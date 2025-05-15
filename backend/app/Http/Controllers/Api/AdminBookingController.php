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
use Illuminate\Support\Facades\Log;
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
            Log::error('Error fetching bookings: ' . $e->getMessage());
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
            Log::error('Error fetching booking details: ' . $e->getMessage());
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
            Log::info('Starting booking confirmation process for ID: ' . $id);

            // Get all properties owned by the authenticated user
            $propertyIds = Property::where('user_id', Auth::id())->pluck('id');
            Log::info('User properties: ' . $propertyIds);

            // Get the booking if it belongs to one of the user's properties
            $booking = Booking::whereIn('property_id', $propertyIds)
                ->findOrFail($id);

            Log::info('Found booking: ' . $booking->id . ' with status: ' . $booking->status);

            // Check if booking is in a valid state to be confirmed
            if ($booking->status !== 'pending') {
                Log::warning('Cannot confirm booking: invalid status ' . $booking->status);
                return response()->json([
                    'status' => 'error',
                    'message' => 'Booking tidak dapat dikonfirmasi karena status saat ini adalah ' . $booking->status
                ], 400);
            }

            DB::beginTransaction();
            Log::info('Starting transaction');

            // Update booking status
            $booking->update(['status' => 'confirmed']);
            Log::info('Updated booking status to confirmed');

            try {
                // Create notification for tenant
                $this->createBookingStatusNotification($booking, 'confirmed');
                Log::info('Created notification for tenant');
            } catch (\Exception $notifError) {
                Log::error('Error creating notification: ' . $notifError->getMessage());
                // Continue even if notification fails
            }

            DB::commit();
            Log::info('Transaction committed');

            return response()->json([
                'status' => 'success',
                'message' => 'Booking berhasil dikonfirmasi',
                'data' => $booking
            ]);
        } catch (\Exception $e) {
            DB::rollBack();
            Log::error('Error confirming booking: ' . $e->getMessage());
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
            Log::info('Starting booking rejection process for ID: ' . $id);

            // Get all properties owned by the authenticated user
            $propertyIds = Property::where('user_id', Auth::id())->pluck('id');
            Log::info('User properties: ' . $propertyIds);

            // Get the booking if it belongs to one of the user's properties
            $booking = Booking::whereIn('property_id', $propertyIds)
                ->with('rooms')
                ->findOrFail($id);

            Log::info('Found booking: ' . $booking->id . ' with status: ' . $booking->status);

            // Check if booking is in a valid state to be rejected
            if ($booking->status !== 'pending') {
                Log::warning('Cannot reject booking: invalid status ' . $booking->status);
                return response()->json([
                    'status' => 'error',
                    'message' => 'Booking tidak dapat ditolak karena status saat ini adalah ' . $booking->status
                ], 400);
            }

            DB::beginTransaction();
            Log::info('Starting transaction');

            // Update booking status
            $booking->update(['status' => 'cancelled']);
            Log::info('Updated booking status to cancelled');

            try {
                // Create notification for tenant
                $this->createBookingStatusNotification($booking, 'cancelled');
                Log::info('Created notification for tenant');
            } catch (\Exception $notifError) {
                Log::error('Error creating notification: ' . $notifError->getMessage());
                // Continue even if notification fails
            }

            DB::commit();
            Log::info('Transaction committed');

            return response()->json([
                'status' => 'success',
                'message' => 'Booking berhasil Ditolak',
                'data' => $booking
            ]);
        } catch (\Exception $e) {
            DB::rollBack();
            Log::error('Error confirming booking: ' . $e->getMessage());
            return response()->json([
                'status' => 'error',
                'message' => 'Gagal Menolak booking',
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
            // Mendapatkan ID properti yang dimiliki oleh user yang sedang login
            $propertyIds = Property::where('user_id', Auth::id())->pluck('id');

            // Mendapatkan booking jika milik properti user
            $booking = Booking::whereIn('property_id', $propertyIds)
                ->with('rooms')
                ->findOrFail($id);

            // Mengecek status booking, hanya yang berstatus 'confirmed' yang bisa diselesaikan
            if ($booking->status !== 'confirmed') {
                return response()->json([
                    'status' => 'error',
                    'message' => 'Booking tidak dapat diselesaikan karena status saat ini adalah ' . $booking->status
                ], 400);
            }

            DB::beginTransaction();
            Log::info('Starting transaction');

            // Update booking status
            $booking->update(['status' => 'completed']);
            Log::info('Updated booking status to completed');

            try {
                // Create notification for tenant
                $this->createBookingStatusNotification($booking, 'completed');
                Log::info('Created notification for tenant');
            } catch (\Exception $notifError) {
                Log::error('Error creating notification: ' . $notifError->getMessage());
                // Continue even if notification fails
            }

            DB::commit();
            Log::info('Transaction committed');

            return response()->json([
                'status' => 'success',
                'message' => 'Booking berhasil diselesaikan',
                'data' => $booking
            ]);
        } catch (\Exception $e) {
            DB::rollBack();
            Log::error('Error confirming booking: ' . $e->getMessage());
            return response()->json([
                'status' => 'error',
                'message' => 'Gagal meyelesaikan booking',
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
            Log::info('Creating notification for booking ' . $booking->id . ' with status ' . $status);

            // Get property details
            $property = Property::find($booking->property_id);
            if (!$property) {
                Log::warning('Property not found for booking ' . $booking->id);
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
                    $message = "Booking Anda untuk $propertyName dari $checkIn hingga $checkOut telah dikonfirmasi oleh pemilik. pembayaran akan dilakukan setelah anda check-in langsung, Terimakasih .";
                    $type = 'booking_confirmed';
                    break;
                case 'rejected':
                    $title = 'Booking Ditolak';
                    $message = "Maaf, booking Anda untuk $propertyName dari $checkIn hingga $checkOut telah ditolak oleh pemilik.";
                    $type = 'booking_rejected';
                    break;
                case 'completed':
                    $title = 'Booking Selesai';
                    $message = "Booking Anda untuk $propertyName dari $checkIn hingga $checkOut telah selesai. silahkan lihat dan download kartu booking anda di halaman booking, Terimakasih Telah Melakukan Pemesanan di Property kami. ";
                    $type = 'booking_completed';
                    break;
                default:
                    Log::warning('Invalid status for notification: ' . $status);
                    return;
            }

            // Check if user_id exists
            if (!$booking->user_id) {
                Log::warning('No user_id found for booking ' . $booking->id);
                return;
            }

            // Log notification data before creating
            Log::info('Creating notification with data: ', [
                'user_id' => $booking->user_id,
                'type' => $type,
                'title' => $title,
                'message' => $message,
                'reference_id' => $booking->id
            ]);

            // Menggunakan NotificationModel bukan Notification
            $notification = NotificationModel::create([
                'user_id' => $booking->user_id,
                'type' => $type,
                'title' => $title,
                'message' => $message,
                'reference_id' => $booking->id,
                'is_read' => false
            ]);

            Log::info('Notification created with ID: ' . $notification->id);
        } catch (\Exception $e) {
            Log::error('Error creating tenant notification: ' . $e->getMessage());
            // Rethrow the exception to be caught by the calling method
            throw $e;
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
            Log::error('Error fetching booking statistics: ' . $e->getMessage());
            return response()->json([
                'status' => 'error',
                'message' => 'Gagal memuat statistik booking',
                'error' => $e->getMessage()
            ], 500);
        }
    }
}
