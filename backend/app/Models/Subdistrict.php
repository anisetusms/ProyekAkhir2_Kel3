<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class Subdistrict extends Model
{
    protected $table = 'subdistricts';
    protected $fillable = ['subdis_name', 'dis_id'];

    public function district(): BelongsTo
    {
        return $this->belongsTo(District::class, 'dis_id');
    }
}