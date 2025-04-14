part of 'register_import.dart';
class RegisterController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> fillFormKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nickNameController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();

  RxBool showPassword = true.obs;
  Rx<FocusNode> emailFocusNode = FocusNode().obs;
  Rx<FocusNode> passwordFocusNode = FocusNode().obs;

  DateTime selectedDate = DateTime.now();

  RxString selectedGender = ''.obs;
  RxString countryCode = "+62".obs;
  // Data countryCodes seperti awal (diisi dari JSON misalnya)
  RxList<Map<String, dynamic>> countryCodes = <Map<String, dynamic>>[].obs;

  var isLoading = false.obs;

  // Untuk upload gambar (diisi di FillProfileScreen)
  File? selectedImage;

  ThemeController themeController = Get.find();

  // Method untuk submit pada form register (3 field: nama, email, password)
  void submit() {
    final isValid = formKey.currentState!.validate();
    Get.focusScope!.unfocus();
    if (!isValid) return;
    // Jika valid, pindah ke screen fill profile
    // (Di sini kamu bisa juga lakukan penyimpanan data lokal jika diperlukan)
    Get.toNamed("/fillProfileScreen");
    formKey.currentState!.save();
  }

  // Method untuk submit form fill profile sekaligus panggil API Laravel Sanctum
  Future<void> fillProfileSubmit({required String status}) async {
    final isValid = fillFormKey.currentState!.validate();
    Get.focusScope!.unfocus();
    if (!isValid) return;

    isLoading.value = true;
    try {
      var uri = Uri.parse("http://10.0.2.2:8000/api/register");
      var request = http.MultipartRequest("POST", uri);
      request.fields['name'] = nameController.text;
      request.fields['username'] = nickNameController.text;
      request.fields['gender'] = selectedGender.value;
      request.fields['phone'] = mobileNumberController.text;
      request.fields['address'] = "-";
      request.fields['email'] = emailController.text;
      request.fields['password'] = passwordController.text;
      request.fields['user_role_id'] = '4';
      request.fields['user_type_id'] = '4';

      if (selectedImage != null) {
        request.files.add(await http.MultipartFile.fromPath('profile_picture', selectedImage!.path));
      }

      var response = await request.send();
      if (response.statusCode == 200) {
        Get.snackbar("Success", "Pendaftaran berhasil",
            backgroundColor: themeController.isDarkMode.value ? Colors.grey[800] : Colors.green[200],
            colorText: themeController.isDarkMode.value ? Colors.white : Colors.black);
        Get.offAll(() => const LoginScreen());
      } else {
        Get.snackbar("Error", "Gagal mendaftar");
      }
    } catch (e) {
      Get.snackbar("Exception", e.toString());
    } finally {
      isLoading.value = false;
    }
    fillFormKey.currentState!.save();
  }

  // Fungsi untuk mengambil gambar dari gallery (bisa juga ditambah fungsi kamera)
  Future<void> pickImageFromGallery() async {
    final XFile? pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      selectedImage = File(pickedFile.path);
      update();
    }
  }
}