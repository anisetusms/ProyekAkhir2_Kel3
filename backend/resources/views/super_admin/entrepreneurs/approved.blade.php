@extends('layouts.index-superadmin')
@section('content')
    <div class="container-fluid py-4">
        <div class="card shadow-lg">
            <div class="card-header bg-primary text-white">
                <h3 class="mb-0"><i class="fas fa-user-check me-2"></i>Daftar Owner yang Sudah Disetujui</h3>
            </div>

            <div class="card-body">
                @if($approvedOwners->isEmpty())
                    <div class="alert alert-info text-center py-4">
                        <i class="fas fa-info-circle fa-2x mb-3"></i>
                        <h4>Tidak ada owner yang disetujui saat ini</h4>
                        <p class="mb-0">Semua permohonan owner akan muncul di sini setelah disetujui</p>
                    </div>
                @else
                    <div class="table-responsive">
                        <table class="table table-striped table-hover align-middle">
                            <thead class="table-light">
                                <tr>
                                    <th class="ps-4">Nama</th>
                                    <th>Email</th>
                                    <th>Username</th>
                                    <th>Status</th>
                                    <th class="text-center">Jumlah Properti</th>
                                    <th class="text-end pe-4">Aksi</th>
                                </tr>
                            </thead>
                            <tbody>
                                @foreach($approvedOwners as $owner)
                                    <tr>
                                        <td class="ps-4">
                                            <div class="d-flex align-items-center">
                                                <div class="avatar avatar-sm me-3 bg-gradient-dark rounded-circle d-flex align-items-center justify-content-center">
                                                    <span class="text-white">{{ substr($owner->name, 0, 1) }}</span>
                                                </div>
                                                <div>
                                                    <h6 class="mb-0">{{ $owner->name }}</h6>
                                                    <small class="text-muted">ID: {{ $owner->id }}</small>
                                                </div>
                                            </div>
                                        </td>
                                        <td>
                                            <a href="mailto:{{ $owner->email }}" class="text-primary">{{ $owner->email }}</a>
                                        </td>
                                        <td>{{ $owner->username }}</td>
                                        <td>
                                            <span class="badge bg-success rounded-pill">
                                                <i class="fas fa-check-circle me-1"></i> Disetujui
                                            </span>
                                        </td>
                                        <td class="text-center">
                                            <span class="badge bg-info rounded-pill">
                                                {{ $owner->properties_count }} Properti
                                            </span>
                                        </td>
                                        <td class="text-end pe-4">
                                            <div class="btn-group" role="group">
                                                <a href="{{ route('super_admin.entrepreneurs.show', $owner->id) }}" 
                                                   class="btn btn-sm btn-outline-info" 
                                                   data-bs-toggle="tooltip" 
                                                   title="Detail">
                                                    <i class="fas fa-eye"></i>
                                                </a>
                                                <a href="{{ route('super_admin.entrepreneurs.edit', $owner->id) }}" 
                                                   class="btn btn-sm btn-outline-warning" 
                                                   data-bs-toggle="tooltip" 
                                                   title="Edit">
                                                    <i class="fas fa-edit"></i>
                                                </a>
                                                <form action="{{ route('super_admin.entrepreneurs.destroy', $owner->id) }}" 
                                                      method="POST" 
                                                      class="d-inline"
                                                      onsubmit="return confirm('Apakah Anda yakin ingin menghapus owner ini?')">
                                                    @csrf
                                                    @method('DELETE')
                                                    <button type="submit" 
                                                            class="btn btn-sm btn-outline-danger" 
                                                            data-bs-toggle="tooltip" 
                                                            title="Hapus">
                                                        <i class="fas fa-trash-alt"></i>
                                                    </button>
                                                </form>
                                            </div>
                                        </td>
                                    </tr>
                                @endforeach
                            </tbody>
                        </table>
                    </div>
                @endif
            </div>
        </div>
    </div>
@endsection

@section('scripts')
    <script>
        $(document).ready(function() {
            // Initialize tooltips
            $('[data-bs-toggle="tooltip"]').tooltip();
            
            // Refresh button
            $('#refreshBtn').click(function() {
                location.reload();
            });
        });
    </script>
@endsection

@section('styles')
    <style>
        .avatar {
            width: 40px;
            height: 40px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 600;
        }
        .card {
            border-radius: 12px;
            overflow: hidden;
            border: none;
            box-shadow: 0 4px 20px rgba(0,0,0,0.08);
        }
        .card-header {
            background-color: #0056b3;
            color: white;
            border-radius: 0 !important;
        }
        .table th {
            border-top: none;
            font-weight: 600;
            text-transform: uppercase;
            font-size: 0.85rem;
            letter-spacing: 0.5px;
        }
        .table td {
            vertical-align: middle;
            font-size: 0.85rem;
        }
        .badge {
            padding: 6px 12px;
            font-weight: 500;
            font-size: 0.9rem;
        }
        .btn-group .btn {
            border-radius: 8px !important;
            margin-right: 4px;
        }
        .btn-group .btn:last-child {
            margin-right: 0;
        }
        .text-primary {
            color: #007bff !important;
        }
    </style>
@endsection
