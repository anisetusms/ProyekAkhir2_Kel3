@extends('layouts.admin')

@section('title', 'Ulasan ' . $property->name)

@section('action_button')
<a href="{{ route('admin.properties.ulasan.index') }}" class="d-none d-sm-inline-block btn btn-sm btn-primary shadow-sm">
    <i class="fas fa-arrow-left fa-sm text-white-50"></i> Kembali ke Daftar
</a>
@endsection

@section('content')
<div class="card shadow mb-4">
    <div class="card-header py-3 d-flex flex-row align-items-center justify-content-between">
        <h6 class="m-0 font-weight-bold text-primary">Informasi Properti</h6>
    </div>
    <div class="card-body">
        <div class="row">
            <div class="col-md-3 text-center">
                @if($property->image)
                    <img src="{{ asset('storage/' . $property->image) }}" alt="{{ $property->name }}" class="img-fluid rounded mb-3" style="max-height: 150px;">
                @else
                    <div class="bg-gray-200 rounded mb-3 d-flex align-items-center justify-content-center" style="height: 150px;">
                        <i class="fas fa-home fa-3x text-gray-500"></i>
                    </div>
                @endif
            </div>
            <div class="col-md-9">
                <h4 class="font-weight-bold">{{ $property->name }}</h4>
                <p class="text-muted">{{ $property->address }}</p>
                
                <div class="row mt-3">
                    <div class="col-md-4">
                        <div class="font-weight-bold mb-1">Tipe Properti</div>
                        <p>{{ $property->is_kost ? 'Kost' : 'Homestay' }}</p>
                    </div>
                    <div class="col-md-4">
                        <div class="font-weight-bold mb-1">Harga</div>
                        <p>Rp {{ number_format($property->price, 0, ',', '.') }} / {{ $property->is_kost ? 'bulan' : 'malam' }}</p>
                    </div>
                    <div class="col-md-4">
                        <div class="font-weight-bold mb-1">Rating</div>
                        <div class="d-flex align-items-center">
                            <span class="font-weight-bold mr-2">{{ number_format($reviews->avg('rating'), 1) }}</span>
                            <div>
                                @for($i = 1; $i <= 5; $i++)
                                    @if($i <= round($reviews->avg('rating')))
                                        <i class="fas fa-star text-warning"></i>
                                    @else
                                        <i class="far fa-star text-warning"></i>
                                    @endif
                                @endfor
                            </div>
                            <span class="ml-2 text-muted">({{ $reviews->total() }} ulasan)</span>
                        </div>
                    </div>
                </div>
                
                <div class="mt-3">
                    <a href="{{ route('admin.properties.show', $property->id) }}" class="btn btn-primary">
                        <i class="fas fa-eye"></i> Lihat Properti
                    </a>
                </div>
            </div>
        </div>
    </div>
</div>

<div class="card shadow mb-4">
    <div class="card-header py-3 d-flex flex-row align-items-center justify-content-between">
        <h6 class="m-0 font-weight-bold text-primary">Daftar Ulasan</h6>
    </div>
    <div class="card-body">
        @if($reviews->isEmpty())
            <div class="text-center py-5">
                <i class="fas fa-comment-slash fa-4x text-gray-300 mb-3"></i>
                <p class="text-gray-500">Belum ada ulasan untuk properti ini</p>
            </div>
        @else
            <div class="list-group">
                @foreach($reviews as $review)
                    <div class="list-group-item list-group-item-action flex-column align-items-start mb-3">
                        <div class="d-flex w-100 justify-content-between align-items-center mb-2">
                            <div class="d-flex align-items-center">
                                @if($review->booking->user->profile_picture)
                                    <img src="{{ asset('storage/' . $review->booking->user->profile_picture) }}" alt="{{ $review->booking->user->name }}" class="img-profile rounded-circle mr-3" style="width: 50px; height: 50px;">
                                @else
                                    <div class="bg-primary rounded-circle mr-3 d-flex align-items-center justify-content-center" style="width: 50px; height: 50px;">
                                        <span class="text-white font-weight-bold" style="font-size: 20px;">{{ substr($review->booking->user->name, 0, 1) }}</span>
                                    </div>
                                @endif
                                <div>
                                    <h5 class="mb-0">{{ $review->booking->user->name }}</h5>
                                    <div class="text-muted">{{ $review->created_at->format('d M Y H:i') }}</div>
                                </div>
                            </div>
                            <div>
                                <div class="d-flex align-items-center">
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
                        
                        <p class="mb-3">{{ $review->comment }}</p>
                        
                        <div class="mt-3">
                            <a href="{{ route('admin.properties.ulasan.show', $review->id) }}" class="btn btn-sm btn-primary">
                                <i class="fas fa-eye"></i> Lihat Detail
                            </a>
                        </div>
                    </div>
                @endforeach
            </div>
            
            <div class="mt-3">
                {{ $reviews->links() }}
            </div>
        @endif
    </div>
</div>
@endsection
