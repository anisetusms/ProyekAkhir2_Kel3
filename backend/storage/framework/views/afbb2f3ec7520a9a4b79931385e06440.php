<?php $__env->startSection('title' , 'Edit Entrepreneur'); ?>

<?php $__env->startSection('content'); ?>
<div class="container mt-5">
    <div class="row justify-content-center">
        <div class="col-md-8">
            <!-- Card Container -->
            <div class="card shadow-sm border-0">
                <div class="card-header bg-primary text-white">
                    <h4 class="mb-0">Edit Entrepreneur</h4>
                </div>
                <div class="card-body">
                    <form action="<?php echo e(route('super_admin.entrepreneurs.update', $entrepreneur->id)); ?>" method="POST">
                        <?php echo csrf_field(); ?>
                        <?php echo method_field('POST'); ?> <!-- Sesuaikan dengan method route -->

                        <div class="mb-3">
                            <label for="name" class="form-label">Name</label>
                            <input 
                                type="text" 
                                name="name" 
                                id="name" 
                                class="form-control" 
                                value="<?php echo e(old('name', $entrepreneur->name)); ?>" 
                                required
                            >
                        </div>

                        <div class="mb-3">
                            <label for="email" class="form-label">Email</label>
                            <input 
                                type="email" 
                                name="email" 
                                id="email" 
                                class="form-control" 
                                value="<?php echo e(old('email', $entrepreneur->email)); ?>" 
                                required
                            >
                        </div>

                        <div class="mb-3">
                            <label for="password" class="form-label">Password <span class="text-muted">(Optional)</span></label>
                            <input 
                                type="password" 
                                name="password" 
                                id="password" 
                                class="form-control"
                            >
                        </div>

                        <div class="mb-4">
                            <label for="password_confirmation" class="form-label">Confirm Password</label>
                            <input 
                                type="password" 
                                name="password_confirmation" 
                                id="password_confirmation" 
                                class="form-control"
                            >
                        </div>

                        <div class="d-flex justify-content-between">
                            <a href="<?php echo e(url()->previous()); ?>" class="btn btn-outline-secondary">
                                ← Kembali
                            </a>
                            <button type="submit" class="btn btn-primary"><i class="fas fa-save me-2"></i>
                                Simpan Perubahan
                            </button>
                        </div>
                    </form>
                </div>
            </div>

            <!-- Optional: Error messages -->
            <?php if($errors->any()): ?>
                <div class="alert alert-danger mt-4">
                    <strong>Terjadi kesalahan:</strong>
                    <ul class="mb-0">
                        <?php $__currentLoopData = $errors->all(); $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $error): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); ?>
                            <li><?php echo e($error); ?></li>
                        <?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); ?>
                    </ul>
                </div>
            <?php endif; ?>

        </div>
    </div>
</div>
<?php $__env->stopSection(); ?>
<?php echo $__env->make('layouts.index-superadmin', array_diff_key(get_defined_vars(), ['__data' => 1, '__path' => 1]))->render(); ?><?php /**PATH E:\KULIAH\SEMESTER 4\PA2\ProyekAkhir2\backend\resources\views/super_admin/entrepreneurs/edit.blade.php ENDPATH**/ ?>