<?php

namespace App\Http\Controllers;

use App\Models\Property;
use Illuminate\Http\Request;

class PropertyApiController extends Controller
{
    public function index()
    {
        $properties = Property::with(['propertyType', 'province', 'city', 'district', 'subdistrict'])->get();
        return response()->json($properties);
    }

    public function show($id)
    {
        $property = Property::with(['propertyType', 'province', 'city', 'district', 'subdistrict'])->find($id);
        if (!$property) {
            return response()->json(['message' => 'Properti tidak ditemukan'], 404);
        }
        return response()->json($property);
    }

    public function store(Request $request)
    {
        $property = Property::create($request->all());
        return response()->json($property, 201);
    }

    public function update(Request $request, $id)
    {
        $property = Property::find($id);
        if (!$property) {
            return response()->json(['message' => 'Properti tidak ditemukan'], 404);
        }
        $property->update($request->all());
        return response()->json($property);
    }

    public function destroy($id)
    {
        $property = Property::find($id);
        if (!$property) {
            return response()->json(['message' => 'Properti tidak ditemukan'], 404);
        }
        $property->delete();
        return response()->json(['message' => 'Properti dihapus']);
    }
}