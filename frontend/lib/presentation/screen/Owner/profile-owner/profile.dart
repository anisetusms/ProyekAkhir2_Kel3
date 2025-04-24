part of 'profile_import.dart';

class ProfileOwner extends StatefulWidget {
  const ProfileOwner({super.key});

  @override
  State<ProfileOwner> createState() => _ProfileOwnerState();
}

class _ProfileOwnerState extends State<ProfileOwner> {
  late ProfileOwnerController controller;
  late bool isDarkMode;

  @override
  void initState() {
    controller = Get.put(ProfileOwnerController());
    isDarkMode = controller.themeController.isDarkMode.value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: homeAppBar(
        MyString.profile,
        false,
        controller.themeController.isDarkMode.value,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Obx(() => Column(
                children: [
                  const SizedBox(height: 20),
                  /// Hanya menampilkan foto dari DB di dalam lingkaran
                  CircleAvatar(
  radius: 70,
  backgroundColor: Colors.grey[200],
  child: Obx(() {
  final imageUrl = controller.imageUrl.value;

  return GestureDetector(
    onTap: () {
      // Navigasi ke halaman full-size saat gambar diklik
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FullSizeImagePage(imageUrl: imageUrl),
        ),
      );
    },
    child: CircleAvatar(
      radius: 70,
      backgroundColor: Colors.grey[200],
      child: ClipOval(
        child: imageUrl.isNotEmpty
            ? Image.network(
                imageUrl,
                fit: BoxFit.cover,
                width: 140,
                height: 140,
                errorBuilder: (context, error, stackTrace) {
                  print("❌ Gagal load gambar: $error");
                  return Image.asset(
                    MyImages.profilePerson,
                    fit: BoxFit.cover,
                    width: 140,
                    height: 140,
                  );
                },
              )
            : Image.asset(
                MyImages.profilePerson,
                fit: BoxFit.cover,
                width: 140,
                height: 140,
              ),
      ),
    ),
  );
}),
),


                  const SizedBox(height: 10),
                  /// Nama
                  Obx(() => Text(
                        controller.name.value.isNotEmpty
                            ? controller.name.value
                            : 'Nama tidak tersedia',
                        style: const TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 20),
                      )),
                  const SizedBox(height: 5),
                  /// Email
                  Obx(() => Text(
                        controller.email.value.isNotEmpty
                            ? controller.email.value
                            : 'Email tidak tersedia',
                        style: const TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 14),
                      )),
                  const SizedBox(height: 20),
                  Divider(color: Colors.grey.shade300),
                  InkWell(
                    onTap: () {
                      Get.toNamed("/editProfileo");
                    },
                    child: commonListTile(
                      MyImages.editProfileScreen,
                      MyString.editProfile,
                      controller.isDarkMode.value,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Get.toNamed('/profileNotification');
                    },
                    child: commonListTile(
                      MyImages.notificationScreen,
                      MyString.notifications,
                      controller.isDarkMode.value,
                    ),
                  ),
                  ListTile(
                    leading: SvgPicture.asset(
                      MyImages.darkThemeScreen,
                      colorFilter: ColorFilter.mode(
                        controller.isDarkMode.value
                            ? Colors.white
                            : MyColors.profileListTileColor,
                        BlendMode.srcIn,
                      ),
                      height: 20,
                      width: 20,
                    ),
                    title: const Text(MyString.darkTheme),
                    titleTextStyle: TextStyle(
                      color: controller.isDarkMode.value
                          ? Colors.white
                          : MyColors.profileListTileColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                    trailing: CustomSwitch(
                      value: controller.isDarkMode.value,
                      onChanged: (value) {
                        controller.isDarkMode.value = value;
                        controller.themeController.toggleTheme();
                      },
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Get.toNamed('/helpCenter');
                    },
                    child: commonListTile(
                      MyImages.helpCenterScreen,
                      MyString.helpCentre,
                      controller.isDarkMode.value,
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      showLogoutSheet();
                    },
                    leading: SvgPicture.asset(
                      MyImages.logoutScreen,
                      height: 20,
                      width: 20,
                    ),
                    title: const Text(MyString.logout),
                    titleTextStyle: const TextStyle(
                      color: MyColors.errorColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }

  void showLogoutSheet() {
  showCupertinoModalPopup(
    context: context,
    builder: (context) => CupertinoActionSheet(
      title: const Text(MyString.logout),
      message: const Text(MyString.logoutTitle),
      actions: [
        CupertinoActionSheetAction(
          isDestructiveAction: true,
          onPressed: () async {
            Navigator.of(context).pop(); // Tutup sheet dulu

            bool success = await AuthService.logout();
            if (!mounted) return;
            if (success) {
              controller.imageUrl.refresh();
  Get.offNamedUntil("/loginOptionScreen", (route) => false);
} else {
  Get.snackbar(
    "Logout Gagal",
    "Coba lagi nanti.",
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: Colors.redAccent,
    colorText: Colors.white,
  );
}

          },
          child: const Text(MyString.yesLogout),
        ),
      ],
      cancelButton: CupertinoActionSheetAction(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: const Text(MyString.cancel),
      ),
    ),
  );
}

  Widget commonListTile(String image, String title, bool isDarkMode) {
    return ListTile(
      leading: SvgPicture.asset(
        image,
        colorFilter: ColorFilter.mode(
          isDarkMode ? Colors.white : MyColors.profileListTileColor,
          BlendMode.srcIn,
        ),
        height: 20,
        width: 20,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isDarkMode ? Colors.white : MyColors.profileListTileColor,
          fontWeight: FontWeight.w500,
          fontSize: 16,
        ),
      ),
    );
  }
}
