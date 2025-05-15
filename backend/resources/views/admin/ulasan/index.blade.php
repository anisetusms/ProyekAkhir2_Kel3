@extends('layouts.admin')

@section('title', 'Daftar Ulasan')

@section('action_button')
<a href="{{ route('admin.properties.ulasan.dashboard') }}" class="d-none d-sm-inline-block btn btn-sm btn-primary shadow-sm">
    <i class="fas fa-arrow-left fa-sm text-white-50"></i> Kembali ke Dashboard
</a>
@endsection

@section('content')
<div class="card shadow mb-4">
    <div class="card-header py-3">
        <h6 class="m-0 font-weight-bold text-primary">Filter Ulasan</h6>
    </div>
    <div class="card-body">
        <form action="{{ route('admin.properties.ulasan.index') }}" method="GET" class="mb-0">
            <div class="row">
                <div class="col-md-3 mb-3">
                    <label for="property_id">Properti</label>
                    <select name="property_id" id="property_id" class="form-control">
                        <option value="">Semua Properti</option>
                        @foreach($properties as $property)
                            <option value="{{ $property->id }}" {{ request('property_id') == $property->id ? 'selected' : '' }}>
                                {{ $property->name }}
                            </option>
                        @endforeach
                    </select>
                </div>
                <div class="col-md-3 mb-3">
                    <label for="rating">Rating</label>
                    <select name="rating" id="rating" class="form-control">
                        <option value="">Semua Rating</option>
                        @for($i = 5; $i >= 1; $i--)
                            <option value="{{ $i }}" {{ request('rating') == $i ? 'selected' : '' }}>
                                {{ $i }} Bintang
                            </option>
                        @endfor
                    </select>
                </div>
                <div class="col-md-4 mb-3">
                    <label for="search">Cari</label>
                    <input type="text" name="search" id="search" class="form-control" placeholder="Cari di komentar..." value="{{ request('search') }}">
                </div>
                <div class="col-md-2 mb-3 d-flex align-items-end">
                    <button type="submit" class="btn btn-primary btn-block">
                        <i class="fas fa-search fa-sm"></i> Filter
                    </button>
                </div>
            </div>
        </form>
    </div>
</div>

<div class="card shadow mb-4">
    <div class="card-header py-3 d-flex flex-row align-items-center justify-content-between">
        <h6 class="m-0 font-weight-bold text-primary">Daftar Ulasan</h6>
        <div class="dropdown no-arrow">
            <a class="dropdown-toggle" href="#" role="button" id="dropdownMenuLink" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                <i class="fas fa-ellipsis-v fa-sm fa-fw text-gray-400"></i>
            </a>
            <div class="dropdown-menu dropdown-menu-right shadow animated--fade-in" aria-labelledby="dropdownMenuLink">
                <div class="dropdown-header">Opsi:</div>
                <a class="dropdown-item" href="{{ route('admin.properties.ulasan.index') }}">Reset Filter</a>
                <a class="dropdown-item" href="{{ route('admin.properties.ulasan.index', ['rating' => 5]) }}">Hanya Bintang 5</a>
                <a class="dropdown-item" href="{{ route('admin.properties.ulasan.index', ['rating' => 1]) }}">Hanya Bintang 1</a>
            </div>
        </div>
    </div>
    <div class="card-body">
        @if($reviews->isEmpty())
            <div class="text-center py-5">
                <i class="fas fa-comment-slash fa-4x text-gray-300 mb-3"></i>
                <p class="text-gray-500 mb-0">Belum ada ulasan yang sesuai dengan filter</p>
                @if(request('property_id') || request('rating') || request('search'))
                    <a href="{{ route('admin.properties.ulasan.index') }}" class="btn btn-sm btn-primary mt-3">
                        Reset Filter
                    </a>
                @endif
            </div>
        @else
            <div class="table-responsive">
                <table class="table table-bordered" width="100%" cellspacing="0">
                    <thead>
                        <tr>
                            <th>Pengguna</th>
                            <th>Properti</th>
                            <th>Rating</th>
                            <th>Ulasan</th>
                            <th>Tanggal</th>
                            <th>Aksi</th>
                        </tr>
                    </thead>
                    <tbody>
                        @foreach($reviews as $review)
                            <tr>
                                <td>
                                    <div class="d-flex align-items-center">
                                        @if($review->booking->user->profile_picture)
                                            <img src="{{ asset('storage/' . $review->booking->user->profile_picture) }}" alt="{{ $review->booking->user->name }}" class="img-profile rounded-circle mr-2" style="width: 40px; height: 40px;">
                                        @else
                                            <div class="bg-primary rounded-circle mr-2 d-flex align-items-center justify-content-center" style="width: 40px; height: 40px;">
                                                <span class="text-white font-weight-bold">{{ substr($review->booking->user->name, 0, 1) }}</span>
                                            </div>
                                        @endif
                                        <div>
                                            <div class="font-weight-bold">{{ $review->booking->user->name }}</div>
                                            <div class="small text-muted">{{ $review->booking->user->email }}</div>
                                        </div>
                                    </div>
                                </td>
                                <td>{{ $review->property->name }}</td>
                                <td>
                                    <div class="d-flex align-items-center">
                                        <span class="font-weight-bold mr-2">{{ $review->rating }}</span>
                                        <div>
                                            @for($i = 1; $i <= 5; $i++)
                                                @if($i <= $review->rating)
                                                    <i class="fas fa-star text-warning"></i>
                                                @else
                                                    <i class="far fa-star text-warning"></i>
                                                @endif
                                            @endfor
                                        </div>
                                    </div>
                                </td>
                                <td>{{ \Illuminate\Support\Str::limit($review->comment, 50) }}</td>
                                <td>{{ $review->created_at->format('d M Y H:i') }}</td>
                                <td>
                                    <a href="{{ route('admin.properties.ulasan.show', $review->id) }}" class="btn btn-sm btn-primary">
                                        <i class="fas fa-eye"></i> Detail
                                    </a>
                                </td>
                            </tr>
                        @endforeach
                    </tbody>
                </table>
            </div>
            
            <div class="mt-3">
                {{ $reviews->appends(request()->query())->links() }}
            </div>
        @endif
    </div>
</div>
@endsection
