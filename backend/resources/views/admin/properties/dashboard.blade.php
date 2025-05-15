@extends('layouts.admin')

@section('title', 'Dashboard')

@section('content')
<div class="container-fluid px-4">
    <!-- Header Dashboard -->
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div class="dashboard-date">
            <span class="text-muted">{{ now()->translatedFormat('l, j F Y') }}</span>
        </div>
    </div>

    <!-- Kartu Statistik -->
    <div class="row">
        <!-- Total Properti -->
        <div class="col-xl-3 col-md-6">
            <div class="card bg-primary bg-gradient text-white mb-4 shadow-sm">
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
                    <a class="small text-white stretched-link" href="{{ route('admin.properties.index') }}">Lihat Detail</a>
                    <div class="small text-white"><i class="fas fa-angle-right"></i></div>
                </div>
            </div>
        </div>

        <!-- Properti Aktif -->
        <div class="col-xl-3 col-md-6">
            <div class="card bg-success bg-gradient text-white mb-4 shadow-sm">
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
                    <a class="small text-white stretched-link" href="{{ route('admin.properties.index') }}">Lihat Detail</a>
                    <div class="small text-white"><i class="fas fa-angle-right"></i></div>
                </div>
            </div>
        </div>

        <!-- Booking Menunggu -->
        <div class="col-xl-3 col-md-6">
            <div class="card bg-warning bg-gradient text-white mb-4 shadow-sm">
                <div class="card-body d-flex justify-content-between align-items-center">
                    <div>
                        <h5 class="card-title">Menunggu Persetujuan</h5>
                        <h2 class="mb-0">{{ $pendingBookings }}</h2>
                    </div>
                    <div class="icon-circle">
                        <i class="fas fa-clock fa-2x"></i>
                    </div>
                </div>
                <div class="card-footer d-flex align-items-center justify-content-between">
                    <a class="small text-white stretched-link" href="{{ route('admin.properties.bookings.index') }}">Review Sekarang</a>
                    <div class="small text-white"><i class="fas fa-angle-right"></i></div>
                </div>
            </div>
        </div>
        
        <!-- Total Pendapatan -->
        <div class="col-xl-3 col-md-6">
            <div class="card bg-danger bg-gradient text-white mb-4 shadow-sm">
                <div class="card-body d-flex justify-content-between align-items-center">
                    <div>
                        <h5 class="card-title">Total Pendapatan</h5>
                        <h2 class="mb-0">{{ 'Rp ' . number_format($totalRevenue, 0, ',', '.') }}</h2>
                    </div>
                    <div class="icon-circle">
                        <i class="fas fa-dollar-sign fa-2x"></i>
                    </div>
                </div>
                <div class="card-footer d-flex align-items-center justify-content-between">
                    <a class="small text-white stretched-link" href="{{ route('admin.properties.bookings.index') }}">Lihat Detail</a>
                    <div class="small text-white"><i class="fas fa-angle-right"></i></div>
                </div>
            </div>
        </div>
    </div>

    <div class="row">
        <!-- Grafik Pendapatan -->
        <div class="col-lg-8">
            <div class="card mb-4 shadow-sm">
                <div class="card-header bg-white d-flex justify-content-between align-items-center">
                    <h5 class="mb-0">Pendapatan Bulanan {{ date('Y') }}</h5>
                    <div class="dropdown">
                        <button class="btn btn-sm btn-outline-secondary dropdown-toggle" type="button" id="revenueDropdown" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                            <i class="fas fa-ellipsis-v"></i>
                        </button>
                        <div class="dropdown-menu dropdown-menu-right" aria-labelledby="revenueDropdown">
                            <a class="dropdown-item" href="#"><i class="fas fa-download mr-2"></i>Unduh Laporan</a>
                            <a class="dropdown-item" href="#"><i class="fas fa-print mr-2"></i>Cetak Grafik</a>
                            <div class="dropdown-divider"></div>
                            <a class="dropdown-item" href="#"><i class="fas fa-chart-line mr-2"></i>Lihat Detail</a>
                        </div>
                    </div>
                </div>
                <div class="card-body">
                    <canvas id="revenueChart" height="300"></canvas>
                </div>
            </div>
        </div>

        <!-- Statistik dan Aksi Cepat -->
        <div class="col-lg-4">
            <!-- Kartu Statistik Pengunjung -->
            <div class="card mb-4 shadow-sm">
                <div class="card-header bg-white">
                    <h5 class="mb-0">Statistik Pengunjung</h5>
                </div>
                <div class="card-body">
                    <div class="d-flex align-items-center mb-4">
                        <div class="icon-shape icon-lg bg-light-primary text-primary rounded-3 me-3">
                            <i class="fas fa-eye fa-lg"></i>
                        </div>
                        <div>
                            <h4 class="mb-0">{{ $totalViews }}</h4>
                            <p class="mb-0 text-muted">Total Pengunjung</p>
                        </div>
                    </div>
                    <div class="progress mb-3" style="height: 8px;">
                        <div class="progress-bar bg-primary" role="progressbar" style="width: 72%;" aria-valuenow="72" aria-valuemin="0" aria-valuemax="100"></div>
                    </div>
                    <p class="small text-muted">72% peningkatan dari bulan lalu</p>
                </div>
            </div>

            <!-- Aksi Cepat -->
            <div class="card shadow-sm">
                <div class="card-header bg-white">
                    <h5 class="mb-0">Aksi Cepat</h5>
                </div>
                <div class="card-body">
                    <div class="d-grid gap-2">
                        <a href="{{ route('admin.properties.create') }}" class="btn btn-outline-primary text-start">
                            <i class="fas fa-plus-circle me-2"></i> Tambah Properti Baru
                        </a>
                        <a href="{{ route('admin.properties.bookings.index') }}" class="btn btn-outline-success text-start">
                            <i class="fas fa-chart-line me-2"></i> Lihat Pemesanan
                        </a>
                        <a href="{{ route('admin.settings') }}" class="btn btn-outline-warning text-start">
                            <i class="fas fa-user-cog me-2"></i> Pengaturan Akun
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Pemesanan Terbaru -->
    <div class="row">
        <div class="col-12">
            <div class="card shadow-sm">
                <div class="card-header bg-white d-flex justify-content-between align-items-center">
                    <h5 class="mb-0">Pemesanan Terbaru</h5>
                    <a href="{{ route('admin.properties.bookings.index') }}" class="btn btn-sm btn-outline-primary">Lihat Semua</a>
                </div>
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-hover mb-0">
                            <thead class="table-light">
                                <tr>
                                    <th>ID</th>
                                    <th>Tamu</th>
                                    <th>Properti</th>
                                    <th>Check-in</th>
                                    <th>Check-out</th>
                                    <th>Total</th>
                                    <th>Status</th>
                                    <th>Aksi</th>
                                </tr>
                            </thead>
                            <tbody>
                                @forelse($latestBookings as $booking)
                                <tr>
                                    <td>{{ $booking->id }}</td>
                                    <td>
                                        <strong>{{ $booking->guest_name }}</strong><br>
                                        <small>{{ $booking->guest_phone }}</small>
                                    </td>
                                    <td>{{ $booking->property->name ?? 'N/A' }}</td>
                                    <td>{{ \Carbon\Carbon::parse($booking->check_in)->format('d M Y') }}</td>
                                    <td>{{ \Carbon\Carbon::parse($booking->check_out)->format('d M Y') }}</td>
                                    <td>{{ 'Rp ' . number_format($booking->total_price, 0, ',', '.') }}</td>
                                    <td>
                                        @if($booking->status == 'pending')
                                        <span class="badge badge-warning">Menunggu</span>
                                        @elseif($booking->status == 'confirmed')
                                        <span class="badge badge-success">Dikonfirmasi</span>
                                        @elseif($booking->status == 'completed')
                                        <span class="badge badge-info">Selesai</span>
                                        @elseif($booking->status == 'cancelled')
                                        <span class="badge badge-danger">Dibatalkan</span>
                                        @endif
                                    </td>
                                    <td>
                                        <a href="{{ route('admin.properties.bookings.show', $booking->id) }}" class="btn btn-info btn-sm">
                                            <i class="fas fa-eye"></i>
                                        </a>
                                    </td>
                                </tr>
                                @empty
                                <tr>
                                    <td colspan="8" class="text-center py-4">Belum ada pemesanan</td>
                                </tr>
                                @endforelse
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

@endsection

@push('styles')
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

    /* CSS tambahan untuk chart */
    #revenueChart {
        width: 100% !important;
        min-height: 300px;
    }
    
    .chart-area {
        position: relative;
        height: 300px;
    }
    
    /* CSS lainnya tetap sama */
    /* ... */
</style>
@endpush

@push('scripts')
<!-- Load Chart.js terlebih dahulu -->
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

<script>
document.addEventListener('DOMContentLoaded', function() {
    // Debug data
    console.log('Bulan:', @json($months));
    console.log('Pendapatan:', @json($revenueData));
    
    const ctx = document.getElementById('revenueChart');
    if (!ctx) {
        console.error('Canvas element not found');
        return;
    }
    
    try {
        const chart = new Chart(ctx, {
            type: 'bar',
            data: {
                labels: @json($months),
                datasets: [{
                    label: 'Pendapatan (Rp)',
                    data: @json($revenueData),
                    backgroundColor: 'rgba(78, 115, 223, 0.7)',
                    borderColor: 'rgba(78, 115, 223, 1)',
                    borderWidth: 1,
                    borderRadius: 5,
                    maxBarThickness: 40,
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                scales: {
                    y: {
                        beginAtZero: true,
                        ticks: {
                            callback: function(value) {
                                return 'Rp ' + value.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ".");
                            }
                        }
                    }
                },
                plugins: {
                    tooltip: {
                        callbacks: {
                            label: function(context) {
                                let label = context.dataset.label || '';
                                if (label) {
                                    label += ': ';
                                }
                                if (context.parsed.y !== null) {
                                    label += 'Rp ' + context.parsed.y.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ".");
                                }
                                return label;
                            }
                        }
                    },
                    legend: {
                        display: false
                    }
                }
            }
        });
    } catch (error) {
        console.error('Error creating chart:', error);
    }
});
</script>
@endpush