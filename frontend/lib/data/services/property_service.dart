import 'package:dio/dio.dart';
import 'package:hotel_booking/data/models/property.dart'; 

class PropertyService {
  final Dio _dio;

  PropertyService(this._dio);

  Future<List<Property>> getProperties({bool? isDeleted}) async {
    try {
      final response = await _dio.get('/properties', queryParameters: {
        'isDeleted': isDeleted,
      });
      
      return (response.data['data']['data'] as List)
          .map((json) => Property.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to load properties: $e');
    }
  }

  Future<Property> createProperty(Map<String, dynamic> data) async {
    try {
      // For file upload
      FormData formData = FormData.fromMap({
        ...data,
        'image': data['image'] != null 
            ? await MultipartFile.fromFile(data['image'].path)
            : null,
      });

      final response = await _dio.post('/properties', data: formData);
      return Property.fromJson(response.data['data']);
    } catch (e) {
      throw Exception('Failed to create property: $e');
    }
  }
}
