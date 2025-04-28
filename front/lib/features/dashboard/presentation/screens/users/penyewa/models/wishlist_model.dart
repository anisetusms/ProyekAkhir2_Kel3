import 'package:front/features/dashboard/presentation/screens/users/penyewa/models/property_model.dart';

class WishlistModel {
  final int id;
  final PropertyModel property;

  WishlistModel({required this.id, required this.property});

  factory WishlistModel.fromJson(Map<String, dynamic> json) {
    return WishlistModel(
      id: json['id'],
      property: PropertyModel.fromJson(json['property']),
    );
  }
}