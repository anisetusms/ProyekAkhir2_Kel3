// lib/features/booking/data/repositories/booking_repository.dart


import 'package:front/features/dashboard/presentation/screens/users/penyewa/service/booking_service.dart';
import 'package:front/features/dashboard/presentation/screens/users/penyewa/models/booking_model.dart';
import 'package:front/features/dashboard/presentation/screens/users/penyewa/booking/exceptions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class BookingRepository {
  final BookingApiService _apiService;

  BookingRepository()
      : _apiService = BookingApiService(
          client: http.Client(),
          prefs: SharedPreferences.getInstance() as SharedPreferences,
        );

  Future<BookingModel> createBooking({
    required int propertyId,
    required String checkIn,
    required String checkOut,
    required bool isForOthers,
    required String identityNumber,
    required String ktpImagePath,
    List<int>? roomIds,
    String? guestName,
    String? guestPhone,
    String? specialRequests,
  }) async {
    try {
      return await _apiService.createBooking(
        propertyId: propertyId,
        checkIn: checkIn,
        checkOut: checkOut,
        isForOthers: isForOthers,
        identityNumber: identityNumber,
        ktpImagePath: ktpImagePath,
        roomIds: roomIds,
        guestName: guestName,
        guestPhone: guestPhone,
        specialRequests: specialRequests,
      );
    } on ApiException {
      rethrow;
    } catch (e) {
      throw RepositoryException('Gagal membuat booking: $e');
    }
  }

  Future<List<BookingModel>> getUserBookings() async {
    try {
      return await _apiService.getUserBookings();
    } on ApiException {
      rethrow;
    } catch (e) {
      throw RepositoryException('Gagal memuat data booking: $e');
    }
  }

  Future<BookingModel> getBookingDetail(String bookingId) async {
    try {
      return await _apiService.getBookingDetail(bookingId);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw RepositoryException('Gagal memuat detail booking: $e');
    }
  }

  Future<void> cancelBooking(String bookingId) async {
    try {
      await _apiService.cancelBooking(bookingId);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw RepositoryException('Gagal membatalkan booking: $e');
    }
  }
}