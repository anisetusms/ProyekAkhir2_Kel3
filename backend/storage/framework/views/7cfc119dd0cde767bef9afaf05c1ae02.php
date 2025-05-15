

<?php $__env->startSection('title', 'Statistik Pemesanan'); ?>

<?php $__env->startSection('action_button'); ?>
<a href="<?php echo e(route('admin.properties.bookings.index')); ?>" class="d-none d-sm-inline-block btn btn-sm btn-secondary shadow-sm">
    <i class="fas fa-arrow-left fa-sm text-white-50"></i> Kembali
</a>
<?php $__env->stopSection(); ?>

<?php $__env->startSection('content'); ?>
<!-- Content Row -->
<div class="row">
    <!-- Total Bookings Card -->
    <div class="col-xl-3 col-md-6 mb-4">
        <div class="card border-left-primary shadow h-100 py-2">
            <div class="card-body">
                <div class="row no-gutters align-items-center">
                    <div class="col mr-2">
                        <div class="text-xs font-weight-bold text-primary text-uppercase mb-1">
                            Total Pemesanan</div>
                        <div class="h5 mb-0 font-weight-bold text-gray-800"><?php echo e($totalBookings); ?></div>
                    </div>
                    <div class="col-auto">
                        <i class="fas fa-calendar fa-2x text-gray-300"></i>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Pending Bookings Card -->
    <div class="col-xl-3 col-md-6 mb-4">
        <div class="card border-left-warning shadow h-100 py-2">
            <div class="card-body">
                <div class="row no-gutters align-items-center">
                    <div class="col mr-2">
                        <div class="text-xs font-weight-bold text-warning text-uppercase mb-1">
                            Menunggu Konfirmasi</div>
                        <div class="h5 mb-0 font-weight-bold text-gray-800"><?php echo e($pendingBookings); ?></div>
                    </div>
                    <div class="col-auto">
                        <i class="fas fa-clock fa-2x text-gray-300"></i>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Confirmed Bookings Card -->
    <div class="col-xl-3 col-md-6 mb-4">
        <div class="card border-left-success shadow h-100 py-2">
            <div class="card-body">
                <div class="row no-gutters align-items-center">
                    <div class="col mr-2">
                        <div class="text-xs font-weight-bold text-success text-uppercase mb-1">
                            Dikonfirmasi</div>
                        <div class="h5 mb-0 font-weight-bold text-gray-800"><?php echo e($confirmedBookings); ?></div>
                    </div>
                    <div class="col-auto">
                        <i class="fas fa-check fa-2x text-gray-300"></i>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Completed Bookings Card -->
    <div class="col-xl-3 col-md-6 mb-4">
        <div class="card border-left-info shadow h-100 py-2">
            <div class="card-body">
                <div class="row no-gutters align-items-center">
                    <div class="col mr-2">
                        <div class="text-xs font-weight-bold text-info text-uppercase mb-1">
                            Selesai</div>
                        <div class="h5 mb-0 font-weight-bold text-gray-800"><?php echo e($completedBookings); ?></div>
                    </div>
                    <div class="col-auto">
                        <i class="fas fa-check-double fa-2x text-gray-300"></i>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Content Row -->
<div class="row">
    <!-- Total Revenue Card -->
    <div class="col-xl-6 col-md-6 mb-4">
        <div class="card border-left-success shadow h-100 py-2">
            <div class="card-body">
                <div class="row no-gutters align-items-center">
                    <div class="col mr-2">
                        <div class="text-xs font-weight-bold text-success text-uppercase mb-1">
                            Total Pendapatan</div>
                        <div class="h5 mb-0 font-weight-bold text-gray-800"><?php echo e('Rp ' . number_format($totalRevenue, 0, ',', '.')); ?></div>
                    </div>
                    <div class="col-auto">
                        <i class="fas fa-dollar-sign fa-2x text-gray-300"></i>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Cancelled Bookings Card -->
    <div class="col-xl-6 col-md-6 mb-4">
        <div class="card border-left-danger shadow h-100 py-2">
            <div class="card-body">
                <div class="row no-gutters align-items-center">
                    <div class="col mr-2">
                        <div class="text-xs font-weight-bold text-danger text-uppercase mb-1">
                            Dibatalkan</div>
                        <div class="h5 mb-0 font-weight-bold text-gray-800"><?php echo e($cancelledBookings); ?></div>
                    </div>
                    <div class="col-auto">
                        <i class="fas fa-times fa-2x text-gray-300"></i>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Booking Status Chart -->
<div class="row">
    <div class="col-xl-8 col-lg-7">
        <div class="card shadow mb-4">
            <div class="card-header py-3 d-flex flex-row align-items-center justify-content-between">
                <h6 class="m-0 font-weight-bold text-primary">Status Pemesanan</h6>
            </div>
            <div class="card-body">
                <div class="chart-pie pt-4 pb-2">
                    <canvas id="bookingStatusChart"></canvas>
                </div>
                <div class="mt-4 text-center small">
                    <span class="mr-2">
                        <i class="fas fa-circle text-warning"></i> Menunggu
                    </span>
                    <span class="mr-2">
                        <i class="fas fa-circle text-success"></i> Dikonfirmasi
                    </span>
                    <span class="mr-2">
                        <i class="fas fa-circle text-info"></i> Selesai
                    </span>
                    <span class="mr-2">
                        <i class="fas fa-circle text-danger"></i> Dibatalkan
                    </span>
                </div>
            </div>
        </div>
    </div>

    <!-- Recent Bookings -->
    <div class="col-xl-4 col-lg-5">
        <div class="card shadow mb-4">
            <div class="card-header py-3 d-flex flex-row align-items-center justify-content-between">
                <h6 class="m-0 font-weight-bold text-primary">Pemesanan Terbaru</h6>
            </div>
            <div class="card-body">
                <div class="list-group">
                    <?php $__empty_1 = true; $__currentLoopData = $recentBookings; $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $booking): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); $__empty_1 = false; ?>
                    <a href="<?php echo e(route('admin.properties.bookings.show', $booking->id)); ?>" class="list-group-item list-group-item-action">
                        <div class="d-flex w-100 justify-content-between">
                            <h6 class="mb-1"><?php echo e($booking->guest_name); ?></h6>
                            <small><?php echo e(\Carbon\Carbon::parse($booking->created_at)->diffForHumans()); ?></small>
                        </div>
                        <p class="mb-1"><?php echo e($booking->property->name); ?></p>
                        <div class="d-flex w-100 justify-content-between">
                            <small><?php echo e(\Carbon\Carbon::parse($booking->check_in)->format('d M Y')); ?> - <?php echo e(\Carbon\Carbon::parse($booking->check_out)->format('d M Y')); ?></small>
                            <?php if($booking->status == 'pending'): ?>
                                <span class="badge badge-warning">Menunggu</span>
                            <?php elseif($booking->status == 'confirmed'): ?>
                                <span class="badge badge-success">Dikonfirmasi</span>
                            <?php elseif($booking->status == 'completed'): ?>
                                <span class="badge badge-info">Selesai</span>
                            <?php elseif($booking->status == 'cancelled'): ?>
                                <span class="badge badge-danger">Dibatalkan</span>
                            <?php endif; ?>
                        </div>
                    </a>
                    <?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); if ($__empty_1): ?>
                    <div class="text-center py-3">
                        <p class="text-muted">Tidak ada pemesanan terbaru</p>
                    </div>
                    <?php endif; ?>
                </div>
            </div>
        </div>
    </div>
</div>
<?php $__env->stopSection(); ?>

<?php $__env->startPush('scripts'); ?>
<script src="<?php echo e(asset('vendor/chart.js/Chart.min.js')); ?>"></script>
<script>
    // Pie Chart for Booking Status
    var ctx = document.getElementById("bookingStatusChart");
    var bookingStatusChart = new Chart(ctx, {
        type: 'doughnut',
        data: {
            labels: ["Menunggu", "Dikonfirmasi", "Selesai", "Dibatalkan"],
            datasets: [{
                data: [<?php echo e($pendingBookings); ?>, <?php echo e($confirmedBookings); ?>, <?php echo e($completedBookings); ?>, <?php echo e($cancelledBookings); ?>],
                backgroundColor: ['#f6c23e', '#1cc88a', '#36b9cc', '#e74a3b'],
                hoverBackgroundColor: ['#dda20a', '#17a673', '#2c9faf', '#c93a2d'],
                hoverBorderColor: "rgba(234, 236, 244, 1)",
            }],
        },
        options: {
            maintainAspectRatio: false,
            tooltips: {
                backgroundColor: "rgb(255,255,255)",
                bodyFontColor: "#858796",
                borderColor: '#dddfeb',
                borderWidth: 1,
                xPadding: 15,
                yPadding: 15,
                displayColors: false,
                caretPadding: 10,
            },
            legend: {
                display: false
            },
            cutoutPercentage: 80,
        },
    });
</script>
<?php $__env->stopPush(); ?>

<?php echo $__env->make('layouts.admin', array_diff_key(get_defined_vars(), ['__data' => 1, '__path' => 1]))->render(); ?><?php /**PATH E:\KULIAH\SEMESTER 4\PA2\ProyekAkhir2\backend\resources\views/admin/properties/bookings/statistics.blade.php ENDPATH**/ ?>