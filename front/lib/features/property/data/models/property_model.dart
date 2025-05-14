import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

part 'property_model.g.dart';

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

  factory PropertyModel.fromJson(Map<String, dynamic> json) =>
      _$PropertyModelFromJson(json);

  Map<String, dynamic> toJson() => _$PropertyModelToJson(this);

  String get imageUrl =>
      image != null
          ? '${dotenv.env['API_BASE_URL']}/storage/$image'
          : 'https://via.placeholder.com/150';

  @override
  List<Object?> get props => [id];
}

double _parsePrice(dynamic price) {
  if (price is String) {
    return double.tryParse(price) ?? 0.0;
  } else if (price is num) {
    return price.toDouble();
  }
  return 0.0;
}

double? _parseLatitude(dynamic latitude) {
  if (latitude is String) {
    return double.tryParse(latitude);
  } else if (latitude is num) {
    return latitude.toDouble();
  }
  return null;
}

double? _parseLongitude(dynamic longitude) {
  if (longitude is String) {
    return double.tryParse(longitude);
  } else if (longitude is num) {
    return longitude.toDouble();
  }
  return null;
}
