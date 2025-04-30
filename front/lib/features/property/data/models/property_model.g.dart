// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'property_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PropertyModel _$PropertyModelFromJson(Map<String, dynamic> json) => PropertyModel(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      image: json['image'] as String?,
      price: double.parse(json['price'] as String), // Handle string price
      address: json['address'] as String,
      description: json['description'] as String,
      propertyTypeId: (json['property_type_id'] as num).toInt(), // snake_case
      provinceId: (json['province_id'] as num).toInt(), // snake_case
      cityId: (json['city_id'] as num).toInt(), // snake_case
      districtId: (json['district_id'] as num).toInt(), // snake_case
      subdistrictId: (json['subdistrict_id'] as num).toInt(), // snake_case
      latitude: double.tryParse(json['latitude'] as String) ?? 0.0, // Handle string
      longitude: double.tryParse(json['longitude'] as String) ?? 0.0, // Handle string
      capacity: (json['capacity'] as num).toInt(),
      availableRooms: (json['available_rooms'] as num).toInt(), // snake_case
      rules: json['rules'] as String?,
      isDeleted: json['isDeleted'] as bool,
      createdAt: DateTime.parse(json['created_at'] as String), // snake_case
      updatedAt: DateTime.parse(json['updated_at'] as String), // snake_case // Add this field
    );

Map<String, dynamic> _$PropertyModelToJson(PropertyModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'image': instance.image,
      'price': instance.price,
      'address': instance.address,
      'description': instance.description,
      'propertyTypeId': instance.propertyTypeId,
      'provinceId': instance.provinceId,
      'cityId': instance.cityId,
      'districtId': instance.districtId,
      'subdistrictId': instance.subdistrictId,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'capacity': instance.capacity,
      'availableRooms': instance.availableRooms,
      'rules': instance.rules,
      'isDeleted': instance.isDeleted,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
