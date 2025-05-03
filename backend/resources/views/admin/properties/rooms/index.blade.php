@extends('layouts.admin')

@section('content')
<div class="container">
    <div class="row mb-4">
        <div class="col-12">
            <h3>Daftar Ruangan</h3>
            <a href="{{ route('admin.properties.rooms.create', $property->id) }}" class="btn btn-primary">
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
            <table class="table table-bordered table-striped">
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
                    @forelse($rooms as $index => $room)
                    <tr>
                        <td>{{ $loop->iteration }}</td>
                        <td>{{ $room->room_type }}</td>
                        <td>Rp {{ number_format($room->price, 0, ',', '.') }}</td>
                        <td>
                            @if (!empty($room->facilities) && $room->facilities->count() > 0)
                                <ul class="mb-0">
                                    @foreach($room->facilities as $facility)
                                        <li>{{ $facility->facility_name }}</li>
                                    @endforeach
                                </ul>
                            @else
                                <em>Tidak ada fasilitas</em>
                            @endif
                        </td>
                        <td>
                            <span class="badge bg-{{ $room->is_available ? 'success' : 'danger' }}">
                                {{ $room->is_available ? 'Tersedia' : 'Tidak Tersedia' }}
                            </span>
                        </td>
                        <td>
                            <a href="{{ route('admin.properties.rooms.show', [$property->id, $room->id]) }}" class="btn btn-info btn-sm mb-1">
                                <i class="fas fa-eye"></i> Lihat
                            </a>
                            <a href="{{ route('admin.properties.rooms.edit', [$property->id, $room->id]) }}" class="btn btn-warning btn-sm mb-1">
                                <i class="fas fa-edit"></i> Edit
                            </a>
                            <form action="{{ route('admin.properties.rooms.destroy', [$property->id, $room->id]) }}" method="POST" class="d-inline-block">
                                @csrf
                                @method('DELETE')
                                <button type="submit" class="btn btn-danger btn-sm" onclick="return confirm('Apakah Anda yakin ingin menghapus ruangan ini?')">
                                    <i class="fas fa-trash-alt"></i> Hapus
                                </button>
                            </form>
                        </td>
                    </tr>
                    @empty
                    <tr>
                        <td colspan="6" class="text-center">Belum ada ruangan tersedia.</td>
                    </tr>
                    @endforelse
                </tbody>
            </table>

            <!-- Pagination -->
            <div class="d-flex justify-content-center">
                {{ $rooms->links() }}
            </div>
        </div>
    </div>
</div>
@endsection
