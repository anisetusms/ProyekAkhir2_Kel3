part of 'login_import.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late LoginController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(LoginController());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(                
                  child: Image.asset(
                      'assets/logo/logo.jpg',
                      height: 250,
                  ),                  
                ),
                const SizedBox(height: 30),
                const Text(
                  "Login",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 20),

                // Email field
                CustomTextFormField(
                  controller: controller.emailController,
                  obscureText: false,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  validator: (value) => Validations().emailValidation(value),
                  hintText: "Email",
                  prefixIcon:
                      const Icon(Icons.email_outlined, color: Colors.grey),
                  fillColor: Colors.transparent,
                ),
                const SizedBox(height: 20),

                // Password field
                Obx(() => CustomTextFormField(
                      controller: controller.passwordController,
                      obscureText: controller.password.value,
                      textInputAction: TextInputAction.done,
                      validator: (value) =>
                          Validations().passwordValidation(value),
                      hintText: "Password",
                      prefixIcon:
                          const Icon(Icons.lock_outline, color: Colors.grey),
                      suffixIcon: IconButton(
                        icon: Icon(
                          controller.password.value
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          controller.password.value =
                              !controller.password.value;
                        },
                      ),
                      fillColor: Colors.transparent,
                    )),
                const SizedBox(height: 10),

                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => Get.toNamed("/choicePassword"),
                    child: const Text(
                      "Lupa password?",
                      style: TextStyle(color: Colors.lightBlue),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Login Button
                Obx(() => SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: controller.submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: Text(
                          controller.isLoading.value ? "Loading..." : "Masuk",
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                      ),
                    )),
                const SizedBox(height: 30),

                // Register Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Belum punya akun?",
                      style: TextStyle(color: Colors.grey),
                    ),
                    TextButton(
                      onPressed: () => Get.toNamed("/registerScreen"),
                      child: const Text(
                        "Daftar",
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.lightBlue),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
