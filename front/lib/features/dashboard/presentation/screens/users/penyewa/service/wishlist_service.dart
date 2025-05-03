import 'package:dio/dio.dart';
import 'package:front/core/network/api_client.dart';
import 'package:front/features/dashboard/presentation/screens/users/penyewa/models/wishlist_model.dart';

class WishlistService {
  final Dio _dio;

  WishlistService(ApiClient apiClient) : _dio = apiClient.dio;

  Future<List<WishlistModel>> getUserWishlists() async {
    try {
      final response = await _dio.get('/wishlist/user');
      return (response.data['data'] as List)
          .map((json) => WishlistModel.fromJson(json))
          .toList();
    } on DioException catch (e) {
      throw Exception('Gagal mengambil daftar wishlist: ${e.message}');
    }
  }

  Future<bool> toggleWishlist(int propertyId) async {
    try {
      final response = await _dio.post('/wishlist/toggle/$propertyId');
      return response.data['status'] == 'added';
    } on DioException catch (e) {
      throw Exception('Gagal mengubah wishlist: ${e.message}');
    }
  }

  Future<bool> checkWishlist(int propertyId) async {
    try {
      final response = await _dio.get('/wishlist/check/$propertyId');
      return response.data['is_wishlisted'];
    } on DioException catch (e) {
      throw Exception('Gagal memeriksa wishlist: ${e.message}');
    }
  }
}