<!-- resources/views/admin/rooms/show.blade.php -->

@extends('layouts.admin')

@section('content')
<div class="container">
    <h2>Detail Ruangan: {{ $room->name }}</h2>
    <div class="mb-3">
        <strong>Nama Ruangan: </strong> {{ $room->name }}
    </div>
    <div class="mb-3">
        <strong>Harga: </strong> Rp {{ number_format($room->price, 0, ',', '.') }}
    </div>
    <div class="mb-3">
        <strong>Status: </strong>
        @if ($room->is_available)
            <span class="badge bg-success">Tersedia</span>
        @else
            <span class="badge bg-danger">Tidak Tersedia</span>
        @endif
    </div>
    <div class="mb-3">
        <strong>Fasilitas: </strong>
        @foreach ($room->facilities as $facility)
            <span class="badge bg-info">{{ $facility->name }}</span>
        @endforeach
    </div>
    <a href="{{ route('admin.rooms.edit', $room->id) }}" class="btn btn-warning">Edit</a>
    <a href="{{ route('admin.rooms.index') }}" class="btn btn-secondary">Kembali</a>
</div>
@endsection
