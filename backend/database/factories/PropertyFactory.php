<?php

namespace Database\Factories;

use Illuminate\Database\Eloquent\Factories\Factory;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Str;
use App\Models\User;
use App\Models\Province;
use App\Models\City;
use App\Models\District;
use App\Models\Subdistrict;
use App\Models\KostDetail;
use App\Models\HomestayDetail;
use App\Models\Property;


// database/factories/PropertyFactory.php
class PropertyFactory extends Factory
{
    public function definition()
    {
        return [
            'name' => $this->faker->word,
            'description' => $this->faker->paragraph,
            'user_id' => User::factory(),
            'property_type' => $this->faker->randomElement(['kost', 'homestay']),
            'province_id' => Province::factory(),
            'city_id' => City::factory(),
            'district_id' => District::factory(),
            'subdistrict_id' => Subdistrict::factory(),
            'price' => $this->faker->numberBetween(500000, 5000000),
            'address' => $this->faker->address,
            'latitude' => $this->faker->latitude,
            'longitude' => $this->faker->longitude,
            'isDeleted' => false
        ];
    }

    public function kost()
    {
        return $this->state(function (array $attributes) {
            return [
                'property_type' => 'kost',
            ];
        })->afterCreating(function (Property $property) {
            KostDetail::factory()->create(['property_id' => $property->id]);
        });
    }

    public function homestay()
    {
        return $this->state(function (array $attributes) {
            return [
                'property_type' => 'homestay',
            ];
        })->afterCreating(function (Property $property) {
            HomestayDetail::factory()->create(['property_id' => $property->id]);
        });
    }
}
