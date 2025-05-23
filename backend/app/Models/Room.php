<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class Room extends Model
{
    use HasFactory;

    protected $fillable = [
        'property_id',
        'room_type',
        'room_number',
        'price',
        'size',
        'capacity',
        'is_available',
        'description'
    ];

    protected $casts = [
        'price' => 'decimal:2',
        'gallery_images' => 'array',
        'is_available' => 'boolean'
    ];

    /**
     * Get the property that owns the room.
     */
    public function property(): BelongsTo
    {
        return $this->belongsTo(Property::class);
    }

    /**
     * Get the facilities for the room.
     */
    public function facilities()
    {
        return $this->hasMany(RoomFacility::class, 'room_id', 'id');
    }


    /**
     * Scope a query to only include available rooms.
     */
    public function scopeAvailable($query)
    {
        return $query->where('is_available', true);
    }

    /**
     * Get the formatted price.
     */
    public function getFormattedPriceAttribute()
    {
        return 'Rp ' . number_format($this->price, 0, ',', '.');
    }

    /**
     * Get all facilities as comma separated string.
     */
    public function getFacilitiesListAttribute()
    {
        return $this->facilities->pluck('facility_name')->join(', ');
    }

    public function roomFacilities()
    {
        return $this->hasMany(RoomFacility::class);
    }
    // app/Models/Room.php
    public function images()
    {
        return $this->hasMany(RoomImage::class);
    }

    public function mainImage()
    {
        return $this->hasOne(RoomImage::class)->where('is_main', true);
    }

    public function getMainImageAttribute()
    {
        return $this->images()->where('is_main', true)->value('image_url');
    }

    public function getGalleryImagesAttribute()
    {
        return $this->images()->where('is_main', false)->pluck('image_url')->toArray();
    }
}
