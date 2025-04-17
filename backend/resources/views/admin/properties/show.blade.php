@extends('admin.layouts.app')

@section('title', 'Property Details: ' . $property->name)

@section('content')
<div class="container-fluid">
    <div class="row mb-4">
        <div class="col-md-12">
            <div class="d-flex justify-content-between align-items-center">
                <h2>Property Details: {{ $property->name }}</h2>
                <div>
                    <a href="{{ route('admin.properties.edit', $property->id) }}" class="btn btn-primary">
                        <i class="fas fa-edit"></i> Edit
                    </a>
                    <a href="{{ route('admin.properties.index') }}" class="btn btn-secondary">
                        <i class="fas fa-arrow-left"></i> Back to List
                    </a>
                </div>
            </div>
        </div>
    </div>

    <div class="row">
        <div class="col-md-8">
            <div class="card shadow mb-4">
                <div class="card-header py-3">
                    <h6 class="m-0 font-weight-bold text-primary">Basic Information</h6>
                </div>
                <div class="card-body">
                    <div class="row">
                        <div class="col-md-4">
                            @if($property->image)
                            <img src="{{ asset('storage/' . $property->image) }}" alt="{{ $property->name }}" class="img-fluid rounded">
                            @else
                            <div class="text-center py-4 bg-light rounded">
                                <i class="fas fa-image fa-3x text-muted"></i>
                                <p class="mt-2">No image available</p>
                            </div>
                            @endif
                        </div>
                        <div class="col-md-8">
                            <h4>{{ $property->name }}</h4>
                            <p class="text-muted">{{ $property->propertyType->name ?? 'N/A' }}</p>
                            
                            <div class="mb-3">
                                <h5>Description</h5>
                                <p>{{ $property->description }}</p>
                            </div>
                            
                            <div class="row">
                                <div class="col-md-6">
                                    <h5>Pricing</h5>
                                    <p><strong>Price:</strong> {{ format_currency($property->price) }}</p>
                                </div>
                                <div class="col-md-6">
                                    <h5>Status</h5>
                                    <span class="badge {{ $property->isActive ? 'badge-success' : 'badge-secondary' }}">
                                        {{ $property->isActive ? 'Active' : 'Inactive' }}
                                    </span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            
            <div class="card shadow mb-4">
                <div class="card-header py-3">
                    <h6 class="m-0 font-weight-bold text-primary">Location Information</h6>
                </div>
                <div class="card-body">
                    <div class="row">
                        <div class="col-md-6">
                            <h5>Address</h5>
                            <p>{{ $property->address }}</p>
                            <p>
                                {{ $property->subdistrict->name ?? 'N/A' }}, 
                                {{ $property->district->name ?? 'N/A' }}<br>
                                {{ $property->city->name ?? 'N/A' }}, 
                                {{ $property->province->name ?? 'N/A' }}
                            </p>
                        </div>
                        <div class="col-md-6">
                            <h5>Coordinates</h5>
                            <p>
                                <strong>Latitude:</strong> {{ $property->latitude ?? 'N/A' }}<br>
                                <strong>Longitude:</strong> {{ $property->longitude ?? 'N/A' }}
                            </p>
                            @if($property->latitude && $property->longitude)
                            <div id="property-map" style="height: 200px; width: 100%;"></div>
                            @endif
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <div class="col-md-4">
            <div class="card shadow mb-4">
                <div class="card-header py-3">
                    <h6 class="m-0 font-weight-bold text-primary">Property Details</h6>
                </div>
                <div class="card-body">
                    @if($property->propertyType->name === 'kost' && $property->kostDetail)
                    <h5>Kost Details</h5>
                    <p><strong>Type:</strong> {{ ucfirst($property->kostDetail->kost_type) }}</p>
                    <p><strong>Total Rooms:</strong> {{ $property->kostDetail->total_rooms }}</p>
                    <p><strong>Available Rooms:</strong> {{ $property->kostDetail->available_rooms }}</p>
                    <p><strong>Meal Included:</strong> {{ $property->kostDetail->meal_included ? 'Yes' : 'No' }}</p>
                    <p><strong>Laundry Included:</strong> {{ $property->kostDetail->laundry_included ? 'Yes' : 'No' }}</p>
                    @elseif($property->propertyType->name === 'homestay' && $property->homestayDetail)
                    <h5>Homestay Details</h5>
                    <p><strong>Total Units:</strong> {{ $property->homestayDetail->total_units }}</p>
                    <p><strong>Available Units:</strong> {{ $property->homestayDetail->available_units }}</p>
                    <p><strong>Minimum Stay:</strong> {{ $property->homestayDetail->minimum_stay }} nights</p>
                    <p><strong>Maximum Guest:</strong> {{ $property->homestayDetail->maximum_guest }}</p>
                    <p><strong>Check-in Time:</strong> {{ $property->homestayDetail->checkin_time }}</p>
                    <p><strong>Check-out Time:</strong> {{ $property->homestayDetail->checkout_time }}</p>
                    @endif
                    
                    @if($property->rules)
                    <h5 class="mt-4">House Rules</h5>
                    <p>{{ $property->rules }}</p>
                    @endif
                </div>
            </div>
            
            <div class="card shadow">
                <div class="card-header py-3">
                    <h6 class="m-0 font-weight-bold text-primary">Rooms Availability</h6>
                </div>
                <div class="card-body">
                    <div class="text-center mb-3">
                        <div class="progress-circle" data-percent="{{ $availablePercentage }}">
                            <svg class="progress-circle-svg" viewBox="0 0 36 36">
                                <path class="progress-circle-bg"
                                    d="M18 2.0845
                                    a 15.9155 15.9155 0 0 1 0 31.831
                                    a 15.9155 15.9155 0 0 1 0 -31.831"
                                />
                                <path class="progress-circle-fill"
                                    stroke-dasharray="{{ $availablePercentage }}, 100"
                                    d="M18 2.0845
                                    a 15.9155 15.9155 0 0 1 0 31.831
                                    a 15.9155 15.9155 0 0 1 0 -31.831"
                                />
                                <text class="progress-circle-text" x="18" y="20.35">{{ round($availablePercentage) }}%</text>
                            </svg>
                        </div>
                        <h5 class="mt-2">Availability Rate</h5>
                    </div>
                    <div class="text-center">
                        <p>
                            <span class="badge badge-success">{{ $availableRooms }} Available</span> / 
                            <span class="badge badge-secondary">{{ $totalRooms }} Total</span>
                        </p>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
@endsection

@push('styles')
<style>
    .progress-circle {
        position: relative;
        display: inline-block;
        width: 100px;
        height: 100px;
    }
    
    .progress-circle-svg {
        transform: rotate(-90deg);
    }
    
    .progress-circle-bg {
        fill: none;
        stroke: #eee;
        stroke-width: 3;
    }
    
    .progress-circle-fill {
        fill: none;
        stroke: #4CAF50;
        stroke-width: 3;
        stroke-linecap: round;
        transition: stroke-dasharray 0.5s ease;
    }
    
    .progress-circle-text {
        font-size: 0.4em;
        text-anchor: middle;
        fill: #333;
        font-weight: bold;
    }
</style>
@endpush

@push('scripts')
@if($property->latitude && $property->longitude)
<script>
    function initMap() {
        const propertyLocation = { lat: {{ $property->latitude }}, lng: {{ $property->longitude }} };
        const map = new google.maps.Map(document.getElementById("property-map"), {
            zoom: 15,
            center: propertyLocation,
        });
        
        new google.maps.Marker({
            position: propertyLocation,
            map: map,
            title: "{{ $property->name }}"
        });
    }
</script>
<script src="https://maps.googleapis.com/maps/api/js?key={{ config('services.google.maps_api_key') }}&callback=initMap" async defer></script>
@endif
@endpush