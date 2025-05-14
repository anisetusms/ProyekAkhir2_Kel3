@extends('layouts.index-superadmin')

@section('content')
<div class="container py-5">
    <div class="row justify-content-center">
        <div class="col-md-8">

            {{-- Heading --}}
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h2 class="text-primary mb-0">
                    <i class="fas fa-user-shield me-2 text-primary"></i>Profil Super Admin
                </h2>
                <a href="{{ route('super_admin.dashboard') }}" class="btn btn-outline-secondary">
                    <i class="fas fa-arrow-left me-1"></i> Kembali
                </a>
            </div>

            {{-- Success Message --}}
            @if(session('success'))
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    <i class="fas fa-check-circle me-2"></i>{{ session('success') }}
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            @endif

            {{-- Error Messages --}}
            @if ($errors->any())
                <div class="alert alert-danger">
                    <ul class="mb-0">
                        @foreach ($errors->all() as $error)
                            <li><i class="fas fa-exclamation-circle me-2 text-danger"></i>{{ $error }}</li>
                        @endforeach
                    </ul>
                </div>
            @endif

            {{-- Profile Card --}}
            <div class="card shadow border-0 rounded-3">
                <div class="card-body">
                    <table class="table table-borderless mb-0">
                        <tr>
                            <th class="text-muted" style="width: 30%;">
                                <i class="fas fa-user me-2 text-primary"></i>Nama
                            </th>
                            <td class="fw-semibold">{{ $admin->name }}</td>
                        </tr>
                        <tr>
                            <th class="text-muted">
                                <i class="fas fa-envelope me-2 text-info"></i>Email
                            </th>
                            <td class="fw-semibold">{{ $admin->email }}</td>
                        </tr>
                        <tr>
                            <th class="text-muted">
                                <i class="fas fa-user-tag me-2 text-warning"></i>Username
                            </th>
                            <td class="fw-semibold">{{ $admin->username }}</td>
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
