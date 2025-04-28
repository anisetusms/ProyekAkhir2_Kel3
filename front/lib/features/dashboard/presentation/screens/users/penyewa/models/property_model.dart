import 'package:json_annotation/json_annotation.dart';

part 'property_model.g.dart';

@JsonSerializable()
class PropertyModel {
  final int id;
  final String name;
  
  @JsonKey(name: 'propertytype')
  final String propertyType;
  
  final String address;
  
  @JsonKey(fromJson: _priceFromJson, toJson: _priceToJson)
  final double price;
  
  final String district;
  
  final String subdistrict;
  
  final String image;
  
  @JsonKey(name: 'created_at')
  final String createdAt;

  PropertyModel({
    required this.id,
    required this.name,
    required this.propertyType,
    required this.address,
    required this.price,
    required this.district,
    required this.subdistrict,
    required this.image,
    required this.createdAt,
  });

  // Custom function for price conversion (from string to double, if needed)
  static double _priceFromJson(dynamic json) {
    if (json is String) {
      return double.tryParse(json) ?? 0.0; // Parse as double, return 0.0 if invalid
    } else if (json is num) {
      return json.toDouble();
    }
    return 0.0;
  }

  // Custom function for price serialization (toString)
  static dynamic _priceToJson(double price) {
    return price.toString();
  }

  factory PropertyModel.fromJson(Map<String, dynamic> json) =>
      _$PropertyModelFromJson(json);

  Map<String, dynamic> toJson() => _$PropertyModelToJson(this);
}
