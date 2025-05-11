import 'dart:io';
import 'package:front/core/network/api_client.dart';
import 'package:front/features/dashboard/presentation/screens/users/penyewa/models/booking_model.dart';
import 'package:front/features/dashboard/presentation/screens/users/penyewa/service/booking_service.dart';
import 'package:front/features/property/data/models/property_model.dart';
import 'package:flutter/material.dart';

class BookingRepository {
  final BookingService _bookingService;
  
  BookingRepository({ApiClient? apiClient}) 
      : _bookingService = BookingService(apiClient ?? ApiClient());
  
  // Create a new booking
  Future<Booking> createBooking({
    required int propertyId,
    required List<int>? roomIds,
    required DateTime checkIn,
    required DateTime checkOut,
    required bool isForOthers,
    String? guestName,
    String? guestPhone,
    required File ktpImage,
    required String identityNumber,
    String? specialRequests,
  }) async {
    // Pastikan tanggal tidak memiliki komponen waktu
    final cleanCheckIn = DateTime(checkIn.year, checkIn.month, checkIn.day);
    final cleanCheckOut = DateTime(checkOut.year, checkOut.month, checkOut.day);
    
    // Debug log untuk melihat tanggal yang dikirim
    debugPrint('Repository: Creating booking with dates: ${cleanCheckIn.toString()} to ${cleanCheckOut.toString()}');
    
    // Validasi durasi sesuai dengan validasi server
    final days = cleanCheckOut.difference(cleanCheckIn).inDays;
    debugPrint('Repository: Calculated days: $days');
    
    if (days < 1) {
      throw Exception('Durasi minimal pemesanan adalah 1 hari');
    }
    
    return await _bookingService.createBooking(
      propertyId: propertyId,
      roomIds: roomIds,
      checkIn: cleanCheckIn,
      checkOut: cleanCheckOut,
      isForOthers: isForOthers,
      guestName: guestName,
      guestPhone: guestPhone,
      ktpImage: ktpImage,
      identityNumber: identityNumber,
      specialRequests: specialRequests,
    );
  }
  
  // Get all bookings for the current user
  Future<List<Booking>> getUserBookings() async {
    return await _bookingService.getUserBookings();
  }
  
  // Get details of a specific booking
  Future<Booking> getBookingDetail(int id) async {
    return await _bookingService.getBookingDetail(id);
  }
  
  // Cancel a booking
  Future<void> cancelBooking(int id) async {
    await _bookingService.cancelBooking(id);
  }
  
  // Check property availability
  Future<Map<String, dynamic>> checkAvailability(
    int propertyId, 
    DateTime checkIn, 
    DateTime checkOut
  ) async {
    // Pastikan tanggal tidak memiliki komponen waktu
    final cleanCheckIn = DateTime(checkIn.year, checkIn.month, checkIn.day);
    final cleanCheckOut = DateTime(checkOut.year, checkOut.month, checkOut.day);
    
    // Debug log untuk melihat tanggal yang dikirim
    debugPrint('Repository: Checking availability with dates: ${cleanCheckIn.toString()} to ${cleanCheckOut.toString()}');
    
    // Validasi durasi sesuai dengan validasi server
    final days = cleanCheckOut.difference(cleanCheckIn).inDays;
    debugPrint('Repository: Calculated days: $days');
    
    if (days < 1) {
      throw Exception('Durasi minimal pemesanan adalah 1 hari');
    }
    
    return await _bookingService.checkAvailability(
      propertyId: propertyId,
      checkIn: cleanCheckIn,
      checkOut: cleanCheckOut,
    );
  }
  
  // Get property details
  Future<PropertyModel> getPropertyDetails(int propertyId) async {
    return await _bookingService.getPropertyDetails(propertyId);
  }
}