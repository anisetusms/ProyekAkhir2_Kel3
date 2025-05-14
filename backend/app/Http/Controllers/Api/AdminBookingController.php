<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Booking;
use App\Models\BookingRoom;
use App\Models\Property;
use App\Models\Room;
use Carbon\Carbon;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\Notification;
use App\Models\Notification as NotificationModel;

class AdminBookingController extends Controller
{
    /**
     * Get all bookings for properties owned by the authenticated user
     * 
     * @return \Illuminate\Http\JsonResponse
     */
    public function index()
    {
        try {
            // Get all properties owned by the authenticated user
            $propertyIds = Property::where('user_id', Auth::id())->pluck('id');

            // Get all bookings for these properties
            $bookings = Booking::whereIn('property_id', $propertyIds)
                ->with(['property:id,name,address,user_id', 'rooms:id,room_number,room_type,price'])
                ->orderBy('created_at', 'desc')
                ->get();

            return response()->json([
                'status' => 'success',
                'data' => $bookings
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'status' => 'error',
                'message' => 'Gagal memuat daftar booking',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Get booking details
     * 
     * @param int $id
     * @return \Illuminate\Http\JsonResponse
     */
    public function show($id)
    {
        try {
            // Get all properties owned by the authenticated user
            $propertyIds = Property::where('user_id', Auth::id())->pluck('id');

            // Get the booking if it belongs to one of the user's properties
            $booking = Booking::whereIn('property_id', $propertyIds)
                ->with([
                    'property:id,name,address,user_id,property_type_id',
                    'property.propertyType:id,name',
                    'rooms:id,room_number,room_type,price',
                    // Removed customer relationship
                ])
                ->findOrFail($id);

            return response()->json([
                'status' => 'success',
                'data' => $booking
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'status' => 'error',
                'message' => 'Gagal memuat detail booking',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Confirm a booking
     * 
     * @param int $id
     * @return \Illuminate\Http\JsonResponse
     */
    public function confirm($id)
    {
        try {
            // Get all properties owned by the authenticated user
            $propertyIds = Property::where('user_id', Auth::id())->pluck('id');

            // Get the booking if it belongs to one of the user's properties
            $booking = Booking::whereIn('property_id', $propertyIds)
                ->findOrFail($id);

            // Check if booking is in a valid state to be confirmed
            if ($booking->status !== 'pending') {
                return response()->json([
                    'status' => 'error',
                    'message' => 'Booking tidak dapat dikonfirmasi karena status saat ini adalah ' . $booking->status
                ], 400);
            }

            DB::beginTransaction();

            // Update booking status
            $booking->update(['status' => 'confirmed']);

            // Create notification for tenant
            $this->createBookingStatusNotification($booking, 'confirmed');

            DB::commit();

            return response()->json([
                'status' => 'success',
                'message' => 'Booking berhasil dikonfirmasi',
                'data' => $booking
            ]);
        } catch (\Exception $e) {
            DB::rollBack();
            return response()->json([
                'status' => 'error',
                'message' => 'Gagal mengkonfirmasi booking',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Reject a booking
     * 
     * @param int $id
     * @return \Illuminate\Http\JsonResponse
     */
    public function reject($id)
    {
        try {
            // Get all properties owned by the authenticated user
            $propertyIds = Property::where('user_id', Auth::id())->pluck('id');

            // Get the booking if it belongs to one of the user's properties
            $booking = Booking::whereIn('property_id', $propertyIds)
                ->with('rooms')
                ->findOrFail($id);

            // Check if booking is in a valid state to be rejected
            if ($booking->status !== 'pending') {
                return response()->json([
                    'status' => 'error',
                    'message' => 'Booking tidak dapat ditolak karena status saat ini adalah ' . $booking->status
                ], 400);
            }

            DB::beginTransaction();

            // Update booking status
            $booking->update(['status' => 'cancelled']);

            // Return room availability
            if ($booking->rooms->isNotEmpty()) {
                Room::whereIn('id', $booking->rooms->pluck('id'))
                    ->update(['is_available' => true]);
            }

            // Return property availability
            DB::table('property_availabilities')
                ->where('booking_id', $booking->id)
                ->update(['status' => 'available', 'booking_id' => null]);

            // Create notification for tenant
            $this->createBookingStatusNotification($booking, 'rejected');

            DB::commit();

            return response()->json([
                'status' => 'success',
                'message' => 'Booking berhasil ditolak',
                'data' => $booking
            ]);
        } catch (\Exception $e) {
            DB::rollBack();
            return response()->json([
                'status' => 'error',
                'message' => 'Gagal menolak booking',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Complete a booking
     * 
     * @param int $id
     * @return \Illuminate\Http\JsonResponse
     */
    public function complete($id)
    {
        try {
            // Get all properties owned by the authenticated user
            $propertyIds = Property::where('user_id', Auth::id())->pluck('id');

            // Get the booking if it belongs to one of the user's properties
            $booking = Booking::whereIn('property_id', $propertyIds)
                ->with('rooms')
                ->findOrFail($id);

            // Check if booking is in a valid state to be completed
            if ($booking->status !== 'confirmed') {
                return response()->json([
                    'status' => 'error',
                    'message' => 'Booking tidak dapat diselesaikan karena status saat ini adalah ' . $booking->status
                ], 400);
            }

            DB::beginTransaction();

            // Update booking status
            $booking->update(['status' => 'completed']);

            // Return room availability
            if ($booking->rooms->isNotEmpty()) {
                Room::whereIn('id', $booking->rooms->pluck('id'))
                    ->update(['is_available' => true]);
            }

            // Return property availability
            DB::table('property_availabilities')
                ->where('booking_id', $booking->id)
                ->update(['status' => 'available', 'booking_id' => null]);

            // Create notification for tenant
            $this->createBookingStatusNotification($booking, 'completed');

            DB::commit();

            return response()->json([
                'status' => 'success',
                'message' => 'Booking berhasil diselesaikan',
                'data' => $booking
            ]);
        } catch (\Exception $e) {
            DB::rollBack();
            return response()->json([
                'status' => 'error',
                'message' => 'Gagal menyelesaikan booking',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Create notification for tenant about booking status
     * 
     * @param Booking $booking
     * @param string $status
     * @return void
     */
    private function createBookingStatusNotification($booking, $status)
    {
        try {
            // Get property details
            $property = Property::find($booking->property_id);
            if (!$property) {
                return;
            }

            $propertyName = $property->name;
            $checkIn = Carbon::parse($booking->check_in)->format('d M Y');
            $checkOut = Carbon::parse($booking->check_out)->format('d M Y');

            $title = '';
            $message = '';
            $type = '';

            switch ($status) {
                case 'confirmed':
                    $title = 'Booking Dikonfirmasi';
                    $message = "Booking Anda untuk $propertyName dari $checkIn hingga $checkOut telah dikonfirmasi oleh pemilik.";
                    $type = 'booking_confirmed';
                    break;
                case 'rejected':
                    $title = 'Booking Ditolak';
                    $message = "Maaf, booking Anda untuk $propertyName dari $checkIn hingga $checkOut telah ditolak oleh pemilik.";
                    $type = 'booking_rejected';
                    break;
                case 'completed':
                    $title = 'Booking Selesai';
                    $message = "Booking Anda untuk $propertyName dari $checkIn hingga $checkOut telah selesai.";
                    $type = 'booking_completed';
                    break;
                default:
                    return;
            }

            Notification::create([
                'user_id' => $booking->user_id,
                'type' => $type,
                'title' => $title,
                'message' => $message,
                'reference_id' => $booking->id,
                'is_read' => false
            ]);
        } catch (\Exception $e) {
            \Log::error('Error creating tenant notification: ' . $e->getMessage());
        }
    }

    /**
     * Get booking statistics
     * 
     * @return \Illuminate\Http\JsonResponse
     */
    public function statistics()
    {
        try {
            // Get all properties owned by the authenticated user
            $propertyIds = Property::where('user_id', Auth::id())->pluck('id');

            // Get booking statistics
            $totalBookings = Booking::whereIn('property_id', $propertyIds)->count();
            $pendingBookings = Booking::whereIn('property_id', $propertyIds)->where('status', 'pending')->count();
            $confirmedBookings = Booking::whereIn('property_id', $propertyIds)->where('status', 'confirmed')->count();
            $completedBookings = Booking::whereIn('property_id', $propertyIds)->where('status', 'completed')->count();
            $cancelledBookings = Booking::whereIn('property_id', $propertyIds)->where('status', 'cancelled')->count();

            // Get total revenue
            $totalRevenue = Booking::whereIn('property_id', $propertyIds)
                ->whereIn('status', ['confirmed', 'completed'])
                ->sum('total_price');

            // Get recent bookings
            $recentBookings = Booking::whereIn('property_id', $propertyIds)
                ->with('property:id,name')
                ->orderBy('created_at', 'desc')
                ->limit(5)
                ->get();

            return response()->json([
                'status' => 'success',
                'data' => [
                    'total_bookings' => $totalBookings,
                    'pending_bookings' => $pendingBookings,
                    'confirmed_bookings' => $confirmedBookings,
                    'completed_bookings' => $completedBookings,
                    'cancelled_bookings' => $cancelledBookings,
                    'total_revenue' => $totalRevenue,
                    'recent_bookings' => $recentBookings
                ]
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'status' => 'error',
                'message' => 'Gagal memuat statistik booking',
                'error' => $e->getMessage()
            ], 500);
        }
    }
}
