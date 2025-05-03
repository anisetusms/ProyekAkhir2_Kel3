import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:front/core/utils/constants.dart';
import 'package:front/features/property/data/models/property_model.dart';

class PropertyApiService {
  final String baseUrl;

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
        'Gagal memuat detail properti. Status: ${response.statusCode}'
      );
    }
  }
}