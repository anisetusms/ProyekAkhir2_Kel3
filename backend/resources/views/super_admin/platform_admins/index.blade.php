@extends('layouts.index-superadmin')
@section('title' , 'Daftar Admin Officier')


@section('content')
<div class="container py-5">
    <div class="card shadow-sm">
        <div class="card-header bg-primary text-white">
            <h5 class="mb-0"><i class="fas fa-users me-2"></i> Daftar Admin Officier</h5>
        </div>
        <div class="card-body">
            @if(session('success'))
            <div class="alert alert-success"><i class="fas fa-check-circle me-2"></i> {{ session('success') }}</div>
            @endif

            @if(session('error'))
            <div class="alert alert-danger"><i class="fas fa-exclamation-triangle me-2"></i> {{ session('error') }}</div>
            @endif

            <div class="mb-3">
                <a href="{{ route('super_admin.platform_admins.create') }}" class="btn btn-primary"><i class="fas fa-plus me-2"></i> Tambah Admin</a>
            </div>

            <div class="table-responsive">
                <table class="table table-bordered table-hover align-middle">
                    <thead>
                        <tr>
                            <th>#</th>
                            <th>Nama</th>
                            <th>Email</th>
                            <th>Username</th>
                            <th>Dibuat Pada</th>
                            <th class="text-center">Aksi</th>
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
                            <td class="text-center">
                                <a href="{{ route('super_admin.platform_admins.edit', $admin->id) }}"
                                    class="btn btn-sm btn-outline-warning"
                                    data-bs-toggle="tooltip"
                                    title="Edit">
                                    <i class="fas fa-edit"></i>
                                </a>
                                <form action="{{ route('super_admin.platform_admins.delete', $admin->id) }}" method="POST" class="d-inline">
                                    @csrf
                                    @method('DELETE')
                                    <button type="submit"
                                        class="btn btn-sm btn-outline-danger"
                                        data-bs-toggle="tooltip"
                                        title="Hapus"
                                        onclick="return confirm('Apakah Anda yakin ingin menghapus admin ini?')">
                                        <i class="fas fa-trash-alt"></i>
                                    </button>
                                </form>
                            </td>
                        </tr>
                        @endforeach
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>
@endsection

@push('styles')
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
@endpush