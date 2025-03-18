part of 'hotel_detail_import.dart';

class HomeDetailController extends GetxController {
  final ThemeController themeController = Get.put(ThemeController());
  late bool isDarkMode;
  late Detail detail;
  RxInt sliderIndex = 0.obs;
  late String firstHalf;
  late String secondHalf;
  RxBool flag = true.obs;


  @override
  void onInit() {
    isDarkMode = themeController.isDarkMode.value;
    detail = Get.arguments['data'];
    super.onInit();
  }


}
