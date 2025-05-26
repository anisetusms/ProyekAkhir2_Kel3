<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Property;
use App\Models\KostDetail;
use App\Models\HomestayDetail;
use App\Models\Province;
use App\Models\City;
use App\Models\District;
use App\Models\Subdistrict;
use App\Models\Booking;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Facades\Validator;
use Illuminate\Http\JsonResponse;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Auth;
use App\Http\Requests\StorePropertyRequest;


class PropertyController extends Controller
{
    /**
     * Display a listing of the properties.
     *
     * @return \Illuminate\View\View
     */
    public function index()
    {
        $user_id = Auth::id();
        $stats = DB::select('CALL get_owner_property_stats(?)', [$user_id]);
        $activeProperties = Property::with(['kostDetail', 'homestayDetail', 'province', 'city', 'district', 'subdistrict'])
            ->where('user_id', $user_id)
            ->where('isDeleted', false)
            ->latest()
            ->paginate(10);
        $inactiveProperties = Property::with(['kostDetail', 'homestayDetail', 'province', 'city', 'district', 'subdistrict'])
            ->where('user_id', $user_id)
            ->where('isDeleted', true)
            ->latest()
            ->paginate(10);

        return view('admin.properties.index', [
            'stats' => $stats[0] ?? null,
            'activeProperties' => $activeProperties,
            'inactiveProperties' => $inactiveProperties,
        ]);
    }

    /**
     * Show the form for creating a new property.
     *
     * @return \Illuminate\View\View
     */
    public function create()
    {
        $provinces = Province::all();
        return view('admin.properties.create', compact('provinces'));
    }

    public function dashboard()
    {
        // Mendapatkan ID pengguna yang sedang login
        $user_id = Auth::id();

        // Statistik properti
        $totalProperties = Property::where('user_id', $user_id)->count();
        $activeProperties = Property::where('user_id', $user_id)->where('isDeleted', false)->count();
        $inactiveProperties = Property::where('user_id', $user_id)->where('isDeleted', true)->count();
        $pendingProperties = Property::where('user_id', $user_id)->count(); // Bisa menyesuaikan jika dibutuhkan
        $pendingBookings = Booking::whereHas('property', function ($query) use ($user_id) {
            $query->where('user_id', $user_id);
        })->where('status', 'pending')->count();
        $totalRevenue = Booking::whereHas('property', function ($query) use ($user_id) {
            $query->where('user_id', $user_id);
        })->whereIn('status', ['confirmed', 'completed'])->sum('total_price');

        // Hanya mengambil pemesanan yang terkait dengan properti yang dimiliki oleh pengguna
        $latestBookings = Booking::whereIn('property_id', Property::where('user_id', $user_id)->pluck('id'))
            ->latest() // Urutkan berdasarkan tanggal pembuatan pemesanan terbaru
            ->take(5) // Ambil hanya 5 pemesanan terbaru
            ->get();

        // Data untuk grafik pendapatan bulanan
        $monthlyRevenue = DB::table('bookings')
            ->join('properties', 'bookings.property_id', '=', 'properties.id')
            ->where('properties.user_id', $user_id)
            ->whereIn('bookings.status', ['confirmed', 'completed'])
            ->select(DB::raw('MONTH(bookings.created_at) as month'), DB::raw('SUM(bookings.total_price) as revenue'))
            ->whereYear('bookings.created_at', date('Y'))
            ->groupBy(DB::raw('MONTH(bookings.created_at)'))
            ->orderBy('month')
            ->get();

        $months = [];
        $revenues = [];

        // Inisialisasi array untuk 12 bulan
        for ($i = 1; $i <= 12; $i++) {
            $months[] = date('F', mktime(0, 0, 0, $i, 1));
            $revenues[$i] = 0;
        }

        // Isi data pendapatan yang ada
        foreach ($monthlyRevenue as $data) {
            $revenues[$data->month] = $data->revenue;
        }

        // Konversi ke array untuk chart.js
        $revenueData = array_values($revenues);

        // Statistik tambahan (bisa disesuaikan dengan data yang ada)
        $totalViews = 120;
        $totalMessages = 50;

        // Mengirim data ke tampilan (view)
        return view('admin.properties.dashboard', compact(
            'totalProperties',
            'activeProperties',
            'pendingProperties',
            'latestBookings',
            'totalViews',
            'totalMessages',
            'pendingBookings',
            'inactiveProperties',
            'totalRevenue',
            'months',
            'revenueData'
        ));
    }

    public function store(StorePropertyRequest $request)
    {
        DB::beginTransaction();
        try {
            // Upload image
            $imagePath = $request->hasFile('image')
                ? $request->file('image')->store('properties', 'public')
                : null;

            // Create property
            $property = Property::create([
                'name' => $request->name,
                'description' => $request->description,
                'property_type_id' => $request->property_type_id,
                'user_id' => Auth::id(),
                'province_id' => $request->province_id,
                'city_id' => $request->city_id,
                'district_id' => $request->district_id,
                'subdistrict_id' => $request->subdistrict_id,
                'price' => $request->price,
                'address' => $request->address,
                'latitude' => $request->latitude ?? 0,
                'longitude' => $request->longitude ?? 0,
                'image' => $imagePath,
                'capacity' => $request->capacity,
                'available_rooms' => $request->property_type_id == 1 ? $request->available_rooms : 0,
                'rules' => $request->rules,
                'isDeleted' => false
            ]);

            // Create property type specific details
            if ($request->property_type_id == 1) { // Kost
                KostDetail::create([
                    'property_id' => $property->id,
                    'kost_type' => $request->kost_type,
                    'total_rooms' => $request->total_rooms,
                    'available_rooms' => $request->available_rooms,
                    'rules' => $request->rules ?? ''
                ]);
            } else { // Homestay
                HomestayDetail::create([
                    'property_id' => $property->id,
                    'total_units' => $request->total_units,
                    'available_units' => $request->available_units,
                    'minimum_stay' => $request->minimum_stay,
                    'maximum_guest' => $request->maximum_guest,
                    'checkin_time' => $request->checkin_time,
                    'checkout_time' => $request->checkout_time
                ]);
            }

            DB::commit();

            return redirect()->route('admin.properties.index')
                ->with('success', 'Properti berhasil dibuat!');
        } catch (\Exception $e) {
            DB::rollBack();

            // Delete image if upload failed
            if (isset($imagePath)) {
                Storage::disk('public')->delete($imagePath);
            }

            return redirect()->back()
                ->with('error', 'Gagal membuat properti: ' . $e->getMessage())
                ->withInput();
        }
    }

    /**
     * Display the specified property.
     *
     * @param  int  $id
     * @return \Illuminate\View\View
     */
    public function show($id)
    {
        $property = Property::with(['rooms', 'kostDetail', 'homestayDetail', 'province', 'city', 'district', 'subdistrict'])->findOrFail($id);

        $totalRooms = $property->rooms->count();
        $availableRooms = $property->rooms->where('is_available', true)->count();

        $availablePercentage = $totalRooms > 0
            ? ($availableRooms / $totalRooms) * 100
            : 0;

        return view('admin.properties.show', compact(
            'property',
            'totalRooms',
            'availableRooms',
            'availablePercentage'
        ));
    }

    /**
     * Show the form for editing the specified property.
     *
     * @param  int  $id
     * @return \Illuminate\View\View
     */
    public function edit($id)
    {
        $property = Property::with(['kostDetail', 'homestayDetail', 'province', 'city', 'district', 'subdistrict'])
            ->where('isDeleted', false)
            ->findOrFail($id);

        $provinces = Province::all();
        $cities = City::where('prov_id', $property->province_id)->get();
        $districts = District::where('city_id', $property->city_id)->get();
        $subdistricts = Subdistrict::where('dis_id', $property->district_id)->get();
        $property_type_id = $property->property_type_id;
        return view('admin.properties.edit', compact('property', 'provinces', 'cities', 'districts', 'subdistricts', 'property_type_id'));
    }

    /**
     * Update the specified property in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  int  $id
     * @return \Illuminate\Http\RedirectResponse
     */
    public function update(Request $request, $id)
    {
        $property = Property::where('isDeleted', false)->findOrFail($id);
        $validator = Validator::make($request->all(), [
            'name' => 'required|string|max:255',
            'description' => 'required|string',
            'province_id' => 'required|exists:provinces,id',
            'city_id' => 'required|exists:cities,id',
            'district_id' => 'required|exists:districts,id',
            'subdistrict_id' => 'required|exists:subdistricts,id',
            'price' => 'required|numeric|min:0',
            'address' => 'required|string',
            'latitude' => 'nullable|numeric',
            'longitude' => 'nullable|numeric',
            'image' => 'nullable|image|mimes:jpeg,png,jpg,gif|max:2048',
            'kost_type' => 'required_if:property_type_id,1|in:putra,putri,campur',
            'total_rooms' => 'required_if:property_type_id,1|integer|min:1',
            'available_rooms' => 'required_if:property_type_id,1|integer|min:0',
            'total_units' => 'required_if:property_type_id,2|integer|min:1',
            'available_units' => 'required_if:property_type_id,2|integer|min:0',
            'minimum_stay' => 'required_if:property_type_id,2|integer|min:1',
            'maximum_guest' => 'required_if:property_type_id,2|integer|min:1',
            'checkin_time' => 'required_if:property_type_id,2|date_format:H:i',
            'checkout_time' => 'required_if:property_type_id,2|date_format:H:i',
            'rules' => 'nullable|string',
        ]);

        if ($validator->fails()) {
            return redirect()->back()
                ->withErrors($validator)
                ->withInput()
                ->with('error', 'Terdapat kesalahan pada form. Silakan periksa kembali.');
        }

        DB::beginTransaction();
        try {
            // Update gambar jika ada
            $imagePath = $property->image;
            if ($request->hasFile('image')) {
                // Hapus gambar lama jika ada
                if ($imagePath) {
                    Storage::disk('public')->delete($imagePath);
                }
                $imagePath = $request->file('image')->store('properties', 'public');
            }

            // Update properti dengan default value untuk latitude dan longitude
            $property->update([
                'name' => $request->name,
                'description' => $request->description,
                'province_id' => $request->province_id,
                'city_id' => $request->city_id,
                'district_id' => $request->district_id,
                'subdistrict_id' => $request->subdistrict_id,
                'price' => $request->price,
                'address' => $request->address,
                'latitude' => $request->latitude ?? $property->latitude ?? 0,
                'longitude' => $request->longitude ?? $property->longitude ?? 0,
                'image' => $imagePath,
                'capacity' => $request->property_type_id == 2 ? $request->maximum_guest : null,
                'available_rooms' => $request->property_type_id == 1 ? $request->available_rooms : 0,
                'rules' => $request->rules,
            ]);

            // Update detail berdasarkan tipe properti
            if ($property->property_type_id == 1) { // Kost
                $kostDetail = KostDetail::where('property_id', $property->id)->first();
                if ($kostDetail) {
                    $kostDetail->update([
                        'kost_type' => $request->kost_type,
                        'total_rooms' => $request->total_rooms,
                        'available_rooms' => $request->available_rooms,
                        'rules' => $request->rules,
                    ]);
                } else {
                    KostDetail::create([
                        'property_id' => $property->id,
                        'kost_type' => $request->kost_type,
                        'total_rooms' => $request->total_rooms,
                        'available_rooms' => $request->available_rooms,
                        'rules' => $request->rules,
                    ]);
                }
            } else { // Homestay
                $homestayDetail = HomestayDetail::where('property_id', $property->id)->first();
                if ($homestayDetail) {
                    $homestayDetail->update([
                        'total_units' => $request->total_units,
                        'available_units' => $request->available_units,
                        'minimum_stay' => $request->minimum_stay,
                        'maximum_guest' => $request->maximum_guest,
                        'checkin_time' => $request->checkin_time,
                        'checkout_time' => $request->checkout_time,
                    ]);
                } else {
                    HomestayDetail::create([
                        'property_id' => $property->id,
                        'total_units' => $request->total_units,
                        'available_units' => $request->available_units,
                        'minimum_stay' => $request->minimum_stay,
                        'maximum_guest' => $request->maximum_guest,
                        'checkin_time' => $request->checkin_time,
                        'checkout_time' => $request->checkout_time,
                    ]);
                }
            }

            DB::commit();

            return redirect()->route('admin.properties.show', $property->id)
                ->with('success', 'Properti berhasil diperbarui');
        } catch (\Exception $e) {
            DB::rollBack();

            return redirect()->back()
                ->with('error', 'Gagal memperbarui properti: ' . $e->getMessage())
                ->withInput();
        }
    }

    /**
     * Remove the specified property from storage (soft delete).
     *
     * @param  int  $id
     * @return \Illuminate\Http\RedirectResponse
     */
    public function destroy($id)
    {
        $property = Property::where('isDeleted', false)->findOrFail($id);

        try {
            $property->update(['isDeleted' => true]);

            return redirect()->route('admin.properties.index')
                ->with('success', 'Properti berhasil dinonaktifkan');
        } catch (\Exception $e) {
            return redirect()->back()
                ->with('error', 'Gagal menonaktifkan properti: ' . $e->getMessage());
        }
    }

    public function reactivate($id)
    {
        $property = Property::where('isDeleted', true)->findOrFail($id);

        try {
            $property->update(['isDeleted' => false]);

            return redirect()->route('admin.properties.index')
                ->with('success', 'Properti berhasil diaktifkan kembali');
        } catch (\Exception $e) {
            return redirect()->back()
                ->with('error', 'Gagal mengaktifkan properti: ' . $e->getMessage());
        }
    }

    public function getCities($provinceId): JsonResponse
    {
        try {
            $cities = City::where('prov_id', $provinceId)
                ->select('id', 'city_name as name') // Ubah city_name menjadi name
                ->get();
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
            $districts = District::where('city_id', $cityId)
                ->select('id', 'dis_name as name') // Ubah dis_name menjadi name
                ->get();
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
            $subdistricts = Subdistrict::where('dis_id', $districtId)
                ->select('id', 'subdis_name as name') // Ubah subdis_name menjadi name
                ->get();
            return response()->json($subdistricts);
        } catch (\Exception $e) {
            return response()->json([
                'error' => 'Failed to load subdistricts',
                'details' => $e->getMessage()
            ], 500);
        }
    }
}
