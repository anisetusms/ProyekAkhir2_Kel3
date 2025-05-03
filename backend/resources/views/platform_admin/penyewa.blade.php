<!-- filepath: e:\KULIAH\SEMESTER 4\PA2\PA2\PA2\resources\views\platform_admin\Pengusaha.blade.php -->
@extends('layouts.index-adminplatform')

@section('content')
<div class="container py-5">
    <h1 class="mb-4">Daftar Pengusaha</h1>

    <div id="tenant-aktif" class="mt-5">
        <h3>Penyewa Aktif</h3>
        <ul class="list-group">
            @foreach ($activeTenant as $tenant)
                <li class="list-group-item d-flex justify-content-between align-items-center">
                    {{ $tenant->username }} ({{ $tenant->email }})
                    <form action="{{ route('platform_admin.ban', $tenant->id) }}" method="POST">
                        @csrf
                        <button type="submit" class="btn btn-sm btn-danger">Ban</button>
                    </form>
                </li>
            @endforeach
        </ul>
    </div>

    <div id="tenant-banned" class="mt-5">
        <h3>Penyewa Dibanned</h3>
        <ul class="list-group">
            @foreach ($bannedTenant as $tenant)
                <li class="list-group-item d-flex justify-content-between align-items-center">
                    {{ $tenant->username }} ({{ $tenant->email }})
                    <form action="{{ route('platform_admin.unban', $tenant->id) }}" method="POST">
                        @csrf
                        <button type="submit" class="btn btn-sm btn-success">Unban</button>
                    </form>
                </li>
            @endforeach
        </ul>
    </div>
</div>
@endsection