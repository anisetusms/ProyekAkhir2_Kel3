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
          Constants.baseUrl + '/login',
          body: {
            'email': _emailController.text,
            'password': _passwordController.text,
          },
        );

        // Validasi jika response kosong atau tidak ada access token
        if (response == null || response['access_token'] == null) {
          setState(() {
            _errorMessage = 'Login gagal. Cek email dan password Anda.';
          });
          return;
        }

        // Cek jika akun memiliki status pending (khusus Owner)
        if (response['user']['user_role_id'] == 2 && response['user']['status'] != 'approved') {
          setState(() {
            _errorMessage =
                response['message'] ?? 'Akun Anda belum disetujui oleh admin. Silakan menunggu.';
          });

          // Simpan token meskipun pending untuk kebutuhan tertentu
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('token', response['access_token']);
          await prefs.setInt('user_role_id', response['user']['user_role_id']);
          return;
        }

        // Jika login berhasil, simpan token dan role ID ke SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', response['access_token']);
        await prefs.setInt('user_role_id', response['user']['user_role_id']);

        // Redirect ke halaman utama setelah login sukses
        Navigator.pushReplacementNamed(context, '/bottombar');
      } catch (e) {
        setState(() {
          _errorMessage = 'Terjadi kesalahan: ${e.toString()}';
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
