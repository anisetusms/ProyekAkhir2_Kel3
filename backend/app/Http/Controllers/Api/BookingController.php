<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use App\Models\Booking;
use App\Models\BookingRoom;
use App\Models\Property;
use App\Models\PropertyAvailability;
use App\Models\PropertyType;
use App\Models\Room;
use Carbon\Carbon;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Str;
use App\Models\Customer;
use Illuminate\Support\Facades\Auth;

class BookingController extends Controller
{
    /**
     * Create a new booking
     * 
     * @param Request $request
     * @return \Illuminate\Http\JsonResponse
     */
    public function store(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'property_id' => 'required|exists:properties,id',
            'room_ids' => 'nullable|array',
            'room_ids.*' => 'exists:rooms,id,property_id,' . $request->property_id,
            'check_in' => 'required|date|after_or_equal:today',
            'check_out' => 'required|date|after:check_in',
            'is_for_others' => 'required|boolean',
            'guest_name' => 'required_if:is_for_others,true|string|max:255',
            'guest_phone' => 'required_if:is_for_others,true|string|max:20',
            'ktp_image' => 'required|file|mimes:jpg,png,pdf|max:2048',
            'identity_number' => 'required|string|size:16',
            'special_requests' => 'nullable|string',
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

            // Get property and its type with proper validation
            $property = Property::with('propertyType')->findOrFail($request->property_id);

            // Check if propertyType is valid
            if (!$property->propertyType) {
                return response()->json([
                    'status' => 'error',
                    'message' => 'Tipe properti tidak ditemukan'
                ], 422);
            }

            $isKost = $property->propertyType->type == PropertyType::TYPE_KOST;
            $isHomestay = $property->propertyType->type == PropertyType::TYPE_HOMESTAY;

            // Validation specific to kost
            if ($isKost && empty($request->room_ids)) {
                return response()->json([
                    'status' => 'error',
                    'message' => 'Untuk kost, Anda harus memilih kamar yang akan dipesan'
                ], 422);
            }

            // Validate dates
            $checkIn = Carbon::parse($request->check_in);
            $checkOut = Carbon::parse($request->check_out);
            $days = $checkOut->diffInDays($checkIn);

            if ($days < 1) {
                return response()->json([
                    'status' => 'error',
                    'message' => 'Durasi minimal pemesanan adalah 1 hari'
                ], 422);
            }

            // Validate availability
            if ($isHomestay && empty($request->room_ids)) {
                // Booking entire homestay
                $unavailableDates = PropertyAvailability::where('property_id', $property->id)
                    ->whereBetween('date', [$checkIn->format('Y-m-d'), $checkOut->copy()->subDay()->format('Y-m-d')])
                    ->where('status', 'booked')
                    ->exists();

                if ($unavailableDates) {
                    return response()->json([
                        'status' => 'error',
                        'message' => 'Homestay tidak tersedia untuk tanggal yang dipilih'
                    ], 422);
                }
            } else {
                // Booking specific rooms (either kost or homestay)
                $unavailableRooms = DB::table('booking_rooms')
                    ->join('bookings', 'booking_rooms.booking_id', '=', 'bookings.id')
                    ->whereIn('booking_rooms.room_id', $request->room_ids)
                    ->where(function ($query) use ($checkIn, $checkOut) {
                        $query->whereBetween('bookings.check_in', [$checkIn, $checkOut])
                            ->orWhereBetween('bookings.check_out', [$checkIn, $checkOut])
                            ->orWhere(function ($q) use ($checkIn, $checkOut) {
                                $q->where('bookings.check_in', '<=', $checkIn)
                                    ->where('bookings.check_out', '>=', $checkOut);
                            });
                    })
                    ->whereIn('bookings.status', ['pending', 'confirmed'])
                    ->exists();

                if ($unavailableRooms) {
                    return response()->json([
                        'status' => 'error',
                        'message' => 'Salah satu kamar yang dipilih sudah tidak tersedia untuk tanggal tersebut'
                    ], 422);
                }
            }

            // Handle customer if booking for others
            $customer = null;
            if ($request->is_for_others) {
                $customer = Customer::updateOrCreate(
                    ['identity_number' => $request->identity_number],
                    [
                        'user_id' => auth()->id(),
                        'name' => $request->guest_name,
                        'phone' => $request->guest_phone,
                        'identity_number' => $request->identity_number
                    ]
                );
            }

            // Upload KTP
            $ktpPath = $request->file('ktp_image')->store('public/ktp');
            $ktpPath = str_replace('public/', '', $ktpPath);

            // Calculate total price
            $totalPrice = 0;
            $rooms = collect();

            if (!empty($request->room_ids)) {
                $rooms = Room::whereIn('id', $request->room_ids)->get();
                foreach ($rooms as $room) {
                    $totalPrice += $room->price * $days;
                }
            } else {
                $totalPrice = $property->price * $days;
            }

            // Generate booking group
            $bookingGroup = $request->booking_group ?? Str::uuid();

            $booking = Booking::create([
                'user_id' => auth()->id(),  // Menggunakan Auth::id() untuk mendapatkan ID pengguna
                'property_id' => $property->id,
                'customer_id' => $request->is_for_others ? $customer->id : null,
                'check_in' => $request->check_in,
                'check_out' => $request->check_out,
                'total_price' => $totalPrice,
                'status' => 'pending',
                'guest_name' => $request->is_for_others
                    ? $request->guest_name
                    : (auth()->check() ? auth()->user()->name : null), // Menggunakan Auth::user() untuk mengakses data pengguna
                'guest_phone' => $request->is_for_others
                    ? $request->guest_phone
                    : (auth()->check() ? auth()->user()->phone : null), // Menggunakan Auth::user() untuk mengakses data pengguna
                'ktp_image' => $ktpPath,
                'identity_number' => $request->identity_number,
                'booking_group' => $bookingGroup,
                'special_requests' => $request->special_requests
            ]);


            // Create booking_room entries if booking specific rooms
            if (!empty($request->room_ids)) {
                foreach ($rooms as $room) {
                    BookingRoom::create([
                        'booking_id' => $booking->id,
                        'room_id' => $room->id,
                        'price' => $room->price
                    ]);

                    // Update room status
                    $room->update(['is_available' => false]);
                }
            }

            // Update property availability
            $currentDate = $checkIn->copy();
            while ($currentDate < $checkOut) {
                PropertyAvailability::updateOrCreate(
                    [
                        'property_id' => $property->id,
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
                'data' => $booking->load('property', 'rooms', 'customer')
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
     * Get user bookings
     * 
     * @return \Illuminate\Http\JsonResponse
     */
    public function index()
    {
        $bookings = Booking::with(['property', 'rooms', 'customer'])
            ->where('user_id', auth()->id())
            ->orderBy('created_at', 'desc')
            ->get();

        return response()->json([
            'status' => 'success',
            'data' => $bookings
        ]);
    }

    /**
     * Get booking detail
     * 
     * @param int $id
     * @return \Illuminate\Http\JsonResponse
     */
    public function show($id)
    {
        $booking = Booking::with(['property', 'rooms', 'customer'])
            ->where('user_id', auth()->id())
            ->findOrFail($id);

        return response()->json([
            'status' => 'success',
            'data' => $booking
        ]);
    }

    /**
     * Cancel booking
     * 
     * @param int $id
     * @return \Illuminate\Http\JsonResponse
     */
    public function cancel($id)
    {
        try {
            DB::beginTransaction();

            $booking = Booking::with('rooms')
                ->where('user_id', auth()->id())
                ->findOrFail($id);

            if (!in_array($booking->status, ['pending', 'confirmed'])) {
                return response()->json([
                    'status' => 'error',
                    'message' => 'Hanya booking dengan status pending atau confirmed yang bisa dibatalkan'
                ], 400);
            }

            $booking->update(['status' => 'cancelled']);

            // Return room availability
            if ($booking->rooms->isNotEmpty()) {
                Room::whereIn('id', $booking->rooms->pluck('id'))
                    ->update(['is_available' => true]);
            }

            // Return property availability
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

    /**
     * Check property availability
     * 
     * @param Request $request
     * @return \Illuminate\Http\JsonResponse
     */
    public function checkAvailability(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'property_id' => 'required|exists:properties,id',
            'check_in' => 'required|date|after_or_equal:today',
            'check_out' => 'required|date|after:check_in',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'status' => 'error',
                'message' => 'Validasi gagal',
                'errors' => $validator->errors()
            ], 422);
        }

        try {
            $property = Property::with('propertyType')->findOrFail($request->property_id);
            $checkIn = Carbon::parse($request->check_in);
            $checkOut = Carbon::parse($request->check_out);
            $checkOutForQuery = $checkOut->copy()->subDay();

            // Check property availability
            $unavailableDates = PropertyAvailability::where('property_id', $property->id)
                ->whereBetween('date', [$checkIn->format('Y-m-d'), $checkOutForQuery->format('Y-m-d')])
                ->where('status', 'booked')
                ->get();

            $response = [
                'status' => 'success',
                'property' => $property,
                'is_available' => $unavailableDates->isEmpty(),
                'unavailable_dates' => $unavailableDates->pluck('date')
            ];

            // If property is kost, show available rooms
            if ($property->property_type_id == PropertyType::TYPE_KOST) {
                $availableRooms = Room::where('property_id', $property->id)
                    ->where('is_available', true)
                    ->whereDoesntHave('bookings', function ($q) use ($checkIn, $checkOut) {
                        $q->where(function ($query) use ($checkIn, $checkOut) {
                            $query->whereBetween('check_in', [$checkIn, $checkOut])
                                ->orWhereBetween('check_out', [$checkIn, $checkOut])
                                ->orWhere(function ($q) use ($checkIn, $checkOut) {
                                    $q->where('check_in', '<', $checkIn)
                                        ->where('check_out', '>', $checkOut);
                                });
                        })
                            ->whereIn('status', ['pending', 'confirmed']);
                    })
                    ->with('facilities')
                    ->get();

                $response['available_rooms'] = $availableRooms;
            }

            return response()->json($response);
        } catch (\Exception $e) {
            return response()->json([
                'status' => 'error',
                'message' => 'Gagal memeriksa ketersediaan',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Upload payment proof
     * 
     * @param Request $request
     * @param int $id
     * @return \Illuminate\Http\JsonResponse
     */
    public function uploadPaymentProof(Request $request, $id)
    {
        $validator = Validator::make($request->all(), [
            'payment_proof' => 'required|file|mimes:jpg,png,pdf|max:2048',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'status' => 'error',
                'message' => 'Validasi gagal',
                'errors' => $validator->errors()
            ], 422);
        }

        try {
            $booking = Booking::where('user_id', auth()->id())
                ->where('status', 'pending')
                ->findOrFail($id);

            $paymentProofPath = $request->file('payment_proof')->store('public/payment_proofs');
            $paymentProofPath = str_replace('public/', '', $paymentProofPath);

            $booking->update([
                'payment_proof' => $paymentProofPath,
                'status' => 'processing'
            ]);

            return response()->json([
                'status' => 'success',
                'message' => 'Bukti pembayaran berhasil diupload',
                'data' => $booking
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'status' => 'error',
                'message' => 'Gagal mengupload bukti pembayaran',
                'error' => $e->getMessage()
            ], 500);
        }
    }
}
