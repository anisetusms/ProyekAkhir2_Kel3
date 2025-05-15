// import 'package:json_annotation/json_annotation.dart';

// part 'room_image.g.dart';

// @JsonSerializable()
// class RoomImage {
//   @JsonKey(name: 'image_url', defaultValue: '')
//   final String imageUrl;

//   RoomImage({required this.imageUrl});

//   factory RoomImage.fromJson(Map<String, dynamic> json) {
//     try {
//       // Handle different API response structures
//       if (json.containsKey('image_url') && json['image_url'] != null) {
//         return RoomImage(imageUrl: json['image_url'].toString());
//       } else if (json.containsKey('imageUrl') && json['imageUrl'] != null) {
//         return RoomImage(imageUrl: json['imageUrl'].toString());
//       } else if (json.containsKey('url') && json['url'] != null) {
//         return RoomImage(imageUrl: json['url'].toString());
//       } else if (json.containsKey('path') && json['path'] != null) {
//         return RoomImage(imageUrl: json['path'].toString());
//       } else {
//         // Try to get the first string value as image URL
//         for (var entry in json.entries) {
//           if (entry.value != null && entry.value is String) {
//             return RoomImage(imageUrl: entry.value as String);
//           }
//         }
//         return RoomImage(imageUrl: '');
//       }
//     } catch (e) {
//       print('Error in RoomImage.fromJson: $e');
//       return RoomImage(imageUrl: '');
//     }
//   }

//   Map<String, dynamic> toJson() => {
//     'image_url': imageUrl,
//   };
// }


import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter/foundation.dart';

part 'room_image.g.dart';

@JsonSerializable()
class RoomImage extends Equatable {
  @JsonKey(name: 'id')
  final int? id;
  
  @JsonKey(name: 'room_id')
  final int? roomId;
  
  @JsonKey(name: 'image_url')
  final String imageUrl;
  
  @JsonKey(name: 'is_main', defaultValue: false)
  final bool isMain;
  
  @JsonKey(name: 'created_at')
  final String? createdAt;
  
  @JsonKey(name: 'updated_at')
  final String? updatedAt;

  RoomImage({
    this.id,
    this.roomId,
    required this.imageUrl,
    this.isMain = false,
    this.createdAt,
    this.updatedAt,
  });

  factory RoomImage.fromJson(Map<String, dynamic> json) {
    try {
      debugPrint('Processing RoomImage.fromJson with: $json');
      
      // Create a copy of the json to avoid modifying the original
      final Map<String, dynamic> processedJson = Map<String, dynamic>.from(json);
      
      // Handle different field names for image_url
      if (!processedJson.containsKey('image_url') && processedJson.containsKey('imageUrl')) {
        processedJson['image_url'] = processedJson['imageUrl'];
      }
      
      // Handle different field names for is_main
      if (!processedJson.containsKey('is_main') && processedJson.containsKey('isMain')) {
        processedJson['is_main'] = processedJson['isMain'];
      }
      
      // Handle different field names for room_id
      if (!processedJson.containsKey('room_id') && processedJson.containsKey('roomId')) {
        processedJson['room_id'] = processedJson['roomId'];
      }
      
      return _$RoomImageFromJson(processedJson);
    } catch (e) {
      debugPrint('Error in RoomImage.fromJson: $e');
      // Return a default RoomImage object in case of error
      return RoomImage(imageUrl: json['image_url'] ?? '');
    }
  }

  Map<String, dynamic> toJson() => _$RoomImageToJson(this);

  @override
  List<Object?> get props => [id, roomId, imageUrl, isMain, createdAt, updatedAt];
}
