@extends('layouts.admin')

@section('title', 'Edit Properti')

@section('content')
<div class="container-fluid">
    <div class="d-sm-flex align-items-center justify-content-between mb-4">
        <h1 class="h3 mb-0 text-gray-800">Edit Properti</h1>
        <a href="{{ route('admin.properties.show', $property->id) }}" class="d-none d-sm-inline-block btn btn-sm btn-secondary shadow-sm">
            <i class="fas fa-arrow-left fa-sm text-white-50"></i> Kembali
        </a>
    </div>

    <div class="card shadow mb-4">
        <div class="card-header py-3">
            <h6 class="m-0 font-weight-bold text-primary">Form Edit Properti</h6>
        </div>
        <div class="card-body">
            <form action="{{ route('admin.properties.update', $property->id) }}" method="POST" enctype="multipart/form-data">
                @csrf
                @method('PUT')
                
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
                            <label for="property_type">Tipe Properti <span class="text-danger">*</span></label>
                            <select class="form-control" id="property_type" name="property_type" disabled>
                                <option>{{ ucfirst($property->property_type) }}</option>
                            </select>
                            <input type="hidden" name="property_type" value="{{ $property->property_type }}">
                        </div>

                        @if($property->property_type === 'kost')
                        <div class="form-group">
                            <label for="kost_type">Tipe Kost <span class="text-danger">*</span></label>
                            <select class="form-control @error('kost_type') is-invalid @enderror" id="kost_type" name="kost_type">
                                <option value="putra" {{ old('kost_type', $property->detail->kost_type) == 'putra' ? 'selected' : '' }}>Putra</option>
                                <option value="putri" {{ old('kost_type', $property->detail->kost_type) == 'putri' ? 'selected' : '' }}>Putri</option>
                                <option value="campur" {{ old('kost_type', $property->detail->kost_type) == 'campur' ? 'selected' : '' }}>Campur</option>
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
                                <img src="{{ $property->image_url }}" alt="Current Image" class="img-thumbnail" width="150">
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

                        @include('admin.properties.partials.location-form', [
                            'province' => $property->province,
                            'city' => $property->city,
                            'district' => $property->district,
                            'subdistrict' => $property->subdistrict
                        ])
                    </div>
                </div>

                <div class="row mt-3">
                    <div class="col-md-6">
                        @if($property->property_type === 'kost')
                            @include('admin.properties.partials.kost-details', ['detail' => $property->detail])
                        @endif
                    </div>
                    <div class="col-md-6">
                        @if($property->property_type === 'homestay')
                            @include('admin.properties.partials.homestay-details', ['detail' => $property->detail])
                        @endif
                    </div>
                </div>

                <div class="form-group mt-4">
                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-save"></i> Simpan Perubahan
                    </button>
                    <a href="{{ route('admin.properties.show', $property->id) }}" class="btn btn-secondary">
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
    // Menampilkan nama file yang dipilih
    $('.custom-file-input').on('change', function() {
        let fileName = $(this).val().split('\\').pop();
        $(this).next('.custom-file-label').addClass("selected").html(fileName);
    });

    // Dynamic location dropdown
    $('#province_id').change(function() {
        const provinceId = $(this).val();
        if (provinceId) {
            $.get('/admin/properties/cities/' + provinceId, function(data) {
                $('#city_id').empty().append('<option value="">Pilih Kota/Kabupaten</option>');
                $('#district_id').empty().append('<option value="">Pilih Kecamatan</option>');
                $('#subdistrict_id').empty().append('<option value="">Pilih Kelurahan</option>');
                
                $.each(data, function(key, value) {
                    $('#city_id').append(`<option value="${key}">${value}</option>`);
                });
            });
        }
    });

    $('#city_id').change(function() {
        const cityId = $(this).val();
        if (cityId) {
            $.get('/admin/properties/districts/' + cityId, function(data) {
                $('#district_id').empty().append('<option value="">Pilih Kecamatan</option>');
                $('#subdistrict_id').empty().append('<option value="">Pilih Kelurahan</option>');
                
                $.each(data, function(key, value) {
                    $('#district_id').append(`<option value="${key}">${value}</option>`);
                });
            });
        }
    });

    $('#district_id').change(function() {
        const districtId = $(this).val();
        if (districtId) {
            $.get('/admin/properties/subdistricts/' + districtId, function(data) {
                $('#subdistrict_id').empty().append('<option value="">Pilih Kelurahan</option>');
                
                $.each(data, function(key, value) {
                    $('#subdistrict_id').append(`<option value="${key}">${value}</option>`);
                });
            });
        }
    });
</script>
@endsection