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
        $property = Property::where('isDeleted', false)->findOrFail($propertyId);
        $rooms = $property->rooms()->with('facilities')->latest()->paginate(10);

        return view('admin.rooms.index', compact('property', 'rooms'));
    }

    /**
     * Show the form for creating a new room.
     *
     * @param  int  $propertyId
     * @return \Illuminate\View\View
     */
    public function create($propertyId)
    {
        $property = Property::where('isDeleted', false)->findOrFail($propertyId);
        return view('admin.rooms.create', compact('property'));
    }

    /**
     * Store a newly created room in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  int  $propertyId
     * @return \Illuminate\Http\RedirectResponse
     */
    public function store(StoreRoomRequest $request, Property $property, $propertyId)
    {
        $property = Property::where('isDeleted', false)->findOrFail($propertyId);

        $validator = Validator::make($request->all(), [
            'room_type' => 'required|string|max:100',
            'room_number' => 'required|string|max:50|unique:rooms,room_number,NULL,id,property_id,' . $propertyId,
            'price' => 'required|numeric|min:0',
            'size' => 'nullable|string|max:50',
            'capacity' => 'required|integer|min:1',
            'is_available' => 'sometimes|boolean',
            'description' => 'nullable|string',
            'facilities' => 'sometimes|array',
            'facilities.*' => 'string|max:255',
        ]);

        if ($validator->fails()) {
            return redirect()->back()
                ->withErrors($validator)
                ->withInput();
        }

        try {
            // Buat kamar
            $room = Room::create([
                'property_id' => $propertyId,
                'room_type' => $request->room_type,
                'room_number' => $request->room_number,
                'price' => $request->price,
                'size' => $request->size,
                'capacity' => $request->capacity,
                'is_available' => $request->is_available ?? true,
                'description' => $request->description,
            ]);

            // Tambahkan fasilitas jika ada
            if ($request->has('facilities')) {
                foreach ($request->facilities as $facility) {
                    RoomFacility::create([
                        'room_id' => $room->id,
                        'facility_name' => $facility
                    ]);
                }
            }

            // Update jumlah kamar tersedia di properti
            $this->updateAvailableRooms($property);

            return redirect()->route('admin.properties.rooms.show', [$propertyId, $room->id])
                ->with('success', 'Kamar berhasil ditambahkan');
        } catch (\Exception $e) {
            return redirect()->back()
                ->with('error', 'Gagal menambahkan kamar: ' . $e->getMessage())
                ->withInput();
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
        $room = $property->rooms()->with('facilities')->findOrFail($roomId);

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
        $property = Property::where('isDeleted', false)->findOrFail($propertyId);
        $room = $property->rooms()->with('facilities')->findOrFail($roomId);

        return view('admin.rooms.edit', compact('property', 'room'));
    }

    /**
     * Update the specified room in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  int  $propertyId
     * @param  int  $roomId
     * @return \Illuminate\Http\RedirectResponse
     */
    public function update(Request $request, Property $property, Room $room,$propertyId, $roomId)
    {
        $property = Property::where('isDeleted', false)->findOrFail($propertyId);
        $room = $property->rooms()->findOrFail($roomId);

        $validator = Validator::make($request->all(), [
            'room_type' => 'sometimes|string|max:100',
            'room_number' => 'sometimes|string|max:50|unique:rooms,room_number,' . $roomId . ',id,property_id,' . $propertyId,
            'price' => 'sometimes|numeric|min:0',
            'size' => 'nullable|string|max:50',
            'capacity' => 'sometimes|integer|min:1',
            'is_available' => 'sometimes|boolean',
            'description' => 'nullable|string',
            'facilities' => 'sometimes|array',
            'facilities.*' => 'string|max:255',
        ]);

        if ($validator->fails()) {
            return redirect()->back()
                ->withErrors($validator)
                ->withInput();
        }

        try {
            // Update kamar
            $room->update([
                'room_type' => $request->room_type ?? $room->room_type,
                'room_number' => $request->room_number ?? $room->room_number,
                'price' => $request->price ?? $room->price,
                'size' => $request->size ?? $room->size,
                'capacity' => $request->capacity ?? $room->capacity,
                'is_available' => $request->has('is_available') ? $request->is_available : $room->is_available,
                'description' => $request->description ?? $room->description,
            ]);

            // Update fasilitas jika ada
            if ($request->has('facilities')) {
                $room->facilities()->delete();
                foreach ($request->facilities as $facility) {
                    RoomFacility::create([
                        'room_id' => $room->id,
                        'facility_name' => $facility
                    ]);
                }
            }

            // Update jumlah kamar tersedia di properti
            $this->updateAvailableRooms($property);

            return redirect()->route('admin.properties.rooms.show', [$propertyId, $room->id])
                ->with('success', 'Kamar berhasil diperbarui');
        } catch (\Exception $e) {
            return redirect()->back()
                ->with('error', 'Gagal memperbarui kamar: ' . $e->getMessage())
                ->withInput();
        }
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
