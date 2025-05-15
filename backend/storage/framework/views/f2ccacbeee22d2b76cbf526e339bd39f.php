<?php $__env->startSection('title', 'Menunggu Persetujuan'); ?>

<?php $__env->startSection('content'); ?>
<div class="card shadow mb-4">
    <div class="card-header py-3">
        <h6 class="m-0 font-weight-bold text-primary">
            <i class="fas fa-user-clock fa-sm fa-fw mr-2 text-gray-400"></i>
            Owner Baru Menunggu Persetujuan
        </h6>
    </div>
    <div class="card-body">
        <?php if($pendingOwners->isEmpty()): ?>
            <p class="text-info">Tidak ada owner baru yang menunggu persetujuan saat ini.</p>
        <?php else: ?>
            <div class="table-responsive">
                <table class="table table-bordered" id="dataTable" width="100%" cellspacing="0">
                    <thead>
                        <tr>
                            <th>Nama</th>
                            <th>Email</th>
                            <th>Diajukan</th>
                            <th class="text-center">Aksi</th>
                        </tr>
                    </thead>
                    <tbody>
                        <?php $__currentLoopData = $pendingOwners; $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $owner): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); ?>
                            <tr>
                                <td><?php echo e($owner->name); ?></td>
                                <td><?php echo e($owner->email); ?></td>
                                <td>
                                    <?php if(!empty($owner->created_at)): ?>
                                        <?php echo e(\Carbon\Carbon::parse($owner->created_at)->diffForHumans()); ?>

                                    <?php else: ?>
                                        Tidak diketahui
                                    <?php endif; ?>
                                </td>
                                <td class="text-center">
                                    <form action="<?php echo e(route('super_admin.entrepreneurs.approve', $owner->id)); ?>" method="POST" style="display: inline;">
                                        <?php echo csrf_field(); ?>
                                        <?php echo method_field('PUT'); ?>
                                        <button type="submit" class="btn btn-success btn-sm">
                                           <i class="fas fa-check-circle fa-sm me-1"></i>Setujui
                                        </button>
                                      
                                    </form>
                                    </td>
                            </tr>
                        <?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); ?>
                    </tbody>
                </table>
            </div>
        <?php endif; ?>
    </div>
</div>
<?php $__env->stopSection(); ?>

<?php $__env->startPush('scripts'); ?>
<script>
    $(document).ready(function() {
        $('#dataTable').DataTable();
    });
</script>
<?php $__env->stopPush(); ?>
<?php echo $__env->make('layouts.index-superadmin', array_diff_key(get_defined_vars(), ['__data' => 1, '__path' => 1]))->render(); ?><?php /**PATH E:\KULIAH\SEMESTER 4\PA2\ProyekAkhir2\backend\resources\views/super_admin/entrepreneurs/pending.blade.php ENDPATH**/ ?>