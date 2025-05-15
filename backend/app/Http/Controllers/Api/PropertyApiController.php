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
    
    public function index1()
    {
        $user_id = Auth::id();

        $properties = Property::with(['kostDetail', 'homestayDetail', 'province', 'city', 'district', 'subdistrict'])
            ->where('isDeleted', false)
            ->latest()
            ->paginate(10);

        return response()->json($properties);
    }

    /**
     * Display a listing of all properties for the authenticated user, including deleted ones.
     *
     * @return \Illuminate\Http\JsonResponse
     */
    public function getAllProperties()
    {
        $user_id = Auth::id();

        $properties = Property::with(['kostDetail', 'homestayDetail', 'province', 'city', 'district', 'subdistrict'])
            ->where('user_id', $user_id)
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
            'latitude' => 'nullable|numeric|between:-90,90', // Tambahkan validasi range
            'longitude' => 'nullable|numeric|between:-180,180', // Tambahkan validasi range
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

        // Validasi tambahan untuk latitude dan longitude
        if ($request->has('latitude') && ($request->latitude < -90 || $request->latitude > 90)) {
            return response()->json([
                'message' => 'Nilai latitude tidak valid. Harus antara -90 dan 90.',
                'errors' => ['latitude' => ['Nilai latitude tidak valid. Harus antara -90 dan 90.']]
            ], 422);
        }

        if ($request->has('longitude') && ($request->longitude < -180 || $request->longitude > 180)) {
            return response()->json([
                'message' => 'Nilai longitude tidak valid. Harus antara -180 dan 180.',
                'errors' => ['longitude' => ['Nilai longitude tidak valid. Harus antara -180 dan 180.']]
            ], 422);
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
                'available_rooms' => $request->property_type_id == 1 ? $request->available_rooms : 0,
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

            return response()->json([
                'message' => 'Properti berhasil dibuat',
                'data' => $property
            ], 201);
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
     * Update the specified property in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  int  $id
     * @return \Illuminate\Http\JsonResponse
     */
    public function update(Request $request, $id)
    {
        $property = Property::where('user_id', Auth::id())
            ->findOrFail($id);

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
            'latitude' => 'nullable|numeric|between:-90,90',
            'longitude' => 'nullable|numeric|between:-180,180',
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

        // Validasi tambahan untuk latitude dan longitude
        if ($request->has('latitude') && ($request->latitude < -90 || $request->latitude > 90)) {
            return response()->json([
                'message' => 'Nilai latitude tidak valid. Harus antara -90 dan 90.',
                'errors' => ['latitude' => ['Nilai latitude tidak valid. Harus antara -90 dan 90.']]
            ], 422);
        }

        if ($request->has('longitude') && ($request->longitude < -180 || $request->longitude > 180)) {
            return response()->json([
                'message' => 'Nilai longitude tidak valid. Harus antara -180 dan 180.',
                'errors' => ['longitude' => ['Nilai longitude tidak valid. Harus antara -180 dan 180.']]
            ], 422);
        }

        DB::beginTransaction();
        try {
            // Upload image if present
            $imagePath = $property->image;
            if ($request->hasFile('image')) {
                // Delete old image if exists
                if ($imagePath) {
                    Storage::disk('public')->delete($imagePath);
                }
                // Store new image
                $imagePath = $request->file('image')->store('properties', 'public');
            }

            // Update property fields
            $property->update([
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
                'available_rooms' => $request->property_type_id == 1 ? $request->available_rooms : 0,
                'rules' => $request->rules,
            ]);

            // Update property type specific details
            if ($request->property_type_id == 1) { // Kost
                // Create or update Kost detail
                $kostDetail = $property->kostDetail ?? new KostDetail();
                $kostDetail->property_id = $property->id;
                $kostDetail->kost_type = $request->kost_type;
                $kostDetail->total_rooms = $request->total_rooms;
                $kostDetail->available_rooms = $request->available_rooms;
                $kostDetail->meal_included = $request->meal_included ?? false;
                $kostDetail->laundry_included = $request->laundry_included ?? false;
                $kostDetail->rules = $request->rules ?? '';
                $kostDetail->save();
            } elseif ($request->property_type_id == 2) { // Homestay
                // Create or update Homestay detail
                $homestayDetail = $property->homestayDetail ?? new HomestayDetail();
                $homestayDetail->property_id = $property->id;
                $homestayDetail->total_units = $request->total_units;
                $homestayDetail->available_units = $request->available_units;
                $homestayDetail->minimum_stay = $request->minimum_stay;
                $homestayDetail->maximum_guest = $request->maximum_guest;
                $homestayDetail->checkin_time = $request->checkin_time;
                $homestayDetail->checkout_time = $request->checkout_time;
                $homestayDetail->save();
            }

            DB::commit();

            return response()->json([
                'message' => 'Properti berhasil diperbarui',
                'data' => $property
            ], 200);
        } catch (\Exception $e) {
            DB::rollBack();
            // Handle image rollback if failed
            if (isset($imagePath)) {
                Storage::disk('public')->delete($imagePath);
            }
            return response()->json(['message' => 'Gagal memperbarui properti: ' . $e->getMessage()], 500);
        }
    }

    /**
     * Deactivate the specified property (soft delete).
     *
     * @param  int  $id
     * @return \Illuminate\Http\JsonResponse
     */
    public function deactivate($id)
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

    /**
     * Reactivate a previously deactivated property.
     *
     * @param  int  $id
     * @return \Illuminate\Http\JsonResponse
     */
    public function reactivate($id)
    {
        $property = Property::where('user_id', Auth::id())
            ->where('isDeleted', true)
            ->findOrFail($id);

        try {
            $property->update(['isDeleted' => false]);
            return response()->json(['message' => 'Properti berhasil diaktifkan kembali']);
        } catch (\Exception $e) {
            return response()->json(['message' => 'Gagal mengaktifkan properti: ' . $e->getMessage()], 500);
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
            $property = Property::with([
                'kostDetail', 
                'homestayDetail', 
                'propertyType',
                'province', 
                'city', 
                'district', 
                'subdistrict'
            ])->findOrFail($id);

            // Pastikan pengguna memiliki akses ke properti ini
            if ($property->user_id != Auth::id()) {
                return response()->json([
                    'success' => false,
                    'message' => 'Anda tidak memiliki akses ke properti ini'
                ], 403);
            }

            return response()->json([
                'success' => true,
                'data' => $property
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Gagal memuat detail properti: ' . $e->getMessage()
            ], 500);
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
