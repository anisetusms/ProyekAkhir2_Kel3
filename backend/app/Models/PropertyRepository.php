<?php

// app/Repositories/PropertyRepository.php
namespace App\Repositories;

use App\Models\Property;

class PropertyRepository
{
    public function getAll()
    {
        return Property::with(['detail', 'rooms.facilities'])->get();
    }

    public function create(array $data)
    {
        $property = Property::create($data['property']);
        
        if ($data['property']['property_type'] === 'kost') {
            $property->detail()->create($data['kost_detail']);
        } else {
            $property->detail()->create($data['homestay_detail']);
        }
        
        return $property->load('detail');
    }

    // Method lainnya...
}