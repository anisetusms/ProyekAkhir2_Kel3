<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Property;
use App\Models\KostDetail;
use App\Models\HomestayDetail;
use App\Models\Province;
use App\Models\City;
use App\Models\District;
use App\Models\Subdistrict;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Facades\Validator;

class PropertyController extends Controller
{
    /**
     * Display a listing of the properties.
     *
     * @return \Illuminate\View\View
     */
    public function index()
    {
        $properties = Property::with(['detail', 'province', 'city', 'district', 'subdistrict'])
            ->where('isDeleted', false)
            ->latest()
            ->paginate(10);

        return view('admin.properties.index', compact('properties'));
    }

    /**
     * Show the form for creating a new property.
     *
     * @return \Illuminate\View\View
     */
    public function create()
    {
        $provinces = Province::where('status', 1)->get();
        return view('admin.properties.create', compact('provinces'));
    }


    /**
     * Store a newly created property in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\RedirectResponse
     */
    public function store(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'name' => 'required|string|max:255',
            'description' => 'required|string',
            'property_type' => 'required|in:kost,homestay',
            'province_id' => 'required|exists:provinces,id',
            'city_id' => 'required|exists:cities,id',
            'district_id' => 'required|exists:districts,id',
            'subdistrict_id' => 'required|exists:subdistricts,id',
            'price' => 'required|numeric|min:0',
            'address' => 'required|string',
            'latitude' => 'nullable|numeric',
            'longitude' => 'nullable|numeric',
            'image' => 'nullable|image|mimes:jpeg,png,jpg,gif|max:2048',
            'kost_type' => 'required_if:property_type,kost|in:putra,putri,campur',
            'total_rooms' => 'required_if:property_type,kost|integer|min:1',
            'rules' => 'nullable|string',
            'meal_included' => 'nullable|boolean',
            'laundry_included' => 'nullable|boolean',
            'total_units' => 'required_if:property_type,homestay|integer|min:1',
            'minimum_stay' => 'required_if:property_type,homestay|integer|min:1',
            'maximum_guest' => 'required_if:property_type,homestay|integer|min:1',
            'checkin_time' => 'required_if:property_type,homestay|date_format:H:i',
            'checkout_time' => 'required_if:property_type,homestay|date_format:H:i',
        ]);

        if ($validator->fails()) {
            return redirect()->back()
                ->withErrors($validator)
                ->withInput();
        }

        try {
            // Upload gambar jika ada
            $imagePath = null;
            if ($request->hasFile('image')) {
                $imagePath = $request->file('image')->store('properties', 'public');
            }

            // Buat properti
            $property = Property::create([
                'name' => $request->name,
                'description' => $request->description,
                'property_type' => $request->property_type,
                'user_id' => $request->user_id,
                'province_id' => $request->province_id,
                'city_id' => $request->city_id,
                'district_id' => $request->district_id,
                'subdistrict_id' => $request->subdistrict_id,
                'price' => $request->price,
                'address' => $request->address,
                'latitude' => $request->latitude,
                'longitude' => $request->longitude,
                'image' => $imagePath,
            ]);

            // Buat detail sesuai jenis properti
            if ($request->property_type === 'kost') {
                KostDetail::create([
                    'property_id' => $property->id,
                    'kost_type' => $request->kost_type,
                    'total_rooms' => $request->total_rooms,
                    'available_rooms' => $request->total_rooms,
                    'rules' => $request->rules,
                    'meal_included' => $request->meal_included ?? false,
                    'laundry_included' => $request->laundry_included ?? false,
                ]);
            } else {
                HomestayDetail::create([
                    'property_id' => $property->id,
                    'total_units' => $request->total_units,
                    'available_units' => $request->total_units,
                    'minimum_stay' => $request->minimum_stay,
                    'maximum_guest' => $request->maximum_guest,
                    'checkin_time' => $request->checkin_time,
                    'checkout_time' => $request->checkout_time,
                ]);
            }

            return redirect()->route('admin.properties.show', $property->id)
                ->with('success', 'Properti berhasil dibuat');
        } catch (\Exception $e) {
            // Hapus gambar jika upload gagal
            if (isset($imagePath)) {
                Storage::disk('public')->delete($imagePath);
            }

            return redirect()->back()
                ->with('error', 'Gagal membuat properti: ' . $e->getMessage())
                ->withInput();
        }
    }

    /**
     * Display the specified property.
     *
     * @param  int  $id
     * @return \Illuminate\View\View
     */
    public function show($id)
    {
        $property = Property::with(['detail', 'rooms.facilities', 'province', 'city', 'district', 'subdistrict'])
            ->where('isDeleted', false)
            ->findOrFail($id);

        return view('admin.properties.show', compact('property'));
    }

    /**
     * Show the form for editing the specified property.
     *
     * @param  int  $id
     * @return \Illuminate\View\View
     */
    public function edit($id)
    {
        $property = Property::with(['detail'])
            ->where('isDeleted', false)
            ->findOrFail($id);

        $provinces = Province::all();
        $cities = City::where('province_id', $property->province_id)->get();
        $districts = District::where('city_id', $property->city_id)->get();
        $subdistricts = Subdistrict::where('district_id', $property->district_id)->get();

        return view('admin.properties.edit', compact('property', 'provinces', 'cities', 'districts', 'subdistricts'));
    }

    /**
     * Update the specified property in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  int  $id
     * @return \Illuminate\Http\RedirectResponse
     */
    public function update(Request $request, $id)
    {
        $property = Property::where('isDeleted', false)->findOrFail($id);

        $validator = Validator::make($request->all(), [
            'name' => 'sometimes|string|max:255',
            'description' => 'sometimes|string',
            'province_id' => 'sometimes|exists:provinces,id',
            'city_id' => 'sometimes|exists:cities,id',
            'district_id' => 'sometimes|exists:districts,id',
            'subdistrict_id' => 'sometimes|exists:subdistricts,id',
            'price' => 'sometimes|numeric|min:0',
            'address' => 'sometimes|string',
            'latitude' => 'nullable|numeric',
            'longitude' => 'nullable|numeric',
            'image' => 'nullable|image|mimes:jpeg,png,jpg,gif|max:2048',
            'kost_type' => 'sometimes|in:putra,putri,campur',
            'rules' => 'nullable|string',
            'meal_included' => 'nullable|boolean',
            'laundry_included' => 'nullable|boolean',
            'minimum_stay' => 'sometimes|integer|min:1',
            'maximum_guest' => 'sometimes|integer|min:1',
            'checkin_time' => 'sometimes|date_format:H:i',
            'checkout_time' => 'sometimes|date_format:H:i',
        ]);

        if ($validator->fails()) {
            return redirect()->back()
                ->withErrors($validator)
                ->withInput();
        }

        try {
            // Update gambar jika ada
            $imagePath = $property->image;
            if ($request->hasFile('image')) {
                // Hapus gambar lama jika ada
                if ($imagePath) {
                    Storage::disk('public')->delete($imagePath);
                }
                $imagePath = $request->file('image')->store('properties', 'public');
            }

            // Update properti
            $property->update([
                'name' => $request->name ?? $property->name,
                'description' => $request->description ?? $property->description,
                'province_id' => $request->province_id ?? $property->province_id,
                'city_id' => $request->city_id ?? $property->city_id,
                'district_id' => $request->district_id ?? $property->district_id,
                'subdistrict_id' => $request->subdistrict_id ?? $property->subdistrict_id,
                'price' => $request->price ?? $property->price,
                'address' => $request->address ?? $property->address,
                'latitude' => $request->latitude ?? $property->latitude,
                'longitude' => $request->longitude ?? $property->longitude,
                'image' => $imagePath,
            ]);

            // Update detail
            if ($property->detail) {
                $property->detail->update($request->all());
            }

            return redirect()->route('admin.properties.show', $property->id)
                ->with('success', 'Properti berhasil diperbarui');
        } catch (\Exception $e) {
            return redirect()->back()
                ->with('error', 'Gagal memperbarui properti: ' . $e->getMessage())
                ->withInput();
        }
    }

    /**
     * Remove the specified property from storage (soft delete).
     *
     * @param  int  $id
     * @return \Illuminate\Http\RedirectResponse
     */
    public function destroy($id)
    {
        $property = Property::where('isDeleted', false)->findOrFail($id);

        try {
            $property->update(['isDeleted' => true]);

            return redirect()->route('admin.properties.index')
                ->with('success', 'Properti berhasil dinonaktifkan');
        } catch (\Exception $e) {
            return redirect()->back()
                ->with('error', 'Gagal menonaktifkan properti: ' . $e->getMessage());
        }
    }

    public function getCities($provinceId)
    {
        $cities = City::where('prov_id', $provinceId)
            ->orderBy('city_name', 'asc')
            ->get(['id', 'city_name as text']);

        return response()->json($cities);
    }

    // Untuk mendapatkan kecamatan berdasarkan kabupaten/kota
    public function getDistricts($cityId)
    {
        $districts = District::where('city_id', $cityId)
            ->orderBy('dis_name', 'asc')
            ->get(['id', 'dis_name as text']);

        return response()->json($districts);
    }

    // Untuk mendapatkan kelurahan berdasarkan kecamatan
    public function getSubdistricts($districtId)
    {
        $subdistricts = Subdistrict::where('dis_id', $districtId)
            ->orderBy('subdis_name', 'asc')
            ->get(['id', 'subdis_name as text']);

        return response()->json($subdistricts);
    }
}
