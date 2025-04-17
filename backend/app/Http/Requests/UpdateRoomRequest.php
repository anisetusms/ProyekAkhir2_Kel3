<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Support\Facades\Gate;

class UpdateRoomRequest extends FormRequest
{
    /**
     * Determine if the user is authorized to make this request.
     */
    public function authorize(): bool
    {
        return Gate::allows('update-room', $this->room);
    }

    /**
     * Get the validation rules that apply to the request.
     *
     * @return array<string, \Illuminate\Contracts\Validation\ValidationRule|array|string>
     */
    public function rules(): array
    {
        return [
            'room_type' => 'sometimes|string|max:100',
            'room_number' => [
                'sometimes',
                'string',
                'max:50',
                'unique:rooms,room_number,'.$this->room->id.',id,property_id,'.$this->room->property_id
            ],
            'price' => 'sometimes|numeric|min:0',
            'size' => 'nullable|string|max:50',
            'capacity' => 'sometimes|integer|min:1',
            'is_available' => 'sometimes|boolean',
            'description' => 'nullable|string',
            'facilities' => 'sometimes|array',
            'facilities.*' => 'string|max:255|distinct',
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
            'room_number' => 'nomor kamar',
            'room_type' => 'tipe kamar',
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
            if ($this->has('facilities') && count($this->facilities) > 10) {
                $validator->errors()->add('facilities', 'Maksimal 10 fasilitas per kamar');
            }
        });
    }
}