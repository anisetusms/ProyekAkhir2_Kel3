@extends('layouts.admin')

@section('content')
<div class="container-fluid px-4">
    <!-- Header Dashboard -->
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h1 class="mt-4">Dashboard Owner</h1>
        <div class="dashboard-date">
            <span class="text-muted">{{ now()->translatedFormat('l, j F Y') }}</span>
        </div>
    </div>

    <!-- Kartu Statistik -->
    <div class="row">
        <!-- Total Properti -->
        <div class="col-xl-3 col-md-6">
            <div class="card bg-primary bg-gradient text-white mb-4">
                <div class="card-body d-flex justify-content-between align-items-center">
                    <div>
                        <h5 class="card-title">Total Properti</h5>
                        <h2 class="mb-0">{{ $totalProperties }}</h2>
                    </div>
                    <div class="icon-circle">
                        <i class="fas fa-building fa-2x"></i>
                    </div>
                </div>
                <div class="card-footer d-flex align-items-center justify-content-between">
                    <a class="small text-white stretched-link" href="#">Lihat Detail</a>
                    <div class="small text-white"><i class="fas fa-angle-right"></i></div>
                </div>
            </div>
        </div>

        <!-- Properti Aktif -->
        <div class="col-xl-3 col-md-6">
            <div class="card bg-success bg-gradient text-white mb-4">
                <div class="card-body d-flex justify-content-between align-items-center">
                    <div>
                        <h5 class="card-title">Properti Aktif</h5>
                        <h2 class="mb-0">{{ $activeProperties }}</h2>
                    </div>
                    <div class="icon-circle">
                        <i class="fas fa-check-circle fa-2x"></i>
                    </div>
                </div>
                <div class="card-footer d-flex align-items-center justify-content-between">
                    <a class="small text-white stretched-link" href="#">Lihat Detail</a>
                    <div class="small text-white"><i class="fas fa-angle-right"></i></div>
                </div>
            </div>
        </div>

        <!-- Properti Menunggu -->
        <div class="col-xl-3 col-md-6">
            <div class="card bg-warning bg-gradient text-white mb-4">
                <div class="card-body d-flex justify-content-between align-items-center">
                    <div>
                        <h5 class="card-title">Menunggu Persetujuan</h5>
                        <h2 class="mb-0">{{ $pendingProperties }}</h2>
                    </div>
                    <div class="icon-circle">
                        <i class="fas fa-clock fa-2x"></i>
                    </div>
                </div>
                <div class="card-footer d-flex align-items-center justify-content-between">
                    <a class="small text-white stretched-link" href="#">Review Sekarang</a>
                    <div class="small text-white"><i class="fas fa-angle-right"></i></div>
                </div>
            </div>
        </div>

        <!-- Total Pengunjung -->
        <div class="col-xl-3 col-md-6">
            <div class="card bg-info bg-gradient text-white mb-4">
                <div class="card-body d-flex justify-content-between align-items-center">
                    <div>
                        <h5 class="card-title">Total Pengunjung</h5>
                        <h2 class="mb-0">{{ $totalViews }}</h2>
                    </div>
                    <div class="icon-circle">
                        <i class="fas fa-eye fa-2x"></i>
                    </div>
                </div>
                <div class="card-footer d-flex align-items-center justify-content-between">
                    <a class="small text-white stretched-link" href="#">Lihat Analitik</a>
                    <div class="small text-white"><i class="fas fa-angle-right"></i></div>
                </div>
            </div>
        </div>
    </div>

    <div class="row">
        <!-- Properti Terbaru -->
        <div class="col-lg-8">
            <div class="card mb-4">
                <div class="card-header bg-white d-flex justify-content-between align-items-center">
                    <h5 class="mb-0">Properti Terbaru</h5>
                    <a href="#" class="btn btn-sm btn-outline-primary">Lihat Semua</a>
                </div>
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-hover mb-0">
                            <thead class="table-light">
                                <tr>
                                    <th>Nama Properti</th>
                                    <th>Status</th>
                                    <th>Tanggal Ditambahkan</th>
                                    <th>Aksi</th>
                                </tr>
                            </thead>
                            <tbody>
                                @foreach($latestProperties as $property)
                                <tr>
                                    <td>
                                        <div class="d-flex align-items-center">
                                            <div class="avatar avatar-sm me-3">
                                                <span class="avatar-initial rounded-circle bg-light text-dark">
                                                    {{ substr($property->name, 0, 1) }}
                                                </span>
                                            </div>
                                            <div>
                                                <h6 class="mb-0">{{ $property->name }}</h6>
                                                <small class="text-muted">{{ $property->type ?? 'Residensial' }}</small>
                                            </div>
                                        </div>
                                    </td>
                                    <td>
                                        <span class="badge rounded-pill bg-{{ $property->isDeleted ? 'danger' : 'success' }}">
                                            {{ $property->isDeleted ? 'Nonaktif' : 'Aktif' }}
                                        </span>
                                    </td>
                                    <td>{{ $property->created_at->translatedFormat('d M Y') }}</td>
                                    <td class="text-nowrap">
                                        <a href="{{ route('admin.properties.rooms.index', $property->id) }}" class="btn btn-sm btn-outline-info" data-bs-toggle="tooltip" title="Kelola Kamar">
                                            <i class="fas fa-door-open"></i>
                                        </a>
                                        <a href="{{ route('admin.properties.show', $property->id) }}" class="btn btn-sm btn-outline-primary" title="Lihat">
                                            <i class="fas fa-eye"></i>
                                        </a>
                                        <a href="{{ route('admin.properties.edit', $property->id) }}" class="btn btn-sm btn-outline-warning" title="Edit">
                                            <i class="fas fa-edit"></i>
                                        </a>
                                        <form action="{{ route('admin.properties.destroy', $property->id) }}" method="POST" class="d-inline" onsubmit="return confirm('Yakin ingin menonaktifkan properti ini?')">
                                            @csrf
                                            @method('DELETE')
                                            <button type="submit" class="btn btn-sm btn-outline-danger" title="Non-aktifkan">
                                                <i class="fas fa-power-off"></i>
                                            </button>
                                        </form>
                                    </td>

                                </tr>
                                @endforeach
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>

        <!-- Statistik dan Aksi Cepat -->
        <div class="col-lg-4">
            <!-- Kartu Pesan -->
            <div class="card mb-4">
                <div class="card-header bg-white">
                    <h5 class="mb-0">Pesan Masuk</h5>
                </div>
                <div class="card-body">
                    <div class="d-flex align-items-center mb-4">
                        <div class="icon-shape icon-lg bg-light-primary text-primary rounded-3 me-3">
                            <i class="fas fa-envelope fa-lg"></i>
                        </div>
                        <div>
                            <h4 class="mb-0">{{ $totalMessages }}</h4>
                            <p class="mb-0 text-muted">Total Pesan</p>
                        </div>
                    </div>
                    <div class="progress mb-3" style="height: 8px;">
                        <div class="progress-bar bg-primary" role="progressbar" style="width: 72%;" aria-valuenow="72" aria-valuemin="0" aria-valuemax="100"></div>
                    </div>
                    <p class="small text-muted">72% pesan telah dibalas bulan ini</p>
                    <a href="#" class="btn btn-primary w-100 mt-2">Lihat Pesan</a>
                </div>
            </div>

            <!-- Aksi Cepat -->
            <div class="card">
                <div class="card-header bg-white">
                    <h5 class="mb-0">Aksi Cepat</h5>
                </div>
                <div class="card-body">
                    <div class="d-grid gap-2">
                        <button class="btn btn-outline-primary text-start">
                            <i class="fas fa-plus-circle me-2"></i> Tambah Properti Baru
                        </button>
                        <button class="btn btn-outline-success text-start">
                            <i class="fas fa-chart-line me-2"></i> Lihat Laporan
                        </button>
                        <button class="btn btn-outline-warning text-start">
                            <i class="fas fa-user-cog me-2"></i> Pengaturan Akun
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<style>
    .icon-circle {
        width: 50px;
        height: 50px;
        border-radius: 50%;
        background-color: rgba(255, 255, 255, 0.2);
        display: flex;
        align-items: center;
        justify-content: center;
    }

    .card {
        border: none;
        border-radius: 10px;
        box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05);
        transition: transform 0.3s ease, box-shadow 0.3s ease;
    }

    .card:hover {
        transform: translateY(-5px);
        box-shadow: 0 10px 15px rgba(0, 0, 0, 0.1);
    }

    .avatar-initial {
        display: flex;
        align-items: center;
        justify-content: center;
        width: 36px;
        height: 36px;
        font-weight: 600;
    }

    .icon-shape {
        display: inline-flex;
        align-items: center;
        justify-content: center;
        width: 48px;
        height: 48px;
    }
</style>

@endsection