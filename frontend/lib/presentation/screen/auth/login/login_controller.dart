part of 'login_import.dart';

class LoginController extends GetxController {
  final ThemeController themeController = Get.put(ThemeController());

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  RxBool password = true.obs;
  RxBool isLoading = false.obs;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  static const String baseUrl = "http://192.168.43.103:8000"; // sesuaikan IP

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

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final token = data['token'];

        // Simpan token
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString("token", token);

        // Navigasi ke halaman utama
        Get.offNamedUntil("/bottomBar", (route) => false);
      } else {
        final error = jsonDecode(response.body);
        Get.snackbar("Login Gagal", error['message'] ?? "Terjadi kesalahan");
      }
    } catch (e) {
      isLoading.value = false;
      Get.snackbar("Error", "Tidak dapat menghubungi server");
    }
  }
}
