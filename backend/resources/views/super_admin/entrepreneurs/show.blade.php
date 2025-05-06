@extends('layouts.index-superadmin')

@section('title', 'Detail Owner')

@section('content')
<div class="container-fluid py-4">
    <div class="row">
        <div class="col-12">
            <div class="card shadow-lg">
                <div class="card-header bg-gradient-primary text-white py-3">
                    <div class="d-flex justify-content-between align-items-center">
                        <h6 class="m-0 font-weight-bold"><i class="fas fa-user-tie me-2"></i>Detail Owner</h6>
                        <a href="{{ route('super_admin.entrepreneurs.approved') }}" class="btn btn-sm btn-light shadow-sm">
                            <i class="fas fa-arrow-left fa-sm text-gray-700 me-1"></i> Kembali
                        </a>
                    </div>
                </div>
                <div class="card-body">
                    <div class="row">
                        <div class="col-md-8">
                            <div class="d-flex align-items-center mb-4">
                                <div class="avatar-custom-xl me-4">
                                    {{ strtoupper(substr($owner->name, 0, 1)) }}
                                </div>
                                <div>
                                    <h5 class="font-weight-bold text-primary mb-0">{{ $owner->name }}</h5>
                                    <small class="text-muted">ID: {{ $owner->id }}</small>
                                    <div class="mt-1">
                                        <span class="badge badge-pill badge-success"><i class="fas fa-check-circle fa-sm me-1"></i>Disetujui</span>
                                    </div>
                                </div>
                            </div>

                            <div class="mb-3">
                                <h6 class="font-weight-bold text-secondary mb-2"><i class="fas fa-info-circle me-1"></i>Informasi Kontak</h6>
                                <div class="list-group">
                                    <li class="list-group-item d-flex align-items-center">
                                        <i class="fas fa-envelope fa-fw me-3 text-primary"></i>
                                        <a href="mailto:{{ $owner->email }}" class="text-decoration-none text-primary">{{ $owner->email }}</a>
                                    </li>
                                    <li class="list-group-item d-flex align-items-center">
                                        <i class="fas fa-user fa-fw me-3 text-info"></i>
                                        <span>{{ $owner->username }}</span>
                                    </li>
                                    <li class="list-group-item d-flex align-items-center">
                                        <i class="fas fa-phone fa-fw me-3 text-success"></i>
                                        <span>{{ $owner->phone ?? '-' }}</span>
                                    </li>
                                    <li class="list-group-item d-flex align-items-center">
                                        <i class="fas fa-map-marker-alt fa-fw me-3 text-warning"></i>
                                        <span>{{ $owner->address ?? '-' }}</span>
                                    </li>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="card bg-light shadow-sm border-0 h-100">
                                <div class="card-body d-flex flex-column justify-content-center align-items-center">
                                    <h6 class="font-weight-bold text-secondary mb-3"><i class="fas fa-chart-pie me-1"></i>Statistik Properti</h6>
                                    <div class="circle-progress position-relative d-inline-flex justify-content-center align-items-center mb-3" data-value="{{ $totalProperties > 0 ? ($properties->where('isDeleted', 0)->count() / $totalProperties) * 100 : 0 }}" data-size="120" data-thickness="10" data-color="#1cc88a">
                                        <div class="font-weight-bold text-gray-800">{{ $properties->where('isDeleted', 0)->count() }}</div>
                                    </div>
                                    <div class="text-center small">
                                        <span class="mr-2">
                                            <i class="fas fa-circle text-success"></i> Aktif
                                        </span>
                                        <span class="mr-2">
                                            <i class="fas fa-circle text-danger"></i> Nonaktif ({{ $properties->where('isDeleted', 1)->count() }})
                                        </span>
                                    </div>
                                    <hr class="my-3">
                                    <h6 class="font-weight-bold text-info mb-2">Berdasarkan Jenis</h6>
                                    <div class="d-flex justify-content-around">
                                        <div class="text-center">
                                            <span class="badge badge-pill badge-primary">{{ $properties->where('property_type_id', 1)->count() }} Kost</span>
                                        </div>
                                        <div class="text-center">
                                            <span class="badge badge-pill badge-warning text-dark">{{ $properties->where('property_type_id', 2)->count() }} Homestay</span>
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

    <div class="row mt-4">
        <div class="col-12">
            <div class="card shadow-lg">
                <div class="card-header bg-gradient-info text-white py-3">
                    <h6 class="m-0 font-weight-bold"><i class="fas fa-building me-2"></i>Daftar Properti</h6>
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
                                                <div class="icon-shape icon-sm bg-gradient-primary text-white rounded-circle me-3">
                                                    <i class="fas fa-home"></i>
                                                </div>
                                                <div>
                                                    <h6 class="mb-0">{{ $property->name }}</h6>
                                                    <small class="text-muted">ID: {{ $property->id }}</small>
                                                </div>
                                            </div>
                                        </td>
                                        <td>
                                            @if($property->property_type_id == 1)
                                                <span class="badge badge-pill badge-primary">Kost</span>
                                            @elseif($property->property_type_id == 2)
                                                <span class="badge badge-pill badge-warning text-dark">Homestay</span>
                                            @else
                                                <span class="badge badge-pill badge-secondary">Lainnya</span>
                                            @endif
                                        </td>
                                        <td>{{ Str::limit($property->address, 30) }}</td>
                                        <td>
                                            @if($property->isDeleted)
                                                <span class="badge badge-pill badge-danger"><i class="fas fa-times-circle fa-sm me-1"></i>Nonaktif</span>
                                            @else
                                                <span class="badge badge-pill badge-success"><i class="fas fa-check-circle fa-sm me-1"></i>Aktif</span>
                                            @endif
                                        </td>
                                        <td class="text-end pe-4">
                                            <a href="#" class="btn btn-sm btn-outline-info shadow-sm" data-bs-toggle="tooltip" title="Detail Properti">
                                                <i class="fas fa-eye fa-sm"></i>
                                            </a>
                                            <a href="#" class="btn btn-sm btn-outline-warning shadow-sm ms-2" data-bs-toggle="tooltip" title="Edit Properti">
                                                <i class="fas fa-edit fa-sm"></i>
                                            </a>
                                            <button class="btn btn-sm btn-outline-danger shadow-sm ms-2" data-bs-toggle="tooltip" title="Hapus Properti">
                                                <i class="fas fa-trash-alt fa-sm"></i>
                                            </button>
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
    .avatar-custom-xl {
        width: 80px;
        height: 80px;
        border-radius: 50%;
        background: linear-gradient(135deg, #4facfe, #00f2fe);
        color: white;
        font-weight: 700;
        font-size: 2rem;
        display: flex;
        align-items: center;
        justify-content: center;
        text-transform: uppercase;
        flex-shrink: 0;
        box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
    }
    .card {
        border-radius: 10px;
        border: none;
        box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
    }
    .card-header {
        border-radius: 10px 10px 0 0 !important;
        padding: 1rem 1.5rem;
    }
    .list-group-item {
        border: none;
        padding: 0.75rem 0;
    }
    .list-group-item:first-child {
        padding-top: 0;
    }
    .list-group-item:last-child {
        padding-bottom: 0;
    }
    .badge {
        border-radius: 0.5rem;
        font-weight: 500;
    }
    .table th {
        font-size: 0.8rem;
        font-weight: 600;
        text-transform: uppercase;
        letter-spacing: 0.05em;
        color: #8898aa;
        border-bottom: 1px solid #e9ecef;
    }
    .table td {
        font-size: 0.9rem;
        vertical-align: middle;
    }
    .icon-shape {
        width: 30px;
        height: 30px;
        border-radius: 50%;
        display: flex;
        align-items: center;
        justify-content: center;
        color: white;
    }
    .circle-progress {
        width: 120px;
        height: 120px;
        border-radius: 50%;
        background: #e9ecef;
        display: flex;
        justify-content: center;
        align-items: center;
    }
    .circle-progress svg {
        position: absolute;
        top: 0;
        left: 0;
    }
    .circle-progress div {
        font-size: 1.5rem;
        font-weight: bold;
    }
</style>
@endsection

@section('scripts')
<script>
    $(document).ready(function() {
        $('[data-bs-toggle="tooltip"]').tooltip();

        // Simple circle progress indicator (requires a library or custom JS)
        $('.circle-progress').each(function() {
            var value = $(this).attr('data-value');
            var size = $(this).attr('data-size');
            var thickness = $(this).attr('data-thickness');
            var color = $(this).attr('data-color');
            var emptyColor = "#e9ecef"; // Light gray

            var canvas = document.createElement('canvas');
            var span = $(this).find('div')[0];
            canvas.width = canvas.height = size;
            $(this).prepend(canvas);

            var ctx = canvas.getContext('2d');
            var radius = (size / 2) - (thickness / 2);

            function drawCircle(color, lineWidth, percent) {
                ctx.beginPath();
                ctx.arc(size / 2, size / 2, radius, 0, 2 * Math.PI * percent, false);
                ctx.strokeStyle = color;
                ctx.lineWidth = lineWidth;
                ctx.lineCap = 'round';
                ctx.stroke();
            }

            drawCircle(emptyColor, thickness, 1);
            drawCircle(color, thickness, value / 100);
        });
    });
</script>
@endsection