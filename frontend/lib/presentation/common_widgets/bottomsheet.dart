
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hotel_booking/core/constants/my_colors.dart';
import 'package:hotel_booking/core/constants/my_images.dart';
import 'package:hotel_booking/core/constants/my_strings.dart';
import 'package:hotel_booking/presentation/common_widgets/bottom_sheet_controller.dart';
import 'package:hotel_booking/presentation/common_widgets/custom_button.dart';

class FilterBottomSheet extends StatelessWidget {
  FilterBottomSheet({super.key});

  final BottomSheetController controller = Get.put(BottomSheetController());

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 0.9,
      child: Container(
        decoration: BoxDecoration(
            color: controller.themeController.isDarkMode.value ? MyColors.scaffoldDarkColor : Colors.white,
            borderRadius: const BorderRadius.only(
                topRight: Radius.circular(20), topLeft: Radius.circular(20))),
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(15, 10, 15, 100),
                child: Column(
                  children: [
                    Container(
                      height: 4,
                      width: 40,
                      decoration: BoxDecoration(
                        color: MyColors.disabledColor,
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      MyString.filterHotel,
                      style: TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 20),
                    ),
                    const SizedBox(height: 10),
                    const Divider(),
                    const SizedBox(height: 10),
                    Column(
                      children: [
                        titleText(
                            MyString.country,
                            controller.themeController.isDarkMode.value,
                            true,
                                () {}),
                        const SizedBox(height: 20),
                        SizedBox(
                          height: 40,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemCount: MyString.countryName.length,
                            itemBuilder: (context, index) {
                              return Obx(() => Row(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      controller.selectedCountry.value = index;
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: controller.selectedCountry.value == index
                                            ? controller.themeController
                                            .isDarkMode.value
                                            ? MyColors.successColor
                                            : MyColors.black
                                            : controller.themeController
                                            .isDarkMode.value
                                            ? MyColors.scaffoldDarkColor
                                            : MyColors.white,
                                        border: Border.all(
                                            color: controller.selectedCountry.value == index
                                                ? controller.themeController.isDarkMode.value
                                                ? MyColors.successColor
                                                : Colors.black
                                                : controller.themeController.isDarkMode.value
                                                ? MyColors.white
                                                : MyColors.black),
                                        borderRadius:
                                        BorderRadius.circular(20),
                                      ),
                                      padding: const EdgeInsets.symmetric(horizontal: 18),
                                      child: Text(
                                        MyString.countryName[index],
                                        style: TextStyle(
                                            color: controller.selectedCountry.value == index
                                                ? MyColors.white
                                                : controller.themeController
                                                .isDarkMode.value
                                                ? MyColors.white
                                                : MyColors.primaryColor,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                ],
                              ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 20),
                        titleText(
                            MyString.sortResults,
                            controller.themeController.isDarkMode.value,
                            false,
                                () {}),
                        const SizedBox(height: 20),
                        SizedBox(
                          height: 40,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemCount: MyString.resultsName.length,
                            itemBuilder: (context, index) {
                              return Obx(() => Row(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      controller.selectedResult.value = index;
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: controller
                                            .selectedResult.value ==
                                            index
                                            ? controller.themeController
                                            .isDarkMode.value
                                            ? MyColors.successColor
                                            : MyColors.black
                                            : controller.themeController
                                            .isDarkMode.value
                                            ? MyColors.scaffoldDarkColor
                                            : MyColors.white,
                                        border: Border.all(
                                            color: controller.selectedResult
                                                .value ==
                                                index
                                                ? controller.themeController
                                                .isDarkMode.value
                                                ? MyColors.successColor
                                                : Colors.black
                                                : controller.themeController
                                                .isDarkMode.value
                                                ? MyColors.white
                                                : MyColors.black),
                                        borderRadius:
                                        BorderRadius.circular(20),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 18),
                                      child: Text(
                                        MyString.resultsName[index],
                                        style: TextStyle(
                                          color: controller.selectedResult
                                              .value ==
                                              index
                                              ? MyColors.white
                                              : controller.themeController
                                              .isDarkMode.value
                                              ? MyColors.white
                                              : MyColors.primaryColor,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                ],
                              ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 20),
                        titleText(
                            MyString.priceRange,
                            controller.themeController.isDarkMode.value,
                            false,
                                () {}),
                        const SizedBox(height: 20),
                        Obx(() => RangeSlider(
                          values: controller.sliderValue.value,
                          onChanged: (RangeValues values) {
                            controller.changeSliderValue(values);
                          },
                          min: 0,
                          max: 100,
                          divisions: 100,
                          activeColor: Colors.green,
                          labels: RangeLabels(
                            controller.sliderValue.value.start.toString(),
                            controller.sliderValue.value.end.toString(),
                          ),
                          inactiveColor:
                          controller.themeController.isDarkMode.value
                              ? MyColors.dividerDarkTheme
                              : MyColors.disabledColor,
                        ),
                        ),
                        const SizedBox(height: 20),
                        titleText(
                            MyString.availabilityTime,
                            controller.themeController.isDarkMode.value,
                            false,
                                () {}),
                        const SizedBox(height: 15),
                        SizedBox(
                          height: 100,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemCount: 3,
                            itemBuilder: (context, index) {
                              return Obx(
                                () => Row(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        controller.selectedTime.value = index;
                                      },
                                      child: Container(
                                        width: 115,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color: MyColors.scaffoldLightColor,
                                          border: Border.all(
                                              color: controller.selectedTime.value == index
                                                  ? MyColors.black
                                                  : MyColors.disabledColor),
                                          borderRadius:
                                          BorderRadius.circular(10),
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          children: [
                                            SvgPicture.asset(
                                              MyImages.selectTime[index],
                                              colorFilter: ColorFilter.mode(
                                                  controller.selectedTime.value == index
                                                      ? MyColors.black
                                                      : Colors.black54,
                                                  BlendMode.srcIn),
                                            ),
                                            const SizedBox(height: 3),
                                            Text(
                                              MyString.selectedTime[index],
                                              style: TextStyle(
                                                  color: controller.selectedTime.value == index
                                                      ? MyColors.black
                                                      : Colors.grey,
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 12),
                                            ),
                                            const SizedBox(height: 3),
                                            Text(
                                              MyString.selectedTimeRange[index],
                                              style: TextStyle(
                                                  color: controller.selectedTime.value == index
                                                      ? MyColors.black
                                                      : Colors.grey,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 11),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        titleText(
                            MyString.sortResults,
                            controller.themeController.isDarkMode.value,
                            true,
                                () {}),
                        const SizedBox(height: 15),
                        SizedBox(
                          height: 35,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemCount: MyString.rate.length,
                            itemBuilder: (context, index) {
                              return Obx(
                                    () => Row(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        controller.selectedRate.value = index;
                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color: controller
                                              .selectedRate.value ==
                                              index
                                              ? controller.themeController
                                              .isDarkMode.value
                                              ? MyColors.successColor
                                              : MyColors.black
                                              : controller.themeController
                                              .isDarkMode.value
                                              ? MyColors.scaffoldDarkColor
                                              : MyColors.white,
                                          border: Border.all(
                                              color: controller.selectedRate
                                                  .value ==
                                                  index
                                                  ? controller.themeController
                                                  .isDarkMode.value
                                                  ? MyColors.successColor
                                                  : Colors.black
                                                  : controller.themeController
                                                  .isDarkMode.value
                                                  ? MyColors.white
                                                  : MyColors.black),
                                          borderRadius:
                                          BorderRadius.circular(20),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 18),
                                        child: Row(
                                          children: [
                                            SvgPicture.asset(
                                              controller.selectedRate.value ==
                                                  index
                                                  ? MyImages.whiteStar
                                                  : MyImages.unselectStar,
                                              colorFilter: ColorFilter.mode(
                                                  controller.selectedRate
                                                      .value ==
                                                      index
                                                      ? MyColors.white
                                                      : controller
                                                      .themeController
                                                      .isDarkMode
                                                      .value
                                                      ? MyColors.white
                                                      : MyColors.black,
                                                  BlendMode.srcIn),
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              MyString.rate[index],
                                              style: TextStyle(
                                                  color: controller
                                                      .selectedRate
                                                      .value ==
                                                      index
                                                      ? MyColors.white
                                                      : controller
                                                      .themeController
                                                      .isDarkMode
                                                      .value
                                                      ? MyColors.white
                                                      : MyColors.black,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 14),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 15),
                        titleText(
                            MyString.accommodationType,
                            controller.themeController.isDarkMode.value,
                            true,
                                () {}),
                        const SizedBox(height: 5),
                        SizedBox(
                          height: 30,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemCount: MyString.accommodationName.length,
                            itemBuilder: (context, index) {
                              return Obx(() => Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: 20,
                                    height: 17,
                                    child: Checkbox(
                                      value: controller.selectedAccommodationName[index],
                                      focusColor: Colors.black,
                                      activeColor: controller
                                          .themeController
                                          .isDarkMode
                                          .value
                                          ? MyColors.successColor
                                          : MyColors.primaryColor,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(5)),
                                      side: BorderSide(
                                          color: controller.themeController
                                              .isDarkMode.value
                                              ? MyColors.white
                                              : MyColors.black),
                                      onChanged: (value) {
                                        controller.selectedAccommodationName[index] = value!;
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    MyString.accommodationName[index],
                                    style: const TextStyle(fontSize: 15),
                                  ),
                                  const SizedBox(width: 8),
                                ],
                              ));
                            },
                          ),
                        ),
                        const SizedBox(height: 10),
                        titleText(
                            MyString.facilities,
                            controller.themeController.isDarkMode.value,
                            true,
                                () {}),
                        const SizedBox(height: 5),
                        SizedBox(
                          height: 30,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemCount: MyString.facilitiesName.length,
                            itemBuilder: (context, index) {
                              return Obx(() => Row(
                                children: [
                                  SizedBox(
                                    width: 20,
                                    height: 17,
                                    child: Checkbox(
                                      value: controller.selectedFacilities[index],
                                      focusColor: MyColors.primaryColor,
                                      activeColor: controller.themeController.isDarkMode.value
                                          ? MyColors.successColor
                                          : MyColors.primaryColor,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                      side: BorderSide(
                                        color: controller.themeController.isDarkMode.value
                                            ? MyColors.white
                                            : MyColors.black,
                                      ),
                                      onChanged: (value) {
                                        controller.selectedFacilities[index] = value!;
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(MyString.facilitiesName[index], style: const TextStyle(fontSize: 15)),
                                  const SizedBox(width: 8),
                                ],
                              ));
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              child: Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                width: MediaQuery.of(context).size.width,
                color: controller.themeController.isDarkMode.value ? MyColors.black : MyColors.white,
                child: Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 50,
                        child: Button(
                          onpressed: () {
                            controller.selectedCountry.value = 99;
                            controller.selectedResult.value = 99;
                            controller.selectedTime.value = 99;
                            controller.selectedRate.value = 99;
                            for(int i = 0 ; i < controller.selectedAccommodationName.length ; i ++) {
                              controller.selectedAccommodationName[i] = false;
                            }
                            for(int i = 0 ; i < controller.selectedFacilities.length; i++) {
                              controller.selectedFacilities[i] = false;
                            }
                            // controller.selectedAccommodationName.refresh();
                          },
                          text: MyString.reset,
                          textColor: controller.themeController.isDarkMode.value ? MyColors.white : MyColors.black,
                          buttonColor: controller.themeController.isDarkMode.value ? MyColors.dividerDarkTheme : MyColors.disabledColor,
                          textSize: 16,
                          fontBold: FontWeight.w700,
                          shadowColor: Colors.transparent,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: SizedBox(
                        height: 50,
                        child: Button(
                          onpressed: () {
                            Get.back();
                          },
                          text: MyString.applyFilter,
                          textColor: MyColors.white,
                          buttonColor: controller.themeController.isDarkMode.value ? MyColors.successColor : MyColors.primaryColor,
                          textSize: 16,
                          fontBold: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget titleText(
    String title, bool isDarkMode, bool seeAllStatus, VoidCallback onPress) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
      ),
      seeAllStatus == true
      ? InkWell(
        onTap: onPress,
        child: Container(
          padding: const EdgeInsets.all(5),
          child: const Text(
            MyString.seeAll,
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
          )),
      )
      : const SizedBox(),
    ],
  );
}

class CommonBottomSheet extends StatelessWidget {
  final String status;
  final String? mainTitle;
  final String? subTitle;
  final String? description;
  final Color? buttonColor1;
  final Color? buttonColor2;
  final Color? shadowColor1;
  final Color? shadowColor2;
  final double? textSize;
  final String text1;
  final String text2;
  final FontWeight? fontBold;
  final Color? textColor1;
  final Color? textColor2;
  final VoidCallback onpressed1;
  final VoidCallback onpressed2;

  CommonBottomSheet({
    super.key,
    required this.status,
    this.mainTitle,
    this.subTitle,
    this.description,
    this.buttonColor1,
    this.buttonColor2,
    this.shadowColor1,
    this.shadowColor2,
    required this.onpressed1,
    required this.onpressed2,
    required this.text1,
    required this.text2,
    this.textSize,
    this.textColor1,
    this.textColor2,
    this.fontBold,
  });

  final BottomSheetController controller = Get.put(BottomSheetController());

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        child: Column(
          children: [
            Text(
              mainTitle.toString(),
              style: const TextStyle(
                  color: MyColors.errorColor,
                  fontWeight: FontWeight.w700,
                  fontSize: 20),
            ),
            const SizedBox(height: 10),
            Divider(color: controller.themeController.isDarkMode.value ? MyColors.dividerDarkTheme : Colors.grey.shade300),
            const SizedBox(height: 10),
            Text(
              subTitle.toString(),
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
              textAlign: TextAlign.center,
            ),
            status == 'cancelBooking'
                ? Column(
                    children: [
                      const SizedBox(height: 10),
                      Text(description.toString(),
                          style: TextStyle(
                              color: controller.themeController.isDarkMode.value
                                  ? MyColors.onBoardingDescriptionDarkColor
                                  : MyColors.textPaymentInfo,
                              fontWeight: FontWeight.w400,
                              fontSize: 12),
                          textAlign: TextAlign.center),
                    ],
                  )
                : const SizedBox(),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                    child: SizedBox(
                  height: 55,
                  child: Button(
                    onpressed: onpressed1,
                    text: text1,
                    buttonColor: buttonColor1,
                    shadowColor: shadowColor1,
                    textColor: textColor1,
                  ),
                )),
                const SizedBox(width: 10),
                Expanded(
                  child: SizedBox(
                    height: 55,
                    child: Button(
                      onpressed: onpressed2,
                      text: text2,
                      buttonColor: buttonColor2,
                      shadowColor: shadowColor2,
                      textColor: textColor2,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
