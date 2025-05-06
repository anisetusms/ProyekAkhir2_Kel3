// services/booking_service.dart
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:front/core/network/api_client.dart';
import 'package:front/features/dashboard/presentation/screens/users/penyewa/models/booking_model.dart';

class BookingService {
  final ApiClient _apiClient;

  BookingService(this._apiClient);

  Future<Booking> createBooking(Booking booking, File ktpImage) async {
    try {
      // Buat FormData
      final formData = FormData.fromMap({
        ...booking.toJson(),
        'ktp_image': await MultipartFile.fromFile(
          ktpImage.path,
          filename: 'ktp_${DateTime.now().millisecondsSinceEpoch}.jpg',
        ),
      });

      // Kirim request
      final response = await _apiClient.post(
        '/bookings',
        formData: formData,
      );

      return Booking.fromJson(response['data']);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Booking>> getUserBookings() async {
    try {
      final response = await _apiClient.get('/bookings');
      return (response['data'] as List)
          .map((json) => Booking.fromJson(json))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<Booking> getBookingDetail(int id) async {
    try {
      final response = await _apiClient.get('/bookings/$id');
      return Booking.fromJson(response['data']);
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> cancelBooking(int id) async {
    try {
      await _apiClient.post('/bookings/$id/cancel');
      return true;
    } catch (e) {
      rethrow;
    }
  }
}