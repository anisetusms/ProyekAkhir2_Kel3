// models/booking.dart
import 'package:intl/intl.dart';

class Booking {
  final int? id;
  final int propertyId;
  final int? roomId;  // Changed from roomIds to roomId (single ID)
  final DateTime checkIn;
  final DateTime checkOut;
  final bool isForOthers;
  final String? guestName;
  final String? guestPhone;
  final String ktpImagePath;
  final String identityNumber;
  final String? specialRequests;
  final double totalPrice;
  final String status;
  final String? bookingGroup;

  Booking({
    this.id,
    required this.propertyId,
    this.roomId,  // Now accepts single room ID
    required this.checkIn,
    required this.checkOut,
    required this.isForOthers,
    this.guestName,
    this.guestPhone,
    required this.ktpImagePath,
    required this.identityNumber,
    this.specialRequests,
    required this.totalPrice,
    this.status = 'pending',
    this.bookingGroup,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'],
      propertyId: json['property_id'],
      roomId: json['room_id'] ??  // Handle both single ID and array response
          (json['rooms'] != null && json['rooms'].isNotEmpty 
              ? json['rooms'][0]['id'] 
              : null),
      checkIn: DateTime.parse(json['check_in']),
      checkOut: DateTime.parse(json['check_out']),
      isForOthers: json['is_for_others'] ?? true,
      guestName: json['guest_name'],
      guestPhone: json['guest_phone'],
      ktpImagePath: json['ktp_image'] ?? '',
      identityNumber: json['identity_number'] ?? '',
      specialRequests: json['special_requests'],
      totalPrice: double.parse(json['total_price'].toString()),
      status: json['status'] ?? 'pending',
      bookingGroup: json['booking_group'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'property_id': propertyId,
      'room_id': roomId,  // Send single ID
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
    int? roomId,  // Changed parameter type
    DateTime? checkIn,
    DateTime? checkOut,
    bool? isForOthers,
    String? guestName,
    String? guestPhone,
    String? ktpImagePath,
    String? identityNumber,
    String? specialRequests,
    double? totalPrice,
    String? status,
    String? bookingGroup,
  }) {
    return Booking(
      id: id ?? this.id,
      propertyId: propertyId ?? this.propertyId,
      roomId: roomId ?? this.roomId,  // Now uses single ID
      checkIn: checkIn ?? this.checkIn,
      checkOut: checkOut ?? this.checkOut,
      isForOthers: isForOthers ?? this.isForOthers,
      guestName: guestName ?? this.guestName,
      guestPhone: guestPhone ?? this.guestPhone,
      ktpImagePath: ktpImagePath ?? this.ktpImagePath,
      identityNumber: identityNumber ?? this.identityNumber,
      specialRequests: specialRequests ?? this.specialRequests,
      totalPrice: totalPrice ?? this.totalPrice,
      status: status ?? this.status,
      bookingGroup: bookingGroup ?? this.bookingGroup,
    );
  }
}