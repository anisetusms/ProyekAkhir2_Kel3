import 'dart:io';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:front/core/utils/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ApiClient {
  final Dio _dio = Dio();
  Dio get dio => _dio;

  ApiClient() {
    // Set base URL and content type
    _dio.options.baseUrl = Constants.baseUrl;
    _dio.options.headers['Content-Type'] = 'application/json';

    // Interceptor for adding the Authorization header
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final prefs = await SharedPreferences.getInstance();
          final token = prefs.getString('token');
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);  // Continue the request
        },
      ),
    );
  }

  /// Upload file to the server
  Future<dynamic> uploadFile(
    String endpoint,
    File file, {
    String fieldName = 'profile_picture', // Default field name for the file
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

      return response.data; // Return the response data
    } on DioException catch (e) {
      debugPrint('Upload Error: ${e.response?.data}');
      _handleError(e);
      rethrow;
    }
  }

  /// POST request with body as form-data
  Future<dynamic> post(
    String endpoint, {
    Map<String, dynamic>? body,
    FormData? formData,
  }) async {
    try {
      Response response;
      if (formData != null) {
        response = await _dio.post(endpoint, data: formData);
      } else {
        response = await _dio.post(endpoint, data: body);
      }

      // Pastikan response data yang diterima berupa Map
      if (response.data is Map<String, dynamic>) {
        return response.data; // Kembalikan data dalam bentuk Map
      } else {
        throw Exception('Response tidak valid');
      }
    } catch (e) {
      _handleError(e as DioException);
      return null;
    }
  }

  /// GET request
  Future<dynamic> get(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.get(
        endpoint,
        queryParameters: queryParameters,
      );
      return response.data;  // Return the response data
    } catch (e) {
      _handleError(e as DioException);
      return null;
    }
  }

  /// PUT request
  Future<dynamic> put(
    String endpoint, {
    Map<String, dynamic>? body,
    FormData? formData,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      Options options = Options(
        headers: {
          'Authorization': 'Bearer $token',
          if (formData != null) 'Content-Type': 'multipart/form-data',
        },
      );

      final response = await _dio.put(
        endpoint,
        data: formData ?? body,
        options: options,
      );

      return response.data; // Return the response data
    } on DioException catch (e) {
      _handleError(e);
      return null;
    }
  }

  /// DELETE request
  Future<dynamic> delete(String endpoint) async {
    try {
      final response = await _dio.delete(endpoint);
      return response.data;  // Return the response data
    } catch (e) {
      _handleError(e as DioException);
      return null;
    }
  }

  /// Handle error response from Dio
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

    throw Exception(errorMessage);  // Throwing the exception with the error message
  }
}
