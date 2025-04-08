<!-- filepath: e:\KULIAH\SEMESTER 4\PA2\PA2\PA2\resources\views\platform_admin\Pengusaha.blade.php -->
@extends('layouts.index-adminplatform')

@section('content')
<div class="container py-5">
    <h1 class="mb-4">Daftar Pengusaha</h1>

    <!-- Daftar Owner Aktif -->
    <div id="owner-aktif" class="mt-5">
        <h3>Owner Aktif</h3>
        <ul class="list-group">
            @foreach ($activeOwners as $owner)
                <li class="list-group-item d-flex justify-content-between align-items-center">
                    {{ $owner->username }} ({{ $owner->email }})
                    <form action="{{ route('platform_admin.ban', $owner->id) }}" method="POST">
                        @csrf
                        <button type="submit" class="btn btn-sm btn-danger">Ban</button>
                    </form>
                </li>
            @endforeach
        </ul>
    </div>

    <!-- Daftar Owner Dibanned -->
    <div id="owner-banned" class="mt-5">
        <h3>Owner Dibanned</h3>
        <ul class="list-group">
            @foreach ($bannedOwners as $owner)
                <li class="list-group-item d-flex justify-content-between align-items-center">
                    {{ $owner->username }} ({{ $owner->email }})
                    <form action="{{ route('platform_admin.unban', $owner->id) }}" method="POST">
                        @csrf
                        <button type="submit" class="btn btn-sm btn-success">Unban</button>
                    </form>
                </li>
            @endforeach
        </ul>
    </div>
</div>
@endsection