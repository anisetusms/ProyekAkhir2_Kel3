<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Properti</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="container mt-4">
        <h3>Edit Properti</h3>
        <div class="card">
            <div class="card-body">
                <form action="{{ route('owner.update-property', $property->property_id) }}" method="POST" enctype="multipart/form-data">
                    @csrf
                    @method('PUT')

                    <div class="mb-3">
                        <label for="name" class="form-label">Nama Properti</label>
                        <input type="text" class="form-control" id="name" name="name" value="{{ $property->property_name }}" required>
                    </div>

                    <div class="mb-3">
                        <label for="property_type" class="form-label">Kategori</label>
                        <select class="form-control" id="property_type" name="property_type" required>
                            @foreach($propertyTypes as $type)
                                <option value="{{ $type->id }}" {{ $type->id == $property->property_type_id ? 'selected' : '' }}>
                                    {{ $type->property_type }}
                                </option>
                            @endforeach
                        </select>
                    </div>

                    <div class="mb-3">
                        <label for="subdistrict" class="form-label">Alamat</label>
                        <input type="text" class="form-control" id="subdistrict" name="subdistrict" value="{{ $property->subdistrict }}" required>
                    </div>

                    <div class="mb-3">
                        <label for="price" class="form-label">Harga</label>
                        <input type="number" class="form-control" id="price" name="price" value="{{ $property->price }}" required>
                    </div>

                    <div class="mb-3">
                        <label for="description" class="form-label">Deskripsi</label>
                        <textarea class="form-control" id="description" name="description" rows="3" required>{{ $property->description }}</textarea>
                    </div>

                    <div class="mb-3">
                        <label for="facilities" class="form-label">Fasilitas</label>
                        <input type="text" class="form-control" id="facilities" name="facilities" value="{{ $property->facilities }}">
                        <small class="text-muted">Pisahkan dengan koma (,)</small>
                    </div>

                    @if(!empty($property->images))
                        @php $images = json_decode($property->images, true); @endphp
                        <div class="row">
                            @foreach($images as $image)
                                <div class="col-md-3 text-center">
                                    <img src="{{ asset('storage/' . $image) }}" alt="Gambar Properti" class="img-fluid mb-2" style="max-width: 100%;">
                                    <br>
                                    <button type="button" class="btn btn-danger btn-sm delete-image" data-path="{{ $image }}">Hapus</button>
                                </div>
                            @endforeach
                        </div>
                    @else
                        <p class="text-muted">Tidak ada gambar tersedia.</p>
                    @endif                                  

                    <button type="submit" class="btn btn-primary">Simpan Perubahan</button>
                    <a href="{{ route('owner.property') }}" class="btn btn-secondary">Batal</a>
                </form>
            </div>
        </div>
    </div>
</body>
</html>
