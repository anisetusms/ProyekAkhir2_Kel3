@extends('layouts.admin')

@section('title', 'Detail Properti')

@section('content')
<div class="container-fluid">
    <div class="d-sm-flex align-items-center justify-content-between mb-4">
        <h1 class="h3 mb-0 text-gray-800">Detail Properti</h1>
        <div>
            <a href="{{ route('admin.properties.index') }}" class="btn btn-secondary">
                <i class="fas fa-arrow-left"></i> Kembali
            </a>
            <a href="{{ route('admin.properties.edit', $property->id) }}" class="btn btn-warning">
                <i class="fas fa-edit"></i> Edit
            </a>
            <a href="{{ route('admin.properties.rooms.index', $property->id) }}" class="btn btn-primary">
                <i class="fas fa-door-open"></i> Kelola Kamar
            </a>
        </div>
    </div>

    <div class="card shadow mb-4">
        <div class="card-header py-3">
            <h6 class="m-0 font-weight-bold text-primary">Informasi Properti</h6>
        </div>
        <div class="card-body">
            <div class="row">
                <div class="col-md-8">
                    <div class="row">
                        <div class="col-md-6">
                            <table class="table table-bordered">
                                <tr>
                                    <th width="40%">Nama Properti</th>
                                    <td>{{ $property->name }}</td>
                                </tr>
                                <tr>
                                    <th>Tipe Properti</th>
                                    <td>
                                        <span class="badge badge-{{ $property->property_type === 'kost' ? 'info' : 'success' }}">
                                            {{ ucfirst($property->property_type) }}
                                        </span>
                                        @if($property->property_type === 'kost')
                                        <span class="badge badge-secondary mt-1">
                                            {{ $property->detail->kost_type_name }}
                                        </span>
                                        @endif
                                    </td>
                                </tr>
                                <tr>
                                    <th>Harga</th>
                                    <td>Rp {{ number_format($property->price, 0, ',', '.') }}</td>
                                </tr>
                                <tr>
                                    <th>Status</th>
                                    <td>
                                        <span class="badge badge-{{ $property->isDeleted ? 'danger' : 'success' }}">
                                            {{ $property->isDeleted ? 'Nonaktif' : 'Aktif' }}
                                        </span>
                                    </td>
                                </tr>
                            </table>
                        </div>
                        <div class="col-md-6">
                            <table class="table table-bordered">
                                <tr>
                                    <th width="40%">Provinsi</th>
                                    <td>{{ $property->province->name }}</td>
                                </tr>
                                <tr>
                                    <th>Kota/Kabupaten</th>
                                    <td>{{ $property->city->name }}</td>
                                </tr>
                                <tr>
                                    <th>Kecamatan</th>
                                    <td>{{ $property->district->name }}</td>
                                </tr>
                                <tr>
                                    <th>Kelurahan</th>
                                    <td>{{ $property->subdistrict->name }}</td>
                                </tr>
                            </table>
                        </div>
                    </div>

                    <div class="row mt-3">
                        <div class="col-12">
                            <h5>Alamat Lengkap</h5>
                            <p>{{ $property->address }}</p>
                            @if($property->latitude && $property->longitude)
                            <div class="embed-responsive embed-responsive-16by9">
                                <iframe 
                                    class="embed-responsive-item" 
                                    src="https://maps.google.com/maps?q={{ $property->latitude }},{{ $property->longitude }}&hl=es;z=14&output=embed"
                                    allowfullscreen>
                                </iframe>
                            </div>
                            @endif
                        </div>
                    </div>

                    <div class="row mt-3">
                        <div class="col-12">
                            <h5>Deskripsi</h5>
                            <p>{{ $property->description }}</p>
                        </div>
                    </div>
                </div>

                <div class="col-md-4">
                    <div class="text-center">
                        <img src="{{ $property->image_url }}" alt="Gambar Properti" class="img-fluid rounded mb-3" style="max-height: 300px;">
                    </div>

                    <div class="card mt-3">
                        <div class="card-header">
                            <h6 class="m-0 font-weight-bold text-primary">
                                Detail {{ ucfirst($property->property_type) }}
                            </h6>
                        </div>
                        <div class="card-body">
                            @if($property->property_type === 'kost')
                                @include('admin.properties.partials.show-kost-details')
                            @else
                                @include('admin.properties.partials.show-homestay-details')
                            @endif
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="card shadow mb-4">
        <div class="card-header py-3 d-flex justify-content-between align-items-center">
            <h6 class="m-0 font-weight-bold text-primary">Statistik Kamar</h6>
            <a href="{{ route('admin.properties.rooms.create', $property->id) }}" class="btn btn-sm btn-primary">
                <i class="fas fa-plus"></i> Tambah Kamar
            </a>
        </div>
        <div class="card-body">
            <div class="row">
                <div class="col-md-6">
                    <h5>Ketersediaan Kamar</h5>
                    <div class="progress mb-3">
                        <div class="progress-bar bg-success" style="width: {{ $availablePercentage }}%">
                            {{ $property->rooms->where('is_available', true)->count() }} Tersedia
                        </div>
                        <div class="progress-bar bg-warning" style="width: {{ 100 - $availablePercentage }}%">
                            {{ $property->rooms->where('is_available', false)->count() }} Terisi
                        </div>
                    </div>
                </div>
                <div class="col-md-6">
                    <h5>Distribusi Tipe Kamar</h5>
                    <div class="table-responsive">
                        <table class="table table-bordered">
                            <thead>
                                <tr>
                                    <th>Tipe Kamar</th>
                                    <th>Jumlah</th>
                                    <th>Persentase</th>
                                </tr>
                            </thead>
                            <tbody>
                                @foreach($roomTypes as $type => $count)
                                <tr>
                                    <td>{{ $type }}</td>
                                    <td>{{ $count }}</td>
                                    <td>{{ round(($count / $property->rooms->count()) * 100, 2) }}%</td>
                                </tr>
                                @endforeach
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
@endsection