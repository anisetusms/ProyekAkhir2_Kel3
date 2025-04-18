<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use App\Models\Property;
use App\Models\KostDetail;
use App\Models\HomestayDetail;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\DB;

class PropertyApiController extends Controller
{
    /**
     * Get list of properties
     */
    public function index(Request $request)
    {
        $user = Auth::user();
        
        $query = Property::with(['kostDetail', 'homestayDetail', 'province', 'city', 'district', 'subdistrict'])
            ->where('user_id', $user->id);
            
        if ($request->has('isDeleted')) {
            $query->where('isDeleted', $request->isDeleted);
        }
        
        $properties = $query->latest()->paginate($request->perPage ?? 10);
        
        return response()->json([
            'success' => true,
            'data' => $properties
        ]);
    }

    /**
     * Get property details
     */
    public function show($id)
    {
        $property = Property::with(['kostDetail', 'homestayDetail', 'rooms', 'province', 'city', 'district', 'subdistrict'])
            ->where('user_id', Auth::id())
            ->findOrFail($id);
            
        $totalRooms = $property->rooms->count();
        $availableRooms = $property->rooms->where('is_available', true)->count();
        $availablePercentage = $totalRooms > 0 ? ($availableRooms / $totalRooms) * 100 : 0;
        
        return response()->json([
            'success' => true,
            'data' => [
                'property' => $property,
                'stats' => [
                    'total_rooms' => $totalRooms,
                    'available_rooms' => $availableRooms,
                    'available_percentage' => $availablePercentage
                ]
            ]
        ]);
    }

    /**
     * Create new property
     */
    public function store(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'name' => 'required|string|max:255',
            'description' => 'required|string',
            'property_type_id' => 'required|in:1,2',
            'province_id' => 'required|exists:provinces,id',
            'city_id' => 'required|exists:cities,id',
            'district_id' => 'required|exists:districts,id',
            'subdistrict_id' => 'required|exists:subdistricts,id',
            'price' => 'required|numeric|min:0',
            'address' => 'required|string',
            'latitude' => 'nullable|numeric',
            'longitude' => 'nullable|numeric',
            'image' => 'nullable|image|mimes:jpeg,png,jpg,gif|max:2048',
            'capacity' => 'required|integer|min:1',
            'available_rooms' => 'required_if:property_type_id,1|integer|min:0',
            'rules' => 'nullable|string',
            // Kost specific
            'kost_type' => 'required_if:property_type_id,1|in:putra,putri,campur',
            'total_rooms' => 'required_if:property_type_id,1|integer|min:1',
            'meal_included' => 'nullable|boolean',
            'laundry_included' => 'nullable|boolean',
            // Homestay specific
            'total_units' => 'required_if:property_type_id,2|integer|min:1',
            'available_units' => 'required_if:property_type_id,2|integer|min:0',
            'minimum_stay' => 'required_if:property_type_id,2|integer|min:1',
            'maximum_guest' => 'required_if:property_type_id,2|integer|min:1',
            'checkin_time' => 'required_if:property_type_id,2|date_format:H:i',
            'checkout_time' => 'required_if:property_type_id,2|date_format:H:i',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'errors' => $validator->errors()
            ], 422);
        }

        try {
            // Handle image upload
            $imagePath = null;
            if ($request->hasFile('image')) {
                $imagePath = $request->file('image')->store('properties', 'public');
            }

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
                'isDeleted' => false
            ]);

            // Create property type specific details
            if ($request->property_type_id == 1) {
                KostDetail::create([
                    'property_id' => $property->id,
                    'kost_type' => $request->kost_type,
                    'total_rooms' => $request->total_rooms,
                    'available_rooms' => $request->available_rooms,
                    'meal_included' => $request->meal_included ?? false,
                    'laundry_included' => $request->laundry_included ?? false,
                    'rules' => $request->rules ?? ''
                ]);
            } else {
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

            return response()->json([
                'success' => true,
                'data' => $property->load(['kostDetail', 'homestayDetail'])
            ], 201);

        } catch (\Exception $e) {
            // Delete image if upload failed
            if (isset($imagePath)) {
                Storage::disk('public')->delete($imagePath);
            }

            return response()->json([
                'success' => false,
                'message' => 'Failed to create property: ' . $e->getMessage()
            ], 500);
        }
    }

    /**
     * Update property
     */
    public function update(Request $request, $id)
    {
        $property = Property::where('user_id', Auth::id())
            ->where('isDeleted', false)
            ->findOrFail($id);

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
                'errors' => $validator->errors()
            ], 422);
        }

        try {
            // Update image if provided
            $imagePath = $property->image;
            if ($request->hasFile('image')) {
                // Delete old image if exists
                if ($imagePath) {
                    Storage::disk('public')->delete($imagePath);
                }
                $imagePath = $request->file('image')->store('properties', 'public');
            }

            // Update property
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

            // Update detail if exists
            if ($property->kostDetail) {
                $property->kostDetail->update($request->only([
                    'kost_type', 'total_rooms', 'available_rooms', 
                    'meal_included', 'laundry_included', 'rules'
                ]));
            } elseif ($property->homestayDetail) {
                $property->homestayDetail->update($request->only([
                    'total_units', 'available_units', 'minimum_stay',
                    'maximum_guest', 'checkin_time', 'checkout_time'
                ]));
            }

            return response()->json([
                'success' => true,
                'data' => $property->fresh(['kostDetail', 'homestayDetail'])
            ]);

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Failed to update property: ' . $e->getMessage()
            ], 500);
        }
    }

    /**
     * Delete (soft delete) property
     */
    public function destroy($id)
    {
        $property = Property::where('user_id', Auth::id())
            ->where('isDeleted', false)
            ->findOrFail($id);

        try {
            $property->update(['isDeleted' => true]);
            
            return response()->json([
                'success' => true,
                'message' => 'Property deleted successfully'
            ]);
            
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Failed to delete property: ' . $e->getMessage()
            ], 500);
        }
    }

    /**
     * Get dashboard data
     */
    public function dashboard()
    {
        $user = Auth::user();
        
        $data = [
            'total_properties' => Property::where('user_id', $user->id)->count(),
            'active_properties' => Property::where('user_id', $user->id)
                ->where('isDeleted', false)
                ->count(),
            'latest_properties' => Property::where('user_id', $user->id)
                ->latest()
                ->take(5)
                ->get(),
            // Add more stats as needed
        ];
        
        return response()->json([
            'success' => true,
            'data' => $data
        ]);
    }

    // Location methods (reuse from PropertyController)
    public function getCities($provinceId)
    {
        try {
            $cities = DB::select('CALL getCities(?)', [$provinceId]);
            return response()->json([
                'success' => true,
                'data' => $cities
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Failed to load cities',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    public function getDistricts($cityId)
    {
        try {
            $districts = DB::select('CALL getDistricts(?)', [$cityId]);
            return response()->json([
                'success' => true,
                'data' => $districts
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Failed to load districts',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    public function getSubdistricts($districtId)
    {
        try {
            $subdistricts = DB::select('CALL getSubdistricts(?)', [$districtId]);
            return response()->json([
                'success' => true,
                'data' => $subdistricts
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Failed to load subdistricts',
                'error' => $e->getMessage()
            ], 500);
        }
    }
}