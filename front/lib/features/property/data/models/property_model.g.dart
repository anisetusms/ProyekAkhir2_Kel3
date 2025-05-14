// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'property_model.dart';

// **************************************************************************

// JsonSerializableGenerator
// **************************************************************************

PropertyModel _$PropertyModelFromJson(Map<String, dynamic> json) =>
    PropertyModel(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      image: json['image'] as String?,
      price: _parsePrice(json['price']),
      address: json['address'] as String,
      description: json['description'] as String,
      propertyTypeId: (json['property_type_id'] as num).toInt(),
      provinceId: (json['province_id'] as num).toInt(),
      cityId: (json['city_id'] as num).toInt(),
      districtId: (json['district_id'] as num).toInt(),
      subdistrictId: (json['subdistrict_id'] as num).toInt(),
      latitude: _parseLatitude(json['latitude']),
      longitude: _parseLongitude(json['longitude']),
      capacity: (json['capacity'] as num).toInt(),
      availableRooms: (json['available_rooms'] as num).toInt(),
      rules: json['rules'] as String?,
      isDeleted: json['isDeleted'] as bool,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$PropertyModelToJson(PropertyModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'image': instance.image,
      'price': instance.price,
      'address': instance.address,
      'description': instance.description,
      'property_type_id': instance.propertyTypeId,
      'province_id': instance.provinceId,
      'city_id': instance.cityId,
      'district_id': instance.districtId,
      'subdistrict_id': instance.subdistrictId,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'capacity': instance.capacity,
      'available_rooms': instance.availableRooms,
      'rules': instance.rules,
      'isDeleted': instance.isDeleted,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };