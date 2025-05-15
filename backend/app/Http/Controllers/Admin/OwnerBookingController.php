<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Booking;
use App\Models\BookingRoom;
use App\Models\Property;
use App\Models\Room;
use App\Models\Notification;
use Carbon\Carbon;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\DB;

class OwnerBookingController extends Controller
{
    /**
     * Menampilkan semua booking untuk properti yang dimiliki oleh user yang sedang login.
     *
     * @return \Illuminate\View\View
     */
    public function index()
    {
        try {
            $propertyIds = Property::where('user_id', Auth::id())->pluck('id');
            $bookings = Booking::whereIn('property_id', $propertyIds)
                ->with(['property:id,name,address,user_id', 'rooms:id,room_number,room_type,price'])
                ->orderBy('created_at', 'desc')
                ->get();
            
            // Mark notifications as read
            Notification::where('user_id', Auth::id())
                ->where('type', 'booking')
                ->where('is_read', false)
                ->update(['is_read' => true]);
                
            return view('admin.properties.bookings.dashboard', compact('bookings'));
        } catch (\Exception $e) {
            return redirect()->back()->with('error', 'Gagal memuat daftar booking. Error: ' . $e->getMessage());
        }
    }

    /**
     * Menampilkan detail booking
     *
     * @param int $id
     * @return \Illuminate\View\View
     */
    public function show($id)
    {
        try {
            // Mendapatkan ID properti yang dimiliki oleh user yang sedang login
            $propertyIds = Property::where('user_id', Auth::id())->pluck('id');

            // Mendapatkan booking berdasarkan ID jika milik properti user
            $booking = Booking::whereIn('property_id', $propertyIds)
                ->with([
                    'property:id,name,address,user_id,property_type_id',
                    'property.propertyType:id,name',
                    'rooms:id,room_number,room_type,price'
                ])
                ->findOrFail($id);
                
            // Mark notification as read
            Notification::where('user_id', Auth::id())
                ->where('type', 'booking')
                ->where('reference_id', $id)
                ->where('is_read', false)
                ->update(['is_read' => true]);

            return view('admin.properties.bookings.show', compact('booking'));
        } catch (\Exception $e) {
            return redirect()->back()->with('error', 'Gagal memuat detail booking. Error: ' . $e->getMessage());
        }
    }

    /**
     * Mengonfirmasi sebuah booking
     *
     * @param int $id
     * @return \Illuminate\Http\RedirectResponse
     */
    public function confirm($id)
    {
        try {
            // Mendapatkan ID properti yang dimiliki oleh user yang sedang login
            $propertyIds = Property::where('user_id', Auth::id())->pluck('id');

            // Mendapatkan booking jika milik properti user
            $booking = Booking::whereIn('property_id', $propertyIds)
                ->findOrFail($id);

            // Mengecek status booking
            if ($booking->status !== 'pending') {
                return redirect()->back()->with('error', 'Booking tidak dapat dikonfirmasi karena status saat ini adalah ' . $booking->status);
            }

            DB::beginTransaction();

            // Mengupdate status booking menjadi 'confirmed'
            $booking->update(['status' => 'confirmed']);
            
            // Create notification for user
            $this->createNotification(
                $booking->user_id, 
                'booking_confirmed', 
                'Pemesanan Anda telah dikonfirmasi', 
                'Pemesanan Anda untuk ' . $booking->property->name . ' telah dikonfirmasi oleh pemilik,/n Silahkan lakukan pembayaran saat check-in di lokasi.',
                $id
            );

            DB::commit();

            return redirect()->route('admin.properties.bookings.dashboard')->with('success', 'Booking berhasil dikonfirmasi');
        } catch (\Exception $e) {
            DB::rollBack();
            return redirect()->back()->with('error', 'Gagal mengonfirmasi booking. Error: ' . $e->getMessage());
        }
    }

    /**
     * Menolak sebuah booking
     *
     * @param int $id
     * @return \Illuminate\Http\RedirectResponse
     */
    public function reject($id)
    {
        try {
            // Mendapatkan ID properti yang dimiliki oleh user yang sedang login
            $propertyIds = Property::where('user_id', Auth::id())->pluck('id');

            // Mendapatkan booking jika milik properti user
            $booking = Booking::whereIn('property_id', $propertyIds)
                ->with('rooms')
                ->findOrFail($id);

            // Mengecek status booking
            if ($booking->status !== 'pending') {
                return redirect()->back()->with('error', 'Booking tidak dapat ditolak karena status saat ini adalah ' . $booking->status);
            }

            DB::beginTransaction();

            // Mengupdate status booking menjadi 'cancelled'
            $booking->update(['status' => 'cancelled']);

            // Mengembalikan ketersediaan kamar
            if ($booking->rooms->isNotEmpty()) {
                Room::whereIn('id', $booking->rooms->pluck('id'))
                    ->update(['is_available' => true]);
            }
            
            // Create notification for user
            $this->createNotification(
                $booking->user_id, 
                'booking_rejected', 
                'Pemesanan Anda telah ditolak', 
                'Pemesanan Anda untuk ' . $booking->property->name . ' telah ditolak oleh pemilik.',
                $id
            );

            DB::commit();

            return redirect()->route('admin.properties.bookings.dashboard')->with('success', 'Booking berhasil ditolak');
        } catch (\Exception $e) {
            DB::rollBack();
            return redirect()->back()->with('error', 'Gagal menolak booking. Error: ' . $e->getMessage());
        }
    }

    /**
     * Menyelesaikan booking
     *
     * @param int $id
     * @return \Illuminate\Http\RedirectResponse
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

            // Mengecek status booking
            if ($booking->status !== 'confirmed') {
                return redirect()->back()->with('error', 'Booking tidak dapat diselesaikan karena status saat ini adalah ' . $booking->status);
            }

            DB::beginTransaction();

            // Mengupdate status booking menjadi 'completed'
            $booking->update(['status' => 'completed']);
            
            // Mengembalikan ketersediaan kamar
            if ($booking->rooms->isNotEmpty()) {
                Room::whereIn('id', $booking->rooms->pluck('id'))
                    ->update(['is_available' => true]);
            }
            
            // Create notification for user
            $this->createNotification(
                $booking->user_id, 
                'booking_completed', 
                'Pemesanan Anda telah selesai', 
                'Pemesanan Anda untuk ' . $booking->property->name . ' telah diselesaikan.',
                $id
            );

            DB::commit();

            return redirect()->route('admin.properties.bookings.dashboard')->with('success', 'Booking berhasil diselesaikan');
        } catch (\Exception $e) {
            DB::rollBack();
            return redirect()->back()->with('error', 'Gagal menyelesaikan booking. Error: ' . $e->getMessage());
        }
    }

    /**
     * Menampilkan statistik booking
     *
     * @return \Illuminate\View\View
     */
    public function statistics()
    {
        try {
            // Mendapatkan ID properti yang dimiliki oleh user yang sedang login
            $propertyIds = Property::where('user_id', Auth::id())->pluck('id');

            // Statistik booking
            $totalBookings = Booking::whereIn('property_id', $propertyIds)->count();
            $pendingBookings = Booking::whereIn('property_id', $propertyIds)->where('status', 'pending')->count();
            $confirmedBookings = Booking::whereIn('property_id', $propertyIds)->where('status', 'confirmed')->count();
            $completedBookings = Booking::whereIn('property_id', $propertyIds)->where('status', 'completed')->count();
            $cancelledBookings = Booking::whereIn('property_id', $propertyIds)->where('status', 'cancelled')->count();

            // Total pendapatan
            $totalRevenue = Booking::whereIn('property_id', $propertyIds)
                ->whereIn('status', ['confirmed', 'completed'])
                ->sum('total_price');

            // Recent bookings
            $recentBookings = Booking::whereIn('property_id', $propertyIds)
                ->with('property:id,name')
                ->orderBy('created_at', 'desc')
                ->limit(5)
                ->get();

            return view('admin.properties.bookings.statistics', compact(
                'totalBookings',
                'pendingBookings',
                'confirmedBookings',
                'completedBookings',
                'cancelledBookings',
                'totalRevenue',
                'recentBookings'
            ));
        } catch (\Exception $e) {
            return redirect()->back()->with('error', 'Gagal memuat statistik booking. Error: ' . $e->getMessage());
        }
    }

    /**
     * Mendapatkan pemesanan yang sedang berlangsung
     *
     * @return \Illuminate\Http\JsonResponse
     */
    public function getPendingBookings()
    {
        try {
            $propertyIds = Property::where('user_id', Auth::id())->pluck('id');
            $pendingBookings = Booking::whereIn('property_id', $propertyIds)
                ->where('status', 'pending')
                ->with('property:id,name', 'rooms:id,room_number,room_type')
                ->orderBy('created_at', 'desc')
                ->get();

            return response()->json([
                'status' => 'success',
                'data' => $pendingBookings
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'status' => 'error',
                'message' => 'Gagal memuat pemesanan yang sedang berlangsung',
                'error' => $e->getMessage()
            ], 500);
        }
    }
    
    /**
     * Mendapatkan jumlah notifikasi yang belum dibaca
     *
     * @return \Illuminate\Http\JsonResponse
     */
    public function getUnreadNotificationsCount()
    {
        try {
            $count = Notification::where('user_id', Auth::id())
                ->where('is_read', false)
                ->count();
                
            return response()->json([
                'status' => 'success',
                'count' => $count
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'status' => 'error',
                'message' => 'Gagal memuat jumlah notifikasi',
                'error' => $e->getMessage()
            ], 500);
        }
    }
    
    /**
     * Membuat notifikasi baru
     *
     * @param int $userId
     * @param string $type
     * @param string $title
     * @param string $message
     * @param int $referenceId
     * @return void
     */
    private function createNotification($userId, $type, $title, $message, $referenceId = null)
    {
        Notification::create([
            'user_id' => $userId,
            'type' => $type,
            'title' => $title,
            'message' => $message,
            'reference_id' => $referenceId,
            'is_read' => false
        ]);
    }
}
