import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:get/get.dart';
import 'package:front/core/network/api_client.dart';
import 'package:front/core/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:front/features/dashboard/presentation/screens/users/penyewa/profil/profile_edit_screen.dart';
import 'package:front/features/dashboard/presentation/screens/users/penyewa/profil/password_edit_screen.dart';
import 'package:dio/dio.dart' as dio;

class ProfileUser extends StatefulWidget {
  const ProfileUser({super.key});

  @override
  State<ProfileUser> createState() => _ProfileUserState();
}

class _ProfileUserState extends State<ProfileUser> {
  File? _selectedImage;
  Map<String, dynamic> _userProfile = {};
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchProfile();
  }

  Future<void> _fetchProfile() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        throw Exception('No authentication token found');
      }

      final response = await ApiClient().get(
        '${Constants.baseUrl}/profile', // Pastikan API backend menyediakan endpoint untuk mengambil data pengguna
        queryParameters: {},
      );

      if (response['success'] == true) {
        setState(() {
          _userProfile = response['data'];
        });
      } else {
        throw Exception(
          response['message']?.toString() ?? 'Failed to fetch profile',
        );
      }
    } catch (e) {
      _handleError(e);
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _selectImage(ImageSource source) async {
    try {
      final pickedFile = await ImagePicker().pickImage(source: source);
      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
        });
        await _updateProfilePicture();
      }
    } catch (e) {
      _handleError(e, customMessage: 'Failed to select image: $e');
    }
  }

  Future<void> _updateProfilePicture() async {
    if (_selectedImage == null) return;

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        throw Exception('No authentication token found');
      }

      final formData = dio.FormData.fromMap({
        'profile_picture': await dio.MultipartFile.fromFile(
          _selectedImage!.path,
          filename: 'profile_${DateTime.now().millisecondsSinceEpoch}.jpg',
        ),
      });

      final response = await ApiClient().post(
        '${Constants.baseUrl}/update-profile',
        formData: formData,
      );

      if (response['success'] == true) {
        await _fetchProfile();
        _showSnackbar(
          'Success',
          'Profile picture updated successfully',
          Colors.green,
        );
      } else {
        throw Exception(
          response['message'] ?? 'Failed to update profile picture',
        );
      }
    } catch (e) {
      _handleError(e);
    }
  }

  void _handleError(dynamic error, {String? customMessage}) {
    final errorMessage = customMessage ?? error.toString();

    if (mounted) {
      setState(() {
        _errorMessage = errorMessage;
      });
    }

    _showSnackbar('Error', errorMessage, Colors.red);
  }

  void _showSnackbar(String title, String message, Color backgroundColor) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: backgroundColor,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
    );
  }

  Future<void> _logout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("Logout"),
            content: const Text("Are you sure you want to logout?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text(
                  "Logout",
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );

    if (confirmed == true) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('token');
      await prefs.remove('user_role_id');
      Get.offAllNamed('/login');
    }
  }

  Future<void> _showImageOptions() async {
    await showModalBottomSheet(
      context: context,
      builder:
          (context) => SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildImageOptionTile(
                  text: "Gallery",
                  icon: Icons.photo_library,
                  source: ImageSource.gallery,
                ),
                const Divider(height: 1),
                _buildImageOptionTile(
                  text: "Camera",
                  icon: Icons.camera_alt,
                  source: ImageSource.camera,
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
    );
  }

  ListTile _buildImageOptionTile({
    required String text,
    required IconData icon,
    required ImageSource source,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(text),
      onTap: () {
        Navigator.pop(context);
        _selectImage(source);
      },
    );
  }

  void _navigateToEditProfile() {
    Get.to(() => ProfileEditScreen(userProfile: _userProfile))?.then((value) {
      if (value == true) {
        _fetchProfile();
      }
    });
  }

  void _navigateToChangePassword() {
    Get.to(() => const PasswordEditScreen())?.then((value) {
      if (value == true) {
        _showSnackbar('Success', 'Password updated successfully', Colors.green);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: _navigateToEditProfile,
            tooltip: 'Edit Profile',
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(child: Text(_errorMessage!));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildProfileHeader(),
          const SizedBox(height: 24),
          _buildProfileActions(),
        ],
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Column(
      children: [
        _buildProfilePicture(),
        const SizedBox(height: 16),
        Text(
          _userProfile['name'] ?? 'No Name',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        const SizedBox(height: 4),
        Text(
          _userProfile['email'] ?? 'No Email',
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '@${_userProfile['username'] ?? 'nousername'}',
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildProfilePicture() {
    return InkWell(
      onTap: _showImageOptions,
      child: Stack(
        children: [
          CircleAvatar(
            radius: 70,
            backgroundColor: Colors.grey.shade300,
            backgroundImage: _getProfileImage(),
            child:
                _userProfile['profile_picture'] == null
                    ? const Icon(Icons.person, size: 50)
                    : null,
          ),
          const Positioned(bottom: 2, right: 2, child: _EditProfileIcon()),
        ],
      ),
    );
  }

  ImageProvider? _getProfileImage() {
    if (_userProfile['profile_picture'] != null) {
      return NetworkImage(
        '${Constants.baseUrlImage}/storage/profile_pictures/${_userProfile['profile_picture']}',
      );
    }
    return null;
  }

  Widget _buildProfileActions() {
    return Column(
      children: [
        _buildDivider(),
        _buildActionTile(
          icon: Icons.lock,
          text: "Change Password",
          onTap: _navigateToChangePassword,
        ),
        _buildDivider(),
        _buildActionTile(
          icon: Icons.notifications,
          text: "Notifications",
          onTap: () => Get.toNamed('/notifications'),
        ),
        _buildDivider(),
        _buildActionTile(
          icon: Icons.language,
          text: "Language",
          onTap: () => Get.toNamed('/language'),
        ),
        _buildDivider(),
        _buildActionTile(
          icon: Icons.help,
          text: "Help Centre",
          onTap: () => Get.toNamed('/help'),
        ),
        _buildDivider(),
        _buildActionTile(
          icon: Icons.privacy_tip,
          text: "Privacy Policy",
          onTap: () => Get.toNamed('/privacy'),
        ),
        _buildDivider(),
        _buildActionTile(
          icon: Icons.logout,
          text: "Logout",
          color: Colors.red,
          onTap: () => _logout(),
        ),
        _buildDivider(),
      ],
    );
  }

  Widget _buildActionTile({
    required IconData icon,
    required String text,
    Color? color,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(text, style: TextStyle(color: color)),
      onTap: onTap,
    );
  }

  Widget _buildDivider() {
    return Divider(color: Colors.grey.shade300);
  }
}

class _EditProfileIcon extends StatelessWidget {
  const _EditProfileIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
      child: const Icon(Icons.edit, size: 16),
    );
  }
}
