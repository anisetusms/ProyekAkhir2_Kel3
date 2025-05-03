@props(['status'])

@php
    $classes = [
        true => 'badge-danger',
        false => 'badge-success'
    ][$status];
@endphp

<span class="badge {{ $classes }}">
    {{ $status ? 'Nonaktif' : 'Aktif' }}
</span>