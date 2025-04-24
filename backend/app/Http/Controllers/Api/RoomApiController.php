<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller; 
use App\Models\Property;
use App\Models\Room;
use App\Models\RoomFacility;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class RoomApiController extends Controller
{
    /**
     * Display a listing of rooms for a property.
     *
     * @param  int  $propertyId
     * @return \Illuminate\Http\JsonResponse
     */
    public function index($propertyId)
    {
        try {
            $property = Property::where('isDeleted', false)->find($propertyId);

            if (!$property) {
                return response()->json([
                    'success' => false,
                    'message' => 'Properti tidak ditemukan'
                ], 404);
            }

            $rooms = $property->rooms()
                ->with('facilities')
                ->where('is_available', true)
                ->paginate(10);

            return response()->json([
                'success' => true,
                'message' => 'Daftar kamar berhasil diambil',
                'data' => $rooms
            ]);

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Gagal mengambil daftar kamar',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Store a newly created room in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  int  $propertyId
     * @return \Illuminate\Http\JsonResponse
     */
    public function store(Request $request, $propertyId)
    {
        $property = Property::where('isDeleted', false)->find($propertyId);

        if (!$property) {
            return response()->json([
                'success' => false,
                'message' => 'Properti tidak ditemukan'
            ], 404);
        }

        $validator = Validator::make($request->all(), [
            'room_type' => 'required|string|max:100',
            'room_number' => 'required|string|max:50',
            'price' => 'required|numeric|min:0',
            'size' => 'nullable|string|max:50',
            'capacity' => 'required|integer|min:1',
            'is_available' => 'sometimes|boolean',
            'description' => 'nullable|string',
            'facilities' => 'sometimes|array',
            'facilities.*' => 'string|max:255',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'message' => 'Validasi gagal',
                'errors' => $validator->errors()
            ], 422);
        }

        try {
            // Buat kamar
            $room = Room::create([
                'property_id' => $propertyId,
                'room_type' => $request->room_type,
                'room_number' => $request->room_number,
                'price' => $request->price,
                'size' => $request->size,
                'capacity' => $request->capacity,
                'is_available' => $request->is_available ?? true,
                'description' => $request->description,
            ]);

            // Tambahkan fasilitas jika ada
            if ($request->has('facilities')) {
                foreach ($request->facilities as $facility) {
                    RoomFacility::create([
                        'room_id' => $room->id,
                        'facility_name' => $facility
                    ]);
                }
            }

            // Update jumlah kamar tersedia di properti
            $this->updateAvailableRooms($property);

            return response()->json([
                'success' => true,
                'message' => 'Kamar berhasil ditambahkan',
                'data' => $room->load('facilities')
            ], 201);

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Gagal menambahkan kamar',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Display the specified room.
     *
     * @param  int  $propertyId
     * @param  int  $roomId
     * @return \Illuminate\Http\JsonResponse
     */
    public function show($propertyId, $roomId)
    {
        try {
            $room = Room::with('facilities')
                ->where('property_id', $propertyId)
                ->find($roomId);

            if (!$room) {
                return response()->json([
                    'success' => false,
                    'message' => 'Kamar tidak ditemukan'
                ], 404);
            }

            return response()->json([
                'success' => true,
                'message' => 'Detail kamar berhasil diambil',
                'data' => $room
            ]);

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Gagal mengambil detail kamar',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Update the specified room in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  int  $propertyId
     * @param  int  $roomId
     * @return \Illuminate\Http\JsonResponse
     */
    public function update(Request $request, $propertyId, $roomId)
    {
        $room = Room::where('property_id', $propertyId)->find($roomId);

        if (!$room) {
            return response()->json([
                'success' => false,
                'message' => 'Kamar tidak ditemukan'
            ], 404);
        }

        $validator = Validator::make($request->all(), [
            'room_type' => 'sometimes|string|max:100',
            'room_number' => 'sometimes|string|max:50',
            'price' => 'sometimes|numeric|min:0',
            'size' => 'nullable|string|max:50',
            'capacity' => 'sometimes|integer|min:1',
            'is_available' => 'sometimes|boolean',
            'description' => 'nullable|string',
            'facilities' => 'sometimes|array',
            'facilities.*' => 'string|max:255',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'message' => 'Validasi gagal',
                'errors' => $validator->errors()
            ], 422);
        }

        try {
            // Update kamar
            $room->update([
                'room_type' => $request->room_type ?? $room->room_type,
                'room_number' => $request->room_number ?? $room->room_number,
                'price' => $request->price ?? $room->price,
                'size' => $request->size ?? $room->size,
                'capacity' => $request->capacity ?? $room->capacity,
                'is_available' => $request->has('is_available') ? $request->is_available : $room->is_available,
                'description' => $request->description ?? $room->description,
            ]);

            // Update fasilitas jika ada
            if ($request->has('facilities')) {
                $room->facilities()->delete();
                foreach ($request->facilities as $facility) {
                    RoomFacility::create([
                        'room_id' => $room->id,
                        'facility_name' => $facility
                    ]);
                }
            }

            // Update jumlah kamar tersedia di properti
            $property = Property::find($propertyId);
            $this->updateAvailableRooms($property);

            return response()->json([
                'success' => true,
                'message' => 'Kamar berhasil diperbarui',
                'data' => $room->load('facilities')
            ]);

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Gagal memperbarui kamar',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Remove the specified room from storage.
     *
     * @param  int  $propertyId
     * @param  int  $roomId
     * @return \Illuminate\Http\JsonResponse
     */
    public function destroy($propertyId, $roomId)
    {
        try {
            $room = Room::where('property_id', $propertyId)->find($roomId);

            if (!$room) {
                return response()->json([
                    'success' => false,
                    'message' => 'Kamar tidak ditemukan'
                ], 404);
            }

            $room->delete();

            // Update jumlah kamar tersedia di properti
            $property = Property::find($propertyId);
            $this->updateAvailableRooms($property);

            return response()->json([
                'success' => true,
                'message' => 'Kamar berhasil dihapus'
            ]);

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Gagal menghapus kamar',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Update available rooms count in property
     *
     * @param  Property  $property
     * @return void
     */
    private function updateAvailableRooms(Property $property)
    {
        if ($property->property_type === 'kost') {
            $availableRooms = $property->rooms()->where('is_available', true)->count();
            $property->detail->update(['available_rooms' => $availableRooms]);
        } else {
            $availableUnits = $property->rooms()->where('is_available', true)->count();
            $property->detail->update(['available_units' => $availableUnits]);
        }
    }
}

