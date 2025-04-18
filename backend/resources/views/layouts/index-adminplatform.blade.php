<!-- filepath: e:\KULIAH\SEMESTER 4\PA2\PA2\PA2\resources\views\layouts\index-adminplatform.blade.php -->
<!doctype html>
<html lang="en" data-bs-theme="light">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>HomMie | Dashboard Admin Platform</title>
    <!--favicon-->
    <link rel="icon" href="assets/images/logoHommie.jpg" type="image/png">
    <link rel="icon" href="{{ asset('owner/assets/images/favicon-32x32.png') }}" type="image/png">
    <!-- Loader -->
    <link href="{{ asset('owner/assets/css/pace.min.css') }}" rel="stylesheet">
    <script src="{{ asset('owner/assets/js/pace.min.js') }}"></script>

    <!-- Plugins -->
    <link href="{{ asset('owner/assets/plugins/perfect-scrollbar/css/perfect-scrollbar.css') }}" rel="stylesheet">
    <link href="{{ asset('owner/assets/plugins/metismenu/metisMenu.min.css') }}" rel="stylesheet">
    <link href="{{ asset('owner/assets/plugins/simplebar/css/simplebar.css') }}" rel="stylesheet">

    <!-- Bootstrap CSS -->
    <link href="{{ asset('owner/assets/css/bootstrap.min.css') }}" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans:wght@300;400;500;600&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css?family=Material+Icons+Outlined" rel="stylesheet">

    <!-- Main CSS -->
    <link href="{{ asset('owner/assets/css/bootstrap-extended.css') }}" rel="stylesheet">
    <link href="{{ asset('owner/sass/main.css') }}" rel="stylesheet">
    <link href="{{ asset('owner/sass/dark-theme.css') }}" rel="stylesheet">
    <link href="{{ asset('owner/sass/blue-theme.css') }}" rel="stylesheet">
    <link href="{{ asset('owner/sass/semi-dark.css') }}" rel="stylesheet">
    <link href="{{ asset('owner/sass/bordered-theme.css') }}" rel="stylesheet">
    <link href="{{ asset('owner/sass/responsive.css') }}" rel="stylesheet">

    <!-- Tambahan -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
  </head>

  <body>
    <!-- Header -->
    <header class="top-header">
      <nav class="navbar navbar-expand align-items-center gap-4">
        <div class="btn-toggle">
          <a href="javascript:;"><i class="material-icons-outlined">menu</i></a>
        </div>
        <div class="search-bar flex-grow-1">
          <div class="position-relative">
            <input class="form-control rounded-5 px-5 search-control d-lg-block d-none" type="text" placeholder="Search">
            <span class="material-icons-outlined position-absolute d-lg-block d-none ms-3 translate-middle-y start-0 top-50">search</span>
            <span class="material-icons-outlined position-absolute me-3 translate-middle-y end-0 top-50 search-close">close</span>
          </div>
        </div>
        <ul class="navbar-nav gap-1 nav-right-links align-items-center">

          <!-- User Profile -->
          @auth
          <li class="nav-item dropdown">
            <a href="javascript:;" class="dropdown-toggle dropdown-toggle-nocaret" data-bs-toggle="dropdown">
              <img src="{{ Auth::user()->profile_picture ? asset('storage/' . Auth::user()->profile_picture) : asset('assets/images/avatars/default.png') }}"
                class="rounded-circle p-1 border" width="45" height="45" alt="">
            </a>
            <div class="dropdown-menu dropdown-user dropdown-menu-end shadow">
              <a class="dropdown-item gap-2 py-2" href="javascript:;">
                <div class="text-center">
                  <img src="{{ Auth::user()->profile_picture ? asset('storage/' . Auth::user()->profile_picture) : asset('assets/images/avatars/default.png') }}"
                    class="rounded-circle p-1 border" width="45" height="45" alt="">
                  <h5 class="user-name mb-0 fw-bold">Hello, {{ Auth::user()->name }}</h5>
                </div>
              </a>
              <hr class="dropdown-divider">
              <form action="{{ route('logout') }}" method="POST">
                @csrf
                <button type="submit" class="dropdown-item d-flex align-items-center gap-2 py-2">
                  <i class="material-icons-outlined">power_settings_new</i>Logout
                </button>
              </form>
            </div>
          </li>
          @endauth
        </ul>
      </nav>
    </header>

    <!-- Sidebar -->
    <aside class="sidebar-wrapper" data-simplebar="true">
      <div class="sidebar-header">
        <div class="logo-icon">
          <img src="assets/images/logo-icon.png" class="logo-img" alt="">
        </div>
        <div class="logo-name flex-grow-1">
          <h5 class="mb-0">HOM<span style="color: #289A84;">MIE</h5>
        </div>
        <div class="sidebar-close">
          <span class="material-icons-outlined">close</span>
        </div>
      </div>
      <div class="sidebar-nav">
        <ul class="metismenu" id="sidenav">
          <li>
            <a href="{{ route('platform_admin.dashboard') }}">
              <div class="parent-icon"><i class="material-icons-outlined">dashboard</i></div>
              <div class="menu-title">Dashboard</div>
            </a>
          </li>
          <li>
            <a href="{{ route('platform_admin.pengusaha') }}">
              <div class="parent-icon"><i class="material-icons-outlined">business</i></div>
              <div class="menu-title">Pengusaha</div>
            </a>
          </li>
          <li>
            <a href="{{ route('platform_admin.penyewa') }}">
              <div class="parent-icon"><i class="material-icons-outlined">home</i></div>
              <div class="menu-title">Penyewa</div>
            </a>
          </li>
          <li>
            <a href="{{ route('platform_admin.profil') }}">
              <div class="parent-icon"><i class="material-icons-outlined">person</i></div>
              <div class="menu-title">Profil</div>
            </a>
          </li>
        </ul>
      </div>
    </aside>

    <!-- Main Wrapper -->
    <main class="main-wrapper">
      <div class="main-content">
        @yield('content')
      </div>
    </main>

    <!-- Footer -->
    <footer class="page-footer">
      <p class="mb-0">Copyright © 2024. All right reserved.</p>
    </footer>

    <!-- Bootstrap JS -->
    <script src="{{ asset('owner/assets/js/bootstrap.bundle.min.js') }}"></script>
    <script src="{{ asset('owner/assets/js/main.js') }}"></script>
  </body>
</html>