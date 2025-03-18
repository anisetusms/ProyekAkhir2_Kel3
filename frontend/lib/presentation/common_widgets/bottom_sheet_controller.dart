import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel_booking/core/constants/my_strings.dart';
import 'package:hotel_booking/core/themes/themes_controller.dart';

class BottomSheetController extends GetxController {
   final ThemeController themeController = Get.put(ThemeController());

   RxInt selectedCountry = 99.obs;
   RxInt selectedResult = 99.obs;
   RxInt selectedTime = 99.obs;
   RxInt selectedRate = 99.obs;
   RxBool selectedCheckBox = false.obs;
   Rx<RangeValues> sliderValue = const RangeValues(30,70).obs;

   RxList<bool> selectedAccommodationName = List.generate(MyString.accommodationName.length, (index) => false).obs;
   RxList<bool> selectedFacilities = List.generate(MyString.facilities.length, (index) => false).obs;

   void changeSliderValue(RangeValues values) {
      sliderValue.value = values;
   }
}