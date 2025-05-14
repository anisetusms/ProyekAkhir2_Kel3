import 'package:flutter/material.dart';
import 'package:front/core/network/api_client.dart';
import 'package:front/features/property/data/models/property_model.dart';
import 'package:front/features/dashboard/presentation/screens/users/penyewa/property_detail_screen.dart';
import 'package:front/features/dashboard/presentation/screens/users/penyewa/home_header.dart';
import 'package:front/core/utils/constants.dart';

class AllPropertiesScreen extends StatefulWidget {
  const AllPropertiesScreen({super.key});

  @override
  _AllPropertiesScreenState createState() => _AllPropertiesScreenState();
}

class _AllPropertiesScreenState extends State<AllPropertiesScreen> {
  List<PropertyModel> allProperties = [];
  String _errorMessage = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAllProperties();
  }

  Future<void> _loadAllProperties() async {
    try {
      final response = await ApiClient().get('/propertiescustomer');
      if (response != null && response is List) {
        final properties = <PropertyModel>[];

        for (var item in response) {
          try {
            properties.add(PropertyModel.fromJson(item));
          } catch (e) {
            print('Error parsing property: $e');
            print('Property data: $item');
          }
        }

        setState(() {
          allProperties = properties;
          _errorMessage =
              properties.isEmpty ? 'Tidak ada properti ditemukan.' : '';
        });
      } else {
        setState(() {
          _errorMessage = 'Format data tidak valid';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage =
            'Terjadi kesalahan saat mengambil data properti: ${e.toString()}';
      });
      print('Error: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget _buildPropertyCard(PropertyModel property) {
    final imageUrl = property.image != null
        ? '${Constants.baseUrlImage}/storage/${property.image}'
        : Constants.defaultPropertyImage;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PropertyDetailScreen(propertyId: property.id),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar Properti
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
              child: Container(
                height: 120,
                width: double.infinity,
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      _buildImagePlaceholder(),
                ),
              ),
            ),
            
            // Detail Properti
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nama Properti
                  Text(
                    property.name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  
                  const SizedBox(height: 4),
                  
                  // Lokasi
                  Text(
                    property.address,
                    style: TextStyle(
                      color: Colors.grey[600], 
                      fontSize: 12
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // Harga dan Rating
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Harga
                      Flexible(
                        child: Text(
                          'Rp ${property.price.toStringAsFixed(0).replaceAllMapped(
                            RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))/ Bulan'), 
                            (Match m) => '${m[1]}.'
                          )}',
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      
                      // Rating
                      Row(
                        children: [
                          const Icon(
                            Icons.star,
                            size: 14,
                            color: Colors.orange,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            '5.0',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePlaceholder() {
    return Container(
      height: 120,
      color: Colors.grey[200],
      child: const Center(
        child: Icon(Icons.home, size: 40, color: Colors.grey),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: DashboardHeader(),
            ),
            
            if (_errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  _errorMessage,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : allProperties.isEmpty
                      ? const Center(child: Text('Tidak ada data'))
                      : GridView.builder(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8, 
                            vertical: 8
                          ),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.75,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                          ),
                          itemCount: allProperties.length,
                          itemBuilder: (context, index) {
                            return _buildPropertyCard(allProperties[index]);
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}