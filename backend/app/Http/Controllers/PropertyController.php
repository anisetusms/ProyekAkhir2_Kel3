<?php

namespace App\Http\Controllers;

use App\Models\Property;

class PropertyController extends Controller
{
    public function showDetailProperty($id)
    {
        $property = Property::with(['price', 'images']) // Ambil relasi harga dan gambar
            ->where('id', $id)
            ->firstOrFail();

        return view('detail-property', [
            'property' => (object) [
                'id' => $property->id,
                'name' => $property->name,
                'description' => $property->description,
                'price' => $property->price->price ?? 0, // Ambil harga dari relasi
                'image' => $property->images->first()->images ?? null, // Ambil gambar pertama dari relasi
            ],
        ]);
    }
}