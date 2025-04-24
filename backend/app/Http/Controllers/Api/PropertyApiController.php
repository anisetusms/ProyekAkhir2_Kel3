<?php

namespace App\Http\Controllers\Api;

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

class PropertyApiController extends Controller
{
    /**
     * Display a listing of the properties for the authenticated user.
     *
     * @return \Illuminate\Http\JsonResponse
     */
    public function index()
    {
        $user_id = Auth::id();

        $properties = Property::with(['kostDetail', 'homestayDetail', 'province', 'city', 'district', 'subdistrict'])
            ->where('user_id', $user_id)
            ->where('isDeleted', false)
            ->latest()
            ->paginate(10);

        return response()->json($properties);
    }

    /**
     * Store a newly created property in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\JsonResponse
     */
    public function store(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'name' => 'required|string|max:255',
            'description' => 'nullable|string',
            'property_type_id' => 'required|integer|exists:property_types,id',
            'province_id' => 'required|integer|exists:provinces,id',
            'city_id' => 'required|integer|exists:cities,id',
            'district_id' => 'required|integer|exists:districts,id',
            'subdistrict_id' => 'required|integer|exists:subdistricts,id',
            'price' => 'required|numeric|min:0',
            'address' => 'required|string',
            'latitude' => 'nullable|numeric',
            'longitude' => 'nullable|numeric',
            'image' => 'nullable|image|mimes:jpeg,png,jpg,gif|max:2048',
            'capacity' => 'nullable|integer|min:1',
            'available_rooms' => 'nullable|integer|min:0',
            'rules' => 'nullable|string',
            'kost_type' => 'nullable|in:putra,putri,campur',
            'total_rooms' => 'nullable|integer|min:1',
            'meal_included' => 'nullable|boolean',
            'laundry_included' => 'nullable|boolean',
            'total_units' => 'nullable|integer|min:1',
            'available_units' => 'nullable|integer|min:0',
            'minimum_stay' => 'nullable|integer|min:1',
            'maximum_guest' => 'nullable|integer|min:1',
            'checkin_time' => 'nullable|date_format:H:i',
            'checkout_time' => 'nullable|date_format:H:i',
        ]);

        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors()], 422);
        }

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
                'isDeleted' => false,
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
                    'rules' => $request->rules ?? '',
                ]);
            } elseif ($request->property_type_id == 2) { // Homestay
                HomestayDetail::create([
                    'property_id' => $property->id,
                    'total_units' => $request->total_units,
                    'available_units' => $request->available_units,
                    'minimum_stay' => $request->minimum_stay,
                    'maximum_guest' => $request->maximum_guest,
                    'checkin_time' => $request->checkin_time,
                    'checkout_time' => $request->checkout_time,
                ]);
            }

            DB::commit();

            return response()->json($property, 201);
        } catch (\Exception $e) {
            DB::rollBack();

            // Delete image if upload failed
            if (isset($imagePath)) {
                Storage::disk('public')->delete($imagePath);
            }

            return response()->json(['message' => 'Gagal membuat properti: ' . $e->getMessage()], 500);
        }
    }

    /**
     * Display the specified property.
     *
     * @param  int  $id
     * @return \Illuminate\Http\JsonResponse
     */
    public function show($id)
    {
        $property = Property::with(['kostDetail', 'homestayDetail', 'province', 'city', 'district', 'subdistrict', 'rooms'])
            ->where('user_id', Auth::id())
            ->where('isDeleted', false)
            ->findOrFail($id);

        return response()->json($property);
    }

    /**
     * Update the specified property in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  int  $id
     * @return \Illuminate\Http\JsonResponse
     */
    public function update(Request $request, $id)
    {
        $property = Property::where('user_id', Auth::id())
            ->where('isDeleted', false)
            ->findOrFail($id);

        $validator = Validator::make($request->all(), [
            'name' => 'sometimes|string|max:255',
            'description' => 'nullable|string',
            'province_id' => 'sometimes|integer|exists:provinces,id',
            'city_id' => 'sometimes|integer|exists:cities,id',
            'district_id' => 'sometimes|integer|exists:districts,id',
            'subdistrict_id' => 'sometimes|integer|exists:subdistricts,id',
            'price' => 'sometimes|numeric|min:0',
            'address' => 'sometimes|string',
            'latitude' => 'nullable|numeric',
            'longitude' => 'nullable|numeric',
            'image' => 'nullable|image|mimes:jpeg,png,jpg,gif|max:2048',
            'capacity' => 'nullable|integer|min:1',
            'available_rooms' => 'nullable|integer|min:0',
            'rules' => 'nullable|string',
            'kost_type' => 'nullable|in:putra,putri,campur',
            'total_rooms' => 'nullable|integer|min:1',
            'meal_included' => 'nullable|boolean',
            'laundry_included' => 'nullable|boolean',
            'total_units' => 'nullable|integer|min:1',
            'available_units' => 'nullable|integer|min:0',
            'minimum_stay' => 'nullable|integer|min:1',
            'maximum_guest' => 'nullable|integer|min:1',
            'checkin_time' => 'nullable|date_format:H:i',
            'checkout_time' => 'nullable|date_format:H:i',
        ]);

        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors()], 422);
        }

        DB::beginTransaction();
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
                'capacity' => $request->capacity ?? $property->capacity,
                'available_rooms' => $request->property_type_id == 1 ? ($request->available_rooms ?? $property->available_rooms) : $property->available_rooms,
                'rules' => $request->rules ?? $property->rules,
            ]);

            // Update detail sesuai jenis properti
            if ($property->property_type_id == 1) { // Kost
                if ($property->kostDetail) {
                    $property->kostDetail->update([
                        'kost_type' => $request->kost_type ?? $property->kostDetail->kost_type,
                        'total_rooms' => $request->total_rooms ?? $property->kostDetail->total_rooms,
                        'available_rooms' => $request->available_rooms ?? $property->kostDetail->available_rooms,
                        'meal_included' => $request->meal_included ?? $property->kostDetail->meal_included,
                        'laundry_included' => $request->laundry_included ?? $property->kostDetail->laundry_included,
                        'rules' => $request->rules ?? $property->kostDetail->rules,
                    ]);
                }
            } elseif ($property->property_type_id == 2) { // Homestay
                if ($property->homestayDetail) {
                    $property->homestayDetail->update([
                        'total_units' => $request->total_units ?? $property->homestayDetail->total_units,
                        'available_units' => $request->available_units ?? $property->homestayDetail->available_units,
                        'minimum_stay' => $request->minimum_stay ?? $property->homestayDetail->minimum_stay,
                        'maximum_guest' => $request->maximum_guest ?? $property->homestayDetail->maximum_guest,
                        'checkin_time' => $request->checkin_time ?? $property->homestayDetail->checkin_time,
                        'checkout_time' => $request->checkout_time ?? $property->homestayDetail->checkout_time,
                    ]);
                }
            }

            DB::commit();

            return response()->json($property, 200);
        } catch (\Exception $e) {
            DB::rollBack();
            return response()->json(['message' => 'Gagal memperbarui properti: ' . $e->getMessage()], 500);
        }
    }

    /**
     * Remove the specified property from storage (soft delete).
     *
     * @param  int  $id
     * @return \Illuminate\Http\JsonResponse
     */
    public function destroy($id)
    {
        $property = Property::where('user_id', Auth::id())
            ->where('isDeleted', false)
            ->findOrFail($id);

        try {
            $property->update(['isDeleted' => true]);
            return response()->json(['message' => 'Properti berhasil dinonaktifkan']);
        } catch (\Exception $e) {
            return response()->json(['message' => 'Gagal menonaktifkan properti: ' . $e->getMessage()], 500);
        }
    }

    public function getProvinces()
    {
        $provinces = Province::all();
        return response()->json($provinces);
    }

    public function getCities($provinceId)
    {
        $cities = City::where('prov_id', $provinceId)->get();
        return response()->json($cities);
    }

    public function getDistricts($cityId)
    {
        $districts = District::where('city_id', $cityId)->get();
        return response()->json($districts);
    }

    public function getSubdistricts($districtId)
    {
        $subdistricts = Subdistrict::where('dis_id', $districtId)->get();
        return response()->json($subdistricts);
    }
}