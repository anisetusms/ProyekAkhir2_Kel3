import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:get/get.dart';
import 'package:front/core/network/api_client.dart';
import 'package:front/core/utils/constants.dart';
import 'package:dio/dio.dart' as dio;

class ProfileEditScreen extends StatefulWidget {
  final Map<String, dynamic> userProfile;

  const ProfileEditScreen({super.key, required this.userProfile});

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  File? _selectedImage;
  late TextEditingController _nameController;
  late TextEditingController _usernameController;
  late String _selectedGender;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.userProfile['name'] ?? '',
    );
    _usernameController = TextEditingController(
      text: widget.userProfile['username'] ?? '',
    );
    _selectedGender = widget.userProfile['gender'] ?? 'Pria';
    _phoneController = TextEditingController(
      text: widget.userProfile['phone'] ?? '',
    );
    _addressController = TextEditingController(
      text: widget.userProfile['address'] ?? '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _selectImage(ImageSource source) async {
    try {
      final pickedFile = await ImagePicker().pickImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
        });
      }
    } catch (e) {
      _showSnackbar('Error', 'Failed to select image: ${e.toString()}');
    }
  }

  Future<void> _updateProfile() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Validasi data
      if (_nameController.text.isEmpty) {
        throw Exception('Name cannot be empty');
      }
      if (_usernameController.text.isEmpty) {
        throw Exception('Username cannot be empty');
      }

      // Buat form data untuk mengirimkan profil
      final formData = dio.FormData.fromMap({
        'name': _nameController.text,
        'username': _usernameController.text,
        'gender': _selectedGender,
        'phone': _phoneController.text,
        'address': _addressController.text,
        if (_selectedImage != null)
          'profile_picture': await dio.MultipartFile.fromFile(
            _selectedImage!.path,
            filename: 'profile_${DateTime.now().millisecondsSinceEpoch}.jpg',
          ),
      });

      // Kirim permintaan untuk mengupdate profil
      final response = await ApiClient().post(
        '${Constants.baseUrl}/update-profile',
        formData: formData,
      );

      if (response['success'] == true) {
        Get.back(result: true); // Kembali dengan hasil true jika berhasil
        _showSnackbar('Success', 'Profile updated successfully', Colors.green);
      } else {
        throw Exception(response['message'] ?? 'Failed to update profile');
      }
    } catch (e) {
      _showSnackbar('Error', e.toString());
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showSnackbar(String title, String message, [Color? color]) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: color ?? Colors.red,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
    );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        actions: [
          IconButton(
            icon:
                _isLoading
                    ? const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(Colors.white),
                      strokeWidth: 2,
                    )
                    : const Icon(Icons.save),
            onPressed: _isLoading ? null : _updateProfile,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            GestureDetector(
              onTap: _showImageOptions,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey.shade300,
                    backgroundImage: _getProfileImage(),
                    child:
                        _selectedImage == null &&
                                widget.userProfile['profile_picture'] == null
                            ? const Icon(
                              Icons.person,
                              size: 40,
                              color: Colors.grey,
                            )
                            : null,
                  ),
                  const Positioned(
                    bottom: 0,
                    right: 0,
                    child: CircleAvatar(
                      radius: 14,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.edit, size: 16, color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _buildTextField(_nameController, 'Name'),
            const SizedBox(height: 16),
            _buildTextField(_usernameController, 'Username'),
            const SizedBox(height: 16),
            _buildGenderDropdown(),
            const SizedBox(height: 16),
            _buildTextField(_phoneController, 'Phone', TextInputType.phone),
            const SizedBox(height: 16),
            _buildTextField(_addressController, 'Address', null),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  ImageProvider? _getProfileImage() {
    if (_selectedImage != null) {
      return FileImage(_selectedImage!);
    } else if (widget.userProfile['profile_picture'] != null) {
      return NetworkImage(
        '${Constants.baseUrlImage}/storage/profile_pictures/${widget.userProfile['profile_picture']}',
      );
    }
    return null;
  }

  Widget _buildTextField(
    TextEditingController controller,
    String labelText, [
    TextInputType? keyboardType,
    int maxLines = 1,
  ]) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        border: const OutlineInputBorder(),
      ),
      keyboardType: keyboardType,
      maxLines: maxLines,
    );
  }

  Widget _buildGenderDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedGender,
      decoration: const InputDecoration(
        labelText: 'Gender',
        border: OutlineInputBorder(),
      ),
      items:
          ['Pria', 'Wanita'].map((String value) {
            return DropdownMenuItem<String>(value: value, child: Text(value));
          }).toList(),
      onChanged: (String? newValue) {
        if (newValue != null) {
          setState(() {
            _selectedGender = newValue;
          });
        }
      },
    );
  }
}
