<!-- filepath: e:\KULIAH\SEMESTER 4\PA2\PA2\PA2\resources\views\super_admin\entrepreneurs\index.blade.php -->


<?php $__env->startSection('content'); ?>
<div class="container py-5">
    <h1 class="mb-4">Daftar Akun Owner</h1>

    <!-- Tombol Tambah Akun -->
    <div class="mb-3">
        <a href="<?php echo e(route('super_admin.entrepreneurs.create')); ?>" class="btn btn-primary">
            <i class="bi bi-plus-circle"></i> Tambah Akun Owner Baru
        </a>
    </div>

    <!-- Tabel Data -->
    <div class="table-responsive">
        <table class="table table-bordered table-hover">
            <thead class="table-dark">
                <tr>
                    <th>ID</th>
                    <th>Nama</th>
                    <th>Email</th>
                    <th>Aksi</th>
                </tr>
            </thead>
            <tbody>
                <?php $__currentLoopData = $entrepreneurs; $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $entrepreneur): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); ?>
                <tr>
                    <td><?php echo e($entrepreneur->id); ?></td>
                    <td><?php echo e($entrepreneur->name); ?></td>
                    <td><?php echo e($entrepreneur->email); ?></td>
                    <td>
                        <!-- Tombol Edit -->
                        <a href="<?php echo e(route('super_admin.entrepreneurs.edit', $entrepreneur->id)); ?>" 
                           class="btn btn-warning btn-sm">
                            <i class="bi bi-pencil-square"></i> Edit
                        </a>

                        <form action="<?php echo e(route('super_admin.entrepreneurs.destroy', $entrepreneur->id)); ?>" 
                              method="POST" 
                              class="d-inline"
                              onsubmit="return confirm('Apakah Anda yakin ingin menghapus akun ini?');">
                            <?php echo csrf_field(); ?>
                            <?php echo method_field('DELETE'); ?>
                            <button type="submit" class="btn btn-danger btn-sm">
                                <i class="bi bi-trash"></i> Hapus
                            </button>
                        </form>
                    </td>
                </tr>
                <?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); ?>
            </tbody>
        </table>
    </div>
</div>
<?php $__env->stopSection(); ?>
<?php echo $__env->make('layouts.index-superadmin', array_diff_key(get_defined_vars(), ['__data' => 1, '__path' => 1]))->render(); ?><?php /**PATH E:\KULIAH\SEMESTER 4\PA2\ProyekAkhir2\backend\resources\views/super_admin/entrepreneurs/index.blade.php ENDPATH**/ ?>