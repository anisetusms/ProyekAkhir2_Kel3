@extends('layouts.index-superadmin')

@section('title', 'Detail Owner')

@section('content')
<div class="container-fluid py-4">
    <div class="row">
        <div class="col-12">
            <div class="card shadow-lg mb-4">
                <div class="card-header bg-gradient-primary text-white">
                    <div class="d-flex justify-content-between align-items-center">
                        <h3 class="mb-0"><i class="fas fa-user-tie me-2"></i>Detail Owner</h3>
                        <a href="{{ route('super_admin.entrepreneurs.approved') }}" class="btn btn-light btn-sm">
                            <i class="fas fa-arrow-left me-1"></i> Kembali
                        </a>
                    </div>
                </div>
                
                <div class="card-body">
                    <div class="row">
                        <div class="col-md-8">
                            <div class="d-flex align-items-center mb-4">
                                <div class="avatar avatar-xl bg-gradient-dark rounded-circle me-4">
                                    <span class="text-white fs-4">{{ substr($owner->name, 0, 1) }}</span>
                                </div>
                                <div>
                                    <h2 class="mb-1">{{ $owner->name }}</h2>
                                    <span class="badge bg-success rounded-pill">
                                        <i class="fas fa-check-circle me-1"></i> Disetujui
                                    </span>
                                </div>
                            </div>

                            <div class="row">
                                <div class="col-md-6">
                                    <div class="info-item mb-3">
                                        <h6 class="text-muted mb-1">Email</h6>
                                        <p class="mb-0">
                                            <a href="mailto:{{ $owner->email }}" class="text-primary">
                                                <i class="fas fa-envelope me-2"></i>{{ $owner->email }}
                                            </a>
                                        </p>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="info-item mb-3">
                                        <h6 class="text-muted mb-1">Username</h6>
                                        <p class="mb-0">
                                            <i class="fas fa-user me-2"></i>{{ $owner->username }}
                                        </p>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="info-item mb-3">
                                        <h6 class="text-muted mb-1">Telepon</h6>
                                        <p class="mb-0">
                                            <i class="fas fa-phone me-2"></i>{{ $owner->phone ?? '-' }}
                                        </p>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="info-item mb-3">
                                        <h6 class="text-muted mb-1">Total Properti</h6>
                                        <p class="mb-0">
                                            <i class="fas fa-building me-2"></i>{{ $totalProperties }}
                                        </p>
                                    </div>
                                </div>
                            </div>

                            <div class="info-item">
                                <h6 class="text-muted mb-1">Alamat</h6>
                                <p class="mb-0">
                                    <i class="fas fa-map-marker-alt me-2"></i>{{ $owner->address ?? '-' }}
                                </p>
                            </div>
                        </div>
                        
                        <div class="col-md-4">
                            <div class="card bg-light border-0 h-100">
                                <div class="card-body">
                                    <h5 class="card-title text-center mb-4">Statistik Properti</h5>
                                    <div class="text-center">
                                        <div class="chart-container" style="position: relative; height:200px; width:100%">
                                            <!-- Placeholder for chart - you can add actual chart here -->
                                            <div class="d-flex justify-content-center align-items-center h-100">
                                                <div class="text-center">
                                                    <h1 class="text-primary">{{ $totalProperties }}</h1>
                                                    <p class="text-muted">Total Properti</p>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="mt-4">
                                        <div class="d-flex justify-content-between mb-2">
                                            <span class="text-muted">Kost</span>
                                            <span class="fw-bold">{{ $properties->where('property_type_id', 1)->count() }}</span>
                                        </div>
                                        <div class="d-flex justify-content-between mb-2">
                                            <span class="text-muted">Homestay</span>
                                            <span class="fw-bold">{{ $properties->where('property_type_id', 2)->count() }}</span>
                                        </div>
                                        <div class="d-flex justify-content-between">
                                            <span class="text-muted">Aktif</span>
                                            <span class="fw-bold">{{ $properties->where('isDeleted', 0)->count() }}</span>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="row">
        <div class="col-12">
            <div class="card shadow-lg">
                <div class="card-header bg-gradient-primary text-white">
                    <h3 class="mb-0"><i class="fas fa-building me-2"></i>Daftar Properti</h3>
                </div>
                <div class="card-body">
                    <div class="table-responsive">
                        <table class="table table-hover align-middle">
                            <thead class="table-light">
                                <tr>
                                    <th class="ps-4">Nama Properti</th>
                                    <th>Jenis</th>
                                    <th>Alamat</th>
                                    <th>Status</th>
                                    <th class="text-end pe-4">Aksi</th>
                                </tr>
                            </thead>
                            <tbody>
                                @foreach($properties as $property)
                                    <tr>
                                        <td class="ps-4">
                                            <div class="d-flex align-items-center">
                                                <div class="icon-shape icon-sm me-3 bg-gradient-info rounded-circle text-center">
                                                    <i class="fas fa-home text-white"></i>
                                                </div>
                                                <div>
                                                    <h6 class="mb-0">{{ $property->name }}</h6>
                                                    <small class="text-muted">ID: {{ $property->id }}</small>
                                                </div>
                                            </div>
                                        </td>
                                        <td>
                                            @if($property->property_type_id == 1)
                                                <span class="badge bg-primary rounded-pill">Kost</span>
                                            @elseif($property->property_type_id == 2)
                                                <span class="badge bg-warning rounded-pill text-dark">Homestay</span>
                                            @else
                                                <span class="badge bg-secondary rounded-pill">Tidak Dikenal</span>
                                            @endif
                                        </td>
                                        <td>{{ Str::limit($property->address, 30) }}</td>
                                        <td>
                                            @if($property->isDeleted)
                                                <span class="badge bg-danger rounded-pill">
                                                    <i class="fas fa-times-circle me-1"></i> Nonaktif
                                                </span>
                                            @else
                                                <span class="badge bg-success rounded-pill">
                                                    <i class="fas fa-check-circle me-1"></i> Aktif
                                                </span>
                                            @endif
                                        </td>
                                        <td class="text-end pe-4">
                                            <a href="#" class="btn btn-sm btn-outline-info" data-bs-toggle="tooltip" title="Detail">
                                                <i class="fas fa-eye"></i>
                                            </a>
                                        </td>
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

@section('styles')
<style>
    .avatar {
        width: 60px;
        height: 60px;
        display: flex;
        align-items: center;
        justify-content: center;
        font-weight: 600;
    }
    .icon-shape {
        width: 36px;
        height: 36px;
        display: flex;
        align-items: center;
        justify-content: center;
    }
    .card {
        border-radius: 12px;
        overflow: hidden;
        border: none;
        box-shadow: 0 4px 20px rgba(0,0,0,0.08);
    }
    .card-header {
        border-radius: 0 !important;
    }
    .info-item {
        padding: 12px;
        border-radius: 8px;
        background-color: rgba(0,0,0,0.02);
        margin-bottom: 12px;
    }
    .badge {
        padding: 6px 10px;
        font-weight: 500;
    }
    .table th {
        border-top: none;
        font-weight: 600;
        text-transform: uppercase;
        font-size: 0.75rem;
        letter-spacing: 0.5px;
    }
    .table td {
        vertical-align: middle;
    }
</style>
@endsection

@section('scripts')
<script>
    $(document).ready(function() {
        // Initialize tooltips
        $('[data-bs-toggle="tooltip"]').tooltip();
    });
</script>
@endsection