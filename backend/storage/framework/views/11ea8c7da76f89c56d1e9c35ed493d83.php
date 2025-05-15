

<?php $__env->startSection('title', 'Detail Pemesanan #' . $booking->id); ?>

<?php $__env->startSection('action_button'); ?>
<a href="<?php echo e(route('admin.properties.bookings.index')); ?>" class="d-none d-sm-inline-block btn btn-sm btn-secondary shadow-sm">
    <i class="fas fa-arrow-left fa-sm text-white-50"></i> Kembali
</a>
<?php $__env->stopSection(); ?>

<?php $__env->startSection('content'); ?>
<div class="row">
    <div class="col-lg-8">
        <!-- Booking Details Card -->
        <div class="card shadow mb-4">
            <div class="card-header py-3 d-flex flex-row align-items-center justify-content-between">
                <h6 class="m-0 font-weight-bold text-primary">Detail Pemesanan</h6>
                <div>
                    <?php if($booking->status == 'pending'): ?>
                        <span class="badge badge-warning">Menunggu</span>
                    <?php elseif($booking->status == 'confirmed'): ?>
                        <span class="badge badge-success">Dikonfirmasi</span>
                    <?php elseif($booking->status == 'completed'): ?>
                        <span class="badge badge-info">Selesai</span>
                    <?php elseif($booking->status == 'cancelled'): ?>
                        <span class="badge badge-danger">Dibatalkan</span>
                    <?php endif; ?>
                </div>
            </div>
            <div class="card-body">
                <div class="row mb-4">
                    <div class="col-md-6">
                        <h5 class="font-weight-bold">Informasi Pemesanan</h5>
                        <p>
                            <strong>ID Pemesanan:</strong> #<?php echo e($booking->id); ?><br>
                            <strong>Tanggal Pemesanan:</strong> <?php echo e(\Carbon\Carbon::parse($booking->created_at)->format('d M Y, H:i')); ?><br>
                            <strong>Status:</strong> 
                            <?php if($booking->status == 'pending'): ?>
                                <span class="badge badge-warning">Menunggu</span>
                            <?php elseif($booking->status == 'confirmed'): ?>
                                <span class="badge badge-success">Dikonfirmasi</span>
                            <?php elseif($booking->status == 'completed'): ?>
                                <span class="badge badge-info">Selesai</span>
                            <?php elseif($booking->status == 'cancelled'): ?>
                                <span class="badge badge-danger">Dibatalkan</span>
                            <?php endif; ?>
                        </p>
                    </div>
                    <div class="col-md-6">
                        <h5 class="font-weight-bold">Informasi Properti</h5>
                        <p>
                            <strong>Nama Properti:</strong> <?php echo e($booking->property->name); ?><br>
                            <strong>Alamat:</strong> <?php echo e($booking->property->address); ?><br>
                            <strong>Tipe Properti:</strong> <?php echo e($booking->property->propertyType->name ?? 'Tidak tersedia'); ?>

                        </p>
                    </div>
                </div>

                <div class="row mb-4">
                    <div class="col-md-6">
                        <h5 class="font-weight-bold">Informasi Tamu</h5>
                        <p>
                            <strong>Nama:</strong> <?php echo e($booking->guest_name); ?><br>
                            <strong>Telepon:</strong> <?php echo e($booking->guest_phone); ?><br>
                            <strong>No. KTP:</strong> <?php echo e($booking->identity_number ?? 'Tidak tersedia'); ?>

                        </p>
                    </div>
                    <div class="col-md-6">
                        <h5 class="font-weight-bold">Informasi Tanggal</h5>
                        <p>
                            <strong>Check-in:</strong> <?php echo e(\Carbon\Carbon::parse($booking->check_in)->format('d M Y')); ?><br>
                            <strong>Check-out:</strong> <?php echo e(\Carbon\Carbon::parse($booking->check_out)->format('d M Y')); ?><br>
                            <strong>Durasi:</strong> <?php echo e(\Carbon\Carbon::parse($booking->check_in)->diffInDays(\Carbon\Carbon::parse($booking->check_out))); ?> hari
                        </p>
                    </div>
                </div>

                <?php if($booking->rooms->isNotEmpty()): ?>
                <div class="mb-4">
                    <h5 class="font-weight-bold">Kamar yang Dipesan</h5>
                    <div class="table-responsive">
                        <table class="table table-bordered">
                            <thead>
                                <tr>
                                    <th>No. Kamar</th>
                                    <th>Tipe Kamar</th>
                                    <th>Harga</th>
                                </tr>
                            </thead>
                            <tbody>
                                <?php $__currentLoopData = $booking->rooms; $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $room): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); ?>
                                <tr>
                                    <td><?php echo e($room->room_number); ?></td>
                                    <td><?php echo e($room->room_type); ?></td>
                                    <td><?php echo e('Rp ' . number_format($room->pivot->price, 0, ',', '.')); ?></td>
                                </tr>
                                <?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); ?>
                            </tbody>
                        </table>
                    </div>
                </div>
                <?php endif; ?>

                <?php if($booking->special_requests): ?>
                <div class="mb-4">
                    <h5 class="font-weight-bold">Permintaan Khusus</h5>
                    <div class="card bg-light">
                        <div class="card-body">
                            <?php echo e($booking->special_requests); ?>

                        </div>
                    </div>
                </div>
                <?php endif; ?>

                <div class="row">
                    <div class="col-md-6">
                        <h5 class="font-weight-bold">Informasi Pembayaran</h5>
                        <p>
                            <strong>Total Harga:</strong> <?php echo e('Rp ' . number_format($booking->total_price, 0, ',', '.')); ?><br>
                            <strong>Status Pembayaran:</strong> 
                            <?php if($booking->payment_proof): ?>
                                <span class="badge badge-success">Bukti Pembayaran Diunggah</span>
                            <?php else: ?>
                                <span class="badge badge-warning">Menunggu Pembayaran</span>
                            <?php endif; ?>
                        </p>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="col-lg-4">
        <!-- Action Card -->
        <div class="card shadow mb-4">
            <div class="card-header py-3">
                <h6 class="m-0 font-weight-bold text-primary">Tindakan</h6>
            </div>
            <div class="card-body">
                <?php if($booking->status == 'pending'): ?>
                <div class="mb-3">
                    <button type="button" class="btn btn-success btn-block" data-toggle="modal" data-target="#confirmBookingModal">
                        <i class="fas fa-check mr-1"></i> Konfirmasi Pemesanan
                    </button>
                </div>
                <div class="mb-3">
                    <button type="button" class="btn btn-danger btn-block" data-toggle="modal" data-target="#rejectBookingModal">
                        <i class="fas fa-times mr-1"></i> Tolak Pemesanan
                    </button>
                </div>
                <?php elseif($booking->status == 'confirmed'): ?>
                <div class="mb-3">
                    <button type="button" class="btn btn-primary btn-block" data-toggle="modal" data-target="#completeBookingModal">
                        <i class="fas fa-check-double mr-1"></i> Selesaikan Pemesanan
                    </button>
                </div>
                <?php endif; ?>
                <div>
                    <a href="<?php echo e(route('admin.properties.bookings.index')); ?>" class="btn btn-secondary btn-block">
                        <i class="fas fa-arrow-left mr-1"></i> Kembali ke Daftar
                    </a>
                </div>
            </div>
        </div>

        <!-- KTP Image Card -->
        <?php if($booking->ktp_image): ?>
        <div class="card shadow mb-4">
            <div class="card-header py-3">
                <h6 class="m-0 font-weight-bold text-primary">Foto KTP</h6>
            </div>
            <div class="card-body">
                <img src="<?php echo e(asset('storage/' . $booking->ktp_image)); ?>" class="img-fluid" alt="KTP">
            </div>
        </div>
        <?php endif; ?>

        <!-- Payment Proof Card -->
        <?php if($booking->payment_proof): ?>
        <div class="card shadow mb-4">
            <div class="card-header py-3">
                <h6 class="m-0 font-weight-bold text-primary">Bukti Pembayaran</h6>
            </div>
            <div class="card-body">
                <img src="<?php echo e(asset('storage/' . $booking->payment_proof)); ?>" class="img-fluid" alt="Bukti Pembayaran">
            </div>
        </div>
        <?php endif; ?>
    </div>
</div>

<!-- Confirm Booking Modal -->
<div class="modal fade" id="confirmBookingModal" tabindex="-1" role="dialog" aria-labelledby="confirmBookingModalLabel" aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="confirmBookingModalLabel">Konfirmasi Pemesanan</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                Apakah Anda yakin ingin mengonfirmasi pemesanan ini?
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-dismiss="modal">Batal</button>
                <form action="<?php echo e(route('admin.properties.bookings.confirm', $booking->id)); ?>" method="POST">
                    <?php echo csrf_field(); ?>
                    <button type="submit" class="btn btn-success">Konfirmasi</button>
                </form>
            </div>
        </div>
    </div>
</div>

<!-- Reject Booking Modal -->
<div class="modal fade" id="rejectBookingModal" tabindex="-1" role="dialog" aria-labelledby="rejectBookingModalLabel" aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="rejectBookingModalLabel">Tolak Pemesanan</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                Apakah Anda yakin ingin menolak pemesanan ini?
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-dismiss="modal">Batal</button>
                <form action="<?php echo e(route('admin.properties.bookings.reject', $booking->id)); ?>" method="POST">
                    <?php echo csrf_field(); ?>
                    <button type="submit" class="btn btn-danger">Tolak</button>
                </form>
            </div>
        </div>
    </div>
</div>

<!-- Complete Booking Modal -->
<div class="modal fade" id="completeBookingModal" tabindex="-1" role="dialog" aria-labelledby="completeBookingModalLabel" aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="completeBookingModalLabel">Selesaikan Pemesanan</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                Apakah Anda yakin ingin menyelesaikan pemesanan ini?
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-dismiss="modal">Batal</button>
                <form action="<?php echo e(route('admin.properties.bookings.complete', $booking->id)); ?>" method="POST">
                    <?php echo csrf_field(); ?>
                    <button type="submit" class="btn btn-primary">Selesaikan</button>
                </form>
            </div>
        </div>
    </div>
</div>
<?php $__env->stopSection(); ?>

<?php echo $__env->make('layouts.admin', array_diff_key(get_defined_vars(), ['__data' => 1, '__path' => 1]))->render(); ?><?php /**PATH E:\KULIAH\SEMESTER 4\PA2\ProyekAkhir2\backend\resources\views/admin/properties/bookings/show.blade.php ENDPATH**/ ?>