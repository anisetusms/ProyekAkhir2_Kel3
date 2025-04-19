part of 'profile_import.dart';

class ProfileOwnerController extends GetxController {
  ThemeController themeController = Get.put(ThemeController());
  RxBool isDarkMode = false.obs;

  // Data user
  RxString name = ''.obs;
  RxString email = ''.obs;
  RxString imageUrl = ''.obs;

  @override
  void onInit() {
    super.onInit();
    isDarkMode.value = themeController.isDarkMode.value;
    fetchProfile(); // Panggil saat controller di-init
  }
Future<void> fetchProfile() async {
  try {
    final token = await getToken();

    final response = await http.get(
      Uri.parse('http://10.0.2.2:8000/api/me'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      final profilePath = data['user']['profile_picture'] ?? '';

      // 🔥 Tambahkan base URL yang mengarah ke folder storage
      final fullUrl = profilePath.isNotEmpty
          ? 'http://10.0.2.2:8000/storage/$profilePath'
          : '';

      print("✔️ URL Gambar: $fullUrl");

      imageUrl.value = fullUrl;
      name.value = data['user']['name'];
      email.value = data['user']['email'];
    } else {
      print('Gagal ambil profil. Status: ${response.statusCode}');
    }
  } catch (e) {
    print('❌ Error saat ambil data user: $e');
  }
}


  Future<String> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token') ?? '';
  }

  //---------------------------------------- profileNotification_screen -----------------------------------
  RxBool generalNotification = false.obs;
  RxBool sound = false.obs;
  RxBool vibrate = false.obs;
  RxBool appUpdates = false.obs;
  RxBool serviceAvailable = false.obs;
  RxBool tipsAvailable = false.obs;

  //---------------------------------------- Language_screen -----------------------------------
  int selectLanguage = 0;
}