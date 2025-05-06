import 'package:flutter/material.dart';
import 'package:front/core/network/api_client.dart';
import 'package:front/features/property/data/models/property_model.dart';
import 'package:front/features/dashboard/presentation/screens/users/penyewa/property_detail_screen.dart';
import 'package:front/features/dashboard/presentation/screens/users/penyewa/home_header.dart';
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
        _errorMessage = properties.isEmpty ? 'Tidak ada properti ditemukan.' : '';
      });
    } else {
      setState(() {
        _errorMessage = 'Format data tidak valid';
      });
    }
  } catch (e) {
    setState(() {
      _errorMessage = 'Terjadi kesalahan saat mengambil data properti: ${e.toString()}';
    });
    print('Error: $e');
  } finally {
    setState(() {
      _isLoading = false;
    });
  }
}

  Widget _buildPropertyCard(PropertyModel property) {
  // Add your base URL if needed
  final imageUrl = property.image != null 
      ? 'https://your-api.com/storage/${property.image}'
      : null;

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
      margin: const EdgeInsets.only(bottom: 20),
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
          ClipRRect(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(12),
            ),
            child: imageUrl != null
                ? Image.network(
                    imageUrl,
                    height: 160,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => _buildImagePlaceholder(),
                  )
                : _buildImagePlaceholder(),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  property.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Text(
                  property.address,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Rp ${property.price} / Bulan',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.star,
                          size: 16,
                          color: Colors.orange,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '5.0',
                          style: TextStyle(
                            color: Colors.grey[600],
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
    height: 160,
    color: Colors.grey[200],
    child: const Center(
      child: Icon(Icons.home, size: 40, color: Colors.grey),
    ),
  );
}

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     backgroundColor: Colors.white,
  //     appBar: AppBar(
  //       title: const Text('Semua Properti'),
  //     ),
  //     body: SafeArea(
  //       child: _isLoading
  //           ? const Center(child: CircularProgressIndicator())
  //           : Padding(
  //               padding: const EdgeInsets.symmetric(horizontal: 16),
  //               child: Column(
  //                 children: [
  //                   const SizedBox(height: 20),
  //                   if (_errorMessage.isNotEmpty)
  //                     Padding(
  //                       padding: const EdgeInsets.all(8.0),
  //                       child: Text(
  //                         _errorMessage,
  //                         style: const TextStyle(color: Colors.red),
  //                       ),
  //                     ),
  //                   Expanded(
  //                     child: allProperties.isEmpty
  //                         ? const Center(child: Text('Tidak ada data'))
  //                         : ListView.builder(
  //                             itemCount: allProperties.length,
  //                             itemBuilder: (context, index) {
  //                               return _buildPropertyCard(allProperties[index]);
  //                             },
  //                           ),
  //                   ),
  //                   const SizedBox(height: 20),
  //                 ],
  //               ),
  //             ),
  //     ),
  //   );
  // }
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
          const SizedBox(height: 20),
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
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: allProperties.length,
                        itemBuilder: (context, index) {
                          return _buildPropertyCard(allProperties[index]);
                        },
                      ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    ),
  );
}

}
