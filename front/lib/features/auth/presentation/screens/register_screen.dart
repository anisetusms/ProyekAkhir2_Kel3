import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:front/core/network/api_client.dart';
import 'package:front/core/utils/constants.dart';
import 'package:front/features/auth/presentation/screens/login_screen.dart';

class RegisterScreen extends StatefulWidget {
  static const routeName = '/register';

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _isLoading = false;
  String? _errorMessage;

  List<Map<String, dynamic>> _roles = [];
  int? _selectedRoleId;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void initState() {
    super.initState();
    _fetchRoles();
  }

  Future<void> _fetchRoles() async {
    try {
      final response = await http.get(Uri.parse('${Constants.baseUrl}/roles'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final allRoles = List<Map<String, dynamic>>.from(
          data['data'].map(
            (role) => {
              'id': int.parse(role['id'].toString()),
              'name': role['name'],
            },
          ),
        );

        final filteredRoles =
            allRoles
                .where((role) => role['id'] == 2 || role['id'] == 4)
                .toList();

        setState(() {
          _roles = filteredRoles;
          _errorMessage = null;
        });
      } else {
        setState(() {
          _errorMessage =
              'Gagal memuat data role (kode ${response.statusCode})';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Terjadi kesalahan saat mengambil data role: $e';
      });
    }
  }

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedRoleId == null) {
        setState(() {
          _errorMessage = 'Role harus dipilih';
        });
        return;
      }

      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      try {
        final response = await ApiClient().post(
          '${Constants.baseUrl}/register',
          body: {
            'name': _nameController.text,
            'username': _usernameController.text,
            'email': _emailController.text,
            'password': _passwordController.text,
            'password_confirmation': _confirmPasswordController.text,
            'user_role_id': _selectedRoleId,
          },
        );

        if (response['access_token'] != null) {
          Navigator.pushReplacementNamed(context, LoginScreen.routeName);
        } else if (response['errors'] != null) {
          setState(() {
            _errorMessage = response['errors'].values.join('\n');
          });
        } else {
          setState(() {
            _errorMessage = response['message'] ?? 'Registrasi gagal.';
          });
        }
      } catch (e) {
        setState(() {
          _errorMessage = 'Terjadi kesalahan: $e';
        });
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context),
                ),
                const SizedBox(height: 12),
                Center(
                  child: Text(
                    "Daftar akun Anda",
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 32),
                _buildIconTextField(
                  controller: _nameController,
                  label: 'Nama',
                  icon: Icons.person,
                ),
                const SizedBox(height: 16),
                _buildIconTextField(
                  controller: _emailController,
                  label: 'Email ID',
                  icon: Icons.alternate_email,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return 'Email tidak boleh kosong';
                    if (!value.contains('@')) return 'Email tidak valid';
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                _buildIconTextField(
                  controller: _passwordController,
                  label: 'Password',
                  icon: Icons.lock_outline,
                  obscureText: _obscurePassword,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed:
                        () => setState(() {
                          _obscurePassword = !_obscurePassword;
                        }),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return 'Password tidak boleh kosong';
                    if (value.length < 8) return 'Password minimal 8 karakter';
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                _buildIconTextField(
                  controller: _confirmPasswordController,
                  label: 'Konfirmasi Password',
                  icon: Icons.lock_outline,
                  obscureText: _obscureConfirmPassword,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirmPassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed:
                        () => setState(() {
                          _obscureConfirmPassword = !_obscureConfirmPassword;
                        }),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return 'Konfirmasi password tidak boleh kosong';
                    if (value != _passwordController.text)
                      return 'Konfirmasi password tidak sesuai';
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                DropdownButtonFormField<int>(
                  decoration: InputDecoration(
                    labelText: 'Pilih Role',
                    border: UnderlineInputBorder(),
                  ),
                  value: _selectedRoleId,
                  items:
                      _roles.map((role) {
                        return DropdownMenuItem<int>(
                          value: role['id'],
                          child: Text(role['name']),
                        );
                      }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedRoleId = value;
                    });
                  },
                  validator:
                      (value) => value == null ? 'Role harus dipilih' : null,
                ),
                if (_errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      _errorMessage!,
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: _isLoading ? null : _register,
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    backgroundColor: Colors.green,
                  ),
                  child:
                      _isLoading
                          ? CircularProgressIndicator(color: Colors.white)
                          : Text('Mendaftar', style: TextStyle(fontSize: 16)),
                ),
                const SizedBox(height: 24),
                Center(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text.rich(
                      TextSpan(
                        text: 'Sudah punya akun? ',
                        children: [
                          TextSpan(
                            text: 'Masuk',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIconTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    Widget? suffixIcon,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      validator:
          validator ??
          (value) =>
              value == null || value.isEmpty
                  ? '$label tidak boleh kosong'
                  : null,
      decoration: InputDecoration(
        hintText: label,
        prefixIcon: Icon(icon),
        suffixIcon: suffixIcon,
        border: UnderlineInputBorder(),
      ),
    );
  }
}
