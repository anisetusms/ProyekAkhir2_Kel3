{{-- resources/views/admin/properties/partials/location-form.blade.php --}}

<div class="form-group">
    <label for="province_id">Provinsi <span class="text-danger">*</span></label>
    <select class="form-control @error('province_id') is-invalid @enderror" 
            id="province_id" name="province_id" required>
        <option value="">Pilih Provinsi</option>
        @foreach($provinces as $province)
            <option value="{{ $province->id }}" 
                {{ old('province_id', $property->province_id ?? '') == $province->id ? 'selected' : '' }}>
                {{ $province->prov_name }}
            </option>
        @endforeach
    </select>
    @error('province_id')
        <div class="invalid-feedback">{{ $message }}</div>
    @enderror
</div>

<div class="form-group">
    <label for="city_id">Kabupaten/Kota <span class="text-danger">*</span></label>
    <select class="form-control @error('city_id') is-invalid @enderror" 
            id="city_id" name="city_id" required disabled>
        <option value="">Pilih Provinsi terlebih dahulu</option>
    </select>
    @error('city_id')
        <div class="invalid-feedback">{{ $message }}</div>
    @enderror
</div>

<div class="form-group">
    <label for="district_id">Kecamatan <span class="text-danger">*</span></label>
    <select class="form-control @error('district_id') is-invalid @enderror" 
            id="district_id" name="district_id" required disabled>
        <option value="">Pilih Kabupaten/Kota terlebih dahulu</option>
    </select>
    @error('district_id')
        <div class="invalid-feedback">{{ $message }}</div>
    @enderror
</div>

<div class="form-group">
    <label for="subdistrict_id">Kelurahan/Desa <span class="text-danger">*</span></label>
    <select class="form-control @error('subdistrict_id') is-invalid @enderror" 
            id="subdistrict_id" name="subdistrict_id" required disabled>
        <option value="">Pilih Kecamatan terlebih dahulu</option>
    </select>
    @error('subdistrict_id')
        <div class="invalid-feedback">{{ $message }}</div>
    @enderror
</div>

@push('scripts')
<script>
$(document).ready(function() {
    // Fungsi untuk memuat data dropdown
    function loadDropdown(url, target, defaultText) {
        $.getJSON(url)
            .done(function(data) {
                const $target = $(target);
                $target.empty().append(`<option value="">${defaultText}</option>`);
                
                if (data.length > 0) {
                    $.each(data, function(index, item) {
                        $target.append($('<option>', {
                            value: item.id,
                            text: item.text
                        }));
                    });
                    $target.prop('disabled', false);
                } else {
                    $target.append('<option value="">Data tidak tersedia</option>');
                }
            })
            .fail(function() {
                $(target).empty().append('<option value="">Gagal memuat data</option>');
            });
    }

    // Ketika provinsi dipilih
    $('#province_id').change(function() {
        const provinceId = $(this).val();
        
        if (provinceId) {
            // Memuat kabupaten/kota
            loadDropdown(
                `/admin/properties/cities/${provinceId}`,
                '#city_id',
                'Pilih Kabupaten/Kota'
            );
            
            // Reset dropdown kecamatan dan kelurahan
            $('#district_id, #subdistrict_id').empty()
                .append('<option value="">Pilih terlebih dahulu</option>')
                .prop('disabled', true);
        } else {
            // Reset semua dropdown jika provinsi tidak dipilih
            $('#city_id, #district_id, #subdistrict_id').empty()
                .append('<option value="">Pilih terlebih dahulu</option>')
                .prop('disabled', true);
        }
    });

    // Ketika kabupaten/kota dipilih
    $('#city_id').change(function() {
        const cityId = $(this).val();
        
        if (cityId) {
            // Memuat kecamatan
            loadDropdown(
                `/admin/properties/districts/${cityId}`,
                '#district_id',
                'Pilih Kecamatan'
            );
            
            // Reset dropdown kelurahan
            $('#subdistrict_id').empty()
                .append('<option value="">Pilih terlebih dahulu</option>')
                .prop('disabled', true);
        } else {
            // Reset dropdown kecamatan dan kelurahan
            $('#district_id, #subdistrict_id').empty()
                .append('<option value="">Pilih terlebih dahulu</option>')
                .prop('disabled', true);
        }
    });

    // Ketika kecamatan dipilih
    $('#district_id').change(function() {
        const districtId = $(this).val();
        
        if (districtId) {
            // Memuat kelurahan/desa
            loadDropdown(
                `/admin/properties/subdistricts/${districtId}`,
                '#subdistrict_id',
                'Pilih Kelurahan/Desa'
            );
        } else {
            // Reset dropdown kelurahan
            $('#subdistrict_id').empty()
                .append('<option value="">Pilih terlebih dahulu</option>')
                .prop('disabled', true);
        }
    });
});
</script>
@endpush