class WishlistModel {
  final int id;
  final PropertyInWishlist property;

  WishlistModel({
    required this.id,
    required this.property,
  });

  factory WishlistModel.fromJson(Map<String, dynamic> json) {
    return WishlistModel(
      id: json['id'],
      property: PropertyInWishlist.fromJson(json['property']),
    );
  }
}

class PropertyInWishlist {
  final int id;
  final String name;
  final double price;
  final String image;

  PropertyInWishlist({
    required this.id,
    required this.name,
    required this.price,
    required this.image,
  });

  factory PropertyInWishlist.fromJson(Map<String, dynamic> json) {
    return PropertyInWishlist(
      id: json['id'],
      name: json['name'],
      price: double.parse(json['price'].toString()),
      image: json['image'],
    );
  }
}
