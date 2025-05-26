@extends('layouts.admin')

@section('title', 'Edit Properti')

@section('content')
<div class="container-fluid">
    <div class="d-sm-flex align-items-center justify-content-between mb-4">
        <a href="{{ route('admin.properties.show', $property->id) }}" class="d-none d-sm-inline-block btn btn-sm btn-secondary shadow-sm">
            <i class="fas fa-arrow-left fa-sm text-white-50"></i> Kembali
        </a>
    </div>

    @if(session('success'))
    <div class="alert alert-success alert-dismissible fade show" role="alert">
        <i class="fas fa-check-circle mr-1"></i> {{ session('success') }}
        <button type="button" class="close" data-dismiss="alert" aria-label="Close">
            <span aria-hidden="true">&times;</span>
        </button>
    </div>
    @endif

    @if(session('error'))
    <div class="alert alert-danger alert-dismissible fade show" role="alert">
        <i class="fas fa-exclamation-circle mr-1"></i> {{ session('error') }}
        <button type="button" class="close" data-dismiss="alert" aria-label="Close">
            <span aria-hidden="true">&times;</span>
        </button>
    </div>
    @endif

    <div class="card shadow mb-4">
        <div class="card-header py-3">
            <h6 class="m-0 font-weight-bold text-primary">Form Edit Properti</h6>
        </div>
        <div class="card-body">
            <form action="{{ route('admin.properties.update', $property->id) }}" method="POST" enctype="multipart/form-data">
                @csrf
                @method('PUT')
                <!-- Hidden fields for latitude and longitude -->
                <input type="hidden" name="latitude" value="{{ old('latitude', $property->latitude ?? 0) }}">
                <input type="hidden" name="longitude" value="{{ old('longitude', $property->longitude ?? 0) }}">

                <div class="row">
                    <div class="col-md-6">
                        <div class="form-group">
                            <label for="name">Nama Properti <span class="text-danger">*</span></label>
                            <input type="text" class="form-control @error('name') is-invalid @enderror" id="name" name="name" value="{{ old('name', $property->name) }}" required>
                            @error('name')
                            <div class="invalid-feedback">{{ $message }}</div>
                            @enderror
                        </div>

                        <div class="form-group">
                            <label for="property_type_id">Tipe Properti <span class="text-danger">*</span></label>
                            <select class="form-control" id="property_type_id" name="property_type_id" disabled>
                                <option value="1" {{ $property->property_type_id == 1 ? 'selected' : '' }}>Kost</option>
                                <option value="2" {{ $property->property_type_id == 2 ? 'selected' : '' }}>Homestay</option>
                            </select>
                            <input type="hidden" name="property_type_id" value="{{ old('property_type_id', $property->property_type_id) }}">
                        </div>

                        @if($property->property_type_id == 1)
                        <div class="form-group">
                            <label for="kost_type">Tipe Kost <span class="text-danger">*</span></label>
                            <select class="form-control @error('kost_type') is-invalid @enderror" id="kost_type" name="kost_type">
                                <option value="putra" {{ old('kost_type', $property->kostDetail->kost_type ?? '') == 'putra' ? 'selected' : '' }}>Putra</option>
                                <option value="putri" {{ old('kost_type', $property->kostDetail->kost_type ?? '') == 'putri' ? 'selected' : '' }}>Putri</option>
                                <option value="campur" {{ old('kost_type', $property->kostDetail->kost_type ?? '') == 'campur' ? 'selected' : '' }}>Campur</option>
                            </select>
                            @error('kost_type')
                            <div class="invalid-feedback">{{ $message }}</div>
                            @enderror
                        </div>
                        @endif

                        <div class="form-group">
                            <label for="price">Harga (Rp) <span class="text-danger">*</span></label>
                            <input type="number" class="form-control @error('price') is-invalid @enderror" id="price" name="price" value="{{ old('price', $property->price) }}" min="0" required>
                            @error('price')
                            <div class="invalid-feedback">{{ $message }}</div>
                            @enderror
                        </div>

                        <div class="form-group">
                            <label for="image">Gambar Utama</label>
                            <div class="custom-file">
                                <input type="file" class="custom-file-input @error('image') is-invalid @enderror" id="image" name="image">
                                <label class="custom-file-label" for="image">Pilih file...</label>
                                @error('image')
                                <div class="invalid-feedback">{{ $message }}</div>
                                @enderror
                            </div>
                            <small class="form-text text-muted">Biarkan kosong jika tidak ingin mengubah gambar</small>
                            @if($property->image)
                            <div class="mt-2">
                                <img src="{{ asset('storage/' . $property->image) }}" alt="Current Image" class="img-thumbnail" width="150">
                            </div>
                            @endif
                        </div>
                    </div>

                    <div class="col-md-6">
                        <div class="form-group">
                            <label for="description">Deskripsi <span class="text-danger">*</span></label>
                            <textarea class="form-control @error('description') is-invalid @enderror" id="description" name="description" rows="3" required>{{ old('description', $property->description) }}</textarea>
                            @error('description')
                            <div class="invalid-feedback">{{ $message }}</div>
                            @enderror
                        </div>

                        <div class="form-group">
                            <label for="address">Alamat Lengkap <span class="text-danger">*</span></label>
                            <textarea class="form-control @error('address') is-invalid @enderror" id="address" name="address" rows="2" required>{{ old('address', $property->address) }}</textarea>
                            @error('address')
                            <div class="invalid-feedback">{{ $message }}</div>
                            @enderror
                        </div>

                        <div class="form-group">
                            <label for="province_id">Provinsi <span class="text-danger">*</span></label>
                            <select class="form-control @error('province_id') is-invalid @enderror" id="province_id" name="province_id" required>
                                <option value="">Pilih Provinsi</option>
                                @foreach($provinces as $province)
                                <option value="{{ $province->id }}" {{ old('province_id', $property->province_id) == $province->id ? 'selected' : '' }}>
                                    {{ $province->prov_name }}
                                </option>
                                @endforeach
                            </select>
                            @error('province_id')
                            <div class="invalid-feedback">{{ $message }}</div>
                            @enderror
                        </div>

                        <div class="form-group">
                            <label for="city_id">Kota/Kabupaten <span class="text-danger">*</span></label>
                            <select class="form-control @error('city_id') is-invalid @enderror" id="city_id" name="city_id" required>
                                <option value="">Pilih Kota/Kabupaten</option>
                                @foreach($cities as $city)
                                <option value="{{ $city->id }}" {{ old('city_id', $property->city_id) == $city->id ? 'selected' : '' }}>
                                    {{ $city->city_name }}
                                </option>
                                @endforeach
                            </select>
                            @error('city_id')
                            <div class="invalid-feedback">{{ $message }}</div>
                            @enderror
                        </div>

                        <div class="form-group">
                            <label for="district_id">Kecamatan <span class="text-danger">*</span></label>
                            <select class="form-control @error('district_id') is-invalid @enderror" id="district_id" name="district_id" required>
                                <option value="">Pilih Kecamatan</option>
                                @foreach($districts as $district)
                                <option value="{{ $district->id }}" {{ old('district_id', $property->district_id) == $district->id ? 'selected' : '' }}>
                                    {{ $district->dis_name }}
                                </option>
                                @endforeach
                            </select>
                            @error('district_id')
                            <div class="invalid-feedback">{{ $message }}</div>
                            @enderror
                        </div>

                        <div class="form-group">
                            <label for="subdistrict_id">Kelurahan <span class="text-danger">*</span></label>
                            <select class="form-control @error('subdistrict_id') is-invalid @enderror" id="subdistrict_id" name="subdistrict_id" required>
                                <option value="">Pilih Kelurahan</option>
                                @foreach($subdistricts as $subdistrict)
                                <option value="{{ $subdistrict->id }}" {{ old('subdistrict_id', $property->subdistrict_id) == $subdistrict->id ? 'selected' : '' }}>
                                    {{ $subdistrict->subdis_name }}
                                </option>
                                @endforeach
                            </select>
                            @error('subdistrict_id')
                            <div class="invalid-feedback">{{ $message }}</div>
                            @enderror
                        </div>
                    </div>
                </div>

                <div class="row mt-3">
                    <div class="col-md-12">
                        <div class="card mb-4">
                            <div class="card-header py-3 bg-primary text-white">
                                <h6 class="m-0 font-weight-bold">
                                    {{ $property->property_type_id == 1 ? 'Detail Kost' : 'Detail Homestay' }}
                                </h6>
                            </div>
                            <div class="card-body">
                                @if($property->property_type_id == 1)
                                <!-- Detail Kost -->
                                <div class="row">
                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label for="total_rooms">Jumlah Kamar Total <span class="text-danger">*</span></label>
                                            <input type="number" class="form-control @error('total_rooms') is-invalid @enderror" id="total_rooms" name="total_rooms" value="{{ old('total_rooms', $property->kostDetail->total_rooms ?? '') }}" min="1" required>
                                            @error('total_rooms')
                                            <div class="invalid-feedback">{{ $message }}</div>
                                            @enderror
                                        </div>

                                        <div class="form-group">
                                            <label for="available_rooms">Jumlah Kamar Tersedia <span class="text-danger">*</span></label>
                                            <input type="number" class="form-control @error('available_rooms') is-invalid @enderror" id="available_rooms" name="available_rooms" value="{{ old('available_rooms', $property->kostDetail->available_rooms ?? '') }}" min="0" required>
                                            @error('available_rooms')
                                            <div class="invalid-feedback">{{ $message }}</div>
                                            @enderror
                                        </div>
                                    </div>
                                </div>
                                @else
                                <!-- Detail Homestay -->
                                <div class="row">
                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label for="total_units">Jumlah Unit Total <span class="text-danger">*</span></label>
                                            <input type="number" class="form-control @error('total_units') is-invalid @enderror" id="total_units" name="total_units" value="{{ old('total_units', $property->homestayDetail->total_units ?? '') }}" min="1" required>
                                            @error('total_units')
                                            <div class="invalid-feedback">{{ $message }}</div>
                                            @enderror
                                        </div>

                                        <div class="form-group">
                                            <label for="available_units">Jumlah Unit Tersedia <span class="text-danger">*</span></label>
                                            <input type="number" class="form-control @error('available_units') is-invalid @enderror" id="available_units" name="available_units" value="{{ old('available_units', $property->homestayDetail->available_units ?? '') }}" min="0" required>
                                            @error('available_units')
                                            <div class="invalid-feedback">{{ $message }}</div>
                                            @enderror
                                        </div>

                                        <div class="form-group">
                                            <label for="minimum_stay">Minimum Menginap (hari) <span class="text-danger">*</span></label>
                                            <input type="number" class="form-control @error('minimum_stay') is-invalid @enderror" id="minimum_stay" name="minimum_stay" value="{{ old('minimum_stay', $property->homestayDetail->minimum_stay ?? 1) }}" min="1" required>
                                            @error('minimum_stay')
                                            <div class="invalid-feedback">{{ $message }}</div>
                                            @enderror
                                        </div>
                                    </div>

                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label for="maximum_guest">Maksimum Tamu <span class="text-danger">*</span></label>
                                            <input type="number" class="form-control @error('maximum_guest') is-invalid @enderror" id="maximum_guest" name="maximum_guest" value="{{ old('maximum_guest', $property->homestayDetail->maximum_guest ?? 1) }}" min="1" required>
                                            @error('maximum_guest')
                                            <div class="invalid-feedback">{{ $message }}</div>
                                            @enderror
                                        </div>

                                        <div class="form-group">
                                            <label for="checkin_time">Jam Check-in <span class="text-danger">*</span></label>
                                            <input type="time" class="form-control @error('checkin_time') is-invalid @enderror"
                                                id="checkin_time" name="checkin_time"
                                                value="{{ old('checkin_time', optional($property->homestayDetail)->checkin_time ? \Carbon\Carbon::parse($property->homestayDetail->checkin_time)->format('H:i') : '14:00') }}"
                                                required>
                                            @error('checkin_time')
                                            <div class="invalid-feedback">{{ $message }}</div>
                                            @enderror
                                        </div>

                                        <div class="form-group">
                                            <label for="checkout_time">Jam Check-out <span class="text-danger">*</span></label>
                                            <input type="time" class="form-control @error('checkout_time') is-invalid @enderror"
                                                id="checkout_time" name="checkout_time"
                                                value="{{ old('checkout_time', optional($property->homestayDetail)->checkout_time ? \Carbon\Carbon::parse($property->homestayDetail->checkout_time)->format('H:i') : '12:00') }}"
                                                required>
                                            @error('checkout_time')
                                            <div class="invalid-feedback">{{ $message }}</div>
                                            @enderror
                                        </div>
                                    </div>
                                </div>
                                @endif

                                <div class="form-group mt-3">
                                    <label for="rules">Peraturan</label>
                                    <textarea class="form-control @error('rules') is-invalid @enderror" id="rules" name="rules" rows="3">{{ old('rules', $property->rules ?? '') }}</textarea>
                                    @error('rules')
                                    <div class="invalid-feedback">{{ $message }}</div>
                                    @enderror
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="form-group mt-4">
                    <button type="submit" class="btn btn-primary btn-lg">
                        <i class="fas fa-save"></i> Simpan Perubahan
                    </button>
                    <a href="{{ route('admin.properties.index', $property->id) }}" class="btn btn-secondary btn-lg">
                        <i class="fas fa-times"></i> Batal
                    </a>
                </div>
            </form>
        </div>
    </div>
</div>
@endsection

@section('scripts')
<script>
    document.querySelector('.custom-file-input').addEventListener('change', function(e) {
        var fileName = document.getElementById("image").files[0].name;
        var nextSibling = e.target.nextElementSibling
        nextSibling.innerText = fileName
    })
    // Menampilkan nama file yang dipilih
    $('.custom-file-input').on('change', function() {
        let fileName = $(this).val().split('\\').pop();
        $(this).next('.custom-file-label').addClass("selected").html(fileName);
    });

    // Dynamic location dropdown
    $('#province_id').change(function() {
        const provinceId = $(this).val();
        if (provinceId) {
            $.ajax({
                url: '/admin/properties/cities/' + provinceId,
                type: 'GET',
                dataType: 'json',
                success: function(data) {
                    $('#city_id').empty().append('<option value="">Pilih Kota/Kabupaten</option>');
                    $('#district_id').empty().append('<option value="">Pilih Kecamatan</option>');
                    $('#subdistrict_id').empty().append('<option value="">Pilih Kelurahan</option>');

                    $.each(data, function(key, value) {
                        $('#city_id').append(`<option value="${value.id}">${value.city_name}</option>`);
                    });
                },
                error: function(xhr, status, error) {
                    console.error('Error loading cities:', error);
                    alert('Gagal memuat data kota. Silakan coba lagi.');
                }
            });
        }
    });

    $('#city_id').change(function() {
        const cityId = $(this).val();
        if (cityId) {
            $.ajax({
                url: '/admin/properties/districts/' + cityId,
                type: 'GET',
                dataType: 'json',
                success: function(data) {
                    $('#district_id').empty().append('<option value="">Pilih Kecamatan</option>');
                    $('#subdistrict_id').empty().append('<option value="">Pilih Kelurahan</option>');

                    $.each(data, function(key, value) {
                        $('#district_id').append(`<option value="${value.id}">${value.dis_name}</option>`);
                    });
                },
                error: function(xhr, status, error) {
                    console.error('Error loading districts:', error);
                    alert('Gagal memuat data kecamatan. Silakan coba lagi.');
                }
            });
        }
    });

    $('#district_id').change(function() {
        const districtId = $(this).val();
        if (districtId) {
            $.ajax({
                url: '/admin/properties/subdistricts/' + districtId,
                type: 'GET',
                dataType: 'json',
                success: function(data) {
                    $('#subdistrict_id').empty().append('<option value="">Pilih Kelurahan</option>');

                    $.each(data, function(key, value) {
                        $('#subdistrict_id').append(`<option value="${value.id}">${value.subdis_name}</option>`);
                    });
                },
                error: function(xhr, status, error) {
                    console.error('Error loading subdistricts:', error);
                    alert('Gagal memuat data kelurahan. Silakan coba lagi.');
                }
            });
        }
    });
</script>
@endsection