<!-- filepath: resources/views/platform_admin/Penyewa.blade.php -->


<?php $__env->startSection('content'); ?>
<div class="container py-5">
    <div class="row">
        <div class="col">
            <h1 class="mb-4 text-center">Daftar Penyewa</h1>
        </div>
    </div>

        <!-- Penyewa Aktif -->
    <div class="row mb-5">
        <div class="col">
            <div class="card shadow">
                <div class="card-header bg-success text-white">
                    <h5 class="mb-0">Penyewa Aktif</h5>
                </div>
                <div class="card-body p-0">
                    <ul class="list-group list-group-flush">
                        <?php $__empty_1 = true; $__currentLoopData = $activeTenant; $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $tenant): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); $__empty_1 = false; ?>
                            <li class="list-group-item d-flex justify-content-between align-items-center">
                                <div>
                                    <strong><?php echo e($tenant->username); ?></strong><br>
                                    <small><?php echo e($tenant->email); ?></small>
                                </div>
                                <form action="<?php echo e(route('platform_admin.ban', $tenant->id)); ?>" method="POST">
                                    <?php echo csrf_field(); ?>
                                    <button type="submit" class="btn btn-outline-danger btn-sm" title="Ban">
                                        <i class="fas fa-user-slash"></i>
                                    </button>
                                </form>
                            </li>
                        <?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); if ($__empty_1): ?>
                            <li class="list-group-item text-center text-muted">Tidak ada penyewa aktif.</li>
                        <?php endif; ?>
                    </ul>
                </div>
            </div>
        </div>
    </div>


    <!-- Penyewa Dibanned -->
    <div class="row">
        <div class="col">
            <div class="card shadow">
                <div class="card-header bg-danger text-white">
                    <h5 class="mb-0">Penyewa Dibanned</h5>
                </div>
                <div class="card-body p-0">
                    <ul class="list-group list-group-flush">
                        <?php $__empty_1 = true; $__currentLoopData = $bannedTenant; $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $tenant): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); $__empty_1 = false; ?>
                            <li class="list-group-item d-flex justify-content-between align-items-center">
                                <div>
                                    <strong><?php echo e($tenant->username); ?></strong><br>
                                    <small><?php echo e($tenant->email); ?></small>
                                </div>
                                <form action="<?php echo e(route('platform_admin.unban', $tenant->id)); ?>" method="POST">
                                    <?php echo csrf_field(); ?>
                                    <button type="submit" class="btn btn-outline-success btn-sm" title="Unban">
                                        <i class="fas fa-user-check"></i>
                                    </button>
                                </form>
                            </li>
                        <?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); if ($__empty_1): ?>
                            <li class="list-group-item text-center text-muted">Tidak ada penyewa yang dibanned.</li>
                        <?php endif; ?>
                    </ul>
                </div>
            </div>
        </div>
    </div>
</div>
<?php $__env->stopSection(); ?>
<?php echo $__env->make('layouts.index-adminplatform', array_diff_key(get_defined_vars(), ['__data' => 1, '__path' => 1]))->render(); ?><?php /**PATH E:\KULIAH\SEMESTER 4\PA2\ProyekAkhir2\backend\resources\views/platform_admin/penyewa.blade.php ENDPATH**/ ?>