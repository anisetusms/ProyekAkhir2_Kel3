<?php $__env->startSection('title' , 'Dashboard'); ?>

<?php $__env->startSection('content'); ?>
<main class="p-4" style="background-color: #f5f5f5;">
  <div class="container-fluid">
    <p class="text-sm text-muted">Today is <?php echo e(\Carbon\Carbon::now()->format('l, M. d, Y')); ?></p>
    <h2 class="fw-bold">Welcome, <?php echo e(Auth::user()->name); ?>!</h2>
 

    <div class="row mb-4">
      <div class="col-md-4 mb-3">
        <div class="card text-white text-center shadow-sm py-3" style="background-color: #3f51b5;">
          <h4 class="fw-bold"><?php echo e($bookings->count()); ?></h4>
          <p class="mb-0">Pemesanan</p>
        </div>
      </div>
      <div class="col-md-4 mb-3">
        <div class="card text-white text-center shadow-sm py-3" style="background-color: #4caf50;">
          <h4 class="fw-bold"><?php echo e($totalProperties); ?></h4>
          <p class="mb-0">Total Property</p>
        </div>
      </div>
      <div class="col-md-4 mb-3">
        <div class="card text-white text-center shadow-sm py-3" style="background-color: #ffc107;">
          <h4 class="fw-bold"><?php echo e($totalBookings); ?></h4>
          <p class="mb-0">Total Booking</p>
        </div>
      </div>
    </div>

    <div class="card shadow-sm">
      <div class="card-body">
        <h5 class="card-title mb-3">Booking</h5>
        <div class="table-responsive">
          <table class="table table-bordered table-hover align-middle">
            <thead class="table-light">
              <tr>
                <th>BookingID</th>
                <th>Nama</th>
                <th>NIK</th>
                <th>Kontak</th>
                <th>Check-In</th>
                <th>Check-Out</th>
                <th>Status</th>
                <th>Properti</th>
              </tr>
            </thead>
            <tbody>
              <?php $__currentLoopData = $bookings; $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $b): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); ?>
              <tr>
                <td><?php echo e($b->id); ?></td>
                <td><?php echo e($b->user->name ?? '-'); ?></td>
                <td><?php echo e($b->user->nik ?? '-'); ?></td>
                <td><?php echo e($b->user->phone ?? '-'); ?></td>
                <td><?php echo e($b->check_in); ?></td>
                <td><?php echo e($b->check_out); ?></td>
                <td><?php echo e(ucfirst($b->status)); ?></td>
                <td><?php echo e($b->property->name ?? '-'); ?></td>
                </td>
              </tr>
              <?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); ?>
            </tbody>
          </table>
        </div>
      </div>
    </div>
  </div>
</main>
<?php $__env->stopSection(); ?>

<?php echo $__env->make('layouts.index-superadmin', array_diff_key(get_defined_vars(), ['__data' => 1, '__path' => 1]))->render(); ?><?php /**PATH E:\KULIAH\SEMESTER 4\PA2\ProyekAkhir2\backend\resources\views/super_admin/dashboard.blade.php ENDPATH**/ ?>