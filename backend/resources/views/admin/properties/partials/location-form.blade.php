<div class="row">
    <div class="col-md-6">
        <div class="form-group">
            <label for="province_id">Provinsi <span class="text-danger">*</span></label>
            <select class="form-control @error('province_id') is-invalid @enderror" 
                    id="province_id" name="province_id" required>
                <option value="">Pilih Provinsi</option>
                @foreach($provinces as $province)
                    <option value="{{ $province->id }}" {{ old('province_id') == $province->id ? 'selected' : '' }}>
                        {{ $province->prov_name }}
                    </option>
                @endforeach
            </select>
            @error('province_id')
                <div class="invalid-feedback">{{ $message }}</div>
            @enderror
        </div>
    </div>
    
    <div class="col-md-6">
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
    </div>
</div>

<div class="row mt-3">
    <div class="col-md-6">
        <div class="form-group">
            <label for="district_id">Kecamatan <span class="text-danger">*</span></label>
            <select class="form-control @error('district_id') is-invalid @enderror" 
                    id="district_id" name="district_id" required disabled>
                <option value="">Pilih Kabupaten terlebih dahulu</option>
            </select>
            @error('district_id')
                <div class="invalid-feedback">{{ $message }}</div>
            @enderror
        </div>
    </div>
    
    <div class="col-md-6">
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
    </div>
</div>

