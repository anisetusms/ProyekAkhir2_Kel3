<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Property;

class AdminController extends Controller
{
    public function index()
    {
        $properties = Property::paginate(10);
        return view('admin.properties.index', compact('properties'));
    }

    public function create()
    {
        return view('admin.properties.create');
    }

    public function store(Request $request)
    {
        // Validasi dan simpan
    }

    public function show($id)
    {
        $property = Property::findOrFail($id);
        return view('admin.properties.show', compact('property'));
    }

    public function edit($id)
    {
        $property = Property::findOrFail($id);
        return view('admin.properties.edit', compact('property'));
    }

    public function update(Request $request, $id)
    {
        // Validasi dan update
    }

    public function destroy($id)
    {
        // Hapus data
    }
}
