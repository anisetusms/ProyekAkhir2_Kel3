<?php

// app/Http/Controllers/LocationController.php
namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class LocationController extends Controller
{
    public function getCities($provinceId)
    {
        $cities = DB::select("CALL getCitiesByProvinceId(?)", [$provinceId]);
        return response()->json($cities);
    }

    public function getDistricts($cityId)
    {
        $districts = DB::select("CALL getDistrictsByCityId(?)", [$cityId]);
        return response()->json($districts);
    }

    public function getSubdistricts($districtId)
    {
        $subdistricts = DB::select("CALL getSubdistrictsByDistrictId(?)", [$districtId]);
        return response()->json($subdistricts);
    }
}
