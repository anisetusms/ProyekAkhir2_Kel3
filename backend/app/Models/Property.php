<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasOne;

class Property extends Model
{
    protected $fillable = [
        'name',
        'description',
        'property_type_id',
        'user_id',
        'province_id',
        'city_id',
        'district_id',
        'subdistrict_id',
        'price',
        'address',
        'latitude',
        'longitude',
        'image',
        'capacity',
        'available_rooms',
        'rules',
        'isDeleted'
    ];

    protected $casts = [
        'price' => 'decimal:2',
        'latitude' => 'decimal:8',
        'longitude' => 'decimal:8',
        'isDeleted' => 'boolean',
        'meal_included' => 'boolean',
        'laundry_included' => 'boolean'
    ];

    // Relationships
    public function propertyType(): BelongsTo
    {
        return $this->belongsTo(PropertyType::class);
    }

    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }

    public function province(): BelongsTo
    {
        return $this->belongsTo(Province::class);
    }

    public function city(): BelongsTo
    {
        return $this->belongsTo(City::class);
    }

    public function district(): BelongsTo
    {
        return $this->belongsTo(District::class);
    }

    public function subdistrict(): BelongsTo
    {
        return $this->belongsTo(Subdistrict::class);
    }

    public function kostDetail(): HasOne
    {
        return $this->hasOne(KostDetail::class);
    }

    public function homestayDetail(): HasOne
    {
        return $this->hasOne(HomestayDetail::class);
    }

    public function rooms()
    {
        return $this->hasMany(Room::class);
    }

    // Accessors
    public function getImageUrlAttribute()
    {
        return $this->image ? asset('storage/'.$this->image) : asset('images/default-property.jpg');
    }

    // Scopes
    public function scopeActive($query)
    {
        return $query->where('isDeleted', false);
    }
}