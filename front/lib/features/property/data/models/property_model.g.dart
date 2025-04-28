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
      price: (json['price'] as num).toDouble(),
      address: json['address'] as String,
      description: json['description'] as String,
      propertyTypeId: (json['propertyTypeId'] as num).toInt(),
      provinceId: (json['provinceId'] as num).toInt(),
      cityId: (json['cityId'] as num).toInt(),
      districtId: (json['districtId'] as num).toInt(),
      subdistrictId: (json['subdistrictId'] as num).toInt(),
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      capacity: (json['capacity'] as num).toInt(),
      availableRooms: (json['availableRooms'] as num).toInt(),
      rules: json['rules'] as String?,
      isDeleted: json['isDeleted'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
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
