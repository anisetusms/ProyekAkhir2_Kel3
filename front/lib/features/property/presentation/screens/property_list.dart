import 'package:flutter/material.dart';
import 'package:front/core/network/api_client.dart';
import 'package:front/core/utils/constants.dart';
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
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadProperties();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadProperties() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await ApiClient().get('${Constants.baseUrl}/properties');
      log('Response dari API: ${response.toString()}');

      if (response == null || response['data'] == null) {
        throw Exception('Respon API tidak valid');
      }

      if (response['data'] is! List) {
        throw Exception('Format data tidak sesuai');
      }

      setState(() {
        _propertiesFuture = Future.value(response['data'] as List<dynamic>);
      });
    } catch (e) {
      log('Error saat memuat properti: $e');
      setState(() {
        _errorMessage = 'Gagal memuat data properti. Silakan coba lagi.';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Map<String, dynamic> _parseProperty(dynamic propertyData) {
    final Map<String, dynamic> property = {};
    if (propertyData is Map) {
      propertyData.forEach((key, value) {
        property[key.toString()] = value;
      });
      // Gunakan isDeleted sebagai indikator status
      property['status'] = propertyData['isDeleted'] == false ? 'active' : 'inactive';
    }
    property['price'] = double.tryParse(property['price']?.toString() ?? '0') ?? 0.0;
    return property;
  }

  Widget _buildPropertyCard(BuildContext context, dynamic propertyData) {
    final property = _parseProperty(propertyData);
    log('Data properti yang dikirim ke PropertyCard: $property');
    log('Tipe data harga sebelum ke PropertyCard: ${property['price'].runtimeType}, nilai: ${property['price']}');
    return PropertyCard(
      property: property,
      onTap: () {
        Navigator.pushNamed(
          context,
          PropertyDetailScreen.routeName,
          arguments: property['id'],
        );
      },
      onManageRooms: () {
        Navigator.pushNamed(
          context,
          '/manage_rooms',
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kelola Properti'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadProperties,
            tooltip: 'Refresh',
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
                        message: 'Terjadi kesalahan: ${snapshot.error}',
                        onRetry: _loadProperties,
                      );
                    }

                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.home_work_outlined,
                              size: 64,
                              color: Colors.grey,
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Belum ada properti yang ditambahkan',
                              style: TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton.icon(
                              icon: const Icon(Icons.add),
                              label: const Text('Tambah Properti Baru'),
                              onPressed: () {
                                Navigator.pushNamed(context, '/add_property');
                              },
                            ),
                          ],
                        ),
                      );
                    }

                    return RefreshIndicator(
                      onRefresh: _loadProperties,
                      child: ListView.builder(
                        controller: _scrollController,
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          return _buildPropertyCard(
                              context, snapshot.data![index]);
                        },
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, '/add_property');
        },
        icon: const Icon(Icons.add),
        label: const Text('Tambah Properti'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }
}