import 'package:flutter/material.dart';
import 'package:front/core/network/api_client.dart';
import 'package:front/core/utils/constants.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:developer';

class PropertyDetailScreen extends StatefulWidget {
  static const routeName = '/property_detail';

  @override
  _PropertyDetailScreenState createState() => _PropertyDetailScreenState();
}

class _PropertyDetailScreenState extends State<PropertyDetailScreen> {
  late Future<dynamic> _propertyFuture;
  int? _propertyId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    
    if (args is int) {
      _propertyId = args;
    } else if (args is Map<String, dynamic>) {
      _propertyId = args['id'];
    }

    if (_propertyId != null) {
      _propertyFuture = _fetchPropertyDetails(_propertyId!);
    } else {
      _propertyFuture = Future.error('ID properti tidak valid');
      log('Error: ID properti tidak ditemukan atau tidak valid');
    }
  }

  Future<dynamic> _fetchPropertyDetails(int id) async {
    try {
      log('Fetching property details for ID: $id');
      final response = await ApiClient().get('${Constants.baseUrl}/properties/$id');
      
      // Log response untuk debugging
      log('API Response: $response');
      
      if (response == null) {
        throw Exception('Response null dari server');
      }
      
      // Periksa struktur response
      if (response is Map<String, dynamic>) {
        if (response.containsKey('success') && response['success'] == false) {
          throw Exception(response['message'] ?? 'Gagal memuat detail properti');
        }
        
        if (response.containsKey('data')) {
          return response['data'];
        } else {
          // Jika tidak ada field 'data', gunakan response langsung
          return response;
        }
      }
      
      return response; // Fallback
    } catch (e) {
      log('Error fetching property details: $e');
      throw Exception('Gagal memuat detail properti: ${e.toString()}');
    }
  }

  void _logPropertyData(dynamic property) {
    try {
      log('Property data structure:');
      if (property is Map<String, dynamic>) {
        property.forEach((key, value) {
          log('$key: $value (${value?.runtimeType})');
        });
      } else {
        log('Property is not a Map: ${property.runtimeType}');
      }
    } catch (e) {
      log('Error logging property data: $e');
    }
  }

  Future<void> _openMap(double? latitude, double? longitude, String? address) async {
    String? url;
    if (latitude != null && longitude != null) {
      url = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    } else if (address != null && address.isNotEmpty) {
      url = 'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(address)}';
    }

    if (url != null) {
      try {
        if (await canLaunchUrl(Uri.parse(url))) {
          await launchUrl(Uri.parse(url));
        } else {
          throw Exception('Tidak dapat membuka peta');
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Tidak dapat membuka peta: ${e.toString()}')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lokasi tidak tersedia')),
      );
    }
  }

  String _getImageUrl(dynamic property) {
    try {
      if (property['image'] == null || property['image'].toString().isEmpty) {
        return '';
      }

      String imagePath = property['image'].toString();

      // Normalisasi path gambar
      if (imagePath.startsWith('http')) {
        return imagePath; // Jika sudah full URL
      }

      // Hapus awalan '/' atau 'storage/'
      imagePath = imagePath.replaceAll(RegExp(r'^\/'), '').replaceAll(RegExp(r'^storage\/'), '');

      // Pastikan base URL tidak memiliki trailing slash
      final base = Constants.baseUrl.replaceAll(RegExp(r'\/$'), '');
      
      return '$base/storage/$imagePath';
    } catch (e) {
      log('Error constructing image URL: $e');
      return '';
    }
  }

  Widget _buildImageWidget(dynamic property) {
    final imageUrl = _getImageUrl(property);

    if (imageUrl.isEmpty) {
      return _buildPlaceholderImage();
    }

    log('Loading image from URL: $imageUrl');

    return CachedNetworkImage(
      imageUrl: imageUrl,
      width: double.infinity,
      height: 200,
      fit: BoxFit.cover,
      placeholder: (context, url) => _buildLoadingIndicator(),
      errorWidget: (context, url, error) {
        log('Error loading image from $imageUrl: $error');
        return _buildPlaceholderImage();
      },
    );
  }

  Widget _buildLoadingIndicator() {
    return Container(
      height: 200,
      width: double.infinity,
      color: Colors.grey[200],
      child: const Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      height: 200,
      width: double.infinity,
      color: Colors.grey[200],
      child: const Center(
        child: Icon(Icons.home, size: 50, color: Colors.grey),
      ),
    );
  }

  Widget _buildErrorWidget(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 50, color: Colors.red),
          SizedBox(height: 16),
          Text(
            'Gagal memuat data',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Text(
              error,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              setState(() {
                if (_propertyId != null) {
                  _propertyFuture = _fetchPropertyDetails(_propertyId!);
                }
              });
            },
            child: Text('Coba Lagi'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Properti'),
      ),
      body: FutureBuilder<dynamic>(
        future: _propertyFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildLoadingIndicator();
          }

          if (snapshot.hasError) {
            log('Error in FutureBuilder: ${snapshot.error}');
            return _buildErrorWidget(snapshot.error.toString());
          }

          if (!snapshot.hasData) {
            return _buildErrorWidget('Data properti tidak ditemukan');
          }

          final property = snapshot.data!;
          _logPropertyData(property); // Tambahkan logging untuk debugging
          
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _buildImageWidget(property),
                SizedBox(height: 16.0),
                Text(
                  property['name'] ?? 'Nama Properti',
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8.0),
                Row(
                  children: [
                    Icon(Icons.location_on, color: Colors.grey[600]),
                    SizedBox(width: 4.0),
                    Expanded(
                      child: Text(
                        property['address'] ?? 'Alamat tidak tersedia',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.map),
                      onPressed: () => _openMap(
                        property['latitude'] != null ? double.tryParse(property['latitude'].toString()) : null,
                        property['longitude'] != null ? double.tryParse(property['longitude'].toString()) : null,
                        property['address'],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.0),
                Text('Deskripsi:', style: TextStyle(fontWeight: FontWeight.bold)),
                Text(property['description'] ?? 'Tidak ada deskripsi'),
                SizedBox(height: 16.0),
                Text(
                  'Harga: Rp ${property['price']?.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                SizedBox(height: 16.0),
                
                // Cek tipe properti dari property_type_id atau property_type
                if (property['property_type_id'] == 1 || 
                    (property['property_type'] != null && 
                     property['property_type']['id'] == 1))
                  _buildKostDetails(property),
                
                if (property['property_type_id'] == 2 || 
                    (property['property_type'] != null && 
                     property['property_type']['id'] == 2))
                  _buildHomestayDetails(property),
                
                // Jika tidak ada detail spesifik, tampilkan informasi umum
                if (property['property_type_id'] == null && 
                    property['property_type'] == null)
                  _buildGeneralDetails(property),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildKostDetails(dynamic property) {
    // Cek apakah data kost ada di root atau di nested object
    final kostDetail = property['kost_detail'] ?? property['kostDetail'] ?? property;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 16.0),
        Text('Detail Kost:', style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 8.0),
        _buildDetailRow('Tipe Kost:', kostDetail['kost_type'] ?? '-'),
        _buildDetailRow('Total Kamar:', kostDetail['total_rooms']?.toString() ?? property['total_rooms']?.toString() ?? '-'),
        _buildDetailRow('Kamar Tersedia:', kostDetail['available_rooms']?.toString() ?? property['available_rooms']?.toString() ?? '-'),
        _buildDetailRow('Kapasitas:', '${property['capacity']?.toString() ?? '-'} Orang'),
        SizedBox(height: 8.0),
        Text('Peraturan:', style: TextStyle(fontWeight: FontWeight.bold)),
        Text(kostDetail['rules'] ?? property['rules'] ?? 'Tidak ada peraturan khusus'),
      ],
    );
  }

  Widget _buildHomestayDetails(dynamic property) {
    // Cek apakah data homestay ada di root atau di nested object
    final homestayDetail = property['homestay_detail'] ?? property['homestayDetail'] ?? property;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 16.0),
        Text('Detail Homestay:', style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 8.0),
        _buildDetailRow('Total Unit:', homestayDetail['total_units']?.toString() ?? property['total_units']?.toString() ?? '-'),
        _buildDetailRow('Unit Tersedia:', homestayDetail['available_units']?.toString() ?? property['available_units']?.toString() ?? '-'),
        _buildDetailRow('Minimum Menginap:', '${homestayDetail['minimum_stay']?.toString() ?? '-'} malam'),
        _buildDetailRow('Maksimum Tamu:', '${homestayDetail['maximum_guest']?.toString() ?? property['capacity']?.toString() ?? '-'} orang'),
        _buildDetailRow('Waktu Check-in:', homestayDetail['checkin_time'] ?? '-'),
        _buildDetailRow('Waktu Check-out:', homestayDetail['checkout_time'] ?? '-'),
      ],
    );
  }

  Widget _buildGeneralDetails(dynamic property) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 16.0),
        Text('Detail Umum:', style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 8.0),
        if (property['capacity'] != null)
          _buildDetailRow('Kapasitas:', '${property['capacity']} Orang'),
        if (property['available_rooms'] != null)
          _buildDetailRow('Kamar Tersedia:', property['available_rooms'].toString()),
        if (property['rules'] != null) ...[
          SizedBox(height: 8.0),
          Text('Peraturan:', style: TextStyle(fontWeight: FontWeight.bold)),
          Text(property['rules']),
        ],
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(label, style: TextStyle(fontWeight: FontWeight.w500)),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
