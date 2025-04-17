<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Property;
use App\Models\Room;
use App\Models\RoomFacility;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
use App\Http\Requests\StoreRoomRequest;
use App\Http\Requests\UpdateRoomRequest;
use Illuminate\Support\Facades\DB;

class RoomController extends Controller
{
    /**
     * Display a listing of the rooms for a property.
     *
     * @param  int  $propertyId
     * @return \Illuminate\View\View
     */
    public function index($propertyId)
    {
        $property = Property::findOrFail($propertyId);
        $rooms = $property->rooms()->with('roomFacilities')->paginate(10);

        return view('admin.properties.rooms.index', compact('rooms', 'property'));
    }

    /**
     * Show the form for creating a new room.
     *
     * @param  int  $propertyId
     * @return \Illuminate\View\View
     */
    public function create($propertyId)
    {
        $property = Property::findOrFail($propertyId);
        // Ambil daftar fasilitas unik dari tabel room_facilities
        $roomFacilities = RoomFacility::select('facility_name')->distinct()->get();

        return view('admin.properties.rooms.create', compact('property', 'roomFacilities'));
    }


    public function store(Request $request, $propertyId)
    {
        // Validasi data ruangan
        $validatedRoomData = $request->validate([
            'room_type' => 'required|string|max:100',
            'room_number' => 'required|string|max:50',
            'price' => 'required|numeric|min:0',
            'size' => 'nullable|string|max:50',
            'capacity' => 'required|integer|min:1',
            'is_available' => 'nullable|boolean',
            'description' => 'nullable|string',
            'facilities' => 'required|array',
            'facilities.*.facility_name' => 'required|string|max:255',
        ]);

        // Tambahkan property_id
        $validatedRoomData['property_id'] = $propertyId;
        $validatedRoomData['is_available'] = $request->input('is_available', true); // Default tersedia

        // Gunakan transaksi untuk memastikan integritas data
        DB::beginTransaction();
        try {
            // Buat ruangan
            $room = Room::create($validatedRoomData);

            // Simpan fasilitas (jika ada)
            if ($request->has('facilities')) {
                foreach ($request->input('facilities') as $facility) {
                    RoomFacility::create([
                        'room_id' => $room->id,
                        'facility_name' => $facility['facility_name'],
                    ]);
                }
            }

            DB::commit();
            return redirect()->route('admin.properties.rooms.index', $propertyId)->with('success', 'Ruangan berhasil ditambah');
        } catch (\Exception $e) {
            DB::rollback();
            return back()->withInput()->withErrors(['error' => 'Gagal menambahkan ruangan: ' . $e->getMessage()]); // Tambahkan pesan error
        }
    }

    /**
     * Display the specified room.
     *
     * @param  int  $propertyId
     * @param  int  $roomId
     * @return \Illuminate\View\View
     */
    public function show($propertyId, $roomId)
    {
        $property = Property::where('isDeleted', false)->findOrFail($propertyId);
        $room = $property->rooms()->with('roomFacilities')->findOrFail($roomId);

        return view('admin.rooms.show', compact('property', 'room'));
    }

    /**
     * Show the form for editing the specified room.
     *
     * @param  int  $propertyId
     * @param  int  $roomId
     * @return \Illuminate\View\View
     */
    public function edit($propertyId, $roomId)
    {
        $property = Property::findOrFail($propertyId);
        $room = Room::findOrFail($roomId);
        $roomFacilities = RoomFacility::select('facility_name')->distinct()->get(); // Ambil semua data fasilitas dari tabel room_facilities

        return view('admin.properties.rooms.edit', compact('room', 'roomFacilities', 'property')); // Teruskan $property ke view
    }

    /**
     * Update the specified room in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  int  $propertyId
     * @param  int  $roomId
     * @return \Illuminate\Http\RedirectResponse
     */
    public function update(Request $request, $propertyId, $roomId)
    {
        // Validasi data ruangan
        $validatedRoomData = $request->validate([
            'room_type' => 'required|string|max:100',
            'room_number' => 'required|string|max:50',
            'price' => 'required|numeric|min:0',
            'is_available' => 'nullable|boolean',
        ]);

        $room = Room::findOrFail($roomId);
        $room->update($validatedRoomData);

        // Update Fasilitas
        $room->roomFacilities()->delete(); // Hapus semua fasilitas terkait sebelumnya

        if ($request->has('facilities')) {
            $facilities = [];
            foreach ($request->input('facilities') as $facility) {
                $facilities[] = [
                    'room_id' => $roomId, // Tambahkan room_id di sini
                    'facility_name' => $facility['facility_name'],
                ];
            }
            $room->roomFacilities()->createMany($facilities);
        }

        return redirect()->route('admin.properties.rooms.index', $propertyId)->with('success', 'Ruangan berhasil diupdate');
    }

    /**
     * Remove the specified room from storage.
     *
     * @param  int  $propertyId
     * @param  int  $roomId
     * @return \Illuminate\Http\RedirectResponse
     */
    public function destroy($propertyId, $roomId)
    {
        $property = Property::where('isDeleted', false)->findOrFail($propertyId);
        $room = $property->rooms()->findOrFail($roomId);

        try {
            $room->delete();

            // Update jumlah kamar tersedia di properti
            $this->updateAvailableRooms($property);

            return redirect()->route('admin.properties.rooms.index', $propertyId)
                ->with('success', 'Kamar berhasil dihapus');
        } catch (\Exception $e) {
            return redirect()->back()
                ->with('error', 'Gagal menghapus kamar: ' . $e->getMessage());
        }
    }

    /**
     * Update available rooms count in property
     *
     * @param  Property  $property
     * @return void
     */
    private function updateAvailableRooms(Property $property)
    {
        if ($property->property_type === 'kost') {
            $availableRooms = $property->rooms()->where('is_available', true)->count();
            $property->detail->update(['available_rooms' => $availableRooms]);
        } else {
            $availableUnits = $property->rooms()->where('is_available', true)->count();
            $property->detail->update(['available_units' => $availableUnits]);
        }
    }
}
