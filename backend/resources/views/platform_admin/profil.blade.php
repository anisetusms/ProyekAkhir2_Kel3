<!-- filepath: e:\KULIAH\SEMESTER 4\PA2\PA2\PA2\resources\views\platform_admin\profil.blade.php -->
@extends('layouts.index-adminplatform')

@section('content')
<div class="container py-5">
    <h1 class="mb-4">Profil Admin</h1>

    <!-- Form Edit Profil -->
    <div class="card shadow-sm">
        <div class="card-body">
            <form action="{{ route('platform_admin.update_profil') }}" method="POST" enctype="multipart/form-data">
                @csrf
                @method('PUT')

                <!-- Foto Profil -->
                <div class="text-center mb-4">
                    <img src="{{ Auth::user()->profile_picture ? asset('storage/profile_pictures/'.Auth::user()->profile_picture) : asset('images/default-avatar.png') }}"
                        class="rounded-circle mb-3"
                        width="120"
                        height="120"
                        alt="Foto Profil">
                    <div>
                        <label for="profile_picture" class="btn btn-outline-primary btn-sm">Ubah Foto</label>
                        <input type="file" id="profile_picture" name="profile_picture" class="d-none">
                    </div>
                </div>

                <!-- Nama -->
                <div class="mb-3">
                    <label for="name" class="form-label">Nama</label>
                    <input type="text" id="name" name="name" class="form-control" value="{{ Auth::user()->name }}" required>
                </div>

                <!-- Email -->
                <div class="mb-3">
                    <label for="email" class="form-label">Email</label>
                    <input type="email" id="email" name="email" class="form-control" value="{{ Auth::user()->email }}" required>
                </div>

                <!-- Kata Sandi -->
                <div class="mb-3">
                    <label for="password" class="form-label">Kata Sandi Baru (Opsional)</label>
                    <input type="password" id="password" name="password" class="form-control" placeholder="Masukkan kata sandi baru">
                </div>

                <!-- Tombol Simpan -->
                <div class="text-end">
                    <button type="submit" class="btn btn-success">Simpan Perubahan</button>
                </div>
            </form>
        </div>
    </div>
</div>
@endsection