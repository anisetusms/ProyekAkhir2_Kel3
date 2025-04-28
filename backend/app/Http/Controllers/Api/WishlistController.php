<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use App\Models\Wishlist;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class WishlistController extends Controller
{
    public function toggleWishlist($propertyId)
    {
        $user = Auth::user();
        
        $wishlist = Wishlist::where('user_id', $user->id)
                            ->where('property_id', $propertyId)
                            ->first();

        if ($wishlist) {
            $wishlist->delete();
            return response()->json(['status' => 'removed']);
        } else {
            Wishlist::create([
                'user_id' => $user->id,
                'property_id' => $propertyId
            ]);
            return response()->json(['status' => 'added']);
        }
    }

    public function checkWishlist($propertyId)
    {
        $user = Auth::user();
        
        $isWishlisted = Wishlist::where('user_id', $user->id)
                               ->where('property_id', $propertyId)
                               ->exists();

        return response()->json(['is_wishlisted' => $isWishlisted]);
    }

    public function getUserWishlists()
    {
        $user = Auth::user();
        
        $wishlists = Wishlist::with('property') // Pastikan relasi 'property' ada di model Wishlist
            ->where('user_id', $user->id)
            ->get()
            ->map(function ($wishlist) {
                return [
                    'id' => $wishlist->id,
                    'property' => [
                        'id' => $wishlist->property->id,
                        'name' => $wishlist->property->name,
                        'price' => $wishlist->property->price,
                        'image' => $wishlist->property->image_url // Sesuaikan dengan field yang ada
                    ]
                ];
            });

        return response()->json([
            'data' => $wishlists
        ]);
    }
}