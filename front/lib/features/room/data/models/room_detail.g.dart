// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'room_detail.dart';

// ************************************************************************** 
// JsonSerializableGenerator
// ************************************************************************** 

RoomDetail _$RoomDetailFromJson(Map<String, dynamic> json) => RoomDetail(
      id: json['id'] as int,
      roomType: json['room_type'] as String? ?? 'Kamar', // Sesuaikan dengan nama field JSON
      roomNumber: json['room_number'] as String? ?? '',
      price: RoomDetail._priceFromJson(json['price']),
      size: json['size'] as String?,
      capacity: json['capacity'] as int?,
      description: json['description'] as String?,
      isAvailable: json['is_available'] as bool? ?? false, // Sesuaikan dengan nama field JSON
      images: (json['images'] as List<dynamic>?)
              ?.map((e) => RoomImage.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      roomFacilities: (json['room_facilities'] as List<dynamic>?)
              ?.map((e) => Facility.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$RoomDetailToJson(RoomDetail instance) =>
    <String, dynamic>{
      'id': instance.id,
      'room_type': instance.roomType, // Sesuaikan dengan nama field JSON
      'room_number': instance.roomNumber, // Sesuaikan dengan nama field JSON
      'price': instance.price,
      'size': instance.size,
      'capacity': instance.capacity,
      'description': instance.description,
      'is_available': instance.isAvailable, // Sesuaikan dengan nama field JSON
      'images': instance.images.map((e) => e.toJson()).toList(),
      'room_facilities': instance.roomFacilities.map((e) => e.toJson()).toList(),
    };
