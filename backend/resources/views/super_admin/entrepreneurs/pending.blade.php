@extends('layouts.index-superadmin')
@section('title', 'Daftar Owner yang Menunggu Persetujuan')

@section('content')
@foreach ($pendingOwners as $owner)
<div class="dropdown-item d-flex align-items-center">
    <div class="mr-3">
        <div class="icon-circle bg-primary">
            <i class="fas fa-user-clock text-white"></i>
        </div>
    </div>
    <div>
        <div class="small text-gray-500">
            @if (!empty($owner->created_at))
            {{ \Carbon\Carbon::parse($owner->created_at)->diffForHumans() }}
            @else
            Tidak diketahui
            @endif
        </div>
        <span class="font-weight-bold">Owner baru membutuhkan persetujuan.</span>
        <div class="mt-2">
            <p><strong>Nama:</strong> {{ $owner->name }}</p>
            <p><strong>Email:</strong> {{ $owner->email }}</p>
        </div>
    </div>

    <!-- Form untuk menyetujui Owner -->
    <form action="{{ route('super_admin.entrepreneurs.approve', $owner->id) }}" method="POST" style="display: inline;">
        @csrf
        @method('PUT')
        <button type="submit" class="btn btn-success btn-sm">Setujui</button>
    </form>
</div>
@endforeach
@endsection