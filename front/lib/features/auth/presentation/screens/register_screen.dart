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
  final TextEditingController _confirmPasswordController = TextEditingController();

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
        setState(() {
          _roles = List<Map<String, dynamic>>.from(data['data'].map((role) => {
                'id': int.parse(role['id'].toString()), // ✅ pastikan id-nya integer
                'name': role['name']
              }));
        });
      } else {
        setState(() {
          _errorMessage = 'Gagal memuat data role';
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
            'role_id': _selectedRoleId.toString(), // kirim sebagai string ke API
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
      appBar: AppBar(
        title: Text('Daftar Akun'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                _buildTextField(_nameController, 'Nama Lengkap'),
                SizedBox(height: 16.0),
                _buildTextField(_usernameController, 'Username'),
                SizedBox(height: 16.0),
                _buildTextField(_emailController, 'Email', keyboardType: TextInputType.emailAddress, validator: (value) {
                  if (value == null || value.isEmpty) return 'Email tidak boleh kosong';
                  if (!value.contains('@')) return 'Email tidak valid';
                  return null;
                }),
                SizedBox(height: 16.0),
                _buildTextField(_passwordController, 'Password', obscureText: true, validator: (value) {
                  if (value == null || value.isEmpty) return 'Password tidak boleh kosong';
                  if (value.length < 8) return 'Password minimal 8 karakter';
                  return null;
                }),
                SizedBox(height: 16.0),
                _buildTextField(_confirmPasswordController, 'Konfirmasi Password', obscureText: true, validator: (value) {
                  if (value == null || value.isEmpty) return 'Konfirmasi password tidak boleh kosong';
                  if (value != _passwordController.text) return 'Konfirmasi password tidak sesuai';
                  return null;
                }),
                SizedBox(height: 16.0),
                DropdownButtonFormField<int>(
                  decoration: InputDecoration(
                    labelText: 'Pilih Role',
                    border: OutlineInputBorder(),
                  ),
                  value: _selectedRoleId,
                  items: _roles.map((role) {
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
                  validator: (value) =>
                      value == null ? 'Role harus dipilih' : null,
                ),
                SizedBox(height: 24.0),
                if (_errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Text(
                      _errorMessage!,
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ElevatedButton(
                  onPressed: _isLoading ? null : _register,
                  child: _isLoading
                      ? CircularProgressIndicator()
                      : Text('Daftar'),
                ),
                SizedBox(height: 16.0),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Sudah punya akun? Login di sini'),
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
      validator: validator ??
          (value) =>
              value == null || value.isEmpty ? '$label tidak boleh kosong' : null,
    );
  }
}
