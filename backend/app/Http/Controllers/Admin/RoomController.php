<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Property;
use App\Models\Room;
use App\Models\RoomFacility;
use App\Models\RoomImage;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Storage;

class RoomController extends Controller
{
    public function index($propertyId)
    {
        $property = Property::findOrFail($propertyId);
        $rooms = $property->rooms()
            ->with(['roomFacilities', 'images' => function ($query) {
                $query->where('is_main', true)->limit(1);
            }])
            ->paginate(10);

        return view('admin.properties.rooms.index', compact('rooms', 'property'));
    }

    public function create($propertyId)
    {
        $property = Property::findOrFail($propertyId);
        $roomFacilities = RoomFacility::select('facility_name')->distinct()->get();

        return view('admin.properties.rooms.create', compact('property', 'roomFacilities'));
    }

    public function store(Request $request, $propertyId)
    {
        $validator = Validator::make($request->all(), [
            'room_type' => 'required|string|max:100',
            'room_number' => 'required|string|max:50',
            'price' => 'required|numeric|min:0',
            'size' => 'nullable|string|max:50',
            'capacity' => 'required|integer|min:1',
            'is_available' => 'nullable|boolean',
            'description' => 'nullable|string',
            'facilities' => 'required|array',
            'facilities.*.facility_name' => 'required|string|max:255',
            'main_image' => 'required|image|mimes:jpeg,png,jpg,gif|max:2048',
            'gallery_images' => 'nullable|array',
            'gallery_images.*' => 'image|mimes:jpeg,png,jpg,gif|max:2048',
        ]);

        if ($validator->fails()) {
            return back()->withErrors($validator)->withInput();
        }

        DB::beginTransaction();
        try {
            // Simpan data kamar
            $room = Room::create([
                'property_id' => $propertyId,
                'room_type' => $request->room_type,
                'room_number' => $request->room_number,
                'price' => $request->price,
                'size' => $request->size,
                'capacity' => $request->capacity,
                'is_available' => $request->input('is_available', true),
                'description' => $request->description,
            ]);

            // Simpan fasilitas
            foreach ($request->input('facilities') as $facility) {
                RoomFacility::create([
                    'room_id' => $room->id,
                    'facility_name' => $facility['facility_name'],
                ]);
            }

            // Simpan gambar utama
            if ($request->hasFile('main_image')) {
                $mainImagePath = $request->file('main_image')->store('room_images', 'public');
                RoomImage::create([
                    'room_id' => $room->id,
                    'image_url' => $mainImagePath,
                    'is_main' => true,
                ]);
            }

            // Simpan gambar gallery
            if ($request->hasFile('gallery_images')) {
                foreach ($request->file('gallery_images') as $image) {
                    $galleryImagePath = $image->store('room_images/gallery', 'public');
                    RoomImage::create([
                        'room_id' => $room->id,
                        'image_url' => $galleryImagePath,
                        'is_main' => false,
                    ]);
                }
            }

            DB::commit();
            return redirect()->route('admin.properties.rooms.index', $propertyId)
                ->with('success', 'Ruangan beserta gambar berhasil ditambahkan');
        } catch (\Exception $e) {
            DB::rollback();
            return back()->withInput()->with('error', 'Gagal menambahkan ruangan: ' . $e->getMessage());
        }
    }

    public function show($propertyId, $roomId)
    {
        $property = Property::where('isDeleted', false)->findOrFail($propertyId);
        $room = $property->rooms()
            ->with(['roomFacilities', 'images'])
            ->findOrFail($roomId);

        return view('admin.properties.rooms.show', compact('property', 'room'));
    }

    public function edit($propertyId, $roomId)
    {
        $property = Property::findOrFail($propertyId);
        $room = Room::with(['roomFacilities', 'images'])->findOrFail($roomId);
        $roomFacilities = RoomFacility::select('facility_name')->distinct()->get();

        return view('admin.properties.rooms.edit', compact('room', 'roomFacilities', 'property'));
    }

    public function update(Request $request, $propertyId, $roomId)
    {
        $validator = Validator::make($request->all(), [
            'room_type' => 'required|string|max:100',
            'room_number' => 'required|string|max:50',
            'price' => 'required|numeric|min:0',
            'size' => 'nullable|string|max:50',
            'capacity' => 'required|integer|min:1',
            'is_available' => 'nullable|boolean',
            'description' => 'nullable|string',
            'facilities' => 'required|array',
            'facilities.*.facility_name' => 'required|string|max:255',
            'main_image' => 'nullable|image|mimes:jpeg,png,jpg,gif|max:2048',
            'gallery_images' => 'nullable|array',
            'gallery_images.*' => 'image|mimes:jpeg,png,jpg,gif|max:2048',
            'delete_images' => 'nullable|array',
            'delete_images.*' => 'exists:room_images,id',
        ]);

        if ($validator->fails()) {
            return back()->withErrors($validator)->withInput();
        }

        DB::beginTransaction();
        try {
            $room = Room::findOrFail($roomId);
            $room->update([
                'room_type' => $request->room_type,
                'room_number' => $request->room_number,
                'price' => $request->price,
                'size' => $request->size,
                'capacity' => $request->capacity,
                'is_available' => $request->input('is_available', true),
                'description' => $request->description,
            ]);

            // Update fasilitas
            $room->roomFacilities()->delete();
            foreach ($request->input('facilities') as $facility) {
                RoomFacility::create([
                    'room_id' => $roomId,
                    'facility_name' => $facility['facility_name'],
                ]);
            }

            // Update gambar utama
            if ($request->hasFile('main_image')) {
                // Hapus gambar utama lama jika ada
                $oldMainImage = $room->images()->where('is_main', true)->first();
                if ($oldMainImage) {
                    Storage::disk('public')->delete($oldMainImage->image_url);
                    $oldMainImage->delete();
                }

                $mainImagePath = $request->file('main_image')->store('room_images', 'public');
                RoomImage::create([
                    'room_id' => $room->id,
                    'image_url' => $mainImagePath,
                    'is_main' => true,
                ]);
            }

            // Hapus gambar yang dipilih
            if ($request->has('delete_images')) {
                foreach ($request->input('delete_images') as $imageId) {
                    $image = RoomImage::find($imageId);
                    if ($image) {
                        Storage::disk('public')->delete($image->image_url);
                        $image->delete();
                    }
                }
            }

            // Tambahkan gambar gallery baru
            if ($request->hasFile('gallery_images')) {
                foreach ($request->file('gallery_images') as $image) {
                    $galleryImagePath = $image->store('room_images/gallery', 'public');
                    RoomImage::create([
                        'room_id' => $room->id,
                        'image_url' => $galleryImagePath,
                        'is_main' => false,
                    ]);
                }
            }

            DB::commit();
            return redirect()->route('admin.properties.rooms.index', $propertyId)
                ->with('success', 'Ruangan berhasil diperbarui');
        } catch (\Exception $e) {
            DB::rollback();
            return back()->withInput()->with('error', 'Gagal memperbarui ruangan: ' . $e->getMessage());
        }
    }

    public function deleteImage(Property $property, Room $room, Request $request)
    {
        $request->validate([
            'image_path' => 'required|string'
        ]);

        // Hapus gambar dari storage
        if (Storage::exists($request->image_path)) {
            Storage::delete($request->image_path);
        }

        // Update record di database
        if ($room->main_image === $request->image_path) {
            // Jika yang dihapus adalah main image
            $room->update(['main_image' => null]);
        } else {
            // Jika yang dihapus adalah gallery image
            $galleryImages = $room->gallery_images ?? [];
            $updatedGallery = array_filter($galleryImages, function ($image) use ($request) {
                return $image !== $request->image_path;
            });
            $room->update(['gallery_images' => array_values($updatedGallery)]);
        }

        return response()->json([
            'success' => true,
            'message' => 'Gambar berhasil dihapus'
        ]);
    }

    public function destroy($propertyId, $roomId)
    {
        $property = Property::where('isDeleted', false)->findOrFail($propertyId);
        $room = $property->rooms()->findOrFail($roomId);

        DB::beginTransaction();
        try {
            // Hapus gambar terkait
            foreach ($room->images as $image) {
                Storage::disk('public')->delete($image->image_url);
                $image->delete();
            }

            // Hapus kamar
            $room->delete();

            // Update jumlah kamar tersedia di properti
            $this->updateAvailableRooms($property);

            DB::commit();
            return redirect()->route('admin.properties.rooms.index', $propertyId)
                ->with('success', 'Kamar berhasil dihapus');
        } catch (\Exception $e) {
            DB::rollback();
            return redirect()->back()
                ->with('error', 'Gagal menghapus kamar: ' . $e->getMessage());
        }
    }

    private function updateAvailableRooms(Property $property)
    {
        if ($property->property_type_id == 1) { // Kost
            $availableRooms = $property->rooms()->where('is_available', true)->count();
            $property->kostDetail()->update(['available_rooms' => $availableRooms]);
        } else { // Homestay
            $availableUnits = $property->rooms()->where('is_available', true)->count();
            $property->homestayDetail()->update(['available_units' => $availableUnits]);
        }
    }
}
