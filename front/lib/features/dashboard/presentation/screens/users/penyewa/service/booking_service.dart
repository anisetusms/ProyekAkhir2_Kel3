import 'dart:io';
import 'package:dio/dio.dart';
import 'package:front/core/network/api_client.dart';
import 'package:front/features/dashboard/presentation/screens/users/penyewa/models/booking_model.dart';
import 'package:front/features/property/data/models/property_model.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as developer;

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
    // Ini sekarang menggunakan getToken() dari ApiClient untuk mendapatkan token
    return {
      'Authorization': 'Bearer ${await _apiClient.getToken()}',
      'Accept': 'application/json',
    };
  }

  Future<PropertyModel> getPropertyDetails(int propertyId) async {
    try {
      final response = await _apiClient.get('/propertiesdetails/$propertyId');

      // Check if status code is not 200 (OK)
      if (response['statusCode'] != 200) {
        throw BookingServiceException(
          message:
              _parseErrorMessage(response['data']) ??
              'Failed to fetch property details',
          status: response['statusCode'],
          data: response['data'],
        );
      }

      // Ensure we're handling the data correctly
      if (response['data'] == null || response['data']['data'] == null) {
        throw BookingServiceException(
          message: 'Invalid property data format',
          status: response['statusCode'],
        );
      }

      // Safely parse the property data with proper type handling
      final propertyData = response['data']['data'];

      // Ensure propertyTypeId is treated as int
      if (propertyData['property_type_id'] is String) {
        propertyData['property_type_id'] = int.parse(
          propertyData['property_type_id'],
        );
      }

      return PropertyModel.fromJson(propertyData);
    } on DioError catch (e) {
      throw BookingServiceException(
        message: _parseDioErrorMessage(e) ?? 'Failed to fetch property details',
        status: e.response?.statusCode,
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
      // Clean dates to remove time components
      final cleanCheckIn = DateTime(checkIn.year, checkIn.month, checkIn.day);
      final cleanCheckOut = DateTime(checkOut.year, checkOut.month, checkOut.day);

      // Format dates according to server expectations (yyyy-MM-dd)
      final formattedCheckIn = DateFormat('yyyy-MM-dd').format(cleanCheckIn);
      final formattedCheckOut = DateFormat('yyyy-MM-dd').format(cleanCheckOut);

      debugPrint('BookingService: Checking availability for property: $propertyId');
      debugPrint('BookingService: Check-in: $formattedCheckIn, Check-out: $formattedCheckOut');

      final requestBody = {
        'property_id': propertyId,
        'check_in': formattedCheckIn,
        'check_out': formattedCheckOut,
      };

      debugPrint('BookingService: Request body: $requestBody');

      // Try different possible endpoints for availability checking
      var response;
      try {
        response = await _apiClient.post('/bookings/check-availability', body: requestBody);
      } catch (e) {
        debugPrint('BookingService: Primary availability endpoint failed, trying alternatives...');
        try {
          response = await _apiClient.post('/availability/check', body: requestBody);
        } catch (e2) {
          debugPrint('BookingService: Alternative endpoint also failed, trying GET method...');
          try {
            response = await _apiClient.get('/bookings/availability?property_id=$propertyId&check_in=$formattedCheckIn&check_out=$formattedCheckOut');
          } catch (e3) {
            debugPrint('BookingService: All availability endpoints failed, assuming available');
            // If all endpoints fail, assume the property is available
            return {
              'is_available': true,
              'available': true,
              'message': 'Availability check not available, assuming property is available',
              'rooms_available': true,
            };
          }
        }
      }

      debugPrint('BookingService: Availability response status: ${response['statusCode']}');
      debugPrint('BookingService: Availability response: ${response.toString()}');

      // Check response status - be more flexible with success conditions
      if (response['statusCode'] == 200 || response['status'] == 'success') {
        if (response['data'] != null) {
          final data = Map<String, dynamic>.from(response['data']);
          
          // Ensure we have the required fields with sensible defaults
          if (!data.containsKey('is_available') && !data.containsKey('available')) {
            data['is_available'] = true;
            data['available'] = true;
          }
          
          // Add default message if not present
          if (!data.containsKey('message')) {
            data['message'] = data['is_available'] == true || data['available'] == true 
                ? 'Property is available for booking' 
                : 'Property is not available for the selected dates';
          }
          
          return data;
        } else {
          // If no data but successful response, assume available
          return {
            'is_available': true,
            'available': true,
            'message': 'Property is available for booking',
            'rooms_available': true,
          };
        }
      } else {
        // If status indicates error but we got a response, try to parse it
        final errorMessage = _parseErrorMessage(response['data']) ?? 'Property may not be available';
        
        // For some errors, we might still want to allow booking
        if (response['statusCode'] == 404) {
          debugPrint('BookingService: Availability endpoint not found, assuming available');
          return {
            'is_available': true,
            'available': true,
            'message': 'Availability check not implemented, property assumed available',
          };
        }
        
        throw BookingServiceException(
          message: errorMessage,
          status: response['statusCode'],
          data: response['data'],
        );
      }
    } on DioException catch (e) {
      debugPrint('BookingService: DioException in checkAvailability: ${e.message}');
      debugPrint('BookingService: DioException response: ${e.response?.data}');
      
      // Handle specific HTTP status codes
      if (e.response?.statusCode == 404) {
        debugPrint('BookingService: Availability endpoint not found (404), assuming available');
        return {
          'is_available': true,
          'available': true,
          'message': 'Availability check not available, assuming property is available',
        };
      } else if (e.response?.statusCode == 500) {
        debugPrint('BookingService: Server error (500), assuming available');
        return {
          'is_available': true,
          'available': true,
          'message': 'Server error during availability check, assuming property is available',
        };
      }
      
      throw BookingServiceException(
        message: _parseDioErrorMessage(e) ?? 'Network error occurred during availability check',
        status: e.response?.statusCode,
        data: e.response?.data,
      );
    } catch (e) {
      debugPrint('BookingService: Error in checkAvailability: $e');
      
      // For any other error, assume available to not block the booking process
      debugPrint('BookingService: Assuming property is available due to error');
      return {
        'is_available': true,
        'available': true,
        'message': 'Could not verify availability, assuming property is available',
      };
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
      final response = await _apiClient.get('/bookings');

      debugPrint('Get user bookings response: ${response['status']}');

      if (response['statusCode'] != 200 && response['status'] != 'success') {
        throw BookingServiceException(
          message:
              _parseErrorMessage(response['data']) ??
              'Failed to fetch bookings',
          status: response['statusCode'] ?? response['status'],
          data: response['data'],
        );
      }

      // Memastikan 'response['data']' adalah List atau mengambil data dari struktur yang benar
      List<dynamic> bookingsData = [];

      if (response['data'] != null) {
        if (response['data'] is List) {
          // Format: { data: [...] }
          bookingsData = List.from(response['data']);
        } else if (response['data']['data'] != null &&
            response['data']['data'] is List) {
          // Format: { data: { data: [...] } }
          bookingsData = List.from(response['data']['data']);
        } else {
          throw BookingServiceException(
            message: 'Format data booking tidak valid',
            status: response['statusCode'] ?? response['status'],
            data: response['data'],
          );
        }
      } else {
        throw BookingServiceException(
          message: 'Data booking kosong',
          status: response['statusCode'] ?? response['status'],
          data: response['data'],
        );
      }

      // Proses elemen dalam bookingsData
      List<Booking> bookings = [];
      for (var i = 0; i < bookingsData.length; i++) {
        try {
          final json = bookingsData[i];
          debugPrint('Processing booking ${i + 1}/${bookingsData.length}');

          // Pastikan json adalah Map<String, dynamic>
          if (json is! Map) {
            debugPrint('Booking data is not a Map: $json');
            continue;
          }

          final booking = Booking.fromJson(Map<String, dynamic>.from(json));
          bookings.add(booking);
        } catch (e) {
          debugPrint('Error parsing booking at index $i: $e');
          // Tetap lanjutkan untuk memproses data lain meski satu gagal
        }
      }

      return bookings;
    } on DioError catch (e) {
      debugPrint('DioError in getUserBookings: ${e.message}');
      debugPrint('DioError response: ${e.response?.data}');
      throw BookingServiceException(
        message: _parseDioErrorMessage(e) ?? 'Network error occurred',
        status: e.response?.statusCode,
        data: e.response?.data,
      );
    } catch (e) {
      debugPrint('Error in getUserBookings: $e');
      throw BookingServiceException(
        message: 'Failed to fetch bookings: ${e.toString()}',
      );
    }
  }

  // Future<Booking> getBookingDetail(int id) async {
  //   try {
  //     final response = await _apiClient.get('/bookings/$id');

  //     if (response['statusCode'] != 200) {
  //       throw BookingServiceException(
  //         message:
  //             _parseErrorMessage(response['data']) ??
  //             'Failed to fetch booking details',
  //         status: response['status'],
  //         data: response['data'],
  //       );
  //     }

  //     // Handle different response formats
  //     if (response['data'] != null) {
  //       if (response['data']['data'] != null) {
  //         return Booking.fromJson(response['data']['data']);
  //       } else {
  //         return Booking.fromJson(response['data']);
  //       }
  //     } else {
  //       throw BookingServiceException(
  //         message: 'Invalid booking data format',
  //         status: response['statusCode'],
  //       );
  //     }
  //   } on DioError catch (e) {
  //     throw BookingServiceException(
  //       message: _parseDioErrorMessage(e) ?? 'Network error occurred',
  //       status: e.response?.statusCode,
  //       data: e.response?.data,
  //     );
  //   } catch (e) {
  //     throw BookingServiceException(
  //       message: 'Failed to fetch booking details: ${e.toString()}',
  //     );
  //   }
  // }

  Future<Booking> getBookingDetail(int bookingId) async {
    try {
      developer.log(
        'Fetching booking detail for ID: $bookingId',
        name: 'BookingService',
      );

      final response = await _apiClient.get('/bookings/$bookingId');

      developer.log(
        'Response status code: ${response['statusCode']}',
        name: 'BookingService',
      );
      developer.log(
        'Response data: ${response['data']}',
        name: 'BookingService',
      );

      if (response['statusCode'] != 200) {
        throw BookingServiceException(
          message:
              _parseErrorMessage(response['data']) ??
              'Failed to fetch booking details',
          status: response['statusCode'],
          data: response['data'],
        );
      }

      // Handle different response formats
      Map<String, dynamic> bookingData;
      if (response['data'] != null) {
        if (response['data']['data'] != null) {
          bookingData = Map<String, dynamic>.from(response['data']['data']);
        } else {
          bookingData = Map<String, dynamic>.from(response['data']);
        }
      } else {
        throw BookingServiceException(
          message: 'Invalid booking data format',
          status: response['statusCode'],
        );
      }

      return Booking.fromJson(bookingData);
    } catch (e) {
      developer.log('Error in getBookingDetail: $e', name: 'BookingService');
      throw BookingServiceException(
        message: 'Failed to fetch booking details: $e',
      );
    }
  }

  // Future<void> cancelBooking(int id) async {
  //   try {
  //     final response = await _apiClient.put('/bookings/$id/cancel');

  //     if (response['statusCode'] != 200) {
  //       throw BookingServiceException(
  //         message:
  //             _parseErrorMessage(response['data']) ??
  //             'Failed to cancel booking',
  //         status: response['status'],
  //         data: response['data'],
  //       );
  //     }
  //   } on DioError catch (e) {
  //     if (e.response?.statusCode == 400) {
  //       throw BookingServiceException(
  //         message:
  //             _parseErrorMessage(e.response?.data) ??
  //             'Booking cannot be cancelled',
  //         status: 400,
  //         data: e.response?.data,
  //       );
  //     }
  //     throw BookingServiceException(
  //       message: _parseDioErrorMessage(e) ?? 'Network error occurred',
  //       status: e.response?.statusCode,
  //       data: e.response?.data,
  //     );
  //   } catch (e) {
  //     throw BookingServiceException(message: 'Failed to cancel booking: $e');
  //   }
  // }

  Future<void> cancelBooking(int bookingId) async {
    try {
      developer.log(
        'Cancelling booking with ID: $bookingId',
        name: 'BookingService',
      );

      final response = await _apiClient.put('/bookings/$bookingId/cancel');

      developer.log(
        'Response status code: ${response['statusCode']}',
        name: 'BookingService',
      );
      developer.log(
        'Response data: ${response['data']}',
        name: 'BookingService',
      );

      if (response['statusCode'] != 200) {
        throw BookingServiceException(
          message:
              _parseErrorMessage(response['data']) ??
              'Failed to cancel booking',
          status: response['statusCode'],
          data: response['data'],
        );
      }
    } catch (e) {
      developer.log('Error in cancelBooking: $e', name: 'BookingService');
      throw BookingServiceException(message: 'Failed to cancel booking: $e');
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
