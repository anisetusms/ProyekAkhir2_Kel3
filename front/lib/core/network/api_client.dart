import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:front/core/utils/constants.dart';
import 'dart:io'; 
import 'package:flutter/foundation.dart';

class ApiClient {
  final Dio _dio = Dio();

  // Getter untuk mengakses instance Dio
  Dio get dio => _dio;

  ApiClient() {
    _dio.options.baseUrl = Constants.baseUrl;
    _dio.options.headers['Content-Type'] = 'application/json';

    // Interceptor untuk menambahkan token secara otomatis jika tersedia
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final prefs = await SharedPreferences.getInstance();
          final token = prefs.getString('token');
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
      ),
    );
  }

  // Tambahkan ini di class ApiClient
  Future<dynamic> uploadFile(
    String endpoint,
    File file, {
    String fieldName = 'profile_picture',
  }) async {
    try {
      FormData formData = FormData.fromMap({
        fieldName: await MultipartFile.fromFile(
          file.path,
          filename: 'profile_${DateTime.now().millisecondsSinceEpoch}.jpg',
        ),
      });

      final response = await _dio.post(
        endpoint,
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );

      return response.data;
    } on DioException catch (e) {
      debugPrint('Upload Error: ${e.response?.data}');
      rethrow;
    }
  }

  // POST request dengan body berupa form-data
  Future<dynamic> post(
    String endpoint, {
    Map<String, dynamic>? body,
    FormData? formData,
  }) async {
    try {
      Response response;
      if (formData != null) {
        // Jika formData disertakan, gunakan formData untuk upload
        response = await _dio.post(endpoint, data: formData);
      } else {
        response = await _dio.post(endpoint, data: body);
      }
      return response.data;
    } catch (e) {
      _handleError(e as DioException);
      return null;
    }
  }

  // Untuk permintaan GET
  Future<dynamic> get(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.get(
        endpoint,
        queryParameters: queryParameters,
      );
      return response.data;
    } catch (e) {
      _handleError(e as DioException);
      return null;
    }
  }

  // PUT request
  Future<dynamic> put(String endpoint, {Map<String, dynamic>? body}) async {
    try {
      final response = await _dio.put(endpoint, data: body);
      return response.data;
    } catch (e) {
      _handleError(e as DioException);
      return null;
    }
  }

  // DELETE request
  Future<dynamic> delete(String endpoint) async {
    try {
      final response = await _dio.delete(endpoint);
      return response.data;
    } catch (e) {
      _handleError(e as DioException);
      return null;
    }
  }

  // Fungsi untuk menangani error
  void _handleError(DioException error) {
    String errorMessage = 'Terjadi kesalahan yang tidak diketahui.';

    if (error.response != null && error.response!.data != null) {
      final responseData = error.response!.data;
      print('🛠️ [DEBUG ERROR RESPONSE]: $responseData');
      errorMessage =
          responseData['message'] ?? 'Terjadi kesalahan dari server.';
      if (responseData['errors'] != null) {
        final errors = responseData['errors'] as Map<String, dynamic>;
        final detailErrors = errors.values
            .map((e) => (e is List ? e.join(', ') : e.toString()))
            .join('\n');
        errorMessage += '\n$detailErrors';
      }
    } else {
      print('⚠️ [NETWORK ERROR]: ${error.message}');
      errorMessage =
          error.message ?? 'Terjadi kesalahan pada koneksi atau request.';
    }

    throw Exception(errorMessage);
  }
}
