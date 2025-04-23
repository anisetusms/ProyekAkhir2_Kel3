part of 'login_import.dart';

class LoginController extends GetxController {
  final ThemeController themeController = Get.put(ThemeController());

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  RxBool password = true.obs;
  RxBool isLoading = false.obs;
 
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  static const String baseUrl = "http://192.168.0.45:8000"; // Gunakan 10.0.2.2 untuk emulator // Gunakan 10.0.2.2 untuk emulator

  void submit() async {
    final isValid = formKey.currentState!.validate();
    Get.focusScope!.unfocus();
    if (!isValid) return;

    isLoading.value = true;

    try {
      final response = await http.post(
        Uri.parse("$baseUrl/api/login"),
        headers: {"Accept": "application/json"},
        body: {
          "email": emailController.text.trim(),
          "password": passwordController.text.trim(),
        },
      );

      isLoading.value = false;

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
  final token = data['access_token'];
  final role = data['user']['user_role_id'];
  final message = data['message'];

  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString("token", token);

  Get.snackbar("Sukses", message, backgroundColor: Colors.green, colorText: Colors.white);

  if (role == 2) {
    Get.offNamedUntil("/bottomBarOwner", (route) => false);
  } else if (role == 4) {
    Get.offNamedUntil("/bottomBar", (route) => false);
  } else {
    Get.snackbar("Akses Ditolak", "Role tidak dikenali", backgroundColor: Colors.orange, colorText: Colors.white);
  }
}else {
        final errorMsg = data['message'] ?? "Email atau password salah";
        Get.snackbar("Login Gagal", errorMsg, backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      isLoading.value = false;
      Get.snackbar("Error", "Tidak dapat menghubungi server", backgroundColor: Colors.red, colorText: Colors.white);
    }
  }
}
