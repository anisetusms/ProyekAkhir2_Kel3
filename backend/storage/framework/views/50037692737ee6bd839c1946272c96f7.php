<!doctype html>
<html lang="en" data-bs-theme="light">

<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>HomMie | Dashboard Owner</title>
  <!--favicon-->
  <link rel="icon" href="<?php echo e(asset('owner/assets/images/favicon-32x32.png')); ?>" type="image/png">
  <!-- CSRF Token -->
  <meta name="csrf-token" content="<?php echo e(csrf_token()); ?>">
  <!-- Loader -->
  <link href="<?php echo e(asset('owner/assets/css/pace.min.css')); ?>" rel="stylesheet">
  <script src="<?php echo e(asset('owner/assets/js/pace.min.js')); ?>"></script>

  <!-- Plugins -->
  <link href="<?php echo e(asset('owner/assets/plugins/perfect-scrollbar/css/perfect-scrollbar.css')); ?>" rel="stylesheet">
  <link href="<?php echo e(asset('owner/assets/plugins/metismenu/metisMenu.min.css')); ?>" rel="stylesheet">
  <link href="<?php echo e(asset('owner/assets/plugins/simplebar/css/simplebar.css')); ?>" rel="stylesheet">

  <!-- Bootstrap CSS -->
  <link href="<?php echo e(asset('owner/assets/css/bootstrap.min.css')); ?>" rel="stylesheet">
  <link href="https://fonts.googleapis.com/css2?family=Noto+Sans:wght@300;400;500;600&display=swap" rel="stylesheet">
  <link href="https://fonts.googleapis.com/css?family=Material+Icons+Outlined" rel="stylesheet">

  <!-- Main CSS -->
  <link href="<?php echo e(asset('owner/assets/css/bootstrap-extended.css')); ?>" rel="stylesheet">
  <link href="<?php echo e(asset('owner/sass/main.css')); ?>" rel="stylesheet">
  <link href="<?php echo e(asset('owner/sass/dark-theme.css')); ?>" rel="stylesheet">
  <link href="<?php echo e(asset('owner/sass/blue-theme.css')); ?>" rel="stylesheet">
  <link href="<?php echo e(asset('owner/sass/semi-dark.css')); ?>" rel="stylesheet">
  <link href="<?php echo e(asset('owner/sass/bordered-theme.css')); ?>" rel="stylesheet">
  <link href="<?php echo e(asset('owner/sass/responsive.css')); ?>" rel="stylesheet">

  <!-- jQuery & SweetAlert -->
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
      <ul class="navbar-nav ms-auto">
        <!-- Notifications -->
        <li class="nav-item dropdown">
          <a class="nav-link dropdown-toggle dropdown-toggle-nocaret position-relative" data-bs-auto-close="outside"
            data-bs-toggle="dropdown" href="javascript:;">
            <i class="material-icons-outlined">notifications</i>
            <span class="badge-notify">5</span>
          </a>
          <div class="dropdown-menu dropdown-notify dropdown-menu-end shadow">
            <div class="px-3 py-1 d-flex align-items-center justify-content-between border-bottom">
              <h5 class="notiy-title mb-0">Notifications</h5>
            </div>
            <div class="notify-list">
              <div>
                <a class="dropdown-item border-bottom py-2" href="javascript:;">
                  <div class="d-flex align-items-center gap-3">
                    <div class="">
                      <img src="<?php echo e(asset('owner/assets/images/avatars/01.png')); ?>" class="rounded-circle" width="45" height="45" alt="">
                    </div>
                    <div class="">
                      <h5 class="notify-title">Congratulations Jhon</h5>
                      <p class="mb-0 notify-desc">You have won the gifts.</p>
                      <p class="mb-0 notify-time">Today</p>
                    </div>
                  </div>
                </a>
              </div>
            </div>
          </div>
        </li>

        <!-- User Profile -->
        <?php if(auth()->guard()->check()): ?>
        <li class="nav-item dropdown">
          <a href="javascript:;" class="dropdown-toggle dropdown-toggle-nocaret" data-bs-toggle="dropdown">
            <img src="<?php echo e(Auth::user()->profile_picture ? asset('storage/' . Auth::user()->profile_picture) : asset('owner/assets/images/avatars/default.png')); ?>"
              class="rounded-circle p-1 border" width="45" height="45" alt="Profile Picture">
          </a>
          <div class="dropdown-menu dropdown-user dropdown-menu-end shadow">
            <a class="dropdown-item gap-2 py-2" href="javascript:;">
              <div class="text-center">
                <img src="<?php echo e(Auth::user()->profile_picture ? asset('storage/' . Auth::user()->profile_picture) : asset('owner/assets/images/avatars/default.png')); ?>"
                  class="rounded-circle p-1 border" width="45" height="45" alt="Profile Picture">
                <h5 class="user-name mb-0 fw-bold">Hello, <?php echo e(Auth::user()->name); ?></h5>
              </div>
            </a>
            <hr class="dropdown-divider">
            <a class="dropdown-item d-flex align-items-center gap-2 py-2" href="javascript:;">
              <i class="material-icons-outlined">person_outline</i>Profile
            </a>
            <hr class="dropdown-divider">
            <form action="<?php echo e(route('logout')); ?>" method="POST">
              <?php echo csrf_field(); ?>
              <button type="submit" class="dropdown-item d-flex align-items-center gap-2 py-2">
                <i class="material-icons-outlined">power_settings_new</i>Logout
              </button>
            </form>
          </div>
        </li>
        <?php endif; ?>
      </ul>
    </nav>
  </header>
  <!-- End Header -->

  <!-- Sidebar -->
  <aside class="sidebar-wrapper" data-simplebar="true">
    <div class="sidebar-header">
      <div class="logo-icon">
        <img src="<?php echo e(asset('owner/assets/images/logo-icon.png')); ?>" class="logo-img" alt="Logo">
      </div>
      <div class="logo-name flex-grow-1">
        <h5 class="mb-0">HOM<span style="color: #289A84;">MIE</span></h5>
      </div>
    </div>
    <div class="sidebar-nav">
      <ul class="metismenu" id="sidenav">
        <li>
          <a href="<?php echo e(route('owner.dashboard')); ?>">
            <div class="parent-icon"><i class="material-icons-outlined">dashboard</i></div>
            <div class="menu-title">Dashboard</div>
          </a>
        </li>
        <li>
          <a href="<?php echo e(route('owner.property')); ?>">
            <div class="parent-icon"><i class="material-icons-outlined">inventory_2</i></div>
            <div class="menu-title">Property</div>
          </a>
        </li>
        <li>
          <a href="javascript:;">
            <div class="parent-icon"><i class="material-icons-outlined">person</i></div>
            <div class="menu-title">Profile</div>
          </a>
        </li>
      </ul>
    </div>
  </aside>
  <!-- End Sidebar -->

  <!-- Main Content -->
  <main class="main-wrapper">
    <div class="main-content">
      <?php echo $__env->yieldContent('content'); ?>
    </div>
  </main>
  <!-- End Main Content -->

  <!-- Footer -->
  <footer class="page-footer">
    <p class="mb-0">Copyright © 2024. All rights reserved.</p>
  </footer>
  <!-- End Footer -->

  <!-- Scripts -->
  <script src="<?php echo e(asset('owner/assets/js/bootstrap.bundle.min.js')); ?>"></script>
  <script src="<?php echo e(asset('owner/assets/plugins/perfect-scrollbar/js/perfect-scrollbar.js')); ?>"></script>
  <script src="<?php echo e(asset('owner/assets/plugins/metismenu/metisMenu.min.js')); ?>"></script>
  <script src="<?php echo e(asset('owner/assets/plugins/simplebar/js/simplebar.min.js')); ?>"></script>
  <script src="<?php echo e(asset('owner/assets/js/main.js')); ?>"></script>
</body>

</html><?php /**PATH E:\KULIAH\SEMESTER 4\PA2\ProyekAkhir2\backend\resources\views/layouts/index-owner.blade.php ENDPATH**/ ?>