import 'package:equatable/equatable.dart';

class Room extends Equatable {
  final int id;
  final int propertyId;
  final String roomType;
  final String roomNumber;
  final num price;
  final String? size;
  final int? capacity;
  final bool isAvailable;
  final String? description;
  final List<RoomFacility>? facilities;

  const Room({
    required this.id,
    required this.propertyId,
    required this.roomType,
    required this.roomNumber,
    required this.price,
    this.size,
    this.capacity,
    required this.isAvailable,
    this.description,
    this.facilities,
  });

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      id: int.tryParse(json['id'].toString()) ?? 0,
      propertyId: int.tryParse(json['property_id'].toString()) ?? 0,
      roomType: json['room_type'] as String,
      roomNumber: json['room_number'] as String,
      price: num.tryParse(json['price'].toString()) ?? 0,
      size: json['size'] as String?,
      capacity: json['capacity'] != null ? int.tryParse(json['capacity'].toString()) : null,
      isAvailable: json['is_available'] as bool,
      description: json['description'] as String?,
      facilities: (json['facilities'] as List<dynamic>?)
          ?.map((e) => RoomFacility.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  @override
  List<Object?> get props => [id];
}

class RoomFacility extends Equatable {
  final int id;
  final int roomId;
  final String facilityName;

  const RoomFacility({
    required this.id,
    required this.roomId,
    required this.facilityName,
  });

  factory RoomFacility.fromJson(Map<String, dynamic> json) {
    return RoomFacility(
      id: json['id'] as int,
      roomId: json['room_id'] as int,
      facilityName: json['facility_name'] as String,
    );
  }

  @override
  List<Object?> get props => [id];
}