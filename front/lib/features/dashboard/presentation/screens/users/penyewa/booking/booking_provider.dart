// providers/booking_provider.dart
import 'package:flutter/foundation.dart';
import 'package:front/features/dashboard/presentation/screens/users/penyewa/models/booking_model.dart';
import 'package:front/features/dashboard/presentation/screens/users/penyewa/service/booking_service.dart';
import 'dart:io';
class BookingProvider with ChangeNotifier {
  final BookingService _bookingService;
  List<Booking> _bookings = [];
  bool _isLoading = false;

  BookingProvider(this._bookingService);

  List<Booking> get bookings => _bookings;
  bool get isLoading => _isLoading;

  Future<void> loadUserBookings() async {
    _isLoading = true;
    notifyListeners();

    try {
      _bookings = await _bookingService.getUserBookings();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Booking> createBooking(Booking booking, File ktpImage) async {
    _isLoading = true;
    notifyListeners();

    try {
      final newBooking = await _bookingService.createBooking(booking, ktpImage);
      _bookings.insert(0, newBooking);
      return newBooking;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> cancelBooking(int bookingId) async {
    _isLoading = true;
    notifyListeners();

    try {
      final success = await _bookingService.cancelBooking(bookingId);
      // if (success) {
      //   final index = _bookings.indexWhere((b) => b.id == bookingId);
      //   if (index != -1) {
      //     _bookings[index] = _bookings[index].copyWith(status: 'cancelled');
      //   }
      // }
      return success;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}