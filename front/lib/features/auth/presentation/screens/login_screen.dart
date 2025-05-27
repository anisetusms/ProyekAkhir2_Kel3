import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:front/core/network/api_client.dart';
import 'package:front/core/utils/constants.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/login';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;
  String? _errorMessage;

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      try {
        final response = await ApiClient().post(
          '${Constants.baseUrl}/login',
          body: {
            'email': _emailController.text.trim(),
            'password': _passwordController.text,
          },
        );

        // Tambahkan pengecekan jika response mengandung "message" saja
        if (response != null &&
            response['message'] != null &&
            response['access_token'] == null) {
          setState(() {
            _errorMessage = response['message'];
          });
          return;
        }

        // Cek validitas akses
        if (response == null ||
            response['access_token'] == null ||
            response['user'] == null) {
          setState(() {
            _errorMessage = 'Login gagal. Cek kembali email dan password Anda.';
          });
          return;
        }

        final userRoleId = response['user']['user_role_id'];
        final userStatus = response['user']['status'];

        // Cek jika owner status-nya belum approved
        if (userRoleId == 2 && userStatus != 'approved') {
          setState(() {
            _errorMessage =
                response['message'] ??
                'Login gagal. Akun Anda belum disetujui oleh admin. Silakan menunggu persetujuan.';
          });

          // Simpan token untuk keperluan tertentu
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('token', response['access_token']);
          await prefs.setInt('user_role_id', userRoleId);
          return;
        }

        // Simpan token & role ID
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', response['access_token']);
        await prefs.setInt('user_role_id', userRoleId);

        // Arahkan ke halaman utama
        Navigator.pushReplacementNamed(context, '/bottombar');
      } catch (e) {
        setState(() {
          _errorMessage = 'Terjadi kesalahan saat login. Coba lagi nanti.';
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
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  'assets/icons/logo.jpg', // Pastikan path sesuai dengan file Anda
                  height: 200,
                ),
                SizedBox(height: 24.0),

                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Login",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 16.0),

                // Email field
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: 'Email',
                    prefixIcon: Icon(Icons.email_outlined),
                    border: UnderlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email tidak boleh kosong';
                    }
                    if (!value.contains('@')) {
                      return 'Email tidak valid';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),

                // Password field
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    hintText: 'Password',
                    prefixIcon: Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                    border: UnderlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password tidak boleh kosong';
                    }
                    return null;
                  },
                ),

                SizedBox(height: 8.0),

                // Error Message
                if (_errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Text(
                      _errorMessage!,
                      style: TextStyle(color: Colors.red),
                    ),
                  ),

                // Tombol Login
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: _isLoading ? null : _login,
                    child:
                        _isLoading
                            ? CircularProgressIndicator(color: Colors.white)
                            : Text('Masuk', style: TextStyle(fontSize: 16)),
                  ),
                ),

                SizedBox(height: 24.0),

                // Daftar Akun
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Belum punya akun?',
                      style: TextStyle(color: Colors.grey),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, RegisterScreen.routeName);
                      },
                      child: Text(
                        'Daftar',
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
}
