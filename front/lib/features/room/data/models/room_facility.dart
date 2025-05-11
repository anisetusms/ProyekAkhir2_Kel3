class RoomFacility {
  final int id;
  final int roomId;
  final String facilityName;

  RoomFacility({
    required this.id,
    required this.roomId,
    required this.facilityName,
  });

  factory RoomFacility.fromJson(Map<String, dynamic> json) {
    return RoomFacility(
      id: int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      roomId: int.tryParse(json['room_id']?.toString() ?? '0') ?? 0,
      facilityName: json['facility_name']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'room_id': roomId, 'facility_name': facilityName};
  }
}
