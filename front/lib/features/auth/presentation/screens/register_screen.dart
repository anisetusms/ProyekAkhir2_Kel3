import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:front/core/network/api_client.dart';
import 'package:front/core/utils/constants.dart';
import 'package:front/features/auth/presentation/screens/login_screen.dart';
import 'package:http/http.dart' as http;

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

        // Filter hanya id 2 dan 4
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
        // Menambahkan status 'pending' untuk user yang memilih role sebagai Owner
        final status = _selectedRoleId == 2 ? 'pending' : null;

        final response = await ApiClient().post(
          '${Constants.baseUrl}/register',
          body: {
            'name': _nameController.text,
            'username': _usernameController.text,
            'email': _emailController.text,
            'password': _passwordController.text,
            'password_confirmation': _confirmPasswordController.text,
            'user_role_id': _selectedRoleId, // Kirim sebagai integer ke API
            'status': status, // Menambahkan status 'pending' jika role Owner
          },
        );

        if (response['access_token'] != null) {
          // Menampilkan pesan sukses setelah registrasi berhasil
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Registrasi berhasil! Silakan login'),
              backgroundColor: Colors.green,
            ),
          );
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
      appBar: AppBar(
        title: Text('Daftar Akun'),
        backgroundColor: Colors.green, // Warna sesuai dengan login
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Image.asset(
                  'assets/icons/logo.jpg',
                  height: 200, // Sesuaikan dengan logo di halaman login
                ),
                SizedBox(height: 24.0),

                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Daftar Akun",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 16.0),

                // Nama Lengkap
                _buildTextField(_nameController, 'Nama Lengkap'),
                SizedBox(height: 16.0),

                // Username
                _buildTextField(_usernameController, 'Username'),
                SizedBox(height: 16.0),

                // Email
                _buildTextField(
                  _emailController,
                  'Email',
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return 'Email tidak boleh kosong';
                    if (!value.contains('@')) return 'Email tidak valid';
                    return null;
                  },
                ),
                SizedBox(height: 16.0),

                // Password
                _buildTextField(
                  _passwordController,
                  'Password',
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return 'Password tidak boleh kosong';
                    if (value.length < 8) return 'Password minimal 8 karakter';
                    return null;
                  },
                ),
                SizedBox(height: 16.0),

                // Konfirmasi Password
                _buildTextField(
                  _confirmPasswordController,
                  'Konfirmasi Password',
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return 'Konfirmasi password tidak boleh kosong';
                    if (value != _passwordController.text)
                      return 'Konfirmasi password tidak sesuai';
                    return null;
                  },
                ),
                SizedBox(height: 16.0),

                // Role
                DropdownButtonFormField<int>(
                  decoration: InputDecoration(
                    labelText: 'Pilih Role',
                    border: OutlineInputBorder(),
                  ),
                  value: _selectedRoleId,
                  items:
                      _roles.isEmpty
                          ? [
                            DropdownMenuItem<int>(
                              value: null,
                              child: Text(
                                _errorMessage != null
                                    ? 'Gagal memuat role'
                                    : 'Memuat role...',
                              ),
                            ),
                          ]
                          : _roles.map((role) {
                            return DropdownMenuItem<int>(
                              value: role['id'],
                              child: Text(role['name']),
                            );
                          }).toList(),
                  onChanged:
                      _roles.isEmpty
                          ? null
                          : (value) {
                            setState(() {
                              _selectedRoleId = value;
                            });
                          },
                  validator:
                      (value) => value == null ? 'Role harus dipilih' : null,
                ),
                if (_errorMessage != null && _roles.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      _errorMessage!,
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                SizedBox(height: 24.0),

                // Error Message
                if (_errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Text(
                      _errorMessage!,
                      style: TextStyle(color: Colors.red),
                    ),
                  ),

                // Tombol Daftar
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green, // Sesuaikan warna tombol
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: _isLoading ? null : _register,
                    child:
                        _isLoading
                            ? CircularProgressIndicator(color: Colors.white)
                            : Text('Daftar', style: TextStyle(fontSize: 16)),
                  ),
                ),
                SizedBox(height: 16.0),

                // Login Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Sudah punya akun?',
                      style: TextStyle(color: Colors.grey),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, LoginScreen.routeName);
                      },
                      child: Text(
                        'Login di sini',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label, {
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
      validator:
          validator ??
          (value) =>
              value == null || value.isEmpty
                  ? '$label tidak boleh kosong'
                  : null,
    );
  }
}