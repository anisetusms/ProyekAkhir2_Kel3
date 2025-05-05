<?php
namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Laravel\Sanctum\HasApiTokens;
use Carbon\Carbon;
use Illuminate\Support\Facades\Hash;

class UserApi extends Authenticatable
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

    // // Relasi ke UserType (user_type_id)
    // public function userType()
    // {
    //     return $this->belongsTo(UserType::class, 'user_type_id');
    // }

    // // Mutator untuk hashing password
    // public function setPasswordAttribute($password)
    // {
    //     $this->attributes['password'] = Hash::make($password);
    // }

    // // Mutator untuk email_verified_at
    // public function setEmailVerifiedAtAttribute($value)
    // {
    //     $this->attributes['email_verified_at'] = $value ? Carbon::now() : null;
    // }
}