@extends('layouts.index-superadmin')

@section('content')
<body>
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
</body>
@endsection