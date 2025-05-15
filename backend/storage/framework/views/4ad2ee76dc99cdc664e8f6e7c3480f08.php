

<?php $__env->startSection('title', 'Daftar Pemesanan'); ?>

<?php $__env->startSection('action_button'); ?>
<a href="<?php echo e(route('admin.properties.bookings.statistics')); ?>" class="d-none d-sm-inline-block btn btn-sm btn-primary shadow-sm">
    <i class="fas fa-chart-bar fa-sm text-white-50"></i> Lihat Statistik
</a>
<?php $__env->stopSection(); ?>

<?php $__env->startSection('content'); ?>
<div class="card shadow mb-4">
    <div class="card-header py-3 d-flex flex-row align-items-center justify-content-between">
        <h6 class="m-0 font-weight-bold text-primary">Daftar Pemesanan</h6>
        <div class="dropdown no-arrow">
            <a class="dropdown-toggle" href="#" role="button" id="dropdownMenuLink" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                <i class="fas fa-ellipsis-v fa-sm fa-fw text-gray-400"></i>
            </a>
            <div class="dropdown-menu dropdown-menu-right shadow animated--fade-in" aria-labelledby="dropdownMenuLink">
                <div class="dropdown-header">Filter Status:</div>
                <a class="dropdown-item filter-status" href="#" data-status="all">Semua</a>
                <a class="dropdown-item filter-status" href="#" data-status="pending">Menunggu</a>
                <a class="dropdown-item filter-status" href="#" data-status="confirmed">Dikonfirmasi</a>
                <a class="dropdown-item filter-status" href="#" data-status="completed">Selesai</a>
                <a class="dropdown-item filter-status" href="#" data-status="cancelled">Dibatalkan</a>
            </div>
        </div>
    </div>
    <div class="card-body">
        <div class="table-responsive">
            <div class="mb-3">
                <input type="text" id="searchBooking" class="form-control" placeholder="Cari berdasarkan nama tamu, properti, atau ID...">
            </div>
            <table class="table table-bordered" id="bookingsTable" width="100%" cellspacing="0">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Tamu</th>
                        <th>Properti</th>
                        <th>Check-in</th>
                        <th>Check-out</th>
                        <th>Total</th>
                        <th>Status</th>
                        <th>Aksi</th>
                    </tr>
                </thead>
                <tbody>
                    <?php $__empty_1 = true; $__currentLoopData = $bookings; $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $booking): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); $__empty_1 = false; ?>
                    <tr data-status="<?php echo e($booking->status); ?>">
                        <td><?php echo e($booking->id); ?></td>
                        <td>
                            <strong><?php echo e($booking->guest_name); ?></strong><br>
                            <small><?php echo e($booking->guest_phone); ?></small>
                        </td>
                        <td><?php echo e($booking->property->name); ?></td>
                        <td><?php echo e(\Carbon\Carbon::parse($booking->check_in)->format('d M Y')); ?></td>
                        <td><?php echo e(\Carbon\Carbon::parse($booking->check_out)->format('d M Y')); ?></td>
                        <td><?php echo e('Rp ' . number_format($booking->total_price, 0, ',', '.')); ?></td>
                        <td>
                            <?php if($booking->status == 'pending'): ?>
                                <span class="badge badge-warning">Menunggu</span>
                            <?php elseif($booking->status == 'confirmed'): ?>
                                <span class="badge badge-success">Dikonfirmasi</span>
                            <?php elseif($booking->status == 'completed'): ?>
                                <span class="badge badge-info">Selesai</span>
                            <?php elseif($booking->status == 'cancelled'): ?>
                                <span class="badge badge-danger">Dibatalkan</span>
                            <?php endif; ?>
                        </td>
                        <td>
                            <a href="<?php echo e(route('admin.properties.bookings.show', $booking->id)); ?>" class="btn btn-info btn-sm">
                                <i class="fas fa-eye"></i>
                            </a>
                            <?php if($booking->status == 'pending'): ?>
                            <button type="button" class="btn btn-success btn-sm confirm-booking" data-id="<?php echo e($booking->id); ?>" data-toggle="modal" data-target="#confirmModal">
                                <i class="fas fa-check"></i>
                            </button>
                            <button type="button" class="btn btn-danger btn-sm reject-booking" data-id="<?php echo e($booking->id); ?>" data-toggle="modal" data-target="#rejectModal">
                                <i class="fas fa-times"></i>
                            </button>
                            <?php elseif($booking->status == 'confirmed'): ?>
                            <button type="button" class="btn btn-primary btn-sm complete-booking" data-id="<?php echo e($booking->id); ?>" data-toggle="modal" data-target="#completeModal">
                                <i class="fas fa-check-double"></i>
                            </button>
                            <?php endif; ?>
                        </td>
                    </tr>
                    <?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); if ($__empty_1): ?>
                    <tr>
                        <td colspan="8" class="text-center">Tidak ada data pemesanan</td>
                    </tr>
                    <?php endif; ?>
                </tbody>
            </table>
        </div>
    </div>
</div>

<!-- Confirm Booking Modal -->
<div class="modal fade" id="confirmModal" tabindex="-1" role="dialog" aria-labelledby="confirmModalLabel" aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="confirmModalLabel">Konfirmasi Pemesanan</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                Apakah Anda yakin ingin mengonfirmasi pemesanan ini?
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-dismiss="modal">Batal</button>
                <form id="confirmForm" method="POST" action="">
                    <?php echo csrf_field(); ?>
                    <button type="submit" class="btn btn-success">Konfirmasi</button>
                </form>
            </div>
        </div>
    </div>
</div>

<!-- Reject Booking Modal -->
<div class="modal fade" id="rejectModal" tabindex="-1" role="dialog" aria-labelledby="rejectModalLabel" aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="rejectModalLabel">Tolak Pemesanan</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                Apakah Anda yakin ingin menolak pemesanan ini?
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-dismiss="modal">Batal</button>
                <form id="rejectForm" method="POST" action="">
                    <?php echo csrf_field(); ?>
                    <button type="submit" class="btn btn-danger">Tolak</button>
                </form>
            </div>
        </div>
    </div>
</div>

<!-- Complete Booking Modal -->
<div class="modal fade" id="completeModal" tabindex="-1" role="dialog" aria-labelledby="completeModalLabel" aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="completeModalLabel">Selesaikan Pemesanan</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                Apakah Anda yakin ingin menyelesaikan pemesanan ini?
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-dismiss="modal">Batal</button>
                <form id="completeForm" method="POST" action="">
                    <?php echo csrf_field(); ?>
                    <button type="submit" class="btn btn-primary">Selesaikan</button>
                </form>
            </div>
        </div>
    </div>
</div>
<?php $__env->stopSection(); ?>

<?php $__env->startPush('scripts'); ?>
<script>
    $(document).ready(function() {
        // Set action URL for confirm modal
        $('.confirm-booking').click(function() {
            const id = $(this).data('id');
            $('#confirmForm').attr('action', `<?php echo e(url('admin/properties/bookings')); ?>/${id}/confirm`);
        });

        // Set action URL for reject modal
        $('.reject-booking').click(function() {
            const id = $(this).data('id');
            $('#rejectForm').attr('action', `<?php echo e(url('admin/properties/bookings')); ?>/${id}/reject`);
        });

        // Set action URL for complete modal
        $('.complete-booking').click(function() {
            const id = $(this).data('id');
            $('#completeForm').attr('action', `<?php echo e(url('admin/properties/bookings')); ?>/${id}/complete`);
        });

        // Filter by status
        $('.filter-status').click(function(e) {
            e.preventDefault();
            const status = $(this).data('status');
            
            if (status === 'all') {
                $('#bookingsTable tbody tr').show();
            } else {
                $('#bookingsTable tbody tr').hide();
                $(`#bookingsTable tbody tr[data-status="${status}"]`).show();
            }
        });

        // Search functionality
        $('#searchBooking').on('keyup', function() {
            const value = $(this).val().toLowerCase();
            $('#bookingsTable tbody tr').filter(function() {
                $(this).toggle($(this).text().toLowerCase().indexOf(value) > -1);
            });
        });
    });
</script>
<?php $__env->stopPush(); ?>

<?php echo $__env->make('layouts.admin', array_diff_key(get_defined_vars(), ['__data' => 1, '__path' => 1]))->render(); ?><?php /**PATH E:\KULIAH\SEMESTER 4\PA2\ProyekAkhir2\backend\resources\views/admin/properties/bookings/index.blade.php ENDPATH**/ ?>