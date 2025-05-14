@extends('layouts.index-superadmin')
@section('title', 'Menunggu Persetujuan')

@section('content')
<div class="card shadow mb-4">
    <div class="card-header py-3">
        <h6 class="m-0 font-weight-bold text-primary">
            <i class="fas fa-user-clock fa-sm fa-fw mr-2 text-gray-400"></i>
            Owner Baru Menunggu Persetujuan
        </h6>
    </div>
    <div class="card-body">
        @if ($pendingOwners->isEmpty())
            <p class="text-info">Tidak ada owner baru yang menunggu persetujuan saat ini.</p>
        @else
            <div class="table-responsive">
                <table class="table table-bordered" id="dataTable" width="100%" cellspacing="0">
                    <thead>
                        <tr>
                            <th>Nama</th>
                            <th>Email</th>
                            <th>Diajukan</th>
                            <th class="text-center">Aksi</th>
                        </tr>
                    </thead>
                    <tbody>
                        @foreach ($pendingOwners as $owner)
                            <tr>
                                <td>{{ $owner->name }}</td>
                                <td>{{ $owner->email }}</td>
                                <td>
                                    @if (!empty($owner->created_at))
                                        {{ \Carbon\Carbon::parse($owner->created_at)->diffForHumans() }}
                                    @else
                                        Tidak diketahui
                                    @endif
                                </td>
                                <td class="text-center">
                                    <form action="{{ route('super_admin.entrepreneurs.approve', $owner->id) }}" method="POST" style="display: inline;">
                                        @csrf
                                        @method('PUT')
                                        <button type="submit" class="btn btn-success btn-sm">
                                           <i class="fas fa-check-circle fa-sm me-1"></i>Setujui
                                        </button>
                                      
                                    </form>
                                    </td>
                            </tr>
                        @endforeach
                    </tbody>
                </table>
            </div>
        @endif
    </div>
</div>
@endsection

@push('scripts')
<script>
    $(document).ready(function() {
        $('#dataTable').DataTable();
    });
</script>
@endpush