<?php $__env->startSection('title', 'Dashboard'); ?>

<?php $__env->startSection('content'); ?>
<div class="container-fluid px-4">
    <!-- Header Dashboard -->
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div class="dashboard-date">
            <span class="text-muted"><?php echo e(now()->translatedFormat('l, j F Y')); ?></span>
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
                        <h2 class="mb-0"><?php echo e($totalProperties); ?></h2>
                    </div>
                    <div class="icon-circle">
                        <i class="fas fa-building fa-2x"></i>
                    </div>
                </div>
                <div class="card-footer d-flex align-items-center justify-content-between">
                    <a class="small text-white stretched-link" href="<?php echo e(route('admin.properties.index')); ?>">Lihat Detail</a>
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
                        <h2 class="mb-0"><?php echo e($activeProperties); ?></h2>
                    </div>
                    <div class="icon-circle">
                        <i class="fas fa-check-circle fa-2x"></i>
                    </div>
                </div>
                <div class="card-footer d-flex align-items-center justify-content-between">
                    <a class="small text-white stretched-link" href="<?php echo e(route('admin.properties.index')); ?>">Lihat Detail</a>
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
                        <h2 class="mb-0"><?php echo e($pendingBookings); ?></h2>
                    </div>
                    <div class="icon-circle">
                        <i class="fas fa-clock fa-2x"></i>
                    </div>
                </div>
                <div class="card-footer d-flex align-items-center justify-content-between">
                    <a class="small text-white stretched-link" href="<?php echo e(route('admin.properties.bookings.dashboard')); ?>">Review Sekarang</a>
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
                        <h2 class="mb-0"><?php echo e('Rp ' . number_format($totalRevenue, 0, ',', '.')); ?></h2>
                    </div>
                    <div class="icon-circle">
                        <i class="fas fa-dollar-sign fa-2x"></i>
                    </div>
                </div>
                <div class="card-footer d-flex align-items-center justify-content-between">
                    <a class="small text-white stretched-link" href="<?php echo e(route('admin.properties.bookings.statistics')); ?>">Lihat Detail</a>
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
                    <h5 class="mb-0">Pendapatan Bulanan <?php echo e(date('Y')); ?></h5>
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
                            <h4 class="mb-0"><?php echo e($totalViews); ?></h4>
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
                        <a href="<?php echo e(route('admin.properties.create')); ?>" class="btn btn-outline-primary text-start">
                            <i class="fas fa-plus-circle me-2"></i> Tambah Properti Baru
                        </a>
                        <a href="<?php echo e(route('admin.properties.bookings.index')); ?>" class="btn btn-outline-success text-start">
                            <i class="fas fa-chart-line me-2"></i> Lihat Pemesanan
                        </a>
                        <a href="<?php echo e(route('admin.settings')); ?>" class="btn btn-outline-warning text-start">
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
                    <a href="<?php echo e(route('admin.properties.bookings.index')); ?>" class="btn btn-sm btn-outline-primary">Lihat Semua</a>
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
                                <?php $__empty_1 = true; $__currentLoopData = $latestBookings; $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $booking): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); $__empty_1 = false; ?>
                                <tr>
                                    <td><?php echo e($booking->id); ?></td>
                                    <td>
                                        <strong><?php echo e($booking->guest_name); ?></strong><br>
                                        <small><?php echo e($booking->guest_phone); ?></small>
                                    </td>
                                    <td><?php echo e($booking->property->name ?? 'N/A'); ?></td>
                                    <td><?php echo e(\Carbon\Carbon::parse($booking->check_in)->format('d M Y')); ?></td>
                                    <td><?php echo e(\Carbon\Carbon::parse($booking->check_out)->format('d M Y')); ?></td>
                                    <td><?php echo e('Rp ' . number_format($booking->total_price, 0, ',', '.')); ?></td>
                                    <td>
                                        <?php if($booking->status == 'pending'): ?>
                                        <span class="badge badge-warning">Menunggu</span>
                                        <?php elseif($booking->status == 'confirmed'): ?>
                                        <span class="badge badge-success">Dikonfirmasi</span>
                                        <?php elseif($booking->status == 'completed'): ?>
                                        <span class="badge badge-info">Selesai</span>
                                        <?php elseif($booking->status == 'cancelled'): ?>
                                        <span class="badge badge-danger">Dibatalkan</span>
                                        <?php endif; ?>
                                    </td>
                                    <td>
                                        <a href="<?php echo e(route('admin.properties.bookings.show', $booking->id)); ?>" class="btn btn-info btn-sm">
                                            <i class="fas fa-eye"></i>
                                        </a>
                                    </td>
                                </tr>
                                <?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); if ($__empty_1): ?>
                                <tr>
                                    <td colspan="8" class="text-center py-4">Belum ada pemesanan</td>
                                </tr>
                                <?php endif; ?>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<?php $__env->stopSection(); ?>

<?php $__env->startPush('styles'); ?>
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
<?php $__env->stopPush(); ?>

<?php $__env->startPush('scripts'); ?>
<!-- Load Chart.js terlebih dahulu -->
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

<script>
document.addEventListener('DOMContentLoaded', function() {
    // Debug data
    console.log('Bulan:', <?php echo json_encode($months, 15, 512) ?>);
    console.log('Pendapatan:', <?php echo json_encode($revenueData, 15, 512) ?>);
    
    const ctx = document.getElementById('revenueChart');
    if (!ctx) {
        console.error('Canvas element not found');
        return;
    }
    
    try {
        const chart = new Chart(ctx, {
            type: 'bar',
            data: {
                labels: <?php echo json_encode($months, 15, 512) ?>,
                datasets: [{
                    label: 'Pendapatan (Rp)',
                    data: <?php echo json_encode($revenueData, 15, 512) ?>,
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
<?php $__env->stopPush(); ?>
<?php echo $__env->make('layouts.admin', array_diff_key(get_defined_vars(), ['__data' => 1, '__path' => 1]))->render(); ?><?php /**PATH E:\KULIAH\SEMESTER 4\PA2\ProyekAkhir2\backend\resources\views/admin/properties/dashboard.blade.php ENDPATH**/ ?>