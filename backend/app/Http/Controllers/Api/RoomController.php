<?php

namespace App\Http\Controllers\Api;

use App\Models\Property;
use App\Models\Room;
use App\Models\RoomImage;
use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use Illuminate\Support\Facades\Log;

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
                    $room->main_image_url = $room->images->isNotEmpty() ? url('storage/' . $room->images->first()->image_url) : null;
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
            
            // Ambil kamar dengan relasi
            $room = Room::with(['roomFacilities', 'images'])
                ->where('property_id', $propertyId)
                ->findOrFail($roomId);
            
            // Log untuk debugging
            Log::debug('Room data: ' . json_encode($room->toArray()));
            
            // Jika tidak ada gambar, cek langsung di database
            if ($room->images->isEmpty()) {
                Log::warning('Tidak ada gambar untuk kamar ID: ' . $roomId);
                
                // Cek langsung di database
                $images = RoomImage::where('room_id', $roomId)->get();
                Log::debug('Images dari database langsung: ' . json_encode($images->toArray()));
                
                // Jika ada gambar di database tapi tidak dimuat dalam relasi
                if ($images->isNotEmpty()) {
                    $room->setRelation('images', $images);
                }
            }
            
            // Tambahkan data gambar secara manual ke respons jika perlu
            $responseData = $room->toArray();
            
            // Mengembalikan data kamar beserta fasilitas dan gambar
            return response()->json([
                'success' => true,
                'message' => 'Detail kamar berhasil diambil',
                'data' => $responseData
            ]);
        } catch (\Exception $e) {
            Log::error('Error pada RoomController@show: ' . $e->getMessage());
            return response()->json([
                'success' => false,
                'message' => 'Kamar tidak ditemukan atau terjadi kesalahan.',
                'error' => $e->getMessage()
            ], 500);
        }
    }
}
