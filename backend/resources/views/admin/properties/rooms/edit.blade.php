@extends('layouts.admin')

@section('content')
<div class="container">
    <h2>Edit Ruangan</h2>
    <form action="{{ route('admin.properties.rooms.update', [$property->id, $room->id]) }}" method="POST">
        @csrf
        @method('PUT')
        <div class="mb-3">
            <label for="room_type" class="form-label">Jenis Ruangan</label>
            <input type="text" class="form-control @error('room_type') is-invalid @enderror" id="room_type" name="room_type" value="{{ old('room_type', $room->room_type) }}">
            @error('room_type')
            <div class="invalid-feedback">{{ $message }}</div>
            @enderror
        </div>
        <div class="mb-3">
            <label for="room_number" class="form-label">Nomor Ruangan</label>
            <input type="text" class="form-control @error('room_number') is-invalid @enderror" id="room_number" name="room_number" value="{{ old('room_number', $room->room_number) }}">
            @error('room_number')
            <div class="invalid-feedback">{{ $message }}</div>
            @enderror
        </div>
        <div class="mb-3">
            <label for="price" class="form-label">Harga</label>
            <input type="number" class="form-control @error('price') is-invalid @enderror" id="price" name="price" value="{{ old('price', $room->price) }}">
            @error('price')
            <div class="invalid-feedback">{{ $message }}</div>
            @enderror
        </div>
        <div class="mb-3">
            <label for="is_available" class="form-label">Ketersediaan</label>
            <select class="form-select @error('is_available') is-invalid @enderror" id="is_available" name="is_available">
                <option value="1" {{ old('is_available', $room->is_available) == '1' ? 'selected' : '' }}>Tersedia</option>
                <option value="0" {{ old('is_available', $room->is_available) == '0' ? 'selected' : '' }}>Tidak Tersedia</option>
            </select>
            @error('is_available')
            <div class="invalid-feedback">{{ $message }}</div>
            @enderror
        </div>

        <div class="mb-3">
            <label for="facilities" class="form-label">Fasilitas</label>
            <div id="facilities-container">
                @if (count($room->roomFacilities) > 0)
                    @foreach ($room->roomFacilities as $index => $roomFacility)
                        <div class="input-group mb-2">
                            <input type="text" class="form-control" name="facilities[{{ $index }}][facility_name]" value="{{ $roomFacility->facility_name }}" required>
                            @if ($index == 0)
                                <button type="button" class="btn btn-outline-secondary add-facility">Tambah</button>
                            @else
                                <button type="button" class="btn btn-outline-danger remove-facility">Hapus</button>
                            @endif
                        </div>
                    @endforeach
                @else
                    <div class="input-group mb-2">
                        <input type="text" class="form-control" name="facilities[0][facility_name]" required>
                        <button type="button" class="btn btn-outline-secondary add-facility">Tambah</button>
                    </div>
                @endif
            </div>
            @error('facilities')
                <div class="text-danger">{{ $message }}</div>
            @enderror
        </div>
        <button type="submit" class="btn btn-primary">Simpan</button>
        <a href="{{ route('admin.properties.rooms.index', $property->id) }}" class="btn btn-secondary">Kembali</a>
    </form>
</div>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        const facilitiesContainer = document.getElementById('facilities-container');
        const addFacilityButton = facilitiesContainer.querySelector('.add-facility');
        let facilityCount = facilitiesContainer.querySelectorAll('.input-group').length;


        addFacilityButton.addEventListener('click', function() {
            const newInputGroup = document.createElement('div');
            newInputGroup.className = 'input-group mb-2';
            newInputGroup.innerHTML = `
                <input type="text" class="form-control" name="facilities[${facilityCount}][facility_name]" required>
                <button type="button" class="btn btn-outline-danger remove-facility">Hapus</button>
            `;
            facilitiesContainer.appendChild(newInputGroup);
            facilityCount++;

            const removeButton = newInputGroup.querySelector('.remove-facility');
            removeButton.addEventListener('click', function() {
                newInputGroup.remove();
                facilityCount--;
            });
        });

        facilitiesContainer.addEventListener('click', function(event) {
            if (event.target.classList.contains('remove-facility')) {
                event.target.closest('.input-group').remove();
                 facilityCount--;
            }
        });
    });
</script>
@endsection
