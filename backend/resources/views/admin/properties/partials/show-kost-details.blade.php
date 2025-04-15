<table class="table table-bordered">
    <tr>
        <th width="40%">Total Kamar</th>
        <td>{{ $property->detail->total_rooms }}</td>
    </tr>
    <tr>
        <th>Kamar Tersedia</th>
        <td>{{ $property->detail->available_rooms }}</td>
    </tr>
    <tr>
        <th>Termasuk Makan</th>
        <td>{!! $property->detail->meal_included ? '<span class="badge badge-success">Ya</span>' : '<span class="badge badge-secondary">Tidak</span>' !!}</td>
    </tr>
    <tr>
        <th>Termasuk Laundry</th>
        <td>{!! $property->detail->laundry_included ? '<span class="badge badge-success">Ya</span>' : '<span class="badge badge-secondary">Tidak</span>' !!}</td>
    </tr>
    @if($property->detail->rules)
    <tr>
        <th>Peraturan Kost</th>
        <td>{{ $property->detail->rules }}</td>
    </tr>
    @endif
</table>