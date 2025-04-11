@extends('layouts.index-owner')

@section('content')
<div class="card">
    <div class="card-body">
        <h2 class="mb-4">Tambah Properti</h2>
        <form id="property-form" action="{{ route('owner.store-property') }}" method="POST" enctype="multipart/form-data">
            @csrf

            <!-- Nama Properti -->
            <div class="mb-3">
                <label for="name" class="form-label">Nama Properti</label>
                <input type="text" class="form-control" id="name" name="name" placeholder="Masukkan nama properti" required>
            </div>

            <!-- Property Type -->
            <div class="mb-3">
                <label for="property_type" class="form-label">Tipe Properti</label>
                <select class="form-select" id="property_type" name="property_type_id" required>
                    <option value="" disabled selected>Pilih tipe properti</option>
                    @foreach ($propertyTypes as $type)
                    <option value="{{ $type->id }}">{{ $type->property_type }}</option>
                    @endforeach
                </select>
            </div>

            <!-- Provinsi -->
            <div class="mb-3">
                <label for="province" class="form-label">Provinsi</label>
                <select name="province_id" id="province" class="form-control" required>
                    <option value="" disabled selected>Pilih Provinsi</option>
                    @foreach($provinces as $province)
                    <option value="{{ $province->id }}">{{ $province->prov_name }}</option>
                    @endforeach
                </select>
            </div>

            <!-- Kota -->
            <div class="mb-3">
                <label for="city" class="form-label">Kota/Kabupaten</label>
                <select class="form-select" id="city" name="city_id" disabled required>
                    <option value="" disabled selected>Pilih Kota</option>
                </select>
            </div>

            <!-- Kecamatan -->
            <div class="mb-3">
                <label for="district" class="form-label">Kecamatan</label>
                <select class="form-select" id="district" name="district_id" disabled required>
                    <option value="" disabled selected>Pilih Kecamatan</option>
                </select>
            </div>

            <!-- Kelurahan -->
            <div class="mb-3">
                <label for="subdistrict" class="form-label">Kelurahan</label>
                <select class="form-select" id="subdistrict" name="subdistrict_id" disabled required>
                    <option value="" disabled selected>Pilih Kelurahan</option>
                </select>
            </div>

            <!-- Harga -->
            <div class="mb-3">
                <label for="price" class="form-label">Harga (Rp)</label>
                <input type="text" class="form-control" id="price" name="price" placeholder="Masukkan harga sewa" required oninput="formatRupiah(this)">
            </div>

            <!-- Deskripsi -->
            <div class="mb-3">
                <label for="description" class="form-label">Deskripsi</label>
                <textarea class="form-control" id="description" name="description" rows="4" placeholder="Deskripsi properti" required></textarea>
            </div>

            <!-- Fasilitas -->
            <div class="mb-3">
                <label class="form-label">Fasilitas</label>
                <div id="facilities-list">
                    <div class="input-group mb-2">
                        <input type="text" name="facilities[]" class="form-control" placeholder="Masukkan fasilitas" required>
                        <button type="button" class="btn btn-danger remove-facility">
                            <span class="material-icons-outlined">delete</span>
                        </button>
                    </div>
                </div>
                <button type="button" class="btn btn-secondary mt-2" id="add-facility">Tambah Fasilitas</button>
            </div>

            <!-- Upload Gambar -->
            <div class="mb-3">
                <label class="form-label">Upload Gambar</label>
                <div id="image-list">
                    <div class="input-group mb-2">
                        <input type="file" class="form-control" id="images" name="images[]" multiple accept="image/jpeg,image/png,image/jpg,image/gif">
                        <button type="button" class="btn btn-danger remove-image">
                            <span class="material-icons-outlined">delete</span>
                        </button>
                    </div>
                </div>
                <button type="button" class="btn btn-secondary mt-2" id="add-image">Tambah Gambar</button>
            </div>

            <!-- Tombol Submit -->
            <button type="submit" class="btn btn-primary">Tambah Properti</button>
        </form>
    </div>
</div>

<script>
    document.addEventListener("DOMContentLoaded", function() {
        const imageList = document.getElementById("image-list");
        const addImageBtn = document.getElementById("add-image");

        // Tambah input gambar baru
        addImageBtn.addEventListener("click", function() {
            const newImageField = document.createElement("div");
            newImageField.classList.add("input-group", "mb-2");
            newImageField.innerHTML = `
                <input type="file" name="images[]" class="form-control" accept="image/*" required>
                <button type="button" class="btn btn-danger remove-image">
                    <span class="material-icons-outlined">delete</span>
                </button>
            `;
            imageList.appendChild(newImageField);
        });

        // Hapus input gambar
        imageList.addEventListener("click", function(e) {
            if (e.target.closest(".remove-image")) {
                e.target.closest(".input-group").remove();
            }
        });
    });

    // JavaScript untuk Tambah/Hapus Fasilitas
    document.addEventListener("DOMContentLoaded", function() {
        const facilitiesList = document.getElementById("facilities-list");
        const addFacilityBtn = document.getElementById("add-facility");

        // Tambah fasilitas baru
        addFacilityBtn.addEventListener("click", function() {
            const newFacility = document.createElement("div");
            newFacility.classList.add("input-group", "mb-2");
            newFacility.innerHTML = `
                <input type="text" name="facilities[]" class="form-control" placeholder="Masukkan fasilitas" required>
                <button type="button" class="btn btn-danger remove-facility">
                    <span class="material-icons-outlined">delete</span>
                </button>
            `;
            facilitiesList.appendChild(newFacility);
        });

        // Hapus fasilitas
        facilitiesList.addEventListener("click", function(e) {
            if (e.target.closest(".remove-facility")) {
                e.target.closest(".input-group").remove();
            }
        });
    });

    function formatRupiah(input) {
        let value = input.value.replace(/\D/g, ""); // Hapus semua karakter non-digit
        value = new Intl.NumberFormat("id-ID").format(value); // Format angka ke Rupiah
        input.value = value;
    }
</script>

<script>
    $(document).ready(function() {
        // Provinsi → Kota
        $('#province').on('change', function() {
            var province_id = $(this).val();
            $('#city').html('<option value="" disabled selected>Loading...</option>').prop('disabled', true);
            $('#district').html('<option value="" disabled selected>Pilih Kecamatan</option>').prop('disabled', true);
            $('#subdistrict').html('<option value="" disabled selected>Pilih Kelurahan</option>').prop('disabled', true);

            if (province_id) {
                $.get('/location/cities/' + province_id, function(data) {
                    $('#city').html('<option value="" disabled selected>Pilih Kota</option>');
                    $.each(data, function(index, item) {
                        $('#city').append(`<option value="${item.id}">${item.city_name}</option>`);
                    });
                    $('#city').prop('disabled', false);
                });
            }
        });

        // Kota → Kecamatan
        $('#city').on('change', function() {
            var city_id = $(this).val();
            $('#district').html('<option value="" disabled selected>Loading...</option>').prop('disabled', true);
            $('#subdistrict').html('<option value="" disabled selected>Pilih Kelurahan</option>').prop('disabled', true);

            if (city_id) {
                $.get('/location/districts/' + city_id, function(data) {
                    $('#district').html('<option value="" disabled selected>Pilih Kecamatan</option>');
                    $.each(data, function(index, item) {
                        $('#district').append(`<option value="${item.id}">${item.dis_name}</option>`);
                    });
                    $('#district').prop('disabled', false);
                });
            }
        });

        // Kecamatan → Kelurahan
        $('#district').on('change', function() {
            var district_id = $(this).val();
            $('#subdistrict').html('<option value="" disabled selected>Loading...</option>').prop('disabled', true);

            if (district_id) {
                $.get('/location/subdistricts/' + district_id, function(data) {
                    $('#subdistrict').html('<option value="" disabled selected>Pilih Kelurahan</option>');
                    $.each(data, function(index, item) {
                        $('#subdistrict').append(`<option value="${item.id}">${item.subdis_name}</option>`);
                    });
                    $('#subdistrict').prop('disabled', false);
                });
            }
        });
    });
</script>
@endsection