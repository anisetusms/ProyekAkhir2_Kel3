<?php
// app/Models/Booking.php
namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;

class Booking extends Model
{
    protected $fillable = [
        'user_id',
        'property_id',
        'check_in',
        'check_out',
        'total_price',
        'status',
        'payment_proof',
        'guest_name',
        'guest_phone',
        'ktp_image',
        'identity_number',
        'booking_group',
        'special_requests'
    ];

    protected $casts = [
        'check_in' => 'date',
        'check_out' => 'date',
        'is_booked_for_others' => 'boolean'
    ];

    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }

    public function customer(): BelongsTo
    {
        return $this->belongsTo(Customer::class);
    }

    public function property(): BelongsTo
    {
        return $this->belongsTo(Property::class);
    }

    public function rooms()
    {
        return $this->belongsToMany(Room::class, 'booking_rooms')
            ->withPivot('price');
    }

    // Menambahkan relasi dengan Ulasan
    public function reviews(): HasMany
    {
        return $this->hasMany(Review::class);
    }
}
