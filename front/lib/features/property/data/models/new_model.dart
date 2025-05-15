import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

part 'new_model.g.dart';

@JsonSerializable()
class PropertyModel extends Equatable {
  final int id;
  final String name;
  final String? image;
  final double price;
  final String address;
  final String description;
  @JsonKey(name: 'property_type_id')
  final int propertyTypeId;
  @JsonKey(name: 'province_id')
  final int provinceId;
  @JsonKey(name: 'city_id')
  final int cityId;
  @JsonKey(name: 'district_id')
  final int districtId;
  @JsonKey(name: 'subdistrict_id')
  final int subdistrictId;
  final double? latitude;
  final double? longitude;
  final int capacity;
  @JsonKey(name: 'available_rooms')
  final int availableRooms;
  final String? rules;
  @JsonKey(name: 'isDeleted')
  final bool isDeleted;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  const PropertyModel({
    required this.id,
    required this.name,
    this.image,
    required this.price,
    required this.address,
    required this.description,
    required this.propertyTypeId,
    required this.provinceId,
    required this.cityId,
    required this.districtId,
    required this.subdistrictId,
    this.latitude,
    this.longitude,
    required this.capacity,
    required this.availableRooms,
    this.rules,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
  });

  bool get isKost => propertyTypeId == 1;
  bool get isHomestay => propertyTypeId == 2;

  // Validasi koordinat
  bool get hasValidCoordinates {
    return latitude != null && 
           longitude != null && 
           latitude! >= -90 && 
           latitude! <= 90 && 
           longitude! >= -180 && 
           longitude! <= 180;
  }

  // Metode untuk menghitung jarak dari posisi pengguna
  double? distanceFrom(double userLat, double userLng) {
    if (!hasValidCoordinates) return null;
    
    try {
      return Geolocator.distanceBetween(
        userLat,
        userLng,
        latitude!,
        longitude!,
      );
    } catch (e) {
      print('[DEBUG] Error calculating distance: $e');
      return null;
    }
  }

  // Metode untuk mendapatkan teks jarak
  String getDistanceText(double? distance) {
    if (distance == null) return 'Jarak tidak tersedia';
    
    if (distance < 1000) {
      return '${distance.toStringAsFixed(0)} meter dari Anda';
    } else {
      return '${(distance / 1000).toStringAsFixed(1)} km dari Anda';
    }
  }

  // Metode untuk mendapatkan warna jarak
  Color getDistanceColor(double? distance) {
    if (distance == null) return Colors.black54;
    
    if (distance < 100) {
      return Colors.green.shade700;
    } else if (distance < 1000) {
      return Colors.orange;
    } else {
      return Colors.blue.shade700;
    }
  }

  // Factory untuk membuat model default
  factory PropertyModel.defaultModel() {
    return PropertyModel(
      id: 0,
      name: 'Properti Default',
      price: 0,
      address: 'Alamat tidak tersedia',
      description: 'Deskripsi tidak tersedia',
      propertyTypeId: 0,
      provinceId: 0,
      cityId: 0,
      districtId: 0,
      subdistrictId: 0,
      capacity: 0,
      availableRooms: 0,
      isDeleted: false,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  factory PropertyModel.fromJson(Map<String, dynamic> json) {
    try {
      return _$PropertyModelFromJson(json);
    } catch (e) {
      print('[DEBUG] Error parsing PropertyModel: $e');
      // Return default model jika parsing gagal
      return PropertyModel.defaultModel();
    }
  }

  Map<String, dynamic> toJson() => _$PropertyModelToJson(this);

  String get imageUrl =>
      image != null
          ? '${dotenv.env['API_BASE_URL'] ?? ''}/storage/$image'
          : 'https://via.placeholder.com/150';

  @override
  List<Object?> get props => [id];
}

// Fungsi parsing yang lebih robust
double _parsePrice(dynamic price) {
  if (price == null) return 0.0;
  if (price is String) {
    try {
      return double.parse(price);
    } catch (e) {
      return 0.0;
    }
  } else if (price is num) {
    return price.toDouble();
  }
  return 0.0;
}

double? _parseLatitude(dynamic latitude) {
  if (latitude == null) return null;
  try {
    if (latitude is String) {
      final parsed = double.tryParse(latitude);
      // Validasi range latitude (-90 sampai 90)
      if (parsed != null && parsed >= -90 && parsed <= 90) {
        return parsed;
      }
    } else if (latitude is num) {
      final value = latitude.toDouble();
      if (value >= -90 && value <= 90) {
        return value;
      }
    }
  } catch (e) {
    print('[DEBUG] Error parsing latitude: $e');
  }
  return null;
}

double? _parseLongitude(dynamic longitude) {
  if (longitude == null) return null;
  try {
    if (longitude is String) {
      final parsed = double.tryParse(longitude);
      // Validasi range longitude (-180 sampai 180)
      if (parsed != null && parsed >= -180 && parsed <= 180) {
        return parsed;
      }
    } else if (longitude is num) {
      final value = longitude.toDouble();
      if (value >= -180 && value <= 180) {
        return value;
      }
    }
  } catch (e) {
    print('[DEBUG] Error parsing longitude: $e');
  }
  return null;
}