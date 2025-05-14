@extends('layouts.index-superadmin')
@section('title', 'Edit Profil Super Admin')

@section('content')
<div class="container py-5">

    {{-- Judul visual di halaman --}}
    <div class="text-center mb-5">
        <h1 class="fw-bold fs-2 text-dark">Edit Profil Super Admin</h1>
        <p class="text-muted fs-6">Perbarui informasi akun Anda dengan benar</p>
    </div>

    {{-- Notifikasi sukses --}}
    @if(session('success'))
        <div class="alert alert-success alert-dismissible fade show" role="alert">
            {{ session('success') }}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    @endif

    {{-- Error validasi --}}
    @if ($errors->any())
        <div class="alert alert-danger alert-dismissible fade show" role="alert">
            <strong>Terjadi kesalahan:</strong>
            <ul class="mb-0 mt-2">
                @foreach ($errors->all() as $error)
                    <li>{{ $error }}</li>
                @endforeach
            </ul>
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    @endif

    <div class="row justify-content-center">
        <div class="col-lg-8">

            {{-- Form dalam card --}}
            <div class="card shadow-sm rounded-4 border-0">
                <div class="card-body p-4">

                    <form action="{{ route('super_admin.profiles.update') }}" method="POST" novalidate>
                        @csrf
                        @method('PUT')

                        {{-- Nama --}}
                        <div class="col-md-12">
                        <div class="mb-3">
                            <label for="name" class="form-label">
                            <i class="fas fa-user me-2 text-primary"></i>
                                Nama Lengkap
                            </label>
                            <input type="text"
                                   class="form-control @error('name') is-invalid @enderror"
                                   id="name"
                                   name="name"
                                   value="{{ old('name', $admin->name) }}"
                                   required>
                            @error('name')
                                <div class="invalid-feedback">{{ $message }}</div>
                            @enderror
                        </div>
                        

                        {{-- Email --}}
                        <div class="mb-3">
                            <label for="email">
                                <i class="fas fa-envelope me-2 text-info"></i>
                               
                                Email
                            </label>
                            <input type="email"
                                   class="form-control @error('email') is-invalid @enderror"
                                   id="email"
                                   name="email"
                                   value="{{ old('email', $admin->email) }}"
                                   required>
                            @error('email')
                                <div class="invalid-feedback">{{ $message }}</div>
                            @enderror
                        </div>

                        {{-- Username --}}
                        <div class="mb-3">
                            <label for="username">
                                 <i class="fas fa-user-tag me-2 text-warning"></i> 
                                Username
                            </label>
                            <input type="text"
                                   class="form-control @error('username') is-invalid @enderror"
                                   id="username"
                                   name="username"
                                   value="{{ old('username', $admin->username) }}"
                                   required>
                            @error('username')
                                <div class="invalid-feedback">{{ $message }}</div>
                            @enderror
                        </div>

                        <hr>

                        {{-- Password Baru --}}
                        <div class="mb-3">
                            <label for="password" class="form-label">
                                Password Baru <small class="text-muted">(Opsional)</small>
                            </label>
                            <input type="password"
                                   class="form-control @error('password') is-invalid @enderror"
                                   id="password"
                                   name="password">
                            @error('password')
                                <div class="invalid-feedback">{{ $message }}</div>
                            @enderror
                        </div>

                        {{-- Konfirmasi Password --}}
                        <div class="mb-4">
                            <label for="password_confirmation" class="form-label">
                                Konfirmasi Password Baru
                            </label>
                            <input type="password"
                                   class="form-control"
                                   id="password_confirmation"
                                   name="password_confirmation">
                        </div>

                        {{-- Tombol Aksi --}}
                        <div class="d-flex justify-content-between align-items-center">
                            <a href="{{ route('super_admin.profiles.index') }}" class="btn btn-outline-secondary">
                                ← Kembali ke Profil
                            </a>
                            <button type="submit" class="btn btn-primary rounded-pill px-4">
                                Simpan Perubahan
                            </button>
                        </div>

                    </form>

                </div>
            </div>

        </div>
    </div>
</div>
</div>
@endsection
