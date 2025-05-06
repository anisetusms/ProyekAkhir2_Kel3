<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Property;
use App\Models\KostDetail;
use App\Models\HomestayDetail;
use App\Models\Province;
use App\Models\RecentSearch;
use App\Models\City;
use App\Models\District;
use App\Models\Subdistrict;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Facades\Validator;
use Illuminate\Http\JsonResponse;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Auth;

class PropertyPenywaApiController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        $user_id = Auth::id();

        $properties = Property::with(['kostDetail', 'homestayDetail', 'province', 'city', 'district', 'subdistrict'])
            ->where('isDeleted', false)
            ->latest()
            ->get();

        return response()->json($properties);
    }

    public function search(Request $request)
    {
        $keyword = $request->query('keyword');
        
        if (!$keyword) {
            return response()->json(['message' => 'Keyword is required'], 400);
        }
    
        // Simpan keyword ke recent search
        RecentSearch::create([
            'user_id' => auth()->check() ? auth()->id() : null,
            'keyword' => $keyword
        ]);
    
        // Pencarian properti + relasi lokasi
        $result = Property::with(['kostDetail', 'homestayDetail', 'province', 'city', 'district', 'subdistrict', 'propertyType'])
            ->where('isDeleted', false)
            ->where(function ($query) use ($keyword) {
                $query->where('name', 'like', "%{$keyword}%")
                      ->orWhereHas('province', fn($q) => $q->where('prov_name', 'like', "%{$keyword}%"))
                      ->orWhereHas('city', fn($q) => $q->where('city_name', 'like', "%{$keyword}%"))
                      ->orWhereHas('district', fn($q) => $q->where('dis_name', 'like', "%{$keyword}%"))
                      ->orWhereHas('subdistrict', fn($q) => $q->where('subdis_name', 'like', "%{$keyword}%"))
                      ->orWhereHas('propertytype', fn($q) => $q->where('name', 'like', "%{$keyword}%"));
            })
            ->get();
    
            return response()->json([
                'data' => $result
            ]);
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        //
    }

    /**
     * Display the specified resource.
     */
    public function show($id)
    {
        // Mencari properti berdasarkan ID yang diberikan
        $property = Property::active()->findOrFail($id);

        // Mengembalikan data properti dalam format JSON
        return response()->json([
            'status' => 'success',
            'message' => 'Data properti berhasil diambil',
            'data' => $property
        ]);
        
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, string $id)
    {
        //
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(string $id)
    {
        //
    }

    
}
