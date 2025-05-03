import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:dotenv/dotenv.dart';
part 'property_model.g.dart';

@JsonSerializable()
class PropertyModel extends Equatable {
  final int id;
  final String name;
  final String? image;
  final double price;
  final String address;
  final String description;
  final int propertyTypeId;
  final int provinceId;
  final int cityId;
  final int districtId;
  final int subdistrictId;
  final double? latitude;
  final double? longitude;
  final int capacity;
  final int availableRooms;
  final String? rules;
  final bool isDeleted;
  final DateTime createdAt;
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

  // String get imageUrl => image != null 
  //     ? '${dotenv.get('API_BASE_URL')}/storage/$image'
  //     : 'https://via.placeholder.com/150';

  @override
  List<Object?> get props => [id];
}