<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Property;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\DB;
use Illuminate\Http\JsonResponse; // Tambahkan import JsonResponse

class DashboardApiController extends Controller
{
    /**
     * Display the dashboard statistics for the authenticated user.
     *
     * @return \Illuminate\Http\JsonResponse
     */
    public function index()
    {
        $user_id = Auth::id();

        try {
            $totalProperties = Property::where('user_id', $user_id)->count();
            $activeProperties = Property::where('user_id', $user_id)->where('isDeleted', false)->count();
            $inactiveProperties = Property::where('user_id', $user_id)->where('isDeleted', true)->count();
            $latestProperties = Property::with(['kostDetail', 'homestayDetail', 'province', 'city', 'district', 'subdistrict'])
                ->where('user_id', $user_id)
                ->latest()
                ->take(5)
                ->get();

            // Hapus bagian ini
            // $totalViews = DB::table('property_views')
            //     ->join('properties', 'property_views.property_id', '=', 'properties.id')
            //     ->where('properties.user_id', $user_id)
            //     ->count();

            // $totalMessages = DB::table('messages')
            //     ->join('properties', 'messages.property_id', '=', 'properties.id')
            //     ->where('properties.user_id', $user_id)
            //     ->count();

            return response()->json([
                'total_properties' => $totalProperties,
                'active_properties' => $activeProperties,
                'inactive_properties' => $inactiveProperties,
                'latest_properties' => $latestProperties,
                // Hapus ini juga
                // 'total_views' => $totalViews,
                // 'total_messages' => $totalMessages,
            ]);
        } catch (\Exception $e) {
            return response()->json(['message' => 'Gagal mengambil data dashboard: ' . $e->getMessage()], 500);
        }
    }
}
