<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;

class UserTypeSeeder extends Seeder
{
    public function run(): void
    {
        DB::table('user_types')->insert([
            ['name' => 'Super Admin'],
            ['name' => 'Admin'],
            ['name' => 'Pemilik Kost'],
            ['name' => 'Pengguna'],
        ]);
    }
}
