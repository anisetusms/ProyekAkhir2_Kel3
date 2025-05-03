import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:front/core/network/api_client.dart';
import 'package:front/core/utils/constants.dart';

class PasswordEditScreen extends StatefulWidget {
  const PasswordEditScreen({super.key});

  @override
  State<PasswordEditScreen> createState() => _PasswordEditScreenState();
}

class _PasswordEditScreenState extends State<PasswordEditScreen> {
  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  
  bool _isLoading = false;
  bool _obscureCurrentPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _updatePassword() async {
    if (!_validatePasswords()) return;

    setState(() => _isLoading = true);

    try {
      final response = await ApiClient().post(
        '${Constants.baseUrl}/update-password',
        body: _buildPasswordData(),
      );

      if (response['success'] == true) {
        _handleSuccess();
      } else {
        throw Exception(response['message'] ?? 'Failed to update password');
      }
    } catch (e) {
      _handleError(e);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  bool _validatePasswords() {
    if (_currentPasswordController.text.isEmpty ||
        _newPasswordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty) {
      _showSnackbar('Error', 'All fields are required', Colors.red);
      return false;
    }

    if (_newPasswordController.text.length < 8) {
      _showSnackbar('Error', 'Password must be at least 8 characters', Colors.red);
      return false;
    }

    if (_newPasswordController.text != _confirmPasswordController.text) {
      _showSnackbar('Error', 'New passwords do not match', Colors.red);
      return false;
    }

    return true;
  }

  Map<String, dynamic> _buildPasswordData() {
    return {
      'current_password': _currentPasswordController.text,
      'new_password': _newPasswordController.text,
      'new_password_confirmation': _confirmPasswordController.text,
    };
  }

  void _handleSuccess() {
    Get.back();
    _showSnackbar('Success', 'Password updated successfully', Colors.green);
    _clearControllers();
  }

  void _handleError(dynamic error) {
    final errorMessage = error is Exception ? error.toString() : 'An unknown error occurred';
    _showSnackbar('Error', errorMessage, Colors.red);
  }

  void _clearControllers() {
    _currentPasswordController.clear();
    _newPasswordController.clear();
    _confirmPasswordController.clear();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Change Password'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _isLoading ? null : _updatePassword,
            tooltip: 'Save Changes',
          ),
        ],
      ),
      body: _buildPasswordForm(),
    );
  }

  Widget _buildPasswordForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildCurrentPasswordField(),
          const SizedBox(height: 16),
          _buildNewPasswordField(),
          const SizedBox(height: 16),
          _buildConfirmPasswordField(),
          const SizedBox(height: 20),
          if (_isLoading) const CircularProgressIndicator(),
        ],
      ),
    );
  }

  Widget _buildCurrentPasswordField() {
    return TextFormField(
      controller: _currentPasswordController,
      decoration: InputDecoration(
        labelText: 'Current Password',
        border: const OutlineInputBorder(),
        suffixIcon: _buildVisibilityToggle(
          isObscured: _obscureCurrentPassword,
          onPressed: () => setState(() => _obscureCurrentPassword = !_obscureCurrentPassword),
        ),
      ),
      obscureText: _obscureCurrentPassword,
      textInputAction: TextInputAction.next,
    );
  }

  Widget _buildNewPasswordField() {
    return TextFormField(
      controller: _newPasswordController,
      decoration: InputDecoration(
        labelText: 'New Password',
        border: const OutlineInputBorder(),
        suffixIcon: _buildVisibilityToggle(
          isObscured: _obscureNewPassword,
          onPressed: () => setState(() => _obscureNewPassword = !_obscureNewPassword),
        ),
      ),
      obscureText: _obscureNewPassword,
      textInputAction: TextInputAction.next,
    );
  }

  Widget _buildConfirmPasswordField() {
    return TextFormField(
      controller: _confirmPasswordController,
      decoration: InputDecoration(
        labelText: 'Confirm New Password',
        border: const OutlineInputBorder(),
        suffixIcon: _buildVisibilityToggle(
          isObscured: _obscureConfirmPassword,
          onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
        ),
      ),
      obscureText: _obscureConfirmPassword,
      textInputAction: TextInputAction.done,
      onFieldSubmitted: (_) => _updatePassword(),
    );
  }

  IconButton _buildVisibilityToggle({
    required bool isObscured,
    required VoidCallback onPressed,
  }) {
    return IconButton(
      icon: Icon(isObscured ? Icons.visibility : Icons.visibility_off),
      onPressed: onPressed,
    );
  }
}