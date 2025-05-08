penyewa.blade.php
<!-- filepath: resources/views/platform_admin/Penyewa.blade.php -->
@extends('layouts.index-adminplatform')

@section('content')
<div class="container py-5">
    <div class="row">
        <div class="col">
            <h1 class="mb-4 text-center">Daftar Penyewa</h1>
        </div>
    </div>

        <!-- Penyewa Aktif -->
    <div class="row mb-5">
        <div class="col">
            <div class="card shadow">
                <div class="card-header bg-success text-white">
                    <h5 class="mb-0">Penyewa Aktif</h5>
                </div>
                <div class="card-body p-0">
                    <ul class="list-group list-group-flush">
                        @forelse ($activeTenant as $tenant)
                            <li class="list-group-item d-flex justify-content-between align-items-center">
                                <div>
                                    <strong>{{ $tenant->username }}</strong><br>
                                    <small>{{ $tenant->email }}</small>
                                </div>
                                <form action="{{ route('platform_admin.ban', $tenant->id) }}" method="POST">
                                    @csrf
                                    <button type="submit" class="btn btn-outline-danger btn-sm" title="Ban">
                                        <i class="fas fa-user-slash"></i>
                                    </button>
                                </form>
                            </li>
                        @empty
                            <li class="list-group-item text-center text-muted">Tidak ada penyewa aktif.</li>
                        @endforelse
                    </ul>
                </div>
            </div>
        </div>
    </div>


    <!-- Penyewa Dibanned -->
    <div class="row">
        <div class="col">
            <div class="card shadow">
                <div class="card-header bg-danger text-white">
                    <h5 class="mb-0">Penyewa Dibanned</h5>
                </div>
                <div class="card-body p-0">
                    <ul class="list-group list-group-flush">
                        @forelse ($bannedTenant as $tenant)
                            <li class="list-group-item d-flex justify-content-between align-items-center">
                                <div>
                                    <strong>{{ $tenant->username }}</strong><br>
                                    <small>{{ $tenant->email }}</small>
                                </div>
                                <form action="{{ route('platform_admin.unban', $tenant->id) }}" method="POST">
                                    @csrf
                                    <button type="submit" class="btn btn-outline-success btn-sm" title="Unban">
                                        <i class="fas fa-user-check"></i>
                                    </button>
                                </form>
                            </li>
                        @empty
                            <li class="list-group-item text-center text-muted">Tidak ada penyewa yang dibanned.</li>
                        @endforelse
                    </ul>
                </div>
            </div>
        </div>
    </div>
</div>
@endsection