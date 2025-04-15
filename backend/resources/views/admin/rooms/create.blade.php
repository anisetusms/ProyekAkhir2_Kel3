<!-- resources/views/admin/rooms/create.blade.php -->

@extends('layouts.admin')

@section('content')
<div class="container">
    <h2>Tambah Ruangan</h2>
    <form action="{{ route('admin.rooms.store') }}" method="POST">
        @csrf
        <div class="mb-3">
            <label for="name" class="form-label">Nama Ruangan</label>
            <input type="text" class="form-control @error('name') is-invalid @enderror" id="name" name="name" value="{{ old('name') }}">
            @error('name')
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
            <label for="facilities" class="form-label">Fasilitas</label>
            <select class="form-select" id="facilities" name="facilities[]" multiple>
                @foreach ($facilities as $facility)
                    <option value="{{ $facility->id }}" {{ in_array($facility->id, old('facilities', [])) ? 'selected' : '' }}>
                        {{ $facility->name }}
                    </option>
                @endforeach
            </select>
        </div>
        <button type="submit" class="btn btn-primary">Simpan</button>
        <a href="{{ route('admin.rooms.index') }}" class="btn btn-secondary">Kembali</a>
    </form>
</div>
@endsection
