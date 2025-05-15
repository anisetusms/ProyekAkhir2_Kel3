<?php $__env->startSection('content'); ?>
<div class="container">
    <h2>Edit Ruangan</h2>
    <form action="<?php echo e(route('admin.properties.rooms.update', [$property->id, $room->id])); ?>" method="POST" enctype="multipart/form-data">
        <?php echo csrf_field(); ?>
        <?php echo method_field('PUT'); ?>
        <div class="row">
            <div class="col-md-8">
                <!-- Informasi Dasar Kamar -->
                <div class="card mb-4">
                    <div class="card-header">Informasi Dasar</div>
                    <div class="card-body">
                        <div class="mb-3">
                            <label for="room_type" class="form-label">Jenis Ruangan</label>
                            <input type="text" class="form-control <?php $__errorArgs = ['room_type'];
$__bag = $errors->getBag($__errorArgs[1] ?? 'default');
if ($__bag->has($__errorArgs[0])) :
if (isset($message)) { $__messageOriginal = $message; }
$message = $__bag->first($__errorArgs[0]); ?> is-invalid <?php unset($message);
if (isset($__messageOriginal)) { $message = $__messageOriginal; }
endif;
unset($__errorArgs, $__bag); ?>"
                                id="room_type" name="room_type" value="<?php echo e(old('room_type', $room->room_type)); ?>" required>
                            <?php $__errorArgs = ['room_type'];
$__bag = $errors->getBag($__errorArgs[1] ?? 'default');
if ($__bag->has($__errorArgs[0])) :
if (isset($message)) { $__messageOriginal = $message; }
$message = $__bag->first($__errorArgs[0]); ?>
                            <div class="invalid-feedback"><?php echo e($message); ?></div>
                            <?php unset($message);
if (isset($__messageOriginal)) { $message = $__messageOriginal; }
endif;
unset($__errorArgs, $__bag); ?>
                        </div>

                        <div class="mb-3">
                            <label for="room_number" class="form-label">Nomor Ruangan</label>
                            <input type="text" class="form-control <?php $__errorArgs = ['room_number'];
$__bag = $errors->getBag($__errorArgs[1] ?? 'default');
if ($__bag->has($__errorArgs[0])) :
if (isset($message)) { $__messageOriginal = $message; }
$message = $__bag->first($__errorArgs[0]); ?> is-invalid <?php unset($message);
if (isset($__messageOriginal)) { $message = $__messageOriginal; }
endif;
unset($__errorArgs, $__bag); ?>"
                                id="room_number" name="room_number" value="<?php echo e(old('room_number', $room->room_number)); ?>" required>
                            <?php $__errorArgs = ['room_number'];
$__bag = $errors->getBag($__errorArgs[1] ?? 'default');
if ($__bag->has($__errorArgs[0])) :
if (isset($message)) { $__messageOriginal = $message; }
$message = $__bag->first($__errorArgs[0]); ?>
                            <div class="invalid-feedback"><?php echo e($message); ?></div>
                            <?php unset($message);
if (isset($__messageOriginal)) { $message = $__messageOriginal; }
endif;
unset($__errorArgs, $__bag); ?>
                        </div>

                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label for="price" class="form-label">Harga per Bulan</label>
                                <div class="input-group">
                                    <span class="input-group-text">Rp</span>
                                    <input type="number" class="form-control <?php $__errorArgs = ['price'];
$__bag = $errors->getBag($__errorArgs[1] ?? 'default');
if ($__bag->has($__errorArgs[0])) :
if (isset($message)) { $__messageOriginal = $message; }
$message = $__bag->first($__errorArgs[0]); ?> is-invalid <?php unset($message);
if (isset($__messageOriginal)) { $message = $__messageOriginal; }
endif;
unset($__errorArgs, $__bag); ?>"
                                        id="price" name="price" value="<?php echo e(old('price', $room->price)); ?>" required>
                                </div>
                                <?php $__errorArgs = ['price'];
$__bag = $errors->getBag($__errorArgs[1] ?? 'default');
if ($__bag->has($__errorArgs[0])) :
if (isset($message)) { $__messageOriginal = $message; }
$message = $__bag->first($__errorArgs[0]); ?>
                                <div class="invalid-feedback"><?php echo e($message); ?></div>
                                <?php unset($message);
if (isset($__messageOriginal)) { $message = $__messageOriginal; }
endif;
unset($__errorArgs, $__bag); ?>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label for="size" class="form-label">Ukuran (m²)</label>
                                <input type="text" class="form-control <?php $__errorArgs = ['size'];
$__bag = $errors->getBag($__errorArgs[1] ?? 'default');
if ($__bag->has($__errorArgs[0])) :
if (isset($message)) { $__messageOriginal = $message; }
$message = $__bag->first($__errorArgs[0]); ?> is-invalid <?php unset($message);
if (isset($__messageOriginal)) { $message = $__messageOriginal; }
endif;
unset($__errorArgs, $__bag); ?>"
                                    id="size" name="size" value="<?php echo e(old('size', $room->size)); ?>">
                                <?php $__errorArgs = ['size'];
$__bag = $errors->getBag($__errorArgs[1] ?? 'default');
if ($__bag->has($__errorArgs[0])) :
if (isset($message)) { $__messageOriginal = $message; }
$message = $__bag->first($__errorArgs[0]); ?>
                                <div class="invalid-feedback"><?php echo e($message); ?></div>
                                <?php unset($message);
if (isset($__messageOriginal)) { $message = $__messageOriginal; }
endif;
unset($__errorArgs, $__bag); ?>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label for="capacity" class="form-label">Kapasitas</label>
                                <input type="number" class="form-control <?php $__errorArgs = ['capacity'];
$__bag = $errors->getBag($__errorArgs[1] ?? 'default');
if ($__bag->has($__errorArgs[0])) :
if (isset($message)) { $__messageOriginal = $message; }
$message = $__bag->first($__errorArgs[0]); ?> is-invalid <?php unset($message);
if (isset($__messageOriginal)) { $message = $__messageOriginal; }
endif;
unset($__errorArgs, $__bag); ?>"
                                    id="capacity" name="capacity" value="<?php echo e(old('capacity', $room->capacity)); ?>" min="1" required>
                                <?php $__errorArgs = ['capacity'];
$__bag = $errors->getBag($__errorArgs[1] ?? 'default');
if ($__bag->has($__errorArgs[0])) :
if (isset($message)) { $__messageOriginal = $message; }
$message = $__bag->first($__errorArgs[0]); ?>
                                <div class="invalid-feedback"><?php echo e($message); ?></div>
                                <?php unset($message);
if (isset($__messageOriginal)) { $message = $__messageOriginal; }
endif;
unset($__errorArgs, $__bag); ?>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label for="is_available" class="form-label">Ketersediaan</label>
                                <select class="form-select <?php $__errorArgs = ['is_available'];
$__bag = $errors->getBag($__errorArgs[1] ?? 'default');
if ($__bag->has($__errorArgs[0])) :
if (isset($message)) { $__messageOriginal = $message; }
$message = $__bag->first($__errorArgs[0]); ?> is-invalid <?php unset($message);
if (isset($__messageOriginal)) { $message = $__messageOriginal; }
endif;
unset($__errorArgs, $__bag); ?>"
                                    id="is_available" name="is_available" required>
                                    <option value="1" <?php echo e(old('is_available', $room->is_available) == '1' ? 'selected' : ''); ?>>Tersedia</option>
                                    <option value="0" <?php echo e(old('is_available', $room->is_available) == '0' ? 'selected' : ''); ?>>Tidak Tersedia</option>
                                </select>
                                <?php $__errorArgs = ['is_available'];
$__bag = $errors->getBag($__errorArgs[1] ?? 'default');
if ($__bag->has($__errorArgs[0])) :
if (isset($message)) { $__messageOriginal = $message; }
$message = $__bag->first($__errorArgs[0]); ?>
                                <div class="invalid-feedback"><?php echo e($message); ?></div>
                                <?php unset($message);
if (isset($__messageOriginal)) { $message = $__messageOriginal; }
endif;
unset($__errorArgs, $__bag); ?>
                            </div>
                        </div>

                        <div class="mb-3">
                            <label for="description" class="form-label">Deskripsi</label>
                            <textarea class="form-control <?php $__errorArgs = ['description'];
$__bag = $errors->getBag($__errorArgs[1] ?? 'default');
if ($__bag->has($__errorArgs[0])) :
if (isset($message)) { $__messageOriginal = $message; }
$message = $__bag->first($__errorArgs[0]); ?> is-invalid <?php unset($message);
if (isset($__messageOriginal)) { $message = $__messageOriginal; }
endif;
unset($__errorArgs, $__bag); ?>"
                                id="description" name="description" rows="3"><?php echo e(old('description', $room->description)); ?></textarea>
                            <?php $__errorArgs = ['description'];
$__bag = $errors->getBag($__errorArgs[1] ?? 'default');
if ($__bag->has($__errorArgs[0])) :
if (isset($message)) { $__messageOriginal = $message; }
$message = $__bag->first($__errorArgs[0]); ?>
                            <div class="invalid-feedback"><?php echo e($message); ?></div>
                            <?php unset($message);
if (isset($__messageOriginal)) { $message = $__messageOriginal; }
endif;
unset($__errorArgs, $__bag); ?>
                        </div>
                    </div>
                </div>

                <!-- Fasilitas Kamar -->
                <div class="card mb-4">
                    <div class="card-header">Fasilitas Kamar</div>
                    <div class="card-body">
                        <div id="facilities-container">
                            <?php
                            $oldFacilities = old('facilities', $room->facilities->pluck('facility_name')->toArray());
                            ?>

                            <?php if(count($oldFacilities) > 0): ?>
                            <?php $__currentLoopData = $oldFacilities; $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $index => $facility): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); ?>
                            <div class="input-group mb-2">
                                <input type="text" class="form-control <?php $__errorArgs = ['facilities.'.$index.'.facility_name'];
$__bag = $errors->getBag($__errorArgs[1] ?? 'default');
if ($__bag->has($__errorArgs[0])) :
if (isset($message)) { $__messageOriginal = $message; }
$message = $__bag->first($__errorArgs[0]); ?> is-invalid <?php unset($message);
if (isset($__messageOriginal)) { $message = $__messageOriginal; }
endif;
unset($__errorArgs, $__bag); ?>"
                                    name="facilities[<?php echo e($index); ?>][facility_name]"
                                    value="<?php echo e($facility); ?>" required>
                                <?php if($loop->first): ?>
                                <button type="button" class="btn btn-outline-secondary add-facility">Tambah</button>
                                <?php else: ?>
                                <button type="button" class="btn btn-outline-danger remove-facility">Hapus</button>
                                <?php endif; ?>
                                <?php $__errorArgs = ['facilities.'.$index.'.facility_name'];
$__bag = $errors->getBag($__errorArgs[1] ?? 'default');
if ($__bag->has($__errorArgs[0])) :
if (isset($message)) { $__messageOriginal = $message; }
$message = $__bag->first($__errorArgs[0]); ?>
                                <div class="invalid-feedback"><?php echo e($message); ?></div>
                                <?php unset($message);
if (isset($__messageOriginal)) { $message = $__messageOriginal; }
endif;
unset($__errorArgs, $__bag); ?>
                            </div>
                            <?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); ?>
                            <?php else: ?>
                            <div class="input-group mb-2">
                                <input type="text" class="form-control" name="facilities[0][facility_name]" required>
                                <button type="button" class="btn btn-outline-secondary add-facility">Tambah</button>
                            </div>
                            <?php endif; ?>
                        </div>
                        <?php $__errorArgs = ['facilities'];
$__bag = $errors->getBag($__errorArgs[1] ?? 'default');
if ($__bag->has($__errorArgs[0])) :
if (isset($message)) { $__messageOriginal = $message; }
$message = $__bag->first($__errorArgs[0]); ?>
                        <div class="text-danger"><?php echo e($message); ?></div>
                        <?php unset($message);
if (isset($__messageOriginal)) { $message = $__messageOriginal; }
endif;
unset($__errorArgs, $__bag); ?>
                    </div>
                </div>
            </div>

            <div class="col-md-4">
                <!-- Gambar Kamar -->
                <div class="card mb-4">
                    <div class="card-header">Gambar Kamar</div>
                    <div class="card-body">
                        <!-- Gambar Utama -->
                        <div class="mb-3">
                            <label for="main_image" class="form-label">Gambar Utama</label>
                            <input type="file" class="form-control <?php $__errorArgs = ['main_image'];
$__bag = $errors->getBag($__errorArgs[1] ?? 'default');
if ($__bag->has($__errorArgs[0])) :
if (isset($message)) { $__messageOriginal = $message; }
$message = $__bag->first($__errorArgs[0]); ?> is-invalid <?php unset($message);
if (isset($__messageOriginal)) { $message = $__messageOriginal; }
endif;
unset($__errorArgs, $__bag); ?>"
                                id="main_image" name="main_image" accept="image/*">
                            <small class="text-muted">Format: JPEG, PNG, JPG | Maks: 2MB</small>
                            <?php $__errorArgs = ['main_image'];
$__bag = $errors->getBag($__errorArgs[1] ?? 'default');
if ($__bag->has($__errorArgs[0])) :
if (isset($message)) { $__messageOriginal = $message; }
$message = $__bag->first($__errorArgs[0]); ?>
                            <div class="invalid-feedback"><?php echo e($message); ?></div>
                            <?php unset($message);
if (isset($__messageOriginal)) { $message = $__messageOriginal; }
endif;
unset($__errorArgs, $__bag); ?>
                            <div class="mt-2">
                                <?php if($room->main_image): ?>
                                <img src="<?php echo e(asset('storage/' . $room->main_image)); ?>" alt="Gambar Utama"
                                    class="img-thumbnail" style="max-height: 150px;">
                                <?php endif; ?>
                                <img id="main_image_preview" src="#" alt="Preview Gambar Utama"
                                    class="img-thumbnail d-none" style="max-height: 150px;">
                            </div>
                        </div>

                        <!-- Gallery Gambar -->
                        <div class="mb-3">
                            <label for="gallery_images" class="form-label">Gambar Tambahan (Gallery)</label>
                            <input type="file" class="form-control <?php $__errorArgs = ['gallery_images'];
$__bag = $errors->getBag($__errorArgs[1] ?? 'default');
if ($__bag->has($__errorArgs[0])) :
if (isset($message)) { $__messageOriginal = $message; }
$message = $__bag->first($__errorArgs[0]); ?> is-invalid <?php unset($message);
if (isset($__messageOriginal)) { $message = $__messageOriginal; }
endif;
unset($__errorArgs, $__bag); ?>"
                                id="gallery_images" name="gallery_images[]" multiple accept="image/*">
                            <small class="text-muted">Format: JPEG, PNG, JPG | Maks: 2MB per gambar</small>
                            <?php $__errorArgs = ['gallery_images'];
$__bag = $errors->getBag($__errorArgs[1] ?? 'default');
if ($__bag->has($__errorArgs[0])) :
if (isset($message)) { $__messageOriginal = $message; }
$message = $__bag->first($__errorArgs[0]); ?>
                            <div class="invalid-feedback"><?php echo e($message); ?></div>
                            <?php unset($message);
if (isset($__messageOriginal)) { $message = $__messageOriginal; }
endif;
unset($__errorArgs, $__bag); ?>
                            <?php $__errorArgs = ['gallery_images.*'];
$__bag = $errors->getBag($__errorArgs[1] ?? 'default');
if ($__bag->has($__errorArgs[0])) :
if (isset($message)) { $__messageOriginal = $message; }
$message = $__bag->first($__errorArgs[0]); ?>
                            <div class="invalid-feedback"><?php echo e($message); ?></div>
                            <?php unset($message);
if (isset($__messageOriginal)) { $message = $__messageOriginal; }
endif;
unset($__errorArgs, $__bag); ?>

                            <!-- Tampilkan gambar yang sudah ada -->
                            <?php if($room->gallery_images && count($room->gallery_images) > 0): ?>
                            <div class="mb-3">
                                <label class="form-label">Gambar Saat Ini:</label>
                                <div class="row g-2">
                                    <?php $__currentLoopData = $room->gallery_images; $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $image): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); ?>
                                    <div class="col-6 col-md-4 position-relative">
                                        <img src="<?php echo e(asset('storage/' . $image)); ?>" class="img-thumbnail mb-2"
                                            style="height: 100px; width: 100%; object-fit: cover;">
                                        <button type="button" class="btn btn-sm btn-danger position-absolute top-0 end-0"
                                            onclick="confirmDeleteImage('<?php echo e($image); ?>')">
                                            <i class="fas fa-trash"></i>
                                        </button>
                                    </div>
                                    <?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); ?>
                                </div>
                            </div>
                            <?php endif; ?>

                            <div id="gallery_preview" class="mt-2 row g-2"></div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="d-flex justify-content-between">
            <a href="<?php echo e(route('admin.properties.rooms.index', $property->id)); ?>" class="btn btn-secondary">
                <i class="fas fa-arrow-left me-1"></i> Kembali
            </a>
            <button type="submit" class="btn btn-primary">
                <i class="fas fa-save me-1"></i> Update Ruangan
            </button>
        </div>
    </form>
</div>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        const facilitiesContainer = document.getElementById('facilities-container');
        let facilityCount = {
            {
                count(old('facilities', $room - > facilities - > toArray())) ? : 1
            }
        };

        // Tambah fasilitas
        document.addEventListener('click', function(e) {
            if (e.target.classList.contains('add-facility')) {
                const newInputGroup = document.createElement('div');
                newInputGroup.className = 'input-group mb-2';
                newInputGroup.innerHTML = `
                    <input type="text" class="form-control" name="facilities[${facilityCount}][facility_name]" required>
                    <button type="button" class="btn btn-outline-danger remove-facility">Hapus</button>
                `;
                facilitiesContainer.appendChild(newInputGroup);
                facilityCount++;
            }

            // Hapus fasilitas
            if (e.target.classList.contains('remove-facility')) {
                e.target.closest('.input-group').remove();
            }
        });

        // Preview gambar utama
        const mainImageInput = document.getElementById('main_image');
        const mainImagePreview = document.getElementById('main_image_preview');

        mainImageInput.addEventListener('change', function() {
            const file = this.files[0];
            if (file) {
                const reader = new FileReader();
                reader.onload = function(e) {
                    mainImagePreview.src = e.target.result;
                    mainImagePreview.classList.remove('d-none');
                }
                reader.readAsDataURL(file);
            }
        });

        // Preview gallery gambar
        const galleryInput = document.getElementById('gallery_images');
        const galleryPreview = document.getElementById('gallery_preview');

        galleryInput.addEventListener('change', function() {
            galleryPreview.innerHTML = '';
            const files = this.files;

            for (let i = 0; i < files.length; i++) {
                const file = files[i];
                if (file.type.match('image.*')) {
                    const reader = new FileReader();
                    reader.onload = function(e) {
                        const col = document.createElement('div');
                        col.className = 'col-6 col-md-4';
                        col.innerHTML = `
                            <img src="${e.target.result}" class="img-thumbnail mb-2" style="height: 100px; width: 100%; object-fit: cover;">
                        `;
                        galleryPreview.appendChild(col);
                    }
                    reader.readAsDataURL(file);
                }
            }
        });
    function confirmDeleteImage(imagePath) {
        if (confirm('Apakah Anda yakin ingin menghapus gambar ini?')) {
            // Kirim permintaan penghapusan ke server
            fetch('<?php echo e(route("admin.properties.rooms.deleteImage", [$property->id, $room->id])); ?>', {
                    method: 'POST',
                    headers: {
                        'X-CSRF-TOKEN': '<?php echo e(csrf_token()); ?>',
                        'Content-Type': 'application/json',
                        'Accept': 'application/json'
                    },
                    body: JSON.stringify({
                        image_path: imagePath
                    })
                })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        location.reload(); // Reload halaman setelah penghapusan berhasil
                    } else {
                        alert('Gagal menghapus gambar: ' + data.message);
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('Terjadi kesalahan saat menghapus gambar');
                });        
        }
    }
</script>

<style>
    .img-thumbnail {
        object-fit: cover;
    }
</style>
<?php $__env->stopSection(); ?>
<?php echo $__env->make('layouts.admin', array_diff_key(get_defined_vars(), ['__data' => 1, '__path' => 1]))->render(); ?><?php /**PATH E:\KULIAH\SEMESTER 4\PA2\ProyekAkhir2\backend\resources\views/admin/properties/rooms/edit.blade.php ENDPATH**/ ?>