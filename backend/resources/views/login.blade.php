<!doctype html>
<html lang="en">

<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Hommie | Login</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
  <style>
    body {
      background-color: #f8f9fa;
      font-family: 'Noto Sans', sans-serif;
    }

    .login-container {
      max-width: 400px;
      margin: 100px auto;
      background-color: white;
      padding: 30px;
      border-radius: 10px;
      box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
    }

    .form-control:focus {
      box-shadow: none;
      border-color: #0d6efd;
    }

    .btn-primary {
      background-color: #0d6efd;
      border: none;
    }

    .btn-primary:hover {
      background-color: #0b5ed7;
    }

    .text-muted a {
      text-decoration: none;
    }

    .text-muted a:hover {
      text-decoration: underline;
    }
  </style>
</head>

<body>

  <div class="login-container">
    <h4 class="mb-3 text-center fw-bold">Selamat Datang</h4>
    <p class="text-center text-muted">Silakan login ke akun Anda</p>

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
  <script src="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.js"></script>
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
  </script>

</body>

</html>
