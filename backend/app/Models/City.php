<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;

class City extends Model
{
    protected $table = 'cities';
    protected $fillable = ['province_id', 'city_name'];

    public function province(): BelongsTo
    {
        return $this->belongsTo(Province::class, 'prov_id');
    }

    public function districts(): HasMany
    {
        return $this->hasMany(District::class, 'city_id');
    }
}