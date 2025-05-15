<?php $__env->startSection('content'); ?>
    <div class="container-fluid">
        <div class="row mb-4">
            <div class="col-md-12">
                <div class="d-flex justify-content-between align-items-center">
                    <h2>Detail Properti: <?php echo e($property->name); ?></h2>
                    <div>
                        <a href="<?php echo e(route('admin.properties.edit', $property->id)); ?>" class="btn btn-primary">
                            <i class="fas fa-edit"></i> Edit
                        </a>
                        <a href="<?php echo e(route('admin.properties.index')); ?>" class="btn btn-secondary">
                            <i class="fas fa-arrow-left"></i> Kembali ke Daftar
                        </a>
                    </div>
                </div>
            </div>
        </div>

        <div class="row">
            <div class="col-md-8">
                <!-- Property Image Card -->
                <div class="card shadow mb-4">
                    <div class="card-header py-3 d-flex justify-content-between align-items-center">
                        <h6 class="m-0 font-weight-bold text-primary">Gambar Properti</h6>
                    </div>
                    <div class="card-body">
                        <?php if($property->image): ?>
                            <img src="<?php echo e(asset('storage/' . $property->image)); ?>" alt="<?php echo e($property->name); ?>" class="img-fluid rounded" style="max-height: 300px; width: 100%; object-fit: cover;">
                        <?php else: ?>
                            <div class="text-center p-5 bg-light rounded">
                                <i class="fas fa-home fa-5x text-secondary mb-3"></i>
                                <p class="text-muted">Tidak ada gambar properti</p>
                            </div>
                        <?php endif; ?>
                    </div>
                </div>

                <div class="card shadow mb-4">
                    <div class="card-header py-3">
                        <h6 class="m-0 font-weight-bold text-primary">Informasi Dasar</h6>
                    </div>
                    <div class="card-body">
                        <div class="row">
                            <div class="col-md-6">
                                <h5>Harga</h5>
                                <p><strong>Harga:</strong> Rp <?php echo e(number_format($property->price, 0, ',', '.')); ?></p>
                                <p><strong>Kapasitas:</strong> <?php echo e($property->capacity ?? 'N/A'); ?> orang</p>
                                <p><strong>Kamar Tersedia:</strong> <?php echo e($property->available_rooms ?? 'N/A'); ?></p>
                            </div>
                            <div class="col-md-6">
                                <h5>Status</h5>
                                <span class="badge badge-pill <?php echo e($property->isDeleted ? 'badge-danger' : 'badge-success'); ?> p-2">
                                    <?php echo e($property->isDeleted ? 'Tidak Aktif' : 'Aktif'); ?>

                                </span>
                                <h5 class="mt-3">Deskripsi</h5>
                                <p><?php echo e($property->description); ?></p>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="card shadow mb-4">
                    <div class="card-header py-3">
                        <h6 class="m-0 font-weight-bold text-primary">Informasi Lokasi</h6>
                    </div>
                    <div class="card-body">
                        <div class="row">
                            <div class="col-md-6">
                                <h5>Alamat</h5>
                                <p><?php echo e($property->address); ?></p>
                                <p>
                                    <?php echo e($property->subdistrict->subdis_name ?? 'N/A'); ?>,
                                    <?php echo e($property->district->dis_name ?? 'N/A'); ?><br>
                                    <?php echo e($property->city->city_name ?? 'N/A'); ?>,
                                    <?php echo e($property->province->prov_name ?? 'N/A'); ?>

                                </p>
                            </div>
                            <div class="col-md-6">
                                <h5>Koordinat</h5>
                                <p>
                                    <strong>Latitude:</strong> <?php echo e($property->latitude ?? 'N/A'); ?><br>
                                    <strong>Longitude:</strong> <?php echo e($property->longitude ?? 'N/A'); ?>

                                </p>
                                <?php if($property->latitude && $property->longitude): ?>
                                     <div id="property-map" style="height: 200px; width: 100%;"></div>
                                <?php endif; ?>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="col-md-4">
                <div class="card shadow mb-4">
                    <div class="card-header py-3">
                        <h6 class="m-0 font-weight-bold text-primary">Detail Properti</h6>
                    </div>
                    <div class="card-body">
                        <?php if($property->property_type_id == 1 && $property->kostDetail): ?>
                            <h5>Detail Kost</h5>
                            <div class="table-responsive">
                                <table class="table table-bordered">
                                    <tr>
                                        <th>Tipe Kost</th>
                                        <td><span class="badge badge-info"><?php echo e(ucfirst($property->kostDetail->kost_type)); ?></span></td>
                                    </tr>
                                    <tr>
                                        <th>Total Kamar</th>
                                        <td><?php echo e($property->kostDetail->total_rooms); ?></td>
                                    </tr>
                                    <tr>
                                        <th>Kamar Tersedia</th>
                                        <td><?php echo e($property->kostDetail->available_rooms); ?></td>
                                    </tr>
                                    <tr>
                                        <th>Termasuk Makan</th>
                                        <td><?php echo $property->kostDetail->meal_included ? '<span class="text-success"><i class="fas fa-check"></i> Ya</span>' : '<span class="text-danger"><i class="fas fa-times"></i> Tidak</span>'; ?></td>
                                    </tr>
                                    <tr>
                                        <th>Termasuk Laundry</th>
                                        <td><?php echo $property->kostDetail->laundry_included ? '<span class="text-success"><i class="fas fa-check"></i> Ya</span>' : '<span class="text-danger"><i class="fas fa-times"></i> Tidak</span>'; ?></td>
                                    </tr>
                                </table>
                            </div>
                        <?php elseif($property->property_type_id == 2 && $property->homestayDetail): ?>
                            <h5>Detail Homestay</h5>
                            <div class="table-responsive">
                                <table class="table table-bordered">
                                    <tr>
                                        <th>Total Unit</th>
                                        <td><?php echo e($property->homestayDetail->total_units); ?></td>
                                    </tr>
                                    <tr>
                                        <th>Unit Tersedia</th>
                                        <td><?php echo e($property->homestayDetail->available_units); ?></td>
                                    </tr>
                                    <tr>
                                        <th>Minimum Menginap</th>
                                        <td><?php echo e($property->homestayDetail->minimum_stay); ?> malam</td>
                                    </tr>
                                    <tr>
                                        <th>Maksimum Tamu</th>
                                        <td><?php echo e($property->homestayDetail->maximum_guest); ?> orang</td>
                                    </tr>
                                    <tr>
                                        <th>Waktu Check-in</th>
                                        <td><?php echo e(\Carbon\Carbon::parse($property->homestayDetail->checkin_time)->format('H:i')); ?></td>
                                    </tr>
                                    <tr>
                                        <th>Waktu Check-out</th>
                                        <td><?php echo e(\Carbon\Carbon::parse($property->homestayDetail->checkout_time)->format('H:i')); ?></td>
                                    </tr>
                                </table>
                            </div>
                        <?php endif; ?>

                        <?php if($property->rules): ?>
                            <h5 class="mt-4">Peraturan</h5>
                            <div class="card bg-light">
                                <div class="card-body">
                                    <p class="mb-0"><?php echo e($property->rules); ?></p>
                                </div>
                            </div>
                        <?php endif; ?>
                    </div>
                </div>

                <div class="card shadow">
                    <div class="card-header py-3">
                        <h6 class="m-0 font-weight-bold text-primary">Ketersediaan Kamar</h6>
                    </div>
                    <div class="card-body">
                        <div class="text-center mb-3">
                            <div class="progress-circle" data-percent="<?php echo e($availablePercentage); ?>">
                                <svg class="progress-circle-svg" viewBox="0 0 36 36">
                                    <path class="progress-circle-bg"
                                          d="M18 2.0845
                                            a 15.9155 15.9155 0 0 1 0 31.831
                                            a 15.9155 15.9155 0 0 1 0 -31.831" />
                                    <path class="progress-circle-fill"
                                          stroke-dasharray="<?php echo e($availablePercentage); ?>, 100"
                                          d="M18 2.0845
                                            a 15.9155 15.9155 0 0 1 0 31.831
                                            a 15.9155 15.9155 0 0 1 0 -31.831" />
                                    <text class="progress-circle-text" x="18" y="20.35"><?php echo e(round($availablePercentage)); ?>%</text>
                                </svg>
                            </div>
                            <h5 class="mt-2">Tingkat Ketersediaan</h5>
                        </div>
                        <div class="text-center">
                            <div class="d-flex justify-content-center">
                                <div class="px-3">
                                    <span class="badge badge-success p-2"><?php echo e($availableRooms); ?></span>
                                    <p class="mt-1 mb-0">Tersedia</p>
                                </div>
                                <div class="px-3">
                                    <span class="badge badge-secondary p-2"><?php echo e($totalRooms); ?></span>
                                    <p class="mt-1 mb-0">Total</p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
<?php $__env->stopSection(); ?>

<?php $__env->startPush('styles'); ?>
    <style>
        .progress-circle {
            position: relative;
            display: inline-block;
            width: 120px;
            height: 120px;
        }

        .progress-circle-svg {
            transform: rotate(-90deg);
        }

        .progress-circle-bg {
            fill: none;
            stroke: #eee;
            stroke-width: 3;
        }

        .progress-circle-fill {
            fill: none;
            stroke: #4CAF50;
            stroke-width: 3;
            stroke-linecap: round;
            transition: stroke-dasharray 0.5s ease;
        }

        .progress-circle-text {
            font-size: 0.4em;
            text-anchor: middle;
            fill: #333;
            font-weight: bold;
        }
        #property-map {
            height: 200px;
            width: 100%;
            margin-top: 20px;
            border-radius: 5px;
        }
        .badge-pill {
            font-size: 14px;
        }
        .table th {
            width: 40%;
        }
    </style>
<?php $__env->stopPush(); ?>

<?php $__env->startPush('scripts'); ?>
    <?php if($property->latitude && $property->longitude): ?>
        <script>
            let map;

            function initMap() {
                const propertyLocation = {
                    lat: <?php echo e($property->latitude); ?>,
                    lng: <?php echo e($property->longitude); ?>

                };

                map = new google.maps.Map(document.getElementById("property-map"), {
                    center: propertyLocation,
                    zoom: 15,
                });

                const marker = new google.maps.Marker({
                    position: propertyLocation,
                    map: map,
                    title: "<?php echo e($property->name); ?>",
                });
            }

            window.onload = function() {
                // Check if the map element exists
                if (document.getElementById("property-map")) {
                    initMap();
                }
            };
        </script>
        <script src="https://maps.googleapis.com/maps/api/js?key=<?php echo e(config('services.google.maps_api_key')); ?>&callback=initMap" async defer></script>
    <?php endif; ?>
<?php $__env->stopPush(); ?>
<?php echo $__env->make('layouts.admin', array_diff_key(get_defined_vars(), ['__data' => 1, '__path' => 1]))->render(); ?><?php /**PATH E:\KULIAH\SEMESTER 4\PA2\ProyekAkhir2\backend\resources\views/admin/properties/show.blade.php ENDPATH**/ ?>