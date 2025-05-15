<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Review;
use App\Models\Booking;
use App\Models\Property;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;

class UlasanController extends Controller
{
    /**
     * Menampilkan ulasan berdasarkan properti
     */
    public function getByProperty($propertyId)
    {
        try {
            Log::info("Fetching reviews for property ID: $propertyId");
            
            // Cek apakah properti ada
            $property = Property::findOrFail($propertyId);
            
            // Ambil semua ulasan untuk properti ini
            $reviews = DB::table('reviews')
                ->join('bookings', 'reviews.booking_id', '=', 'bookings.id')
                ->join('users', 'bookings.user_id', '=', 'users.id')
                ->select(
                    'reviews.*',
                    'users.id as user_id',
                    'users.name as user_name',
                    'users.profile_picture'
                )
                ->where('reviews.property_id', $propertyId)
                ->orderBy('reviews.created_at', 'desc')
                ->get();
            
            Log::info("Found " . count($reviews) . " reviews");
            
            // Transformasi data untuk format yang diharapkan oleh frontend
            $formattedReviews = $reviews->map(function($review) {
                return [
                    'id' => $review->id,
                    'booking_id' => $review->booking_id,
                    'property_id' => $review->property_id,
                    'rating' => $review->rating,
                    'comment' => $review->comment,
                    'created_at' => $review->created_at,
                    'updated_at' => $review->updated_at,
                    'user' => [
                        'id' => $review->user_id,
                        'name' => $review->user_name,
                        'profile_picture' => $review->profile_picture
                    ]
                ];
            });
            
            // Hitung rata-rata rating
            $averageRating = $reviews->avg('rating') ?? 0;
            
            $result = [
                'status' => 'success',
                'message' => 'Berhasil mengambil data ulasan',
                'data' => [
                    'items' => $formattedReviews,
                    'average_rating' => round($averageRating, 1),
                    'count' => $reviews->count()
                ]
            ];
            
            Log::info("Returning reviews data: " . json_encode($result));
            
            return response()->json($result);
        } catch (\Exception $e) {
            Log::error("Error fetching reviews: " . $e->getMessage());
            return response()->json([
                'status' => 'error',
                'message' => 'Gagal mengambil data ulasan',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Menyimpan ulasan baru
     */
    public function store(Request $request)
    {
        try {
            Log::info("Creating new review with data: " . json_encode($request->all()));
            
            // Validasi input
            $validator = Validator::make($request->all(), [
                'booking_id' => 'required|exists:bookings,id',
                'property_id' => 'required|exists:properties,id',
                'rating' => 'required|integer|min:1|max:5',
                'comment' => 'required|string|min:1|max:500',
            ]);

            if ($validator->fails()) {
                Log::warning("Validation failed: " . json_encode($validator->errors()));
                return response()->json([
                    'status' => 'error',
                    'message' => 'Validasi gagal',
                    'errors' => $validator->errors()
                ], 422);
            }

            // Cek apakah booking milik user yang sedang login
            $booking = Booking::findOrFail($request->booking_id);
            
            if ($booking->user_id !== Auth::id()) {
                Log::warning("User " . Auth::id() . " attempted to review booking " . $request->booking_id . " which belongs to user " . $booking->user_id);
                return response()->json([
                    'status' => 'error',
                    'message' => 'Anda tidak berhak memberikan ulasan untuk booking ini'
                ], 403);
            }

            // Cek apakah booking sudah selesai
            if ($booking->status !== 'completed') {
                Log::warning("Attempted to review booking with status: " . $booking->status);
                return response()->json([
                    'status' => 'error',
                    'message' => 'Anda hanya dapat memberikan ulasan untuk booking yang sudah selesai'
                ], 400);
            }

            // Cek apakah sudah pernah memberikan ulasan untuk booking ini
            $existingReview = Review::where('booking_id', $request->booking_id)->first();

            if ($existingReview) {
                Log::warning("Duplicate review attempt for booking " . $request->booking_id);
                return response()->json([
                    'status' => 'error',
                    'message' => 'Anda sudah memberikan ulasan untuk booking ini'
                ], 400);
            }

            // Buat ulasan baru
            $review = Review::create([
                'booking_id' => $request->booking_id,
                'property_id' => $request->property_id,
                'rating' => $request->rating,
                'comment' => $request->comment,
            ]);

            Log::info("Review created successfully with ID: " . $review->id);

            return response()->json([
                'status' => 'success',
                'message' => 'Ulasan berhasil disimpan',
                'data' => $review
            ], 201);
        } catch (\Exception $e) {
            Log::error("Error creating review: " . $e->getMessage());
            return response()->json([
                'status' => 'error',
                'message' => 'Gagal menyimpan ulasan',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Menampilkan ulasan yang diberikan oleh user yang sedang login
     */
    public function userUlasan()
    {
        try {
            $userId = Auth::id();
            Log::info("Fetching reviews for user ID: $userId");
            
            $reviews = DB::table('reviews')
                ->join('bookings', 'reviews.booking_id', '=', 'bookings.id')
                ->join('properties', 'reviews.property_id', '=', 'properties.id')
                ->select(
                    'reviews.*',
                    'properties.name as property_name',
                    'properties.image as property_image',
                    'bookings.check_in',
                    'bookings.check_out'
                )
                ->where('bookings.user_id', $userId)
                ->orderBy('reviews.created_at', 'desc')
                ->get();
            
            Log::info("Found " . count($reviews) . " reviews for user");
            
            // Transformasi data untuk format yang diharapkan oleh frontend
            $formattedReviews = $reviews->map(function($review) {
                return [
                    'id' => $review->id,
                    'booking_id' => $review->booking_id,
                    'property_id' => $review->property_id,
                    'rating' => $review->rating,
                    'comment' => $review->comment,
                    'created_at' => $review->created_at,
                    'updated_at' => $review->updated_at,
                    'property' => [
                        'id' => $review->property_id,
                        'name' => $review->property_name,
                        'image' => $review->property_image
                    ],
                    'booking' => [
                        'id' => $review->booking_id,
                        'check_in' => $review->check_in,
                        'check_out' => $review->check_out
                    ]
                ];
            });

            return response()->json([
                'status' => 'success',
                'message' => 'Berhasil mengambil data ulasan',
                'data' => $formattedReviews
            ]);
        } catch (\Exception $e) {
            Log::error("Error fetching user reviews: " . $e->getMessage());
            return response()->json([
                'status' => 'error',
                'message' => 'Gagal mengambil data ulasan',
                'error' => $e->getMessage()
            ], 500);
        }
    }
}
