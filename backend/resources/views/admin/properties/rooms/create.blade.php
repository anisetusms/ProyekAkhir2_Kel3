@extends('layouts.admin')

@section('content')
<div class="container">
    <h2>Tambah Ruangan</h2>
    <form action="{{ route('admin.properties.rooms.store', $property->id) }}" method="POST" enctype="multipart/form-data">
        @csrf
        <div class="row">
            <div class="col-md-8">
                <!-- Informasi Dasar Kamar -->
                <div class="card mb-4">
                    <div class="card-header">Informasi Dasar</div>
                    <div class="card-body">
                        <div class="mb-3">
                            <label for="room_type" class="form-label">Jenis Ruangan</label>
                            <input type="text" class="form-control @error('room_type') is-invalid @enderror" 
                                   id="room_type" name="room_type" value="{{ old('room_type') }}" required>
                            @error('room_type')
                                <div class="invalid-feedback">{{ $message }}</div>
                            @enderror
                        </div>

                        <div class="mb-3">
                            <label for="room_number" class="form-label">Nomor Ruangan</label>
                            <input type="text" class="form-control @error('room_number') is-invalid @enderror" 
                                   id="room_number" name="room_number" value="{{ old('room_number') }}" required>
                            @error('room_number')
                                <div class="invalid-feedback">{{ $message }}</div>
                            @enderror
                        </div>

                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label for="price" class="form-label">Harga per Bulan</label>
                                <div class="input-group">
                                    <span class="input-group-text">Rp</span>
                                    <input type="number" class="form-control @error('price') is-invalid @enderror" 
                                           id="price" name="price" value="{{ old('price') }}" required>
                                </div>
                                @error('price')
                                    <div class="invalid-feedback">{{ $message }}</div>
                                @enderror
                            </div>
                            <div class="col-md-6 mb-3">
                                <label for="size" class="form-label">Ukuran (m²)</label>
                                <input type="text" class="form-control @error('size') is-invalid @enderror" 
                                       id="size" name="size" value="{{ old('size') }}">
                                @error('size')
                                    <div class="invalid-feedback">{{ $message }}</div>
                                @enderror
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label for="capacity" class="form-label">Kapasitas</label>
                                <input type="number" class="form-control @error('capacity') is-invalid @enderror" 
                                       id="capacity" name="capacity" value="{{ old('capacity', 1) }}" min="1" required>
                                @error('capacity')
                                    <div class="invalid-feedback">{{ $message }}</div>
                                @enderror
                            </div>
                            <div class="col-md-6 mb-3">
                                <label for="is_available" class="form-label">Ketersediaan</label>
                                <select class="form-select @error('is_available') is-invalid @enderror" 
                                        id="is_available" name="is_available" required>
                                    <option value="1" {{ old('is_available', 1) == '1' ? 'selected' : '' }}>Tersedia</option>
                                    <option value="0" {{ old('is_available') == '0' ? 'selected' : '' }}>Tidak Tersedia</option>
                                </select>
                                @error('is_available')
                                    <div class="invalid-feedback">{{ $message }}</div>
                                @enderror
                            </div>
                        </div>

                        <div class="mb-3">
                            <label for="description" class="form-label">Deskripsi</label>
                            <textarea class="form-control @error('description') is-invalid @enderror" 
                                      id="description" name="description" rows="3">{{ old('description') }}</textarea>
                            @error('description')
                                <div class="invalid-feedback">{{ $message }}</div>
                            @enderror
                        </div>
                    </div>
                </div>

                <!-- Fasilitas Kamar -->
                <div class="card mb-4">
                    <div class="card-header">Fasilitas Kamar</div>
                    <div class="card-body">
                        <div id="facilities-container">
                            @if(old('facilities'))
                                @foreach(old('facilities') as $index => $facility)
                                    <div class="input-group mb-2">
                                        <input type="text" class="form-control @error('facilities.'.$index.'.facility_name') is-invalid @enderror" 
                                               name="facilities[{{ $index }}][facility_name]" 
                                               value="{{ $facility['facility_name'] }}" required>
                                        @if($loop->first)
                                            <button type="button" class="btn btn-outline-secondary add-facility">Tambah</button>
                                        @else
                                            <button type="button" class="btn btn-outline-danger remove-facility">Hapus</button>
                                        @endif
                                        @error('facilities.'.$index.'.facility_name')
                                            <div class="invalid-feedback">{{ $message }}</div>
                                        @enderror
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
                </div>
            </div>

            <div class="col-md-4">
                <!-- Gambar Kamar -->
                <div class="card mb-4">
                    <div class="card-header">Gambar Kamar</div>
                    <div class="card-body">
                        <!-- Gambar Utama -->
                        <div class="mb-3">
                            <label for="main_image" class="form-label">Gambar Utama</label>
                            <input type="file" class="form-control @error('main_image') is-invalid @enderror" 
                                   id="main_image" name="main_image" accept="image/*" required>
                            <small class="text-muted">Format: JPEG, PNG, JPG | Maks: 2MB</small>
                            @error('main_image')
                                <div class="invalid-feedback">{{ $message }}</div>
                            @enderror
                            <div class="mt-2">
                                <img id="main_image_preview" src="#" alt="Preview Gambar Utama" 
                                     class="img-thumbnail d-none" style="max-height: 150px;">
                            </div>
                        </div>

                        <!-- Gallery Gambar -->
                        <div class="mb-3">
                            <label for="gallery_images" class="form-label">Gambar Tambahan (Gallery)</label>
                            <input type="file" class="form-control @error('gallery_images') is-invalid @enderror" 
                                   id="gallery_images" name="gallery_images[]" multiple accept="image/*">
                            <small class="text-muted">Format: JPEG, PNG, JPG | Maks: 2MB per gambar</small>
                            @error('gallery_images')
                                <div class="invalid-feedback">{{ $message }}</div>
                            @enderror
                            @error('gallery_images.*')
                                <div class="invalid-feedback">{{ $message }}</div>
                            @enderror
                            <div id="gallery_preview" class="mt-2 row g-2"></div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="d-flex justify-content-between">
            <a href="{{ route('admin.properties.rooms.index', $property->id) }}" class="btn btn-secondary">
                <i class="fas fa-arrow-left me-1"></i> Kembali
            </a>
            <button type="submit" class="btn btn-primary">
                <i class="fas fa-save me-1"></i> Simpan Ruangan
            </button>
        </div>
    </form>
</div>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        const facilitiesContainer = document.getElementById('facilities-container');
        let facilityCount = {{ old('facilities') ? count(old('facilities')) : 1 }};

        // Tambah fasilitas
        document.addEventListener('click', function(e) {
            if (e.target.classList.contains('add-facility')) {
                const newInputGroup = document.createElement('div');
                newInputGroup.className = 'input-group mb-2';
                newInputGroup.innerHTML = `
                    <input type="text" class="form-control" name="facilities[${facilityCount}][facility_name]" required>
                    <button type="button" class="btn btn-outline-danger remove-facility">Hapus</button>
                `;
                facilitiesContainer.appendChild(newInputGroup);
                facilityCount++;
            }

            // Hapus fasilitas
            if (e.target.classList.contains('remove-facility')) {
                e.target.closest('.input-group').remove();
            }
        });

        // Preview gambar utama
        const mainImageInput = document.getElementById('main_image');
        const mainImagePreview = document.getElementById('main_image_preview');
        
        mainImageInput.addEventListener('change', function() {
            const file = this.files[0];
            if (file) {
                const reader = new FileReader();
                reader.onload = function(e) {
                    mainImagePreview.src = e.target.result;
                    mainImagePreview.classList.remove('d-none');
                }
                reader.readAsDataURL(file);
            }
        });

        // Preview gallery gambar
        const galleryInput = document.getElementById('gallery_images');
        const galleryPreview = document.getElementById('gallery_preview');
        
        galleryInput.addEventListener('change', function() {
            galleryPreview.innerHTML = '';
            const files = this.files;
            
            for (let i = 0; i < files.length; i++) {
                const file = files[i];
                if (file.type.match('image.*')) {
                    const reader = new FileReader();
                    reader.onload = function(e) {
                        const col = document.createElement('div');
                        col.className = 'col-6 col-md-4';
                        col.innerHTML = `
                            <img src="${e.target.result}" class="img-thumbnail mb-2" style="height: 100px; width: 100%; object-fit: cover;">
                        `;
                        galleryPreview.appendChild(col);
                    }
                    reader.readAsDataURL(file);
                }
            }
        });
    });
</script>

<style>
    .img-thumbnail {
        object-fit: cover;
    }
</style>
@endsection