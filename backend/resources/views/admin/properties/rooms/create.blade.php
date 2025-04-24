@extends('layouts.admin')

@section('content')
<div class="container">
    <h2>Tambah Ruangan</h2>
    <form action="{{ route('admin.properties.rooms.store', $property->id) }}" method="POST">
        @csrf
        <div class="mb-3">
            <label for="room_type" class="form-label">Jenis Ruangan</label>
            <input type="text" class="form-control @error('room_type') is-invalid @enderror" id="room_type" name="room_type" value="{{ old('room_type') }}">
            @error('room_type')
                <div class="invalid-feedback">{{ $message }}</div>
            @enderror
        </div>

        <div class="mb-3">
            <label for="room_number" class="form-label">Nomor Ruangan</label>
            <input type="text" class="form-control @error('room_number') is-invalid @enderror" id="room_number" name="room_number" value="{{ old('room_number') }}">
            @error('room_number')
                <div class="invalid-feedback">{{ $message }}</div>
            @enderror
        </div>

        <div class="mb-3">
            <label for="price" class="form-label">Harga</label>
            <input type="number" class="form-control @error('price') is-invalid @enderror" id="price" name="price" value="{{ old('price') }}">
            @error('price')
                <div class="invalid-feedback">{{ $message }}</div>
            @enderror
        </div>

        <div class="mb-3">
            <label for="size" class="form-label">Ukuran</label>
            <input type="text" class="form-control @error('size') is-invalid @enderror" id="size" name="size" value="{{ old('size') }}">
            @error('size')
                <div class="invalid-feedback">{{ $message }}</div>
            @enderror
        </div>

        <div class="mb-3">
            <label for="capacity" class="form-label">Kapasitas</label>
            <input type="number" class="form-control @error('capacity') is-invalid @enderror" id="capacity" name="capacity" value="{{ old('capacity') }}">
            @error('capacity')
                <div class="invalid-feedback">{{ $message }}</div>
            @enderror
        </div>

        <div class="mb-3">
            <label for="is_available" class="form-label">Ketersediaan</label>
            <select class="form-select @error('is_available') is-invalid @enderror" id="is_available" name="is_available">
                <option value="1" {{ old('is_available') == '1' ? 'selected' : '' }}>Tersedia</option>
                <option value="0" {{ old('is_available') == '0' ? 'selected' : '' }}>Tidak Tersedia</option>
            </select>
            @error('is_available')
                <div class="invalid-feedback">{{ $message }}</div>
            @enderror
        </div>

         <div class="mb-3">
            <label for="description" class="form-label">Deskripsi</label>
            <textarea class="form-control @error('description') is-invalid @enderror" id="description" name="description">{{ old('description') }}</textarea>
            @error('description')
                <div class="invalid-feedback">{{ $message }}</div>
            @enderror
        </div>

        <div class="mb-3">
            <label for="facilities" class="form-label">Fasilitas</label>
            <div id="facilities-container">
                <div class="input-group mb-2">
                    <input type="text" class="form-control @error('facilities.0') is-invalid @enderror" name="facilities[0][facility_name]" value="{{ old('facilities.0.facility_name') }}">
                    <button type="button" class="btn btn-outline-secondary add-facility">Tambah</button>
                     @error('facilities.0')
                        <div class="invalid-feedback">{{ $message }}</div>
                     @enderror
                </div>
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
        const addFacilityButton = document.querySelector('.add-facility');

        let facilityCount = 1; // Start from 1, menghindari duplikasi index 0

        addFacilityButton.addEventListener('click', function() {
            const newInputGroup = document.createElement('div');
            newInputGroup.className = 'input-group mb-2';
            newInputGroup.innerHTML = `
                <input type="text" class="form-control" name="facilities[${facilityCount}][facility_name]" required>
                <button type="button" class="btn btn-outline-danger remove-facility">Hapus</button>
            `;
            facilitiesContainer.appendChild(newInputGroup);
            facilityCount++;

             // Menambahkan event listener untuk tombol Hapus yang baru dibuat
            const removeButton = newInputGroup.querySelector('.remove-facility');
            removeButton.addEventListener('click', function() {
                newInputGroup.remove();
            });
        });

        // Event listener untuk tombol Hapus yang ada saat halaman dimuat (untuk fasilitas pertama)
        const initialRemoveButton = facilitiesContainer.querySelector('.remove-facility');
        if (initialRemoveButton) { // Check if the button exists
            initialRemoveButton.addEventListener('click', function() {
                facilitiesContainer.querySelector('.input-group').remove();
            });
        }
    });
</script>
@endsection
