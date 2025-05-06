@extends('layouts.index-superadmin')

@section('content')
<div class="container py-5">
    <div class="row justify-content-center">
        <div class="col-md-8">
            {{-- Heading --}}
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h2 class="mb-0"><i class="fas fa-user-shield me-2"></i>Profil Super Admin</h2>
                <a href="{{ route('super_admin.dashboard') }}" class="btn btn-outline-secondary">
                    <i class="fas fa-arrow-left me-1"></i> Kembali
                </a>
            </div>

            {{-- Success Message --}}
            @if(session('success'))
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    {{ session('success') }}
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            @endif

            {{-- Error Messages --}}
            @if ($errors->any())
                <div class="alert alert-danger">
                    <ul class="mb-0">
                        @foreach ($errors->all() as $error)
                            <li><i class="fas fa-exclamation-circle me-2"></i>{{ $error }}</li>
                        @endforeach
                    </ul>
                </div>
            @endif

            {{-- Profile Card --}}
            <div class="card shadow-sm border-0">
                <div class="card-body">
                    <table class="table table-borderless mb-0">
                        <tr>
                            <th style="width: 30%;"><i class="fas fa-user me-2"></i>Nama</th>
                            <td>{{ $admin->name }}</td>
                        </tr>
                        <tr>
                            <th><i class="fas fa-envelope me-2"></i>Email</th>
                            <td>{{ $admin->email }}</td>
                        </tr>
                        <tr>
                            <th><i class="fas fa-user-tag me-2"></i>Username</th>
                            <td>{{ $admin->username }}</td>
                        </tr>
                    </table>
                </div>
                <div class="card-footer bg-white text-end">
                    <a href="{{ route('super_admin.profiles.edit') }}" class="btn btn-warning">
                        <i class="fas fa-edit me-1"></i> Edit Profil
                    </a>
                </div>
            </div>
        </div>
    </div>
</div>
@endsection
