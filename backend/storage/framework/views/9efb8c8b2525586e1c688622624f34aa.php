

<?php $__env->startSection('title', 'Ulasan ' . $property->name); ?>

<?php $__env->startSection('action_button'); ?>
<a href="<?php echo e(route('admin.properties.ulasan.index')); ?>" class="d-none d-sm-inline-block btn btn-sm btn-primary shadow-sm">
    <i class="fas fa-arrow-left fa-sm text-white-50"></i> Kembali ke Daftar
</a>
<?php $__env->stopSection(); ?>

<?php $__env->startSection('content'); ?>
<div class="card shadow mb-4">
    <div class="card-header py-3 d-flex flex-row align-items-center justify-content-between">
        <h6 class="m-0 font-weight-bold text-primary">Informasi Properti</h6>
    </div>
    <div class="card-body">
        <div class="row">
            <div class="col-md-3 text-center">
                <?php if($property->image): ?>
                    <img src="<?php echo e(asset('storage/' . $property->image)); ?>" alt="<?php echo e($property->name); ?>" class="img-fluid rounded mb-3" style="max-height: 150px;">
                <?php else: ?>
                    <div class="bg-gray-200 rounded mb-3 d-flex align-items-center justify-content-center" style="height: 150px;">
                        <i class="fas fa-home fa-3x text-gray-500"></i>
                    </div>
                <?php endif; ?>
            </div>
            <div class="col-md-9">
                <h4 class="font-weight-bold"><?php echo e($property->name); ?></h4>
                <p class="text-muted"><?php echo e($property->address); ?></p>
                
                <div class="row mt-3">
                    <div class="col-md-4">
                        <div class="font-weight-bold mb-1">Tipe Properti</div>
                        <p><?php echo e($property->is_kost ? 'Kost' : 'Homestay'); ?></p>
                    </div>
                    <div class="col-md-4">
                        <div class="font-weight-bold mb-1">Harga</div>
                        <p>Rp <?php echo e(number_format($property->price, 0, ',', '.')); ?> / <?php echo e($property->is_kost ? 'bulan' : 'malam'); ?></p>
                    </div>
                    <div class="col-md-4">
                        <div class="font-weight-bold mb-1">Rating</div>
                        <div class="d-flex align-items-center">
                            <span class="font-weight-bold mr-2"><?php echo e(number_format($reviews->avg('rating'), 1)); ?></span>
                            <div>
                                <?php for($i = 1; $i <= 5; $i++): ?>
                                    <?php if($i <= round($reviews->avg('rating'))): ?>
                                        <i class="fas fa-star text-warning"></i>
                                    <?php else: ?>
                                        <i class="far fa-star text-warning"></i>
                                    <?php endif; ?>
                                <?php endfor; ?>
                            </div>
                            <span class="ml-2 text-muted">(<?php echo e($reviews->total()); ?> ulasan)</span>
                        </div>
                    </div>
                </div>
                
                <div class="mt-3">
                    <a href="<?php echo e(route('admin.properties.show', $property->id)); ?>" class="btn btn-primary">
                        <i class="fas fa-eye"></i> Lihat Properti
                    </a>
                </div>
            </div>
        </div>
    </div>
</div>

<div class="card shadow mb-4">
    <div class="card-header py-3 d-flex flex-row align-items-center justify-content-between">
        <h6 class="m-0 font-weight-bold text-primary">Daftar Ulasan</h6>
    </div>
    <div class="card-body">
        <?php if($reviews->isEmpty()): ?>
            <div class="text-center py-5">
                <i class="fas fa-comment-slash fa-4x text-gray-300 mb-3"></i>
                <p class="text-gray-500">Belum ada ulasan untuk properti ini</p>
            </div>
        <?php else: ?>
            <div class="list-group">
                <?php $__currentLoopData = $reviews; $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $review): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); ?>
                    <div class="list-group-item list-group-item-action flex-column align-items-start mb-3">
                        <div class="d-flex w-100 justify-content-between align-items-center mb-2">
                            <div class="d-flex align-items-center">
                                <?php if($review->booking->user->profile_picture): ?>
                                    <img src="<?php echo e(asset('storage/' . $review->booking->user->profile_picture)); ?>" alt="<?php echo e($review->booking->user->name); ?>" class="img-profile rounded-circle mr-3" style="width: 50px; height: 50px;">
                                <?php else: ?>
                                    <div class="bg-primary rounded-circle mr-3 d-flex align-items-center justify-content-center" style="width: 50px; height: 50px;">
                                        <span class="text-white font-weight-bold" style="font-size: 20px;"><?php echo e(substr($review->booking->user->name, 0, 1)); ?></span>
                                    </div>
                                <?php endif; ?>
                                <div>
                                    <h5 class="mb-0"><?php echo e($review->booking->user->name); ?></h5>
                                    <div class="text-muted"><?php echo e($review->created_at->format('d M Y H:i')); ?></div>
                                </div>
                            </div>
                            <div>
                                <div class="d-flex align-items-center">
                                    <?php for($i = 1; $i <= 5; $i++): ?>
                                        <?php if($i <= $review->rating): ?>
                                            <i class="fas fa-star text-warning"></i>
                                        <?php else: ?>
                                            <i class="far fa-star text-warning"></i>
                                        <?php endif; ?>
                                    <?php endfor; ?>
                                    <span class="ml-2 font-weight-bold"><?php echo e($review->rating); ?>.0</span>
                                </div>
                            </div>
                        </div>
                        
                        <p class="mb-3"><?php echo e($review->comment); ?></p>
                        
                        <div class="mt-3">
                            <a href="<?php echo e(route('admin.properties.ulasan.show', $review->id)); ?>" class="btn btn-sm btn-primary">
                                <i class="fas fa-eye"></i> Lihat Detail
                            </a>
                        </div>
                    </div>
                <?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); ?>
            </div>
            
            <div class="mt-3">
                <?php echo e($reviews->links()); ?>

            </div>
        <?php endif; ?>
    </div>
</div>
<?php $__env->stopSection(); ?>

<?php echo $__env->make('layouts.admin', array_diff_key(get_defined_vars(), ['__data' => 1, '__path' => 1]))->render(); ?><?php /**PATH E:\KULIAH\SEMESTER 4\PA2\ProyekAkhir2\backend\resources\views/admin/ulasan/property.blade.php ENDPATH**/ ?>