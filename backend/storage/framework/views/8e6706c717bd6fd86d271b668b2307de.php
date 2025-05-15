<?php $__env->startSection('content'); ?>
<div class="container-fluid">
    <div class="row mb-4">
        <div class="col-md-12">
            <div class="d-flex justify-content-between align-items-center">
                <h2>Detail Properti: <?php echo e($property->name); ?></h2>
                <div>
                    <a href="<?php echo e(route('super_admin.entrepreneurs.approved')); ?>" class="btn btn-secondary">
                        <i class="fas fa-arrow-left"></i> Kembali ke Daftar
                    </a>
                </div>
            </div>
        </div>
    </div>

    <div class="row">
        <div class="col-md-8">
            <div class="card shadow mb-4">
                <div class="card-header py-3">
                    <h6 class="m-0 font-weight-bold text-primary">Informasi Dasar</h6>
                </div>
                <div class="card-body">
                    <div class="row">
                        <div class="col-md-6">
                            <h5>Harga</h5>
                            <p><strong>Harga:</strong> Rp <?php echo e(number_format($property->price, 0, ',', '.')); ?></p>
                            <p><strong>Kapasitas:</strong> <?php echo e($property->capacity); ?> orang</p>
                            <p><strong>Kamar Tersedia:</strong> <?php echo e($property->available_rooms); ?></p>
                        </div>
                        <div class="col-md-6">
                            <h5>Status</h5>
                            <span class="badge <?php echo e($property->isDeleted ? 'badge-secondary' : 'badge-success'); ?>">
                                <?php echo e($property->isDeleted ? 'Tidak Aktif' : 'Aktif'); ?>

                            </span>
                            <h5 class="mt-3">Lokasi</h5>
                            <p><?php echo e($property->address); ?></p>
                            <p>
                                <?php if($property->subdistrict && $property->district && $property->city && $property->province): ?>
                                    <?php echo e($property->subdistrict->subdis_name); ?>,
                                    <?php echo e($property->district->dis_name); ?>,
                                    <?php echo e($property->city->city_name); ?>,
                                    <?php echo e($property->province->prov_name); ?>

                                <?php else: ?>
                                    -
                                <?php endif; ?>
                            </p>
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
                    <?php if($property->propertyType->name === 'kost' && $property->kostDetail): ?>
                        <h5>Detail Kost</h5>
                        <p><strong>Tipe:</strong> <?php echo e(ucfirst($property->kostDetail->kost_type)); ?></p>
                        <p><strong>Total Kamar:</strong> <?php echo e($property->kostDetail->total_rooms); ?></p>
                        <p><strong>Kamar Tersedia:</strong> <?php echo e($property->kostDetail->available_rooms); ?></p>
                        <p><strong>Termasuk Makan:</strong> <?php echo e($property->kostDetail->meal_included ? 'Ya' : 'Tidak'); ?></p>
                        <p><strong>Termasuk Laundry:</strong> <?php echo e($property->kostDetail->laundry_included ? 'Ya' : 'Tidak'); ?></p>
                    <?php elseif($property->propertyType->name === 'homestay' && $property->homestayDetail): ?>
                        <h5>Detail Homestay</h5>
                        <p><strong>Total Unit:</strong> <?php echo e($property->homestayDetail->total_units); ?></p>
                        <p><strong>Unit Tersedia:</strong> <?php echo e($property->homestayDetail->available_units); ?></p>
                        <p><strong>Minimum Menginap:</strong> <?php echo e($property->homestayDetail->minimum_stay); ?> malam</p>
                        <p><strong>Maksimum Tamu:</strong> <?php echo e($property->homestayDetail->maximum_guest); ?></p>
                        <p><strong>Waktu Check-in:</strong> <?php echo e($property->homestayDetail->checkin_time); ?></p>
                        <p><strong>Waktu Check-out:</strong> <?php echo e($property->homestayDetail->checkout_time); ?></p>
                    <?php endif; ?>

                    <?php if($property->rules): ?>
                        <h5 class="mt-4"> Peraturan</h5>
                        <p><?php echo e($property->rules); ?></p>
                    <?php endif; ?>
                </div>
            </div>

            <div class="card shadow">
                <div class="card-header py-3">
                    <h6 class="m-0 font-weight-bold text-primary">Gambar Properti</h6>
                </div>
                <div class="card-body">
                    <?php if($property->image): ?>
                        <img src="<?php echo e($property->image_url); ?>" alt="Properti Image" class="img-thumbnail" style="width: 100%;">
                    <?php else: ?>
                        <p>Tidak ada gambar yang tersedia</p>
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
                        <p>
                            <span class="badge badge-success"><?php echo e($availableRooms); ?> Tersedia</span> /
                            <span class="badge badge-secondary"><?php echo e($totalRooms); ?> Total</span>
                        </p>
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
        width: 100px;
        height: 100px;
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

<?php echo $__env->make('layouts.index-superadmin', array_diff_key(get_defined_vars(), ['__data' => 1, '__path' => 1]))->render(); ?><?php /**PATH E:\KULIAH\SEMESTER 4\PA2\ProyekAkhir2\backend\resources\views/super_admin/entrepreneurs/properties/details.blade.php ENDPATH**/ ?>