import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  // Gunakan secure storage untuk menyimpan token secara aman
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  static const String _tokenKey = 'auth_token';

  /// Menyimpan token ke storage
  Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  /// Mengambil token dari storage
  Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  /// Menghapus token (saat logout)
  Future<void> clearToken() async {
    await _storage.delete(key: _tokenKey);
  }

  /// Mengecek apakah user sudah login (berdasarkan ketersediaan token)
  Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }
}
