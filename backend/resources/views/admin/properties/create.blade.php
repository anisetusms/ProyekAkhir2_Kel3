@extends('layouts.admin')

@section('content')
<div class="container-fluid">
    <div class="d-sm-flex align-items-center justify-content-between mb-4">
        <h1 class="h3 mb-0 text-gray-800">Tambah Properti Baru</h1>
        <a href="{{ route('admin.properties.index') }}" class="d-none d-sm-inline-block btn btn-sm btn-secondary shadow-sm">
            <i class="fas fa-arrow-left fa-sm text-white-50"></i> Kembali
        </a>
    </div>

    <div class="card shadow mb-4">
        <div class="card-header py-3">
            <h6 class="m-0 font-weight-bold text-primary">Form Properti Baru</h6>
        </div>
        <div class="card-body">
            <form action="{{ route('admin.properties.store') }}" method="POST" enctype="multipart/form-data">
                @csrf

                <div class="row">
                    <div class="col-md-6">
                        <!-- Informasi Dasar Properti -->
                        <div class="form-group">
                            <label for="name">Nama Properti <span class="text-danger">*</span></label>
                            <input type="text" class="form-control @error('name') is-invalid @enderror"
                                id="name" name="name" value="{{ old('name') }}" required>
                            @error('name')
                            <div class="invalid-feedback">{{ $message }}</div>
                            @enderror
                        </div>

                        <div class="form-group">
                            <label for="property_type">Tipe Properti <span class="text-danger">*</span></label>
                            <select class="form-control @error('property_type') is-invalid @enderror"
                                id="property_type" name="property_type" required>
                                <option value="">Pilih Tipe</option>
                                <option value="kost" {{ old('property_type') == 'kost' ? 'selected' : '' }}>Kost</option>
                                <option value="homestay" {{ old('property_type') == 'homestay' ? 'selected' : '' }}>Homestay</option>
                            </select>
                            @error('property_type')
                            <div class="invalid-feedback">{{ $message }}</div>
                            @enderror
                        </div>

                        <!-- Form Detail Kost (akan muncul jika tipe kost dipilih) -->
                        <div id="kost-details" style="display: {{ old('property_type') == 'kost' ? 'block' : 'none' }};">
                            <div class="form-group">
                                <label for="kost_type">Tipe Kost <span class="text-danger">*</span></label>
                                <select class="form-control @error('kost_type') is-invalid @enderror"
                                    id="kost_type" name="kost_type">
                                    <option value="">Pilih Tipe Kost</option>
                                    <option value="putra" {{ old('kost_type') == 'putra' ? 'selected' : '' }}>Putra</option>
                                    <option value="putri" {{ old('kost_type') == 'putri' ? 'selected' : '' }}>Putri</option>
                                    <option value="campur" {{ old('kost_type') == 'campur' ? 'selected' : '' }}>Campur</option>
                                </select>
                                @error('kost_type')
                                <div class="invalid-feedback">{{ $message }}</div>
                                @enderror
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="price">Harga (Rp) <span class="text-danger">*</span></label>
                            <input type="number" class="form-control @error('price') is-invalid @enderror"
                                id="price" name="price" value="{{ old('price') }}" min="0" required>
                            @error('price')
                            <div class="invalid-feedback">{{ $message }}</div>
                            @enderror
                        </div>

                        <div class="form-group">
                            <label for="image">Gambar Utama</label>
                            <div class="custom-file">
                                <input type="file" class="custom-file-input @error('image') is-invalid @enderror"
                                    id="image" name="image">
                                <label class="custom-file-label" for="image">Pilih file...</label>
                                @error('image')
                                <div class="invalid-feedback">{{ $message }}</div>
                                @enderror
                            </div>
                            <small class="form-text text-muted">Format: JPEG, PNG, JPG (Maks 2MB)</small>
                        </div>
                    </div>

                    <div class="col-md-6">
                        <!-- Deskripsi dan Alamat -->
                        <div class="form-group">
                            <label for="description">Deskripsi <span class="text-danger">*</span></label>
                            <textarea class="form-control @error('description') is-invalid @enderror"
                                id="description" name="description" rows="3" required>{{ old('description') }}</textarea>
                            @error('description')
                            <div class="invalid-feedback">{{ $message }}</div>
                            @enderror
                        </div>

                        <div class="form-group">
                            <label for="address">Alamat Lengkap <span class="text-danger">*</span></label>
                            <textarea class="form-control @error('address') is-invalid @enderror"
                                id="address" name="address" rows="2" required>{{ old('address') }}</textarea>
                            @error('address')
                            <div class="invalid-feedback">{{ $message }}</div>
                            @enderror
                        </div>

                        <!-- Form Lokasi -->
                        @include('admin.properties.partials.location-form')
                    </div>
                </div>

                <!-- Form Detail Homestay (akan muncul jika tipe homestay dipilih) -->
                <div class="row mt-3">
                    <div class="col-md-6">
                        <div id="homestay-details" style="display: {{ old('property_type') == 'homestay' ? 'block' : 'none' }};">
                            @include('admin.properties.partials.homestay-details')
                        </div>
                    </div>
                </div>

                <!-- Tombol Submit -->
                <div class="form-group mt-4">
                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-save"></i> Simpan
                    </button>
                    <button type="reset" class="btn btn-secondary">
                        <i class="fas fa-undo"></i> Reset
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>
@endsection

@push('scripts')
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
    // Toggle form detail berdasarkan tipe properti
    $('#property_type').change(function() {
        const type = $(this).val();

        $('#kost-details').hide();
        $('#homestay-details').hide();

        if (type === 'kost') {
            $('#kost-details').show();
        } else if (type === 'homestay') {
            $('#homestay-details').show();
        }
    });

    // Menampilkan nama file yang dipilih
    $('.custom-file-input').on('change', function() {
        let fileName = $(this).val().split('\\').pop();
        $(this).next('.custom-file-label').addClass("selected").html(fileName);
    });

    // Menampilkan nama file yang dipilih
    $('.custom-file-input').on('change', function() {
        let fileName = $(this).val().split('\\').pop();
        $(this).next('.custom-file-label').addClass("selected").html(fileName);
    });

    $(document).ready(function() {
        console.log('Location form initialized');

        // Fungsi untuk memuat dropdown
        function loadDropdown(url, targetSelector, defaultText) {
            const $target = $(targetSelector);
            $target.html('<option value="">Memuat...</option>').prop('disabled', true);

            $.ajax({
                url: url,
                type: 'GET',
                dataType: 'json',
                success: function(data) {
                    console.log('Data received:', data);

                    let options = `<option value="">${defaultText}</option>`;
                    if (data && data.length > 0) {
                        data.forEach(item => {
                            options += `<option value="${item.id}">${item.name}</option>`;
                        });
                        $target.html(options).prop('disabled', false);
                    } else {
                        $target.html('<option value="">Data tidak tersedia</option>');
                    }
                },
                error: function(xhr, status, error) {
                    console.error('Error:', error);
                    $target.html('<option value="">Gagal memuat data</option>');

                    // Untuk debugging, tampilkan response error
                    console.log('Response:', xhr.responseText);
                    alert('Error memuat data. Lihat console untuk detail.');
                }
            });
        }

        // Event handler untuk provinsi
        $('#province_id').change(function() {
            const provinceId = $(this).val();
            if (provinceId) {
                loadDropdown(
                    "{{ route('admin.properties.cities', '') }}/" + provinceId,
                    '#city_id',
                    'Pilih Kabupaten/Kota'
                );
            } else {
                $('#city_id, #district_id, #subdistrict_id')
                    .html('<option value="">Pilih terlebih dahulu</option>')
                    .prop('disabled', true);
            }
        });

        // Ketika kabupaten dipilih
        $('#city_id').on('change', function() {
            const cityId = $(this).val();
            console.log('Kabupaten dipilih:', cityId);

            if (cityId) {
                loadDropdown(
                    `/admin/properties/districts/${cityId}`,
                    '#district_id',
                    'Pilih Kecamatan'
                );

                // Reset dropdown tergantung
                $('#subdistrict_id').val('').prop('disabled', true);
            } else {
                $('#district_id, #subdistrict_id')
                    .html('<option value="">Pilih terlebih dahulu</option>')
                    .prop('disabled', true);
            }
        });

        // Ketika kecamatan dipilih
        $('#district_id').on('change', function() {
            const districtId = $(this).val();
            console.log('Kecamatan dipilih:', districtId);

            if (districtId) {
                loadDropdown(
                    `/admin/properties/subdistricts/${districtId}`,
                    '#subdistrict_id',
                    'Pilih Kelurahan/Desa'
                );
            } else {
                $('#subdistrict_id')
                    .html('<option value="">Pilih terlebih dahulu</option>')
                    .prop('disabled', true);
            }
        });
    });
</script>
@endpush