import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String baseUrl = "http://10.0.2.2:8000"; // Gunakan 10.0.2.2 jika pakai emulator Android

  static Future<Map<String, dynamic>> login(String email, String password) async {
    final url = Uri.parse("$baseUrl/api/login");

    try {
      final response = await http.post(
        url,
        headers: {"Accept": "application/json"},
        body: {
          "email": email,
          "password": password,
        },
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        String token = data['access_token']; // ✅ Sesuaikan dengan respons Laravel

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);

        return {
          "success": true,
          "message": data['message'],
          "role": data['user']['user_role_id'], // kirim juga role biar bisa routing
        };
      } else {
        return {
          "success": false,
          "message": data['message'] ?? 'Email atau password salah',
        };
      }
    } catch (e) {
      return {
        "success": false,
        "message": "Tidak dapat menghubungi server",
      };
    }
  }

  static Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }



    static Future<bool> logout() async {
    final token = await getToken();
    if (token == null) return false;

    final url = Uri.parse("$baseUrl/api/logout");

    try {
      final response = await http.post(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        },
      );

      if (response.statusCode == 200) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.remove('token');
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

}
