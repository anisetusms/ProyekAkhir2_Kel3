// import 'package:front/features/property/data/models/property_model.dart';
// import 'package:front/features/room/data/models/room_model.dart';

// class AdminBooking {
//   final int id;
//   final int propertyId;
//   final int userId;
//   final bool isForOthers;
//   final DateTime checkIn;
//   final DateTime checkOut;
//   final double totalPrice;
//   final String status;
//   final String? paymentProof;
//   final DateTime? createdAt;
//   final DateTime? updatedAt;
//   final String? guestName;
//   final String? guestPhone;
//   final String? ktpImage;
//   final String? identityNumber;
//   final String? bookingGroup;
//   final String? specialRequests;
//   final String? rejectionReason;
//   final int? customerId;
  
//   // Relasi
//   final PropertyModel? property;
//   final List<AdminBookingRoom>? rooms;
//   final BookingUser? user;
//   final BookingCustomer? customer;

//   AdminBooking({
//     required this.id,
//     required this.propertyId,
//     required this.userId,
//     required this.isForOthers,
//     required this.checkIn,
//     required this.checkOut,
//     required this.totalPrice,
//     required this.status,
//     this.paymentProof,
//     this.createdAt,
//     this.updatedAt,
//     this.guestName,
//     this.guestPhone,
//     this.ktpImage,
//     this.identityNumber,
//     this.bookingGroup,
//     this.specialRequests,
//     this.rejectionReason,
//     this.customerId,
//     this.property,
//     this.rooms,
//     this.user,
//     this.customer,
//   });

//   factory AdminBooking.fromJson(Map<String, dynamic> json) {
//     return AdminBooking(
//       id: json['id'],
//       propertyId: json['property_id'],
//       userId: json['user_id'],
//       isForOthers: json['is_for_others'] == 1 || json['is_for_others'] == true,
//       checkIn: DateTime.parse(json['check_in']),
//       checkOut: DateTime.parse(json['check_out']),
//       totalPrice: double.parse(json['total_price'].toString()),
//       status: json['status'],
//       paymentProof: json['payment_proof'],
//       createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
//       updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
//       guestName: json['guest_name'],
//       guestPhone: json['guest_phone'],
//       ktpImage: json['ktp_image'],
//       identityNumber: json['identity_number'],
//       bookingGroup: json['booking_group'],
//       specialRequests: json['special_requests'],
//       rejectionReason: json['rejection_reason'],
//       customerId: json['customer_id'],
//       property: json['property'] != null ? PropertyModel.fromJson(json['property']) : null,
//       rooms: json['rooms'] != null 
//           ? List<AdminBookingRoom>.from(json['rooms'].map((room) => AdminBookingRoom.fromJson(room)))
//           : null,
//       user: json['user'] != null ? BookingUser.fromJson(json['user']) : null,
//       customer: json['customer'] != null ? BookingCustomer.fromJson(json['customer']) : null,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'property_id': propertyId,
//       'user_id': userId,
//       'is_for_others': isForOthers,
//       'check_in': checkIn.toIso8601String().split('T')[0],
//       'check_out': checkOut.toIso8601String().split('T')[0],
//       'total_price': totalPrice,
//       'status': status,
//       'payment_proof': paymentProof,
//       'created_at': createdAt?.toIso8601String(),
//       'updated_at': updatedAt?.toIso8601String(),
//       'guest_name': guestName,
//       'guest_phone': guestPhone,
//       'ktp_image': ktpImage,
//       'identity_number': identityNumber,
//       'booking_group': bookingGroup,
//       'special_requests': specialRequests,
//       'rejection_reason': rejectionReason,
//       'customer_id': customerId,
//       if (property != null) 'property': property!.toJson(),
//       if (rooms != null) 'rooms': rooms!.map((room) => room.toJson()).toList(),
//       if (user != null) 'user': user!.toJson(),
//       if (customer != null) 'customer': customer!.toJson(),
//     };
//   }

//   // Helper method untuk mendapatkan durasi booking dalam hari
//   int get durationInDays {
//     return checkOut.difference(checkIn).inDays;
//   }

//   // Helper method untuk mendapatkan status dalam bahasa Indonesia
//   String get statusInIndonesian {
//     switch (status) {
//       case 'pending':
//         return 'Menunggu Konfirmasi';
//       case 'confirmed':
//         return 'Dikonfirmasi';
//       case 'cancelled':
//         return 'Dibatalkan';
//       case 'completed':
//         return 'Selesai';
//       default:
//         return status;
//     }
//   }

//   // Helper method untuk mengecek apakah booking bisa dikonfirmasi
//   bool get canBeConfirmed {
//     return status == 'pending';
//   }

//   // Helper method untuk mengecek apakah booking bisa ditolak
//   bool get canBeRejected {
//     return status == 'pending';
//   }

//   // Helper method untuk mengecek apakah booking bisa diselesaikan
//   bool get canBeCompleted {
//     return status == 'confirmed';
//   }

//   // Helper method untuk mendapatkan warna status
//   int getStatusColor() {
//     switch (status) {
//       case 'pending':
//         return 0xFFFFA000; // Orange
//       case 'confirmed':
//         return 0xFF4CAF50; // Green
//       case 'cancelled':
//         return 0xFFF44336; // Red
//       case 'completed':
//         return 0xFF2196F3; // Blue
//       default:
//         return 0xFF9E9E9E; // Grey
//     }
//   }
// }

// class AdminBookingRoom {
//   final int id;
//   final int bookingId;
//   final int roomId;
//   final double price;
//   final DateTime? createdAt;
//   final DateTime? updatedAt;
  
//   // Relasi
//   final Room? room;

//   AdminBookingRoom({
//     required this.id,
//     required this.bookingId,
//     required this.roomId,
//     required this.price,
//     this.createdAt,
//     this.updatedAt,
//     this.room,
//   });

//   factory AdminBookingRoom.fromJson(Map<String, dynamic> json) {
//     return AdminBookingRoom(
//       id: json['id'],
//       bookingId: json['booking_id'],
//       roomId: json['room_id'],
//       price: double.parse(json['price'].toString()),
//       createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
//       updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
//       room: json['room'] != null ? Room.fromJson(json['room']) : null,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'booking_id': bookingId,
//       'room_id': roomId,
//       'price': price,
//       'created_at': createdAt?.toIso8601String(),
//       'updated_at': updatedAt?.toIso8601String(),
//       if (room != null) 'room': room!.toJson(),
//     };
//   }
// }

// class BookingUser {
//   final int id;
//   final String name;
//   final String email;
//   final String? phone;
//   final String? profilePicture;

//   BookingUser({
//     required this.id,
//     required this.name,
//     required this.email,
//     this.phone,
//     this.profilePicture,
//   });

//   factory BookingUser.fromJson(Map<String, dynamic> json) {
//     return BookingUser(
//       id: json['id'],
//       name: json['name'],
//       email: json['email'],
//       phone: json['phone'],
//       profilePicture: json['profile_picture'],
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'name': name,
//       'email': email,
//       'phone': phone,
//       'profile_picture': profilePicture,
//     };
//   }
// }

// class BookingCustomer {
//   final int id;
//   final String name;
//   final String phone;
//   final String identityNumber;
//   final DateTime? createdAt;
//   final DateTime? updatedAt;

//   BookingCustomer({
//     required this.id,
//     required this.name,
//     required this.phone,
//     required this.identityNumber,
//     this.createdAt,
//     this.updatedAt,
//   });

//   factory BookingCustomer.fromJson(Map<String, dynamic> json) {
//     return BookingCustomer(
//       id: json['id'],
//       name: json['name'],
//       phone: json['phone'],
//       identityNumber: json['identity_number'],
//       createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
//       updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'name': name,
//       'phone': phone,
//       'identity_number': identityNumber,
//       'created_at': createdAt?.toIso8601String(),
//       'updated_at': updatedAt?.toIso8601String(),
//     };
//   }
// }


import 'package:front/features/property/data/models/property_model.dart';
import 'package:front/features/room/data/models/room_model.dart';
import 'package:intl/intl.dart';

class AdminBooking {
  final int id;
  final int propertyId;
  final int userId;
  final bool isForOthers;
  final DateTime checkIn;
  final DateTime checkOut;
  final double totalPrice;
  final String status;
  final String? paymentProof;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? guestName;
  final String? guestPhone;
  final String? ktpImage;
  final String? identityNumber;
  final String? bookingGroup;
  final String? specialRequests;
  final String? adminNotes;
  final int? customerId;
  final PropertyModel? property;
  final List<Room>? rooms;
  final BookingCustomer? customer;
  final BookingUser? user;

  AdminBooking({
    required this.id,
    required this.propertyId,
    required this.userId,
    required this.isForOthers,
    required this.checkIn,
    required this.checkOut,
    required this.totalPrice,
    required this.status,
    this.paymentProof,
    this.createdAt,
    this.updatedAt,
    this.guestName,
    this.guestPhone,
    this.ktpImage,
    this.identityNumber,
    this.bookingGroup,
    this.specialRequests,
    this.adminNotes,
    this.customerId,
    this.property,
    this.rooms,
    this.customer,
    this.user,
  });

  factory AdminBooking.fromJson(Map<String, dynamic> json) {
    return AdminBooking(
      id: json['id'],
      propertyId: json['property_id'],
      userId: json['user_id'],
      isForOthers: json['is_for_others'] ?? false,
      checkIn: DateTime.parse(json['check_in']),
      checkOut: DateTime.parse(json['check_out']),
      totalPrice: double.parse(json['total_price'].toString()),
      status: json['status'],
      paymentProof: json['payment_proof'],
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
      guestName: json['guest_name'],
      guestPhone: json['guest_phone'],
      ktpImage: json['ktp_image'],
      identityNumber: json['identity_number'],
      bookingGroup: json['booking_group'],
      specialRequests: json['special_requests'],
      adminNotes: json['admin_notes'],
      customerId: json['customer_id'],
      property: json['property'] != null ? PropertyModel.fromJson(json['property']) : null,
      rooms: json['rooms'] != null 
          ? (json['rooms'] as List).map((room) => Room.fromJson(room)).toList() 
          : null,
      customer: json['customer'] != null ? BookingCustomer.fromJson(json['customer']) : null,
      user: json['user'] != null ? BookingUser.fromJson(json['user']) : null,
    );
  }

  // Helper methods
  int get durationInDays => checkOut.difference(checkIn).inDays;

  String get formattedCheckIn => DateFormat('dd MMM yyyy').format(checkIn);
  
  String get formattedCheckOut => DateFormat('dd MMM yyyy').format(checkOut);
  
  String get formattedCreatedAt => createdAt != null 
      ? DateFormat('dd MMM yyyy, HH:mm').format(createdAt!) 
      : 'N/A';

  String get formattedTotalPrice => NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp',
    decimalDigits: 0,
  ).format(totalPrice);

  String get statusInIndonesian {
    switch (status) {
      case 'pending':
        return 'Menunggu Konfirmasi';
      case 'confirmed':
        return 'Dikonfirmasi';
      case 'cancelled':
        return 'Dibatalkan';
      case 'completed':
        return 'Selesai';
      default:
        return status;
    }
  }

  Color getStatusColor() {
    switch (status) {
      case 'pending':
        return Colors.orange;
      case 'confirmed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      case 'completed':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }
}

class BookingCustomer {
  final int id;
  final String name;
  final String? phone;
  final String? identityNumber;

  BookingCustomer({
    required this.id,
    required this.name,
    this.phone,
    this.identityNumber,
  });

  factory BookingCustomer.fromJson(Map<String, dynamic> json) {
    return BookingCustomer(
      id: json['id'],
      name: json['name'],
      phone: json['phone'],
      identityNumber: json['identity_number'],
    );
  }
}

class BookingUser {
  final int id;
  final String name;
  final String email;
  final String? phone;

  BookingUser({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
  });

  factory BookingUser.fromJson(Map<String, dynamic> json) {
    return BookingUser(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
    );
  }
}
import 'package:flutter/material.dart';

