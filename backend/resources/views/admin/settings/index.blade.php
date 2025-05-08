@extends('layouts.admin')

@section('content')
<div class="container-fluid">
    <div class="row">
        <!-- Main Content -->
        <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4">
            <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3">
                <h1 class="h2 mb-0">Pengaturan Akun</h1>
            </div>

            @if(session('success'))
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <i class="fas fa-check-circle me-2"></i>
                {{ session('success') }}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
            @endif

            <div class="row">
                <div class="col-md-3">
                    <div class="card border-0 shadow-sm mb-4">
                        <div class="card-body p-0">
                            <div class="list-group list-group-flush">
                                <a href="#profile" class="list-group-item list-group-item-action active d-flex align-items-center" data-bs-toggle="tab">
                                    <i class="fas fa-user-circle me-3 text-primary"></i>
                                    <span>Profil Saya</span>
                                </a>
                                <a href="#password" class="list-group-item list-group-item-action d-flex align-items-center" data-bs-toggle="tab">
                                    <i class="fas fa-key me-3 text-warning"></i>
                                    <span>Ganti Password</span>
                                </a>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-md-9">
                    <div class="tab-content">
                        <!-- Profile Tab -->
                        <div class="tab-pane fade show active" id="profile">
                            <div class="card border-0 shadow-sm">
                                <div class="card-header bg-white border-bottom-0 py-3">
                                    <h5 class="mb-0 d-flex align-items-center">
                                        <i class="fas fa-user-circle me-2 text-primary"></i>
                                        Informasi Profil
                                    </h5>
                                </div>
                                <div class="card-body">
                                    <form action="{{ route('admin.settings.profile.update') }}" method="POST" enctype="multipart/form-data">
                                        @csrf
                                        @method('PUT')

                                        <div class="row align-items-start">
                                            <!-- Foto Profil -->
                                            <div class="col-lg-4 text-center mb-4 mb-lg-0">
                                                <div class="position-relative d-inline-block mb-3">
                                                    <img src="{{ Auth::user()->profile_picture ? asset('storage/profile_pictures/'.Auth::user()->profile_picture) : asset('images/default-avatar.png') }}"
                                                        class="rounded-circle img-thumbnail shadow-sm"
                                                        id="profile-preview"
                                                        style="width: 180px; height: 180px; object-fit: cover;">
                                                    <label for="profile_picture" class="btn btn-sm btn-primary rounded-circle position-absolute" style="bottom: 10px; right: 10px;">
                                                        <i class="fas fa-camera"></i>
                                                        <input type="file" id="profile_picture" name="profile_picture" accept="image/*" class="d-none">
                                                    </label>
                                                </div>
                                                <small class="text-muted d-block">Format: JPG, PNG (Max 2MB)</small>
                                            </div>

                                            <!-- Form Profil -->
                                            <div class="col-lg-8">
                                                <div class="row g-3">
                                                    <div class="col-md-6">
                                                        <label for="name" class="form-label">Nama Lengkap</label>
                                                        <div class="input-group">
                                                            <span class="input-group-text bg-light"><i class="fas fa-user"></i></span>
                                                            <input type="text" class="form-control" id="name" name="name"
                                                                value="{{ old('name', Auth::user()->name) }}" required>
                                                        </div>
                                                    </div>

                                                    <div class="col-md-6">
                                                        <label for="username" class="form-label">Username</label>
                                                        <div class="input-group">
                                                            <span class="input-group-text bg-light"><i class="fas fa-at"></i></span>
                                                            <input type="text" class="form-control" id="username" name="username"
                                                                value="{{ old('username', Auth::user()->username) }}" required>
                                                        </div>
                                                    </div>

                                                    <div class="col-md-6">
                                                        <label for="gender" class="form-label">Jenis Kelamin</label>
                                                        <div class="input-group">
                                                            <span class="input-group-text bg-light"><i class="fas fa-venus-mars"></i></span>
                                                            <select class="form-select" id="gender" name="gender" required>
                                                                <option value="Pria" {{ Auth::user()->gender == 'Pria' ? 'selected' : '' }}>Pria</option>
                                                                <option value="Wanita" {{ Auth::user()->gender == 'Wanita' ? 'selected' : '' }}>Wanita</option>
                                                            </select>
                                                        </div>
                                                    </div>

                                                    <div class="col-md-6">
                                                        <label for="phone" class="form-label">Nomor Telepon</label>
                                                        <div class="input-group">
                                                            <span class="input-group-text bg-light"><i class="fas fa-phone"></i></span>
                                                            <input type="tel" class="form-control" id="phone" name="phone"
                                                                value="{{ old('phone', Auth::user()->phone) }}">
                                                        </div>
                                                    </div>

                                                    <div class="col-12">
                                                        <label for="address" class="form-label">Alamat</label>
                                                        <div class="input-group">
                                                            <span class="input-group-text bg-light"><i class="fas fa-map-marker-alt"></i></span>
                                                            <textarea class="form-control" id="address" name="address" rows="3">{{ old('address', Auth::user()->address) }}</textarea>
                                                        </div>
                                                    </div>

                                                    <div class="col-12 mt-3">
                                                        <button type="submit" class="btn btn-primary px-4">
                                                            <i class="fas fa-save me-2"></i>Simpan Perubahan
                                                        </button>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </form>
                                </div>
                            </div>
                        </div>

                        <!-- Password Tab -->
                        <div class="tab-pane fade" id="password">
                            <div class="card border-0 shadow-sm">
                                <div class="card-header bg-white border-bottom-0 py-3">
                                    <h5 class="mb-0 d-flex align-items-center">
                                        <i class="fas fa-key me-2 text-warning"></i>
                                        Ganti Password
                                    </h5>
                                </div>
                                <div class="card-body">
                                    <form action="{{ route('admin.settings.password.update') }}" method="POST">
                                        @csrf
                                        @method('PUT')

                                        <div class="row g-3">
                                            <div class="col-12">
                                                <label for="current_password" class="form-label">Password Saat Ini</label>
                                                <div class="input-group">
                                                    <span class="input-group-text bg-light"><i class="fas fa-lock"></i></span>
                                                    <input type="password" class="form-control" id="current_password" name="current_password" required>
                                                    <button class="btn btn-outline-secondary toggle-password" type="button">
                                                        <i class="fas fa-eye"></i>
                                                    </button>
                                                </div>
                                                @error('current_password')
                                                <div class="text-danger small mt-2">{{ $message }}</div>
                                                @enderror
                                            </div>

                                            <div class="col-md-6">
                                                <label for="new_password" class="form-label">Password Baru</label>
                                                <div class="input-group">
                                                    <span class="input-group-text bg-light"><i class="fas fa-lock"></i></span>
                                                    <input type="password" class="form-control" id="new_password" name="new_password" required>
                                                    <button class="btn btn-outline-secondary toggle-password" type="button">
                                                        <i class="fas fa-eye"></i>
                                                    </button>
                                                </div>
                                                <div class="form-text">Minimal 8 karakter</div>
                                                @error('new_password')
                                                <div class="text-danger small mt-2">{{ $message }}</div>
                                                @enderror
                                            </div>

                                            <div class="col-md-6">
                                                <label for="new_password_confirmation" class="form-label">Konfirmasi Password Baru</label>
                                                <div class="input-group">
                                                    <span class="input-group-text bg-light"><i class="fas fa-lock"></i></span>
                                                    <input type="password" class="form-control" id="new_password_confirmation" name="new_password_confirmation" required>
                                                    <button class="btn btn-outline-secondary toggle-password" type="button">
                                                        <i class="fas fa-eye"></i>
                                                    </button>
                                                </div>
                                            </div>

                                            <div class="col-12 mt-3">
                                                <button type="submit" class="btn btn-primary px-4">
                                                    <i class="fas fa-sync-alt me-2"></i>Update Password
                                                </button>
                                            </div>
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

<style>
    .list-group-item {
        border: none;
        padding: 1rem 1.25rem;
        border-radius: 0.5rem !important;
        margin-bottom: 0.5rem;
        transition: all 0.3s ease;
    }
    
    .list-group-item.active {
        background-color: #f8f9fa;
        color: #0d6efd;
        font-weight: 500;
        border-left: 4px solid #0d6efd;
    }
    
    .list-group-item:not(.active):hover {
        background-color: #f8f9fa;
        color: #0d6efd;
    }
    
    .card {
        border-radius: 0.75rem;
    }
    
    .img-thumbnail {
        border: 3px solid #fff;
        box-shadow: 0 4px 6px rgba(0,0,0,0.1);
    }
    
    .input-group-text {
        min-width: 45px;
        justify-content: center;
    }
</style>

<script>
    // Preview gambar profil
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

    // Toggle password visibility
    document.querySelectorAll('.toggle-password').forEach(function(button) {
        button.addEventListener('click', function() {
            const input = this.parentNode.querySelector('input');
            const icon = this.querySelector('i');
            
            if (input.type === 'password') {
                input.type = 'text';
                icon.classList.remove('fa-eye');
                icon.classList.add('fa-eye-slash');
            } else {
                input.type = 'password';
                icon.classList.remove('fa-eye-slash');
                icon.classList.add('fa-eye');
            }
        });
    });

    // Tab system
    document.addEventListener('DOMContentLoaded', function() {
        var tabElms = document.querySelectorAll('a[data-bs-toggle="tab"]');
        tabElms.forEach(function(tabEl) {
            tabEl.addEventListener('click', function(e) {
                e.preventDefault();
                var tab = new bootstrap.Tab(this);
                tab.show();
            });
        });

        if (window.location.hash) {
            var triggerEl = document.querySelector(a[href="${window.location.hash}"]);
            if (triggerEl) {
                bootstrap.Tab.getInstance(triggerEl).show();
            }
        }
    });
</script>
@endsection