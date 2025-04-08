<!DOCTYPE html>
<html lang="id" data-bs-theme="light">

<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>HomMie | Dashboard Super Admin</title>
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
      <h1 class="h4 mb-0">Dashboard Super Admin</h1>
      <div class="dropdown">
        <a href="#" class="text-white text-decoration-none dropdown-toggle" data-bs-toggle="dropdown">
          <img src="{{ Auth::user()->profile_picture ? asset('storage/' . Auth::user()->profile_picture) : asset('assets/images/avatars/default.png') }}" class="rounded-circle" width="40" height="40" alt="Profil">
          <span>{{ Auth::user()->name }}</span>
        </a>
        <ul class="dropdown-menu dropdown-menu-end">
          <li><a class="dropdown-item" href="#">Profil</a></li>
          <li><a class="dropdown-item" href="{{ route('landingpage') }}">Web</a></li>
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
        <a href="{{ route('super_admin.dashboard') }}" class="nav-link text-dark {{ request()->routeIs('super_admin.dashboard') ? 'fw-bold' : '' }}">
          <i class="material-icons-outlined">dashboard</i> Dashboard
        </a>
        <a href="{{ route('super_admin.entrepreneurs.index') }}" class="nav-link text-dark {{ request()->routeIs('super_admin.entrepreneurs.index') ? 'fw-bold' : '' }}">
          <i class="material-icons-outlined">group</i> Pemilik Kost
        </a>
        <a href="{{ route('super_admin.platform_admins.index') }}" class="nav-link text-dark {{ request()->routeIs('super_admin.platform_admins.index') ? 'fw-bold' : '' }}">
          <i class="material-icons-outlined">admin_panel_settings</i> Admin Platform
        </a>
        <a href="{{ route('super_admin.profiles.index') }}" class="nav-link text-dark {{ request()->routeIs('super_admin.profiles.index') ? 'fw-bold' : '' }}">
          <i class="material-icons-outlined">person</i> Profil
        </a>
      </nav>
    </aside>

    <!-- Konten Utama -->
    <main class="flex-grow-1 p-4">
      <div class="container">
        <h2>Selamat Datang, {{ Auth::user()->name }}</h2>
        <p>Gunakan menu navigasi untuk mengelola pemilik kost, admin platform, dan profil pengguna.</p>

        <div class="row">
          <div class="col-md-4">
            <div class="card shadow-sm">
              <div class="card-body text-center">
                <i class="material-icons-outlined text-primary" style="font-size: 48px;">group</i>
                <h5 class="card-title mt-3">Pemilik Kost</h5>
                <p class="card-text">Kelola pemilik kost.</p>
                <a href="{{ route('super_admin.entrepreneurs.index') }}" class="btn btn-primary">Lihat</a>
              </div>
            </div>
          </div>
          <div class="col-md-4">
            <div class="card shadow-sm">
              <div class="card-body text-center">
                <i class="material-icons-outlined text-success" style="font-size: 48px;">admin_panel_settings</i>
                <h5 class="card-title mt-3">Admin Platform</h5>
                <p class="card-text">Kelola administrator platform.</p>
                <a href="{{ route('super_admin.platform_admins.index') }}" class="btn btn-success">Lihat</a>
              </div>
            </div>
          </div>
          <div class="col-md-4">
            <div class="card shadow-sm">
              <div class="card-body text-center">
                <i class="material-icons-outlined text-warning" style="font-size: 48px;">person</i>
                <h5 class="card-title mt-3">Profil Pengguna</h5>
                <p class="card-text">Kelola profil pengguna.</p>
                <a href="{{ route('super_admin.profiles.index') }}" class="btn btn-warning">Lihat</a>
              </div>
            </div>
          </div>
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