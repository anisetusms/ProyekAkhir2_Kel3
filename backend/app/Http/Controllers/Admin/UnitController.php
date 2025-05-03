<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Property;
use App\Models\Unit;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class UnitController extends Controller
{
    public function create(Property $property)
    {
        return view('admin.properties.units.create', compact('property'));
    }

    public function store(Request $request, Property $property)
    {
        $request->validate([
            'total_units' => 'required|integer|min:1',
            'minimum_stay' => 'required|integer|min:1',
            'maximum_guest' => 'required|integer|min:1',
            'checkin_time' => 'required|date_format:H:i',
            'checkout_time' => 'required|date_format:H:i',
        ]);

        DB::beginTransaction();
        try {
            // Update homestay detail
            $property->homestayDetail()->update([
                'minimum_stay' => $request->minimum_stay,
                'maximum_guest' => $request->maximum_guest,
                'checkin_time' => $request->checkin_time,
                'checkout_time' => $request->checkout_time,
            ]);
            
            // Buat unit
            for ($i = 1; $i <= $request->total_units; $i++) {
                Unit::create([
                    'property_id' => $property->id,
                    'unit_number' => $i,
                    'status' => 'available'
                ]);
            }
            
            DB::commit();
            
            return redirect()->route('admin.properties.show', $property->id)
                ->with('success', 'Unit berhasil ditambahkan');
        } catch (\Exception $e) {
            DB::rollBack();
            return redirect()->back()
                ->with('error', 'Gagal menambahkan unit: ' . $e->getMessage())
                ->withInput();
        }
    }
}