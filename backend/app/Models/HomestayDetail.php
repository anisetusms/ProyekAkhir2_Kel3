<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class HomestayDetail extends Model
{
    use HasFactory;

    protected $fillable = [
        'property_id',
        'total_units',
        'available_units',
        'minimum_stay',
        'maximum_guest',
        'checkin_time',
        'checkout_time'
    ];

    /**
     * Get the property that owns the homestay detail.
     */
    public function property(): BelongsTo
    {
        return $this->belongsTo(Property::class);
    }

    /**
     * Format checkin time for display.
     */
    public function getFormattedCheckinTimeAttribute()
    {
        return date('H:i', strtotime($this->checkin_time));
    }

    /**
     * Format checkout time for display.
     */
    public function getFormattedCheckoutTimeAttribute()
    {
        return date('H:i', strtotime($this->checkout_time));
    }
}