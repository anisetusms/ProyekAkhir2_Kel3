<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\HasMany;

class PropertyType extends Model
{
    protected $fillable = ['name'];

    // Menambahkan konstanta untuk tipe properti
    const TYPE_KOST = 1;
    const TYPE_HOMESTAY = 2;

    public function properties()
    {
        return $this->hasMany(Property::class);
    }
}
