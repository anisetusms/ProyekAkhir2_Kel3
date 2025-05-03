// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'property_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PropertyModel _$PropertyModelFromJson(Map<String, dynamic> json) =>
    PropertyModel(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      propertyType: json['propertytype'] as String,
      address: json['address'] as String,
      price: PropertyModel._priceFromJson(json['price']),
      district: json['district'] as String,
      subdistrict: json['subdistrict'] as String,
      image: json['image'] as String,
      createdAt: json['created_at'] as String,
    );

Map<String, dynamic> _$PropertyModelToJson(PropertyModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'propertytype': instance.propertyType,
      'address': instance.address,
      'price': PropertyModel._priceToJson(instance.price),
      'district': instance.district,
      'subdistrict': instance.subdistrict,
      'image': instance.image,
      'created_at': instance.createdAt,
    };
