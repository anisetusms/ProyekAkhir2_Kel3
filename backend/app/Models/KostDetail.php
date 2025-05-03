<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class KostDetail extends Model
{
    use HasFactory;

    protected $fillable = [
        'property_id',
        'kost_type',
        'total_rooms',
        'available_rooms',
        'rules',
        'meal_included',
        'laundry_included'
    ];

    protected $casts = [
        'meal_included' => 'boolean',
        'laundry_included' => 'boolean'
    ];

    /**
     * Get the property that owns the kost detail.
     */
    public function property(): BelongsTo
    {
        return $this->belongsTo(Property::class);
    }

    /**
     * Get the kost type as a readable string.
     */
    public function getKostTypeNameAttribute()
    {
        return [
            'putra' => 'Putra',
            'putri' => 'Putri',
            'campur' => 'Campur'
        ][$this->kost_type] ?? $this->kost_type;
    }
}