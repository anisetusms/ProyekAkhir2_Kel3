<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Review;
use App\Models\Property;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\DB;

class UlasanController extends Controller
{
    /**
     * Menampilkan dashboard ulasan
     */
    public function dashboard()
    {
        $user = Auth::user();
        
        // Ambil semua properti milik user ini
        $propertyIds = Property::where('user_id', $user->id)->pluck('id')->toArray();
        
        // Ambil statistik ulasan
        $totalReviews = Review::whereIn('property_id', $propertyIds)->count();
        $averageRating = Review::whereIn('property_id', $propertyIds)->avg('rating') ?? 0;
        $fiveStarReviews = Review::whereIn('property_id', $propertyIds)->where('rating', 5)->count();
        $recentReviews = Review::whereIn('property_id', $propertyIds)
            ->with(['property', 'booking.user'])
            ->orderBy('created_at', 'desc')
            ->limit(5)
            ->get();
            
        // Ambil data untuk grafik
        $ratingDistribution = [
            5 => Review::whereIn('property_id', $propertyIds)->where('rating', 5)->count(),
            4 => Review::whereIn('property_id', $propertyIds)->where('rating', 4)->count(),
            3 => Review::whereIn('property_id', $propertyIds)->where('rating', 3)->count(),
            2 => Review::whereIn('property_id', $propertyIds)->where('rating', 2)->count(),
            1 => Review::whereIn('property_id', $propertyIds)->where('rating', 1)->count(),
        ];
        
        // Ambil data ulasan per properti
        $propertiesWithReviews = Property::where('user_id', $user->id)
            ->withCount('reviews')
            ->withAvg('reviews', 'rating')
            ->orderBy('reviews_count', 'desc')
            ->get();
            
        return view('admin.ulasan.dashboard', compact(
            'totalReviews', 
            'averageRating', 
            'fiveStarReviews', 
            'recentReviews', 
            'ratingDistribution',
            'propertiesWithReviews'
        ));
    }
    
    /**
     * Menampilkan daftar semua ulasan
     */
    public function index(Request $request)
    {
        $user = Auth::user();
        
        // Ambil semua properti milik user ini
        $propertyIds = Property::where('user_id', $user->id)->pluck('id')->toArray();
        
        // Filter berdasarkan properti jika ada
        $propertyId = $request->input('property_id');
        $rating = $request->input('rating');
        $search = $request->input('search');
        
        $query = Review::whereIn('property_id', $propertyIds)
            ->with(['property', 'booking.user']);
            
        if ($propertyId) {
            $query->where('property_id', $propertyId);
        }
        
        if ($rating) {
            $query->where('rating', $rating);
        }
        
        if ($search) {
            $query->where('comment', 'like', "%{$search}%");
        }
        
        $reviews = $query->orderBy('created_at', 'desc')
            ->paginate(10);
            
        $properties = Property::where('user_id', $user->id)->get();
        
        return view('admin.ulasan.index', compact('reviews', 'properties'));
    }
    
    /**
     * Menampilkan detail ulasan
     */
    public function show($id)
    {
        $user = Auth::user();
        
        // Ambil ulasan dan pastikan properti milik user ini
        $review = Review::with(['property', 'booking.user'])
            ->whereHas('property', function($query) use ($user) {
                $query->where('user_id', $user->id);
            })
            ->findOrFail($id);
            
        return view('admin.ulasan.show', compact('review'));
    }
    
    /**
     * Menampilkan ulasan berdasarkan properti
     */
    public function getByProperty($propertyId)
    {
        $user = Auth::user();
        
        // Pastikan properti milik user ini
        $property = Property::where('user_id', $user->id)
            ->findOrFail($propertyId);
            
        $reviews = Review::where('property_id', $propertyId)
            ->with(['booking.user'])
            ->orderBy('created_at', 'desc')
            ->paginate(10);
            
        return view('admin.ulasan.property', compact('property', 'reviews'));
    }
}
