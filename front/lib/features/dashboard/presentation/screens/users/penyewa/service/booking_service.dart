import 'dart:io';
import 'package:dio/dio.dart';
import 'package:front/core/network/api_client.dart';
import 'package:front/features/dashboard/presentation/screens/users/penyewa/models/booking_model.dart';
import 'package:front/features/property/data/models/property_model.dart';
import 'package:intl/intl.dart';

class BookingServiceException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic data;

  BookingServiceException({
    required this.message,
    this.statusCode,
    this.data,
  });

  @override
  String toString() => 'BookingServiceException: $message${statusCode != null ? ' (Status $statusCode)' : ''}';
}

class BookingService {
  final ApiClient _apiClient;

  BookingService(this._apiClient);

  Future<PropertyModel> getPropertyDetails(int propertyId) async {
    try {
      final response = await _apiClient.get('/propertiesdetails/$propertyId');

      // Check if status code is not 200 (OK)
      if (response['statusCode'] != 200) {
        throw BookingServiceException(
          message: _parseErrorMessage(response['data']) ?? 'Failed to fetch property details',
          statusCode: response['statusCode'],
          data: response['data'],
        );
      }

      // Ensure we're handling the data correctly
      if (response['data'] == null || response['data']['data'] == null) {
        throw BookingServiceException(
          message: 'Invalid property data format',
          statusCode: response['statusCode'],
        );
      }

      // Safely parse the property data with proper type handling
      final propertyData = response['data']['data'];
      
      // Ensure propertyTypeId is treated as int
      if (propertyData['property_type_id'] is String) {
        propertyData['property_type_id'] = int.parse(propertyData['property_type_id']);
      }
      
      return PropertyModel.fromJson(propertyData);
    } on DioError catch (e) {
      throw BookingServiceException(
        message: _parseDioErrorMessage(e) ?? 'Failed to fetch property details',
        statusCode: e.response?.statusCode,
        data: e.response?.data,
      );
    } catch (e) {
      throw BookingServiceException(
        message: 'Failed to fetch property details: ${e.toString()}',
      );
    }
  }

  Future<Map<String, dynamic>> checkAvailability({
    required int propertyId,
    required DateTime checkIn,
    required DateTime checkOut,
  }) async {
    try {
      final response = await _apiClient.post('/bookings/check-availability', body: {
        'property_id': propertyId,
        'check_in': DateFormat('yyyy-MM-dd').format(checkIn),
        'check_out': DateFormat('yyyy-MM-dd').format(checkOut),
      });

      if (response['statusCode'] != 200) {
        throw BookingServiceException(
          message: _parseErrorMessage(response['data']) ?? 'Failed to check availability',
          statusCode: response['statusCode'],
          data: response['data'],
        );
      }

      return response['data'];
    } on DioError catch (e) {
      throw BookingServiceException(
        message: _parseDioErrorMessage(e) ?? 'Network error occurred',
        statusCode: e.response?.statusCode,
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
      // Validate dates
      if (checkOut.difference(checkIn).inDays < 1) {
        throw BookingServiceException(
          message: 'Check-out date must be at least 1 day after check-in date',
        );
      }

      final formData = FormData.fromMap({
        'property_id': propertyId,
        'check_in': DateFormat('yyyy-MM-dd').format(checkIn),
        'check_out': DateFormat('yyyy-MM-dd').format(checkOut),
        'is_for_others': isForOthers ? 1 : 0,
        if (isForOthers && guestName != null) 'guest_name': guestName,
        if (isForOthers && guestPhone != null) 'guest_phone': guestPhone,
        'ktp_image': await MultipartFile.fromFile(
          ktpImage.path,
          filename: 'ktp_${DateTime.now().millisecondsSinceEpoch}${ktpImage.path.substring(ktpImage.path.lastIndexOf('.'))}',
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

      // Kirim request ke API
      final response = await _apiClient.post(
        '/bookings',
        formData: formData,
      );

      // Check for successful response (201 Created)
      if (response['statusCode'] != 201) {
        throw BookingServiceException(
          message: _parseErrorMessage(response['data']) ?? 'Failed to create booking',
          statusCode: response['statusCode'],
          data: response['data'],
        );
      }

      return Booking.fromJson(response['data']['data']);
    } on DioError catch (e) {
      throw BookingServiceException(
        message: _parseDioErrorMessage(e) ?? 'Network error occurred',
        statusCode: e.response?.statusCode,
        data: e.response?.data,
      );
    } catch (e) {
      throw BookingServiceException(
        message: 'Failed to create booking: ${e.toString()}',
      );
    }
  }

  Future<List<Booking>> getUserBookings() async {
    try {
      final response = await _apiClient.get('/bookings');

      if (response['statusCode'] != 200) {
        throw BookingServiceException(
          message: _parseErrorMessage(response['data']) ?? 'Failed to fetch bookings',
          statusCode: response['statusCode'],
          data: response['data'],
        );
      }

      return (response['data']['data'] as List)
          .map((json) => Booking.fromJson(json))
          .toList();
    } on DioError catch (e) {
      throw BookingServiceException(
        message: _parseDioErrorMessage(e) ?? 'Network error occurred',
        statusCode: e.response?.statusCode,
        data: e.response?.data,
      );
    } catch (e) {
      throw BookingServiceException(
        message: 'Failed to fetch bookings: ${e.toString()}',
      );
    }
  }

  Future<Booking> getBookingDetail(int id) async {
    try {
      final response = await _apiClient.get('/bookings/$id');

      if (response['statusCode'] != 200) {
        throw BookingServiceException(
          message: _parseErrorMessage(response['data']) ?? 'Failed to fetch booking details',
          statusCode: response['statusCode'],
          data: response['data'],
        );
      }

      return Booking.fromJson(response['data']['data']);
    } on DioError catch (e) {
      throw BookingServiceException(
        message: _parseDioErrorMessage(e) ?? 'Network error occurred',
        statusCode: e.response?.statusCode,
        data: e.response?.data,
      );
    } catch (e) {
      throw BookingServiceException(
        message: 'Failed to fetch booking details: ${e.toString()}',
      );
    }
  }

  Future<void> cancelBooking(int id) async {
    try {
      final response = await _apiClient.put('/bookings/$id/cancel');

      if (response['statusCode'] != 200) {
        throw BookingServiceException(
          message: _parseErrorMessage(response['data']) ?? 'Failed to cancel booking',
          statusCode: response['statusCode'],
          data: response['data'],
        );
      }
    } on DioError catch (e) {
      if (e.response?.statusCode == 400) {
        throw BookingServiceException(
          message: _parseErrorMessage(e.response?.data) ?? 'Booking cannot be cancelled',
          statusCode: 400,
          data: e.response?.data,
        );
      }
      throw BookingServiceException(
        message: _parseDioErrorMessage(e) ?? 'Network error occurred',
        statusCode: e.response?.statusCode,
        data: e.response?.data,
      );
    } catch (e) {
      throw BookingServiceException(
        message: 'Failed to cancel booking: $e',
      );
    }
  }

  // Helper method to parse error messages from the response data
  String? _parseErrorMessage(dynamic responseData) {
    if (responseData == null) return null;
    if (responseData is Map) {
      return responseData['message'] ??
             (responseData['errors'] is Map ? 
              (responseData['errors'].values.first?.first) : 
              null);
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
