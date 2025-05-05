@extends('layouts.index-superadmin')

@section('title', 'Daftar Owner yang Sudah Disetujui')

@section('content')
    <div class="container">
        <h2>Daftar Owner yang Sudah Disetujui</h2>
        @if($approvedOwners->isEmpty())
            <p>Tidak ada owner yang disetujui saat ini.</p>
        @else
            <table class="table table-bordered">
                <thead>
                    <tr>
                        <th>Nama</th>
                        <th>Email</th>
                        <th>Username</th>
                        <th>Status</th>
                        <th>Aksi</th>
                    </tr>
                </thead>
                <tbody>
                    @foreach($approvedOwners as $owner)
                        <tr>
                            <td>{{ $owner->name }}</td>
                            <td>{{ $owner->email }}</td>
                            <td>{{ $owner->username }}</td>
                            <td><span class="badge badge-success">Disetujui</span></td>
                            <td>
                                <a href="{{ route('super_admin.entrepreneurs.edit', $owner->id) }}" class="btn btn-warning btn-sm">Edit</a>
                                <form action="{{ route('super_admin.entrepreneurs.destroy', $owner->id) }}" method="POST" style="display:inline;">
                                    @csrf
                                    @method('DELETE')
                                    <button type="submit" class="btn btn-danger btn-sm">Hapus</button>
                                </form>
                            </td>
                        </tr>
                    @endforeach
                </tbody>
            </table>
        @endif
    </div>
@endsection
