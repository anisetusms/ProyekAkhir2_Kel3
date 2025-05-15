@extends('layouts.index-superadmin')
@section('title' , 'Dashboard')

@section('content')
<main class="p-4" style="background-color: #f5f5f5;">
  <div class="container-fluid">
    <p class="text-sm text-muted">Today is {{ \Carbon\Carbon::now()->format('l, M. d, Y') }}</p>
    <h2 class="fw-bold">Welcome, {{ Auth::user()->name }}!</h2>

    <!-- Info Cards -->
    <div class="row mb-4">
      <div class="col-md-4 mb-3">
        <div class="card text-white text-center shadow-sm py-3" style="background-color: #3f51b5; border-radius: 1rem;">
          <h4 class="fw-bold">{{ $bookings->count() }}</h4>
          <p class="mb-0">Pemesanan</p>
        </div>
      </div>
      <div class="col-md-4 mb-3">
        <div class="card text-white text-center shadow-sm py-3" style="background-color: #4caf50; border-radius: 1rem;">
          <h4 class="fw-bold">{{ $totalProperties }}</h4>
          <p class="mb-0">Total Property</p>
        </div>
      </div>
      <div class="col-md-4 mb-3">
        <div class="card text-white text-center shadow-sm py-3" style="background-color: #ffc107; border-radius: 1rem;">
          <h4 class="fw-bold">{{ $totalBookings }}</h4>
          <p class="mb-0">Total Booking</p>
        </div>
      </div>
    </div>

    <!-- Booking Table -->
    <div class="card shadow-sm mb-4">
      <div class="card-body">
        <h5 class="card-title mb-3 fw-bold">Daftar Booking Terbaru</h5>
        <div class="table-responsive rounded-4">
          <table class="table table-hover align-middle mb-0 border rounded-4 overflow-hidden" id="bookingTable">
            <thead class="table-light">
              <tr class="align-middle text-center">
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
              @forelse ($bookings as $b)
              <tr class="text-center">
                <td>{{ $b->id }}</td>
                <td>{{ $b->user->name ?? '-' }}</td>
                <td>{{ $b->user->nik ?? '-' }}</td>
                <td>{{ $b->user->phone ?? '-' }}</td>
                <td>{{ $b->check_in }}</td>
                <td>{{ $b->check_out }}</td>
                <td>
<span class="badge text-white rounded-pill
  @if($b->status == 'confirmed') bg-primary
  @elseif($b->status == 'completed') bg-success
  @elseif($b->status == 'cancelled') bg-danger
  @else bg-secondary
  @endif">
  {{ ucfirst($b->status) }}
</span>

                </td>
                <td>{{ $b->property->name ?? '-' }}</td>
              </tr>
              @empty
              <tr>
                <td colspan="8" class="text-center text-muted">Tidak ada data booking.</td>
              </tr>
              @endforelse
            </tbody>
          </table>
        </div>

        <!-- Pagination Controls -->
        <div class="d-flex justify-content-between align-items-center mt-3">
          <button id="prevPage" class="btn btn-outline-primary btn-sm">Sebelumnya</button>
          <span id="pageIndicator" class="small text-muted"></span>
          <button id="nextPage" class="btn btn-outline-primary btn-sm">Berikutnya</button>
        </div>
      </div>
    </div>
  </div>
</main>

<!-- Pagination Script -->
<script>
  document.addEventListener('DOMContentLoaded', function () {
    const rows = document.querySelectorAll('#bookingTable tbody tr');
    const rowsPerPage = 10;
    let currentPage = 1;
    const totalPages = Math.ceil(rows.length / rowsPerPage);
    const pageIndicator = document.getElementById('pageIndicator');

    function showPage(page) {
      const start = (page - 1) * rowsPerPage;
      const end = start + rowsPerPage;

      rows.forEach((row, index) => {
        row.style.display = (index >= start && index < end) ? '' : 'none';
      });

      pageIndicator.textContent = Halaman ${page} dari ${totalPages};
      document.getElementById('prevPage').disabled = page === 1;
      document.getElementById('nextPage').disabled = page === totalPages;
    }

    document.getElementById('prevPage').addEventListener('click', () => {
      if (currentPage > 1) {
        currentPage--;
        showPage(currentPage);
      }
    });

    document.getElementById('nextPage').addEventListener('click', () => {
      if (currentPage < totalPages) {
        currentPage++;
        showPage(currentPage);
      }
    });

    showPage(currentPage); // Initial display
  });
</script>
@endsection