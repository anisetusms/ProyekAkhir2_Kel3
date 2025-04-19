import 'package:hotel_booking/presentation/screen/hotelDetails/Modelclass/review_model.dart';
import 'package:hotel_booking/presentation/screen/hotelDetails/Modelclass/images_model.dart';
import 'package:hotel_booking/presentation/screen/hotelDetails/Modelclass/details_model.dart';
import 'package:hotel_booking/presentation/screen/hotelDetails/Modelclass/facilites_model.dart';
import 'package:hotel_booking/presentation/screen/galleryPhoto/gallery_photo_model.dart';

class Detail {
  int? id;
  String? hotelName;
  String? location;
  String? price;
  String? rate;
  String? review;
  String? status;
  String? image;
  String? description;
  double lat=0;
  double lng=0;
  List<Images> images = [];
  List<GalleryPhoto> galleryPhotos = [];
  List<Details> details = [];
  List<Facility> facility = [];
  List<AllReview> allReview = [];

  // Detail({
  //   required this.id,
  //   required this.hotelName,
  //   required this.location,
  //   required this.price,
  //   required this.rate,
  //   required this.image,
  // });

  Detail.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    hotelName = json['hotelName'];
    location = json['location'];
    price = json['price'];
    rate = json['rate'];
    review = json['review'];
    status = json['status'];
    image = json['image'];
    description = json['Description'];
    lat = json['lat'] ?? 0;
    lng = json['lng'] ?? 0;

    if(json['images'] != null) {
      images = List<dynamic>.from(json['images']).map((i) => Images.fromJson(i)).toList();
    }
    if(json['galleryPhotos'] != null) {
      galleryPhotos = List<dynamic>.from(json['galleryPhotos']).map((i) => GalleryPhoto.fromJson(i)).toList();
    }
    if(json['details'] != null) {
      details = List<dynamic>.from(json['details']).map((i) => Details.fromJson(i)).toList();
    }
    if(json['facilites'] != null) {
      facility = List<dynamic>.from(json['facilites']).map((i) => Facility.fromJson(i)).toList();
    }
    if(json['allReviews'] != null) {
      allReview = List<dynamic>.from(json['allReviews']).map((i) => AllReview.fromJson(i)).toList();
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic> {};
    data['id'] = id;
    data['hotelName'] = hotelName;
    data['location'] = location;
    data['price'] = price;
    data['rate'] = rate;
    data['review'] = review;
    data['status'] = status;
    data['image'] = image;
    data['Description'] = description;
    if(data['images'] != null) {
      data['images'] = images.map((item) => item.toJson()).toList();
    }
    if(data['galleryPhotos'] != null) {
      data['galleryPhotos'] = galleryPhotos.map((item) => item.toJson()).toList();
    }
    if(data['details'] != null) {
      data['details'] = details.map((item) => item.toJson()).toList();
    }
    if(data['facility'] != null) {
      data['facility'] = facility.map((item) => item.toJson()).toList();
    }
    if(data['allReviews'] != null) {
      data['allReviews'] = allReview.map((item) => item.toJson()).toList();
    }
    return data;
  }
}

//----------------------------------- RecentlyBook_model ----------------------------------

class RecentlyBook {
  int? id;
  String? hotelName;
  String? roomType;
  String? available;
  String? location;
  String? status;
  String? rate;
  String? review;
  String? price;
  String? image;

  RecentlyBook({
    required this.id,
    required this.hotelName,
    required this.roomType,
    required this.available,
    required this.location,
    required this.status,
    required this.rate,
    required this.review,
    required this.price,
    required this.image,
  });

  RecentlyBook.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    hotelName = json['hotelName'];
    roomType = json['roomType'];
    available = json['available'];
    location = json['location'];
    status = json['Status'];
    rate = json['rate'];
    review = json['review'];
    price = json['price'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic> {};
    data['id'] = id;
    data['hotelName'] = hotelName;
    data['roomType'] = roomType;
    data['available'] = available;
    data['location'] = location;
    data['Status'] = status;
    data['rate'] = rate;
    data['review'] = review;
    data['price'] = price;
    data['image'] = image;
    return data;
  }
}