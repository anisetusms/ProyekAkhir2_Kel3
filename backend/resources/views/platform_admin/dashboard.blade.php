@extends('layouts.index-adminplatform')

@section('content')
<main class="flex-grow-1 p-4">
    <div class="container">
        <h2>Selamat Datang, {{ Auth::user()->name }}</h2>
        <p>Gunakan menu navigasi untuk mengelola akun Owner dan Penyewa.</p>

        <div class="row">
            <!-- Owner Aktif -->
            <div class="col-md-6">
                <div class="card shadow-sm">
                    <div class="card-body text-center">
                        <i class="material-icons-outlined text-primary" style="font-size: 48px;">group</i>
                        <h5 class="card-title mt-3">Owner Aktif</h5>
                        <p class="card-text">Jumlah: <strong>{{ $activeOwnersCount }}</strong></p>
                        <a href="{{ route('platform_admin.pengusaha') }}" class="btn btn-primary">Lihat</a>
                    </div>
                </div>
            </div>

            <!-- Owner Dibanned -->
            <div class="col-md-6">
                <div class="card shadow-sm">
                    <div class="card-body text-center">
                        <i class="material-icons-outlined text-danger" style="font-size: 48px;">block</i>
                        <h5 class="card-title mt-3">Owner Dibanned</h5>
                        <p class="card-text">Jumlah: <strong>{{ $bannedOwnersCount }}</strong></p>
                        <a href="{{ route('platform_admin.pengusaha') }}" class="btn btn-danger">Lihat</a>
                    </div>
                </div>
            </div>
        </div>

        <div class="row mt-4">
            <!-- Penyewa Aktif -->
            <div class="col-md-6">
                <div class="card shadow-sm">
                    <div class="card-body text-center">
                        <i class="material-icons-outlined text-success" style="font-size: 48px;">group</i>
                        <h5 class="card-title mt-3">Penyewa Aktif</h5>
                        <p class="card-text">Jumlah: <strong>{{ $activeTenantsCount }}</strong></p>
                        <a href="{{ route('platform_admin.penyewa') }}" class="btn btn-success">Lihat</a>
                    </div>
                </div>
            </div>

            <!-- Penyewa Dibanned -->
            <div class="col-md-6">
                <div class="card shadow-sm">
                    <div class="card-body text-center">
                        <i class="material-icons-outlined text-warning" style="font-size: 48px;">block</i>
                        <h5 class="card-title mt-3">Penyewa Dibanned</h5>
                        <p class="card-text">Jumlah: <strong>{{ $bannedTenantsCount }}</strong></p>
                        <a href="{{ route('platform_admin.penyewa') }}" class="btn btn-warning">Lihat</a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</main>
@endsection