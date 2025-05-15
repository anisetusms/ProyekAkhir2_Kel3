@extends('layouts.admin')

@section('title', 'Detail Ulasan')

@section('action_button')
<a href="{{ route('admin.properties.ulasan.index') }}" class="d-none d-sm-inline-block btn btn-sm btn-primary shadow-sm">
    <i class="fas fa-arrow-left fa-sm text-white-50"></i> Kembali ke Daftar
</a>
@endsection

@section('content')
<div class="row">
    <div class="col-lg-8">
        <!-- Detail Ulasan -->
        <div class="card shadow mb-4">
            <div class="card-header py-3 d-flex flex-row align-items-center justify-content-between">
                <h6 class="m-0 font-weight-bold text-primary">Detail Ulasan</h6>
            </div>
            <div class="card-body">
                <div class="mb-4">
                    <div class="d-flex align-items-center mb-3">
                        @if($review->booking->user->profile_picture)
                            <img src="{{ asset('storage/' . $review->booking->user->profile_picture) }}" alt="{{ $review->booking->user->name }}" class="img-profile rounded-circle mr-3" style="width: 60px; height: 60px;">
                        @else
                            <div class="bg-primary rounded-circle mr-3 d-flex align-items-center justify-content-center" style="width: 60px; height: 60px;">
                                <span class="text-white font-weight-bold" style="font-size: 24px;">{{ substr($review->booking->user->name, 0, 1) }}</span>
                            </div>
                        @endif
                        <div>
                            <h5 class="font-weight-bold mb-0">{{ $review->booking->user->name }}</h5>
                            <div class="text-muted">{{ $review->created_at->format('d M Y H:i') }}</div>
                            <div class="mt-1">
                                @for($i = 1; $i <= 5; $i++)
                                    @if($i <= $review->rating)
                                        <i class="fas fa-star text-warning"></i>
                                    @else
                                        <i class="far fa-star text-warning"></i>
                                    @endif
                                @endfor
                                <span class="ml-2 font-weight-bold">{{ $review->rating }}.0</span>
                            </div>
                        </div>
                    </div>
                    
                    <div class="p-4 bg-light rounded">
                        <p class="mb-0">{{ $review->comment }}</p>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <div class="col-lg-4">
        <!-- Informasi Properti -->
        <div class="card shadow mb-4">
            <div class="card-header py-3">
                <h6 class="m-0 font-weight-bold text-primary">Informasi Properti</h6>
            </div>
            <div class="card-body">
                <div class="text-center mb-3">
                    @if($review->property->image)
                        <img src="{{ asset('storage/' . $review->property->image) }}" alt="{{ $review->property->name }}" class="img-fluid rounded mb-3" style="max-height: 150px;">
                    @else
                        <div class="bg-gray-200 rounded mb-3 d-flex align-items-center justify-content-center" style="height: 150px;">
                            <i class="fas fa-home fa-3x text-gray-500"></i>
                        </div>
                    @endif
                    <h5 class="font-weight-bold">{{ $review->property->name }}</h5>
                    <p class="text-muted">{{ $review->property->address }}</p>
                </div>
                
                <div class="mb-3">
                    <div class="font-weight-bold mb-1">Tipe Properti</div>
                    <p>{{ $review->property->is_kost ? 'Kost' : 'Homestay' }}</p>
                </div>
                
                <div class="mb-3">
                    <div class="font-weight-bold mb-1">Harga</div>
                    <p>Rp {{ number_format($review->property->price, 0, ',', '.') }} / {{ $review->property->is_kost ? 'bulan' : 'malam' }}</p>
                </div>
                
                <a href="{{ route('admin.properties.show', $review->property->id) }}" class="btn btn-primary btn-block">
                    <i class="fas fa-eye"></i> Lihat Properti
                </a>
            </div>
        </div>
        
        <!-- Informasi Booking -->
        <div class="card shadow mb-4">
            <div class="card-header py-3">
                <h6 class="m-0 font-weight-bold text-primary">Informasi Booking</h6>
            </div>
            <div class="card-body">
                <div class="mb-3">
                    <div class="font-weight-bold mb-1">ID Booking</div>
                    <p>{{ $review->booking->booking_code }}</p>
                </div>
                
                <div class="mb-3">
                    <div class="font-weight-bold mb-1">Tanggal Check-in</div>
                    <p>{{ \Carbon\Carbon::parse($review->booking->check_in)->format('d M Y') }}</p>
                </div>
                
                <div class="mb-3">
                    <div class="font-weight-bold mb-1">Tanggal Check-out</div>
                    <p>{{ \Carbon\Carbon::parse($review->booking->check_out)->format('d M Y') }}</p>
                </div>
                
                <div class="mb-3">
                    <div class="font-weight-bold mb-1">Durasi</div>
                    <p>{{ \Carbon\Carbon::parse($review->booking->check_in)->diffInDays(\Carbon\Carbon::parse($review->booking->check_out)) }} hari</p>
                </div>
                
                <div class="mb-3">
                    <div class="font-weight-bold mb-1">Total Pembayaran</div>
                    <p>Rp {{ number_format($review->booking->total_price, 0, ',', '.') }}</p>
                </div>
                
                <a href="{{ route('admin.properties.bookings.show', $review->booking->id) }}" class="btn btn-info btn-block">
                    <i class="fas fa-calendar-check"></i> Lihat Detail Booking
                </a>
            </div>
        </div>
    </div>
</div>
@endsection
