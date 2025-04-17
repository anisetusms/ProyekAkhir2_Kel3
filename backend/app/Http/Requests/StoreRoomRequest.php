<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Support\Facades\Gate;

class StoreRoomRequest extends FormRequest
{
    /**
     * Determine if the user is authorized to make this request.
     */
    public function authorize(): bool
    {
        return Gate::allows('create-room', $this->property);
    }

    /**
     * Get the validation rules that apply to the request.
     *
     * @return array<string, \Illuminate\Contracts\Validation\ValidationRule|array|string>
     */
    public function rules(): array
    {
        return [
            'room_type' => 'required|string|max:100',
            'room_number' => [
                'required',
                'string',
                'max:50',
                'unique:rooms,room_number,NULL,id,property_id,'.$this->property->id
            ],
            'price' => 'required|numeric|min:0',
            'size' => 'nullable|string|max:50',
            'capacity' => 'required|integer|min:1',
            'is_available' => 'sometimes|boolean',
            'description' => 'nullable|string',
            'facilities' => 'sometimes|array',
            'facilities.*' => 'string|max:255|distinct',
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
            'room_number.unique' => 'Nomor kamar sudah digunakan di properti ini',
            'price.min' => 'Harga tidak boleh negatif',
            'capacity.min' => 'Kapasitas minimal 1 orang',
            'facilities.*.distinct' => 'Fasilitas tidak boleh duplikat',
        ];
    }

    /**
     * Prepare the data for validation.
     */
    protected function prepareForValidation()
    {
        $this->merge([
            'is_available' => $this->boolean('is_available'),
        ]);
    }
}