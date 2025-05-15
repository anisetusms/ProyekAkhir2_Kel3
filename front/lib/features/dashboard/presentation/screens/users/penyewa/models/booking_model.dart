import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart';

class BookingRoom {
  final int id;
  final int bookingId;
  final int roomId;
  final double price;
  final int? customerId;
  final Map<String, dynamic>? room;

  BookingRoom({
    required this.id,
    required this.bookingId,
    required this.roomId,
    required this.price,
    this.customerId,
    this.room,
  });

  factory BookingRoom.fromJson(Map<String, dynamic> json) {
    return BookingRoom(
      id: json['id'] is String ? int.parse(json['id']) : json['id'] ?? 0,
      bookingId: json['booking_id'] is String ? int.parse(json['booking_id']) : json['booking_id'] ?? 0,
      roomId: json['room_id'] is String ? int.parse(json['room_id']) : json['room_id'] ?? 0,
      price: double.tryParse(json['price'].toString()) ?? 0.0,
      customerId: json['customer_id'] is String ? int.tryParse(json['customer_id']) : json['customer_id'],
      room: json['room'] is Map<String, dynamic> ? json['room'] : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'booking_id': bookingId,
      'room_id': roomId,
      'price': price,
      'customer_id': customerId,
      'room': room,
    };
  }
}

class Booking {
  final int? id;
  final int propertyId;
  final List<int>? roomIds;
  final DateTime checkIn;
  final DateTime checkOut;
  final bool isForOthers;
  final String? guestName;
  final String? guestPhone;
  final String? ktpImage;
  final String identityNumber;
  final String? specialRequests;
  final double totalPrice;
  final String status;
  final String? bookingGroup;
  final DateTime createdAt;
  final DateTime updatedAt;

  final String? propertyName;
  final String? propertyAddress;
  final String? propertyImage;
  final int? propertyTypeId;

  final List<BookingRoom>? bookingRooms;

  Booking({
    this.id,
    required this.propertyId,
    this.roomIds,
    required this.checkIn,
    required this.checkOut,
    required this.isForOthers,
    this.guestName,
    this.guestPhone,
    this.ktpImage,
    required this.identityNumber,
    this.specialRequests,
    required this.totalPrice,
    this.status = 'pending',
    this.bookingGroup,
    this.propertyName,
    this.propertyAddress,
    this.propertyImage,
    this.propertyTypeId,
    this.bookingRooms,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  bool get isHomestay => propertyTypeId == 2;
  bool get isKost => propertyTypeId == 1;

  factory Booking.fromJson(Map<String, dynamic> json) {
    debugPrint('Parsing booking from JSON: ${json.keys}');

    // Safely parse ID - handle both String and int types
    int? id;
    if (json['id'] != null) {
      id = json['id'] is String ? int.tryParse(json['id']) : json['id'];
    }

    // Safely parse property_id - handle both String and int types
    int propertyId = 0;
    if (json['property_id'] != null) {
      propertyId = json['property_id'] is String 
          ? int.tryParse(json['property_id'].toString()) ?? 0 
          : json['property_id'] ?? 0;
    }

    List<BookingRoom>? bookingRooms;
    if (json['rooms'] != null && json['rooms'] is List) {
      try {
        bookingRooms = (json['rooms'] as List)
            .map((room) {
              if (room is Map) {
                // Konversi Map<dynamic, dynamic> ke Map<String, dynamic>
                final Map<String, dynamic> roomMap = {};
                room.forEach((key, value) {
                  if (key is String) {
                    roomMap[key] = value;
                  }
                });
                return BookingRoom.fromJson(roomMap);
              } else {
                return BookingRoom.fromJson(Map<String, dynamic>.from(room));
              }
            })
            .toList();
      } catch (e) {
        debugPrint('Error parsing booking rooms: $e');
        bookingRooms = [];
      }
    }

    List<int>? roomIds;
    if (bookingRooms != null && bookingRooms.isNotEmpty) {
      roomIds = bookingRooms.map((br) => br.roomId).toList();
    } else if (json['room_ids'] != null && json['room_ids'] is List) {
      roomIds = (json['room_ids'] as List)
          .map((id) => id is String ? int.tryParse(id) ?? 0 : id as int)
          .toList();
    }

    final property = json['property'];
    String? propertyName = property?['name'];
    String? propertyAddress = property?['address'];
    String? propertyImage = property?['image'];
    
    // Safely parse property_type_id - handle both String and int types
    int? propertyTypeId;
    if (property != null && property['property_type_id'] != null) {
      propertyTypeId = property['property_type_id'] is String
          ? int.tryParse(property['property_type_id']) ?? 0
          : property['property_type_id'];
    }

    DateTime parseDate(dynamic dateStr) {
      if (dateStr == null) return DateTime.now();
      try {
        return DateTime.parse(dateStr.toString());
      } catch (e) {
        debugPrint('Error parsing date: $e');
        return DateTime.now();
      }
    }

    // Safely parse is_for_others - handle different types
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

    // Safely parse total_price - handle different types
    double totalPrice = 0.0;
    if (json['total_price'] != null) {
      totalPrice = double.tryParse(json['total_price'].toString()) ?? 0.0;
    }

    return Booking(
      id: id,
      propertyId: propertyId,
      roomIds: roomIds,
      checkIn: parseDate(json['check_in']),
      checkOut: parseDate(json['check_out']),
      isForOthers: isForOthers,
      guestName: json['guest_name'],
      guestPhone: json['guest_phone'],
      ktpImage: json['ktp_image'],
      identityNumber: json['identity_number'] ?? '',
      specialRequests: json['special_requests'],
      totalPrice: totalPrice,
      status: json['status'] ?? 'pending',
      bookingGroup: json['booking_group'],
      propertyName: propertyName,
      propertyAddress: propertyAddress,
      propertyImage: propertyImage,
      propertyTypeId: propertyTypeId,
      bookingRooms: bookingRooms,
      createdAt: parseDate(json['created_at']),
      updatedAt: parseDate(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'property_id': propertyId,
      'room_ids': roomIds,
      'check_in': DateFormat('yyyy-MM-dd').format(checkIn),
      'check_out': DateFormat('yyyy-MM-dd').format(checkOut),
      'is_for_others': isForOthers,
      'guest_name': guestName,
      'guest_phone': guestPhone,
      'identity_number': identityNumber,
      'special_requests': specialRequests,
      'booking_group': bookingGroup,
    };
  }

  Booking copyWith({
    int? id,
    int? propertyId,
    List<int>? roomIds,
    DateTime? checkIn,
    DateTime? checkOut,
    bool? isForOthers,
    String? guestName,
    String? guestPhone,
    String? ktpImage,
    String? identityNumber,
    String? specialRequests,
    double? totalPrice,
    String? status,
    String? bookingGroup,
    String? propertyName,
    String? propertyAddress,
    String? propertyImage,
    int? propertyTypeId,
    List<BookingRoom>? bookingRooms,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Booking(
      id: id ?? this.id,
      propertyId: propertyId ?? this.propertyId,
      roomIds: roomIds ?? this.roomIds,
      checkIn: checkIn ?? this.checkIn,
      checkOut: checkOut ?? this.checkOut,
      isForOthers: isForOthers ?? this.isForOthers,
      guestName: guestName ?? this.guestName,
      guestPhone: guestPhone ?? this.guestPhone,
      ktpImage: ktpImage ?? this.ktpImage,
      identityNumber: identityNumber ?? this.identityNumber,
      specialRequests: specialRequests ?? this.specialRequests,
      totalPrice: totalPrice ?? this.totalPrice,
      status: status ?? this.status,
      bookingGroup: bookingGroup ?? this.bookingGroup,
      propertyName: propertyName ?? this.propertyName,
      propertyAddress: propertyAddress ?? this.propertyAddress,
      propertyImage: propertyImage ?? this.propertyImage,
      propertyTypeId: propertyTypeId ?? this.propertyTypeId,
      bookingRooms: bookingRooms ?? this.bookingRooms,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}