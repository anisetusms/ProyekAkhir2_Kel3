<?php
namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
class PropertyAvailability extends Model
{
    protected $table = 'property_availability';
    protected $fillable = [
        'property_id',
        'date',
        'status',
        'booking_id'
    ];

    protected $casts = [
        'date' => 'date'
    ];

    public function property()
    {
        return $this->belongsTo(Property::class);
    }

    public function booking()
    {
        return $this->belongsTo(Booking::class);
    }
}
