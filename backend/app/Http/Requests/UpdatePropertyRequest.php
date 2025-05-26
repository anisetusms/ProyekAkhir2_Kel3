<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Validation\Rule;

class UpdatePropertyRequest extends FormRequest
{
    /**
     * Determine if the user is authorized to make this request.
     */
    public function authorize(): bool
    {
        // Pastikan user yang mengupdate adalah pemilik properti atau admin
        return $this->user()->can('update', $this->property);
    }

    /**
     * Get the validation rules that apply to the request.
     *
     * @return array<string, \Illuminate\Contracts\Validation\ValidationRule|array|string>
     */
    public function rules(): array
    {
        return [
            'name' => 'sometimes|string|max:255',
            'description' => 'sometimes|string',
            'province_id' => 'sometimes|exists:provinces,id',
            'city_id' => 'sometimes|exists:cities,id',
            'district_id' => 'sometimes|exists:districts,id',
            'subdistrict_id' => 'sometimes|exists:subdistricts,id',
            'price' => 'sometimes|numeric|min:0',
            'address' => 'sometimes|string',
            'latitude' => 'nullable|numeric|between:-90,90',
            'longitude' => 'nullable|numeric|between:-180,180',
            'image' => 'nullable|image|mimes:jpeg,png,jpg,gif|max:2048',
            
            // Kost specific rules
            'kost_type' => 'sometimes|in:putra,putri,campur',
            'total_rooms' => 'sometimes|integer|min:1',
            'rules' => 'nullable|string',
            
            // Homestay specific rules
            'total_units' => 'sometimes|integer|min:1',
            'minimum_stay' => 'sometimes|integer|min:1',
            'maximum_guest' => 'sometimes|integer|min:1',
            'checkin_time' => 'sometimes|date_format:H:i',
            'checkout_time' => 'sometimes|date_format:H:i',
        ];
    }

    /**
     * Get custom attributes for validator errors.
     *
     * @return array
     */
    public function attributes(): array
    {
        return [
            'province_id' => 'provinsi',
            'city_id' => 'kota',
            'district_id' => 'kecamatan',
            'subdistrict_id' => 'kelurahan',
        ];
    }

    /**
     * Configure the validator instance.
     *
     * @param  \Illuminate\Validation\Validator  $validator
     * @return void
     */
    public function withValidator($validator)
    {
        $validator->after(function ($validator) {
            // Validasi tambahan setelah validasi dasar
            if ($this->has('latitude') && !$this->has('longitude')) {
                $validator->errors()->add('longitude', 'Longitude harus diisi jika latitude diisi');
            }

            if ($this->has('longitude') && !$this->has('latitude')) {
                $validator->errors()->add('latitude', 'Latitude harus diisi jika longitude diisi');
            }
        });
    }
}