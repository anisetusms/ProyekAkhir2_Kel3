

<?php $__env->startSection('content'); ?>
<div class="container-fluid">
    <div class="row">
        <!-- Main Content -->
        <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4">
            <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                <h1 class="h2">Pengaturan Akun</h1>
            </div>

            <?php if(session('success')): ?>
            <div class="alert alert-success">
                <?php echo e(session('success')); ?>

            </div>
            <?php endif; ?>

            <div class="row">
                <div class="col-md-3">
                    <div class="list-group">
                        <a href="#profile" class="list-group-item list-group-item-action active" data-bs-toggle="tab">
                            <i class="fas fa-user me-2"></i>Profil
                        </a>
                        <a href="#password" class="list-group-item list-group-item-action" data-bs-toggle="tab">
                            <i class="fas fa-lock me-2"></i>Password
                        </a>
                    </div>
                </div>

                <div class="col-md-9">
                    <div class="tab-content">
                        <!-- Profile Tab -->
                        <div class="tab-pane fade show active" id="profile">
                            <div class="card">
                                <div class="card-header bg-primary text-white">
                                    <h5 class="mb-0">Informasi Profil</h5>
                                </div>
                                <div class="card-body">
                                    <form action="<?php echo e(route('admin.settings.profile.update')); ?>" method="POST" enctype="multipart/form-data">
                                        <?php echo csrf_field(); ?>
                                        <?php echo method_field('PUT'); ?>

                                        <div class="row mb-3">
                                            <div class="col-md-4 text-center">
                                                <div class="mb-3">
                                                    <img src="<?php echo e(Auth::user()->profile_picture ? asset('storage/profile_pictures/'.Auth::user()->profile_picture) : asset('images/default-avatar.png')); ?>"
                                                        class="rounded-circle img-thumbnail"
                                                        id="profile-preview"
                                                        style="width: 150px; height: 150px; object-fit: cover;">
                                                </div>
                                                <div class="mb-3">
                                                    <input type="file" class="form-control" id="profile_picture" name="profile_picture" accept="image/*">
                                                    <small class="text-muted">Format: JPG, PNG (Max 2MB)</small>
                                                </div>
                                            </div>
                                            <div class="col-md-8">
                                                <div class="row">
                                                    <div class="col-md-6 mb-3">
                                                        <label for="name" class="form-label">Nama Lengkap</label>
                                                        <input type="text" class="form-control" id="name" name="name"
                                                            value="<?php echo e(old('name', Auth::user()->name)); ?>" required>
                                                    </div>
                                                    <div class="col-md-6 mb-3">
                                                        <label for="username" class="form-label">Username</label>
                                                        <input type="text" class="form-control" id="username" name="username"
                                                            value="<?php echo e(old('username', Auth::user()->username)); ?>" required>
                                                    </div>
                                                </div>

                                                <div class="row">
                                                    <div class="col-md-6 mb-3">
                                                        <label for="gender" class="form-label">Jenis Kelamin</label>
                                                        <select class="form-select" id="gender" name="gender" required>
                                                            <option value="Pria" <?php echo e(Auth::user()->gender == 'Pria' ? 'selected' : ''); ?>>Pria</option>
                                                            <option value="Wanita" <?php echo e(Auth::user()->gender == 'Wanita' ? 'selected' : ''); ?>>Wanita</option>
                                                        </select>
                                                    </div>
                                                    <div class="col-md-6 mb-3">
                                                        <label for="phone" class="form-label">Nomor Telepon</label>
                                                        <input type="tel" class="form-control" id="phone" name="phone"
                                                            value="<?php echo e(old('phone', Auth::user()->phone)); ?>">
                                                    </div>
                                                </div>

                                                <div class="mb-3">
                                                    <label for="address" class="form-label">Alamat</label>
                                                    <textarea class="form-control" id="address" name="address" rows="3"><?php echo e(old('address', Auth::user()->address)); ?></textarea>
                                                </div>

                                                <div class="d-grid gap-2 d-md-flex justify-content-md-end">
                                                    <button type="submit" class="btn btn-primary">Simpan Perubahan</button>
                                                </div>
                                            </div>
                                        </div>
                                    </form>
                                </div>
                            </div>
                        </div>

                        <!-- Password Tab -->
                        <div class="tab-pane fade" id="password">
                            <div class="card">
                                <div class="card-header bg-primary text-white">
                                    <h5 class="mb-0">Ganti Password</h5>
                                </div>
                                <div class="card-body">
                                    <form action="<?php echo e(route('admin.settings.password.update')); ?>" method="POST">
                                        <?php echo csrf_field(); ?>
                                        <?php echo method_field('PUT'); ?>

                                        <div class="mb-3">
                                            <label for="current_password" class="form-label">Password Saat Ini</label>
                                            <input type="password" class="form-control" id="current_password" name="current_password" required>
                                            <?php $__errorArgs = ['current_password'];
$__bag = $errors->getBag($__errorArgs[1] ?? 'default');
if ($__bag->has($__errorArgs[0])) :
if (isset($message)) { $__messageOriginal = $message; }
$message = $__bag->first($__errorArgs[0]); ?>
                                            <span class="text-danger"><?php echo e($message); ?></span>
                                            <?php unset($message);
if (isset($__messageOriginal)) { $message = $__messageOriginal; }
endif;
unset($__errorArgs, $__bag); ?>
                                        </div>

                                        <div class="row">
                                            <div class="col-md-6 mb-3">
                                                <label for="new_password" class="form-label">Password Baru</label>
                                                <input type="password" class="form-control" id="new_password" name="new_password" required>
                                                <div class="form-text">Minimal 8 karakter</div>
                                                <?php $__errorArgs = ['new_password'];
$__bag = $errors->getBag($__errorArgs[1] ?? 'default');
if ($__bag->has($__errorArgs[0])) :
if (isset($message)) { $__messageOriginal = $message; }
$message = $__bag->first($__errorArgs[0]); ?>
                                                <span class="text-danger"><?php echo e($message); ?></span>
                                                <?php unset($message);
if (isset($__messageOriginal)) { $message = $__messageOriginal; }
endif;
unset($__errorArgs, $__bag); ?>
                                            </div>
                                            <div class="col-md-6 mb-3">
                                                <label for="new_password_confirmation" class="form-label">Konfirmasi Password Baru</label>
                                                <input type="password" class="form-control" id="new_password_confirmation" name="new_password_confirmation" required>
                                            </div>
                                        </div>

                                        <div class="d-grid gap-2 d-md-flex justify-content-md-end">
                                            <button type="submit" class="btn btn-primary">Update Password</button>
                                        </div>
                                    </form>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </main>
    </div>
</div>

<script>
    document.getElementById('profile_picture').addEventListener('change', function(event) {
        const file = event.target.files[0];
        if (file) {
            const reader = new FileReader();
            reader.onload = function(e) {
                document.getElementById('profile-preview').src = e.target.result;
            }
            reader.readAsDataURL(file);
        }
    }); 
        document.addEventListener('DOMContentLoaded', function() {
            // Aktifkan tab system
            var tabElms = document.querySelectorAll('a[data-bs-toggle="tab"]');
            tabElms.forEach(function(tabEl) {
                tabEl.addEventListener('click', function(e) {
                    e.preventDefault();
                    var tab = new bootstrap.Tab(this);
                    tab.show();
                });
            });

            // Tangani hash URL
            if (window.location.hash) {
                var triggerEl = document.querySelector(`a[href="${window.location.hash}"]`);
                if (triggerEl) {
                    bootstrap.Tab.getInstance(triggerEl).show();
                }
            }
        });
</script>
<?php $__env->stopSection(); ?>
<?php echo $__env->make('layouts.index-adminplatform', array_diff_key(get_defined_vars(), ['__data' => 1, '__path' => 1]))->render(); ?><?php /**PATH E:\KULIAH\SEMESTER 4\PA2\ProyekAkhir2\backend\resources\views/platform_admin/settings/index.blade.php ENDPATH**/ ?>