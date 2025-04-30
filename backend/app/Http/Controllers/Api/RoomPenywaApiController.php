<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use App\Models\HomestayDetail; // Pastikan ini ada
use App\Models\KostDetail;    // Pastikan ini ada
use App\Models\Property;
use App\Models\Room;
use App\Models\RoomFacility;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Validator;

class RoomPenywaApiController extends Controller
{
    /**
     * Display a listing of the resource.
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
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        //
    }

    /**
     * Display the specified resource.
     */
    public function show(string $id)
    {
        //
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, string $id)
    {
        //
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(string $id)
    {
        //
    }
}
