<?php $__env->startSection('title' , 'Daftar Owner yang sudah Disetujui'); ?>

<?php $__env->startSection('content'); ?>
<div class="container-fluid py-4">
    <div class="card shadow border-0">
        <div class="card-body">
            <?php if($approvedOwners->isEmpty()): ?>
                <div class="alert alert-info text-center py-4">
                    <i class="fas fa-info-circle fa-2x mb-3"></i>
                    <h4>Tidak ada owner yang disetujui saat ini</h4>
                    <p class="mb-0">Semua permohonan owner yang telah disetujui akan muncul di sini.</p>
                </div>
            <?php else: ?>
                <div class="table-responsive">
                    <table class="table table-hover align-middle">
                        <thead class="table-light">
                            <tr>
                                <th class="ps-4">Nama</th>
                                <th>Email</th>
                                <th>Username</th>
                                <th>Status</th>
                                <th class="text-center">Properti</th>
                                <th class="text-end pe-4">Aksi</th>
                            </tr>
                        </thead>
                        <tbody>
                            <?php $__currentLoopData = $approvedOwners; $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $owner): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); ?>
                                <tr>
                                    <td class="ps-4">
                                        <div class="d-flex align-items-center">

                                            <div>
                                                <strong><?php echo e($owner->name); ?></strong><br>
                                                <small class="text-muted">ID: <?php echo e($owner->id); ?></small>
                                            </div>
                                        </div>
                                    </td>
                                    <td>
                                        <a href="mailto:<?php echo e($owner->email); ?>" class="text-decoration-none text-primary">
                                            <?php echo e($owner->email); ?>

                                        </a>
                                    </td>
                                    <td><?php echo e($owner->username); ?></td>
                                    <td>
                                         <span class="badge badge-pill badge-success"><i class="fas fa-check-circle fa-sm me-1"></i>Disetujui</span>
                                    </td>
                                    <td class="text-center">
                                        <span class="badge-status-property">
                                            <?php echo e($owner->properties_count); ?>

                                        </span>
                                    </td>
                                    <td class="text-end pe-4">
                                        <div class="btn-group" role="group">
                                            <a href="<?php echo e(route('super_admin.entrepreneurs.show', $owner->id)); ?>"
                                               class="btn btn-sm btn-outline-primary"
                                               data-bs-toggle="tooltip"
                                               title="Detail">
                                                <i class="fas fa-eye"></i>
                                            </a>
                                            <a href="<?php echo e(route('super_admin.entrepreneurs.edit', $owner->id)); ?>"
                                               class="btn btn-sm btn-outline-warning"
                                               data-bs-toggle="tooltip"
                                               title="Edit">
                                                <i class="fas fa-edit"></i>
                                            </a>
                                            <form action="<?php echo e(route('super_admin.entrepreneurs.destroy', $owner->id)); ?>"
                                                  method="POST"
                                                  class="d-inline"
                                                  onsubmit="return confirm('Apakah Anda yakin ingin menghapus owner ini?')">
                                                <?php echo csrf_field(); ?>
                                                <?php echo method_field('DELETE'); ?>
                                                <button type="submit"
                                                        class="btn btn-sm btn-outline-danger"
                                                        data-bs-toggle="tooltip"
                                                        title="Hapus">
                                                    <i class="fas fa-trash-alt"></i>
                                                </button>
                                            </form>
                                        </div>
                                    </td>
                                </tr>
                            <?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); ?>
                        </tbody>
                    </table>
                </div>
            <?php endif; ?>
        </div>
    </div>
</div>
<?php $__env->stopSection(); ?>

<?php $__env->startSection('scripts'); ?>
<script>
    $(document).ready(function() {
        $('[data-bs-toggle="tooltip"]').tooltip();
        $('#refreshBtn').click(function() {
            location.reload();
        });
    });
</script>
<?php $__env->stopSection(); ?>

<?php $__env->startSection('styles'); ?>
<style>
    .avatar-custom {
        width: 40px;
        height: 40px;
        border-radius: 50%;
        background: linear-gradient(135deg, #84fab0, #8fd3f4);
        color: white;
        font-weight: 600;
        font-size: 1rem;
        display: flex;
        align-items: center;
        justify-content: center;
        text-transform: uppercase;
        flex-shrink: 0;
    }

    .card {
        border-radius: 16px;
        box-shadow: 0 6px 20px rgba(0, 0, 0, 0.08);
    }

    .card-header {
        border-radius: 16px 16px 0 0;
        padding: 1rem 1.25rem;
        background: linear-gradient(90deg, #28a745, #64dd17);
        color: white;
    }

    .badge-status-property {
        background-color: #e7f1ff;
        color: #007bff;
        font-weight: 600;
        font-size: 0.85rem;
        padding: 6px 12px;
        border-radius: 999px;
        display: inline-block;
    }

    .table-hover tbody tr:hover {
        background-color: rgba(40, 167, 69, 0.05);
    }

    .btn-group .btn {
        border-radius: 8px !important;
        margin-right: 4px;
    }

    .btn-group .btn:last-child {
        margin-right: 0;
    }

    .table th {
        font-size: 0.85rem;
        text-transform: uppercase;
        font-weight: 600;
        letter-spacing: 0.5px;
    }

    .table td {
        font-size: 0.9rem;
        vertical-align: middle;
    }
</style>
<?php $__env->stopSection(); ?>

<?php echo $__env->make('layouts.index-superadmin', array_diff_key(get_defined_vars(), ['__data' => 1, '__path' => 1]))->render(); ?><?php /**PATH E:\KULIAH\SEMESTER 4\PA2\ProyekAkhir2\backend\resources\views/super_admin/entrepreneurs/approved.blade.php ENDPATH**/ ?>