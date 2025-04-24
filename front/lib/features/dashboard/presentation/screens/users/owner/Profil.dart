import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:get/get.dart';

class ProfileOwner extends StatefulWidget {
  const ProfileOwner({super.key});

  @override
  State<ProfileOwner> createState() => _ProfileOwnerState();
}

class _ProfileOwnerState extends State<ProfileOwner> {
  File? selectedImage;

  Future<void> selectImageFromGallery() async {
    XFile? pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> selectImageFromCamera() async {
    XFile? pickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        selectedImage = File(pickedFile.path);
      });
    }
  }

  Future showOptions() async {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return BottomSheet(
          onClosing: () {},
          builder: (context) {
            return Wrap(
              children: [
                const SizedBox(height: 20),
                _buildOptionTile("Open Gallery", selectImageFromGallery),
                Divider(color: Colors.grey.shade300),
                _buildOptionTile("Open Camera", selectImageFromCamera),
                const SizedBox(height: 20),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildOptionTile(String text, VoidCallback onTap) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pop();
        onTap();
      },
      child: Container(
        alignment: Alignment.center,
        height: 40,
        width: MediaQuery.of(context).size.width,
        child: Text(
          text,
          style: const TextStyle(fontSize: 14),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Profile")),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              InkWell(
                onTap: () {
                  showOptions();
                },
                child: Stack(
                  children: [
                    selectedImage != null
                        ? CircleAvatar(
                            radius: 70,
                            backgroundImage: FileImage(selectedImage!),
                          )
                        : CircleAvatar(
                            radius: 70,
                            backgroundColor: Colors.grey.shade300,
                            child: const Icon(Icons.person, size: 50),
                          ),
                    Positioned(
                      bottom: 2,
                      right: 2,
                      child: Icon(Icons.edit, color: Colors.black),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Owner Daniel",
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
              ),
              const SizedBox(height: 5),
              const Text(
                "owner_daniel@yourdomain.com",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
              ),
              const SizedBox(height: 20),
              Divider(color: Colors.grey.shade300),
              InkWell(
                onTap: () {
                  Get.toNamed("/editProfileOwner");
                },
                child: commonListTile(Icons.edit, "Edit Profile"),
              ),
              InkWell(
                onTap: () {
                  Get.toNamed('/ownerNotification');
                },
                child: commonListTile(Icons.notifications, "Notifications"),
              ),
              InkWell(
                onTap: () {
                  Get.toNamed('/chooseLanguage');
                },
                child: commonListTile(Icons.language, "Language"),
              ),
              InkWell(
                onTap: () {
                  Get.toNamed('/ownerHelp');
                },
                child: commonListTile(Icons.help, "Help Centre"),
              ),
              InkWell(
                onTap: () {
                  Get.toNamed('/PrivacyPolicy');
                },
                child: commonListTile(Icons.privacy_tip, "Privacy Policy"),
              ),
              InkWell(
                onTap: () {
                  // Dialog rating
                },
                child: commonListTile(Icons.star, "Rate BooKNest"),
              ),
              ListTile(
                onTap: () {
                  showModalBottomSheet(
                    useSafeArea: true,
                    isScrollControlled: true,
                    context: context,
                    builder: (context) {
                      return Container(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              "Logout",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 10),
                            const Text("Are you sure you want to logout?"),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text("Cancel"),
                                ),
                                ElevatedButton(
  onPressed: () {
    Navigator.pop(context); // kalau kamu sedang dalam bottom sheet, ini oke
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/login',
      (route) => false,
    );
  },
  child: const Text("Logout"),
),

                              ],
                            )
                          ],
                        ),
                      );
                    },
                  );
                },
                leading: const Icon(Icons.logout, color: Colors.red),
                title: const Text("Logout"),
                titleTextStyle: const TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget commonListTile(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: Colors.black),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w500,
          fontSize: 16,
        ),
      ),
    );
  }
}
