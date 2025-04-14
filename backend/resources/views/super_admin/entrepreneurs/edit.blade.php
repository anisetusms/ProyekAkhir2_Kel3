<!-- filepath: e:\KULIAH\SEMESTER 4\PA2\PA2\PA2\resources\views\super_admin\entrepreneurs\edit.blade.php -->
@extends('layouts.index-superadmin')

@section('content')
<div class="container">
    <h1>Edit Entrepreneur</h1>
    <form action="{{ route('super_admin.entrepreneurs.update', $entrepreneur->id) }}" method="POST">
        @csrf
        @method('POST') <!-- Pastikan metode sesuai dengan route -->

        <div class="form-group">
            <label for="name">Name</label>
            <input type="text" name="name" id="name" class="form-control" value="{{ old('name', $entrepreneur->name) }}" required>
        </div>

        <div class="form-group">
            <label for="email">Email</label>
            <input type="email" name="email" id="email" class="form-control" value="{{ old('email', $entrepreneur->email) }}" required>
        </div>

        <div class="form-group">
            <label for="password">Password (Optional)</label>
            <input type="password" name="password" id="password" class="form-control">
        </div>

        <div class="form-group">
            <label for="password_confirmation">Confirm Password</label>
            <input type="password" name="password_confirmation" id="password_confirmation" class="form-control">
        </div>

        <button type="submit" class="btn btn-primary">Update</button>
    </form>
</div>
@endsection