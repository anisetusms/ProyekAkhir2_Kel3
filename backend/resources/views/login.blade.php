<!doctype html>
<html lang="en">

<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Hommie | Login</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
  <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
  <style>
    :root {
      --primary-color: #4361ee;
      --secondary-color: #3f37c9;
      --accent-color: #4895ef;
      --light-color: #f8f9fa;
      --dark-color: #212529;
    }
    
    body {
      background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
      font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
      min-height: 100vh;
      display: flex;
      align-items: center;
      justify-content: center;
    }

    .login-container {
      width: 100%;
      max-width: 420px;
      background-color: white;
      padding: 2.5rem;
      border-radius: 16px;
      box-shadow: 0 10px 25px rgba(0, 0, 0, 0.08);
      transition: all 0.3s ease;
    }

    .login-container:hover {
      box-shadow: 0 15px 30px rgba(0, 0, 0, 0.12);
    }

    .login-header {
      text-align: center;
      margin-bottom: 2rem;
    }

    .login-logo {
      width: 80px;
      height: 80px;
      margin: 0 auto 1rem;
      background-color: var(--primary-color);
      border-radius: 50%;
      display: flex;
      align-items: center;
      justify-content: center;
      color: white;
      font-size: 2rem;
      box-shadow: 0 4px 12px rgba(67, 97, 238, 0.3);
    }

    .login-title {
      font-weight: 700;
      color: var(--dark-color);
      margin-bottom: 0.5rem;
    }

    .login-subtitle {
      color: #6c757d;
      font-size: 0.9rem;
    }

    .form-control {
      padding: 0.75rem 1rem;
      border-radius: 8px;
      border: 1px solid #e0e0e0;
      transition: all 0.3s;
    }

    .form-control:focus {
      box-shadow: 0 0 0 0.25rem rgba(67, 97, 238, 0.25);
      border-color: var(--primary-color);
    }

    .input-group-text {
      background-color: white;
      border-radius: 0 8px 8px 0;
      cursor: pointer;
      transition: all 0.3s;
    }

    .input-group-text:hover {
      background-color: #f8f9fa;
    }

    .btn-login {
      background-color: var(--primary-color);
      border: none;
      padding: 0.75rem;
      border-radius: 8px;
      font-weight: 600;
      letter-spacing: 0.5px;
      transition: all 0.3s;
    }

    .btn-login:hover {
      background-color: var(--secondary-color);
      transform: translateY(-2px);
    }

    .btn-login:active {
      transform: translateY(0);
    }

    .form-check-input:checked {
      background-color: var(--primary-color);
      border-color: var(--primary-color);
    }

    .login-footer {
      text-align: center;
      margin-top: 1.5rem;
      font-size: 0.9rem;
    }

    .login-footer a {
      color: var(--primary-color);
      text-decoration: none;
      font-weight: 500;
      transition: all 0.2s;
    }

    .login-footer a:hover {
      color: var(--secondary-color);
      text-decoration: underline;
    }

    .divider {
      display: flex;
      align-items: center;
      margin: 1.5rem 0;
      color: #6c757d;
      font-size: 0.8rem;
    }

    .divider::before,
    .divider::after {
      content: "";
      flex: 1;
      border-bottom: 1px solid #dee2e6;
    }

    .divider::before {
      margin-right: 1rem;
    }

    .divider::after {
      margin-left: 1rem;
    }

    .alert {
      border-radius: 8px;
    }

    @media (max-width: 576px) {
      .login-container {
        padding: 1.5rem;
        margin: 1rem;
      }
    }
  </style>
</head>

<body>
  <div class="login-container">
    <div class="login-header">
      <div class="login-logo">
        <i class="bi bi-house-door"></i>
      </div>
      <h2 class="login-title">Selamat Datang</h2>
      <p class="login-subtitle">Silakan login ke akun Anda</p>
    </div>

    <form action="{{ route('login1') }}" method="POST">
      @csrf

      <div class="mb-3">
        <label for="email" class="form-label">Email</label>
        <div class="input-group">
          <span class="input-group-text"><i class="bi bi-envelope"></i></span>
          <input type="email" id="email" name="email" class="form-control" placeholder="email@example.com" required>
        </div>
      </div>

      <div class="mb-3">
        <label for="password" class="form-label">Password</label>
        <div class="input-group">
          <input type="password" id="password" name="password" class="form-control" placeholder="Masukkan Password" required>
          <button class="input-group-text" type="button" onclick="togglePassword()">
            <i class="bi bi-eye-slash-fill" id="toggleIcon"></i>
          </button>
        </div>
      </div>

      <div class="mb-3 d-flex justify-content-between align-items-center">
        <div class="form-check">
          <input class="form-check-input" type="checkbox" id="remember" name="remember">
          <label class="form-check-label" for="remember">Ingat Saya</label>
        </div>
        <a href="#" class="text-decoration-none">Lupa Password?</a>
      </div>

      <div class="d-grid mb-3">
        <button type="submit" class="btn btn-login text-white">Login</button>
      </div>

      @if(session('error'))
      <div class="alert alert-danger mt-3">
        <i class="bi bi-exclamation-triangle-fill me-2"></i>
        {{ session('error') }}
      </div>
      @endif

      <div class="divider">ATAU</div>

      <div class="login-footer">
        Belum punya akun? <a href="{{ route('register') }}">Daftar di sini</a>
      </div>
    </form>
  </div>

  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
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
    
    // Efek hover pada tombol login
    const loginBtn = document.querySelector('.btn-login');
    loginBtn.addEventListener('mouseenter', () => {
      loginBtn.style.boxShadow = '0 5px 15px rgba(67, 97, 238, 0.4)';
    });
    loginBtn.addEventListener('mouseleave', () => {
      loginBtn.style.boxShadow = 'none';
    });
  </script>
</body>

</html>