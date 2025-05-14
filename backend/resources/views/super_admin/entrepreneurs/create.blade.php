@extends('layouts.index-superadmin')

@section('content')
<div class="container py-5">
    <div class="row justify-content-center">
        <div class="col-md-8">
            <div class="card shadow-lg border-0 rounded-4">
                <div class="card-header bg-primary text-white text-center rounded-top-4">
                    <h4 class="mb-0"><i class="fas fa-user-plus me-2"></i>Tambah Owner Baru</h4>
                </div>
                <div class="card-body px-4 py-4">
                    <form action="{{ route('super_admin.entrepreneurs.store') }}" method="POST">
                        @csrf

                        {{-- Nama --}}
                        <div class="mb-3">
                            <label for="name" class="form-label fw-semibold">
                                <i class="fas fa-user text-primary me-1"></i> Nama Lengkap
                            </label>
                            <input type="text" name="name" id="name" class="form-control @error('name') is-invalid @enderror" placeholder="Masukkan nama lengkap" required>
                            @error('name')
                                <div class="invalid-feedback">{{ $message }}</div>
                            @enderror
                        </div>

                        {{-- Email --}}
                        <div class="mb-3">
                            <label for="email" class="form-label fw-semibold">
                                <i class="fas fa-envelope me-2 text-info"></i> Email
                            </label>
                            <input type="email" name="email" id="email" class="form-control @error('email') is-invalid @enderror" placeholder="Masukkan email" required>
                            @error('email')
                                <div class="invalid-feedback">{{ $message }}</div>
                            @enderror
                        </div>

                        {{-- Username --}}
                        <div class="mb-3">
                            <label for="username" class="form-label fw-semibold">
                                <i class="fas fa-user-tag me-2 text-warning"></i> Username
                            </label>
                            <input type="text" name="username" id="username" class="form-control @error('username') is-invalid @enderror" placeholder="Masukkan username" required>
                            @error('username')
                                <div class="invalid-feedback">{{ $message }}</div>
                            @enderror
                        </div>

                        {{-- Password --}}
                        <div class="mb-3">
                            <label for="password" class="form-label fw-semibold">
                                <i class="fas fa-lock me-2 text-danger"></i> Password
                            </label>
                            <input type="password" name="password" id="password" class="form-control @error('password') is-invalid @enderror" placeholder="Masukkan password" required>
                            @error('password')
                                <div class="invalid-feedback">{{ $message }}</div>
                            @enderror
                        </div>

                        {{-- Tombol --}}
                        <div class="d-grid gap-3 mt-4">
                            <button type="submit" class="btn btn-primary btn-lg shadow-sm">
                                <i class="fas fa-save me-1"></i> Simpan
                            </button>
                            <a href="{{ route('super_admin.entrepreneurs.approved') }}" class="btn btn-outline-secondary btn-lg">
                                <i class="fas fa-arrow-left me-1"></i> Kembali
                            </a>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>
@endsection
