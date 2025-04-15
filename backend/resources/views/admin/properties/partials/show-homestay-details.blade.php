<table class="table table-bordered">
    <tr>
        <th width="40%">Total Unit</th>
        <td>{{ $property->detail->total_units }}</td>
    </tr>
    <tr>
        <th>Unit Tersedia</th>
        <td>{{ $property->detail->available_units }}</td>
    </tr>
    <tr>
        <th>Minimal Menginap</th>
        <td>{{ $property->detail->minimum_stay }} hari</td>
    </tr>
    <tr>
        <th>Maksimal Tamu</th>
        <td>{{ $property->detail->maximum_guest }} orang</td>
    </tr>
    <tr>
        <th>Waktu Check-in</th>
        <td>{{ $property->detail->formatted_checkin_time }}</td>
    </tr>
    <tr>
        <th>Waktu Check-out</th>
        <td>{{ $property->detail->formatted_checkout_time }}</td>
    </tr>
</table>