@extends('layouts.index-superadmin')
@section('title' , 'Edit Entrepreneur')

@section('content')
<div class="container mt-5">
    <div class="row justify-content-center">
        <div class="col-md-8">
            <!-- Card Container -->
            <div class="card shadow-sm border-0">
                <div class="card-header bg-primary text-white">
                    <h4 class="mb-0">Edit Entrepreneur</h4>
                </div>
                <div class="card-body">
                    <form action="{{ route('super_admin.entrepreneurs.update', $entrepreneur->id) }}" method="POST">
                        @csrf
                        @method('POST') <!-- Sesuaikan dengan method route -->

                        <div class="mb-3">
                            <label for="name" class="form-label">Name</label>
                            <input 
                                type="text" 
                                name="name" 
                                id="name" 
                                class="form-control" 
                                value="{{ old('name', $entrepreneur->name) }}" 
                                required
                            >
                        </div>

                        <div class="mb-3">
                            <label for="email" class="form-label">Email</label>
                            <input 
                                type="email" 
                                name="email" 
                                id="email" 
                                class="form-control" 
                                value="{{ old('email', $entrepreneur->email) }}" 
                                required
                            >
                        </div>

                        <div class="mb-3">
                            <label for="password" class="form-label">Password <span class="text-muted">(Optional)</span></label>
                            <input 
                                type="password" 
                                name="password" 
                                id="password" 
                                class="form-control"
                            >
                        </div>

                        <div class="mb-4">
                            <label for="password_confirmation" class="form-label">Confirm Password</label>
                            <input 
                                type="password" 
                                name="password_confirmation" 
                                id="password_confirmation" 
                                class="form-control"
                            >
                        </div>

                        <div class="d-flex justify-content-between">
                            <a href="{{ url()->previous() }}" class="btn btn-outline-secondary">
                                ← Kembali
                            </a>
                            <button type="submit" class="btn btn-primary"><i class="fas fa-save me-2"></i>
                                Simpan Perubahan
                            </button>
                        </div>
                    </form>
                </div>
            </div>

            <!-- Optional: Error messages -->
            @if ($errors->any())
                <div class="alert alert-danger mt-4">
                    <strong>Terjadi kesalahan:</strong>
                    <ul class="mb-0">
                        @foreach ($errors->all() as $error)
                            <li>{{ $error }}</li>
                        @endforeach
                    </ul>
                </div>
            @endif

        </div>
    </div>
</div>
@endsection