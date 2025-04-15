@extends('layouts.admin')

@section('content')
<div class="container">
    <div class="row mb-4">
        <div class="col-12">
            <h3>Daftar Ruangan</h3>
            <a href="{{ route('admin.rooms.create') }}" class="btn btn-primary">
                <i class="fas fa-plus-circle"></i> Tambah Ruangan
            </a>
        </div>
    </div>

    <!-- Notifikasi jika ada pesan -->
    @if(session('success'))
        <div class="alert alert-success">
            {{ session('success') }}
        </div>
    @elseif(session('error'))
        <div class="alert alert-danger">
            {{ session('error') }}
        </div>
    @endif

    <div class="row">
        <div class="col-12">
            <table class="table table-bordered">
                <thead>
                    <tr>
                        <th>No</th>
                        <th>Nama Ruangan</th>
                        <th>Harga per Bulan</th>
                        <th>Fasilitas</th>
                        <th>Status</th>
                        <th>Aksi</th>
                    </tr>
                </thead>
                <tbody>
                    @foreach($rooms as $index => $room)
                        <tr>
                            <td>{{ $index + 1 }}</td>
                            <td>{{ $room->name }}</td>
                            <td>Rp {{ number_format($room->price, 0, ',', '.') }}</td>
                            <td>
                                <ul>
                                    @foreach($room->facilities as $facility)
                                        <li>{{ $facility->name }}</li>
                                    @endforeach
                                </ul>
                            </td>
                            <td>
                                <span class="badge badge-{{ $room->is_available ? 'success' : 'danger' }}">
                                    {{ $room->is_available ? 'Tersedia' : 'Tidak Tersedia' }}
                                </span>
                            </td>
                            <td>
                                <a href="{{ route('admin.rooms.edit', $room->id) }}" class="btn btn-warning btn-sm">
                                    <i class="fas fa-edit"></i> Edit
                                </a>
                                <form action="{{ route('admin.rooms.destroy', $room->id) }}" method="POST" class="d-inline-block">
                                    @csrf
                                    @method('DELETE')
                                    <button type="submit" class="btn btn-danger btn-sm" onclick="return confirm('Apakah Anda yakin ingin menghapus ruangan ini?')">
                                        <i class="fas fa-trash-alt"></i> Hapus
                                    </button>
                                </form>
                            </td>
                        </tr>
                    @endforeach
                </tbody>
            </table>
            {{ $rooms->links() }}
        </div>
    </div>
</div>
@endsection
