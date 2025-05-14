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
    // Set base URL dan timeout
    _dio.options.baseUrl = Constants.baseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 15);
    _dio.options.receiveTimeout = const Duration(seconds: 15);
    _dio.options.sendTimeout = const Duration(seconds: 15);

    // Set default headers
    _dio.options.headers['Accept'] = 'application/json';
    _dio.options.validateStatus = (status) {
      return status! < 500; // Terima semua status kode di bawah 500
    };

    // Tambahkan logging untuk debugging
    _dio.interceptors.add(
      LogInterceptor(
        request: true,
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
        responseBody: true,
        error: true,
        logPrint: (object) {
          debugPrint(object.toString());
        },
      ),
    );

    // Interceptor untuk menambahkan header Authorization
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Tambahkan token ke header jika tersedia
          final prefs = await SharedPreferences.getInstance();
          final token = prefs.getString('token');
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }

          // Log request untuk debugging
          debugPrint(
            '🚀 REQUEST[${options.method}] => URL: ${options.baseUrl}${options.path}',
          );
          if (options.queryParameters.isNotEmpty) {
            debugPrint('QUERY PARAMS: ${options.queryParameters}');
          }
          return handler.next(options);
        },
        onResponse: (response, handler) {
          // Log response untuk debugging
          debugPrint(
            '✅ RESPONSE[${response.statusCode}] => URL: ${response.requestOptions.baseUrl}${response.requestOptions.path}',
          );
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          // Log error untuk debugging
          debugPrint(
            '⚠️ ERROR[${e.response?.statusCode}] => URL: ${e.requestOptions.baseUrl}${e.requestOptions.path}',
          );
          debugPrint('ERROR MESSAGE: ${e.message}');

          // Coba tampilkan response body jika ada
          if (e.response?.data != null) {
            debugPrint('ERROR RESPONSE: ${e.response?.data}');
          }

          return handler.next(e);
        },
      ),
    );
  }

  // Tambahkan metode untuk mendapatkan token
  Future<String?> getToken() async {
    // Mengambil token yang disimpan di SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  /// GET request
  Future<dynamic> get(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      // Tambahkan log untuk debugging
      debugPrint('Sending GET request to: ${Constants.baseUrl}$endpoint');
      if (queryParameters != null) {
        debugPrint('With query parameters: $queryParameters');
      }

      final response = await _dio.get(
        endpoint,
        queryParameters: queryParameters,
      );

      // Tambahkan log untuk debugging
      debugPrint('Response status code: ${response.statusCode}');
      debugPrint('Response data: ${response.data}');

      return response.data;
    } catch (e) {
      // Log error untuk debugging
      debugPrint('GET Error: $e');
      if (e is DioException) {
        _handleError(e);
      } else {
        throw Exception('Error: $e');
      }
      return null;
    }
  }

  /// POST request
  Future<dynamic> post(
    String endpoint, {
    Map<String, dynamic>? body,
    FormData? formData,
  }) async {
    try {
      // Tambahkan log untuk debugging
      debugPrint('Sending POST request to: ${Constants.baseUrl}$endpoint');
      if (body != null) {
        debugPrint('With body: $body');
      } else if (formData != null) {
        debugPrint('With FormData fields: ${formData.fields}');
        debugPrint('With FormData files: ${formData.files.length}');
      }

      Response response;
      if (formData != null) {
        // Set content type untuk form data
        Options options = Options(
          contentType: 'multipart/form-data',
          headers: {'Accept': 'application/json'},
        );
        response = await _dio.post(endpoint, data: formData, options: options);
      } else {
        response = await _dio.post(endpoint, data: body);
      }

      // Tambahkan log untuk debugging
      debugPrint('Response status code: ${response.statusCode}');
      debugPrint('Response data: ${response.data}');

      return response.data;
    } catch (e) {
      // Log error untuk debugging
      debugPrint('POST Error: $e');
      if (e is DioException) {
        _handleError(e);
      } else {
        throw Exception('Error: $e');
      }
      return null;
    }
  }

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

  /// PUT request
  Future<dynamic> put(
    String endpoint, {
    Map<String, dynamic>? body,
    FormData? formData,
  }) async {
    try {
      // Tambahkan log untuk debugging
      debugPrint('Sending PUT request to: ${Constants.baseUrl}$endpoint');
      if (body != null) {
        debugPrint('With body: $body');
      } else if (formData != null) {
        debugPrint('With FormData fields: ${formData.fields}');
        debugPrint('With FormData files: ${formData.files.length}');
      }

      Response response;
      if (formData != null) {
        // Set content type untuk form data
        Options options = Options(
          contentType: 'multipart/form-data',
          headers: {
            'Accept': 'application/json',
            'X-HTTP-Method-Override':
                'PUT', // Tambahkan header ini untuk Laravel
          },
        );
        response = await _dio.put(endpoint, data: formData, options: options);
      } else {
        // Untuk data JSON, gunakan application/json
        Options options = Options(
          contentType: 'application/json',
          headers: {'Accept': 'application/json'},
        );
        response = await _dio.put(endpoint, data: body, options: options);
      }

      // Tambahkan log untuk debugging
      debugPrint('Response status code: ${response.statusCode}');
      debugPrint('Response data: ${response.data}');

      return response.data;
    } catch (e) {
      // Log error untuk debugging
      debugPrint('PUT Error: $e');
      if (e is DioException) {
        _handleError(e);
      } else {
        throw Exception('Error: $e');
      }
      return null;
    }
  }

  /// DELETE request
  Future<dynamic> delete(String endpoint) async {
    try {
      // Tambahkan log untuk debugging
      debugPrint('Sending DELETE request to: ${Constants.baseUrl}$endpoint');

      final response = await _dio.delete(endpoint);

      // Tambahkan log untuk debugging
      debugPrint('Response status code: ${response.statusCode}');
      debugPrint('Response data: ${response.data}');

      return response.data;
    } catch (e) {
      // Log error untuk debugging
      debugPrint('DELETE Error: $e');
      if (e is DioException) {
        _handleError(e);
      } else {
        throw Exception('Error: $e');
      }
      return null;
    }
  }

  /// Handle error response from Dio
  void _handleError(DioException error) {
    String errorMessage = 'Terjadi kesalahan yang tidak diketahui.';

    // Log error details for debugging
    debugPrint('DioException Type: ${error.type}');
    debugPrint('DioException Message: ${error.message}');
    debugPrint('Request Path: ${error.requestOptions.path}');
    debugPrint('Request Method: ${error.requestOptions.method}');
    debugPrint('Request Headers: ${error.requestOptions.headers}');

    if (error.response != null) {
      debugPrint('Response Status Code: ${error.response!.statusCode}');
      debugPrint('Response Data: ${error.response!.data}');
    }

    // Handle different error types
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        errorMessage = 'Koneksi timeout. Periksa koneksi internet Anda.';
        break;
      case DioExceptionType.sendTimeout:
        errorMessage =
            'Timeout saat mengirim data. Periksa koneksi internet Anda.';
        break;
      case DioExceptionType.receiveTimeout:
        errorMessage =
            'Timeout saat menerima data. Periksa koneksi internet Anda.';
        break;
      case DioExceptionType.badResponse:
        if (error.response != null) {
          final statusCode = error.response!.statusCode;
          if (statusCode == 401) {
            errorMessage = 'Tidak diizinkan. Silakan login kembali.';
          } else if (statusCode == 403) {
            errorMessage = 'Akses ditolak.';
          } else if (statusCode == 404) {
            errorMessage = 'Endpoint tidak ditemukan.';
          } else if (statusCode == 422) {
            // Validation errors
            if (error.response!.data is Map<String, dynamic> &&
                error.response!.data['errors'] != null) {
              final errors =
                  error.response!.data['errors'] as Map<String, dynamic>;
              final errorList = <String>[];
              errors.forEach((key, value) {
                if (value is List) {
                  errorList.addAll(value.map((e) => e.toString()));
                } else {
                  errorList.add(value.toString());
                }
              });
              errorMessage = errorList.join('\n');
            } else if (error.response!.data is Map<String, dynamic> &&
                error.response!.data['message'] != null) {
              errorMessage = error.response!.data['message'];
            } else {
              errorMessage = 'Validasi gagal.';
            }
          } else {
            errorMessage = 'Terjadi kesalahan pada server.';
          }
        }
        break;
      case DioExceptionType.cancel:
        errorMessage = 'Permintaan dibatalkan.';
        break;
      case DioExceptionType.connectionError:
        errorMessage = 'Koneksi error. Periksa koneksi internet Anda.';
        break;
      case DioExceptionType.unknown:
        if (error.error is SocketException) {
          errorMessage =
              'Tidak dapat terhubung ke server. Periksa koneksi internet Anda.';
        } else {
          errorMessage = 'Terjadi kesalahan yang tidak diketahui.';
        }
        break;
      default:
        errorMessage = 'Terjadi kesalahan yang tidak diketahui.';
        break;
    }

    throw Exception(errorMessage);
  }
}
