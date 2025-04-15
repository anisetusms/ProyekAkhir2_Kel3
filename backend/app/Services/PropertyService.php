<?php

// app/Services/PropertyService.php
namespace App\Services;

use App\Repositories\PropertyRepository;

class PropertyService
{
    protected $propertyRepo;

    public function __construct(PropertyRepository $propertyRepo)
    {
        $this->propertyRepo = $propertyRepo;
    }

    public function createProperty(array $data)
    {
        // Validasi bisnis logic disini
        return $this->propertyRepo->create($data);
    }

    // Method lainnya...
}