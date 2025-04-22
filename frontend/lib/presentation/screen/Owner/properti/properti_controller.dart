part of 'properti_import.dart';

class PropertiControllers extends GetxController {
  final RxList<PropertyModel> propertiList = <PropertyModel>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProperti();
  }

  void fetchProperti() async {
    isLoading.value = true;
    final token = await getToken();

    try {
      // Ganti URL dan token sesuai API kamu
      final response = await http.get(
        Uri.parse('http://127.0.0.1:8000/api/properties'), 
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        propertiList.value = jsonData.map((e) => PropertyModel.fromJson(e)).toList();
      } else {
        Get.snackbar('Error', 'Gagal memuat data properti');
      }
    } catch (e) {
      Get.snackbar('Error', 'Terjadi kesalahan: $e');
    } finally {
      isLoading.value = false;
    }
  }
  Future<String> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token') ?? '';
  }

  void tambahProperti() {
    Get.toNamed('/tambahProperti');
  }

  void lihatDetailProperti(PropertyModel property) {
    Get.toNamed('/detailProperti', arguments: property);
  }
}
