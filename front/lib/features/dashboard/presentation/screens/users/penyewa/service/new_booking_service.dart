import 'dart:io';
import 'package:dio/dio.dart';
import 'package:front/core/network/api_client.dart';
import 'package:front/features/dashboard/presentation/screens/users/penyewa/models/booking_model.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:front/core/services/auth_service.dart';

class BookingServiceException implements Exception {
  final String message;
  final int? status;
  final dynamic data;

  BookingServiceException({required this.message, this.status, this.data});

  @override
  String toString() =>
      'BookingServiceException: $message${status != null ? ' (Status $status)' : ''}';
}

class BookingService {
  final ApiClient _apiClient;

  BookingService(this._apiClient);

  Future<Map<String, String>> getAuthHeaders() async {
    final token = await AuthService().getToken();
    return {'Authorization': 'Bearer $token', 'Accept': 'application/json'};
  }

  Future<Map<String, dynamic>> checkAvailability({
    required int propertyId,
    required DateTime checkIn,
    required DateTime checkOut,
  }) async {
    try {
      // Pastikan tanggal tidak memiliki komponen waktu
      final cleanCheckIn = DateTime(checkIn.year, checkIn.month, checkIn.day);
      final cleanCheckOut = DateTime(
        checkOut.year,
        checkOut.month,
        checkOut.day,
      );

      // Format tanggal sesuai dengan yang diharapkan server (yyyy-MM-dd)
      final formattedCheckIn = DateFormat('yyyy-MM-dd').format(cleanCheckIn);
      final formattedCheckOut = DateFormat('yyyy-MM-dd').format(cleanCheckOut);

      debugPrint(
        'Checking availability for: $formattedCheckIn to $formattedCheckOut',
      );

      final response = await _apiClient.post(
        '/bookings/check-availability',
        body: {
          'property_id': propertyId,
          'check_in': formattedCheckIn,
          'check_out': formattedCheckOut,
        },
      );

      if (response['statusCode'] != 200) {
        throw BookingServiceException(
          message:
              _parseErrorMessage(response['data']) ??
              'Failed to check availability',
          status: response['statusCode'],
          data: response['data'],
        );
      }

      return response['data'];
    } on DioError catch (e) {
      throw BookingServiceException(
        message: _parseDioErrorMessage(e) ?? 'Network error occurred',
        status: e.response?.statusCode,
        data: e.response?.data,
      );
    } catch (e) {
      throw BookingServiceException(
        message: 'Failed to check availability: ${e.toString()}',
      );
    }
  }

  Future<Booking> createBooking({
    required int propertyId,
    List<int>? roomIds,
    required DateTime checkIn,
    required DateTime checkOut,
    required bool isForOthers,
    String? guestName,
    String? guestPhone,
    required File ktpImage,
    required String identityNumber,
    String? specialRequests,
  }) async {
    try {
      // Pastikan tanggal tidak memiliki komponen waktu
      final cleanCheckIn = DateTime(checkIn.year, checkIn.month, checkIn.day);
      final cleanCheckOut = DateTime(
        checkOut.year,
        checkOut.month,
        checkOut.day,
      );

      // Format tanggal sesuai dengan yang diharapkan server (yyyy-MM-dd)
      final formattedCheckIn = DateFormat('yyyy-MM-dd').format(cleanCheckIn);
      final formattedCheckOut = DateFormat('yyyy-MM-dd').format(cleanCheckOut);

      // Debug log untuk melihat tanggal yang dikirim
      debugPrint(
        'Creating booking with dates: $formattedCheckIn to $formattedCheckOut',
      );

      // Validasi durasi sesuai dengan validasi server
      final days = cleanCheckOut.difference(cleanCheckIn).inDays;
      debugPrint('Calculated days: $days');

      if (days < 1) {
        throw BookingServiceException(
          message: 'Durasi minimal pemesanan adalah 1 hari',
        );
      }

      final formData = FormData.fromMap({
        'property_id': propertyId,
        'check_in': formattedCheckIn,
        'check_out': formattedCheckOut,
        'is_for_others': isForOthers ? 1 : 0,
        if (isForOthers && guestName != null) 'guest_name': guestName,
        if (isForOthers && guestPhone != null) 'guest_phone': guestPhone,
        'ktp_image': await MultipartFile.fromFile(
          ktpImage.path,
          filename:
              'ktp_${DateTime.now().millisecondsSinceEpoch}${ktpImage.path.substring(ktpImage.path.lastIndexOf('.'))}',
        ),
        'identity_number': identityNumber,
        if (specialRequests != null && specialRequests.isNotEmpty)
          'special_requests': specialRequests,
      });

      // Add room IDs if provided
      if (roomIds != null && roomIds.isNotEmpty) {
        for (var roomId in roomIds) {
          formData.fields.add(MapEntry('room_ids[]', roomId.toString()));
        }
      }

      // Debug log untuk melihat data yang dikirim
      debugPrint('Sending booking data: ${formData.fields}');

      // Kirim request ke API
      final response = await _apiClient.post('/bookings', formData: formData);

      // Debug log untuk melihat respons lengkap
      debugPrint('Server response status: ${response['status']}');
      debugPrint('Server response data: ${response['data']}');

      // Periksa respons dengan lebih fleksibel
      if (response['status'] == 'success') {
        // Respons sukses, coba parse data booking
        if (response['data'] != null) {
          if (response['data']['data'] != null) {
            // Format respons: { data: { data: {...} } }
            return Booking.fromJson(response['data']['data']);
          } else {
            // Format respons: { data: {...} }
            return Booking.fromJson(response['data']);
          }
        } else {
          throw BookingServiceException(
            message: 'Respons server tidak valid: Data kosong',
            status: response['status'],
            data: response['data'],
          );
        }
      } else {
        // Respons error
        throw BookingServiceException(
          message:
              _parseErrorMessage(response['data']) ??
              'Failed to create booking',
          status: response['status'],
          data: response['data'],
        );
      }
    } on DioError catch (e) {
      debugPrint('DioError: ${e.response?.data}');
      throw BookingServiceException(
        message: _parseDioErrorMessage(e) ?? 'Network error occurred',
        status: e.response?.statusCode,
        data: e.response?.data,
      );
    } catch (e) {
      debugPrint('Error creating booking: $e');
      throw BookingServiceException(
        message: 'Failed to create booking: ${e.toString()}',
      );
    }
  }

  Future<List<Booking>> getUserBookings() async {
    try {
      final response = await _apiClient.get('/bookings/user');

      if (response == null) {
        throw Exception('Tidak ada respons dari server');
      }

      if (response is List) {
        return response.map((item) => Booking.fromJson(item)).toList();
      } else if (response is Map &&
          response.containsKey('data') &&
          response['data'] is List) {
        return (response['data'] as List)
            .map((item) => Booking.fromJson(item))
            .toList();
      } else {
        throw Exception('Format respons tidak valid');
      }
    } catch (e) {
      throw Exception('Gagal memuat daftar booking: $e');
    }
  }

  Future<Booking> getBookingDetail(int id) async {
    try {
      final response = await _apiClient.get('/bookings/$id');

      if (response['statusCode'] != 200) {
        throw BookingServiceException(
          message:
              _parseErrorMessage(response['data']) ??
              'Failed to fetch booking details',
          status: response['statusCode'],
          data: response['data'],
        );
      }

      return Booking.fromJson(response['data']['data']);
    } on DioError catch (e) {
      throw BookingServiceException(
        message: _parseDioErrorMessage(e) ?? 'Network error occurred',
        status: e.response?.statusCode,
        data: e.response?.data,
      );
    } catch (e) {
      throw BookingServiceException(
        message: 'Failed to fetch booking details: ${e.toString()}',
      );
    }
  }

  Future<void> cancelBooking(int bookingId) async {
    try {
      final response = await _apiClient.put(
        '/bookings/$bookingId/cancel',
        body: {}, // atau formData, tergantung definisinya
      );
      if (response == null) {
        throw Exception('Tidak ada respons dari server');
      }

      if (response is Map &&
          response.containsKey('success') &&
          response['success'] == true) {
        return;
      } else {
        final message =
            response is Map && response.containsKey('message')
                ? response['message']
                : 'Gagal membatalkan booking';
        throw Exception(message);
      }
    } catch (e) {
      throw Exception('Gagal membatalkan booking: $e');
    }
  }

  // Helper method to parse error messages from the response data
  String? _parseErrorMessage(dynamic responseData) {
    if (responseData == null) return null;
    if (responseData is Map) {
      return responseData['message'] ??
          (responseData['errors'] is Map
              ? (responseData['errors'].values.first?.first)
              : null);
    }
    return null;
  }

  // Helper method to parse Dio errors
  String? _parseDioErrorMessage(DioError e) {
    if (e.response?.data != null && e.response?.data is Map) {
      return _parseErrorMessage(e.response?.data);
    }
    return e.message;
  }
}
