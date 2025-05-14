<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Property;
use App\Models\Booking;
use App\Models\User;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;
use Illuminate\Http\JsonResponse;
use Illuminate\Support\Facades\Log;

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
            // Get user data
            $user = User::find($user_id);
            
            // Get property statistics
            $totalProperties = Property::where('user_id', $user_id)->count();
            $activeProperties = Property::where('user_id', $user_id)->where('isDeleted', false)->count();
            $inactiveProperties = Property::where('user_id', $user_id)->where('isDeleted', true)->count();
            
            // Get latest properties
            $latestProperties = Property::with(['kostDetail', 'homestayDetail', 'province', 'city', 'district', 'subdistrict', 'propertyType'])
                ->where('user_id', $user_id)
                ->latest()
                ->take(5)
                ->get();
            
            $response = [
                'user' => [
                    'id' => $user->id,
                    'name' => $user->name,
                    'email' => $user->email,
                    'profile_picture' => $user->profile_picture
                ],
                'total_properties' => $totalProperties,
                'active_properties' => $activeProperties,
                'inactive_properties' => $inactiveProperties,
                'latest_properties' => $latestProperties,
            ];
            
            // Check if Booking model exists and add booking statistics
            if (class_exists('App\Models\Booking')) {
                try {
                    // Get booking statistics
                    $totalBookings = Booking::whereHas('property', function($query) use ($user_id) {
                        $query->where('user_id', $user_id);
                    })->count();
                    
                    $pendingBookings = Booking::whereHas('property', function($query) use ($user_id) {
                        $query->where('user_id', $user_id);
                    })->where('status', 'pending')->count();
                    
                    $confirmedBookings = Booking::whereHas('property', function($query) use ($user_id) {
                        $query->where('user_id', $user_id);
                    })->where('status', 'confirmed')->count();
                    
                    $completedBookings = Booking::whereHas('property', function($query) use ($user_id) {
                        $query->where('user_id', $user_id);
                    })->where('status', 'completed')->count();
                    
                    // Get total revenue
                    $totalRevenue = Booking::whereHas('property', function($query) use ($user_id) {
                        $query->where('user_id', $user_id);
                    })->whereIn('status', ['confirmed', 'completed'])->sum('total_price');
                    
                    // Get recent bookings
                    $recentBookings = Booking::with(['property:id,name,image'])
                        ->whereHas('property', function($query) use ($user_id) {
                            $query->where('user_id', $user_id);
                        })
                        ->latest()
                        ->take(5)
                        ->get()
                        ->map(function($booking) {
                            return [
                                'id' => $booking->id,
                                'guest_name' => $booking->guest_name,
                                'property_name' => $booking->property->name,
                                'property_image' => $booking->property->image,
                                'check_in' => $booking->check_in,
                                'check_out' => $booking->check_out,
                                'total_price' => $booking->total_price,
                                'status' => $booking->status,
                                'created_at' => $booking->created_at
                            ];
                        });
                    
                    $response['total_bookings'] = $totalBookings;
                    $response['pending_bookings'] = $pendingBookings;
                    $response['confirmed_bookings'] = $confirmedBookings;
                    $response['completed_bookings'] = $completedBookings;
                    $response['total_revenue'] = $totalRevenue;
                    $response['recent_bookings'] = $recentBookings;
                } catch (\Exception $e) {
                    // Jika terjadi error saat mengambil data booking, abaikan dan lanjutkan
                    \Log::error('Error fetching booking data: ' . $e->getMessage());
                }
            }
            
            // Check if activities table exists before querying
            if (Schema::hasTable('activities')) {
                try {
                    // Get recent activities
                    $recentActivities = DB::table('activities')
                        ->where('user_id', $user_id)
                        ->orderBy('created_at', 'desc')
                        ->take(5)
                        ->get();
                    
                    $response['recent_activities'] = $recentActivities;
                } catch (\Exception $e) {
                    // Jika terjadi error saat mengambil data aktivitas, abaikan dan lanjutkan
                    \Log::error('Error fetching activities data: ' . $e->getMessage());
                    $response['recent_activities'] = [];
                }
            } else {
                $response['recent_activities'] = [];
            }

            return response()->json($response);
        } catch (\Exception $e) {
            return response()->json(['message' => 'Gagal mengambil data dashboard: ' . $e->getMessage()], 500);
        }
    }
}
