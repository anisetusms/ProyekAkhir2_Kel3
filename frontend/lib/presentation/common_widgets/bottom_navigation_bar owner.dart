import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hotel_booking/core/constants/my_images.dart';
import 'package:hotel_booking/core/constants/my_strings.dart';
import 'package:hotel_booking/presentation/common_widgets/bottom_navigation_bar_owner_controller.dart';
import 'package:hotel_booking/presentation/screen/Owner/Ulasan/ulasan_import.dart';
import 'package:hotel_booking/presentation/screen/Owner/properti/properti_import.dart';
import 'package:hotel_booking/presentation/screen/Owner/booking-owner/booking_owner_import.dart';
import 'package:hotel_booking/presentation/screen/owner/home/home_owner_import.dart';
import 'package:hotel_booking/presentation/screen/Owner/profile-owner/profile_import.dart';

class BottomBarOwner extends StatefulWidget {
  const BottomBarOwner({super.key});

  @override
  State<BottomBarOwner> createState() => _BottomBarOnerState();
}

class _BottomBarOnerState extends State<BottomBarOwner> {

  late BottomBarOwnerController controller;

  @override
  void initState() {
    controller = Get.put(BottomBarOwnerController());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Obx(() => BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items:
          [
            _bottomNavigationBarItem(MyImages.selectedHome, MyImages.unSelectedHome, MyString.home, controller.themeController.isDarkMode.value),
            _bottomNavigationBarItem(MyImages.selectedProperty, MyImages.unSelectedProperty, MyString.properti, controller.themeController.isDarkMode.value),
            _bottomNavigationBarItem(MyImages.selectedBooking, MyImages.unSelectedBooking, MyString.booking, controller.themeController.isDarkMode.value),
            _bottomNavigationBarItem(MyImages.selectedComment, MyImages.unSelectedComment, MyString.ulasan, controller.themeController.isDarkMode.value),
            _bottomNavigationBarItem(MyImages.selectedProfile, MyImages.unSelectedProfile, MyString.profile, controller.themeController.isDarkMode.value),
          ],
        currentIndex: controller.selectedBottomTab.value,
        onTap: (value) {
          controller.selectedBottomTab.value = value;
        },
      ),),
      body: Obx(() {
        switch (controller.selectedBottomTab.value) {
          case 0: return const HomeOwner();
          case 1: return const Properti();
          case 2: return const BookingOwner();
          case 3: return const Ulasan();
          default: return const ProfileOwner();
        }
      }),
    );
  }

  _bottomNavigationBarItem(String activeIcon, String unActiveIcon, String labelName, bool isDarkMode) {
    return BottomNavigationBarItem(
      activeIcon: SvgPicture.asset(activeIcon, colorFilter: ColorFilter.mode(controller.themeController.isDarkMode.value ? Colors.white : Colors.black, BlendMode.srcIn),),
      icon: SvgPicture.asset(unActiveIcon),
      label: labelName,
    );
  }
}




