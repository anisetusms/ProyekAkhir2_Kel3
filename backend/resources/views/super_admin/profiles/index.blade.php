<!-- filepath: e:\KULIAH\SEMESTER 4\PA2\PA2\PA2\resources\views\super_admin\profiles\index.blade.php -->
@extends('layouts.index-superadmin')

@section('content')
<div class="container py-5">
    <h1>Profil Super Admin</h1>

    @if(session('success'))
        <div class="alert alert-success">{{ session('success') }}</div>
    @endif

    @if ($errors->any())
        <div class="alert alert-danger">
            <ul>
                @foreach ($errors->all() as $error)
                    <li>{{ $error }}</li>
                @endforeach
            </ul>
        </div>
    @endif

    <a href="{{ route('super_admin.dashboard') }}" class="btn btn-secondary mb-3">Kembali</a>

    <table class="table">
        <thead>
            <tr>
                <th>ID</th>
                <th>Nama</th>
                <th>Email</th>
                <th>Username</th>
                <th>Aksi</th>
            </tr>
        </thead>
        <tbody>
            <tr>
                <td>{{ $admin->id }}</td>
                <td>{{ $admin->name }}</td>
                <td>{{ $admin->email }}</td>
                <td>{{ $admin->username }}</td>
                <td>
                    <a href="{{ route('super_admin.profiles.edit') }}" class="btn btn-warning">Edit</a>
                </td>
            </tr>
        </tbody>
    </table>
</div>
@endsection