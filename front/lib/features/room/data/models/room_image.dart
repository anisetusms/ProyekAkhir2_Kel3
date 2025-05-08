import 'package:json_annotation/json_annotation.dart';

part 'room_image.g.dart';

@JsonSerializable()
class RoomImage {
  @JsonKey(name: 'image_url', defaultValue: '')
  final String imageUrl;

  RoomImage({required this.imageUrl});

  factory RoomImage.fromJson(Map<String, dynamic> json) {
    try {
      // Handle different API response structures
      if (json.containsKey('image_url') && json['image_url'] != null) {
        return RoomImage(imageUrl: json['image_url'].toString());
      } else if (json.containsKey('imageUrl') && json['imageUrl'] != null) {
        return RoomImage(imageUrl: json['imageUrl'].toString());
      } else if (json.containsKey('url') && json['url'] != null) {
        return RoomImage(imageUrl: json['url'].toString());
      } else if (json.containsKey('path') && json['path'] != null) {
        return RoomImage(imageUrl: json['path'].toString());
      } else {
        // Try to get the first string value as image URL
        for (var entry in json.entries) {
          if (entry.value != null && entry.value is String) {
            return RoomImage(imageUrl: entry.value as String);
          }
        }
        return RoomImage(imageUrl: '');
      }
    } catch (e) {
      print('Error in RoomImage.fromJson: $e');
      return RoomImage(imageUrl: '');
    }
  }

  Map<String, dynamic> toJson() => {
    'image_url': imageUrl,
  };
}
