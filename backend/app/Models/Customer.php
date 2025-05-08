<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Customer extends Model
{
    use HasFactory;

    protected $fillable = [
        'user_id',
        'name',
        'phone',
        'identity_number'
    ];

    /**
     * Relasi ke user yang melakukan booking
     */
    public function user()
    {
        return $this->belongsTo(User::class);
    }

    /**
     * Relasi ke semua booking yang menggunakan customer ini
     */
    public function bookings()
    {
        return $this->hasMany(Booking::class);
    }
}