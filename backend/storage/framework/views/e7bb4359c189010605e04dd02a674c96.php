

<?php $__env->startSection('title-icon', 'fa-tachometer-alt'); ?>

<?php $__env->startSection('content'); ?>
<div class="container-fluid">
    <!-- Page Header -->
    <div class="d-sm-flex align-items-center justify-content-between mb-4">
        <h1 class="h3 mb-0 text-gray-800">Dashboard Admin Platform</h1>
    </div>

    <div class="row mb-4">
        <div class="col-12">
            <div class="d-flex align-items-center">
                <div>
                    <h5 class="mb-1">Selamat Datang, <?php echo e(Auth::user()->name); ?></h5>
                    <p class="mb-0 text-gray-600">Gunakan menu navigasi untuk mengelola akun Owner dan Penyewa.</p>
                </div>
            </div>
        </div>
    </div>

    <div class="row">
        <!-- Owner Summary -->
        <div class="col-xl-6 col-md-12 mb-4">
            <div class="card shadow h-100 py-3 border-left-primary">
                <div class="card-body">
                    <div class="d-flex justify-content-between align-items-center mb-2">
                        <div>
                            <h5 class="text-primary font-weight-bold">Owner</h5>
                            <div class="h5 font-weight-bold text-gray-800">
                                Total: <?php echo e($activeOwnersCount + $bannedOwnersCount); ?>

                            </div>
                            <small class="text-success d-block">Aktif: <?php echo e($activeOwnersCount); ?></small>
                            <small class="text-danger">Dibanned: <?php echo e($bannedOwnersCount); ?></small>
                        </div>
                        <div>
                            <i class="fas fa-user-tie fa-2x text-gray-300"></i>
                        </div>
                    </div>
                    <div class="mt-2 text-right">
                        <a href="<?php echo e(route('platform_admin.pengusaha')); ?>" class="btn btn-primary btn-sm">
                            <i class="fas fa-eye"></i>
                        </a>
                    </div>
                </div>
            </div>
        </div>

        <!-- Penyewa Summary -->
        <div class="col-xl-6 col-md-12 mb-4">
            <div class="card shadow h-100 py-3 border-left-info">
                <div class="card-body">
                    <div class="d-flex justify-content-between align-items-center mb-2">
                        <div>
                            <h5 class="text-info font-weight-bold">Penyewa</h5>
                            <div class="h5 font-weight-bold text-gray-800">
                                Total: <?php echo e($activeTenantsCount + $bannedTenantsCount); ?>

                            </div>
                            <small class="text-success d-block">Aktif: <?php echo e($activeTenantsCount); ?></small>
                            <small class="text-danger">Dibanned: <?php echo e($bannedTenantsCount); ?></small>
                        </div>
                        <div>
                            <i class="fas fa-users fa-2x text-gray-300"></i>
                        </div>
                    </div>
                    <div class="mt-2 text-right">
                        <a href="<?php echo e(route('platform_admin.penyewa')); ?>" class="btn btn-info btn-sm">
                            <i class="fas fa-eye"></i>
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<?php $__env->stopSection(); ?>
<?php echo $__env->make('layouts.index-adminplatform', array_diff_key(get_defined_vars(), ['__data' => 1, '__path' => 1]))->render(); ?><?php /**PATH E:\KULIAH\SEMESTER 4\PA2\ProyekAkhir2\backend\resources\views/platform_admin/dashboard.blade.php ENDPATH**/ ?>