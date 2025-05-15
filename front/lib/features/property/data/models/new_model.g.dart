// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'new_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PropertyModel _$PropertyModelFromJson(Map<String, dynamic> json) {
  try {
    return PropertyModel(
      id: json['id'] is String ? int.tryParse(json['id']) ?? 0 : (json['id'] as num?)?.toInt() ?? 0,
      name: json['name'] as String? ?? 'Properti Tanpa Nama',
      image: json['image'] as String?,
      price: _parsePrice(json['price']),
      address: json['address'] as String? ?? 'Alamat tidak tersedia',
      description: json['description'] as String? ?? '',
      propertyTypeId: json['property_type_id'] is String 
          ? int.tryParse(json['property_type_id']) ?? 0 
          : (json['property_type_id'] as num?)?.toInt() ?? 0,
      provinceId: json['province_id'] is String 
          ? int.tryParse(json['province_id']) ?? 0 
          : (json['province_id'] as num?)?.toInt() ?? 0,
      cityId: json['city_id'] is String 
          ? int.tryParse(json['city_id']) ?? 0 
          : (json['city_id'] as num?)?.toInt() ?? 0,
      districtId: json['district_id'] is String 
          ? int.tryParse(json['district_id']) ?? 0 
          : (json['district_id'] as num?)?.toInt() ?? 0,
      subdistrictId: json['subdistrict_id'] is String 
          ? int.tryParse(json['subdistrict_id']) ?? 0 
          : (json['subdistrict_id'] as num?)?.toInt() ?? 0,
      latitude: _parseLatitude(json['latitude']),
      longitude: _parseLongitude(json['longitude']),
      capacity: json['capacity'] is String 
          ? int.tryParse(json['capacity']) ?? 0 
          : (json['capacity'] as num?)?.toInt() ?? 0,
      availableRooms: json['available_rooms'] is String 
          ? int.tryParse(json['available_rooms']) ?? 0 
          : (json['available_rooms'] as num?)?.toInt() ?? 0,
      rules: json['rules'] as String?,
      isDeleted: json['isDeleted'] is String 
          ? json['isDeleted'] == 'true' 
          : (json['isDeleted'] as bool?) ?? false,
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at'] as String) 
          : DateTime.now(),
      updatedAt: json['updated_at'] != null 
          ? DateTime.parse(json['updated_at'] as String) 
          : DateTime.now(),
    );
  } catch (e) {
    // Return default model jika parsing gagal
    return PropertyModel.defaultModel();
  }
}

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