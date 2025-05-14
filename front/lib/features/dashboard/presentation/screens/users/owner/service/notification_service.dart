import 'package:dio/dio.dart';
import 'package:front/core/network/api_client.dart';
import 'package:front/features/property/data/models/notification_model.dart';

class NotificationService {
  final ApiClient _apiClient = ApiClient();

  // Mendapatkan semua notifikasi
  Future<List<NotificationModel>> getNotifications() async {
    try {
      final response = await _apiClient.get('/notifications');
      
      if (response['status'] == 'success') {
        final List<dynamic> data = response['data'];
        return data.map((item) => NotificationModel.fromJson(item)).toList();
      } else {
        throw Exception(response['message'] ?? 'Gagal memuat notifikasi');
      }
    } on DioException catch (e) {
      throw Exception('Gagal memuat notifikasi: ${e.message}');
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    }
  }

  // Mendapatkan jumlah notifikasi yang belum dibaca
  Future<int> getUnreadCount() async {
    try {
      final response = await _apiClient.get('/notifications/unread-count');
      
      if (response['status'] == 'success') {
        return response['count'] ?? 0;
      } else {
        throw Exception(response['message'] ?? 'Gagal memuat jumlah notifikasi');
      }
    } on DioException catch (e) {
      throw Exception('Gagal memuat jumlah notifikasi: ${e.message}');
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    }
  }

  // Menandai notifikasi sebagai dibaca
Future<bool> markAsRead(int id) async {
  try {
    final response = await _apiClient.post('/notifications/$id/mark-as-read');
    
    return response['status'] == 'success';
  } on DioException catch (e) {
    throw Exception('Gagal menandai notifikasi sebagai dibaca: ${e.message}');
  } catch (e) {
    throw Exception('Terjadi kesalahan: $e');
  }
}

// Menandai semua notifikasi sebagai dibaca
Future<bool> markAllAsRead() async {
  try {
    final response = await _apiClient.post('/notifications/mark-all-as-read');
    
    return response['status'] == 'success';
  } on DioException catch (e) {
    throw Exception('Gagal menandai semua notifikasi sebagai dibaca: ${e.message}');
  } catch (e) {
    throw Exception('Terjadi kesalahan: $e');
  }
}


  // Menghapus notifikasi
  Future<bool> deleteNotification(int id) async {
    try {
      final response = await _apiClient.delete('/notifications/$id');
      
      return response['status'] == 'success';
    } on DioException catch (e) {
      throw Exception('Gagal menghapus notifikasi: ${e.message}');
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    }
  }
}
