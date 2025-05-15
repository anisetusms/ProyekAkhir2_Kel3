

<?php $__env->startSection('title', 'Dashboard Ulasan'); ?>

<?php $__env->startSection('content'); ?>
<div class="row">
    <!-- Total Ulasan Card -->
    <div class="col-xl-3 col-md-6 mb-4">
        <div class="card border-left-primary shadow h-100 py-2">
            <div class="card-body">
                <div class="row no-gutters align-items-center">
                    <div class="col mr-2">
                        <div class="text-xs font-weight-bold text-primary text-uppercase mb-1">
                            Total Ulasan</div>
                        <div class="h5 mb-0 font-weight-bold text-gray-800"><?php echo e($totalReviews); ?></div>
                    </div>
                    <div class="col-auto">
                        <i class="fas fa-comments fa-2x text-gray-300"></i>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Rating Rata-rata Card -->
    <div class="col-xl-3 col-md-6 mb-4">
        <div class="card border-left-success shadow h-100 py-2">
            <div class="card-body">
                <div class="row no-gutters align-items-center">
                    <div class="col mr-2">
                        <div class="text-xs font-weight-bold text-success text-uppercase mb-1">
                            Rating Rata-rata</div>
                        <div class="h5 mb-0 font-weight-bold text-gray-800">
                            <?php echo e(number_format($averageRating, 1)); ?>

                            <small class="text-warning">
                                <?php for($i = 1; $i <= 5; $i++): ?>
                                    <?php if($i <= round($averageRating)): ?>
                                        <i class="fas fa-star"></i>
                                    <?php else: ?>
                                        <i class="far fa-star"></i>
                                    <?php endif; ?>
                                <?php endfor; ?>
                            </small>
                        </div>
                    </div>
                    <div class="col-auto">
                        <i class="fas fa-star fa-2x text-gray-300"></i>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Ulasan Bintang 5 Card -->
    <div class="col-xl-3 col-md-6 mb-4">
        <div class="card border-left-warning shadow h-100 py-2">
            <div class="card-body">
                <div class="row no-gutters align-items-center">
                    <div class="col mr-2">
                        <div class="text-xs font-weight-bold text-warning text-uppercase mb-1">
                            Ulasan Bintang 5</div>
                        <div class="h5 mb-0 font-weight-bold text-gray-800">
                            <?php echo e($fiveStarReviews); ?>

                            <small class="text-muted">
                                (<?php echo e($totalReviews > 0 ? number_format(($fiveStarReviews / $totalReviews) * 100, 1) : 0); ?>%)
                            </small>
                        </div>
                    </div>
                    <div class="col-auto">
                        <i class="fas fa-award fa-2x text-gray-300"></i>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Ulasan Terbaru Card -->
    <div class="col-xl-3 col-md-6 mb-4">
        <div class="card border-left-info shadow h-100 py-2">
            <div class="card-body">
                <div class="row no-gutters align-items-center">
                    <div class="col mr-2">
                        <div class="text-xs font-weight-bold text-info text-uppercase mb-1">
                            Ulasan Terbaru</div>
                        <div class="h5 mb-0 font-weight-bold text-gray-800">
                            <?php echo e($recentReviews->count()); ?>

                        </div>
                    </div>
                    <div class="col-auto">
                        <i class="fas fa-clock fa-2x text-gray-300"></i>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<div class="row">
    <!-- Distribusi Rating -->
    <div class="col-xl-8 col-lg-7">
        <div class="card shadow mb-4">
            <div class="card-header py-3 d-flex flex-row align-items-center justify-content-between">
                <h6 class="m-0 font-weight-bold text-primary">Distribusi Rating</h6>
            </div>
            <div class="card-body">
                <div class="chart-bar">
                    <canvas id="ratingDistributionChart"></canvas>
                </div>
            </div>
        </div>
    </div>

    <!-- Ulasan Terbaru -->
    <div class="col-xl-4 col-lg-5">
        <div class="card shadow mb-4">
            <div class="card-header py-3 d-flex flex-row align-items-center justify-content-between">
                <h6 class="m-0 font-weight-bold text-primary">Ulasan Terbaru</h6>
                <a href="<?php echo e(route('admin.properties.ulasan.index')); ?>" class="btn btn-sm btn-primary">
                    Lihat Semua
                </a>
            </div>
            <div class="card-body">
                <?php if($recentReviews->isEmpty()): ?>
                    <div class="text-center py-4">
                        <i class="fas fa-comment-slash fa-3x text-gray-300 mb-3"></i>
                        <p class="text-gray-500">Belum ada ulasan</p>
                    </div>
                <?php else: ?>
                    <div class="list-group">
                        <?php $__currentLoopData = $recentReviews; $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $review): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); ?>
                            <a href="<?php echo e(route('admin.properties.ulasan.show', $review->id)); ?>" class="list-group-item list-group-item-action">
                                <div class="d-flex w-100 justify-content-between">
                                    <h6 class="mb-1"><?php echo e($review->booking->user->name); ?></h6>
                                    <small class="text-muted"><?php echo e($review->created_at->diffForHumans()); ?></small>
                                </div>
                                <div class="mb-1">
                                    <?php for($i = 1; $i <= 5; $i++): ?>
                                        <?php if($i <= $review->rating): ?>
                                            <i class="fas fa-star text-warning"></i>
                                        <?php else: ?>
                                            <i class="far fa-star text-warning"></i>
                                        <?php endif; ?>
                                    <?php endfor; ?>
                                </div>
                                <p class="mb-1"><?php echo e(\Illuminate\Support\Str::limit($review->comment, 100)); ?></p>
                                <small class="text-muted"><?php echo e($review->property->name); ?></small>
                            </a>
                        <?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); ?>
                    </div>
                <?php endif; ?>
            </div>
        </div>
    </div>
</div>

<div class="row">
    <!-- Properti dengan Ulasan -->
    <div class="col-12">
        <div class="card shadow mb-4">
            <div class="card-header py-3">
                <h6 class="m-0 font-weight-bold text-primary">Properti dengan Ulasan</h6>
            </div>
            <div class="card-body">
                <div class="table-responsive">
                    <table class="table table-bordered" width="100%" cellspacing="0">
                        <thead>
                            <tr>
                                <th>Properti</th>
                                <th>Jumlah Ulasan</th>
                                <th>Rating Rata-rata</th>
                                <th>Aksi</th>
                            </tr>
                        </thead>
                        <tbody>
                            <?php $__currentLoopData = $propertiesWithReviews; $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $property): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); ?>
                                <tr>
                                    <td>
                                        <div class="d-flex align-items-center">
                                            <?php if($property->image): ?>
                                                <img src="<?php echo e(asset('storage/' . $property->image)); ?>" alt="<?php echo e($property->name); ?>" class="img-thumbnail mr-3" style="width: 50px; height: 50px; object-fit: cover;">
                                            <?php else: ?>
                                                <div class="bg-gray-200 mr-3" style="width: 50px; height: 50px; display: flex; align-items: center; justify-content: center;">
                                                    <i class="fas fa-home text-gray-500"></i>
                                                </div>
                                            <?php endif; ?>
                                            <div>
                                                <div class="font-weight-bold"><?php echo e($property->name); ?></div>
                                                <div class="small text-muted"><?php echo e($property->address); ?></div>
                                            </div>
                                        </div>
                                    </td>
                                    <td><?php echo e($property->reviews_count); ?></td>
                                    <td>
                                        <div class="d-flex align-items-center">
                                            <span class="font-weight-bold mr-2"><?php echo e(number_format($property->reviews_avg_rating, 1)); ?></span>
                                            <div>
                                                <?php for($i = 1; $i <= 5; $i++): ?>
                                                    <?php if($i <= round($property->reviews_avg_rating)): ?>
                                                        <i class="fas fa-star text-warning"></i>
                                                    <?php else: ?>
                                                        <i class="far fa-star text-warning"></i>
                                                    <?php endif; ?>
                                                <?php endfor; ?>
                                            </div>
                                        </div>
                                    </td>
                                    <td>
                                        <a href="<?php echo e(route('admin.properties.ulasan.property', $property->id)); ?>" class="btn btn-sm btn-primary">
                                            <i class="fas fa-eye"></i> Lihat Ulasan
                                        </a>
                                    </td>
                                </tr>
                            <?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); ?>
                            
                            <?php if($propertiesWithReviews->isEmpty()): ?>
                                <tr>
                                    <td colspan="4" class="text-center py-4">
                                        <i class="fas fa-comment-slash fa-3x text-gray-300 mb-3"></i>
                                        <p class="text-gray-500">Belum ada ulasan untuk properti Anda</p>
                                    </td>
                                </tr>
                            <?php endif; ?>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>
<?php $__env->stopSection(); ?>

<?php $__env->startPush('scripts'); ?>
<script src="<?php echo e(asset('vendor/chart.js/Chart.min.js')); ?>"></script>
<script>
    // Grafik Distribusi Rating
    var ctx = document.getElementById("ratingDistributionChart");
    var ratingDistributionChart = new Chart(ctx, {
        type: 'bar',
        data: {
            labels: ["Bintang 5", "Bintang 4", "Bintang 3", "Bintang 2", "Bintang 1"],
            datasets: [{
                label: "Jumlah Ulasan",
                backgroundColor: ["#4e73df", "#1cc88a", "#36b9cc", "#f6c23e", "#e74a3b"],
                data: [
                    <?php echo e($ratingDistribution[5]); ?>,
                    <?php echo e($ratingDistribution[4]); ?>,
                    <?php echo e($ratingDistribution[3]); ?>,
                    <?php echo e($ratingDistribution[2]); ?>,
                    <?php echo e($ratingDistribution[1]); ?>

                ],
            }],
        },
        options: {
            maintainAspectRatio: false,
            layout: {
                padding: {
                    left: 10,
                    right: 25,
                    top: 25,
                    bottom: 0
                }
            },
            scales: {
                xAxes: [{
                    gridLines: {
                        display: false,
                        drawBorder: false
                    },
                    maxBarThickness: 25,
                }],
                yAxes: [{
                    ticks: {
                        min: 0,
                        maxTicksLimit: 5,
                        padding: 10,
                        callback: function(value, index, values) {
                            return value;
                        }
                    },
                    gridLines: {
                        color: "rgb(234, 236, 244)",
                        zeroLineColor: "rgb(234, 236, 244)",
                        drawBorder: false,
                        borderDash: [2],
                        zeroLineBorderDash: [2]
                    }
                }],
            },
            legend: {
                display: false
            },
            tooltips: {
                titleMarginBottom: 10,
                titleFontColor: '#6e707e',
                titleFontSize: 14,
                backgroundColor: "rgb(255,255,255)",
                bodyFontColor: "#858796",
                borderColor: '#dddfeb',
                borderWidth: 1,
                xPadding: 15,
                yPadding: 15,
                displayColors: false,
                caretPadding: 10,
                callbacks: {
                    label: function(tooltipItem, chart) {
                        var datasetLabel = chart.datasets[tooltipItem.datasetIndex].label || '';
                        return datasetLabel + ': ' + tooltipItem.yLabel;
                    }
                }
            },
        }
    });
</script>
<?php $__env->stopPush(); ?>

<?php echo $__env->make('layouts.admin', array_diff_key(get_defined_vars(), ['__data' => 1, '__path' => 1]))->render(); ?><?php /**PATH E:\KULIAH\SEMESTER 4\PA2\ProyekAkhir2\backend\resources\views/admin/ulasan/dashboard.blade.php ENDPATH**/ ?>