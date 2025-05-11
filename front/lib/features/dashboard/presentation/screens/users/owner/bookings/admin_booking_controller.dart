import 'package:front/core/network/api_client.dart';
import 'package:front/core/utils/constants.dart';

class AdminBookingController {
  final ApiClient _apiClient;

  AdminBookingController({ApiClient? apiClient}) 
      : _apiClient = apiClient ?? ApiClient();

  Future<List<dynamic>> getBookings() async {
    final response = await _apiClient.get('${Constants.baseUrl}/admin/bookings');
    
    if (response is Map<String, dynamic> && response.containsKey('data')) {
      return response['data'] as List<dynamic>;
    }
    
    throw Exception('Format data tidak sesuai');
  }

  Future<Map<String, dynamic>> getBookingDetails(int bookingId) async {
    final response = await _apiClient.get(
      '${Constants.baseUrl}/admin/bookings/$bookingId',
    );
    
    if (response is Map<String, dynamic> && response.containsKey('data')) {
      return response['data'] as Map<String, dynamic>;
    }
    
    throw Exception('Format data tidak sesuai');
  }

  Future<void> confirmBooking(int bookingId) async {
    await _apiClient.post(
      '${Constants.baseUrl}/admin/bookings/$bookingId/confirm',
      {},
    );
  }

  Future<void> rejectBooking(int bookingId) async {
    await _apiClient.post(
      '${Constants.baseUrl}/admin/bookings/$bookingId/reject',
      {},
    );
  }

  Future<void> completeBooking(int bookingId) async {
    await _apiClient.post(
      '${Constants.baseUrl}/admin/bookings/$bookingId/complete',
      {},
    );
  }

  Future<Map<String, dynamic>> getBookingStatistics() async {
    final response = await _apiClient.get(
      '${Constants.baseUrl}/admin/bookings/statistics',
    );
    
    if (response is Map<String, dynamic> && response.containsKey('data')) {
      return response['data'] as Map<String, dynamic>;
    }
    
    throw Exception('Format data tidak sesuai');
  }
}
