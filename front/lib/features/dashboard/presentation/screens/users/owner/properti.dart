import 'package:flutter/material.dart';
import 'package:front/core/network/api_client.dart';
import 'package:front/core/utils/constants.dart';
import 'package:front/features/property/presentation/widgets/property_card.dart';
import 'package:front/features/property/presentation/screens/property_detail.dart';
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
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadProperties,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(_errorMessage!),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadProperties,
                        child: const Text('Coba Lagi'),
                      ),
                    ],
                  ),
                )
              : FutureBuilder<List<dynamic>>(
                  future: _propertiesFuture,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(
                        child: Text('Error: ${snapshot.error}'),
                      );
                    }

                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(
                        child: Text('Belum ada properti yang ditambahkan.'),
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
        child: const Icon(Icons.add),
        tooltip: 'Tambah Properti Baru',
      ),
    );
  }
}