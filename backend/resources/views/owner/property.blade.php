@extends('layouts.index-owner')

@section('content')

<div class="row g-3">
    <div class="col-auto">
        <div class="position-relative">
            <input class="form-control px-5 rounded-pill" type="search" placeholder="Search Property">
            <span class="material-icons-outlined position-absolute ms-3 translate-middle-y start-0 top-50 fs-5">search</span>
        </div>
    </div>
    <div class="col-auto flex-grow-1 overflow-auto"></div>
    <div class="col-auto">
        <div class="d-flex align-items-center gap-2 justify-content-lg-end">
            <a href="{{ route('owner.add-property') }}" class="btn btn-primary px-4 rounded-pill">
                <i class="bi bi-plus-lg me-2"></i> Add Property
            </a>
        </div>
    </div>
</div>

<div class="card mt-4">
    <div class="card-body">
        <div class="product-table">
            <div class="table-responsive white-space-nowrap">
                <table class="table align-middle">
                    <thead class="table-light">
                        <tr>
                            <th><input class="form-check-input" type="checkbox"></th>
                            <th>No.</th>
                            <th>Property Name</th>
                            <th>Category</th>
                            <th>Address</th>
                            <th>Date</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        @foreach ($properties as $property)
                        <tr>
                            <td><input class="form-check-input" type="checkbox"></td>
                            <td>{{ $loop->iteration }}</td>
                            <td>{{ $property->name }}</td>
                            <td>{{ $property->property_type }}</td>
                            <td>{{ $property->subdistrict }}</td>
                            <td>{{ date('d M Y', strtotime($property->created_at)) }}</td>
                            <td>
                                <div class="d-flex gap-2">
                                    <!-- Tombol Edit (Menuju Halaman Edit) -->
                                    <a href="{{ route('owner.edit-property', $property->id) }}" class="btn btn-warning btn-sm rounded-circle" title="Edit">
                                        <i class="bi bi-pencil-square"></i>
                                    </a>

                                    <!-- Tombol Delete -->
                                    <form id="delete-form-{{ $property->id }}" action="{{ route('owner.delete-property') }}" method="POST" style="display:inline;">
                                        @csrf
                                        <input type="hidden" name="property_id" value="{{ $property->id }}">
                                        <button type="button" class="btn btn-danger btn-sm rounded-circle" onclick="confirmDelete({{ $property->id }})" title="Delete">
                                            <i class="bi bi-trash"></i>
                                        </button>
                                    </form> 
                                </div>                              
                            </td>
                        </tr>
                        @endforeach
                    </tbody>
                </table>
            </div>
        </div>
        
        <!-- Pagination (jika diperlukan) -->
    </div>
</div>

<script>
    function confirmDelete(propertyId) {
        Swal.fire({
            title: "Yakin ingin menghapus?",
            text: "Data ini akan dihapus secara permanen!",
            icon: "warning",
            showCancelButton: true,
            confirmButtonColor: "#d33",
            cancelButtonColor: "#3085d6",
            confirmButtonText: "Ya, Hapus!",
            cancelButtonText: "Batal",
            customClass: {
                confirmButton: "swal-confirm",
                cancelButton: "swal-cancel"
            }
        }).then((result) => {
            if (result.isConfirmed) {
                document.getElementById('delete-form-' + propertyId).submit();
            }
        });
    }
</script>
    
<style>
    /* Tambahkan border-radius untuk tombol */
    .swal-confirm, .swal-cancel {
        border-radius: 12px !important; /* Ubah sesuai selera */
        padding: 8px 16px;
    }
</style>    

@endsection
