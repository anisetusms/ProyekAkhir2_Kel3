<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;

class UserTypeSeeder extends Seeder
{
    public function run(): void
    {
        // Nonaktifkan foreign key checks
        DB::statement('SET FOREIGN_KEY_CHECKS=0;');

        // Hapus semua data dan reset auto-increment
        DB::table('user_types')->truncate();

        // Masukkan data baru
        DB::table('user_types')->insert([
            ['name' => 'Super Admin'],
            ['name' => 'Owner'],
            ['name' => 'Admin Platform'],
            ['name' => 'Pengguna'],
        ]);

        // Aktifkan kembali foreign key checks
        DB::statement('SET FOREIGN_KEY_CHECKS=1;');
    }
}