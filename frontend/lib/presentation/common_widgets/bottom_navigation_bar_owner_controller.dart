import 'package:get/get.dart';
import 'package:hotel_booking/core/themes/themes_controller.dart';

class BottomBarOwnerController extends GetxController {
  ThemeController themeController = Get.put(ThemeController());

  RxInt selectedBottomTab = 0.obs;

}