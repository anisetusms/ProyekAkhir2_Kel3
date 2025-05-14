@extends('layouts.index-superadmin')
@section('title' , 'Dashboard')

@section('content')
<main class="p-4" style="background-color: #f5f5f5;">
  <div class="container-fluid">
    <p class="text-sm text-muted">Today is {{ \Carbon\Carbon::now()->format('l, M. d, Y') }}</p>
    <h2 class="fw-bold">Welcome, {{ Auth::user()->name }}!</h2>
 

    <div class="row mb-4">
      <div class="col-md-4 mb-3">
        <div class="card text-white text-center shadow-sm py-3" style="background-color: #3f51b5;">
          <h4 class="fw-bold">{{ $bookings->count() }}</h4>
          <p class="mb-0">Pemesanan</p>
        </div>
      </div>
      <div class="col-md-4 mb-3">
        <div class="card text-white text-center shadow-sm py-3" style="background-color: #4caf50;">
          <h4 class="fw-bold">{{ $totalProperties }}</h4>
          <p class="mb-0">Total Property</p>
        </div>
      </div>
      <div class="col-md-4 mb-3">
        <div class="card text-white text-center shadow-sm py-3" style="background-color: #ffc107;">
          <h4 class="fw-bold">{{ $totalBookings }}</h4>
          <p class="mb-0">Total Booking</p>
        </div>
      </div>
    </div>

    <div class="card shadow-sm">
      <div class="card-body">
        <h5 class="card-title mb-3">Booking</h5>
        <div class="table-responsive">
          <table class="table table-bordered table-hover align-middle">
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
