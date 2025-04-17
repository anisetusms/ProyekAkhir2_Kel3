<div class="card">
    <div class="card-header">
        <h6 class="m-0 font-weight-bold text-primary">Detail Homestay</h6>
    </div>
    <div class="card-body">
        <div class="form-group">
            <label for="total_units">Total Unit <span class="text-danger">*</span></label>
            <input type="number" class="form-control @error('total_units') is-invalid @enderror" 
                   id="total_units" name="total_units" 
                   value="{{ old('total_units', $detail->total_units ?? '') }}" 
                   min="1" required>
            @error('total_units')
                <div class="invalid-feedback">{{ $message }}</div>
            @enderror
        </div>

        <div class="form-group">
            <label for="minimum_stay">Minimal Menginap (hari) <span class="text-danger">*</span></label>
            <input type="number" class="form-control @error('minimum_stay') is-invalid @enderror" 
                   id="minimum_stay" name="minimum_stay" 
                   value="{{ old('minimum_stay', $detail->minimum_stay ?? 1) }}" 
                   min="1" required>
            @error('minimum_stay')
                <div class="invalid-feedback">{{ $message }}</div>
            @enderror
        </div>

        <div class="form-group">
            <label for="maximum_guest">Maksimal Tamu <span class="text-danger">*</span></label>
            <input type="number" class="form-control @error('maximum_guest') is-invalid @enderror" 
                   id="maximum_guest" name="maximum_guest" 
                   value="{{ old('maximum_guest', $detail->maximum_guest ?? 2) }}" 
                   min="1" required>
            @error('maximum_guest')
                <div class="invalid-feedback">{{ $message }}</div>
            @enderror
        </div>

        <div class="row">
            <div class="col-md-6">
                <div class="form-group">
                    <label for="checkin_time">Waktu Check-in <span class="text-danger">*</span></label>
                    <input type="time" class="form-control @error('checkin_time') is-invalid @enderror" 
                           id="checkin_time" name="checkin_time" 
                           value="{{ old('checkin_time', $detail->checkin_time ?? '14:00') }}" 
                           required>
                    @error('checkin_time')
                        <div class="invalid-feedback">{{ $message }}</div>
                    @enderror
                </div>
            </div>
            <div class="col-md-6">
                <div class="form-group">
                    <label for="checkout_time">Waktu Check-out <span class="text-danger">*</span></label>
                    <input type="time" class="form-control @error('checkout_time') is-invalid @enderror" 
                           id="checkout_time" name="checkout_time" 
                           value="{{ old('checkout_time', $detail->checkout_time ?? '12:00') }}" 
                           required>
                    @error('checkout_time')
                        <div class="invalid-feedback">{{ $message }}</div>
                    @enderror
                </div>
            </div>
        </div>

        <!-- <div class="form-group">
            <label for="homestay_rules">Peraturan Tambahan</label>
            <textarea class="form-control @error('homestay_rules') is-invalid @enderror" 
                      id="homestay_rules" name="homestay_rules" 
                      rows="3">{{ old('homestay_rules', $detail->rules ?? '') }}</textarea>
            @error('homestay_rules')
                <div class="invalid-feedback">{{ $message }}</div>
            @enderror
        </div> -->
    </div>
</div>