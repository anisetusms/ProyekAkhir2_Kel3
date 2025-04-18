@extends('layouts.admin')

@section('content')
<div class="container-fluid">
    <h1>Dashboard Owner</h1>

    <div class="row">
        <div class="col-md-4">
            <div class="card bg-primary text-white mb-4">
                <div class="card-body">
                    <h5 class="card-title">Total Properti</h5>
                    <p class="card-text">{{ $totalProperties }}</p>
                </div>
            </div>
        </div>

        <div class="col-md-4">
            <div class="card bg-success text-white mb-4">
                <div class="card-body">
                    <h5 class="card-title">Properti Aktif</h5>
                    <p class="card-text">{{ $activeProperties }}</p>
                </div>
            </div>
        </div>

        <div class="col-md-4">
            <div class="card bg-warning text-white mb-4">
                <div class="card-body">
                    <h5 class="card-title">Properti Menunggu Persetujuan</h5>
                    <p class="card-text">{{ $pendingProperties }}</p>
                </div>
            </div>
        </div>
    </div>

    <div class="row">
        <div class="col-md-8">
            <div class="card mb-4">
                <div class="card-header">Properti Terbaru</div>
                <div class="card-body">
                    <table class="table">
                        <thead>
                            <tr>
                                <th>Nama Properti</th>
                                <th>Status</th>
                                <th>Tanggal Ditambahkan</th>
                            </tr>
                        </thead>
                        <tbody>
                            @foreach($latestProperties as $property)
                            <tr>
                                <td>{{ $property->name }}</td>
                                <td>
                                    <span class="badge badge-{{ $property->isDeleted ? 'danger' : 'success' }}">
                                        {{ $property->isDeleted ? 'Nonaktif' : 'Aktif' }}
                                    </span>
                                </td>
                                <td>{{ $property->created_at->format('d M Y') }}</td>
                            </tr>
                            @endforeach
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <div class="col-md-4">
            <div class="card mb-4">
                <div class="card-header">Statistik</div>
                <div class="card-body">
                    <p>Total View: {{ $totalViews }}</p>
                    <p>Total Pesan: {{ $totalMessages }}</p>
                </div>
            </div>
        </div>
    </div>
</div>
@endsection