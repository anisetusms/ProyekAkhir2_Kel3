<table class="table table-bordered">
    <tr>
        <th width="40%">Total Kamar</th>
        <td>{{ $property->detail->total_rooms ?? '-'}}</td>
    </tr>
    <tr>
        <th>Kamar Tersedia</th>
        <td>{{ $property->detail->available_rooms ?? '-'}}</td>
    </tr>
    @if($property->detail->rules)
    <tr>
        <th>Peraturan Kost</th>
        <td>{{ $property->detail->rules ?? '-'}}</td>
    </tr>
    @endif
</table>