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
use Illuminate\Http\JsonResponse;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Auth;
use App\Http\Requests\StorePropertyRequest;


class PropertyController extends Controller
{
    /**
     * Display a listing of the properties.
     *
     * @return \Illuminate\View\View
     */
    public function index()
    {
        $user_id = Auth::id();

        // Stats hanya untuk owner yang login
        $stats = DB::select('CALL get_owner_property_stats(?)', [$user_id]);

        // Properti aktif milik owner yang login
        $activeProperties = Property::with(['kostDetail', 'homestayDetail', 'province', 'city', 'district', 'subdistrict'])
            ->where('user_id', $user_id)
            ->where('isDeleted', false)
            ->latest()
            ->paginate(10);

        // Properti nonaktif milik owner yang login
        $inactiveProperties = Property::with(['kostDetail', 'homestayDetail', 'province', 'city', 'district', 'subdistrict'])
            ->where('user_id', $user_id)
            ->where('isDeleted', true)
            ->latest()
            ->paginate(10);

        return view('admin.properties.index', [
            'stats' => $stats[0] ?? null,
            'activeProperties' => $activeProperties,
            'inactiveProperties' => $inactiveProperties,
        ]);
    }

    /**
     * Show the form for creating a new property.
     *
     * @return \Illuminate\View\View
     */
    public function create()
    {
        $provinces = Province::all();
        return view('admin.properties.create', compact('provinces'));
    }

    public function dashboard()
    {
        $user_id = Auth::id();

        $totalProperties = Property::where('user_id', $user_id)->count();
        $activeProperties = Property::where('user_id', $user_id)->count(); // Ganti ini
        $pendingProperties = Property::where('user_id', $user_id)->count(); // Ganti ini
        $latestProperties = Property::where('user_id', $user_id)->latest()->take(5)->get();
        $totalViews = 120; // contoh angka
        $totalMessages = 50; // contoh angka

        return view('admin.properties.dashboard', compact('totalProperties', 'activeProperties', 'pendingProperties', 'latestProperties', 'totalViews', 'totalMessages'));
    }

    public function store(StorePropertyRequest $request)
    {
        DB::beginTransaction();
        try {
            // Upload image
            $imagePath = $request->hasFile('image')
                ? $request->file('image')->store('properties', 'public')
                : null;

            // Create property
            $property = Property::create([
                'name' => $request->name,
                'description' => $request->description,
                'property_type_id' => $request->property_type_id,
                'user_id' => Auth::id(),
                'province_id' => $request->province_id,
                'city_id' => $request->city_id,
                'district_id' => $request->district_id,
                'subdistrict_id' => $request->subdistrict_id,
                'price' => $request->price,
                'address' => $request->address,
                'latitude' => $request->latitude,
                'longitude' => $request->longitude,
                'image' => $imagePath,
                'capacity' => $request->capacity,
                'available_rooms' => $request->property_type_id == 1 ? $request->available_rooms : 0, // Tambahkan nilai untuk available_rooms
                'rules' => $request->rules,
                'isDeleted' => false
            ]);

            // Create property type specific details
            if ($request->property_type_id == 1) { // Kost
                KostDetail::create([
                    'property_id' => $property->id,
                    'kost_type' => $request->kost_type,
                    'total_rooms' => $request->total_rooms,
                    'available_rooms' => $request->available_rooms,
                    'meal_included' => $request->meal_included ?? false,
                    'laundry_included' => $request->laundry_included ?? false,
                    'rules' => $request->rules ?? ''
                ]);
            } else { // Homestay
                HomestayDetail::create([
                    'property_id' => $property->id,
                    'total_units' => $request->total_units,
                    'available_units' => $request->available_units,
                    'minimum_stay' => $request->minimum_stay,
                    'maximum_guest' => $request->maximum_guest,
                    'checkin_time' => $request->checkin_time,
                    'checkout_time' => $request->checkout_time
                ]);
            }

            DB::commit();

            return redirect()->route('admin.properties.index');
        } catch (\Exception $e) {
            DB::rollBack();

            // Delete image if upload failed
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
        $property = Property::with('rooms')->findOrFail($id);

        $totalRooms = $property->rooms->count();
        $availableRooms = $property->rooms->where('is_available', true)->count();

        $availablePercentage = $totalRooms > 0
            ? ($availableRooms / $totalRooms) * 100
            : 0;

        return view('admin.properties.show', compact(
            'property',
            'totalRooms',
            'availableRooms',
            'availablePercentage'
        ));
    }



    /**
     * Show the form for editing the specified property.
     *
     * @param  int  $id
     * @return \Illuminate\View\View
     */
    public function edit($id)
    {
        $property = Property::where('isDeleted', false)->findOrFail($id);

        $provinces = Province::all();
        $cities = City::where('prov_id', $property->province_id)->get();
        $districts = District::where('city_id', $property->city_id)->get();
        $subdistricts = Subdistrict::where('dis_id', $property->district_id)->get();

        // Mengambil detail sesuai jenis properti
        $detail = null;
        if ($property->property_type_id == 1) { // Kost
            $detail = KostDetail::where('property_id', $id)->first();
        } elseif ($property->property_type_id == 2) { // Homestay
            $detail = HomestayDetail::where('property_id', $id)->first();
        }

        return view('admin.properties.edit', compact('property', 'provinces', 'cities', 'districts', 'subdistricts', 'detail'));
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

    public function getCities($provinceId): JsonResponse
    {
        try {
            $cities = DB::select('CALL getCities(?)', [$provinceId]);
            return response()->json($cities);
        } catch (\Exception $e) {
            return response()->json([
                'error' => 'Failed to load cities',
                'details' => $e->getMessage()
            ], 500);
        }
    }

    public function getDistricts($cityId): JsonResponse
    {
        try {
            $districts = DB::select('CALL getDistricts(?)', [$cityId]);
            return response()->json($districts);
        } catch (\Exception $e) {
            return response()->json([
                'error' => 'Failed to load districts',
                'details' => $e->getMessage()
            ], 500);
        }
    }

    public function getSubdistricts($districtId): JsonResponse
    {
        try {
            $subdistricts = DB::select('CALL getSubdistricts(?)', [$districtId]);
            return response()->json($subdistricts);
        } catch (\Exception $e) {
            return response()->json([
                'error' => 'Failed to load subdistricts',
                'details' => $e->getMessage()
            ], 500);
        }
    }
}
