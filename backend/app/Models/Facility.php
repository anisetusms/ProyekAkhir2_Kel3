<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Facility extends Model
{
    use HasFactory;

    // Kolom yang boleh diisi (mass assignment)
    protected $fillable = ['name'];

    // Relasi many-to-many dengan model Property
    public function properties()
    {
        return $this->belongsToMany(
            Property::class,       // Model yang berelasi
            'property_facilities', // Nama tabel pivot
            'facility_id',         // FK untuk facility di tabel pivot
            'property_id'          // FK untuk property di tabel pivot
        );
    }
}