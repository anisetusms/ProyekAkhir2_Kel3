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
            <form action="{{ route('admin.properties.store') }}" method="POST" enctype="multipart/form-data" id="propertyForm">
                @csrf

                <!-- Basic Information Section -->
                <div class="row">
                    <div class="col-md-6">
                        <div class="form-group">
                            <label for="name">Nama Properti <span class="text-danger">*</span></label>
                            <input type="text" class="form-control @error('name') is-invalid @enderror"
                                id="name" name="name" value="{{ old('name') }}" required>
                            @error('name')
                            <div class="invalid-feedback">{{ $message }}</div>
                            @enderror
                        </div>

                        <div class="form-group">
                            <label for="property_type_id">Tipe Properti <span class="text-danger">*</span></label>
                            <select class="form-control @error('property_type_id') is-invalid @enderror"
                                id="property_type_id" name="property_type_id" required>
                                <option value="">Pilih Tipe Properti</option>
                                @foreach(\App\Models\PropertyType::all() as $type)
                                <option value="{{ $type->id }}" {{ old('property_type_id') == $type->id ? 'selected' : '' }}>
                                    @if($type->id == 1)
                                    Kost
                                    @elseif($type->id == 2)
                                    Homestay
                                    @else
                                    {{ $type->name }}
                                    @endif
                                </option>
                                @endforeach
                            </select>
                            @error('property_type_id')
                            <div class="invalid-feedback">{{ $message }}</div>
                            @enderror
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
                            <label for="capacity">Kapasitas <span class="text-danger">*</span></label>
                            <input type="number" class="form-control @error('capacity') is-invalid @enderror"
                                id="capacity" name="capacity" value="{{ old('capacity', 1) }}" min="1" required>
                            @error('capacity')
                            <div class="invalid-feedback">{{ $message }}</div>
                            @enderror
                        </div>
                    </div>

                    <div class="col-md-6">
                        <div class="form-group">
                            <label for="description">Deskripsi <span class="text-danger">*</span></label>
                            <textarea class="form-control @error('description') is-invalid @enderror"
                                id="description" name="description" rows="3" required>{{ old('description') }}</textarea>
                            @error('description')
                            <div class="invalid-feedback">{{ $message }}</div>
                            @enderror
                        </div>

                        <div class="form-group">
                            <label for="rules">Peraturan</label>
                            <textarea class="form-control @error('rules') is-invalid @enderror"
                                id="rules" name="rules" rows="2">{{ old('rules') }}</textarea>
                            @error('rules')
                            <div class="invalid-feedback">{{ $message }}</div>
                            @enderror
                        </div>

                        <div class="form-group">
                            <label for="image">Gambar Utama</label>
                            <div class="custom-file">
                                <input type="file" class="custom-file-input @error('image') is-invalid @enderror"
                                    id="image" name="image" accept="image/*">
                                <label class="custom-file-label" for="image">Pilih file...</label>
                                @error('image')
                                <div class="invalid-feedback">{{ $message }}</div>
                                @enderror
                            </div>
                            <small class="form-text text-muted">Format: JPEG, PNG, JPG, GIF (Maks 2MB)</small>
                        </div>
                    </div>
                </div>

                <!-- Location Section -->
                <div class="row mt-3">
                    <div class="col-md-3">
                        <div class="form-group">
                            <label for="province_id">Provinsi <span class="text-danger">*</span></label>
                            <select class="form-control @error('province_id') is-invalid @enderror"
                                id="province_id" name="province_id" required>
                                <option value="">Pilih Provinsi</option>
                                @foreach($provinces as $province)
                                <option value="{{ $province->id }}" {{ old('province_id') == $province->id ? 'selected' : '' }}>
                                    {{ $province->prov_name }}
                                </option>
                                @endforeach
                            </select>
                            @error('province_id')
                            <div class="invalid-feedback">{{ $message }}</div>
                            @enderror
                        </div>
                    </div>

                    <div class="col-md-3">
                        <div class="form-group">
                            <label for="city_id">Kota/Kabupaten <span class="text-danger">*</span></label>
                            <select class="form-control @error('city_id') is-invalid @enderror"
                                id="city_id" name="city_id" required disabled>
                                <option value="">Pilih Provinsi terlebih dahulu</option>
                            </select>
                            @error('city_id')
                            <div class="invalid-feedback">{{ $message }}</div>
                            @enderror
                        </div>
                    </div>

                    <div class="col-md-3">
                        <div class="form-group">
                            <label for="district_id">Kecamatan <span class="text-danger">*</span></label>
                            <select class="form-control @error('district_id') is-invalid @enderror"
                                id="district_id" name="district_id" required disabled>
                                <option value="">Pilih Kota terlebih dahulu</option>
                            </select>
                            @error('district_id')
                            <div class="invalid-feedback">{{ $message }}</div>
                            @enderror
                        </div>
                    </div>

                    <div class="col-md-3">
                        <div class="form-group">
                            <label for="subdistrict_id">Kelurahan <span class="text-danger">*</span></label>
                            <select class="form-control @error('subdistrict_id') is-invalid @enderror"
                                id="subdistrict_id" name="subdistrict_id" required disabled>
                                <option value="">Pilih Kecamatan terlebih dahulu</option>
                            </select>
                            @error('subdistrict_id')
                            <div class="invalid-feedback">{{ $message }}</div>
                            @enderror
                        </div>
                    </div>
                </div>

                <!-- Property Type Specific Sections -->
                <div id="kostFields" style="display: {{ old('property_type_id') == 1 ? 'block' : 'none' }};">
                    <div class="row mt-3">
                        <div class="col-md-4">
                            <div class="form-group">
                                <label for="kost_type">Tipe Kost <span class="text-danger">*</span></label>
                                <select class="form-control @error('kost_type') is-invalid @enderror"
                                    id="kost_type" name="kost_type" required>
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

                        <div class="col-md-4">
                            <div class="form-group">
                                <label for="total_rooms">Total Kamar <span class="text-danger">*</span></label>
                                <input type="number" class="form-control @error('total_rooms') is-invalid @enderror"
                                    id="total_rooms" name="total_rooms" value="{{ old('total_rooms') }}" min="1" required>
                                @error('total_rooms')
                                <div class="invalid-feedback">{{ $message }}</div>
                                @enderror
                            </div>
                        </div>

                        <div class="col-md-4">
                            <div class="form-group">
                                <label for="available_rooms">Kamar Tersedia <span class="text-danger">*</span></label>
                                <input type="number" class="form-control @error('available_rooms') is-invalid @enderror"
                                    id="available_rooms" name="available_rooms" value="{{ old('available_rooms') }}" min="1" required>
                                @error('available_rooms')
                                <div class="invalid-feedback">{{ $message }}</div>
                                @enderror
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-6">
                            <div class="form-group">
                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox" id="meal_included" name="meal_included" value="1" {{ old('meal_included') ? 'checked' : '' }}>
                                    <label class="form-check-label" for="meal_included">
                                        Termasuk makan
                                    </label>
                                </div>
                            </div>
                        </div>

                        <div class="col-md-6">
                            <div class="form-group">
                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox" id="laundry_included" name="laundry_included" value="1" {{ old('laundry_included') ? 'checked' : '' }}>
                                    <label class="form-check-label" for="laundry_included">
                                        Termasuk laundry
                                    </label>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div id="homestayFields" style="display: {{ old('property_type_id') == 2 ? 'block' : 'none' }};">
                    <div class="row mt-3">
                        <div class="col-md-4">
                            <div class="form-group">
                                <label for="total_units">Total Unit <span class="text-danger">*</span></label>
                                <input type="number" class="form-control @error('total_units') is-invalid @enderror"
                                    id="total_units" name="total_units" value="{{ old('total_units') }}" min="1" required>
                                @error('total_units')
                                <div class="invalid-feedback">{{ $message }}</div>
                                @enderror
                            </div>
                        </div>

                        <div class="col-md-4">
                            <div class="form-group">
                                <label for="available_units">Unit tersedia <span class="text-danger">*</span></label>
                                <input type="number" class="form-control @error('available_units') is-invalid @enderror"
                                    id="available_units" name="available_units" value="{{ old('available_units') }}" min="1" required>
                                @error('available_units')
                                <div class="invalid-feedback">{{ $message }}</div>
                                @enderror
                            </div>
                        </div>

                        <div class="col-md-4">
                            <div class="form-group">
                                <label for="minimum_stay">Minimal Menginap (malam) <span class="text-danger">*</span></label>
                                <input type="number" class="form-control @error('minimum_stay') is-invalid @enderror"
                                    id="minimum_stay" name="minimum_stay" value="{{ old('minimum_stay') }}" min="1" required>
                                @error('minimum_stay')
                                <div class="invalid-feedback">{{ $message }}</div>
                                @enderror
                            </div>
                        </div>

                        <div class="col-md-4">
                            <div class="form-group">
                                <label for="maximum_guest">Maksimal Tamu per Unit <span class="text-danger">*</span></label>
                                <input type="number" class="form-control @error('maximum_guest') is-invalid @enderror"
                                    id="maximum_guest" name="maximum_guest" value="{{ old('maximum_guest') }}" min="1" required>
                                @error('maximum_guest')
                                <div class="invalid-feedback">{{ $message }}</div>
                                @enderror
                            </div>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-md-6">
                            <div class="form-group">
                                <label for="checkin_time">Waktu Check-in <span class="text-danger">*</span></label>
                                <input type="time" class="form-control @error('checkin_time') is-invalid @enderror"
                                    id="checkin_time" name="checkin_time" value="{{ old('checkin_time', '14:00') }}" required>
                                @error('checkin_time')
                                <div class="invalid-feedback">{{ $message }}</div>
                                @enderror
                            </div>
                        </div>

                        <div class="col-md-6">
                            <div class="form-group">
                                <label for="checkout_time">Waktu Check-out <span class="text-danger">*</span></label>
                                <input type="time" class="form-control @error('checkout_time') is-invalid @enderror"
                                    id="checkout_time" name="checkout_time" value="{{ old('checkout_time', '12:00') }}" required>
                                @error('checkout_time')
                                <div class="invalid-feedback">{{ $message }}</div>
                                @enderror
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Coordinates and Address -->
                <div class="row mt-3">
                    <div class="col-md-6">
                        <div class="form-group">
                            <label for="latitude">Latitude <span class="text-danger">*</span></label>
                            <input type="text" class="form-control @error('latitude') is-invalid @enderror"
                                id="latitude" name="latitude" value="{{ old('latitude') }}" required>
                            @error('latitude')
                            <div class="invalid-feedback">{{ $message }}</div>
                            @enderror
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="form-group">
                            <label for="longitude">Longitude <span class="text-danger">*</span></label>
                            <input type="text" class="form-control @error('longitude') is-invalid @enderror"
                                id="longitude" name="longitude" value="{{ old('longitude') }}" required>
                            @error('longitude')
                            <div class="invalid-feedback">{{ $message }}</div>
                            @enderror
                        </div>
                    </div>
                </div>

                <div class="form-group">
                    <label for="address">Alamat Lengkap <span class="text-danger">*</span></label>
                    <textarea class="form-control @error('address') is-invalid @enderror"
                        id="address" name="address" rows="2" required>{{ old('address') }}</textarea>
                    @error('address')
                    <div class="invalid-feedback">{{ $message }}</div>
                    @enderror
                </div>

                <!-- Submit Button -->
                <div class="form-group mt-4">
                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-save"></i> Simpan Properti
                    </button>
                    <button type="reset" class="btn btn-secondary">
                        <i class="fas fa-undo"></i> Reset Form
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>
@endsection

@push('scripts')
<script>
    $(document).ready(function() {
        // Toggle property type specific fields
        function togglePropertyFields() {
            const propertyTypeId = $('#property_type_id').val();
            $('#kostFields, #homestayFields').hide();

            if (propertyTypeId == 1) { // Kost
                $('#kostFields').show();
                $('#kostFields input, #kostFields select').prop('required', true);
                $('#homestayFields input, #homestayFields select').prop('required', false);
            } else if (propertyTypeId == 2) { // Homestay
                $('#homestayFields').show();
                $('#homestayFields input, #homestayFields select').prop('required', true);
                $('#kostFields input, #kostFields select').prop('required', false);
            }
        }

        // Initial toggle
        togglePropertyFields();

        // On property type change
        $('#property_type_id').change(function() {
            togglePropertyFields();
        });

        // File input label
        $('.custom-file-input').on('change', function() {
            let fileName = $(this).val().split('\\').pop();
            $(this).next('.custom-file-label').addClass("selected").html(fileName);
        });

        // Location dropdown handling
        function loadDropdown(url, targetSelector, defaultText) {
            const $target = $(targetSelector);
            $target.html('<option value="">Memuat...</option>').prop('disabled', true);

            $.ajax({
                url: url,
                type: 'GET',
                dataType: 'json',
                success: function(data) {
                    let options = `<option value="">${defaultText}</option>`;
                    if (data && data.length > 0) {
                        data.forEach(item => {
                            options += `<option value="${item.id}">${item.name}</option>`;
                        });
                        $target.html(options).prop('disabled', false);

                        // Set old value if exists
                        const oldValue = $target.data('old');
                        if (oldValue) {
                            $target.val(oldValue);
                        }
                    } else {
                        $target.html('<option value="">Data tidak tersedia</option>');
                    }
                },
                error: function(xhr) {
                    console.error('Error:', xhr.responseText);
                    $target.html('<option value="">Gagal memuat data</option>');
                }
            });
        }

        // Province change handler
        $('#province_id').change(function() {
            const provinceId = $(this).val();
            if (provinceId) {
                loadDropdown(
                    `/admin/properties/cities/${provinceId}`,
                    '#city_id',
                    'Pilih Kabupaten/Kota'
                );
            } else {
                $('#city_id, #district_id, #subdistrict_id')
                    .html('<option value="">Pilih terlebih dahulu</option>')
                    .prop('disabled', true);
            }
        });

        // City change handler
        $('#city_id').change(function() {
            const cityId = $(this).val();
            if (cityId) {
                loadDropdown(
                    `/admin/properties/districts/${cityId}`,
                    '#district_id',
                    'Pilih Kecamatan'
                );
            } else {
                $('#district_id, #subdistrict_id')
                    .html('<option value="">Pilih terlebih dahulu</option>')
                    .prop('disabled', true);
            }
        });

        // District change handler
        $('#district_id').change(function() {
            const districtId = $(this).val();
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