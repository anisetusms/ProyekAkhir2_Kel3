<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Property extends Model
{
    use HasFactory;

    protected $table = 'properties'; // Nama tabel
    protected $fillable = [
        'user_id',
        'name',
        'property_type_id',
        'subdis_id',
        'description',
        'isDeleted',
    ];

    // Relasi ke tabel property_prices
    public function price()
    {
        return $this->hasOne(PropertyPrice::class, 'property_id');
    }

    // Relasi ke tabel property_images
    public function images()
    {
        return $this->hasMany(PropertyImage::class, 'property_id');
    }
}