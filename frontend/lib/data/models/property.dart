import 'package:flutter/widgets.dart';

class Property {
  final BigInt id;
  final String name;
  final Text? description;
  final BigInt propertyTypeId;
  final BigInt userId;
  final BigInt provinceId;
  final BigInt cityId;
  final BigInt districtId;
  final BigInt subdistrictId;
  final double price;
  final Text? address;
  final double? latitude;
  final double? longitude;
  final String? image;
  final int? capacity;
  final int? availableRooms;
  final Text? rules;
  final bool isDeleted;

  // Optional: Nested relationships (lazy parsing)
  final String? imageUrl;
  final PropertyType? propertyType;
  final User? user;
  final Province? province;
  final City? city;
  final District? district;
  final Subdistrict? subdistrict;

  Property({
    required this.id,
    required this.name,
    this.description,
    required this.propertyTypeId,
    required this.userId,
    required this.provinceId,
    required this.cityId,
    required this.districtId,
    required this.subdistrictId,
    required this.price,
    this.address,
    this.latitude,
    this.longitude,
    this.image,
    this.capacity,
    this.availableRooms,
    this.rules,
    required this.isDeleted,
    this.imageUrl,
    this.propertyType,
    this.user,
    this.province,
    this.city,
    this.district,
    this.subdistrict,
  });

  factory Property.fromJson(Map<String, dynamic> json) {
    return Property(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      propertyTypeId: json['property_type_id'],
      userId: json['user_id'],
      provinceId: json['province_id'],
      cityId: json['city_id'],
      districtId: json['district_id'],
      subdistrictId: json['subdistrict_id'],
      price: double.tryParse(json['price'].toString()) ?? 0.0,
      address: json['address'],
      latitude: json['latitude'] != null
          ? double.tryParse(json['latitude'].toString())
          : null,
      longitude: json['longitude'] != null
          ? double.tryParse(json['longitude'].toString())
          : null,
      image: json['image'],
      capacity: json['capacity'],
      availableRooms: json['available_rooms'],
      rules: json['rules'],
      isDeleted: json['isDeleted'] ?? false,
      imageUrl: json['image_url'], // Dari accessor Laravel
      // Optional parsing for relationships
      propertyType: json['property_type'] != null
          ? PropertyType.fromJson(json['property_type'])
          : null,
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      province: json['province'] != null
          ? Province.fromJson(json['province'])
          : null,
      city: json['city'] != null ? City.fromJson(json['city']) : null,
      district: json['district'] != null
          ? District.fromJson(json['district'])
          : null,
      subdistrict: json['subdistrict'] != null
          ? Subdistrict.fromJson(json['subdistrict'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'property_type_id': propertyTypeId,
      'user_id': userId,
      'province_id': provinceId,
      'city_id': cityId,
      'district_id': districtId,
      'subdistrict_id': subdistrictId,
      'price': price,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'image': image,
      'capacity': capacity,
      'available_rooms': availableRooms,
      'rules': rules,
      'isDeleted': isDeleted,
    };
  }
}
