part of 'register_import.dart';

class RegisterController extends GetxController {
   final ThemeController themeController = Get.put(ThemeController());
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  
  RxBool showPassword = true.obs;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  RxString selectedGender = ''.obs;
  Rx<File?> selectedImage = Rx<File?>(null);

  final  dio = dio_lib.Dio();

  Future<void> pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      selectedImage.value = File(pickedFile.path);
    }
  }

  Future<void> register() async {
    final isValid = formKey.currentState!.validate();
    Get.focusScope?.unfocus();
    if (!isValid) return;

    final formData = dio_lib.FormData.fromMap({
      "name": nameController.text,
      "username": usernameController.text,
      "email": emailController.text,
      "password": passwordController.text,
      "phone": phoneController.text,
      "address": addressController.text,
      "gender": selectedGender.value,
      if (selectedImage.value != null)
        "profile_picture": await dio_lib.MultipartFile.fromFile(
          selectedImage.value!.path,
          filename: selectedImage.value!.path.split("/").last,
        ),
    });

    try {
      final response = await dio.post(
        "http://10.0.2.2:8000/api/register",
        data: formData,
        options: dio_lib.Options(
          headers: {
            "Accept": "application/json",
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar("Sukses", "Registrasi berhasil!");
        Get.offAllNamed("/bottomBar");
      } else {
        Get.snackbar("Gagal", "Terjadi kesalahan saat registrasi.");
      }
    } on dio_lib.DioException catch (e) {
  String errorMsg = 'Terjadi kesalahan.';

  if (e.response != null) {
    final data = e.response?.data;

    if (data is Map && data.containsKey('message')) {
      errorMsg = data['message'];
    } else {
      errorMsg = 'Status: ${e.response?.statusCode}\nError: ${data.toString()}';
    }
  } else {
    errorMsg = 'Tidak ada respon dari server.\nError: ${e.message}';
  }

  Get.snackbar("Gagal", errorMsg);
}
  }
}
