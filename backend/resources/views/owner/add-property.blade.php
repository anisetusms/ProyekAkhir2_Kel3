@extends('layouts.index-owner')

@section('content')
<div class="card">
    <div class="card-body">
        <h2 class="mb-4">Tambah Properti</h2>
        <form action="{{route('owner.store-property')}}" method="POST" enctype="multipart/form-data">
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

            <!-- Pilih Provinsi -->
            <div class="mb-3">
                <label for="province" class="form-label">Provinsi</label>
                <select class="form-select" id="province" name="province" required>
                    <option value="" disabled selected>Pilih Provinsi</option>
                </select>
            </div>

            <div class="mb-3">
                <label for="city" class="form-label">Kota/Kabupaten</label>
                <select class="form-select" id="city" name="city" disabled required>
                    <option value="" disabled selected>Pilih Kota</option>
                </select>
            </div>

            <div class="mb-3">
                <label for="district" class="form-label">Kecamatan</label>
                <select class="form-select" id="district" name="district" disabled required>
                    <option value="" disabled selected>Pilih Kecamatan</option>
                </select>
            </div>

            <div class="mb-3">
                <label for="subdistrict" class="form-label">Kelurahan</label>
                <select class="form-select" id="subdistrict" name="subdis_id" required>
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
</script>

<!-- JavaScript untuk Tambah/Hapus Fasilitas -->
<script>
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

        // Hapus fasilitas (pastikan event tetap berjalan meskipun klik di ikon)
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
        // Ambil data provinsi saat halaman dimuat
        $.ajax({
            url: '/location/provinces', // Pastikan URL ini sesuai dengan route
            type: 'GET',
            success: function(data) {
                $.each(data, function(key, province) {
                    $('#province').append('<option value="' + province.id + '">' + province.prov_name + '</option>');
                });
            }
        });

        // Ambil data kota/kabupaten berdasarkan provinsi
        $('#province').on('change', function() {
            var province_id = $(this).val();
            $('#city, #district, #subdistrict')
                .html('<option value="" disabled selected>Pilih</option>')
                .prop('disabled', true);

            if (province_id) {
                $.get('/location/cities/' + province_id, function(data) {
                    $.each(data, function(key, city) {
                        $('#city').append('<option value="' + city.id + '">' + city.city_name + '</option>');
                    });
                    $('#city').prop('disabled', false);
                });
            }
        });

        // Ambil data kecamatan berdasarkan kota/kabupaten
        $('#city').on('change', function() {
            var city_id = $(this).val();
            $('#district, #subdistrict').html('<option value="" disabled selected>Pilih</option>').prop('disabled', true);

            if (city_id) {
                $.get('/location/districts/' + city_id, function(data) {
                    $.each(data, function(key, district) {
                        $('#district').append('<option value="' + district.id + '">' + district.dis_name + '</option>');
                    });
                    $('#district').prop('disabled', false);
                });
            }
        });

        // Ambil data kelurahan berdasarkan kecamatan
        $('#district').on('change', function() {
            var district_id = $(this).val();
            $('#subdistrict').html('<option value="" disabled selected>Pilih Kelurahan</option>').prop('disabled', true);

            if (district_id) {
                $.get('/location/subdistricts/' + district_id, function(data) {
                    $.each(data, function(key, subdistrict) {
                        $('#subdistrict').append('<option value="' + subdistrict.id + '">' + subdistrict.subdis_name + '</option>');
                    });
                    $('#subdistrict').prop('disabled', false);
                });
            }
        });


        $('form').on('submit', function(e) {
            e.preventDefault();

            var formData = new FormData(this);

            $.ajax({
                url: $(this).attr('action'),
                type: $(this).attr('method'),
                data: formData,
                processData: false,
                contentType: false,
                success: function(response) {
                    alert('Properti berhasil ditambahkan!');
                    window.location.reload();
                },
                error: function(xhr) {
                    var errors = xhr.responseJSON.errors;
                    if (errors) {
                        $.each(errors, function(key, value) {
                            alert(value[0]); // Tampilkan pesan error
                        });
                    }
                }
            });
        });
    });
</script>

@endsection