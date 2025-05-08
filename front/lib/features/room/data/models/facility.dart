import 'package:json_annotation/json_annotation.dart';

part 'facility.g.dart';

@JsonSerializable()
class Facility {
  @JsonKey(name: 'facility_name', defaultValue: '')
  final String facilityName;

  Facility({required this.facilityName});

  factory Facility.fromJson(Map<String, dynamic> json) {
    try {
      // Handle different API response structures
      if (json.containsKey('facility_name') && json['facility_name'] != null) {
        return Facility(facilityName: json['facility_name'].toString());
      } else if (json.containsKey('facilityName') && json['facilityName'] != null) {
        return Facility(facilityName: json['facilityName'].toString());
      } else if (json.containsKey('name') && json['name'] != null) {
        return Facility(facilityName: json['name'].toString());
      } else {
        // Try to get the first string value as facility name
        for (var entry in json.entries) {
          if (entry.value != null && entry.value is String) {
            return Facility(facilityName: entry.value as String);
          }
        }
        return Facility(facilityName: 'Fasilitas');
      }
    } catch (e) {
      print('Error in Facility.fromJson: $e');
      return Facility(facilityName: 'Fasilitas');
    }
  }

  Map<String, dynamic> toJson() => {
    'facility_name': facilityName,
  };
}
