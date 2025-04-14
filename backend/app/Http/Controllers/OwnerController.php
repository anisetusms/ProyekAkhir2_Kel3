<?php

namespace App\Http\Controllers;

use App\Models\Property;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Facades\Validator;
use Illuminate\Http\JsonResponse;
use Illuminate\View\View;
use Illuminate\Http\RedirectResponse;

class OwnerController extends Controller
{
    /**
     * Tampilkan halaman dashboard owner.
     */

    public function dashboard_owner()
    {
        return view('owner.dashboard-owner');
    }

    public function showOwnerpage(): View
    {
        $stats = DB::select('CALL get_owner_property_stats(?)', [Auth::id()]);
        return view('owner.dashboard-owner', ['stats' => $stats[0] ?? null]);
    }

    /**
     * Tampilkan daftar properti milik owner.
     */
    public function showPropertypage(): View
    {
        // Ambil data properti milik owner dan ubah jadi Collection
        $properties = collect(DB::select('CALL view_propertiesByidowner(?)', [Auth::id()]));

        // Jika data kosong, arahkan ke view dengan pesan kosong
        if ($properties->isEmpty()) {
            return view('owner.property', [
                'properties' => [],
                'message' => 'Belum ada properti yang ditambahkan.'
            ]);
        }

        // Jika ada data, tampilkan seperti biasa
        return view('owner.property', compact('properties'));
    }


    /**
     * Tampilkan halaman tambah properti.
     */
    public function add_property(): View
    {
        $propertyTypes = DB::select("CALL getPropertyTypes()");
        $provinces = DB::select("CALL getProvinces()");

        return view('owner.add-property', [
            'propertyTypes' => $propertyTypes,
            'provinces' => $provinces,
            'defaultLatitude' => config('app.map_default_lat', -2.5489),
            'defaultLongitude' => config('app.map_default_lng', 118.0149)
        ]);
    }

    /**
     * Simpan properti baru.
     */
    public function store_property(Request $request): RedirectResponse
    {
        $validator = Validator::make($request->all(), [
            'name' => 'required|string|max:255',
            'property_type_id' => 'required|integer|exists:property_types,id',
            'province_id' => 'required|integer|exists:provinces,id',
            'city_id' => 'required|integer|exists:cities,id',
            'district_id' => 'required|integer|exists:districts,id',
            'subdistrict_id' => 'required|integer|exists:subdistricts,id',
            'price' => 'required|numeric|min:1',
            'description' => 'required|string',
            'address' => 'required|string|max:500',
            'capacity' => 'required|integer|min:1',
            'available_rooms' => 'required|integer|min:0|max:' . $request->capacity,
            'latitude' => 'required|numeric',
            'longitude' => 'required|numeric',
            'rules' => 'nullable|string',
            'facilities' => 'nullable|array',
            'facilities.*' => 'string|max:100',
            'featured_image' => 'required|image|mimes:jpeg,png,jpg,gif|max:2048',
            'images' => 'required|array|min:1|max:5',
            'images.*' => 'image|mimes:jpeg,png,jpg,gif|max:2048',
        ], [
            'available_rooms.max' => 'Available rooms cannot exceed total capacity',
            'images.max' => 'Maximum 5 additional images allowed'
        ]);

        if ($validator->fails()) {
            return redirect()->back()
                ->withErrors($validator)
                ->withInput();
        }

        DB::beginTransaction();

        try {
            // Upload gambar utama
            if ($request->hasFile('featured_image')) {
                $path = $request->file('featured_image')->store('public/property_images');
                $imagePath = str_replace('public/', '', $path);
            } else {
                $imagePath = null;
            }

            // Simpan properti utama
            $property = Property::create([
                'name' => $request->name,
                'description' => $request->description,
                'user_id' => Auth::id(),
                'province_id' => $request->province_id,
                'city_id' => $request->city_id,
                'district_id' => $request->district_id,
                'subdistrict_id' => $request->subdistrict_id,
                'price' => $request->price,
                'image' => $imagePath,
                'property_type_id' => $request->property_type_id,
                'capacity' => $request->capacity,
                'available_rooms' => $request->available_rooms,
                'rules' => $request->rules ?? '',
                'address' => $request->address,
                'latitude' => $request->latitude,
                'longitude' => $request->longitude,
            ]);

            // Simpan fasilitas
            if ($request->filled('facilities')) {
                foreach ($request->facilities as $facility) {
                    DB::insert('CALL store_property_facility(?, ?)', [
                        $property->id,
                        $facility
                    ]);
                }
            }

            // Simpan gambar tambahan
            if ($request->hasFile('images')) {
                foreach ($request->file('images') as $image) {
                    $path = $image->store('public/property_images');
                    DB::insert('CALL store_property_image(?, ?)', [
                        $property->id,
                        str_replace('public/', '', $path)
                    ]);
                }
            }

            DB::commit();
            return redirect()->route('owner.property')->with('success', 'Properti berhasil ditambahkan');
        } catch (\Exception $e) {
            DB::rollBack();
            return redirect()->back()
                ->with('error', 'Gagal menyimpan properti: ' . $e->getMessage())
                ->withInput();
        }
    }

    /**
     * Hapus properti.
     */
    public function delete_property(Request $request): RedirectResponse
    {
        $request->validate([
            'property_id' => 'required|integer|exists:properties,id'
        ]);

        try {
            DB::statement('CALL soft_delete_property(?)', [$request->property_id]);
            return redirect()->back()->with('success', 'Properti berhasil diarsipkan');
        } catch (\Exception $e) {
            return redirect()->back()->with('error', 'Gagal menghapus properti: ' . $e->getMessage());
        }
    }

    /**
     * Tampilkan halaman edit properti.
     */
    // public function edit_property($id): View
    // {
    //     $property = collect(DB::select('CALL view_propertyById(?)', [$id]))->first();

    //     if (!$property || $property->user_id != Auth::id()) {
    //         abort(404);
    //     }

    //     $propertyTypes = DB::select("CALL getPropertyTypes()");
    //     $provinces = DB::select("CALL getProvinces()");
    //     $cities = DB::select('CALL getCities(?)', [$property->province_id]);
    //     $districts = DB::select('CALL getDistricts(?)', [$property->city_id]);
    //     $subdistricts = DB::select('CALL getSubdistricts(?)', [$property->district_id]);
    //     $facilities = DB::select('CALL get_property_facilities(?)', [$id]);
    //     $images = DB::select('CALL get_property_images(?)', [$id]);

    //     return view('owner.edit-property', compact(
    //         'property',
    //         'propertyTypes',
    //         'provinces',
    //         'cities',
    //         'districts',
    //         'subdistricts',
    //         'facilities',
    //         'images'
    //     ));
    // }

    public function editProperty($id): View|RedirectResponse
    {
        // Ambil data properti berdasarkan ID
        $property = DB::table('properties')->where('id', $id)->first();

        // Jika properti tidak ditemukan, redirect dengan pesan error
        if (!$property) {
            return redirect()->route('owner.property')->with('error', 'Properti tidak ditemukan.');
        }

        // Tampilkan halaman edit properti
        return view('owner.edit-property', compact('property'));
    }

    /**
     * Update properti.
     */
    public function updateProperty(Request $request, $id): RedirectResponse
    {
        // Validasi input
        $request->validate([
            'name' => 'required|string|max:255',
            'description' => 'required|string',
            'price' => 'required|numeric|min:1',
            'address' => 'required|string',
            'latitude' => 'required|numeric',
            'longitude' => 'required|numeric',
            'rules' => 'nullable|string',
            'featured_image' => 'nullable|image|mimes:jpeg,png,jpg,gif|max:2048',
        ]);

        try {
            // Ambil data properti berdasarkan ID
            $property = DB::table('properties')->where('id', $id)->first();

            if (!$property) {
                return redirect()->route('owner.property')->with('error', 'Properti tidak ditemukan.');
            }

            // Update data properti
            $data = $request->only(['name', 'description', 'price', 'address', 'latitude', 'longitude', 'rules']);

            // Jika ada gambar baru, simpan dan hapus gambar lama
            if ($request->hasFile('featured_image')) {
                $path = $request->file('featured_image')->store('property_images', 'public');
                $data['image'] = $path;

                // Hapus gambar lama jika ada
                if ($property->image) {
                    Storage::disk('public')->delete($property->image);
                }
            }

            DB::table('properties')->where('id', $id)->update($data);

            return redirect()->route('owner.property')->with('success', 'Properti berhasil diperbarui.');
        } catch (\Exception $e) {
            \Log::error('Error saat memperbarui properti:', ['error' => $e->getMessage()]);
            return redirect()->back()->with('error', 'Terjadi kesalahan saat memperbarui properti.');
        }
    }

    /**
     * Get cities by province (AJAX).
     */
    // Update AJAX location methods
    public function getCities($provinceId): JsonResponse
    {
        try {
            $cities = DB::select('CALL getCities(?)', [$provinceId]);
            return response()->json($cities);
        } catch (\Exception $e) {
            return response()->json([
                'error' => 'Failed to load cities',
                'details' => $e->getMessage()
            ], 500);
        }
    }

    public function getDistricts($cityId): JsonResponse
    {
        try {
            $districts = DB::select('CALL getDistricts(?)', [$cityId]);
            return response()->json($districts);
        } catch (\Exception $e) {
            return response()->json([
                'error' => 'Failed to load districts',
                'details' => $e->getMessage()
            ], 500);
        }
    }

    public function getSubdistricts($districtId): JsonResponse
    {
        try {
            $subdistricts = DB::select('CALL getSubdistricts(?)', [$districtId]);
            return response()->json($subdistricts);
        } catch (\Exception $e) {
            return response()->json([
                'error' => 'Failed to load subdistricts',
                'details' => $e->getMessage()
            ], 500);
        }
    }
}
