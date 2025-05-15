<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\RoomImage;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Log;

class RoomImageController extends Controller
{
    /**
     * Mengambil gambar untuk kamar tertentu.
     */
    public function getByRoomId($roomId)
    {
        try {
            $images = RoomImage::where('room_id', $roomId)->get();
            
            Log::debug('Room images for room ID ' . $roomId . ': ' . json_encode($images));
            
            return response()->json([
                'success' => true,
                'data' => $images
            ]);
        } catch (\Exception $e) {
            Log::error('Error getting room images: ' . $e->getMessage());
            return response()->json([
                'success' => false,
                'message' => 'Gagal mengambil gambar kamar',
                'error' => $e->getMessage()
            ], 500);
        }
    }
}
