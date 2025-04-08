<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class UserRole extends Model
{
    use HasFactory;

    protected $table = 'user_roles'; // Nama tabel di database

    protected $primaryKey = 'id'; // Primary key tabel

    protected $fillable = [
        'role_name',
    ];
}
