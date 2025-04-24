import 'package:flutter/material.dart';
import 'package:front/core/network/api_client.dart';
import 'package:front/core/utils/constants.dart';
import 'package:dio/dio.dart';  

class DashboardScreen extends StatefulWidget {
  static const routeName = '/dashboard';

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  Future<Map<String, dynamic>>? _dashboardDataFuture;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _dashboardDataFuture = _fetchDashboardData();
  }

  Future<Map<String, dynamic>> _fetchDashboardData() async {
    try {
      final response = await ApiClient().get('${Constants.baseUrl}/dashboard');
      print('Response Data (dari _fetchDashboardData): ${response}');
      if (response is Map<String, dynamic>) {
        return response;
      } else {
        throw Exception('Format data dashboard tidak sesuai.');
      }
    } catch (e) {
      print('Error fetching dashboard data (dari catch): $e');
      if (e is DioException) {
        print('DioError Type: ${e.type}');
        print('DioError Message: ${e.message}');
        print('DioError Response: ${e.response?.data}');
        print('DioError StackTrace: ${e.stackTrace}');
      }
      setState(() { 
        _errorMessage = e.toString();
      });
      throw e;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Dashboard')),
      body:
          _errorMessage != null
              ? Center(child: Text(_errorMessage!))
              : FutureBuilder<Map<String, dynamic>>(
                future: _dashboardDataFuture,
                builder: (context, snapshot) {
                  print(
                    'Snapshot Connection State: ${snapshot.connectionState}',
                  ); // Tambahan print
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    print(
                      'Snapshot Error: ${snapshot.error}',
                    ); // Tambahan print
                    return Center(
                      child: Text('Gagal memuat data: ${snapshot.error}'),
                    );
                  } else if (snapshot.hasData) {
                    final dashboardData = snapshot.data!;
                    print('Snapshot Data: $dashboardData'); // Tambahan print
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Selamat Datang di Dashboard!',
                            style: TextStyle(
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 20.0),
                          Text(
                            'Informasi Properti Anda:',
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10.0),
                          if (dashboardData.containsKey('total_properties') &&
                              dashboardData['total_properties'] is int)
                            Text(
                              'Total Properti: ${dashboardData['total_properties']}',
                            ),
                          if (dashboardData.containsKey('total_properties') &&
                              dashboardData['total_properties'] is! int)
                            Text(
                              'Total Properti (tidak valid): ${dashboardData['total_properties']}',
                            ),
                          if (dashboardData.containsKey('total_bookings') &&
                              dashboardData['total_bookings'] is int)
                            Text(
                              'Total Pemesanan: ${dashboardData['total_bookings']}',
                            ),
                          if (dashboardData.containsKey('total_bookings') &&
                              dashboardData['total_bookings'] is! int)
                            Text(
                              'Total Pemesanan (tidak valid): ${dashboardData['total_bookings']}',
                            ),
                          // Tambahkan widget lain untuk menampilkan data dashboard sesuai kebutuhan Anda
                          SizedBox(height: 20.0),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/properties');
                            },
                            child: Text('Lihat Daftar Properti'),
                          ),
                          SizedBox(height: 10.0),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/add_property');
                            },
                            child: Text('Tambah Properti Baru'),
                          ),
                          // Tambahkan tombol atau informasi lain sesuai kebutuhan dashboard Anda
                        ],
                      ),
                    );
                  } else {
                    return Center(child: Text('Tidak ada data dashboard.'));
                  }
                },
              ),
    );
  }
}
