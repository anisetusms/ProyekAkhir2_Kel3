@extends('layouts.admin')

@section('content')
    <div class="container-fluid">
        <div class="d-sm-flex align-items-center justify-content-between mb-4">
            <h1 class="h3 mb-0 text-gray-800">Daftar Properti</h1>
            <a href="{{ route('admin.properties.create') }}" class="d-none d-sm-inline-block btn btn-sm btn-primary shadow-sm">
                <i class="fas fa-plus fa-sm text-white-50"></i> Tambah Properti
            </a>
        </div>

        @if(session('success'))
            <div class="alert alert-success">
                {{ session('success') }}
            </div>
        @endif

        <div class="card shadow mb-4">
            <div class="card-header py-3">
                <h6 class="m-0 font-weight-bold text-primary">Properti Aktif</h6>
            </div>
            <div class="card-body">
                <div class="table-responsive">
                    <table class="table table-bordered" id="activeDataTable" width="100%" cellspacing="0">
                        <thead>
                            <tr>
                                <th>No</th>
                                <th>Nama</th>
                                <th>Tipe</th>
                                <th>Tipe Kost</th>
                                <th>Lokasi</th>
                                <th>Harga</th>
                                <th>Status</th>
                                <th>Aksi</th>
                            </tr>
                        </thead>
                        <tbody>
                            @if(isset($activeProperties) && count($activeProperties) > 0)
                                @foreach($activeProperties as $property)
                                    <tr>
                                        <td>{{ $loop->iteration }}</td>
                                        <td>{{ $property->name }}</td>
                                        <td>
                                            @php
                                                $propertyTypes = [
                                                1 => 'Kost',
                                                2 => 'Homestay',
                                                ];
                                                $propertyType = $propertyTypes[$property->property_type_id] ?? 'Lainnya';
                                            @endphp
                                            <span class="badge badge-{{ $property->property_type_id == 1 ? 'info' : 'success' }}">
                                                {{ $propertyType }}
                                            </span>
                                        </td>
                                        <td>
                                            {{-- Menampilkan Tipe Kost jika Properti adalah Kost --}}
                                            @if($property->property_type_id == 1 && $property->kostDetail)
                                                {{ $property->kostDetail->kost_type }}
                                            @else
                                                -
                                            @endif
                                        </td>
                                        <td>
                                            @if($property->subdistrict && $property->district && $property->city && $property->province)
                                            {{ $property->subdistrict->subdis_name }},
                                            {{ $property->district->dis_name }},
                                            {{ $property->city->city_name }},
                                            {{ $property->province->prov_name }}
                                            <small class="d-block text-muted">{{ $property->address }}</small>
                                            @else
                                            -
                                            @endif
                                        </td>
                                        <td>Rp {{ number_format($property->price, 0, ',', '.') }}</td>
                                        <td>
                                            <span class="badge badge-success">
                                                Aktif
                                            </span>
                                        </td>
                                        <td>
                                            <a href="{{ route('admin.properties.show', $property->id) }}" class="btn btn-sm btn-info" title="Detail">
                                                <i class="fas fa-eye"></i>
                                            </a>
                                            <a href="{{ route('admin.properties.edit', $property->id) }}" class="btn btn-sm btn-warning" title="Edit">
                                                <i class="fas fa-edit"></i>
                                            </a>
                                            <form action="{{ route('admin.properties.destroy', $property->id) }}" method="POST" style="display: inline-block;">
                                                @csrf
                                                @method('DELETE')
                                                <button type="submit" class="btn btn-sm btn-danger" title="Nonaktifkan"
                                                    onclick="return confirm('Apakah Anda yakin?')">
                                                    <i class="fas fa-trash"></i>
                                                </button>
                                            </form>
                                            <a href="{{ route('admin.properties.rooms.index', $property->id) }}" class="btn btn-sm btn-secondary" title="Kelola Kamar">
                                                <i class="fas fa-door-open"></i>
                                            </a>
                                        </td>
                                    </tr>
                                @endforeach
                            @else
                                <tr>
                                    <td colspan="8" class="text-center">Tidak ada properti aktif.</td>
                                </tr>
                            @endif
                        </tbody>
                    </table>
                </div>
                @if(isset($activeProperties) && count($activeProperties) > 0)
                    <div class="d-flex justify-content-center">
                        {{ $activeProperties->links() }}
                    </div>
                @endif
            </div>
        </div>

        <div class="card shadow mb-4">
            <div class="card-header py-3">
                <h6 class="m-0 font-weight-bold text-danger">Properti Nonaktif</h6>
            </div>
            <div class="card-body">
                <div class="table-responsive">
                    <table class="table table-bordered" id="inactiveDataTable" width="100%" cellspacing="0">
                        <thead>
                            <tr>
                                <th>No</th>
                                <th>Nama</th>
                                <th>Tipe</th>
                                <th>Tipe Kost</th>
                                <th>Lokasi</th>
                                <th>Harga</th>
                                <th>Status</th>
                                <th>Aksi</th>
                            </tr>
                        </thead>
                        <tbody>
                            @if(isset($inactiveProperties) && count($inactiveProperties) > 0)
                                @foreach($inactiveProperties as $property)
                                    <tr>
                                        <td>{{ $loop->iteration }}</td>
                                        <td>{{ $property->name }}</td>
                                        <td>
                                            @php
                                                $propertyTypes = [
                                                1 => 'Kost',
                                                2 => 'Homestay',
                                                ];
                                                $propertyType = $propertyTypes[$property->property_type_id] ?? 'Lainnya';
                                            @endphp
                                            <span class="badge badge-{{ $property->property_type_id == 1 ? 'info' : 'success' }}">
                                                {{ $propertyType }}
                                            </span>
                                        </td>
                                        <td>
                                            {{-- Menampilkan Tipe Kost jika Properti adalah Kost --}}
                                            @if($property->property_type_id == 1 && $property->kostDetail)
                                                {{ $property->kostDetail->kost_type }}
                                            @else
                                                -
                                            @endif
                                        </td>
                                        <td>
                                            @if($property->subdistrict && $property->district && $property->city && $property->province)
                                            {{ $property->subdistrict->subdis_name }},
                                            {{ $property->district->dis_name }},
                                            {{ $property->city->city_name }},
                                            {{ $property->province->prov_name }}
                                            <small class="d-block text-muted">{{ $property->address }}</small>
                                            @else
                                            -
                                            @endif
                                        </td>
                                        <td>Rp {{ number_format($property->price, 0, ',', '.') }}</td>
                                        <td>
                                            <span class="badge badge-danger">
                                                Nonaktif
                                            </span>
                                        </td>
                                        <td>
                                            <a href="{{ route('admin.properties.show', $property->id) }}" class="btn btn-sm btn-info" title="Detail">
                                                <i class="fas fa-eye"></i>
                                            </a>
                                            <a href="{{ route('admin.properties.edit', $property->id) }}" class="btn btn-sm btn-warning" title="Edit">
                                                <i class="fas fa-edit"></i>
                                            </a>
                                            <form action="{{ route('admin.properties.destroy', $property->id) }}" method="POST" style="display: inline-block;">
                                                @csrf
                                                @method('DELETE')
                                                <button type="submit" class="btn btn-sm btn-danger" title="Hapus Permanen"
                                                    onclick="return confirm('Apakah Anda yakin ingin menghapus properti ini secara permanen?')">
                                                    <i class="fas fa-trash"></i>
                                                </button>
                                            </form>
                                        </td>
                                    </tr>
                                @endforeach
                            @else
                                <tr>
                                    <td colspan="8" class="text-center">Tidak ada properti nonaktif.</td>
                                </tr>
                            @endif
                        </tbody>
                    </table>
                </div>
                @if(isset($inactiveProperties) && count($inactiveProperties) > 0)
                    <div class="d-flex justify-content-center">
                        {{ $inactiveProperties->links() }}
                    </div>
                @endif
            </div>
        </div>
    </div>
@endsection

@section('scripts')
<script src="{{ asset('vendor/datatables/jquery.dataTables.min.js') }}"></script>
<script src="{{ asset('vendor/datatables/dataTables.bootstrap4.min.js') }}"></script>

<script>
    // Call the dataTables jQuery plugin
    $(document).ready(function() {
        $('#activeDataTable').DataTable({
            "language": {
                "url": "//cdn.datatables.net/plug-ins/1.10.20/i18n/Indonesian.json"
            },
            "responsive": true,
            "dom": '<"top"f>rt<"bottom"lip><"clear">',
            "pageLength": 10,
             "order": [[0, 'asc']]
        });

        $('#inactiveDataTable').DataTable({
            "language": {
                "url": "//cdn.datatables.net/plug-ins/1.10.20/i18n/Indonesian.json"
            },
            "responsive": true,
            "dom": '<"top"f>rt<"bottom"lip><"clear">',
            "pageLength": 10,
             "order": [[0, 'asc']]
        });
    });
</script>
@endsection
