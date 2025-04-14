<?php

namespace App\Http\Controllers;

use App\Models\Property;
use App\Models\PropertyPrice;
use App\Models\PropertyImage;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Storage;

class UserController extends Controller
{
    /**
     * Tampilkan detail properti berdasarkan ID.
     */
    public function showDetailProperty($id)
    {
        // Panggil Stored Procedure untuk mendapatkan data properti
        $property = DB::select('CALL view_propertyById(?)', [$id]);

        // Pastikan data ditemukan
        if (empty($property)) {
            return redirect()->route('landingpage')->with('error', 'Properti tidak ditemukan.');
        }

        // Ambil data properti pertama
        $property = $property[0];

        // Ambil fasilitas properti
        $facilities = DB::select('CALL view_facilitiesByPropertyId(?)', [$id]);

        // Ambil gambar properti
        $images = DB::select('CALL view_imagesByPropertyId(?)', [$id]);

        // Format data untuk dikirim ke view
        $property->facilities = array_map(function ($facility) {
            return $facility->facility;
        }, $facilities);

        $property->images = array_map(function ($image) {
            return $image->images_path;
        }, $images);

        // Kembalikan view dengan data properti
        return view('detail-property', compact('property'));
    }

    /**
     * Tambahkan properti baru.
     */
    public function storeProperty(Request $request)
    {
        // Validasi input
        $request->validate([
            'name' => 'required|string|max:255',
            'description' => 'nullable|string',
            'subdis_id' => 'required|exists:subdistricts,id',
            'price' => 'required|numeric|min:1',
            'images.*' => 'nullable|file|mimes:jpeg,png,jpg,gif|max:2048',
        ]);

        try {
            // Simpan data properti
            $property = Property::create([
                'name' => $request->name,
                'description' => $request->description,
                'subdis_id' => $request->subdis_id,
            ]);

            // Simpan harga properti
            PropertyPrice::create([
                'property_id' => $property->id,
                'price' => $request->price,
            ]);

            // Simpan gambar properti
            if ($request->hasFile('images')) {
                foreach ($request->file('images') as $image) {
                    $imagePath = $image->store('property_images', 'public');
                    PropertyImage::create([
                        'property_id' => $property->id,
                        'images' => $imagePath,
                    ]);
                }
            }

            return redirect()->route('owner.property')->with('success', 'Properti berhasil ditambahkan.');
        } catch (\Exception $e) {
            return redirect()->back()->with('error', 'Terjadi kesalahan: ' . $e->getMessage());
        }
    }

    /**
     * Hapus properti berdasarkan ID.
     */
    public function deleteProperty($id)
    {
        try {
            // Cari properti berdasarkan ID
            $property = Property::findOrFail($id);

            // Hapus gambar properti dari storage
            $images = PropertyImage::where('property_id', $property->id)->get();
            foreach ($images as $image) {
                Storage::disk('public')->delete($image->images);
                $image->delete();
            }

            // Hapus harga properti
            PropertyPrice::where('property_id', $property->id)->delete();

            // Hapus properti
            $property->delete();

            return redirect()->route('owner.property')->with('success', 'Properti berhasil dihapus.');
        } catch (\Exception $e) {
            return redirect()->back()->with('error', 'Terjadi kesalahan: ' . $e->getMessage());
        }
    }
}
