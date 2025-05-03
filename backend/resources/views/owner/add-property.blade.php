@extends('layouts.index-owner')
@section('content')
<div class="container">
    @if ($errors->any())
        <div class="alert alert-danger">
            <ul>
                @foreach ($errors->all() as $error)
                    <li>{{ $error }}</li>
                @endforeach
            </ul>
        </div>
    @endif
    <h2>Tambah Properti</h2>
    <form action="{{ route('owner.store_property') }}" method="POST" enctype="multipart/form-data">
        @csrf

        <div class="row mb-4">
            <div class="col-md-8">
                <div class="form-group mb-3">
                    <label for="name">Nama Properti</label>
                    <input type="text" id="name" name="name" class="form-control @error('name') is-invalid @enderror" value="{{ old('name') }}" required>
                    @error('name')
                        <div class="invalid-feedback">{{ $message }}</div>
                    @enderror
                </div>

                <div class="form-group mb-3">
                    <label for="description">Deskripsi Properti</label>
                    <textarea id="description" name="description" class="form-control @error('description') is-invalid @enderror" rows="5" required>{{ old('description') }}</textarea>
                    @error('description')
                        <div class="invalid-feedback">{{ $message }}</div>
                    @enderror
                </div>

                <div class="form-group mb-3">
                    <label for="property_type_id">Tipe Properti</label>
                    <select id="property_type_id" name="property_type_id" class="form-control @error('property_type_id') is-invalid @enderror" required>
                        <option value="">Pilih Tipe Properti</option>
                        @foreach ($propertyTypes as $type)
                            <option value="{{ $type->id }}" {{ old('property_type_id') == $type->id ? 'selected' : '' }}>{{ $type->property_type }}</option>
                        @endforeach
                    </select>
                    @error('property_type_id')
                        <div class="invalid-feedback">{{ $message }}</div>
                    @enderror
                </div>
            </div>

            <div class="col-md-4">
                <div class="form-group mb-3">
                    <label for="featured_image">Gambar Utama</label>
                    <div class="border p-2 text-center">
                        <img id="featured-image-preview" src="#" alt="Preview" class="img-fluid mb-2 d-none" style="max-height: 150px;">
                        <input type="file" id="featured_image" name="featured_image" class="form-control-file @error('featured_image') is-invalid @enderror" required onchange="previewFeaturedImage(this)">
                        <small class="text-muted">Format: JPEG, PNG, JPG, GIF (Max 2MB)</small>
                    </div>
                    @error('featured_image')
                        <div class="invalid-feedback d-block">{{ $message }}</div>
                    @enderror
                </div>
            </div>
        </div>

        <div class="card mb-4">
            <div class="card-header bg-primary text-white">
                <h5 class="mb-0">Lokasi Properti</h5>
            </div>
            <div class="card-body">
                <div class="row">
                    <div class="col-md-3">
                        <div class="form-group">
                            <label for="province_id">Provinsi</label>
                            <select id="province_id" name="province_id" class="form-control @error('province_id') is-invalid @enderror" required>
                                <option value="">Pilih Provinsi</option>
                                @foreach ($provinces as $province)
                                    <option value="{{ $province->id }}" {{ old('province_id') == $province->id ? 'selected' : '' }}>{{ $province->prov_name }}</option>
                                @endforeach
                            </select>
                            @error('province_id')
                                <div class="invalid-feedback">{{ $message }}</div>
                            @enderror
                        </div>
                    </div>

                    <div class="col-md-3">
                        <div class="form-group">
                            <label for="city_id">Kabupaten/Kota</label>
                            <select id="city_id" name="city_id" class="form-control @error('city_id') is-invalid @enderror" required>
                                <option value="">Pilih Kabupaten/Kota</option>
                                @if(old('province_id'))
                                    @php
                                        $cities = DB::select('CALL getCities(?)', [old('province_id')]);
                                    @endphp
                                    @foreach($cities as $city)
                                        <option value="{{ $city->id }}" {{ old('city_id') == $city->id ? 'selected' : '' }}>{{ $city->name }}</option>
                                    @endforeach
                                @endif
                            </select>
                            @error('city_id')
                                <div class="invalid-feedback">{{ $message }}</div>
                            @enderror
                        </div>
                    </div>

                    <div class="col-md-3">
                        <div class="form-group">
                            <label for="district_id">Kecamatan</label>
                            <select id="district_id" name="district_id" class="form-control @error('district_id') is-invalid @enderror" required>
                                <option value="">Pilih Kecamatan</option>
                            </select>
                            @error('district_id')
                                <div class="invalid-feedback">{{ $message }}</div>
                            @enderror
                        </div>
                    </div>

                    <div class="col-md-3">
                        <div class="form-group">
                            <label for="subdistrict_id">Kelurahan</label>
                            <select id="subdistrict_id" name="subdistrict_id" class="form-control @error('subdistrict_id') is-invalid @enderror" required>
                                <option value="">Pilih Kelurahan</option>
                            </select>
                            @error('subdistrict_id')
                                <div class="invalid-feedback">{{ $message }}</div>
                            @enderror
                        </div>
                    </div>
                </div>

                <div class="form-group mt-3">
                    <label for="address">Alamat Lengkap</label>
                    <textarea id="address" name="address" class="form-control @error('address') is-invalid @enderror" rows="2" required>{{ old('address') }}</textarea>
                    @error('address')
                        <div class="invalid-feedback">{{ $message }}</div>
                    @enderror
                </div>

                <div class="row mt-3">
                    <div class="col-md-6">
                        <div class="form-group">
                            <label for="latitude">Latitude</label>
                            <input type="text" id="latitude" name="latitude" class="form-control @error('latitude') is-invalid @enderror" value="{{ old('latitude', $defaultLatitude) }}" required>
                            @error('latitude')
                                <div class="invalid-feedback">{{ $message }}</div>
                            @enderror
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="form-group">
                            <label for="longitude">Longitude</label>
                            <input type="text" id="longitude" name="longitude" class="form-control @error('longitude') is-invalid @enderror" value="{{ old('longitude', $defaultLongitude) }}" required>
                            @error('longitude')
                                <div class="invalid-feedback">{{ $message }}</div>
                            @enderror
                        </div>
                    </div>
                </div>

                <div id="map" class="mt-3" style="height: 300px; width: 100%;"></div>
                <small class="text-muted">Klik pada peta atau geser marker untuk menentukan lokasi</small>
            </div>
        </div>

        <div class="card mb-4">
            <div class="card-header bg-primary text-white">
                <h5 class="mb-0">Detail Properti</h5>
            </div>
            <div class="card-body">
                <div class="row">
                    <div class="col-md-4">
                        <div class="form-group">
                            <label for="price">Harga per Bulan (Rp)</label>
                            <div class="input-group">
                                <div class="input-group-prepend">
                                    <span class="input-group-text">Rp</span>
                                </div>
                                <input type="number" id="price" name="price" class="form-control @error('price') is-invalid @enderror" value="{{ old('price') }}" min="1" required>
                            </div>
                            @error('price')
                                <div class="invalid-feedback">{{ $message }}</div>
                            @enderror
                        </div>
                    </div>

                    <div class="col-md-4">
                        <div class="form-group">
                            <label for="capacity">Kapasitas Kamar</label>
                            <input type="number" id="capacity" name="capacity" class="form-control @error('capacity') is-invalid @enderror" value="{{ old('capacity') }}" min="1" required>
                            @error('capacity')
                                <div class="invalid-feedback">{{ $message }}</div>
                            @enderror
                        </div>
                    </div>

                    <div class="col-md-4">
                        <div class="form-group">
                            <label for="available_rooms">Kamar Tersedia</label>
                            <input type="number" id="available_rooms" name="available_rooms" class="form-control @error('available_rooms') is-invalid @enderror" value="{{ old('available_rooms') }}" min="0" required>
                            @error('available_rooms')
                                <div class="invalid-feedback">{{ $message }}</div>
                            @enderror
                        </div>
                    </div>
                </div>

                <div class="form-group mt-3">
                    <label for="rules">Aturan Properti (Opsional)</label>
                    <textarea id="rules" name="rules" class="form-control @error('rules') is-invalid @enderror" rows="3">{{ old('rules') }}</textarea>
                    @error('rules')
                        <div class="invalid-feedback">{{ $message }}</div>
                    @enderror
                </div>
            </div>
        </div>

        <div class="card mb-4">
            <div class="card-header bg-primary text-white">
                <h5 class="mb-0">Fasilitas</h5>
            </div>
            <div class="card-body">
                <div class="row">
                    @foreach(['Kamar Mandi Dalam', 'AC', 'WiFi', 'Dapur', 'Laundry', 'Parkir', 'TV', 'Kipas Angin', 'Lemari', 'Meja Belajar'] as $facility)
                        <div class="col-md-3 mb-2">
                            <div class="custom-control custom-checkbox">
                                <input type="checkbox" class="custom-control-input" name="facilities[]" value="{{ $facility }}" id="facility_{{ $loop->index }}" {{ is_array(old('facilities')) && in_array($facility, old('facilities')) ? 'checked' : '' }}>
                                <label class="custom-control-label" for="facility_{{ $loop->index }}">{{ $facility }}</label>
                            </div>
                        </div>
                    @endforeach
                </div>
                @error('facilities')
                    <div class="text-danger small">{{ $message }}</div>
                @enderror
            </div>
        </div>

        <div class="card mb-4">
            <div class="card-header bg-primary text-white">
                <h5 class="mb-0">Gambar Tambahan</h5>
            </div>
            <div class="card-body">
                <div class="form-group">
                    <label>Upload Gambar (Maksimal 5 gambar)</label>
                    <div class="custom-file">
                        <input type="file" id="images" name="images[]" class="custom-file-input @error('images') is-invalid @enderror" multiple onchange="previewAdditionalImages(this)">
                        <label class="custom-file-label" for="images">Pilih gambar...</label>
                    </div>
                    @error('images')
                        <div class="invalid-feedback d-block">{{ $message }}</div>
                    @enderror
                    <small class="text-muted">Format: JPEG, PNG, JPG, GIF (Max 2MB per gambar)</small>
                </div>

                <div class="row mt-3" id="additional-images-preview">
                    <div class="col-12">
                        <p class="text-muted">Preview gambar akan muncul di sini</p>
                    </div>
                </div>
            </div>
        </div>

        <div class="form-group text-center">
            <button type="submit" class="btn btn-primary btn-lg mr-2">
                <i class="fas fa-save"></i> Simpan Properti
            </button>
            <a href="{{ route('owner.property') }}" class="btn btn-secondary btn-lg">
                <i class="fas fa-arrow-left"></i> Kembali
            </a>
        </div>
    </form>
</div>

<script>
    function initMap() {
        const defaultLat = parseFloat(document.getElementById('latitude').value) || {{ $defaultLatitude }};
        const defaultLng = parseFloat(document.getElementById('longitude').value) || {{ $defaultLongitude }};

        const map = new google.maps.Map(document.getElementById('map'), {
            center: { lat: defaultLat, lng: defaultLng },
            zoom: 15,
            streetViewControl: false,
            mapTypeControl: false
        });

        const marker = new google.maps.Marker({
            position: { lat: defaultLat, lng: defaultLng },
            map: map,
            draggable: true,
            title: "Lokasi Properti"
        });

        google.maps.event.addListener(marker, 'dragend', function() {
            document.getElementById('latitude').value = marker.getPosition().lat();
            document.getElementById('longitude').value = marker.getPosition().lng();
        });

        map.addListener('click', function(e) {
            marker.setPosition(e.latLng);
            document.getElementById('latitude').value = e.latLng.lat();
            document.getElementById('longitude').value = e.latLng.lng();
        });
    }

    function previewFeaturedImage(input) {
        const preview = document.getElementById('featured-image-preview');
        if (input.files && input.files[0]) {
            const reader = new FileReader();
            reader.onload = function(e) {
                preview.src = e.target.result;
                preview.classList.remove('d-none');
            }
            reader.readAsDataURL(input.files[0]);
        }
    }

    function previewAdditionalImages(input) {
        const previewContainer = document.getElementById('additional-images-preview');
        previewContainer.innerHTML = '';

        if (input.files && input.files.length > 0) {
            const label = input.nextElementSibling;
            label.textContent = input.files.length + ' gambar dipilih';

            const files = Array.from(input.files).slice(0, 5);

            files.forEach((file, index) => {
                const reader = new FileReader();
                reader.onload = function(e) {
                    const col = document.createElement('div');
                    col.className = 'col-md-3 mb-3';

                    const card = document.createElement('div');
                    card.className = 'card';

                    const img = document.createElement('img');
                    img.src = e.target.result;
                    img.className = 'card-img-top';
                    img.style.height = '120px';
                    img.style.objectFit = 'cover';

                    card.appendChild(img);
                    col.appendChild(card);
                    previewContainer.appendChild(col);
                }
                reader.readAsDataURL(file);
            });
        } else {
            const label = input.nextElementSibling;
            label.textContent = 'Pilih gambar...';

            const message = document.createElement('div');
            message.className = 'col-12';
            message.innerHTML = '<p class="text-muted">Preview gambar akan muncul di sini</p>';
            previewContainer.appendChild(message);
        }
    }

    document.getElementById('province_id').addEventListener('change', function() {
        const provinceId = this.value;
        const citySelect = document.getElementById('city_id');
        const districtSelect = document.getElementById('district_id');
        const subdistrictSelect = document.getElementById('subdistrict_id');

        citySelect.innerHTML = '<option value="">Memuat...</option>';
        citySelect.disabled = true;
        districtSelect.innerHTML = '<option value="">Pilih Kecamatan</option>';
        subdistrictSelect.innerHTML = '<option value="">Pilih Kelurahan</option>';

        if (provinceId) {
            fetch(`/owner/get-cities/${provinceId}`)
                .then(response => response.json())
                .then(data => {
                    citySelect.innerHTML = '<option value="">Pilih Kabupaten/Kota</option>';
                    data.forEach(city => {
                        citySelect.innerHTML += `<option value="${city.id}">${city.name}</option>`;
                    });
                    citySelect.disabled = false;
                })
                .catch(error => {
                    console.error('Error:', error);
                    citySelect.innerHTML = '<option value="">Gagal memuat data</option>';
                    citySelect.disabled = false;
                });
        } else {
            citySelect.innerHTML = '<option value="">Pilih Kabupaten/Kota</option>';
            citySelect.disabled = false;
        }
    });

    document.getElementById('city_id').addEventListener('change', function() {
        const cityId = this.value;
        const districtSelect = document.getElementById('district_id');
        const subdistrictSelect = document.getElementById('subdistrict_id');

        districtSelect.innerHTML = '<option value="">Memuat...</option>';
        districtSelect.disabled = true;
        subdistrictSelect.innerHTML = '<option value="">Pilih Kelurahan</option>';

        if (cityId) {
            fetch(`/owner/get-districts/${cityId}`)
                .then(response => response.json())
                .then(data => {
                    districtSelect.innerHTML = '<option value="">Pilih Kecamatan</option>';
                    data.forEach(district => {
                        districtSelect.innerHTML += `<option value="${district.id}">${district.name}</option>`;
                    });
                    districtSelect.disabled = false;
                })
                .catch(error => {
                    console.error('Error:', error);
                    districtSelect.innerHTML = '<option value="">Gagal memuat data</option>';
                    districtSelect.disabled = false;
                });
        } else {
            districtSelect.innerHTML = '<option value="">Pilih Kecamatan</option>';
            districtSelect.disabled = false;
        }
    });

    document.getElementById('district_id').addEventListener('change', function() {
        const districtId = this.value;
        const subdistrictSelect = document.getElementById('subdistrict_id');

        subdistrictSelect.innerHTML = '<option value="">Memuat...</option>';
        subdistrictSelect.disabled = true;

        if (districtId) {
            fetch(`/owner/get-subdistricts/${districtId}`)
                .then(response => response.json())
                .then(data => {
                    subdistrictSelect.innerHTML = '<option value="">Pilih Kelurahan</option>';
                    data.forEach(subdistrict => {
                        subdistrictSelect.innerHTML += `<option value="${subdistrict.id}">${subdistrict.name}</option>`;
                    });
                    subdistrictSelect.disabled = false;
                })
                .catch(error => {
                    console.error('Error:', error);
                    subdistrictSelect.innerHTML = '<option value="">Gagal memuat data</option>';
                    subdistrictSelect.disabled = false;
                });
        } else {
            subdistrictSelect.innerHTML = '<option value="">Pilih Kelurahan</option>';
            subdistrictSelect.disabled = false;
        }
    });

    document.addEventListener('DOMContentLoaded', function() {
        const oldProvinceId = "{{ old('province_id') }}";
        const oldCityId = "{{ old('city_id') }}";
        const oldDistrictId = "{{ old('district_id') }}";
        const oldSubdistrictId = "{{ old('subdistrict_id') }}";

        if (oldProvinceId) {
            const provinceSelect = document.getElementById('province_id');
            provinceSelect.value = oldProvinceId;

            const event = new Event('change');
            provinceSelect.dispatchEvent(event);
            setTimeout(() => {
                if (oldCityId) {
                    const citySelect = document.getElementById('city_id');
                    citySelect.value = oldCityId;

                    citySelect.dispatchEvent(new Event('change'));

                    setTimeout(() => {
                        if (oldDistrictId) {
                            const districtSelect = document.getElementById('district_id');
                            districtSelect.value = oldDistrictId;

                            districtSelect.dispatchEvent(new Event('change'));

                            setTimeout(() => {
                                if (oldSubdistrictId) {
                                    document.getElementById('subdistrict_id').value = oldSubdistrictId;
                                }
                            }, 300);
                        }
                    }, 300);
                }
            }, 300);
        }
    });
</script>
<script src="https://maps.googleapis.com/maps/api/js?key={{ config('services.google_maps.key') }}&callback=initMap" async defer></script>
@endsection
