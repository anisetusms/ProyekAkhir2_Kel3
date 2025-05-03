<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Properti</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
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

                    <div class="mb-3">
                        <label for="images" class="form-label">Gambar Properti</label>
                        <input type="file" class="form-control" id="images" name="images[]" multiple>
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

    <script>
        document.querySelectorAll('.delete-image').forEach(button => {
            button.addEventListener('click', function () {
                let imagePath = this.getAttribute('data-path');
                
                Swal.fire({
                    title: "Yakin ingin menghapus gambar ini?",
                    text: "Gambar ini akan dihapus secara permanen!",
                    icon: "warning",
                    showCancelButton: true,
                    confirmButtonColor: "#d33",
                    cancelButtonColor: "#3085d6",
                    confirmButtonText: "Ya, Hapus!",
                    cancelButtonText: "Batal"
                }).then((result) => {
                    if (result.isConfirmed) {
                        // Send AJAX request to delete the image
                        fetch('{{ route('owner.delete-image') }}', {
                            method: 'DELETE',
                            headers: {
                                'Content-Type': 'application/json',
                                'X-CSRF-TOKEN': '{{ csrf_token() }}',
                            },
                            body: JSON.stringify({ image: imagePath })
                        })
                        .then(response => response.json())
                        .then(data => {
                            if (data.success) {
                                Swal.fire("Terhapus!", "Gambar telah dihapus.", "success");
                                location.reload(); // Refresh page
                            } else {
                                Swal.fire("Gagal!", "Gambar gagal dihapus.", "error");
                            }
                        });
                    }
                });
            });
        });
    </script>
</body>
</html>
