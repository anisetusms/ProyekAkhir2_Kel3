import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:front/core/utils/constants.dart';
import 'package:front/features/property/data/models/property_model.dart';
import 'package:front/core/network/api_client.dart';

class PropertyApiService {
  final String baseUrl;
  final ApiClient _apiClient = ApiClient();

  PropertyApiService({this.baseUrl = Constants.baseUrl});

  Future<PropertyModel> getPropertyDetail(int id) async {
    final url = Uri.parse('$baseUrl/propertiesdetail/$id');

    print('Fetching property from: $url'); // Debug log

    final response = await http.get(url);

    print('Response status: ${response.statusCode}'); // Debug
    print('Response body: ${response.body}'); // Debug

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return PropertyModel.fromJson(jsonData['data'] ?? jsonData);
    } else if (response.statusCode == 404) {
      throw Exception('Properti tidak ditemukan (404)');
    } else {
      throw Exception(
        'Gagal memuat detail properti. Status: ${response.statusCode}',
      );
    }
  }

  Future<Map<String, dynamic>> getPropertyReviews(int propertyId) async {
    try {
      // Pastikan URL endpoint benar
      final response = await _apiClient.get('/property/$propertyId/reviews');
      
      if (response != null && response['status'] == 'success' && response['data'] != null) {
        print('Reviews data: ${response['data']}');
        return response['data'];
      } else {
        print('No reviews data found or invalid format');
        return {
          'items': [],
          'average_rating': 0.0,
          'count': 0
        };
      }
    } catch (e) {
      print('Error fetching property reviews: $e');
      return {
        'items': [],
        'average_rating': 0.0,
        'count': 0
      };
    }
  }
}
