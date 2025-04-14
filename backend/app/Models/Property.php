<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Property extends Model
{
    use HasFactory;

    protected $fillable = [
        'name',
        'description',
        'user_id',
        'province_id',
        'city_id',
        'district_id',
        'subdistrict_id',
        'price',
        'image',
        'property_type_id',
        'capacity',
        'available_rooms',
        'rules',
        'address',
        'latitude',
        'longitude',
    ];
}