import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String baseUrl = "http://127.0.0.1:8000"; // sesuaikan IP (10.0.2.2 jika pakai emulator Android)

  static Future<bool> login(String email, String password) async {
    final url = Uri.parse("$baseUrl/api/login");

    final response = await http.post(
      url,
      headers: {"Accept": "application/json"},
      body: {
        "email": email,
        "password": password,
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      String token = data['token'];

      // Simpan token ke storage
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);

      return true;
    } else {
      print("Login gagal: ${response.body}");
      return false;
    }
  }


  static Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }
}
