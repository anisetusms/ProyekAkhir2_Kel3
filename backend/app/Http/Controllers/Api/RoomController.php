<?php

namespace App\Http\Controllers\Api;

use App\Models\Property;
use App\Models\Room;
use App\Models\RoomImage;
use Illuminate\Http\Request;
use App\Http\Controllers\Controller;

class RoomController extends Controller
{
    /**
     * Menampilkan daftar kamar untuk penyewa.
     */
    public function index($propertyId)
    {
        try {
            $property = Property::findOrFail($propertyId);

            // Mengambil data kamar beserta gambar utama
            $rooms = $property->rooms()
                ->with([
                    'roomFacilities',
                    'images' => function ($query) {
                        $query->where('is_main', true)->limit(1); // Mengambil gambar utama
                    }
                ])
                ->get();

            // Mengembalikan data kamar beserta gambar utama
            return response()->json([
                'success' => true,
                'data' => $rooms->map(function ($room) {
                    $room->main_image_url = $room->images->isNotEmpty() ? url('storage/room_images/' . $room->images->first()->image_url) : null;
                    return $room;
                })
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Data kamar tidak ditemukan',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Menampilkan detail kamar untuk penyewa.
     */
    public function show($propertyId, $roomId)
    {
        try {
            $property = Property::findOrFail($propertyId);
            $room = $property->rooms()
                ->with(['roomFacilities', 'images']) // Mengambil fasilitas dan gambar
                ->findOrFail($roomId); // Menampilkan detail kamar berdasarkan ID

            // Mengembalikan data kamar beserta fasilitas dan gambar
            return response()->json([
                'success' => true,
                'data' => $room
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Kamar tidak ditemukan atau terjadi kesalahan.',
                'error' => $e->getMessage()
            ], 500);
        }
    }
}
