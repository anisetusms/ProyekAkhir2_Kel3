class Constants {
  // Sesuaikan dengan URL API Anda
  // static const String baseUrl = 'http://192.168.106.45:8000/api';
  static const String baseUrl = 'http://192.168.106.45:8000/api';
  
  // Untuk development di emulator Android:
  // static const String baseUrl = 'http://10.0.2.2:8000';
  
  // Untuk development di iOS simulator:
  // static const String baseUrl = 'http://localhost:8000';

  // Pastikan URL storage benar
  static String get imageBaseUrl => '$baseUrl/storage';
  static const String defaultPropertyImage = 'https://via.placeholder.com/400?text=No+Image';
}