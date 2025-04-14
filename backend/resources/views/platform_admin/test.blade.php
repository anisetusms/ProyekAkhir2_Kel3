<!-- filepath: e:\KULIAH\SEMESTER 4\PA2\PA2\PA2\resources\views\platform_admin\dashboard.blade.php -->
<!DOCTYPE html>
<html lang="id" data-bs-theme="light">

<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>HomMie | Dashboard Admin Platform</title>
  <!-- Favicon -->
  <link rel="icon" href="/assets/images/favicon-32x32.png" type="image/png">
  <!-- Bootstrap CSS -->
  <link href="/assets/css/bootstrap.min.css" rel="stylesheet">
  <!-- Custom CSS -->
  <link href="/assets/css/custom.css" rel="stylesheet">
  <link href="https://fonts.googleapis.com/css2?family=Noto+Sans:wght@300;400;500;600&display=swap" rel="stylesheet">
  <link href="https://fonts.googleapis.com/css?family=Material+Icons+Outlined" rel="stylesheet">
</head>

<body>
  <!-- Header -->
  <header class="bg-dark text-white py-3">
    <div class="container d-flex justify-content-between align-items-center">
      <h1 class="h4 mb-0">Dashboard Admin Platform</h1>
      <div class="dropdown">
        <a href="#" class="text-white text-decoration-none dropdown-toggle" data-bs-toggle="dropdown">
          <img src="{{ Auth::user()->profile_picture ? asset('storage/' . Auth::user()->profile_picture) : asset('assets/images/avatars/default.png') }}" class="rounded-circle" width="40" height="40" alt="Profil">
          <span>{{ Auth::user()->name }}</span>
        </a>
        <ul class="dropdown-menu dropdown-menu-end">
          <li><a class="dropdown-item" href="#">Profil</a></li>
          <li>
            <form action="{{ route('logout') }}" method="POST">
              @csrf
              <button type="submit" class="dropdown-item">Keluar</button>
            </form>
          </li>
        </ul>
      </div>
    </div>
  </header>

  <!-- Sidebar dan Konten -->
  <div class="d-flex">
    <!-- Sidebar -->
    <aside class="bg-light border-end" style="width: 250px; min-height: 100vh;">
      <nav class="nav flex-column p-3">
        <a href="{{ route('platform_admin.dashboard') }}" class="nav-link text-dark {{ request()->routeIs('platform_admin.dashboard') ? 'fw-bold' : '' }}">
          <i class="material-icons-outlined">dashboard</i> Dashboard
        </a>
        <a href="{{ route('platform_admin.index') }}" class="nav-link text-dark {{ request()->routeIs('platform_admin.index') ? 'fw-bold' : '' }}">
          <i class="material-icons-outlined">group</i> Owner
        </a>
        <a href="{{ route('platform_admin.index') }}" class="nav-link text-dark {{ request()->routeIs('platform_admin.index') ? 'fw-bold' : '' }}">
          <i class="material-icons-outlined">group</i> Penyewa
        </a>
        <a href="{{ route('platform_admin.index') }}" class="nav-link text-dark {{ request()->routeIs('super_admin.profiles.index') ? 'fw-bold' : '' }}">
          <i class="material-icons-outlined">person</i> Profil
        </a>
      </nav>
    </aside>

    <!-- Konten Utama -->
    <main class="flex-grow-1 p-4">
      <div class="container">
        <h2>Selamat Datang, {{ Auth::user()->name }}</h2>
        <p>Gunakan menu navigasi untuk mengelola akun Owner dan Penyewa.</p>

        <div class="row">
          <div class="col-md-6">
            <div class="card shadow-sm">
              <div class="card-body text-center">
                <i class="material-icons-outlined text-primary" style="font-size: 48px;">group</i>
                <h5 class="card-title mt-3">Owner Aktif</h5>
                <p class="card-text">Kelola akun Owner yang aktif.</p>
                <a href="#owner-aktif" class="btn btn-primary">Lihat</a>
              </div>
            </div>
          </div>
          <div class="col-md-6">
            <div class="card shadow-sm">
              <div class="card-body text-center">
                <i class="material-icons-outlined text-danger" style="font-size: 48px;">block</i>
                <h5 class="card-title mt-3">Owner Dibanned</h5>
                <p class="card-text">Kelola akun Owner yang dibanned.</p>
                <a href="#owner-banned" class="btn btn-danger">Lihat</a>
              </div>
            </div>
          </div>
        </div>

        <div class="row mt-4">
          <div class="col-md-6">
            <div class="card shadow-sm">
              <div class="card-body text-center">
                <i class="material-icons-outlined text-success" style="font-size: 48px;">group</i>
                <h5 class="card-title mt-3">Penyewa Aktif</h5>
                <p class="card-text">Kelola akun Penyewa yang aktif.</p>
                <a href="#penyewa-aktif" class="btn btn-success">Lihat</a>
              </div>
            </div>
          </div>
          <div class="col-md-6">
            <div class="card shadow-sm">
              <div class="card-body text-center">
                <i class="material-icons-outlined text-warning" style="font-size: 48px;">block</i>
                <h5 class="card-title mt-3">Penyewa Dibanned</h5>
                <p class="card-text">Kelola akun Penyewa yang dibanned.</p>
                <a href="#penyewa-banned" class="btn btn-warning">Lihat</a>
              </div>
            </div>
          </div>
        </div>

        <!-- Daftar Owner Aktif -->
        <div id="owner-aktif" class="mt-5">
          <h3>Owner Aktif</h3>
          <ul class="list-group">
            @foreach ($activeOwners as $owner)
              <li class="list-group-item d-flex justify-content-between align-items-center">
                {{ $owner->username }} ({{ $owner->email }})
                <form action="{{ route('platform_admin.ban', $owner->id) }}" method="POST">
                  @csrf
                  <button type="submit" class="btn btn-sm btn-danger">Ban</button>
                </form>
              </li>
            @endforeach
          </ul>
        </div>

        <!-- Daftar Owner Dibanned -->
        <div id="owner-banned" class="mt-5">
          <h3>Owner Dibanned</h3>
          <ul class="list-group">
            @foreach ($bannedOwners as $owner)
              <li class="list-group-item d-flex justify-content-between align-items-center">
                {{ $owner->username }} ({{ $owner->email }})
                <form action="{{ route('platform_admin.unban', $owner->id) }}" method="POST">
                  @csrf
                  <button type="submit" class="btn btn-sm btn-success">Unban</button>
                </form>
              </li>
            @endforeach
          </ul>
        </div>

        <!-- Daftar Penyewa Aktif -->
        <div id="penyewa-aktif" class="mt-5">
          <h3>Penyewa Aktif</h3>
          <ul class="list-group">
            @foreach ($activeTenants as $tenant)
              <li class="list-group-item d-flex justify-content-between align-items-center">
                {{ $tenant->username }} ({{ $tenant->email }})
                <form action="{{ route('platform_admin.ban', $tenant->id) }}" method="POST">
                  @csrf
                  <button type="submit" class="btn btn-sm btn-danger">Ban</button>
                </form>
              </li>
            @endforeach
          </ul>
        </div>

        <!-- Daftar Penyewa Dibanned -->
        <div id="penyewa-banned" class="mt-5">
          <h3>Penyewa Dibanned</h3>
          <ul class="list-group">
            @foreach ($bannedTenants as $tenant)
              <li class="list-group-item d-flex justify-content-between align-items-center">
                {{ $tenant->username }} ({{ $tenant->email }})
                <form action="{{ route('platform_admin.unban', $tenant->id) }}" method="POST">
                  @csrf
                  <button type="submit" class="btn btn-sm btn-success">Unban</button>
                </form>
              </li>
            @endforeach
          </ul>
        </div>
      </div>
    </main>
  </div>

  <!-- Footer -->
  <footer class="bg-dark text-white text-center py-3">
    <p class="mb-0">&copy; {{ date('Y') }} HomMie. Hak Cipta Dilindungi.</p>
  </footer>

  <!-- Bootstrap JS -->
  <script src="/assets/js/bootstrap.bundle.min.js"></script>
</body>

</html>