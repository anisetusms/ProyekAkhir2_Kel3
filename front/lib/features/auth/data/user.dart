class User {
  final int id;
  final String name;
  final String username;
  final String? gender;
  final String? phone;
  final String? address;
  final String? profilePicture;
  final int userRoleId;
  final String status; 

  User({
    required this.id,
    required this.name,
    required this.username,
    this.gender,
    this.phone,
    this.address,
    this.profilePicture,
    required this.userRoleId,
    required this.status,  
  });

  // Factory constructor untuk membuat objek User dari JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: _parseInt(json['id']),
      name: _parseString(json['name']),
      username: _parseString(json['username']),
      gender: _parseString(json['gender']),
      phone: _parseString(json['phone']),
      address: _parseString(json['address']),
      profilePicture: _parseString(json['profile_picture']),
      userRoleId: _parseInt(json['user_role_id']),
      status: _parseString(json['status']),  // Parsing status dari JSON
    );
  }

  // Helper methods for safe parsing
  static String _parseString(dynamic value) {
    if (value == null) return '';
    return value.toString();
  }

  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    return int.tryParse(value.toString()) ?? 0;
  }

  // Convert to JSON for sending to API
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'username': username,
      'gender': gender,
      'phone': phone,
      'address': address,
      'profile_picture': profilePicture,
      'user_role_id': userRoleId,
      'status': status,  // Menambahkan status ke dalam JSON
    };
  }
}