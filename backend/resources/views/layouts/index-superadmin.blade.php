<!DOCTYPE html>
<html lang="id">

<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta name="description" content="Dashboard Super Admin Hommie">
    <meta name="author" content="Hommie Team">
    <title>@yield('title') - {{ config('app.name') }}</title>

    <!-- Favicon -->
    <link rel="shortcut icon" href="{{ asset('favicon.ico') }}">

    <!-- Font Awesome -->
    <link href="{{ asset('vendor/fontawesome-free/css/all.min.css') }}" rel="stylesheet" type="text/css">

    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css?family=Nunito:200,200i,300,300i,400,400i,600,600i,700,700i,800,800i,900,900i" rel="stylesheet">

    <!-- SB Admin 2 CSS -->
    <link href="{{ asset('css/sb-admin-2.min.css') }}" rel="stylesheet">

    <!-- Custom Styles -->
    <style>
        /* Improved Sidebar Styles */
        .sidebar {
            background-color: #4e73df;
            color: white;
            box-shadow: 0 0.15rem 1.75rem 0 rgba(58, 59, 69, 0.15);
        }

        .sidebar-brand {
            height: 4.375rem;
        }

        .sidebar-brand-text {
            font-weight: 800;
            letter-spacing: 0.05rem;
        }

        .sidebar-nav-link {
            font-size: 1rem;
            padding: 0.75rem 1.25rem;
            color: #ffffff;
            transition: background-color 0.2s;
        }

        .sidebar-nav-link:hover {
            background-color: #575fcf;
            color: #ffffff;
        }

        .dropdown-item {
            font-size: 0.85rem;
            padding: 0.5rem 1.5rem;
            color: #4e73df;
            transition: background-color 0.2s;
        }

        .dropdown-item:hover {
            background-color: #f8f9fa;
        }

        .badge-counter {
            position: absolute;
            transform: scale(0.7);
            transform-origin: top right;
            right: 0.25rem;
            top: 0.25rem;
            background-color: red;
            color: white;
        }

        /* Enhanced Navbar */
        .topbar .navbar-nav .nav-link {
            color: #4e73df;
            transition: all 0.2s ease-in-out;
        }

        .topbar .navbar-nav .nav-link:hover {
            color: #2e59d9;
        }

        .img-profile {
            width: 40px;
            height: 40px;
            object-fit: cover;
            border: 2px solid #e3e6f0;
        }
    </style>

    @stack('styles')
</head>

<body id="page-top">

    <!-- Page Wrapper -->
    <div id="wrapper">

        <!-- Sidebar -->
        <ul class="navbar-nav bg-gradient-primary sidebar sidebar-dark accordion" id="accordionSidebar">

            <!-- Sidebar Brand -->
            <a class="sidebar-brand d-flex align-items-center justify-content-center" href="{{ route('super_admin.dashboard') }}">
                <div class="sidebar-brand-icon">
                    <i class="fas fa-home"></i>
                </div>
                <div class="sidebar-brand-text mx-3">HOMMIE</div>
            </a>

            <!-- Divider -->
            <hr class="sidebar-divider my-0">

            <!-- Nav Item - Dashboard -->
            <li class="nav-item {{ request()->routeIs('super_admin.dashboard') ? 'active' : '' }}">
                <a class="nav-link" href="{{ route('super_admin.dashboard') }}">
                    <i class="fas fa-fw fa-tachometer-alt"></i>
                    <span>Dashboard</span>
                </a>
            </li>

            <!-- Divider -->
            <hr class="sidebar-divider">

            <!-- Heading -->
            <div class="sidebar-heading">
                Manajemen Pengguna
            </div>

            <!-- Nav Item - Owner Dropdown -->
            <li class="nav-item dropdown {{ request()->routeIs('super_admin.entrepreneurs.*') ? 'active' : '' }}">
                <a class="nav-link dropdown-toggle" href="#" id="ownerDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                    <i class="fas fa-fw fa-building"></i>
                    <span>Owner</span>
                </a>
                <!-- Dropdown - Owner Menu -->
                <div class="dropdown-menu shadow animated--grow-in" aria-labelledby="ownerDropdown">
                    <h6 class="dropdown-header">Manajemen Owner:</h6>
                    <a class="dropdown-item" href="{{ route('super_admin.entrepreneurs.pending') }}">
                        <i class="fas fa-user-clock mr-2 text-gray-400"></i>
                        Menunggu Persetujuan
                        @if($pendingOwnerCount ?? '0' > 0)
                            <span class="badge badge-danger badge-pill float-right">{{ $pendingOwnerCount }}</span>
                        @endif
                    </a>
                    <a class="dropdown-item" href="{{ route('super_admin.entrepreneurs.approved') }}">
                        <i class="fas fa-users mr-2 text-gray-400"></i>
                        Daftar Owner
                    </a>
                    <div class="dropdown-divider"></div>
                    <a class="dropdown-item" href="{{ route('super_admin.entrepreneurs.create') }}">
                        <i class="fas fa-plus-circle mr-2 text-success"></i>
                        Tambah Owner Baru
                    </a>
                </div>
            </li>

            <!-- Nav Item - Platform Admins -->
            <li class="nav-item {{ request()->routeIs('super_admin.platform_admins.*') ? 'active' : '' }}">
                <a class="nav-link" href="{{ route('super_admin.platform_admins.index') }}">
                    <i class="fas fa-fw fa-user-shield"></i>
                    <span>Admin Officier</span>
                </a>
            </li>

            <!-- Divider -->
            <hr class="sidebar-divider">

            <!-- Heading -->
            <div class="sidebar-heading">
                Manajemen Sistem
            </div>

            <!-- Nav Item - Profile -->
            <li class="nav-item {{ request()->routeIs('super_admin.profiles.*') ? 'active' : '' }}">
                <a class="nav-link" href="{{ route('super_admin.profiles.index') }}">
                    <i class="fas fa-fw fa-user-cog"></i>
                    <span>Profil</span>
                </a>
            </li>

            <!-- Nav Item - Settings -->
            <li class="nav-item {{ request()->routeIs('super_admin.settings') ? 'active' : '' }}">
                <a class="nav-link" href="{{ route('super_admin.settings') }}">
                    <i class="fas fa-fw fa-cogs"></i>
                    <span>Pengaturan</span>
                </a>
            </li>

            <!-- Divider -->
            <hr class="sidebar-divider d-none d-md-block">

            <!-- Sidebar Toggler (Sidebar) -->
            <div class="text-center d-none d-md-inline">
                <button class="rounded-circle border-0" id="sidebarToggle"></button>
            </div>

        </ul>
        <!-- End of Sidebar -->

        <!-- Content Wrapper -->
        <div id="content-wrapper" class="d-flex flex-column">

            <!-- Main Content -->
            <div id="content">

                <!-- Topbar -->
                <nav class="navbar navbar-expand navbar-light bg-white topbar mb-4 static-top shadow">

                    <!-- Sidebar Toggle (Topbar) -->
                    <button id="sidebarToggleTop" class="btn btn-link d-md-none rounded-circle mr-3">
                        <i class="fa fa-bars"></i>
                    </button>

                    <!-- Topbar Search -->
                    <form class="d-none d-sm-inline-block form-inline mr-auto ml-md-3 my-2 my-md-0 mw-100 navbar-search">
                        <div class="input-group">
                            <input type="text" class="form-control bg-light border-0 small" placeholder="Search for..." aria-label="Search">
                            <div class="input-group-append">
                                <button class="btn btn-primary" type="submit">
                                    <i class="fas fa-search fa-sm"></i>
                                </button>
                            </div>
                        </div>
                    </form>

                    <!-- Topbar Navbar -->
                    <ul class="navbar-nav ml-auto">

                        <!-- Nav Item - Alerts -->
                        <li class="nav-item dropdown no-arrow mx-1">
                            <a class="nav-link dropdown-toggle" href="#" id="alertsDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                <i class="fas fa-bell fa-fw"></i>
                                <!-- Counter - Alerts -->
                                @if($pendingOwnerCount ?? '0' > 0)
                                    <span class="badge badge-danger badge-counter">{{ $pendingOwnerCount }}</span>
                                @endif
                            </a>
                            <!-- Dropdown - Alerts -->
                            <div class="dropdown-list dropdown-menu dropdown-menu-right shadow animated--grow-in" aria-labelledby="alertsDropdown">
                                <h6 class="dropdown-header">
                                    Notifikasi Terbaru
                                </h6>
                                @if($pendingOwnerCount ?? '0' > 0 )
                                    <a class="dropdown-item d-flex align-items-center" href="{{ route('super_admin.entrepreneurs.pending') }}">
                                        <div class="mr-3">
                                            <div class="icon-circle bg-primary">
                                                <i class="fas fa-user-clock text-white"></i>
                                            </div>
                                        </div>
                                        <div>
                                            <span class="font-weight-bold">Ada {{ $pendingOwnerCount }} owner menunggu persetujuan</span>
                                        </div>
                                    </a>
                                @else
                                    <a class="dropdown-item text-center py-3">
                                        <i class="fas fa-bell-slash text-gray-400 fa-2x mb-2"></i>
                                        <div>Tidak ada notifikasi baru</div>
                                    </a>
                                @endif
                                <a class="dropdown-item text-center small text-gray-500" href="{{ route('super_admin.entrepreneurs.pending') }}">Lihat Semua Notifikasi</a>
                            </div>
                        </li>

                        <div class="topbar-divider d-none d-sm-block"></div>

                        <!-- Nav Item - User Information -->
                        <li class="nav-item dropdown no-arrow">
                            <a class="nav-link dropdown-toggle" href="#" id="userDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                <span class="mr-2 d-none d-lg-inline text-gray-600 small">{{ Auth::user()->name }}</span>
                                <img class="img-profile rounded-circle" src="{{ Auth::user()->profile_picture ? asset('storage/profile_pictures/' . Auth::user()->profile_picture) : asset('img/undraw_profile.svg') }}" alt="Profile Picture">
                            </a>
                            <!-- Dropdown - User Information -->
                            <div class="dropdown-menu dropdown-menu-right shadow animated--grow-in" aria-labelledby="userDropdown">
                                <a class="dropdown-item" href="{{ route('super_admin.profiles.index') }}">
                                    <i class="fas fa-user fa-sm fa-fw mr-2 text-gray-400"></i>
                                    Profil
                                </a>
                                <a class="dropdown-item" href="{{ route('super_admin.settings') }}">
                                    <i class="fas fa-cogs fa-sm fa-fw mr-2 text-gray-400"></i>
                                    Pengaturan
                                </a>
                                <div class="dropdown-divider"></div>
                                <a class="dropdown-item" href="#" data-toggle="modal" data-target="#logoutModal">
                                    <i class="fas fa-sign-out-alt fa-sm fa-fw mr-2 text-gray-400"></i>
                                    Keluar
                                </a>
                            </div>
                        </li>

                    </ul>

                </nav>
                <!-- End of Topbar -->

                <!-- Begin Page Content -->
                <div class="container-fluid">

                    <!-- Page Heading -->
                    <div class="d-sm-flex align-items-center justify-content-between mb-4 content-header">
                        <h1 class="h3 mb-0 text-gray-800">@yield('title')</h1>
                        @hasSection('action_button')
                            @yield('action_button')
                        @endif
                    </div>

                    <!-- Alert Messages -->
                    <div class="row">
                        <div class="col-12">
                            @include('layouts.partials.alerts')
                        </div>
                    </div>

                    <!-- Main Content -->
                    @yield('content')

                </div>
                <!-- /.container-fluid -->

            </div>
            <!-- End of Main Content -->

            <!-- Footer -->
            <footer class="sticky-footer bg-white">
                <div class="container my-auto">
                    <div class="copyright text-center my-auto">
                        <span>Copyright &copy; {{ config('app.name') }} {{ date('Y') }}</span>
                    </div>
                </div>
            </footer>
            <!-- End of Footer -->

        </div>
        <!-- End of Content Wrapper -->

    </div>
    <!-- End of Page Wrapper -->

    <!-- Scroll to Top Button-->
    <a class="scroll-to-top rounded" href="#page-top">
        <i class="fas fa-angle-up"></i>
    </a>

    <!-- Logout Modal-->
    <div class="modal fade" id="logoutModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="exampleModalLabel">Siap untuk keluar?</h5>
                    <button class="close" type="button" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">×</span>
                    </button>
                </div>
                <div class="modal-body">Pilih "Keluar" di bawah ini jika Anda siap untuk mengakhiri sesi saat ini.</div>
                <div class="modal-footer">
                    <button class="btn btn-secondary" type="button" data-dismiss="modal">Batal</button>
                    <form action="{{ route('logout') }}" method="POST">
                        @csrf
                        <button type="submit" class="btn btn-primary">Keluar</button>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <!-- Bootstrap core JavaScript-->
    <script src="{{ asset('vendor/jquery/jquery.min.js') }}"></script>
    <script src="{{ asset('vendor/bootstrap/js/bootstrap.bundle.min.js') }}"></script>

    <!-- Core plugin JavaScript-->
    <script src="{{ asset('vendor/jquery-easing/jquery.easing.min.js') }}"></script>

    <!-- Custom scripts for all pages-->
    <script src="{{ asset('js/sb-admin-2.min.js') }}"></script>

    <!-- Custom Scripts -->
    <script>
        // Enhanced dropdown functionality
        $(document).ready(function() {
            // Better dropdown hover effect
            $('.dropdown').hover(function() {
                $(this).find('.dropdown-menu').stop(true, true).delay(100).fadeIn(200);
            }, function() {
                $(this).find('.dropdown-menu').stop(true, true).delay(100).fadeOut(200);
            });

            // Initialize tooltips
            $('[data-toggle="tooltip"]').tooltip();
        });
    </script>

    @stack('scripts')
</body>

</html>
