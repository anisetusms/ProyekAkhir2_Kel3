<!-- filepath: e:\KULIAH\SEMESTER 4\PA2\PA2\PA2\resources\views\detail-property.blade.php -->
@extends('layouts.index-welcome')

@section('content')
<div class="container py-5">
    <div class="card shadow-lg">
        <!-- Gambar Properti -->
        <img src="{{ $property->image ? asset('storage/' . $property->image) : asset('default-image.jpg') }}" 
             class="card-img-top object-fit-cover" 
             style="max-height: 400px; object-fit: cover;" 
             alt="{{ $property->name }}">

        <div class="card-body">
            <!-- Nama Properti -->
            <h3 class="fw-bold">{{ $property->name }}</h3>

            <!-- Deskripsi Properti -->
            <p class="text-muted">{{ $property->description ?? 'Deskripsi tidak tersedia' }}</p>

            <!-- Harga Properti -->
            <h5 class="text-success fw-bold">
                Rp {{ number_format($property->price, 0, ',', '.') }}/bulan
            </h5>

            <!-- Fasilitas Properti -->
            @if (!empty($property->facilities) && count($property->facilities) > 0)
                <h6 class="mt-4">Fasilitas:</h6>
                <ul>
                    @foreach ($property->facilities as $facility)
                        <li>{{ $facility }}</li>
                    @endforeach
                </ul>
            @else
                <p class="text-muted">Fasilitas tidak tersedia</p>
            @endif

            <!-- Tombol Kembali -->
            <a href="{{ route('landingpage') }}" class="btn btn-primary mt-3">Kembali</a>
        </div>
    </div>

    <!-- Galeri Gambar Properti -->
    @if (!empty($property->images) && count($property->images) > 1)
        <div class="mt-5">
            <h4>Galeri Gambar</h4>
            <div class="row">
                @foreach ($property->images as $image)
                    <div class="col-md-4 mb-3">
                        <img src="{{ url('storage/' . $image) }}" 
                             class="img-fluid rounded" 
                             alt="Gambar Properti">
                    </div>
                @endforeach
            </div>
        </div>
    @endif
</div>
@endsection