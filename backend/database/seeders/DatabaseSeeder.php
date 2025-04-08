<?php

namespace Database\Seeders;

use App\Models\User;
// use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;

class DatabaseSeeder extends Seeder
{
    /**
     * Seed the application's database.
     */
    public function run(): void
    {
        // User::factory(10)->create();

        // User::create([
        //     'name' => 'Bambang',
        //     'username' => 'manalu',
        //     'email' => 'bambang@gmail.com',
        //     'password' => Hash::make('bambang19'), 
        //     'user_type_id' => 2, 
        //     'user_role_id' => 2,
        //     'created_at' => now(),
        // ]);

        // User::create([
        //     'name' => 'admin',
        //     'username' => 'admin',
        //     'email' => 'admin@gmail.com',
        //     'password' => Hash::make('admin123'), 
        //     'user_type_id' => 2, 
        //     'user_role_id' => 1,
        //     'created_at' => now(),
        // ]);  

        // User::create([
        //     'name' => 'superadmin',
        //     'username' => 'superadmin',
        //     'email' => 'superadmin@gmail.com',
        //     'password' => Hash::make('superadmin123'), 
        //     'user_type_id' => 1, 
        //     'user_role_id' => 1,
        //     'created_at' => now(),
        // ]);

        User::create([
            'name' => 'adminplatform',
            'username' => 'adminplatform',
            'email' => 'adminplatform@gmail.com',
            'password' => Hash::make('adminplatform123'), 
            'user_type_id' => 4, 
            'user_role_id' => 4,
            'created_at' => now(),
        ]);
    }
}
