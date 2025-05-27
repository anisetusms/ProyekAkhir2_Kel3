<?php $__env->startSection('title' , 'Daftar Admin Officier'); ?>


<?php $__env->startSection('content'); ?>
<div class="container py-5">
    <div class="card shadow-sm">
        <div class="card-header bg-primary text-white">
            <h5 class="mb-0"><i class="fas fa-users me-2"></i> Daftar Admin Officier</h5>
        </div>
        <div class="card-body">
            <?php if(session('success')): ?>
            <div class="alert alert-success"><i class="fas fa-check-circle me-2"></i> <?php echo e(session('success')); ?></div>
            <?php endif; ?>

            <?php if(session('error')): ?>
            <div class="alert alert-danger"><i class="fas fa-exclamation-triangle me-2"></i> <?php echo e(session('error')); ?></div>
            <?php endif; ?>

            <div class="mb-3">
                <a href="<?php echo e(route('super_admin.platform_admins.create')); ?>" class="btn btn-primary"><i class="fas fa-plus me-2"></i> Tambah Admin</a>
            </div>

            <div class="table-responsive">
                <table class="table table-bordered table-hover align-middle">
                    <thead>
                        <tr>
                            <th>#</th>
                            <th>Nama</th>
                            <th>Email</th>
                            <th>Username</th>
                            <th>Dibuat Pada</th>
                            <th class="text-center">Aksi</th>
                        </tr>
                    </thead>
                    <tbody>
                        <?php $__currentLoopData = $platformAdmins; $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $admin): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); ?>
                        <tr>
                            <td><?php echo e($loop->iteration); ?></td>
                            <td><?php echo e($admin->name); ?></td>
                            <td><?php echo e($admin->email); ?></td>
                            <td><?php echo e($admin->username); ?></td>
                            <td><?php echo e($admin->created_at); ?></td>
                            <td class="text-center">
                                <a href="<?php echo e(route('super_admin.platform_admins.edit', $admin->id)); ?>"
                                    class="btn btn-sm btn-outline-warning"
                                    data-bs-toggle="tooltip"
                                    title="Edit">
                                    <i class="fas fa-edit"></i>
                                </a>
                                <form action="<?php echo e(route('super_admin.platform_admins.delete', $admin->id)); ?>" method="POST" class="d-inline">
                                    <?php echo csrf_field(); ?>
                                    <?php echo method_field('DELETE'); ?>
                                    <button type="submit"
                                        class="btn btn-sm btn-outline-danger"
                                        data-bs-toggle="tooltip"
                                        title="Hapus"
                                        onclick="return confirm('Apakah Anda yakin ingin menghapus admin ini?')">
                                        <i class="fas fa-trash-alt"></i>
                                    </button>
                                </form>
                            </td>
                        </tr>
                        <?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); ?>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>
<?php $__env->stopSection(); ?>

<?php $__env->startPush('styles'); ?>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
<?php $__env->stopPush(); ?>
<?php echo $__env->make('layouts.index-superadmin', array_diff_key(get_defined_vars(), ['__data' => 1, '__path' => 1]))->render(); ?><?php /**PATH E:\KULIAH\SEMESTER 4\PA2\ProyekAkhir2\backend\resources\views/super_admin/platform_admins/index.blade.php ENDPATH**/ ?>