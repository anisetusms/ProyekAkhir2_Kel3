@extends('layouts.admin')

@section('title', 'Detail Pemesanan #' . $booking->id)

@section('action_button')
<a href="{{ route('admin.properties.bookings.index') }}" class="d-none d-sm-inline-block btn btn-sm btn-secondary shadow-sm">
    <i class="fas fa-arrow-left fa-sm text-white-50"></i> Kembali
</a>
@endsection

@section('content')
<div class="row">
    <div class="col-lg-8">
        <!-- Booking Details Card -->
        <div class="card shadow mb-4">
            <div class="card-header py-3 d-flex flex-row align-items-center justify-content-between">
                <h6 class="m-0 font-weight-bold text-primary">Detail Pemesanan</h6>
                <div>
                    @if($booking->status == 'pending')
                        <span class="badge badge-warning">Menunggu</span>
                    @elseif($booking->status == 'confirmed')
                        <span class="badge badge-success">Dikonfirmasi</span>
                    @elseif($booking->status == 'completed')
                        <span class="badge badge-info">Selesai</span>
                    @elseif($booking->status == 'cancelled')
                        <span class="badge badge-danger">Dibatalkan</span>
                    @endif
                </div>
            </div>
            <div class="card-body">
                <div class="row mb-4">
                    <div class="col-md-6">
                        <h5 class="font-weight-bold">Informasi Pemesanan</h5>
                        <p>
                            <strong>ID Pemesanan:</strong> #{{ $booking->id }}<br>
                            <strong>Tanggal Pemesanan:</strong> {{ \Carbon\Carbon::parse($booking->created_at)->format('d M Y, H:i') }}<br>
                            <strong>Status:</strong> 
                            @if($booking->status == 'pending')
                                <span class="badge badge-warning">Menunggu</span>
                            @elseif($booking->status == 'confirmed')
                                <span class="badge badge-success">Dikonfirmasi</span>
                            @elseif($booking->status == 'completed')
                                <span class="badge badge-info">Selesai</span>
                            @elseif($booking->status == 'cancelled')
                                <span class="badge badge-danger">Dibatalkan</span>
                            @endif
                        </p>
                    </div>
                    <div class="col-md-6">
                        <h5 class="font-weight-bold">Informasi Properti</h5>
                        <p>
                            <strong>Nama Properti:</strong> {{ $booking->property->name }}<br>
                            <strong>Alamat:</strong> {{ $booking->property->address }}<br>
                            <strong>Tipe Properti:</strong> {{ $booking->property->propertyType->name ?? 'Tidak tersedia' }}
                        </p>
                    </div>
                </div>

                <div class="row mb-4">
                    <div class="col-md-6">
                        <h5 class="font-weight-bold">Informasi Tamu</h5>
                        <p>
                            <strong>Nama:</strong> {{ $booking->guest_name }}<br>
                            <strong>Telepon:</strong> {{ $booking->guest_phone }}<br>
                            <strong>No. KTP:</strong> {{ $booking->identity_number ?? 'Tidak tersedia' }}
                        </p>
                    </div>
                    <div class="col-md-6">
                        <h5 class="font-weight-bold">Informasi Tanggal</h5>
                        <p>
                            <strong>Check-in:</strong> {{ \Carbon\Carbon::parse($booking->check_in)->format('d M Y') }}<br>
                            <strong>Check-out:</strong> {{ \Carbon\Carbon::parse($booking->check_out)->format('d M Y') }}<br>
                            <strong>Durasi:</strong> {{ \Carbon\Carbon::parse($booking->check_in)->diffInDays(\Carbon\Carbon::parse($booking->check_out)) }} hari
                        </p>
                    </div>
                </div>

                @if($booking->rooms->isNotEmpty())
                <div class="mb-4">
                    <h5 class="font-weight-bold">Kamar yang Dipesan</h5>
                    <div class="table-responsive">
                        <table class="table table-bordered">
                            <thead>
                                <tr>
                                    <th>No. Kamar</th>
                                    <th>Tipe Kamar</th>
                                    <th>Harga</th>
                                </tr>
                            </thead>
                            <tbody>
                                @foreach($booking->rooms as $room)
                                <tr>
                                    <td>{{ $room->room_number }}</td>
                                    <td>{{ $room->room_type }}</td>
                                    <td>{{ 'Rp ' . number_format($room->pivot->price, 0, ',', '.') }}</td>
                                </tr>
                                @endforeach
                            </tbody>
                        </table>
                    </div>
                </div>
                @endif

                @if($booking->special_requests)
                <div class="mb-4">
                    <h5 class="font-weight-bold">Permintaan Khusus</h5>
                    <div class="card bg-light">
                        <div class="card-body">
                            {{ $booking->special_requests }}
                        </div>
                    </div>
                </div>
                @endif

                <div class="row">
                    <div class="col-md-6">
                        <h5 class="font-weight-bold">Informasi Pembayaran</h5>
                        <p>
                            <strong>Total Harga:</strong> {{ 'Rp ' . number_format($booking->total_price, 0, ',', '.') }}<br>
                            <strong>Status Pembayaran:</strong> 
                            @if($booking->payment_proof)
                                <span class="badge badge-success">Bukti Pembayaran Diunggah</span>
                            @else
                                <span class="badge badge-warning">Menunggu Pembayaran</span>
                            @endif
                        </p>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="col-lg-4">
        <!-- Action Card -->
        <div class="card shadow mb-4">
            <div class="card-header py-3">
                <h6 class="m-0 font-weight-bold text-primary">Tindakan</h6>
            </div>
            <div class="card-body">
                @if($booking->status == 'pending')
                <div class="mb-3">
                    <button type="button" class="btn btn-success btn-block" data-toggle="modal" data-target="#confirmBookingModal">
                        <i class="fas fa-check mr-1"></i> Konfirmasi Pemesanan
                    </button>
                </div>
                <div class="mb-3">
                    <button type="button" class="btn btn-danger btn-block" data-toggle="modal" data-target="#rejectBookingModal">
                        <i class="fas fa-times mr-1"></i> Tolak Pemesanan
                    </button>
                </div>
                @elseif($booking->status == 'confirmed')
                <div class="mb-3">
                    <button type="button" class="btn btn-primary btn-block" data-toggle="modal" data-target="#completeBookingModal">
                        <i class="fas fa-check-double mr-1"></i> Selesaikan Pemesanan
                    </button>
                </div>
                @endif
                <div>
                    <a href="{{ route('admin.properties.bookings.index') }}" class="btn btn-secondary btn-block">
                        <i class="fas fa-arrow-left mr-1"></i> Kembali ke Daftar
                    </a>
                </div>
            </div>
        </div>

        <!-- KTP Image Card -->
        @if($booking->ktp_image)
        <div class="card shadow mb-4">
            <div class="card-header py-3">
                <h6 class="m-0 font-weight-bold text-primary">Foto KTP</h6>
            </div>
            <div class="card-body">
                <img src="{{ asset('storage/' . $booking->ktp_image) }}" class="img-fluid" alt="KTP">
            </div>
        </div>
        @endif

        <!-- Payment Proof Card -->
        @if($booking->payment_proof)
        <div class="card shadow mb-4">
            <div class="card-header py-3">
                <h6 class="m-0 font-weight-bold text-primary">Bukti Pembayaran</h6>
            </div>
            <div class="card-body">
                <img src="{{ asset('storage/' . $booking->payment_proof) }}" class="img-fluid" alt="Bukti Pembayaran">
            </div>
        </div>
        @endif
    </div>
</div>

<!-- Confirm Booking Modal -->
<div class="modal fade" id="confirmBookingModal" tabindex="-1" role="dialog" aria-labelledby="confirmBookingModalLabel" aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="confirmBookingModalLabel">Konfirmasi Pemesanan</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                Apakah Anda yakin ingin mengonfirmasi pemesanan ini?
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-dismiss="modal">Batal</button>
                <form action="{{ route('admin.properties.bookings.confirm', $booking->id) }}" method="POST">
                    @csrf
                    <button type="submit" class="btn btn-success">Konfirmasi</button>
                </form>
            </div>
        </div>
    </div>
</div>

<!-- Reject Booking Modal -->
<div class="modal fade" id="rejectBookingModal" tabindex="-1" role="dialog" aria-labelledby="rejectBookingModalLabel" aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="rejectBookingModalLabel">Tolak Pemesanan</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                Apakah Anda yakin ingin menolak pemesanan ini?
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-dismiss="modal">Batal</button>
                <form action="{{ route('admin.properties.bookings.reject', $booking->id) }}" method="POST">
                    @csrf
                    <button type="submit" class="btn btn-danger">Tolak</button>
                </form>
            </div>
        </div>
    </div>
</div>

<!-- Complete Booking Modal -->
<div class="modal fade" id="completeBookingModal" tabindex="-1" role="dialog" aria-labelledby="completeBookingModalLabel" aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="completeBookingModalLabel">Selesaikan Pemesanan</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                Apakah Anda yakin ingin menyelesaikan pemesanan ini?
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-dismiss="modal">Batal</button>
                <form action="{{ route('admin.properties.bookings.complete', $booking->id) }}" method="POST">
                    @csrf
                    <button type="submit" class="btn btn-primary">Selesaikan</button>
                </form>
            </div>
        </div>
    </div>
</div>
@endsection
