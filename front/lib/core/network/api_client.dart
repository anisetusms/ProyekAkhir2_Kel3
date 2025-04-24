import 'package:dio/dio.dart';
import 'package:front/core/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiClient {
  final Dio _dio = Dio();

  ApiClient() {
    _dio.options.baseUrl = Constants.baseUrl;
    _dio.options.headers['Content-Type'] = 'application/json';

    // Interceptor untuk menambahkan token secara otomatis jika tersedia
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final prefs = await SharedPreferences.getInstance();
        final token = prefs.getString('token');
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
    ));
  }

  Future<dynamic> post(String endpoint, {Map<String, dynamic>? body}) async {
    try {
      final response = await _dio.post(endpoint, data: body);
      return response.data;
    } catch (e) {
      _handleError(e as DioException);
      return null;
    }
  }

  Future<dynamic> get(String endpoint, {Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await _dio.get(endpoint, queryParameters: queryParameters);
      return response.data;
    } catch (e) {
      _handleError(e as DioException);
      return null;
    }
  }

  Future<dynamic> put(String endpoint, {Map<String, dynamic>? body}) async {
    try {
      final response = await _dio.put(endpoint, data: body);
      return response.data;
    } catch (e) {
      _handleError(e as DioException);
      return null;
    }
  }

  Future<dynamic> delete(String endpoint) async {
    try {
      final response = await _dio.delete(endpoint);
      return response.data;
    } catch (e) {
      _handleError(e as DioException);
      return null;
    }
  }

  void _handleError(DioException error) {
    String errorMessage = 'Terjadi kesalahan yang tidak diketahui.';
    if (error.response != null && error.response!.data != null) {
      errorMessage = error.response!.data['message'] ?? 'Terjadi kesalahan dari server.';
    } else {
      errorMessage = error.message ?? 'Terjadi kesalahan pada koneksi atau request.';
    }
    throw Exception(errorMessage);
  }
}