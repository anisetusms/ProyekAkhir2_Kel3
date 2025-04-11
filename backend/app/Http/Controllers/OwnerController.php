<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Validator;

class OwnerController extends Controller
{
    /**
     * Tampilkan halaman dashboard owner.
     */
    public function showOwnerpage()
    {
        return view('owner.dashboard-owner');
    }

    /** 
     * Tampilkan daftar properti milik owner.
     */
    public function showPropertypage()
    {
        $userId = auth()->id(); // Ambil ID pengguna yang sedang login

        // Panggil Stored Procedure untuk mengambil properti berdasarkan ID owner
        $properties = DB::select('CALL view_propertiesByidowner(?)', [$userId]);

        return view('owner.property', compact('properties'));
    }

    /**
     * Tampilkan halaman tambah properti.
     */
    public function add_property()
    {
        // Ambil daftar tipe properti untuk dropdown
        $propertyTypes = DB::select("CALL getPropertyTypes()");

        // Ambil daftar provinsi untuk dropdown
        $provinces = DB::select("CALL getProvinces()");
        $cities = [];
        $districts = [];

        return view('owner.add-property', compact('propertyTypes', 'provinces', 'cities', 'districts'));
    }
    

    /**
     * Simpan properti baru.
     */
    public function store_property(Request $request)
    {
        // Validasi data input
        $request->validate([
            'name' => 'required|string|max:255',
            'property_type_id' => 'required|integer|exists:property_types,id',
            'province_id' => 'required|integer|exists:provinces,id',
            'city_id' => 'required|integer|exists:cities,id',
            'district_id' => 'required|integer|exists:districts,id',
            'subdis_id' => 'required|integer|exists:subdistricts,id',
            'price' => 'required|numeric|min:1',
            'description' => 'required|string',
            'facilities' => 'nullable|array',
            'images' => 'nullable|array',
            'images.*' => 'image|mimes:jpeg,png,jpg,gif|max:2048',
        ]);

        $userId = auth()->id(); // Ambil user_id dari user yang sedang login

        // Mulai transaksi database
        DB::beginTransaction();

        try {
            // Simpan data properti dasar
            $dataProperty = json_encode([
                'name' => $request->name,
                'property_type_id' => $request->property_type_id,
                'province_id' => $request->province_id,
                'city_id' => $request->city_id,
                'district_id' => $request->district_id,
                'subdis_id' => $request->subdis_id,
                'description' => $request->description,
                'user_id' => $userId,
            ]);
            DB::statement('CALL store_propertyy(?)', [$dataProperty]);

            // Ambil ID properti yang baru ditambahkan
            $newPropertyId = DB::select('SELECT LAST_INSERT_ID() as id')[0]->id;

            // Simpan harga properti
            $datapriceProperty = json_encode([
                'property_id' => $newPropertyId,
                'price' => $request->price,
            ]);
            DB::statement('CALL store_priceProperty(?)', [$datapriceProperty]);

            // Simpan fasilitas satu per satu
            if ($request->filled('facilities')) {
                foreach ($request->facilities as $facility) {
                    $dataFacilitiesProperty = json_encode([
                        'property_id' => $newPropertyId,
                        'facility' => $facility,
                    ]);
                    DB::statement('CALL store_facilitiesProperty(?)', [$dataFacilitiesProperty]);
                }
            }

            // Simpan gambar properti
            if ($request->hasFile('images')) {
                foreach ($request->file('images') as $image) {
                    $path = $image->store('property_images', 'public'); // Pastikan folder public/storage ada

                    $dataphotoProperty = json_encode([
                        'property_id' => $newPropertyId,
                        'images_path' => $path,
                    ]);
                    DB::statement('CALL store_photoProperty(?)', [$dataphotoProperty]);
                }
            }

            DB::commit(); // Commit transaksi
            return redirect()->route('owner.property')->with('success', 'Properti berhasil ditambahkan');
        } catch (\Exception $e) {
            DB::rollback(); // Rollback jika terjadi kesalahan
            return redirect()->back()->with('error', 'Terjadi kesalahan: ' . $e->getMessage());
        }
    }

    /**
     * Hapus properti berdasarkan ID.
     */
    public function delete_property(Request $request)
    {
        $property_id = $request->input('property_id');

        if (!$property_id) {
            return redirect()->back()->with('error', 'Property ID tidak ditemukan.');
        }

        try {
            DB::statement("CALL delete_property(?)", [$property_id]);
            return redirect()->back()->with('success', 'Properti berhasil dihapus.');
        } catch (\Exception $e) {
            return redirect()->back()->with('error', 'Terjadi kesalahan: ' . $e->getMessage());
        }
    }

    /**
     * Tampilkan halaman edit properti.
     */
    public function edit_property(Request $request, $id)
    {
        $property = DB::select("CALL view_propertyById(?)", [$id]);

        // Ambil data provinsi
        $provinces = DB::select("CALL getProvinces()");
        $cityId = $request->input('city_id');
        $districts = [];

        // Jika ada city_id, ambil kota dan kecamatan terkait
        if ($cityId) {
            $cities = DB::select('CALL getCities(?)', [$cityId]);
            $districts = DB::select('CALL getDistricts(?)', [$cityId]);
        }

        return view('owner.kelola-property', compact('property', 'provinces', 'cities', 'districts'));
    }

    public function getCities($provinceId)
    {
        $cities = DB::select('CALL getCities(?)', [$provinceId]);
        return response()->json($cities);
    }

    public function showCities($provinceId)
    {
        $cities = DB::select('CALL getCities(?)', [$provinceId]);
        return response()->json($cities);
    }
}
