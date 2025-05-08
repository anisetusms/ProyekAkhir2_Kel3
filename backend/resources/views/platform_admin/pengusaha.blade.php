@extends('layouts.index-adminplatform')

@section('content')
<div class="container py-5">
    <div class="row">
        <div class="col">
            <h1 class="mb-4 text-center">Daftar Pengusaha</h1>
        </div>
    </div>

    <!-- Owner Aktif -->
    <div class="row mb-5">
        <div class="col">
            <div class="card shadow">
                <div class="card-header bg-success text-white">
                    <h5 class="mb-0">Owner Aktif</h5>
                </div>
                <div class="card-body p-0">
                    <ul class="list-group list-group-flush">
                        @forelse ($activeOwners as $owner)
                            <li class="list-group-item d-flex justify-content-between align-items-center">
                                <div>
                                    <strong>{{ $owner->username }}</strong><br>
                                    <small>{{ $owner->email }}</small>
                                </div>
                                <div class="d-flex">
                                    <!-- Detail Button -->
                                    <a href="{{ route('platform_admin.show', $owner->id) }}"
                                       class="btn btn-sm btn-outline-primary"
                                       data-bs-toggle="tooltip"
                                       title="Detail">
                                        <i class="fas fa-eye"></i>
                                    </a>
                                    
                                    <!-- Ban Button -->
                                    <form action="{{ route('platform_admin.ban', $owner->id) }}" method="POST">
                                        @csrf
                                        <button type="submit" class="btn btn-outline-danger btn-sm ms-2" title="Ban">
                                            <i class="fas fa-user-slash"></i>
                                        </button>
                                    </form>
                                </div>
                            </li>
                        @empty
                            <li class="list-group-item text-center text-muted">Tidak ada owner aktif.</li>
                        @endforelse
                    </ul>
                </div>
            </div>
        </div>
    </div>

    <!-- Owner Dibanned -->
    <div class="row">
        <div class="col">
            <div class="card shadow">
                <div class="card-header bg-danger text-white">
                    <h5 class="mb-0">Owner Dibanned</h5>
                </div>
                <div class="card-body p-0">
                    <ul class="list-group list-group-flush">
                        @forelse ($bannedOwners as $owner)
                            <li class="list-group-item d-flex justify-content-between align-items-center">
                                <div>
                                    <strong>{{ $owner->username }}</strong><br>
                                    <small>{{ $owner->email }}</small>
                                </div>
                                <div class="d-flex">
                                    <!-- Detail Button -->
                                    <a href="{{ route('platform_admin.show', $owner->id) }}"
                                       class="btn btn-sm btn-outline-primary"
                                       data-bs-toggle="tooltip"
                                       title="Detail">
                                        <i class="fas fa-eye"></i>
                                    </a>
                                    
                                    <!-- Unban Button -->
                                    <form action="{{ route('platform_admin.unban', $owner->id) }}" method="POST">
                                        @csrf
                                        <button type="submit" class="btn btn-outline-success btn-sm ms-2" title="Unban">
                                            <i class="fas fa-user-check"></i>
                                        </button>
                                    </form>
                                </div>
                            </li>
                        @empty
                            <li class="list-group-item text-center text-muted">Tidak ada owner yang dibanned.</li>
                        @endforelse
                    </ul>
                </div>
            </div>
        </div>
    </div>
</div>
@endsection
