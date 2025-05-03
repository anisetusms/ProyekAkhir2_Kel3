<div class="modal fade" id="deletePropertyModal" tabindex="-1" role="dialog" aria-labelledby="deletePropertyModalLabel" aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="deletePropertyModalLabel">Konfirmasi Penghapusan</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                Apakah Anda yakin ingin {{ $property->isDeleted ? 'menghapus permanen' : 'menonaktifkan' }} properti ini?
                @if(!$property->isDeleted)
                <div class="alert alert-warning mt-2">
                    <i class="fas fa-exclamation-triangle"></i> Properti yang dinonaktifkan tidak akan muncul di pencarian
                </div>
                @endif
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-dismiss="modal">Batal</button>
                <form action="{{ route('admin.properties.destroy', $property->id) }}" method="POST">
                    @csrf
                    @method('DELETE')
                    <button type="submit" class="btn btn-danger">
                        <i class="fas fa-trash"></i> {{ $property->isDeleted ? 'Hapus Permanen' : 'Nonaktifkan' }}
                    </button>
                </form>
            </div>
        </div>
    </div>
</div>