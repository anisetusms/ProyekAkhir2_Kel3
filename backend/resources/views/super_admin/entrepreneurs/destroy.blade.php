@extends('layouts.index-superadmin')

@section('content')
<div class="container">
    <h1>Delete Entrepreneur</h1>
    <p>Are you sure you want to delete this entrepreneur?</p>
    <p><strong>Name:</strong> {{ $entrepreneur->name }}</p>
    <p><strong>Email:</strong> {{ $entrepreneur->email }}</p>

    <form action="{{ route('super_admin.entrepreneurs.delete') }}" method="POST">
        @csrf
        <input type="hidden" name="id" value="{{ $entrepreneur->id }}">
        <button type="submit" class="btn btn-danger">Delete</button>
        <a href="{{ route('super_admin.entrepreneurs.index') }}" class="btn btn-secondary">Cancel</a>
    </form>
</div>
@endsection