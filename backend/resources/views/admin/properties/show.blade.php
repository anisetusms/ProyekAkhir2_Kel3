@extends('layouts.admin')

@section('content')
    <div class="container-fluid">
        <div class="row mb-4">
            <div class="col-md-12">
                <div class="d-flex justify-content-between align-items-center">
                    <h2>Detail Properti: {{ $property->name }}</h2>
                    <div>
                        <a href="{{ route('admin.properties.edit', $property->id) }}" class="btn btn-primary">
                            <i class="fas fa-edit"></i> Edit
                        </a>
                        <a href="{{ route('admin.properties.index') }}" class="btn btn-secondary">
                            <i class="fas fa-arrow-left"></i> Kembali ke Daftar
                        </a>
                    </div>
                </div>
            </div>
        </div>

        <div class="row">
            <div class="col-md-8">
                <div class="card shadow mb-4">
                    <div class="card-header py-3">
                        <h6 class="m-0 font-weight-bold text-primary">Informasi Dasar</h6>
                    </div>
                    <div class="card-body">
                        <div class="row">
                            <div class="col-md-6">
                                <h5>Harga</h5>
                                <p><strong>Harga:</strong> Rp {{ number_format($property->price, 0, ',', '.') }}</p>
                                <p><strong>Kapasitas:</strong> {{ $property->capacity }} orang</p>
                                <p><strong>Kamar Tersedia:</strong> {{ $property->available_rooms }}</p>
                            </div>
                            <div class="col-md-6">
                                <h5>Status</h5>
                                <span class="badge {{ $property->isDeleted ? 'badge-secondary' : 'badge-success' }}">
                                    {{ $property->isDeleted ? 'Tidak Aktif' : 'Aktif' }}
                                </span>
                                <h5 class="mt-3">Lokasi</h5>
                                <p>{{ $property->address }}</p>
                                <p>
                                    @if($property->subdistrict && $property->district && $property->city && $property->province)
                                        {{ $property->subdistrict->subdis_name }},
                                        {{ $property->district->dis_name }},
                                        {{ $property->city->city_name }},
                                        {{ $property->province->prov_name }}
                                    @else
                                        -
                                    @endif
                                </p>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="card shadow mb-4">
                    <div class="card-header py-3">
                        <h6 class="m-0 font-weight-bold text-primary">Informasi Lokasi</h6>
                    </div>
                    <div class="card-body">
                        <div class="row">
                            <div class="col-md-6">
                                <h5>Alamat</h5>
                                <p>{{ $property->address }}</p>
                                <p>
                                    {{ $property->subdistrict->subdis_name ?? 'N/A' }},
                                    {{ $property->district->dis_name ?? 'N/A' }}<br>
                                    {{ $property->city->city_name ?? 'N/A' }},
                                    {{ $property->province->prov_name ?? 'N/A' }}
                                </p>
                            </div>
                            <div class="col-md-6">
                                <h5>Koordinat</h5>
                                <p>
                                    <strong>Latitude:</strong> {{ $property->latitude ?? 'N/A' }}<br>
                                    <strong>Longitude:</strong> {{ $property->longitude ?? 'N/A' }}
                                </p>
                                @if($property->latitude && $property->longitude)
                                    <div id="property-map" style="height: 200px; width: 100%;"></div>
                                @endif
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="col-md-4">
                <div class="card shadow mb-4">
                    <div class="card-header py-3">
                        <h6 class="m-0 font-weight-bold text-primary">Detail Properti</h6>
                    </div>
                    <div class="card-body">
                        @if($property->propertyType->name === 'kost' && $property->kostDetail)
                            <h5>Detail Kost</h5>
                            <p><strong>Tipe:</strong> {{ ucfirst($property->kostDetail->kost_type) }}</p>
                            <p><strong>Total Kamar:</strong> {{ $property->kostDetail->total_rooms }}</p>
                            <p><strong>Kamar Tersedia:</strong> {{ $property->kostDetail->available_rooms }}</p>
                            <p><strong>Termasuk Makan:</strong> {{ $property->kostDetail->meal_included ? 'Ya' : 'Tidak' }}</p>
                            <p><strong>Termasuk Laundry:</strong> {{ $property->kostDetail->laundry_included ? 'Ya' : 'Tidak' }}</p>
                        @elseif($property->propertyType->name === 'homestay' && $property->homestayDetail)
                            <h5>Detail Homestay</h5>
                            <p><strong>Total Unit:</strong> {{ $property->homestayDetail->total_units }}</p>
                            <p><strong>Unit Tersedia:</strong> {{ $property->homestayDetail->available_units }}</p>
                            <p><strong>Minimum Menginap:</strong> {{ $property->homestayDetail->minimum_stay }} malam</p>
                            <p><strong>Maksimum Tamu:</strong> {{ $property->homestayDetail->maximum_guest }}</p>
                            <p><strong>Waktu Check-in:</strong> {{ $property->homestayDetail->checkin_time }}</p>
                            <p><strong>Waktu Check-out:</strong> {{ $property->homestayDetail->checkout_time }}</p>
                        @endif

                        @if($property->rules)
                            <h5 class="mt-4"> Peraturan</h5>
                            <p>{{ $property->rules }}</p>
                        @endif
                    </div>
                </div>

                <div class="card shadow">
                    <div class="card-header py-3">
                        <h6 class="m-0 font-weight-bold text-primary">Ketersediaan Kamar</h6>
                    </div>
                    <div class="card-body">
                        <div class="text-center mb-3">
                            <div class="progress-circle" data-percent="{{ $availablePercentage }}">
                                <svg class="progress-circle-svg" viewBox="0 0 36 36">
                                    <path class="progress-circle-bg"
                                          d="M18 2.0845
                                             a 15.9155 15.9155 0 0 1 0 31.831
                                             a 15.9155 15.9155 0 0 1 0 -31.831" />
                                    <path class="progress-circle-fill"
                                          stroke-dasharray="{{ $availablePercentage }}, 100"
                                          d="M18 2.0845
                                             a 15.9155 15.9155 0 0 1 0 31.831
                                             a 15.9155 15.9155 0 0 1 0 -31.831" />
                                    <text class="progress-circle-text" x="18" y="20.35">{{ round($availablePercentage) }}%</text>
                                </svg>
                            </div>
                            <h5 class="mt-2">Tingkat Ketersediaan</h5>
                        </div>
                        <div class="text-center">
                            <p>
                                <span class="badge badge-success">{{ $availableRooms }} Tersedia</span> /
                                <span class="badge badge-secondary">{{ $totalRooms }} Total</span>
                            </p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
@endsection

@push('styles')
    <style>
        .progress-circle {
            position: relative;
            display: inline-block;
            width: 100px;
            height: 100px;
        }

        .progress-circle-svg {
            transform: rotate(-90deg);
        }

        .progress-circle-bg {
            fill: none;
            stroke: #eee;
            stroke-width: 3;
        }

        .progress-circle-fill {
            fill: none;
            stroke: #4CAF50;
            stroke-width: 3;
            stroke-linecap: round;
            transition: stroke-dasharray 0.5s ease;
        }

        .progress-circle-text {
            font-size: 0.4em;
            text-anchor: middle;
            fill: #333;
            font-weight: bold;
        }
    </style>
@endpush

@push('scripts')
    @if($property->latitude && $property->longitude)
        <script>
            function initMap() {
                const propertyLocation = {
                    lat: {{ $property->latitude }}, // Pass directly as number
                    lng: {{ $property->longitude }}  // Pass directly as number
                };
                const map = new google.maps.Map(document.getElementById("property-map"), {
                    zoom: 15,
                    center: propertyLocation,
                });

                new google.maps.Marker({
                    position: propertyLocation,
                    map: map,
                    title: "{{ $property->name }}"
                });
            }
        </script>
        <script src="https://maps.googleapis.com/maps/api/js?key={{ config('services.google.maps_api_key') }}&callback=initMap" async defer></script>
    @endif
@endpush
