@extends('layouts.index-owner')

@section('content')
<div class="container mt-4">
    <h2 class="mb-4">Daftar Properti</h2>

    <!-- Tombol Tambah Properti -->
    <a href="{{ route('owner.add-property') }}" class="btn btn-primary mb-3">
        + Tambah Properti
    </a>

    <!-- Pesan Sukses -->
    @if(session('success'))
    <div class="alert alert-success alert-dismissible fade show" role="alert">
        {{ session('success') }}
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    </div>
    @endif

    <!-- Tabel Properti -->
    @if (empty($properties))
    <div class="alert alert-info">
        Belum ada properti yang ditambahkan.
    </div>
    @else
    <div class="table-responsive">
        <table class="table table-bordered align-middle">
            <thead class="table-light">
                <tr>
                    <th>#</th>
                    <th>Nama Properti</th>
                    <th>Deskripsi</th>
                    <th>Harga</th>
                    <th>Lokasi</th>
                    <th>Aksi</th>
                </tr>
            </thead>
            <tbody>
                @foreach ($properties as $property)
                <tr>
                    <td>{{ $loop->iteration }}</td>
                    <td>{{ $property->name }}</td>
                    <td>{{ Str::limit($property->description, 100) }}</td>
                    <td>Rp {{ number_format($property->price, 0, ',', '.') }}</td>
                    <td>
                        {{ $property->province->name ?? '-' }},
                        {{ $property->city->name ?? '-' }},
                        {{ $property->district->name ?? '-' }},
                        {{ $property->subdistrict->name ?? '-' }}
                    </td>
                    <td>
                        <a href="{{ route('owner.edit-property', $property->id) }}" class="btn btn-warning btn-sm">
                            Edit
                        </a>
                        <form action="{{ route('owner.delete-property', $property->id) }}" method="POST" style="display:inline;" onsubmit="return confirm('Yakin ingin menghapus properti ini?');">
                            @csrf
                            @method('DELETE')
                            <button type="submit" class="btn btn-danger btn-sm">
                                Hapus
                            </button>
                        </form>
                    </td>
                </tr>
                @endforeach
            </tbody>
        </table>
    </div>
    @endif
</div>
@endsection