import 'package:flutter/material.dart';
import 'package:front/core/network/api_client.dart';
import 'package:front/features/property/presentation/widgets/property_card.dart';
import 'package:front/features/property/presentation/screens/property_detail.dart';
import 'package:front/core/widgets/loading_indicator.dart';
import 'package:front/core/widgets/error_state.dart';
import 'dart:developer';

class PropertyListScreen extends StatefulWidget {
  static const routeName = '/properties';

  @override
  _PropertyListScreenState createState() => _PropertyListScreenState();
}

class _PropertyListScreenState extends State<PropertyListScreen> {
  late Future<List<dynamic>> _propertiesFuture;
  bool _isLoading = false;
  String? _errorMessage;
  
  // Warna tema yang konsisten dengan dashboard
  final Color primaryColor = const Color(0xFF8E44AD); // Ungu seperti di screenshot
  final Color addPropertyColor = const Color(0xFF4CAF50); // Hijau untuk tombol tambah properti

  @override
  void initState() {
    super.initState();
    _loadProperties();
  }

  Future<void> _loadProperties() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await ApiClient().get('/properties');
      log('Response dari API: ${response.toString()}');

      if (response == null || response['data'] == null) {
        throw Exception('Respon API tidak valid');
      }

      if (response['data'] is! List) {
        throw Exception('Format data tidak sesuai');
      }

      setState(() {
        _propertiesFuture = Future.value(response['data'] as List<dynamic>);
        _isLoading = false;
      });
    } catch (e) {
      log('Error saat memuat properti: $e');
      setState(() {
        _errorMessage = 'Gagal memuat data properti. Silakan coba lagi.';
        _isLoading = false;
      });
    }
  }

  Map<String, dynamic> _parseProperty(dynamic propertyData) {
    final Map<String, dynamic> property = {};
    
    // Konversi semua key ke String dan handle null values
    if (propertyData is Map) {
      propertyData.forEach((key, value) {
        property[key.toString()] = value;
      });
    }

    // Handle price conversion
    property['price'] = double.tryParse(property['price']?.toString() ?? '0') ?? 0;

    return property;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Properti Anda'),
        backgroundColor: primaryColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadProperties,
          ),
        ],
      ),
      body: _isLoading
          ? const LoadingIndicator()
          : _errorMessage != null
              ? ErrorState(
                  message: _errorMessage!,
                  onRetry: _loadProperties,
                )
              : FutureBuilder<List<dynamic>>(
                  future: _propertiesFuture,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return ErrorState(
                        message: 'Error: ${snapshot.error}',
                        onRetry: _loadProperties,
                      );
                    }

                    if (!snapshot.hasData) {
                      return const LoadingIndicator();
                    }

                    if (snapshot.data!.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.home_work_outlined,
                              size: 64,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Belum ada properti yang ditambahkan.',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 24),
                            ElevatedButton.icon(
                              icon: const Icon(Icons.add),
                              label: const Text('Tambah Properti Baru'),
                              onPressed: () => Navigator.pushNamed(context, '/add_property'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: addPropertyColor,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return RefreshIndicator(
                      onRefresh: _loadProperties,
                      child: ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          final property = _parseProperty(snapshot.data![index]);
                          log('Properti ke-$index: $property');

                          return PropertyCard(
                            property: property,
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                PropertyDetailScreen.routeName,
                                arguments: property['id'],
                              );
                            },
                            onEdit: () {
                              Navigator.pushNamed(
                                context,
                                '/edit_property',
                                arguments: property['id'],
                              );
                            },
                            onManageRooms: () {
                              Navigator.pushNamed(
                                context,
                                '/property_rooms',
                                arguments: property['id'],
                              );
                            },
                            onToggleStatus: () {
                              // Implementasi toggle status properti
                              _togglePropertyStatus(property['id']);
                            },
                          );
                        },
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/add_property');
        },
        backgroundColor: addPropertyColor,
        child: const Icon(Icons.add),
        tooltip: 'Tambah Properti Baru',
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Future<void> _togglePropertyStatus(int? propertyId) async {
    if (propertyId == null) return;
    
    try {
      setState(() {
        _isLoading = true;
      });
      
      await ApiClient().put(
        '/properties/$propertyId/toggle-status',
      );
      
      // Refresh data setelah toggle status
      _loadProperties();
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Status properti berhasil diubah'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      log('Error saat mengubah status properti: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal mengubah status properti: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: 1, // Properti adalah halaman aktif
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.apartment),
          label: 'Properti',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.book_online),
          label: 'Booking',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.message),
          label: 'Ulasan',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
      onTap: (index) {
        switch (index) {
          case 0: // Home/Dashboard
            Navigator.pushReplacementNamed(context, '/dashboard');
            break;
          case 1: // Properti
            // Sudah di halaman properti
            break;
          case 2: // Booking
            Navigator.pushReplacementNamed(context, '/bookings');
            break;
          case 3: // Ulasan
            Navigator.pushReplacementNamed(context, '/reviews');
            break;
          case 4: // Profile
            Navigator.pushReplacementNamed(context, '/profile');
            break;
        }
      },
    );
  }
}
