<?php $__env->startSection('content'); ?>
<div class="container">
    <div class="row mb-4">
        <div class="col-12">
            <h3>Daftar Ruangan</h3>
            <a href="<?php echo e(route('admin.properties.rooms.create', $property->id)); ?>" class="btn btn-primary">
                <i class="fas fa-plus-circle"></i> Tambah Ruangan
            </a>
        </div>
    </div>

    <!-- Notifikasi jika ada pesan -->
    <?php if(session('success')): ?>
        <div class="alert alert-success">
            <?php echo e(session('success')); ?>

        </div>
    <?php elseif(session('error')): ?>
        <div class="alert alert-danger">
            <?php echo e(session('error')); ?>

        </div>
    <?php endif; ?>

    <div class="row">
        <div class="col-12">
            <table class="table table-bordered table-striped">
                <thead>
                    <tr>
                        <th>No</th>
                        <th>Nama Ruangan</th>
                        <th>Harga per Bulan</th>
                        <th>Fasilitas</th>
                        <th>Status</th>
                        <th>Aksi</th>
                    </tr>
                </thead>
                <tbody>
                    <?php $__empty_1 = true; $__currentLoopData = $rooms; $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $index => $room): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); $__empty_1 = false; ?>
                    <tr>
                        <td><?php echo e($loop->iteration); ?></td>
                        <td><?php echo e($room->room_type); ?></td>
                        <td>Rp <?php echo e(number_format($room->price, 0, ',', '.')); ?></td>
                        <td>
                            <?php if(!empty($room->facilities) && $room->facilities->count() > 0): ?>
                                <ul class="mb-0">
                                    <?php $__currentLoopData = $room->facilities; $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $facility): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); ?>
                                        <li><?php echo e($facility->facility_name); ?></li>
                                    <?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); ?>
                                </ul>
                            <?php else: ?>
                                <em>Tidak ada fasilitas</em>
                            <?php endif; ?>
                        </td>
                        <td>
                            <span class="badge bg-<?php echo e($room->is_available ? 'success' : 'danger'); ?>">
                                <?php echo e($room->is_available ? 'Tersedia' : 'Tidak Tersedia'); ?>

                            </span>
                        </td>
                        <td>
                            <a href="<?php echo e(route('admin.properties.rooms.show', [$property->id, $room->id])); ?>" class="btn btn-info btn-sm mb-1">
                                <i class="fas fa-eye"></i> Lihat
                            </a>
                            <a href="<?php echo e(route('admin.properties.rooms.edit', [$property->id, $room->id])); ?>" class="btn btn-warning btn-sm mb-1">
                                <i class="fas fa-edit"></i> Edit
                            </a>
                            <form action="<?php echo e(route('admin.properties.rooms.destroy', [$property->id, $room->id])); ?>" method="POST" class="d-inline-block">
                                <?php echo csrf_field(); ?>
                                <?php echo method_field('DELETE'); ?>
                                <button type="submit" class="btn btn-danger btn-sm" onclick="return confirm('Apakah Anda yakin ingin menghapus ruangan ini?')">
                                    <i class="fas fa-trash-alt"></i> Hapus
                                </button>
                            </form>
                        </td>
                    </tr>
                    <?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); if ($__empty_1): ?>
                    <tr>
                        <td colspan="6" class="text-center">Belum ada ruangan tersedia.</td>
                    </tr>
                    <?php endif; ?>
                </tbody>
            </table>

            <!-- Pagination -->
            <div class="d-flex justify-content-center">
                <?php echo e($rooms->links()); ?>

            </div>
        </div>
    </div>
</div>
<?php $__env->stopSection(); ?>

<?php echo $__env->make('layouts.admin', array_diff_key(get_defined_vars(), ['__data' => 1, '__path' => 1]))->render(); ?><?php /**PATH E:\KULIAH\SEMESTER 4\PA2\ProyekAkhir2\backend\resources\views/admin/properties/rooms/index.blade.php ENDPATH**/ ?>