<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Review extends Model
{
    use HasFactory;

    protected $table = 'reviews'; // Pastikan nama tabel sesuai
    protected $fillable = ['booking_id', 'property_id', 'rating', 'comment'];

    // Relasi dengan User (melalui booking)
    public function user()
    {
        return $this->belongsTo(User::class, 'booking_id', 'id')
            ->join('bookings', 'bookings.id', '=', 'reviews.booking_id')
            ->join('users', 'users.id', '=', 'bookings.user_id');
    }

    // Relasi dengan Property (satu ulasan terkait dengan satu property)
    public function property()
    {
        return $this->belongsTo(Property::class, 'property_id');
    }

    // Relasi dengan Booking (satu ulasan terkait dengan satu booking)
    public function booking()
    {
        return $this->belongsTo(Booking::class, 'booking_id');
    }
}
