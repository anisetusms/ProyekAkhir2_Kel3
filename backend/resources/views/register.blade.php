<!doctype html>
<html lang="en" data-bs-theme="">

<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>TobaStay | Register</title>
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

  {{-- ditambahkan --}}
  <!-- Tambahkan CSS intl-tel-input -->
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/intl-tel-input/17.0.8/css/intlTelInput.css" />
  {{-- /ditambahkan --}}

  </head>

<body>


  <!--authentication-->

  <div class="section-authentication-cover">
    <div class="">
      <div class="row g-0">

        <div class="col-12 col-xl-7 col-xxl-8 auth-cover-left align-items-center justify-content-center d-none d-xl-flex border-end bg-transparent">

          <div class="card rounded-0 mb-0 border-0 shadow-none bg-transparent bg-none">
            <div class="card-body">
              <img src="assets/images/auth/register1.png" class="img-fluid auth-img-cover-login" width="500"
                alt="">
            </div>
          </div>

        </div>

        <div class="col-12 col-xl-5 col-xxl-4 auth-cover-right align-items-center justify-content-center">
          <div class="card rounded-0 m-3 border-0 shadow-none bg-none">
            <div class="card-body p-sm-5">
              <img src="assets/images/logo1.png" class="mb-4" width="145" alt="">
              <h4 class="fw-bold">Get Started Now</h4>
              <p class="mb-0">Enter your credentials to create your account</p>

              <div class="row g-3 my-4">
                <div class="col-12 col-lg-6">
                  <button class="btn btn-filter py-2 font-text1 fw-bold d-flex align-items-center justify-content-center w-100"><img src="assets/images/apps/05.png" width="20" class="me-2" alt="">Google</button>
                </div>
                <div class="col col-lg-6">
                  <button class="btn btn-filter py-2 font-text1 fw-bold d-flex align-items-center justify-content-center w-100"><img src="assets/images/apps/17.png" width="20" class="me-2" alt="">Facebook</button>
                </div>
              </div>

              <div class="separator section-padding">
                <div class="line"></div>
                <p class="mb-0 fw-bold">OR</p>
                <div class="line"></div>
              </div>

              <div class="form-body mt-4">
                {{-- <form class="row g-3" id="registerForm" action="{{ route('insertRegister') }}" method="POST">
                    @csrf
                    <div class="col-12">
                        <label for="inputFullName" class="form-label">Full Name</label>
                        <input type="text" class="form-control" id="inputFullName" name="name" placeholder="John Doe" required>
                    </div>
                    <div class="col-12">
                        <label for="inputUsername" class="form-label">Username</label>
                        <input type="text" class="form-control" id="inputUsername" name="username" placeholder="Jhon123" required>
                    </div>
                    <div class="col-12">
                        <label for="inputEmailAddress" class="form-label">Email Address</label>
                        <input type="email" class="form-control" id="inputEmailAddress" name="email" placeholder="example@user.com" required>
                    </div>
                    <div class="col-12">
                        <label for="inputPhoneNumber" class="form-label">Phone Number</label>
                        <input type="tel" class="form-control" id="inputPhoneNumber" name="phone" required>
                    </div>
                    <div class="col-12">
                        <label for="inputUserType" class="form-label">Tipe User</label>
                        <select class="form-control" id="inputUserType" name="user_type_id" required>
                            <option value="" selected disabled>Pilih tipe user</option>
                            @foreach($userTypes as $userType)
                                <option value="{{ $userType->id }}">{{ $userType->userType_name }}</option>
                            @endforeach
                        </select>
                    </div>                  
                    <div class="col-12">
                        <label for="inputChoosePassword" class="form-label">Password</label>
                        <div class="input-group">
                            <input type="password" class="form-control" id="inputChoosePassword" name="password" placeholder="Enter Password" required>
                            <a href="javascript:;" class="input-group-text bg-transparent" onclick="togglePassword()">
                                <i class="bi bi-eye-slash-fill"></i>
                            </a>
                        </div>
                    </div>
                    <div class="col-12">
                        <label for="inputConfirmPassword" class="form-label">Confirm Password</label>
                        <input type="password" class="form-control" id="inputConfirmPassword" name="password_confirmation" placeholder="Confirm Password" required>
                    </div>
                    
                    <div class="col-12">
                        <div class="form-check form-switch">
                            <input class="form-check-input" type="checkbox" id="flexSwitchCheckChecked" required>
                            <label class="form-check-label" for="flexSwitchCheckChecked">I agree to the Terms & Conditions</label>
                        </div>
                    </div>
            
                    <div class="col-12">
                        <!-- Google reCAPTCHA -->
                        <div class="g-recaptcha" data-sitekey="YOUR_RECAPTCHA_SITE_KEY"></div>
                    </div>
            
                    <div class="col-12">
                        <div class="d-grid">
                            <button type="submit" class="btn btn-grd-danger">Register</button>
                        </div>
                    </div>
            
                    <div class="col-12">
                        <div class="text-start">
                            <p class="mb-0">Already have an account?
                                <a href="{{ route('showLoginForm') }}">Sign in here</a>
                            </p>
                        </div>
                    </div>
                </form> --}}
                <form class="row g-3" id="registerForm" action="{{ route('insertRegister') }}" method="POST">
                  @csrf
                  <div class="col-12">
                      <label for="inputFullName" class="form-label">Full Name</label>
                      <input type="text" class="form-control" id="inputFullName" name="name" required>
                  </div>
                  <div class="col-12">
                      <label for="inputUsername" class="form-label">Username</label>
                      <input type="text" class="form-control" id="inputUsername" name="username" required>
                  </div>
                  <div class="col-12">
                      <label for="inputEmailAddress" class="form-label">Email Address</label>
                      <input type="email" class="form-control" id="inputEmailAddress" name="email" required>
                  </div>
                  <div class="col-12">
                      <label for="inputPhoneNumber" class="form-label">Phone Number</label>
                      <input type="tel" class="form-control" id="inputPhoneNumber" name="phone" required>
                  </div>
                  <div class="col-12">
                      <label for="inputUserType" class="form-label">Tipe User</label>
                      <select class="form-control" id="inputUserType" name="user_type_id" required>
                          <option value="" selected disabled>Pilih tipe user</option>
                          @foreach($userTypes as $userType)
                              <option value="{{ $userType->id }}">{{ $userType->userType_name }}</option>
                          @endforeach
                      </select>
                  </div>
                  <div class="col-12">
                      <label for="inputUserRole" class="form-label">Role User</label>
                      <select class="form-control" id="inputUserRole" name="user_role_id" required>
                          <option value="" selected disabled>Pilih role user</option>
                          @foreach($userRoles as $userRole)
                              <option value="{{ $userRole->id }}">{{ $userRole->role_name }}</option>
                          @endforeach
                      </select>
                  </div>
                  <div class="col-12">
                      <label for="inputChoosePassword" class="form-label">Password</label>
                      <div class="input-group">
                          <input type="password" class="form-control" id="inputChoosePassword" name="password" required>
                          <a href="javascript:;" class="input-group-text bg-transparent" onclick="togglePassword()">
                              <i class="bi bi-eye-slash-fill"></i>
                          </a>
                      </div>
                  </div>
                  <div class="col-12">
                      <label for="inputConfirmPassword" class="form-label">Confirm Password</label>
                      <input type="password" class="form-control" id="inputConfirmPassword" name="password_confirmation" required>
                  </div>
                  <div class="col-12">
                      <div class="form-check form-switch">
                          <input class="form-check-input" type="checkbox" id="flexSwitchCheckChecked" required>
                          <label class="form-check-label" for="flexSwitchCheckChecked">I agree to the Terms & Conditions</label>
                      </div>
                  </div>
                  <div class="col-12">
                      <!-- Google reCAPTCHA -->
                      <div class="g-recaptcha" data-sitekey="YOUR_RECAPTCHA_SITE_KEY"></div>
                  </div>
                  <div class="col-12">
                      <div class="d-grid">
                          <button type="submit" class="btn btn-grd-danger">Register</button>
                      </div>
                  </div>
                  <div class="col-12">
                      <div class="text-start">
                          <p class="mb-0">Already have an account?
                              <a href="{{ route('showLoginForm') }}">Sign in here</a>
                          </p>
                      </div>
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
    $(document).ready(function () {
      $("#show_hide_password a").on('click', function (event) {
        event.preventDefault();
        if ($('#show_hide_password input').attr("type") == "text") {
          $('#show_hide_password input').attr('type', 'password');
          $('#show_hide_password i').addClass("bi-eye-slash-fill");
          $('#show_hide_password i').removeClass("bi-eye-fill");
        } else if ($('#show_hide_password input').attr("type") == "password") {
          $('#show_hide_password input').attr('type', 'text');
          $('#show_hide_password i').removeClass("bi-eye-slash-fill");
          $('#show_hide_password i').addClass("bi-eye-fill");
        }
      });
    });
  </script>

  {{-- ditambahkan --}}
  <!-- Tambahkan JS intl-tel-input -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/intl-tel-input/17.0.8/js/intlTelInput.min.js"></script>
<script>
    // Inisialisasi intl-tel-input untuk Phone Number
    var input = document.querySelector("#inputPhoneNumber");
    var iti = window.intlTelInput(input, {
        initialCountry: "id", // Default ke Indonesia
        separateDialCode: true,
        utilsScript: "https://cdnjs.cloudflare.com/ajax/libs/intl-tel-input/17.0.8/js/utils.js",
    });

    // Validasi Password
    document.getElementById("registerForm").addEventListener("submit", function(e) {
        var password = document.getElementById("inputChoosePassword").value;
        var confirmPassword = document.getElementById("inputConfirmPassword").value;
        if (password !== confirmPassword) {
            e.preventDefault();
            alert("Passwords do not match!");
        }
    });

    // Toggle Password Visibility
    function togglePassword() {
        var passwordField = document.getElementById("inputChoosePassword");
        var icon = document.querySelector(".input-group-text i");

        if (passwordField.type === "password") {
            passwordField.type = "text";
            icon.classList.remove("bi-eye-slash-fill");
            icon.classList.add("bi-eye-fill");
        } else {
            passwordField.type = "password";
            icon.classList.remove("bi-eye-fill");
            icon.classList.add("bi-eye-slash-fill");
        }
      }
</script>

<!-- Tambahkan Google reCAPTCHA -->
<script src="https://www.google.com/recaptcha/api.js" async defer></script>
  {{-- /ditambahkan --}}

</body>

</html>