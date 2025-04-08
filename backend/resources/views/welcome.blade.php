@extends('layouts.index-welcome')
@section('content')
<!-- Carousel -->
{{-- <section>
      <div class="row row-cols-1 row-cols-lg-12 row-cols-xl-12">
        <div class="col">
          <div class="card">
            <div class="card-body">
              <div id="carouselExampleSlidesOnly" class="carousel slide" data-bs-ride="carousel">
                <div class="carousel-inner">
                  <div class="carousel-item active">
                    <img src="assets/images/carousels/01.png" class="d-block w-100" alt="...">
                  </div>
                  <div class="carousel-item">
                    <img src="assets/images/carousels/02.png" class="d-block w-100" alt="...">
                  </div>
                  <div class="carousel-item">
                    <img src="assets/images/carousels/03.png" class="d-block w-100" alt="...">
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </section> --}}
<style>
  /* Efek Hover pada Card */
  .property-card {
    transition: transform 0.3s ease, box-shadow 0.3s ease;
  }

  .property-card:hover {
    transform: scale(1.05);
    box-shadow: 0px 10px 20px rgba(0, 0, 0, 0.2);
  }
</style>

<!-- Form Pencarian -->
<section class="container mt-5">
  <div class="p-4 rounded">
    <h2 class="fw-bold text-dark">Mau cari penginapan ?</h2>
    <p class="text-dark">Dapatkan infonya dan langsung sewa penginapan di platform ini.</p>
    <form action="" method="GET">
      <div class="input-group shadow rounded overflow-hidden">
        <span class="input-group-text bg-white border-0">
          <i class="bi bi-search"></i>
        </span>
        <input type="text" name="query" class="form-control border-0" placeholder="Masukan nama lokasi/area/alamat">
        <button type="submit" class="btn btn-success px-4">Cari</button>
      </div>
    </form>
  </div>
</section>

<section class="container mt-5">
  <h3 class="fw-bold mb-4">🏠 Daftar Homestay & Kost</h3>
  <div class="row row-cols-1 row-cols-md-4 g-3">
    @foreach ($properties as $property)
    <div class="col">
      <a href="{{ route('detail-property.show', $property->property_id) }}"
        class="text-decoration-none">
        <div class="card shadow-lg h-100 border-0 rounded-4 overflow-hidden position-relative property-card">
          <!-- Badge Tipe Properti -->
          <span class="position-absolute top-0 start-0 m-2 px-3 py-1 bg-success text-white rounded">
            {{ $property->property_type }}
          </span>

          <!-- Gambar Properti -->
          <img src="{{ $property->image ? asset('storage/' . $property->image) : asset('default-image.jpg') }}"
            class="card-img-top object-fit-cover"
            style="height: 250px; object-fit: cover;"
            alt="{{ $property->property_name }}">

          <div class="card-body">
            <h6 class="card-title mb-2 text-dark">{{ $property->property_name }}</h6>
            <h6 class="card-title mb-2 fw-bold text-dark">Kecamatan {{ $property->subdistrict  }}</h6>
            <p class="card-text text-muted">{{ Str::limit($property->description, 80) }}</p>
            <h5 class="">Rp{{ number_format($property->price, 0, ',', '.') }}/bulan</h5>
          </div>
        </div>
      </a>
    </div>
    @endforeach
  </div>
</section>
@endsection