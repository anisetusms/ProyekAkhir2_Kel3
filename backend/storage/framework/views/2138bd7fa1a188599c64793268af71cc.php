

<?php $__env->startSection('content'); ?>
<div class="container py-5">
    <div class="row">
        <div class="col">
            <h1 class="mb-4 text-center">Daftar Pengusaha</h1>
        </div>
    </div>

    <!-- Owner Aktif -->
    <div class="row mb-5">
        <div class="col">
            <div class="card shadow">
                <div class="card-header bg-success text-white">
                    <h5 class="mb-0">Owner Aktif</h5>
                </div>
                <div class="card-body p-0">
                    <ul class="list-group list-group-flush">
                        <?php $__empty_1 = true; $__currentLoopData = $activeOwners; $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $owner): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); $__empty_1 = false; ?>
                            <li class="list-group-item d-flex justify-content-between align-items-center">
                                <div>
                                    <strong><?php echo e($owner->username); ?></strong><br>
                                    <small><?php echo e($owner->email); ?></small>
                                </div>
                                <div class="d-flex">
                                    <!-- Detail Button -->
                                    <a href="<?php echo e(route('platform_admin.show', $owner->id)); ?>"
                                       class="btn btn-sm btn-outline-primary"
                                       data-bs-toggle="tooltip"
                                       title="Detail">
                                        <i class="fas fa-eye"></i>
                                    </a>
                                    
                                    <!-- Ban Button -->
                                    <form action="<?php echo e(route('platform_admin.ban', $owner->id)); ?>" method="POST">
                                        <?php echo csrf_field(); ?>
                                        <button type="submit" class="btn btn-outline-danger btn-sm ms-2" title="Ban">
                                            <i class="fas fa-user-slash"></i>
                                        </button>
                                    </form>
                                </div>
                            </li>
                        <?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); if ($__empty_1): ?>
                            <li class="list-group-item text-center text-muted">Tidak ada owner aktif.</li>
                        <?php endif; ?>
                    </ul>
                </div>
            </div>
        </div>
    </div>

    <!-- Owner Dibanned -->
    <div class="row">
        <div class="col">
            <div class="card shadow">
                <div class="card-header bg-danger text-white">
                    <h5 class="mb-0">Owner Dibanned</h5>
                </div>
                <div class="card-body p-0">
                    <ul class="list-group list-group-flush">
                        <?php $__empty_1 = true; $__currentLoopData = $bannedOwners; $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $owner): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); $__empty_1 = false; ?>
                            <li class="list-group-item d-flex justify-content-between align-items-center">
                                <div>
                                    <strong><?php echo e($owner->username); ?></strong><br>
                                    <small><?php echo e($owner->email); ?></small>
                                </div>
                                <div class="d-flex">
                                    <!-- Detail Button -->
                                    <a href="<?php echo e(route('platform_admin.show', $owner->id)); ?>"
                                       class="btn btn-sm btn-outline-primary"
                                       data-bs-toggle="tooltip"
                                       title="Detail">
                                        <i class="fas fa-eye"></i>
                                    </a>
                                    
                                    <!-- Unban Button -->
                                    <form action="<?php echo e(route('platform_admin.unban', $owner->id)); ?>" method="POST">
                                        <?php echo csrf_field(); ?>
                                        <button type="submit" class="btn btn-outline-success btn-sm ms-2" title="Unban">
                                            <i class="fas fa-user-check"></i>
                                        </button>
                                    </form>
                                </div>
                            </li>
                        <?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); if ($__empty_1): ?>
                            <li class="list-group-item text-center text-muted">Tidak ada owner yang dibanned.</li>
                        <?php endif; ?>
                    </ul>
                </div>
            </div>
        </div>
    </div>
</div>
<?php $__env->stopSection(); ?>

<?php echo $__env->make('layouts.index-adminplatform', array_diff_key(get_defined_vars(), ['__data' => 1, '__path' => 1]))->render(); ?><?php /**PATH E:\KULIAH\SEMESTER 4\PA2\ProyekAkhir2\backend\resources\views/platform_admin/pengusaha.blade.php ENDPATH**/ ?>