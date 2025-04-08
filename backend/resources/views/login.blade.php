  <!doctype html>
  <html lang="en" data-bs-theme="">

  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Hommie | Login</title>
    <!--favicon-->
    <link rel="icon" href="assets/images/favicon-32x32.png" type="image/png">
    <!-- loader-->
    <link href="assets/css/pace.min.css" rel="stylesheet">
    <script src="assets/js/pace.min.js"></script>

    <!--plugins-->
    <link href="assets/plugins/perfect-scrollbar/css/perfect-scrollbar.css" rel="stylesheet">
    <link rel="stylesheet" type="text/css" href="assets/plugins/metismenu/metisMenu.min.css">
    <link rel="stylesheet" type="text/css" href="assets/plugins/metismenu/mm-vertical.css">
    <!--bootstrap css-->
    <link href="assets/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans:wght@300;400;500;600&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css?family=Material+Icons+Outlined" rel="stylesheet">
    <!--main css-->
    <link href="assets/css/bootstrap-extended.css" rel="stylesheet">
    <link href="sass/main.css" rel="stylesheet">
    <link href="sass/dark-theme.css" rel="stylesheet">
    <link href="sass/blue-theme.css" rel="stylesheet">
    <link href="sass/responsive.css" rel="stylesheet">

  </head>
  @if(session('success'))
  <div class="alert alert-success">
    {{ session('success') }}
  </div>
  @endif

  @if(session('error'))
  <div class="alert alert-danger">
    {{ session('error') }}
  </div>
  @endif

  @if(session('error'))
  <div class="alert alert-danger alert-dismissible fade show" role="alert">
    {{ session('error') }}
    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
  </div>
  @endif

  <body>
    <!--authentication-->

    <div class="section-authentication-cover">
      <div class="">
        <div class="row g-0">

          <div class="col-12 col-xl-7 col-xxl-8 auth-cover-left align-items-center justify-content-center d-none d-xl-flex border-end bg-transparent">

            <div class="card rounded-0 mb-0 border-0 shadow-none bg-transparent bg-none">
              <div class="card-body">
                <img src="assets/images/auth/login1.png" class="img-fluid auth-img-cover-login" width="650" alt="">
              </div>
            </div>

          </div>

          <div class="col-12 col-xl-5 col-xxl-4 auth-cover-right align-items-center justify-content-center border-top border-4 border-primary border-gradient-1">
            <div class="card rounded-0 m-3 mb-0 border-0 shadow-none bg-none">
              <div class="card-body p-sm-5">
                <img src="assets/images/logo1.png" class="mb-4" width="145" alt="">
                <h4 class="fw-bold">Get Started Now</h4>
                <p class="mb-0">Enter your credentials to login your account</p>

                <div class="row g-3 my-4">
                  <div class="col-12 col-lg-6">
                    <button class="btn btn-light py-2 font-text1 fw-bold d-flex align-items-center justify-content-center w-100"><img src="assets/images/apps/05.png" width="20" class="me-2" alt="">Google</button>
                  </div>
                  <div class="col col-lg-6">
                    <button class="btn btn-light py-2 font-text1 fw-bold d-flex align-items-center justify-content-center w-100"><img src="assets/images/apps/17.png" width="20" class="me-2" alt="">Facebook</button>
                  </div>
                </div>

                <div class="separator section-padding">
                  <div class="line"></div>
                  <p class="mb-0 fw-bold">OR</p>
                  <div class="line"></div>
                </div>

                <div class="form-body mt-4">
                  <form class="row g-3" id="loginForm" action="{{ route('login1') }}" method="POST">
                    @csrf

                    <div class="col-12">
                      <label for="inputEmailAddress" class="form-label">Email</label>
                      <input type="email" class="form-control" id="inputEmailAddress" name="email" placeholder="jhon@example.com" required>
                    </div>

                    <div class="col-12">
                      <label for="inputChoosePassword" class="form-label">Password</label>
                      <div class="input-group">
                        <input type="password" class="form-control" id="inputChoosePassword" name="password" placeholder="Enter Password" required>
                        <button type="button" class="input-group-text bg-transparent" onclick="togglePassword()">
                          <i class="bi bi-eye-slash-fill" id="toggleIcon"></i>
                        </button>
                      </div>
                    </div>

                    <div class="col-md-6">
                      <div class="form-check form-switch">
                        <input class="form-check-input" type="checkbox" id="flexSwitchCheckChecked" name="remember">
                        <label class="form-check-label" for="flexSwitchCheckChecked">Remember Me</label>
                      </div>
                    </div>

                    <div class="col-md-6 text-end">
                      {{-- <a href="{{ route('password.request') }}">Forgot Password?</a> --}}
                      <a href="">Forgot Password?</a>
                    </div>

                    <div class="col-12">
                      <div class="d-grid">
                        <button type="submit" class="btn btn-grd-primary">Login</button>
                      </div>
                    </div>

                    <div class="col-12">
                      <div class="text-start">
                        <p class="mb-0">Don't have an account yet? <a href="{{ route('register') }}">Sign up here</a></p>
                      </div>
                    </div>

                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                      Akun Anda telah diblokir. Silakan hubungi admin.
                      <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>

                  </form>
                </div>

              </div>
            </div>
          </div>

        </div>
        <!--end row-->
      </div>
    </div>

    <!--authentication-->
    <!--plugins-->
    <script src="assets/js/jquery.min.js"></script>

    <script>
      function togglePassword() {
        let passwordInput = document.getElementById("inputChoosePassword");
        let toggleIcon = document.getElementById("toggleIcon");

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