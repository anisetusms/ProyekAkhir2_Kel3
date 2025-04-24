@extends('layouts.index-superadmin')

@section('content')
<main class="p-4">
  <div class="container-fluid">
    <p class="text-sm text-muted">Today is {{ \Carbon\Carbon::now()->format('l, M. d, Y') }}</p>
    <h2 class="fw-bold">Welcome, {{ Auth::user()->name }}!</h2>
    <p class="mb-4">Dashboard</p>

    <div class="row mb-4">
      <div class="col-md-4 mb-3">
        <div class="card shadow-sm text-center py-3">
          <h4 class="text-success fw-bold">{{ $bookings->count() }}</h4>
          <p class="text-muted">Pemesanan</p>
        </div>
      </div>
      <div class="col-md-4 mb-3">
        <div class="card shadow-sm text-center py-3">
          <h4 class="text-success fw-bold">{{ $totalProperties }}</h4>
          <p class="text-muted">Total Property</p>
        </div>
      </div>
      <div class="col-md-4 mb-3">
        <div class="card shadow-sm text-center py-3">
          <h4 class="text-success fw-bold">{{ $totalBookings }}</h4>
          <p class="text-muted">Total Booking</p>
        </div>
      </div>
    </div>
    <div class="card shadow-sm">
      <div class="card-body">
        <h5 class="card-title mb-3">Booking</h5>
        <div class="table-responsive">
          <table class="table table-bordered table-hover">
            <thead class="table-light">
              <tr>
                <th>BookingID</th>
                <th>Nama</th>
                <th>NIK</th>
                <th>Kontak</th>
                <th>Check-In</th>
                <th>Check-Out</th>
                <th>Status</th>
                <th>Properti</th>
                <th>Action</th>
              </tr>
            </thead>
            <tbody>
              @foreach ($bookings as $b)
              <tr>
                <td>{{ $b->id }}</td>
                <td>{{ $b->user->name ?? '-' }}</td>
                <td>{{ $b->user->nik ?? '-' }}</td>
                <td>{{ $b->user->phone ?? '-' }}</td>
                <td>{{ $b->check_in }}</td>
                <td>{{ $b->check_out }}</td>
                <td>{{ ucfirst($b->status) }}</td>
                <td>{{ $b->property->name ?? '-' }}</td>
                <td>
                  <a href="#" class="text-primary me-2"><i class="bi bi-pencil-square"></i></a>
                  <a href="#" class="text-danger"><i class="bi bi-trash"></i></a>
                </td>
              </tr>
              @endforeach
            </tbody>
          </table>
        </div>
      </div>
    </div>
  </div>
</main>
@endsection