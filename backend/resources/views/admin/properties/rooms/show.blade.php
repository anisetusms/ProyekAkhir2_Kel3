@extends('layouts.admin')

@section('content')
<div class="container">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2>Detail Ruangan</h2>
        <a href="{{ route('admin.properties.rooms.index', $property->id) }}" class="btn btn-secondary">
            <i class="fas fa-arrow-left me-1"></i> Kembali ke Daftar Ruangan
        </a>
    </div>

    <div class="row">
        <div class="col-md-8">
            <!-- Informasi Dasar Kamar -->
            <div class="card mb-4">
                <div class="card-header">Informasi Dasar</div>
                <div class="card-body">
                    <div class="row mb-3">
                        <div class="col-md-6">
                            <h6>Jenis Ruangan</h6>
                            <p>{{ $room->room_type }}</p>
                        </div>
                        <div class="col-md-6">
                            <h6>Nomor Ruangan</h6>
                            <p>{{ $room->room_number }}</p>
                        </div>
                    </div>

                    <div class="row mb-3">
                        <div class="col-md-6">
                            <h6>Harga per Bulan</h6>
                            <p>Rp {{ number_format($room->price, 0, ',', '.') }}</p>
                        </div>
                        <div class="col-md-6">
                            <h6>Ukuran</h6>
                            <p>{{ $room->size ? $room->size . ' m²' : '-' }}</p>
                        </div>
                    </div>

                    <div class="row mb-3">
                        <div class="col-md-6">
                            <h6>Kapasitas</h6>
                            <p>{{ $room->capacity }} orang</p>
                        </div>
                        <div class="col-md-6">
                            <h6>Ketersediaan</h6>
                            <p>
                                @if($room->is_available)
                                    <span class="badge bg-success">Tersedia</span>
                                @else
                                    <span class="badge bg-danger">Tidak Tersedia</span>
                                @endif
                            </p>
                        </div>
                    </div>

                    <div class="mb-3">
                        <h6>Deskripsi</h6>
                        <p>{{ $room->description ?? '-' }}</p>
                    </div>
                </div>
            </div>

            <!-- Fasilitas Kamar -->
            <div class="card mb-4">
                <div class="card-header">Fasilitas Kamar</div>
                <div class="card-body">
                    @if($room->facilities && count($room->facilities) > 0)
                        <ul class="list-group">
                            @foreach($room->facilities as $facility)
                                <li class="list-group-item">{{ $facility->facility_name }}</li>
                            @endforeach
                        </ul>
                    @else
                        <p class="text-muted">Tidak ada fasilitas yang ditambahkan</p>
                    @endif
                </div>
            </div>
        </div>

        <div class="col-md-4">
            <!-- Gambar Kamar -->
            <div class="card mb-4">
                <div class="card-header">Gambar Kamar</div>
                <div class="card-body">
                    <!-- Gambar Utama -->
                    <div class="mb-4">
                        <h6>Gambar Utama</h6>
                        @if($room->main_image)
                            <img src="{{ asset('storage/' . $room->main_image) }}" alt="Gambar Utama" 
                                 class="img-thumbnail w-100" style="max-height: 250px; object-fit: cover;">
                        @else
                            <p class="text-muted">Tidak ada gambar utama</p>
                        @endif
                    </div>

                    <!-- Gallery Gambar -->
                    <div>
                        <h6>Galeri Gambar</h6>
                        @if($room->gallery_images && count($room->gallery_images) > 0)
                            <div class="row g-2">
                                @foreach($room->gallery_images as $image)
                                    <div class="col-6">
                                        <img src="{{ asset('storage/' . $image) }}" class="img-thumbnail mb-2" 
                                             style="height: 100px; width: 100%; object-fit: cover;">
                                    </div>
                                @endforeach
                            </div>
                        @else
                            <p class="text-muted">Tidak ada gambar tambahan</p>
                        @endif
                    </div>
                </div>
            </div>

            <!-- Actions -->
            <div class="card">
                <div class="card-header">Aksi</div>
                <div class="card-body d-grid gap-2">
                    <a href="{{ route('admin.properties.rooms.edit', [$property->id, $room->id]) }}" 
                       class="btn btn-primary btn-block">
                        <i class="fas fa-edit me-1"></i> Edit Ruangan
                    </a>
                    <form action="{{ route('admin.properties.rooms.destroy', [$property->id, $room->id]) }}" method="POST" 
                          onsubmit="return confirm('Apakah Anda yakin ingin menghapus ruangan ini?')">
                        @csrf
                        @method('DELETE')
                        <button type="submit" class="btn btn-danger btn-block">
                            <i class="fas fa-trash me-1"></i> Hapus Ruangan
                        </button>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>
@endsection

<style>
    .img-thumbnail {
        object-fit: cover;
    }
</style>