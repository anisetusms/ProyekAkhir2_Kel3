<!-- filepath: e:\KULIAH\SEMESTER 4\PA2\PA2\PA2\resources\views\super_admin\entrepreneurs\index.blade.php -->
@extends('layouts.index-superadmin')

@section('content')
<div class="container py-5">
    <h1 class="mb-4">Daftar Akun Owner</h1>

    <!-- Tombol Tambah Akun -->
    <div class="mb-3">
        <a href="{{ route('super_admin.entrepreneurs.create') }}" class="btn btn-primary">
            <i class="bi bi-plus-circle"></i> Tambah Akun Owner Baru
        </a>
    </div>

    <!-- Tabel Data -->
    <div class="table-responsive">
        <table class="table table-bordered table-hover">
            <thead class="table-dark">
                <tr>
                    <th>ID</th>
                    <th>Nama</th>
                    <th>Email</th>
                    <th>Aksi</th>
                </tr>
            </thead>
            <tbody>
                @foreach($entrepreneurs as $entrepreneur)
                <tr>
                    <td>{{ $entrepreneur->id }}</td>
                    <td>{{ $entrepreneur->name }}</td>
                    <td>{{ $entrepreneur->email }}</td>
                    <td>
                        <!-- Tombol Edit -->
                        <a href="{{ route('super_admin.entrepreneurs.edit', $entrepreneur->id) }}" 
                           class="btn btn-warning btn-sm">
                            <i class="bi bi-pencil-square"></i> Edit
                        </a>

                        <form action="{{ route('super_admin.entrepreneurs.destroy', $entrepreneur->id) }}" 
                              method="POST" 
                              class="d-inline"
                              onsubmit="return confirm('Apakah Anda yakin ingin menghapus akun ini?');">
                            @csrf
                            @method('DELETE')
                            <button type="submit" class="btn btn-danger btn-sm">
                                <i class="bi bi-trash"></i> Hapus
                            </button>
                        </form>
                    </td>
                </tr>
                @endforeach
            </tbody>
        </table>
    </div>
</div>
@endsection