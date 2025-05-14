import 'dart:convert';
import 'package:front/core/network/api_client.dart';
import 'package:front/features/property/data/models/admin_booking_model.dart';
import 'package:flutter/material.dart';

class AdminBookingRepository {
  final ApiClient _apiClient;
  
  AdminBookingRepository({ApiClient? apiClient}) 
      : _apiClient = apiClient ?? ApiClient();
  
  // Get all bookings for properties owned by the authenticated user
  Future<Map<String, dynamic>> getBookings({
    String? status,
    int? propertyId,
    int page = 1,
  }) async {
    try {
      Map<String, dynamic> queryParams = {
        'page': page.toString(),
      };
      
      if (status != null) {
        queryParams['status'] = status;
      }
      
      if (propertyId != null) {
        queryParams['property_id'] = propertyId.toString();
      }
      
      final response = await _apiClient.get(
        'admin/bookings',
        queryParameters: queryParams,
      );
      
      final List<AdminBooking> bookings = (response['data'] as List)
          .map((booking) => AdminBooking.fromJson(booking))
          .toList();
      
      return {
        'bookings': bookings,
        'meta': response['meta'],
      };
    } catch (e) {
      debugPrint('Error getting admin bookings: $e');
      rethrow;
    }
  }
  
  // Get booking details
  Future<AdminBooking> getBookingDetail(int id) async {
    try {
      final response = await _apiClient.get('admin/bookings/$id');
      return AdminBooking.fromJson(response['data']);
    } catch (e) {
      debugPrint('Error getting admin booking detail: $e');
      rethrow;
    }
  }
  
  // Update booking status
  Future<AdminBooking> updateBookingStatus(int id, String status, {String? notes}) async {
    try {
      final Map<String, dynamic> data = {
        'status': status,
      };
      
      if (notes != null && notes.isNotEmpty) {
        data['notes'] = notes;
      }
      
      final response = await _apiClient.put('admin/bookings/$id/status', data: data);
      return AdminBooking.fromJson(response['data']);
    } catch (e) {
      debugPrint('Error updating admin booking status: $e');
      rethrow;
    }
  }
  
  // Get booking statistics
  Future<Map<String, dynamic>> getBookingStatistics() async {
    try {
      final response = await _apiClient.get('admin/bookings/statistics');
      return response['data'];
    } catch (e) {
      debugPrint('Error getting admin booking statistics: $e');
      rethrow;
    }
  }
}
