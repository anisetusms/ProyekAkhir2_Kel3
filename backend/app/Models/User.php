<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Laravel\Sanctum\HasApiTokens;
use Carbon\Carbon;
use Illuminate\Support\Facades\Hash;

class User extends Authenticatable
{
    use HasApiTokens, HasFactory;

    protected $fillable = [
        'name',
        'username',
        'phone',
        'address',
        'profile_picture',
        'email',
        'password',
        'is_banned',
        'status',
        'user_type_id',
        'user_role_id',
    ];

    protected $hidden = [
        'password',
        'remember_token',
    ];

    protected $casts = [
        'email_verified_at' => 'datetime',
        'is_banned' => 'boolean',
    ];

    // Relasi ke UserRole (user_role_id)
    public function role()
    {
        return $this->belongsTo(UserRole::class, 'user_role_id');
    }

    public function properties()
    {
        return $this->hasMany(Property::class, 'user_id');
    }
}
