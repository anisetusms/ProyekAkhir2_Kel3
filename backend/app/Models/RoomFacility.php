<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class RoomFacility extends Model
{
    use HasFactory;

    protected $fillable = [
        'room_id',
        'facility_name'
    ];

    /**
     * Get the room that owns the facility.
     */
    public function room(): BelongsTo
    {
        return $this->belongsTo(Room::class);
    }

    /**
     * Scope a query to only include facilities with given names.
     */
    public function scopeWithFacilities($query, array $facilities)
    {
        return $query->whereIn('facility_name', $facilities);
    }
}