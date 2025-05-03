<!-- filepath: e:\KULIAH\SEMESTER 4\PA2\PA2\PA2\resources\views\platform_admin\index.blade.php -->
@extends('layouts.app')

@section('content')
<div class="container py-5">
    <h2 class="text-center mb-4">Daftar Pengguna (Owner dan Penyewa)</h2>

    <table class="table table-bordered table-hover">
        <thead class="table-light">
            <tr>
                <th>#</th>
                <th>Nama</th>
                <th>Email</th>
                <th>Role</th>
                <th>Status</th>
                <th>Aksi</th>
            </tr>
        </thead>
        <tbody>
            @foreach ($users as $user)
            <tr>
                <td>{{ $loop->iteration }}</td>
                <td>{{ $user->username }}</td>
                <td>{{ $user->email }}</td>
                <td>
                    @if ($user->user_role_id == 2)
                        Owner
                    @elseif ($user->user_role_id == 3)
                        Penyewa
                    @endif
                </td>
                <td>
                    @if ($user->is_banned)
                        <span class="badge bg-danger">Banned</span>
                    @else
                        <span class="badge bg-success">Aktif</span>
                    @endif
                </td>
                <td>
                    @if ($user->is_banned)
                        <form action="{{ route('platform_admin.unban', $user->id) }}" method="POST" class="d-inline">
                            @csrf
                            <button type="submit" class="btn btn-sm btn-success"><i class="fas fa-check"></i> Unban</button>
                        </form>
                    @else
                        <form action="{{ route('platform_admin.ban', $user->id) }}" method="POST" class="d-inline">
                            @csrf
                            <button type="submit" class="btn btn-sm btn-danger"><i class="fas fa-ban"></i> Ban</button>
                        </form>
                    @endif
                </td>
            </tr>
            @endforeach
        </tbody>
    </table>
</div>
@endsection