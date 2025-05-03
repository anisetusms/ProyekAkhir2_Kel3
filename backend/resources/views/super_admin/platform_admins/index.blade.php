@extends('layouts.index-superadmin')

@section('content')
<div class="container py-5">
    <h1>Daftar Admin Platform</h1>

    @if(session('success'))
        <div class="alert alert-success">{{ session('success') }}</div>
    @endif

    @if(session('error'))
        <div class="alert alert-danger">{{ session('error') }}</div>
    @endif

    <div class="mb-3">
    <a href="{{ route('super_admin.platform_admins.create') }}" class="btn btn-primary">Tambah Admin Platform</a>
    </div>

    <table class="table table-bordered">
        <thead>
            <tr>
                <th>#</th>
                <th>Nama</th>
                <th>Email</th>
                <th>Username</th>
                <th>Dibuat Pada</th>
                <th>Aksi</th>
            </tr>
        </thead>
        <tbody>
            @foreach($platformAdmins as $admin)
                <tr>
                    <td>{{ $loop->iteration }}</td>
                    <td>{{ $admin->name }}</td>
                    <td>{{ $admin->email }}</td>
                    <td>{{ $admin->username }}</td>
                    <td>{{ $admin->created_at }}</td>
                    <td>
                        <a href="{{ route('super_admin.platform_admins.edit', $admin->id) }}" class="btn btn-sm btn-warning">Edit</a>
                        <form action="{{ route('super_admin.platform_admins.delete', $admin->id) }}" method="POST" class="d-inline">
                            @csrf
                            @method('DELETE')
                            <button type="submit" class="btn btn-sm btn-danger" onclick="return confirm('Apakah Anda yakin ingin menghapus admin ini?')">Hapus</button>
                        </form>
                    </td>
                </tr>
            @endforeach
        </tbody>
    </table>
</div>
@endsection