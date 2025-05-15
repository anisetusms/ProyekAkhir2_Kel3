import 'dart:developer' as developer;
import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart';

class BookingRoom {
  final int? id;
  final int? bookingId;
  final int? roomId;
  final double price;
  final Map<String, dynamic>? room;

  BookingRoom({
    required this.id,
    required this.bookingId,
    required this.roomId,
    required this.price,
    this.room,
  });

  factory BookingRoom.fromJson(Map<String, dynamic> json) {
    // Pastikan konversi tipe data yang benar
    int? parseId(dynamic value) {
      if (value == null) return null;
      if (value is int) return value;
      if (value is String) return int.tryParse(value);
      return null;
    }

    double parsePrice(dynamic value) {
      if (value == null) return 0.0;
      if (value is double) return value;
      if (value is int) return value.toDouble();
      if (value is String) return double.tryParse(value) ?? 0.0;
      return 0.0;
    }

    // Pastikan room adalah Map<String, dynamic> jika ada
    Map<String, dynamic>? roomData;
    if (json['room'] != null) {
      if (json['room'] is Map) {
        roomData = {};
        (json['room'] as Map).forEach((key, value) {
          if (key is String) {
            roomData![key] = value;
          }
        });
      }
    }

    return BookingRoom(
      id: parseId(json['id']),
      bookingId: parseId(json['booking_id']),
      roomId: parseId(json['room_id']),
      price: parsePrice(json['price']),
      room: roomData,
    );
  }
}

class Booking {
  final int? id;
  final int? propertyId;
  final int? userId;
  final bool isForOthers;
  final DateTime checkIn;
  final DateTime checkOut;
  final double totalPrice;
  final String status;
  final String? paymentProof;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? guestName;
  final String? guestPhone;
  final String? ktpImage;
  final String identityNumber;
  final String? bookingGroup;
  final String? specialRequests;
  final int? customerId;
  final String? propertyName;
  final String? propertyImage;
  final String? propertyAddress;
  final bool isKost;
  final bool isHomestay;
  final List<BookingRoom>? bookingRooms;

  Booking({
    required this.id,
    required this.propertyId,
    required this.userId,
    required this.isForOthers,
    required this.checkIn,
    required this.checkOut,
    required this.totalPrice,
    required this.status,
    required this.paymentProof,
    required this.createdAt,
    required this.updatedAt,
    required this.guestName,
    required this.guestPhone,
    required this.ktpImage,
    required this.identityNumber,
    required this.bookingGroup,
    required this.specialRequests,
    required this.customerId,
    required this.propertyName,
    required this.propertyImage,
    required this.propertyAddress,
    required this.isKost,
    required this.isHomestay,
    this.bookingRooms,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
  try {
    // Log untuk debugging
    developer.log('Parsing booking JSON: ${json.keys}', name: 'BookingModel');

    // Fungsi helper untuk parsing ID dan angka
    int? parseId(dynamic value) {
      if (value == null) return null;
      if (value is int) return value;
      if (value is String) {
        try {
          return int.tryParse(value);
        } catch (e) {
          developer.log('Error parsing ID from string: $e', name: 'BookingModel');
          return null;
        }
      }
      return null;
    }

    double parsePrice(dynamic value) {
      if (value == null) return 0.0;
      if (value is double) return value;
      if (value is int) return value.toDouble();
      if (value is String) {
        try {
          return double.tryParse(value) ?? 0.0;
        } catch (e) {
          developer.log('Error parsing price from string: $e', name: 'BookingModel');
          return 0.0;
        }
      }
      return 0.0;
    }

    // Parsing ID dan propertyId dengan aman
    int? id = parseId(json['id']);
    int? propertyId = parseId(json['property_id']);
    int? userId = parseId(json['user_id']);
    int? customerId = parseId(json['customer_id']);

    // Parsing tanggal
    DateTime parseDate(dynamic dateStr) {
      if (dateStr == null) return DateTime.now();
      try {
        return DateTime.parse(dateStr.toString());
      } catch (e) {
        developer.log('Error parsing date: $e', name: 'BookingModel');
        return DateTime.now();
      }
    }

    // Parsing property data
    Map<String, dynamic>? propertyData;
    String? propertyName;
    String? propertyImage;
    String? propertyAddress;
    bool isKost = false;
    bool isHomestay = false;

    if (json['property'] != null) {
      if (json['property'] is Map) {
        propertyData = {};
        (json['property'] as Map).forEach((key, value) {
          if (key is String) {
            propertyData![key] = value;
          }
        });
        
        propertyName = propertyData['name']?.toString();
        propertyImage = propertyData['image']?.toString();
        propertyAddress = propertyData['address']?.toString();

        // Determine property type
        int? propertyTypeId = parseId(propertyData['property_type_id']);
        isKost = propertyTypeId == 1; // Assuming 1 is Kost
        isHomestay = propertyTypeId == 2; // Assuming 2 is Homestay
      }
    }

    // Parse booking rooms if available
    List<BookingRoom>? bookingRooms;
    if (json['rooms'] != null && json['rooms'] is List) {
      try {
        bookingRooms = [];
        for (var roomJson in json['rooms']) {
          // Ensure roomJson is Map<String, dynamic>
          if (roomJson is Map) {
            Map<String, dynamic> roomMap = {};
            roomJson.forEach((key, value) {
              if (key is String) {
                roomMap[key] = value;
              }
            });
            bookingRooms.add(BookingRoom.fromJson(roomMap));
          }
        }
      } catch (e) {
        developer.log('Error parsing booking rooms: $e', name: 'BookingModel');
        // Continue without rooms if there's an error
        bookingRooms = [];
      }
    }

    // Parse boolean values
    bool isForOthers = false;
    if (json['is_for_others'] != null) {
      if (json['is_for_others'] is bool) {
        isForOthers = json['is_for_others'];
      } else if (json['is_for_others'] is int) {
        isForOthers = json['is_for_others'] == 1;
      } else if (json['is_for_others'] is String) {
        isForOthers = json['is_for_others'] == '1' || json['is_for_others'].toLowerCase() == 'true';
      }
    }

    // Parse total price with extra safety
    double totalPrice = 0.0;
    try {
      totalPrice = parsePrice(json['total_price']);
    } catch (e) {
      developer.log('Error parsing total_price: $e', name: 'BookingModel');
    }

    // Create and return the Booking object
    return Booking(
      id: id,
      propertyId: propertyId,
      userId: userId,
      isForOthers: isForOthers,
      checkIn: parseDate(json['check_in']),
      checkOut: parseDate(json['check_out']),
      totalPrice: totalPrice,
      status: json['status']?.toString() ?? '',
      paymentProof: json['payment_proof']?.toString(),
      createdAt: parseDate(json['created_at']),
      updatedAt: parseDate(json['updated_at']),
      guestName: json['guest_name']?.toString(),
      guestPhone: json['guest_phone']?.toString(),
      ktpImage: json['ktp_image']?.toString(),
      identityNumber: json['identity_number']?.toString() ?? '',
      bookingGroup: json['booking_group']?.toString(),
      specialRequests: json['special_requests']?.toString(),
      customerId: customerId,
      propertyName: propertyName,
      propertyImage: propertyImage,
      propertyAddress: propertyAddress,
      isKost: isKost,
      isHomestay: isHomestay,
      bookingRooms: bookingRooms ?? [],
    );
  } catch (e) {
    developer.log('Error parsing booking JSON: $e', name: 'BookingModel');
    rethrow;
  }
}
}
