<?php
// app/Http/Controllers/Api/BookingController.php
namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Booking;
use App\Models\BookingRoom;
use App\Models\PropertyAvailability;
use App\Models\Room;
use App\Models\Property;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Str;
use Illuminate\Support\Facades\DB;
use Carbon\Carbon;

class BookingController extends Controller
{
    // Helper untuk menghitung total hari
    private function calculateDays($checkIn, $checkOut)
    {
        return Carbon::parse($checkIn)->diffInDays(Carbon::parse($checkOut));
    }

    /**
     * Membuat booking baru
     */
    public function store(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'property_id' => 'required|exists:properties,id',
            'room_ids' => 'nullable|array',
            'room_ids.*' => 'exists:rooms,id,property_id,'.$request->property_id,
            'check_in' => 'required|date|after_or_equal:today',
            'check_out' => 'required|date|after:check_in',
            'is_for_others' => 'required|boolean',
            'guest_name' => 'required_if:is_for_others,true|string|max:255',
            'guest_phone' => 'required_if:is_for_others,true|string|max:20',
            'ktp_image' => 'required|file|mimes:jpg,png,pdf|max:2048',
            'identity_number' => 'required|string|size:16',
            'special_requests' => 'nullable|string'
        ], [
            'identity_number.size' => 'Nomor KTP harus 16 digit',
            'room_ids.*.exists' => 'Kamar tidak valid atau tidak tersedia di properti ini'
        ]);

        if ($validator->fails()) {
            return response()->json([
                'status' => 'error',
                'message' => 'Validasi gagal',
                'errors' => $validator->errors()
            ], 422);
        }

        try {
            DB::beginTransaction();

            // Generate unique booking group jika kosong
            $bookingGroup = $request->booking_group ?? Str::uuid();

            // Simpan file KTP
            $ktpPath = $request->file('ktp_image')->store('public/ktp');
            $ktpPath = str_replace('public/', '', $ktpPath);

            // Hitung total harga
            $totalPrice = 0;
            $days = $this->calculateDays($request->check_in, $request->check_out);

            if ($request->filled('room_ids')) {
                // Hitung harga dari kamar yang dipilih
                foreach ($request->room_ids as $roomId) {
                    $room = Room::findOrFail($roomId);
                    $totalPrice += $room->price * $days;
                }
            } else {
                // Ambil harga property jika booking homestay
                $property = Property::findOrFail($request->property_id);
                $totalPrice = $property->price * $days;
            }

            // Buat booking
            $booking = Booking::create([
                'user_id' => auth()->id(),
                'property_id' => $request->property_id,
                'check_in' => $request->check_in,
                'check_out' => $request->check_out,
                'total_price' => $totalPrice,
                'status' => 'pending',
                'guest_name' => $request->is_for_others 
                    ? $request->guest_name 
                    : auth()->user()->name,
                'guest_phone' => $request->is_for_others 
                    ? $request->guest_phone 
                    : auth()->user()->phone,
                'ktp_image' => $ktpPath,
                'identity_number' => $request->identity_number,
                'booking_group' => $bookingGroup,
                'special_requests' => $request->special_requests
            ]);

            // Jika booking kamar, simpan relasinya
            if ($request->filled('room_ids')) {
                foreach ($request->room_ids as $roomId) {
                    $room = Room::findOrFail($roomId);
                    BookingRoom::create([
                        'booking_id' => $booking->id,
                        'room_id' => $roomId,
                        'price' => $room->price
                    ]);

                    // Update status kamar
                    $room->update(['is_available' => false]);
                }
            }

            // Update ketersediaan property
            $currentDate = Carbon::parse($request->check_in);
            $endDate = Carbon::parse($request->check_out);
            
            while ($currentDate <= $endDate) {
                PropertyAvailability::updateOrCreate(
                    [
                        'property_id' => $request->property_id,
                        'date' => $currentDate->format('Y-m-d')
                    ],
                    [
                        'status' => 'booked',
                        'booking_id' => $booking->id
                    ]
                );
                $currentDate->addDay();
            }

            DB::commit();

            return response()->json([
                'status' => 'success',
                'message' => 'Booking berhasil dibuat',
                'data' => $booking->load('rooms', 'property')
            ], 201);

        } catch (\Exception $e) {
            DB::rollBack();
            return response()->json([
                'status' => 'error',
                'message' => 'Terjadi kesalahan server',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Menampilkan daftar booking user
     */
    public function index()
    {
        $bookings = Booking::where('user_id', auth()->id())
            ->with(['property', 'rooms'])
            ->orderBy('created_at', 'desc')
            ->get();

        return response()->json([
            'status' => 'success',
            'data' => $bookings
        ]);
    }

    /**
     * Menampilkan detail booking
     */
    public function show($id)
    {
        $booking = Booking::with(['property', 'rooms', 'user'])
            ->where('user_id', auth()->id())
            ->findOrFail($id);

        return response()->json([
            'status' => 'success',
            'data' => $booking
        ]);
    }

    /**
     * Membatalkan booking
     */
    public function cancel($id)
    {
        $booking = Booking::where('user_id', auth()->id())
            ->findOrFail($id);

        if (!in_array($booking->status, ['pending', 'confirmed'])) {
            return response()->json([
                'status' => 'error',
                'message' => 'Booking tidak dapat dibatalkan'
            ], 400);
        }

        try {
            DB::beginTransaction();

            $booking->update(['status' => 'cancelled']);

            // Kembalikan ketersediaan kamar
            if ($booking->rooms->isNotEmpty()) {
                Room::whereIn('id', $booking->rooms->pluck('id'))
                    ->update(['is_available' => true]);
            }

            // Kembalikan ketersediaan property
            PropertyAvailability::where('booking_id', $booking->id)
                ->update(['status' => 'available', 'booking_id' => null]);

            DB::commit();

            return response()->json([
                'status' => 'success',
                'message' => 'Booking berhasil dibatalkan'
            ]);

        } catch (\Exception $e) {
            DB::rollBack();
            return response()->json([
                'status' => 'error',
                'message' => 'Gagal membatalkan booking',
                'error' => $e->getMessage()
            ], 500);
        }
    }
}