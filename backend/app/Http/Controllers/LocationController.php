<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class LocationController extends Controller
{
    /**
     * Tambahkan Provinsi
     */
    public function storeProvinces(Request $request)
    {
        $request->validate([
            'prov_name' => 'required|string|max:100'
        ]);

        try {
            DB::statement("CALL insert_province(?)", [$request->prov_name]);

            return response()->json(['message' => 'Provinsi berhasil ditambahkan'], 201);
        } catch (\Exception $e) {
            return response()->json(['message' => 'Terjadi kesalahan saat menambahkan provinsi', 'error' => $e->getMessage()], 500);
        }
    }

    /**
     * Tambahkan Kota/Kabupaten
     */
    public function storeCities(Request $request)
    {
        $request->validate([
            'city_name' => 'required|string|max:100',
            'prov_id' => 'required|exists:provinces,id'
        ]);

        try {
            DB::statement("CALL insert_city(?, ?)", [$request->city_name, $request->prov_id]);

            return response()->json(['message' => 'Kota/Kabupaten berhasil ditambahkan'], 201);
        } catch (\Exception $e) {
            return response()->json(['message' => 'Terjadi kesalahan saat menambahkan kota/kabupaten', 'error' => $e->getMessage()], 500);
        }
    }

    /**
     * Tambahkan Kecamatan
     */
    public function storeDistricts(Request $request)
    {
        $request->validate([
            'district_name' => 'required|string|max:100',
            'city_id' => 'required|exists:cities,id'
        ]);

        try {
            DB::statement("CALL insert_district(?, ?)", [$request->district_name, $request->city_id]);

            return response()->json(['message' => 'Kecamatan berhasil ditambahkan'], 201);
        } catch (\Exception $e) {
            return response()->json(['message' => 'Terjadi kesalahan saat menambahkan kecamatan', 'error' => $e->getMessage()], 500);
        }
    }

    /**
     * Tambahkan Kelurahan
     */
    public function storeSubdistricts(Request $request)
    {
        $request->validate([
            'subdistrict_name' => 'required|string|max:100',
            'district_id' => 'required|exists:districts,id'
        ]);

        try {
            DB::statement("CALL insert_subdistrict(?, ?)", [$request->subdistrict_name, $request->district_id]);

            return response()->json(['message' => 'Kelurahan berhasil ditambahkan'], 201);
        } catch (\Exception $e) {
            return response()->json(['message' => 'Terjadi kesalahan saat menambahkan kelurahan', 'error' => $e->getMessage()], 500);
        }
    }

    /**
     * Ambil Semua Provinsi
     */
    public function getProvinces()
    {
        try {
            $provinces = DB::select("CALL getProvinces()");
            return response()->json($provinces);
        } catch (\Exception $e) {
            return response()->json(['message' => 'Terjadi kesalahan saat mengambil data provinsi', 'error' => $e->getMessage()], 500);
        }
    }

    /**
     * Ambil Semua Kota/Kabupaten Berdasarkan Provinsi
     */
    public function getCities($provinceId)
    {
        $cities = DB::select('CALL getCities(?)', [$provinceId]);
        return response()->json($cities);
    }

    /**
     * Ambil Semua Kecamatan Berdasarkan Kota/Kabupaten
     */
    public function getDistricts($city_id)
    {
        try {
            $districts = DB::select("CALL getDistricts(?)", [$city_id]);
            return response()->json($districts);
        } catch (\Exception $e) {
            return response()->json(['message' => 'Terjadi kesalahan saat mengambil data kecamatan', 'error' => $e->getMessage()], 500);
        }
    }

    /**
     * Ambil Semua Kelurahan Berdasarkan Kecamatan
     */
    public function getSubdistricts($district_id)
    {
        try {
            $subdistricts = DB::select("CALL getSubdistricts(?)", [$district_id]);
            return response()->json($subdistricts);
        } catch (\Exception $e) {
            return response()->json(['message' => 'Terjadi kesalahan saat mengambil data kelurahan', 'error' => $e->getMessage()], 500);
        }
    }
}
