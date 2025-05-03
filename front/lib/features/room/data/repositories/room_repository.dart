import 'package:front/core/network/api_client.dart';
import 'package:front/core/utils/constants.dart';
import 'package:front/features/room/data/models/room_model.dart';
import 'package:flutter/foundation.dart';

class RoomRepository {
  final ApiClient _apiClient = ApiClient();

  Future<List<Room>> getRoomsByPropertyId(int propertyId) async {
    try {
      final response = await _apiClient.get('/properties/$propertyId/rooms');

      if (response['success'] == true) {
        final roomsData = response['data']['data'] as List;
        return roomsData.map((roomJson) => Room.fromJson(roomJson)).toList();
      } else {
        throw Exception(response['message'] ?? 'Failed to load rooms');
      }
    } catch (e) {
      debugPrint('Error fetching rooms: $e');
      throw Exception('Failed to load rooms');
    }
  }

  Future<Room?> getRoomById(int roomId) async {
    try {
      final response = await _apiClient.get(
        '${Constants.baseUrl}/rooms/$roomId',
      );
      if (response != null && response['data'] is Map<String, dynamic>) {
        return Room.fromJson(response['data']);
      }
      return null;
    } catch (e) {
      print('Error fetching room by ID: $e');
      return null; // Return null on error, or handle differently
    }
  }

  Future<Room?> addRoom(Room room) async {
    try {
      final response = await _apiClient.post(
        '${Constants.baseUrl}/properties/${room.propertyId}/rooms',
        body:
            room.toJsonWithoutFacilities(), // Gunakan method toJsonWithoutFacilities
      );
      if (response != null) {
        if (response['success'] == true &&
            response['data'] is Map<String, dynamic>) {
          return Room.fromJson(response['data']);
        } else {
          throw Exception(
            response['message'] ?? 'Gagal menambahkan kamar dari server',
          );
        }
      }
      return null;
    } catch (e) {
      debugPrint('Error adding room: $e');
      throw e; // Re-throw error untuk ditangani di UI
    }
  }

  Future<Room?> updateRoom(Room room) async {
    try {
      final response = await _apiClient.post(
        // Menggunakan POST sesuai route
        '${Constants.baseUrl}/properties/${room.propertyId}/rooms/${room.id}',
        body: room.toJsonWithoutFacilities(), // Juga update tanpa fasilitas
      );
      if (response != null && response['data'] is Map<String, dynamic>) {
        return Room.fromJson(response['data']);
      }
      return null;
    } catch (e) {
      print('Error updating room: $e');
      return null; // Return null on error, or handle differently
    }
  }

  Future<bool> deleteRoom(int roomId, int propertyId) async {
    try {
      final response = await _apiClient.delete(
        '${Constants.baseUrl}/properties/$propertyId/rooms/$roomId',
      );
      return response != null && response['success'] == true;
    } catch (e) {
      print('Error deleting room: $e');
      return false; // Return false on error, or handle differently
    }
  }

  Future<List<RoomFacility>> getRoomFacilities(int roomId) async {
    try {
      final response = await _apiClient.get(
        '${Constants.baseUrl}/rooms/$roomId/facilities',
      );
      if (response != null && response['data'] is List) {
        return (response['data'] as List)
            .map((json) => RoomFacility.fromJson(json as Map<String, dynamic>))
            .toList();
      }
      return [];
    } catch (e) {
      print('Error fetching room facilities: $e');
      return [];
    }
  }

  Future<RoomFacility?> addRoomFacility(
    int roomId,
    String facilityName, {
    required int propertyId,
  }) async {
    try {
      final response = await _apiClient.post(
        '${Constants.baseUrl}/properties/$propertyId/rooms/$roomId/facilities',
        body: {'facility_name': facilityName},
      );
      if (response != null && response['data'] is Map<String, dynamic>) {
        return RoomFacility.fromJson(response['data']);
      }
      return null;
    } catch (e) {
      print('Error adding room facility: $e');
      return null;
    }
  }

  Future<bool> deleteRoomFacility(int facilityId) async {
    try {
      final response = await _apiClient.delete(
        '${Constants.baseUrl}/rooms/facilities/$facilityId',
      );
      return response != null && response['success'] == true;
    } catch (e) {
      print('Error deleting room facility: $e');
      return false;
    }
  }
}

// Tambahkan method toJsonWithoutFacilities pada model Room
extension RoomToJsonWithoutFacilities on Room {
  Map<String, dynamic> toJsonWithoutFacilities() {
    return {
      'property_id': propertyId,
      'room_type': roomType,
      'room_number': roomNumber,
      'price': price,
      'size': size,
      'capacity': capacity,
      'is_available': isAvailable,
      'description': description,
    };
  }
}
