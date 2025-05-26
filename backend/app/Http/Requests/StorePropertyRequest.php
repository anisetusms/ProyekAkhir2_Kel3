<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class StorePropertyRequest extends FormRequest
{
    public function authorize()
    {
        return true;
    }

    public function rules()
    {
        $rules = [
            'name' => 'required|string|max:255',
            'description' => 'required|string',
            'property_type_id' => 'required|exists:property_types,id',
            'province_id' => 'required|exists:provinces,id',
            'city_id' => 'required|exists:cities,id',
            'district_id' => 'required|exists:districts,id',
            'subdistrict_id' => 'required|exists:subdistricts,id',
            'price' => 'required|numeric|min:0',
            'address' => 'required|string',
            'latitude' => 'required|numeric',
            'longitude' => 'required|numeric',
            'image' => 'nullable|image|mimes:jpeg,png,jpg,gif|max:2048',
            'capacity' => 'required|integer|min:1',
            'available_rooms' => 'required_if:property_type_id,1|nullable|numeric|min:0',
            'rules' => 'nullable|string',
        ];

        $typeSpecificRules = match ($this->property_type_id) {
            1 => [ // Kost
                'kost_type' => 'required|in:putra,putri,campur',
                'total_rooms' => 'required|integer|min:1',
            ],
            2 => [ // Homestay
                'total_units' => 'required|integer|min:1',
                'available_units' => 'required|numeric',
                'minimum_stay' => 'required|integer|min:1',
                'maximum_guest' => 'required|integer|min:1',
                'checkin_time' => 'required|date_format:H:i',
                'checkout_time' => 'required|date_format:H:i',
            ],
            default => [], // Default rules jika property_type_id tidak 1 atau 2
        };

        return array_merge($rules, $typeSpecificRules);
    }
}