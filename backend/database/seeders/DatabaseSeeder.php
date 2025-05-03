<?php

namespace Database\Seeders;

use App\Models\User;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;

class DatabaseSeeder extends Seeder
{
    public function run(): void
    {
        // Nonaktifkan foreign key checks
        DB::statement('SET FOREIGN_KEY_CHECKS=0;');

        // Hapus data di tabel properties
        DB::table('properties')->truncate();

        // Hapus data di tabel users
        DB::table('users')->truncate();

        // Panggil seeder untuk UserType dan UserRole
        $this->call([
            UserTypeSeeder::class,
            UserRoleSeeder::class,
        ]);

        // Masukkan data pengguna
        $hashedPassword = Hash::make('bambang19');

        User::create([
            'name' => 'Bambang',
            'username' => 'manalu',
            'email' => 'bambang@gmail.com',
            'phone' => '081234567890',
            'address' => 'Simangulampe',
            'profile_picture' => null,
            'password' => $hashedPassword,
            'user_type_id' => 2,
            'user_role_id' => 2,
            'is_banned' => false,
            'created_at' => now(),
        ]);

        $hashedPassword = Hash::make('adminplatform123');

        User::create([
            'name' => 'adminplatform',
            'username' => 'adminplatform',
            'email' => 'adminplatform@gmail.com',
            'phone' => '081234567891',
            'address' => 'Aekraja No. 1',
            'profile_picture' => null,
            'password' => $hashedPassword,
            'user_type_id' => 3,
            'user_role_id' => 3,
            'is_banned' => false,
            'created_at' => now(),
        ]);
        $hashedPassword = Hash::make('superadmin123');
        
        User::create([
            'name' => 'superadmin',
            'username' => 'superadmin',
            'email' => 'superadmin@gmail.com',
            'phone' => '081234567892',
            'address' => 'Jl. Superadmin No. 1',
            'profile_picture' => null,
            'password' => $hashedPassword,
            'user_type_id' => 1,
            'user_role_id' => 1,
            'is_banned' => false,
            'created_at' => now(),
        ]);

        $hashedPassword = Hash::make('penyewa123');

        User::create([
            'name' => 'penyewa1',
            'username' => 'penyewa1',
            'email' => 'penyewa@gmail.com',
            'phone' => '081234567893',
            'address' => 'WaterKing',
            'profile_picture' => null,
            'password' => $hashedPassword,
            'user_type_id' => 4,
            'user_role_id' => 4,
            'is_banned' => false,
            'created_at' => now(),
        ]);

        // Aktifkan kembali foreign key checks
        DB::statement('SET FOREIGN_KEY_CHECKS=1;');
    }
}