import 'package:flutter/material.dart';
import 'package:front/core/network/api_client.dart';
import 'package:front/core/utils/constants.dart';
import 'package:front/features/property/presentation/widgets/property_card.dart';
import 'package:front/features/property/presentation/screens/property_detail.dart';
import 'dart:developer'; // Import untuk log

class PropertyListScreen extends StatefulWidget {
  static const routeName = '/properties';

  @override
  _PropertyListScreenState createState() => _PropertyListScreenState();
}

class _PropertyListScreenState extends State<PropertyListScreen> {
  late Future<List<dynamic>> _propertiesFuture;

  @override
  void initState() {
    super.initState();
    _propertiesFuture = _fetchProperties();
  }

  Future<List<dynamic>> _fetchProperties() async {
    try {
      final response = await ApiClient().get('${Constants.baseUrl}/properties');
      log(
        'Response from /properties: ${response.body}',
      ); // Log seluruh response
      return response['data'] as List<dynamic>;
    } catch (e) {
      // Handle error appropriately
      print('Error fetching properties: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Daftar Properti Anda')),
      body: FutureBuilder<List<dynamic>>(
        future: _propertiesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Gagal memuat properti: ${snapshot.error}'),
            );
          } else if (snapshot.hasData) {
            final properties = snapshot.data!;
            log('Data Properti Setelah Parsing: $properties'); // Tambahkan ini
            if (properties.isEmpty) {
              return Center(
                child: Text('Belum ada properti yang ditambahkan.'),
              );
            }
            return ListView.builder(
              itemCount: properties.length,
              itemBuilder: (context, index) {
                final property = properties[index];
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
            );
          } else {
            return Center(child: Text('Tidak ada data properti.'));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(
            context,
            '/add_property',
          ); // Asumsi ada route untuk tambah properti
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
