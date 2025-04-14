<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class PropertyPrice extends Model
{
    use HasFactory;

    protected $table = 'property_prices'; // Nama tabel
    protected $fillable = [
        'property_id',
        'price',
    ];
}