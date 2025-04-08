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

        return view('owner.add-property', compact('propertyTypes'));
    }

    /**
     * Simpan properti baru.
     */
    public function store_property(Request $request)
    {
        // Validasi data input
        $validator = Validator::make($request->all(), [
            'name' => 'required|string|max:255',
            'property_type_id' => 'required|integer|exists:property_types,id',
            'subdis_id' => 'required|integer|exists:subdistricts,id',
            'price' => 'required|numeric|min:1',
            'description' => 'required|string',
            'facilities' => 'nullable|array',
            'images' => 'nullable|array',
            'images.*' => 'image|mimes:jpeg,png,jpg,gif|max:2048',
        ]);

        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors()], 422);
        }

        // Ambil user_id dari user yang sedang login
        $userId = auth()->id();

        // Mulai transaksi database
        DB::beginTransaction();

        try {
            // Panggil SP untuk menyimpan data properti dasar
            $dataProperty = json_encode([
                'name' => $request->name,
                'property_type_id' => $request->property_type_id,
                'subdis_id' => $request->subdis_id,
                'description' => $request->description,
                'user_id' => $userId, // Tambahkan user_id
            ]);
            DB::statement('CALL store_propertyy(?)', [$dataProperty]);

            // Ambil ID properti yang baru ditambahkan
            $newPropertyId = DB::select('SELECT LAST_INSERT_ID() as id')[0]->id;

            // Panggil SP untuk menyimpan harga properti
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

            // Simpan gambar satu per satu
            if ($request->hasFile('images')) {
                foreach ($request->file('images') as $image) {
                    $path = $image->store('property_images', 'public'); // Simpan ke storage/app/public/property_images

                    $dataphotoProperty = json_encode([
                        'property_id' => $newPropertyId,
                        'images_path' => $path,
                    ]);
                    DB::statement('CALL store_photoProperty(?)', [$dataphotoProperty]);
                }
            }

            // Commit transaksi
            DB::commit();

            return response()->json(['message' => 'Properti berhasil ditambahkan'], 201);
        } catch (\Exception $e) {
            // Rollback transaksi jika terjadi kesalahan
            DB::rollback();

            return response()->json(['message' => 'Terjadi kesalahan: ' . $e->getMessage()], 500);
        }
    }

    /**
     * Hapus properti berdasarkan ID.
     */
    public function delete_property(Request $request)
    {
        $property_id = $request->input('property_id');

        // Validasi jika property_id kosong
        if (!$property_id) {
            return redirect()->back()->with('error', 'Property ID tidak ditemukan.');
        }

        try {
            // Panggil Stored Procedure untuk menandai properti sebagai dihapus
            DB::statement("CALL delete_property(?)", [$property_id]);

            return redirect()->back()->with('success', 'Properti berhasil dihapus.');
        } catch (\Exception $e) {
            return redirect()->back()->with('error', 'Terjadi kesalahan: ' . $e->getMessage());
        }
    }

    /**
     * Tampilkan halaman edit properti.
     */
    public function edit_property($id)
    {
        // Mengambil data properti menggunakan Stored Procedure
        $property = DB::select("CALL view_propertyById(?)", [$id]);

        // Pastikan data ditemukan
        if (!empty($property)) {
            $property = $property[0]; // Ambil data pertama
        } else {
            return redirect()->route('owner.property')->with('error', 'Properti tidak ditemukan.');
        }

        // Ambil daftar tipe properti untuk dropdown
        $propertyTypes = DB::select("CALL getPropertyTypes()");

        return view('owner.kelola-property', compact('property', 'propertyTypes'));
    }
}
