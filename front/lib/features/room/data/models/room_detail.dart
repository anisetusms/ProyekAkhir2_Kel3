import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'room_image.dart';
import 'facility.dart';
import 'package:flutter/foundation.dart';

part 'room_detail.g.dart';

@JsonSerializable(explicitToJson: true)
class RoomDetail extends Equatable {
  final int id;
  
  @JsonKey(name: 'room_type', defaultValue: 'Kamar')
  final String roomType;
  
  @JsonKey(name: 'room_number', defaultValue: '')
  final String roomNumber;
  
  @JsonKey(name: 'price', fromJson: _priceFromJson)
  final double price;
  
  @JsonKey(name: 'size')
  final String? size;
  
  @JsonKey(name: 'capacity')
  final int? capacity;
  
  @JsonKey(name: 'description')
  final String? description;
  
  @JsonKey(name: 'is_available', defaultValue: false)
  final bool isAvailable;
  
  @JsonKey(name: 'images', fromJson: _imagesFromJson, defaultValue: [])
  final List<RoomImage> images;
  
  @JsonKey(name: 'room_facilities', fromJson: _facilitiesFromJson, defaultValue: [])
  final List<Facility> roomFacilities;

  RoomDetail({
    required this.id,
    required this.roomType,
    required this.roomNumber,
    required this.price,
    this.size,
    this.capacity,
    this.description,
    required this.isAvailable,
    required this.images,
    required this.roomFacilities,
  });

  // Custom converter for price to handle different formats
  static double _priceFromJson(dynamic json) {
    if (json == null) return 0.0;
    if (json is int) {
      return json.toDouble();
    } else if (json is double) {
      return json;
    } else if (json is String) {
      return double.tryParse(json) ?? 0.0;
    }
    return 0.0;
  }

  // Custom converter for images
  static List<RoomImage> _imagesFromJson(dynamic json) {
    debugPrint('Processing images from JSON: $json');
    if (json == null) {
      debugPrint('Images JSON is null, returning empty list');
      return [];
    }
    
    List<RoomImage> imagesList = [];
    
    if (json is List) {
      debugPrint('Images JSON is a List with ${json.length} items');
      for (var item in json) {
        if (item is Map<String, dynamic>) {
          try {
            imagesList.add(RoomImage.fromJson(Map<String, dynamic>.from(item)));
            debugPrint('Added image from map: $item');
          } catch (e) {
            debugPrint('Error parsing image from map: $e');
          }
        } else if (item is String) {
          imagesList.add(RoomImage(imageUrl: item));
          debugPrint('Added image from string: $item');
        }
      }
    } else if (json is Map<String, dynamic>) {
      // Handle case where images might be a single object
      try {
        imagesList.add(RoomImage.fromJson(Map<String, dynamic>.from(json)));
        debugPrint('Added image from single map: $json');
      } catch (e) {
        debugPrint('Error parsing image from single map: $e');
      }
    }
    
    debugPrint('Processed ${imagesList.length} images');
    return imagesList;
  }

  // Custom converter for facilities
  static List<Facility> _facilitiesFromJson(dynamic json) {
    debugPrint('Processing facilities from JSON: $json');
    if (json == null) {
      debugPrint('Facilities JSON is null, returning empty list');
      return [];
    }
    
    List<Facility> facilitiesList = [];
    
    if (json is List) {
      debugPrint('Facilities JSON is a List with ${json.length} items');
      for (var item in json) {
        if (item is Map<String, dynamic>) {
          try {
            facilitiesList.add(Facility.fromJson(Map<String, dynamic>.from(item)));
            debugPrint('Added facility from map: $item');
          } catch (e) {
            debugPrint('Error parsing facility from map: $e');
          }
        } else if (item is String) {
          facilitiesList.add(Facility(facilityName: item));
          debugPrint('Added facility from string: $item');
        }
      }
    }
    
    debugPrint('Processed ${facilitiesList.length} facilities');
    return facilitiesList;
  }

  factory RoomDetail.fromJson(Map<String, dynamic> json) {
    try {
      debugPrint('Processing RoomDetail.fromJson with: $json');
      
      // Create a copy of the json to avoid modifying the original
      final Map<String, dynamic> processedJson = Map<String, dynamic>.from(json);
      
      // Ensure required fields exist
      if (!processedJson.containsKey('id')) {
        processedJson['id'] = 0;
      }
      
      // Handle different field names for room_type
      if (!processedJson.containsKey('room_type') && processedJson.containsKey('roomType')) {
        processedJson['room_type'] = processedJson['roomType'];
      }
      
      // Handle different field names for room_number
      if (!processedJson.containsKey('room_number') && processedJson.containsKey('roomNumber')) {
        processedJson['room_number'] = processedJson['roomNumber'];
      }
      
      // Handle different field names for is_available
      if (!processedJson.containsKey('is_available') && processedJson.containsKey('isAvailable')) {
        processedJson['is_available'] = processedJson['isAvailable'];
      }
      
      // Handle different field names for room_facilities
      if (!processedJson.containsKey('room_facilities') && processedJson.containsKey('roomFacilities')) {
        processedJson['room_facilities'] = processedJson['roomFacilities'];
      } else if (!processedJson.containsKey('room_facilities') && processedJson.containsKey('facilities')) {
        processedJson['room_facilities'] = processedJson['facilities'];
      }
      
      // Add debug for images
      debugPrint('Images in JSON: ${processedJson['images']}');
      
      // Jika tidak ada images, coba cari di field lain
      if (processedJson['images'] == null) {
        // Coba cari di main_image_url atau mainImageUrl
        if (processedJson.containsKey('main_image_url') && processedJson['main_image_url'] != null) {
          processedJson['images'] = [{'image_url': processedJson['main_image_url'], 'is_main': true}];
        } else if (processedJson.containsKey('mainImageUrl') && processedJson['mainImageUrl'] != null) {
          processedJson['images'] = [{'image_url': processedJson['mainImageUrl'], 'is_main': true}];
        }
        
        // Coba cari di gallery_images atau galleryImages
        if (processedJson.containsKey('gallery_images') && processedJson['gallery_images'] != null) {
          List<Map<String, dynamic>> galleryImages = [];
          if (processedJson['gallery_images'] is List) {
            for (var url in processedJson['gallery_images']) {
              galleryImages.add({'image_url': url, 'is_main': false});
            }
          }
          
          if (processedJson['images'] == null) {
            processedJson['images'] = galleryImages;
          } else if (processedJson['images'] is List) {
            (processedJson['images'] as List).addAll(galleryImages);
          }
        }
      }
      
      // Use the generated fromJson method with our processed data
      return _$RoomDetailFromJson(processedJson);
    } catch (e) {
      debugPrint('Error in RoomDetail.fromJson: $e');
      // Return a default RoomDetail object in case of error
      return RoomDetail(
        id: 0,
        roomType: 'Kamar',
        roomNumber: '',
        price: 0,
        isAvailable: false,
        images: [],
        roomFacilities: [],
      );
    }
  }

  Map<String, dynamic> toJson() => _$RoomDetailToJson(this);

  @override
  List<Object?> get props => [id, roomType, roomNumber, price, size, capacity, description, isAvailable, images, roomFacilities];
}
