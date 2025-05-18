import 'package:front/core/network/api_client.dart';
import 'dart:developer' as developer;

class PropertyRatingService {
  final ApiClient _apiClient;
  
  // Cache untuk menyimpan rating yang sudah diambil
  final Map<int, double> _ratingCache = {};

  PropertyRatingService(this._apiClient);

  /// Mengambil rating properti dari API
  Future<double> getPropertyRating(int propertyId) async {
    // Cek apakah rating sudah ada di cache
    if (_ratingCache.containsKey(propertyId)) {
      return _ratingCache[propertyId]!;
    }

    try {
      // Panggil API untuk mendapatkan ulasan properti
      final response = await _apiClient.get('/reviews/property/$propertyId');
      
      // Log response untuk debugging
      developer.log('Rating response for property $propertyId: $response', name: 'PropertyRatingService');
      
      if (response != null && 
          response['status'] == 'success' && 
          response['data'] != null &&
          response['data']['average_rating'] != null) {
        
        // Ambil nilai rating dari response
        final double rating = double.parse(response['data']['average_rating'].toString());
        
        // Simpan di cache untuk penggunaan berikutnya
        _ratingCache[propertyId] = rating;
        
        return rating;
      }
      
      // Jika tidak ada data rating, kembalikan 0
      return 0.0;
    } catch (e) {
      developer.log('Error fetching property rating: $e', name: 'PropertyRatingService');
      return 0.0;
    }
  }

  /// Mengambil jumlah ulasan properti dari API
  Future<int> getReviewCount(int propertyId) async {
    try {
      final response = await _apiClient.get('/reviews/property/$propertyId');
      
      if (response != null && 
          response['status'] == 'success' && 
          response['data'] != null &&
          response['data']['count'] != null) {
        
        return int.parse(response['data']['count'].toString());
      }
      
      return 0;
    } catch (e) {
      developer.log('Error fetching review count: $e', name: 'PropertyRatingService');
      return 0;
    }
  }

  /// Membersihkan cache rating
  void clearCache() {
    _ratingCache.clear();
  }
}
