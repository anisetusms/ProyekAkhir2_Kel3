import 'package:front/features/room/data/models/facility.dart';
import 'package:front/features/room/data/models/room_image.dart';

class Room {
  final int id;
  final String roomType;
  final String roomNumber;
  final double price;
  final String? size;
  final int? capacity;
  final String? description;
  final bool isAvailable;
  final List<RoomImage> images;
  final List<Facility> facilities;

  Room({
    required this.id,
    required this.roomType,
    required this.roomNumber,
    required this.price,
    this.size,
    this.capacity,
    this.description,
    required this.isAvailable,
    required this.images,
    required this.facilities,
  });

  factory Room.fromJson(Map<String, dynamic> json) {
    // Handle price conversion
    double price = 0.0;
    if (json['price'] != null) {
      if (json['price'] is int) {
        price = json['price'].toDouble();
      } else if (json['price'] is double) {
        price = json['price'];
      } else if (json['price'] is String) {
        price = double.tryParse(json['price']) ?? 0.0;
      }
    }

    // Handle images - return empty list if not provided
    List<RoomImage> images = [];
    if (json['images'] != null && json['images'] is List) {
      images = (json['images'] as List)
          .map((image) => RoomImage.fromJson(image))
          .toList();
    }

    // Handle facilities
    List<Facility> facilities = [];
    if (json['facilities'] != null && json['facilities'] is List) {
      facilities = (json['facilities'] as List)
          .map((facility) => Facility.fromJson(facility))
          .toList();
    }

    return Room(
      id: json['id'] ?? 0,
      roomType: json['room_type'] ?? 'Kamar',
      roomNumber: json['room_number'] ?? '',
      price: price,
      size: json['size'],
      capacity: json['capacity'],
      description: json['description'],
      isAvailable: json['is_available'] ?? true,
      images: images,
      facilities: facilities,
    );
  }
}