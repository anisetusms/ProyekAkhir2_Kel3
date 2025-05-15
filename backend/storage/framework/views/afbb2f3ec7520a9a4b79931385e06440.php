<!-- filepath: e:\KULIAH\SEMESTER 4\PA2\PA2\PA2\resources\views\super_admin\entrepreneurs\edit.blade.php -->


<?php $__env->startSection('content'); ?>
<div class="container">
    <h1>Edit Entrepreneur</h1>
    <form action="<?php echo e(route('super_admin.entrepreneurs.update', $entrepreneur->id)); ?>" method="POST">
        <?php echo csrf_field(); ?>
        <?php echo method_field('POST'); ?> <!-- Pastikan metode sesuai dengan route -->

        <div class="form-group">
            <label for="name">Name</label>
            <input type="text" name="name" id="name" class="form-control" value="<?php echo e(old('name', $entrepreneur->name)); ?>" required>
        </div>

        <div class="form-group">
            <label for="email">Email</label>
            <input type="email" name="email" id="email" class="form-control" value="<?php echo e(old('email', $entrepreneur->email)); ?>" required>
        </div>

        <div class="form-group">
            <label for="password">Password (Optional)</label>
            <input type="password" name="password" id="password" class="form-control">
        </div>

        <div class="form-group">
            <label for="password_confirmation">Confirm Password</label>
            <input type="password" name="password_confirmation" id="password_confirmation" class="form-control">
        </div>

        <button type="submit" class="btn btn-primary">Update</button>
    </form>
</div>
<?php $__env->stopSection(); ?>
<?php echo $__env->make('layouts.index-superadmin', array_diff_key(get_defined_vars(), ['__data' => 1, '__path' => 1]))->render(); ?><?php /**PATH E:\KULIAH\SEMESTER 4\PA2\ProyekAkhir2\backend\resources\views/super_admin/entrepreneurs/edit.blade.php ENDPATH**/ ?>