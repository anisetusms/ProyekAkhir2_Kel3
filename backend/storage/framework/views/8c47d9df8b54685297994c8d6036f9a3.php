<?php $__env->startSection('content'); ?>
<div class="container py-5">
    <div class="row justify-content-center">
        <div class="col-md-8">

            
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h2 class="text-primary mb-0">
                    <i class="fas fa-user-shield me-2 text-primary"></i>Profil Super Admin
                </h2>
                <a href="<?php echo e(route('super_admin.dashboard')); ?>" class="btn btn-outline-secondary">
                    <i class="fas fa-arrow-left me-1"></i> Kembali
                </a>
            </div>

            
            <?php if(session('success')): ?>
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    <i class="fas fa-check-circle me-2"></i><?php echo e(session('success')); ?>

                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            <?php endif; ?>

            
            <?php if($errors->any()): ?>
                <div class="alert alert-danger">
                    <ul class="mb-0">
                        <?php $__currentLoopData = $errors->all(); $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $error): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); ?>
                            <li><i class="fas fa-exclamation-circle me-2 text-danger"></i><?php echo e($error); ?></li>
                        <?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); ?>
                    </ul>
                </div>
            <?php endif; ?>

            
            <div class="card shadow border-0 rounded-3">
                <div class="card-body">
                    <table class="table table-borderless mb-0">
                        <tr>
                            <th class="text-muted" style="width: 30%;">
                                <i class="fas fa-user me-2 text-primary"></i>Nama
                            </th>
                            <td class="fw-semibold"><?php echo e($admin->name); ?></td>
                        </tr>
                        <tr>
                            <th class="text-muted">
                                <i class="fas fa-envelope me-2 text-info"></i>Email
                            </th>
                            <td class="fw-semibold"><?php echo e($admin->email); ?></td>
                        </tr>
                        <tr>
                            <th class="text-muted">
                                <i class="fas fa-user-tag me-2 text-warning"></i>Username
                            </th>
                            <td class="fw-semibold"><?php echo e($admin->username); ?></td>
                        </tr>
                    </table>
                </div>
                <div class="card-footer bg-white text-end">
                    <a href="<?php echo e(route('super_admin.profiles.edit')); ?>" class="btn btn-warning">
                        <i class="fas fa-edit me-1"></i> Edit Profil
                    </a>
                </div>
            </div>
        </div>
    </div>
</div>
<?php $__env->stopSection(); ?>

<?php echo $__env->make('layouts.index-superadmin', array_diff_key(get_defined_vars(), ['__data' => 1, '__path' => 1]))->render(); ?><?php /**PATH E:\KULIAH\SEMESTER 4\PA2\ProyekAkhir2\backend\resources\views/super_admin/profiles/index.blade.php ENDPATH**/ ?>