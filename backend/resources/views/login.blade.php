<!doctype html>
<html lang="en" data-bs-theme="light">

<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Hommie | Login</title>
  <link href="https://fonts.googleapis.com/css2?family=Finger+Paint&display=swap" rel="stylesheet">

  <!-- Bootstrap & Icons -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
  <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
  <link href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css" rel="stylesheet">

  <style>
    body {
      font-family: 'Segoe UI', 'Noto Sans', sans-serif;
      background-color: var(--bs-body-bg);
      transition: background-color 0.3s ease;
    }

  .finger-paint {
    font-family: 'Finger Paint', cursive;
  }


    .login-card {
      max-width: 420px;
      width: 100%;
      background-color: var(--bs-body-bg);
      color: var(--bs-body-color);
      border-radius: 12px;
      box-shadow: 0 8px 24px rgba(0, 0, 0, 0.1);
      transition: background-color 0.3s ease, color 0.3s ease;
    }

    .form-control:focus {
      box-shadow: 0 0 0 0.2rem rgba(13, 110, 253, 0.25);
      border-color: #0d6efd;
    }

    .btn-primary {
      background-color: #0d6efd;
      border: none;
    }

    .btn-primary:hover {
      background-color: #0b5ed7;
    }

    .toggle-mode-btn {
      position: absolute;
      top: 20px;
      right: 20px;
    }

    .logo-img {
      width: 70px;
      border-radius: 8px;
    }
  </style>
</head>

<body class="d-flex align-items-center justify-content-center min-vh-100 bg-body-tertiary position-relative">

  <!-- Toggle Dark Mode -->
  <button class="btn btn-outline-secondary toggle-mode-btn" onclick="toggleTheme()">
    <i class="bi bi-moon-stars-fill me-1"></i> Mode
  </button>

  <!-- Login Card -->
  <div class="login-card card p-4 animate__animated animate__fadeIn">
    <div class="text-center mb-4">
    <img src="frontend/assets/logo/logo.jpg" alt="Logo" class="logo-img mb-2">
      <h4 class="finger-paint">Hommie</h4>
      <p class="text-muted mb-0">Silakan login ke akun Anda</p>
    </div>

    <form action="{{ route('login1') }}" method="POST">
      @csrf

      <div class="mb-3">
        <label for="email" class="form-label">Email</label>
        <input type="email" id="email" name="email" class="form-control" placeholder="email@example.com" required>
      </div>

      <div class="mb-3">
        <label for="password" class="form-label">Password</label>
        <div class="input-group">
          <input type="password" id="password" name="password" class="form-control" placeholder="Masukkan Password" required>
          <button class="btn btn-outline-secondary" type="button" onclick="togglePassword()">
            <i class="bi bi-eye-slash-fill" id="toggleIcon"></i>
          </button>
        </div>
      </div>

      <div class="mb-3 form-check">
        <input type="checkbox" class="form-check-input" id="remember" name="remember">
        <label class="form-check-label" for="remember">Ingat Saya</label>
      </div>

      <div class="d-grid mb-3">
        <button type="submit" class="btn btn-primary">Login</button>
      </div>

      <div class="text-center text-muted mb-2">
        <a href="#">Lupa Password?</a>
      </div>

      <div class="text-center text-muted">
        Belum punya akun? <a href="{{ route('register') }}">Daftar di sini</a>
      </div>

      @if(session('error'))
      <div class="alert alert-danger mt-3">
        {{ session('error') }}
      </div>
      @endif
    </form>
  </div>

  <!-- Script Section -->
  <script>
    function togglePassword() {
      const passwordInput = document.getElementById("password");
      const toggleIcon = document.getElementById("toggleIcon");

      if (passwordInput.type === "password") {
        passwordInput.type = "text";
        toggleIcon.classList.remove("bi-eye-slash-fill");
        toggleIcon.classList.add("bi-eye-fill");
      } else {
        passwordInput.type = "password";
        toggleIcon.classList.remove("bi-eye-fill");
        toggleIcon.classList.add("bi-eye-slash-fill");
      }
    }

    function toggleTheme() {
      const html = document.documentElement;
      const current = html.getAttribute("data-bs-theme");
      html.setAttribute("data-bs-theme", current === "light" ? "dark" : "light");
    }
  </script>

</body>

</html>
