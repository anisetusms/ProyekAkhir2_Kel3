<li class="nav-item dropdown no-arrow mx-1">
    <a class="nav-link dropdown-toggle" href="#" id="alertsDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
        <i class="fas fa-bell fa-fw"></i>
        <span class="badge badge-danger badge-counter" id="notificationCount">0</span>
    </a>
    <div class="dropdown-list dropdown-menu dropdown-menu-right shadow animated--grow-in" aria-labelledby="alertsDropdown">
        <h6 class="dropdown-header">
            Notifikasi
        </h6>
        <div id="notificationList">
            <div class="text-center py-3">
                <p class="text-muted">Memuat notifikasi...</p>
            </div>
        </div>
        <a class="dropdown-item text-center small text-gray-500" href="#">Lihat Semua Notifikasi</a>
    </div>
</li>

<script>
    // Function to load notifications
    function loadNotifications() {
        fetch('{{ route('admin.properties.bookings.pending') }}')
            .then(response => response.json())
            .then(data => {
                const bookings = data.data;
                const count = bookings.length;
                const listContainer = document.getElementById('notificationList');
                const countElement = document.getElementById('notificationCount');

                countElement.textContent = count;

                if (count > 0) {
                    listContainer.innerHTML = bookings.map(booking => `
                        <a class="dropdown-item d-flex align-items-center" href="{{ route('admin.properties.bookings.show', '') }}/${booking.id}">
                            <div class="mr-3">
                                <div class="icon-circle bg-primary">
                                    <i class="fas fa-file-alt text-white"></i>
                                </div>
                            </div>
                            <div>
                                <div class="small text-gray-500">${new Date(booking.created_at).toLocaleString()}</div>
                                <span class="font-weight-bold">Pemesanan baru oleh ${booking.guest_name}</span>
                            </div>
                        </a>
                    `).join('');
                } else {
                    listContainer.innerHTML = '<div class="text-center py-3"><p class="text-muted">Tidak ada notifikasi baru</p></div>';
                }
            })
            .catch(error => {
                console.error('Error loading notifications:', error);
                document.getElementById('notificationList').innerHTML = '<div class="text-center py-3"><p class="text-muted">Gagal memuat notifikasi</p></div>';
            });
    }

    // Load notifications when page loads
    document.addEventListener('DOMContentLoaded', function() {
        loadNotifications();
        
        // Refresh notifications every 60 seconds
        setInterval(loadNotifications, 60000);
    });
</script>
