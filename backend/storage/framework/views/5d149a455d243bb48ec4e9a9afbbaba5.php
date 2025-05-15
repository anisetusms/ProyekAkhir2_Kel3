<?php $__env->startSection('content'); ?>
<div class="container-fluid">
    <div class="d-sm-flex align-items-center justify-content-between mb-4">
        <h1 class="h3 mb-0 text-gray-800">Daftar Properti</h1>
        <a href="<?php echo e(route('admin.properties.create')); ?>" class="d-none d-sm-inline-block btn btn-sm btn-primary shadow-sm">
            <i class="fas fa-plus fa-sm text-white-50"></i> Tambah Properti
        </a>
    </div>

    <?php if(session('success')): ?>
    <div class="alert alert-success">
        <?php echo e(session('success')); ?>

    </div>
    <?php endif; ?>

    
    <div class="card shadow mb-4">
        <div class="card-header py-3">
            <h6 class="m-0 font-weight-bold text-primary">Properti Aktif</h6>
        </div>
        <div class="card-body">
            <div class="table-responsive">
                <table class="table table-bordered" id="activeDataTable" width="100%" cellspacing="0">
                    <thead>
                        <tr>
                            <th>No</th>
                            <th>Nama</th>
                            <th>Tipe</th>
                            <th>Tipe Kost</th>
                            <th>Lokasi</th>
                            <th>Harga</th>
                            <th>Status</th>
                            <th>Aksi</th>
                        </tr>
                    </thead>
                    <tbody>
                        <?php $__empty_1 = true; $__currentLoopData = $activeProperties; $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $property): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); $__empty_1 = false; ?>
                        <tr>
                            <td><?php echo e($loop->iteration); ?></td>
                            <td><?php echo e($property->name); ?></td>
                            <td>
                                <?php
                                $propertyTypes = [1 => 'Kost', 2 => 'Homestay'];
                                $propertyType = $propertyTypes[$property->property_type_id] ?? 'Lainnya';
                                ?>
                                <span class="badge badge-<?php echo e($property->property_type_id == 1 ? 'info' : 'success'); ?>">
                                    <?php echo e($propertyType); ?>

                                </span>
                            </td>
                            <td>
                                <?php if($property->property_type_id == 1 && $property->kostDetail): ?>
                                <?php echo e($property->kostDetail->kost_type); ?>

                                <?php else: ?>
                                -
                                <?php endif; ?>
                            </td>
                            <td>
                                <?php if($property->subdistrict && $property->district && $property->city && $property->province): ?>
                                <?php echo e($property->subdistrict->subdis_name); ?>,
                                <?php echo e($property->district->dis_name); ?>,
                                <?php echo e($property->city->city_name); ?>,
                                <?php echo e($property->province->prov_name); ?>

                                <small class="d-block text-muted"><?php echo e($property->address); ?></small>
                                <?php else: ?>
                                -
                                <?php endif; ?>
                            </td>
                            <td>Rp <?php echo e(number_format($property->price, 0, ',', '.')); ?></td>
                            <td><span class="badge badge-success">Aktif</span></td>
                            <td>
                                <div class="d-flex gap-2">
                                    <a href="<?php echo e(route('admin.properties.rooms.index', $property->id)); ?>" class="btn btn-sm btn-outline-info" data-bs-toggle="tooltip" title="Kelola Kamar">
                                        <i class="fas fa-door-open"></i>
                                    </a>
                                    <a href="<?php echo e(route('admin.properties.show', $property->id)); ?>" class="btn btn-sm btn-outline-primary" title="Lihat">
                                        <i class="fas fa-eye"></i>
                                    </a>
                                    <a href="<?php echo e(route('admin.properties.edit', $property->id)); ?>" class="btn btn-sm btn-outline-warning" title="Edit">
                                        <i class="fas fa-edit"></i>
                                    </a>
                                    <form action="<?php echo e(route('admin.properties.destroy', $property->id)); ?>" method="POST" class="d-inline" onsubmit="return confirm('Yakin ingin menonaktifkan properti ini?')">
                                        <?php echo csrf_field(); ?>
                                        <?php echo method_field('DELETE'); ?>
                                        <button type="submit" class="btn btn-sm btn-outline-danger" title="Non-aktifkan">
                                            <i class="fas fa-power-off"></i>
                                        </button>
                                    </form>
                                </div>
                            </td>
                        </tr>
                        <?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); if ($__empty_1): ?>
                        <tr>
                            <td colspan="8" class="text-center">Tidak ada properti aktif.</td>
                        </tr>
                        <?php endif; ?>
                    </tbody>
                </table>
            </div>
            <?php if($activeProperties->count()): ?>
            <div class="d-flex justify-content-center mt-3">
                <?php echo e($activeProperties->links('pagination::bootstrap-4')); ?>

            </div>
            <?php endif; ?>
        </div>
    </div>

    
    <div class="card shadow mb-4">
        <div class="card-header py-3">
            <h6 class="m-0 font-weight-bold text-danger">Properti Nonaktif</h6>
        </div>
        <div class="card-body">
            <div class="table-responsive">
                <table class="table table-bordered" id="inactiveDataTable" width="100%" cellspacing="0">
                    <thead>
                        <tr>
                            <th>No</th>
                            <th>Nama</th>
                            <th>Tipe</th>
                            <th>Tipe Kost</th>
                            <th>Lokasi</th>
                            <th>Harga</th>
                            <th>Status</th>
                            <th>Aksi</th>
                        </tr>
                    </thead>
                    <tbody>
                        <?php $__empty_1 = true; $__currentLoopData = $inactiveProperties; $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $property): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); $__empty_1 = false; ?>
                        <tr>
                            <td><?php echo e($loop->iteration); ?></td>
                            <td><?php echo e($property->name); ?></td>
                            <td>
                                <?php
                                $propertyTypes = [1 => 'Kost', 2 => 'Homestay'];
                                $propertyType = $propertyTypes[$property->property_type_id] ?? 'Lainnya';
                                ?>
                                <span class="badge badge-<?php echo e($property->property_type_id == 1 ? 'info' : 'success'); ?>">
                                    <?php echo e($propertyType); ?>

                                </span>
                            </td>
                            <td>
                                <?php if($property->property_type_id == 1 && $property->kostDetail): ?>
                                <?php echo e($property->kostDetail->kost_type); ?>

                                <?php else: ?>
                                -
                                <?php endif; ?>
                            </td>
                            <td>
                                <?php if($property->subdistrict && $property->district && $property->city && $property->province): ?>
                                <?php echo e($property->subdistrict->subdis_name); ?>,
                                <?php echo e($property->district->dis_name); ?>,
                                <?php echo e($property->city->city_name); ?>,
                                <?php echo e($property->province->prov_name); ?>

                                <small class="d-block text-muted"><?php echo e($property->address); ?></small>
                                <?php else: ?>
                                -
                                <?php endif; ?>
                            </td>
                            <td>Rp <?php echo e(number_format($property->price, 0, ',', '.')); ?></td>
                            <td><span class="badge badge-danger">Nonaktif</span></td>
                            <td>
                                <a href="<?php echo e(route('admin.properties.show', $property->id)); ?>" class="btn btn-sm btn-outline-primary" title="Lihat">
                                    <i class="fas fa-eye"></i>
                                </a>
                                <a href="<?php echo e(route('admin.properties.edit', $property->id)); ?>" class="btn btn-sm btn-outline-warning" title="Edit">
                                    <i class="fas fa-edit"></i>
                                </a>
                                <form action="<?php echo e(route('admin.properties.reactivate', $property->id)); ?>" method="POST" class="d-inline" onsubmit="return confirm('Yakin ingin mengaktifkan kembali properti ini?')">
                                    <?php echo csrf_field(); ?>
                                    <?php echo method_field('PUT'); ?>
                                    <button type="submit" class="btn btn-sm btn-outline-success" title="Aktifkan Kembali">
                                        <i class="fas fa-toggle-on"></i>
                                    </button>
                                </form>
                            </td>
                        </tr>
                        <?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); if ($__empty_1): ?>
                        <tr>
                            <td colspan="8" class="text-center">Tidak ada properti nonaktif.</td>
                        </tr>
                        <?php endif; ?>
                    </tbody>
                </table>
            </div>
            <?php if($inactiveProperties->count()): ?>
            <div class="d-flex justify-content-center mt-3">
                <?php echo e($inactiveProperties->appends(request()->except('page_active'))->links('pagination::bootstrap-4')); ?>

            </div>
            <?php endif; ?>
        </div>
    </div>
</div>
<?php $__env->stopSection(); ?>

<?php $__env->startSection('scripts'); ?>
<script src="<?php echo e(asset('vendor/datatables/jquery.dataTables.min.js')); ?>"></script>
<script src="<?php echo e(asset('vendor/datatables/dataTables.bootstrap4.min.js')); ?>"></script>
<script>
    $(document).ready(function() {
        $('#activeDataTable, #inactiveDataTable').DataTable({
            language: {
                url: "//cdn.datatables.net/plug-ins/1.10.20/i18n/Indonesian.json"
            },
            responsive: true,
            dom: '<"top"f>rt<"bottom"lip><"clear">',
            pageLength: 10,
            order: [
                [0, 'asc']
            ]
        });

        // Tooltip bootstrap
        var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'))
        tooltipTriggerList.map(function(tooltipTriggerEl) {
            return new bootstrap.Tooltip(tooltipTriggerEl)
        });
    });
</script>
<?php $__env->stopSection(); ?>
<?php echo $__env->make('layouts.admin', array_diff_key(get_defined_vars(), ['__data' => 1, '__path' => 1]))->render(); ?><?php /**PATH E:\KULIAH\SEMESTER 4\PA2\ProyekAkhir2\backend\resources\views/admin/properties/index.blade.php ENDPATH**/ ?>