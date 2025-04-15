<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Validation\Rule;

class StorePropertyRequest extends FormRequest
{
    /**
     * Determine if the user is authorized to make this request.
     */
    public function authorize(): bool
    {
        return true; // Ganti dengan logika authorization jika diperlukan
    }

    /**
     * Get the validation rules that apply to the request.
     *
     * @return array<string, \Illuminate\Contracts\Validation\ValidationRule|array|string>
     */
    public function rules(): array
    {
        return [
            'name' => 'required|string|max:255',
            'description' => 'required|string',
            'property_type' => ['required', Rule::in(['kost', 'homestay'])],
            'user_id' => 'required|exists:users,id',
            'province_id' => 'required|exists:provinces,id',
            'city_id' => 'required|exists:cities,id',
            'district_id' => 'required|exists:districts,id',
            'subdistrict_id' => 'required|exists:subdistricts,id',
            'price' => 'required|numeric|min:0',
            'address' => 'required|string',
            'latitude' => 'nullable|numeric|between:-90,90',
            'longitude' => 'nullable|numeric|between:-180,180',
            'image' => 'nullable|image|mimes:jpeg,png,jpg,gif|max:2048',
            
            // Kost specific rules
            'kost_type' => 'required_if:property_type,kost|in:putra,putri,campur',
            'total_rooms' => 'required_if:property_type,kost|integer|min:1',
            'rules' => 'nullable|string',
            'meal_included' => 'nullable|boolean',
            'laundry_included' => 'nullable|boolean',
            
            // Homestay specific rules
            'total_units' => 'required_if:property_type,homestay|integer|min:1',
            'minimum_stay' => 'required_if:property_type,homestay|integer|min:1',
            'maximum_guest' => 'required_if:property_type,homestay|integer|min:1',
            'checkin_time' => 'required_if:property_type,homestay|date_format:H:i',
            'checkout_time' => 'required_if:property_type,homestay|date_format:H:i',
        ];
    }

    /**
     * Get custom messages for validator errors.
     *
     * @return array
     */
    public function messages(): array
    {
        return [
            'name.required' => 'Nama properti wajib diisi',
            'property_type.in' => 'Tipe properti harus berupa kost atau homestay',
            'kost_type.required_if' => 'Tipe kost wajib diisi untuk properti kost',
            'total_rooms.required_if' => 'Jumlah kamar wajib diisi untuk properti kost',
            'total_units.required_if' => 'Jumlah unit wajib diisi untuk properti homestay',
            'checkin_time.required_if' => 'Waktu check-in wajib diisi untuk homestay',
            'checkout_time.required_if' => 'Waktu check-out wajib diisi untuk homestay',
            'image.max' => 'Ukuran gambar tidak boleh lebih dari 2MB',
        ];
    }

    /**
     * Prepare the data for validation.
     */
    protected function prepareForValidation()
    {
        // Set user_id dari user yang sedang login jika tidak disediakan
        if (!$this->has('user_id')) {
            $this->merge([
                'user_id' => request()->user_id()
            ]);
        }

        // Konversi boolean fields
        $this->merge([
            'meal_included' => $this->boolean('meal_included'),
            'laundry_included' => $this->boolean('laundry_included'),
        ]);
    }
}