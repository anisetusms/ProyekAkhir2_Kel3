<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use App\Models\Property;
use App\Models\KostDetail;
use App\Models\HomestayDetail;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\Storage;

class PropertyController extends Controller
{
    /**
     * Display a listing of the properties.
     *
     * @return \Illuminate\Http\JsonResponse
     */
    public function index()
    {
        try {
            $properties = Property::with(['detail', 'rooms.facilities', 'province', 'city', 'district', 'subdistrict'])
                ->where('isDeleted', false)
                ->paginate(10);

            return response()->json([
                'success' => true,
                'message' => 'Data properti berhasil diambil',
                'data' => $properties
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Gagal mengambil data properti',
                'error' => $e->getMessage()
            ], 500);
        }
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
            'description' => 'required|string',
            'property_type' => 'required|in:kost,homestay',
            'user_id' => 'required|exists:users,id',
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
            return response()->json([
                'success' => false,
                'message' => 'Validasi gagal',
                'errors' => $validator->errors()
            ], 422);
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
                    'available_rooms' => $request->total_rooms, // Awalnya semua kamar available
                    'rules' => $request->rules,
                    'meal_included' => $request->meal_included ?? false,
                    'laundry_included' => $request->laundry_included ?? false,
                ]);
            } else {
                HomestayDetail::create([
                    'property_id' => $property->id,
                    'total_units' => $request->total_units,
                    'available_units' => $request->total_units, // Awalnya semua unit available
                    'minimum_stay' => $request->minimum_stay,
                    'maximum_guest' => $request->maximum_guest,
                    'checkin_time' => $request->checkin_time,
                    'checkout_time' => $request->checkout_time,
                ]);
            }

            return response()->json([
                'success' => true,
                'message' => 'Properti berhasil dibuat',
                'data' => $property->load('detail')
            ], 201);

        } catch (\Exception $e) {
            // Hapus gambar jika upload gagal
            if (isset($imagePath)) { // Perbaikan di sini
                Storage::disk('public')->delete($imagePath);
            }            

            return response()->json([
                'success' => false,
                'message' => 'Gagal membuat properti',
                'error' => $e->getMessage()
            ], 500);
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
        try {
            $property = Property::with(['detail', 'rooms.facilities', 'province', 'city', 'district', 'subdistrict'])
                ->where('isDeleted', false)
                ->find($id);

            if (!$property) {
                return response()->json([
                    'success' => false,
                    'message' => 'Properti tidak ditemukan'
                ], 404);
            }

            return response()->json([
                'success' => true,
                'message' => 'Detail properti berhasil diambil',
                'data' => $property
            ]);

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Gagal mengambil detail properti',
                'error' => $e->getMessage()
            ], 500);
        }
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
        $property = Property::where('isDeleted', false)->find($id);

        if (!$property) {
            return response()->json([
                'success' => false,
                'message' => 'Properti tidak ditemukan'
            ], 404);
        }

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
            return response()->json([
                'success' => false,
                'message' => 'Validasi gagal',
                'errors' => $validator->errors()
            ], 422);
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

            return response()->json([
                'success' => true,
                'message' => 'Properti berhasil diperbarui',
                'data' => $property->load('detail')
            ]);

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Gagal memperbarui properti',
                'error' => $e->getMessage()
            ], 500);
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
        try {
            $property = Property::where('isDeleted', false)->find($id);

            if (!$property) {
                return response()->json([
                    'success' => false,
                    'message' => 'Properti tidak ditemukan'
                ], 404);
            }

            $property->update(['isDeleted' => true]);

            return response()->json([
                'success' => true,
                'message' => 'Properti berhasil dinonaktifkan'
            ]);

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Gagal menonaktifkan properti',
                'error' => $e->getMessage()
            ], 500);
        }
    }
}