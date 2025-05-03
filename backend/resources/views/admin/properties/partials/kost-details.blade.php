<div class="card">
    <div class="card-header">
        <h6 class="m-0 font-weight-bold text-primary">Detail Kost</h6>
    </div>
    <div class="card-body">
        <div class="form-group">
            <label for="total_rooms">Total Kamar <span class="text-danger">*</span></label>
            <input type="number" class="form-control @error('total_rooms') is-invalid @enderror" id="total_rooms" name="total_rooms" 
                value="{{ old('total_rooms', $detail->total_rooms ?? '') }}" min="1" required>
            @error('total_rooms')
                <div class="invalid-feedback">{{ $message }}</div>
            @enderror
        </div>

        <div class="form-group">
            <label for="rules">Peraturan Kost</label>
            <textarea class="form-control @error('rules') is-invalid @enderror" id="rules" name="rules" rows="3">{{ old('rules', $detail->rules ?? '') }}</textarea>
            @error('rules')
                <div class="invalid-feedback">{{ $message }}</div>
            @enderror
        </div>

        <div class="form-check">
            <input class="form-check-input" type="checkbox" id="meal_included" name="meal_included" 
                {{ old('meal_included', $detail->meal_included ?? false) ? 'checked' : '' }}>
            <label class="form-check-label" for="meal_included">Termasuk Makan</label>
        </div>

        <div class="form-check mt-2">
            <input class="form-check-input" type="checkbox" id="laundry_included" name="laundry_included" 
                {{ old('laundry_included', $detail->laundry_included ?? false) ? 'checked' : '' }}>
            <label class="form-check-label" for="laundry_included">Termasuk Laundry</label>
        </div>
    </div>
</div>