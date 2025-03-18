part of 'login_import.dart';

class LoginController extends GetxController {
  final ThemeController themeController = Get.put(ThemeController());

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  RxBool password = true.obs;

  TextEditingController emailController =TextEditingController();
  TextEditingController passwordController =TextEditingController();

  void submit() {
    final isValid = formKey.currentState!.validate();
    Get.focusScope!.unfocus();
    if (!isValid) {
      return;
    } else {
      Get.offNamedUntil("/bottomBar", (route) => false);
    }
    formKey.currentState!.save();
  }
}