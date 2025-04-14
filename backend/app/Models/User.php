<?php
namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Laravel\Sanctum\HasApiTokens;

class User extends Authenticatable
{
    use HasApiTokens, HasFactory;

    protected $table = 'users'; // opsional kalau nama tabel sesuai konvensi

    protected $fillable = [
        'name',
        'username',
        'phone',
        'address',
        'profile_picture',
        'email',
        'password',
        'is_banned',
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
}
