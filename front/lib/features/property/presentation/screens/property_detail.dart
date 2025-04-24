import 'package:flutter/material.dart';
import 'package:front/core/network/api_client.dart';
import 'package:front/core/utils/constants.dart';
import 'package:url_launcher/url_launcher.dart'; // Import untuk membuka peta

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
    _propertyId = ModalRoute.of(context)?.settings.arguments as int?;
    if (_propertyId != null) {
      _propertyFuture = _fetchPropertyDetails(_propertyId!);
    } else {
      // Handle jika tidak ada ID
      _propertyFuture = Future.error('ID properti tidak ditemukan.');
    }
  }

  Future<dynamic> _fetchPropertyDetails(int id) async {
    try {
      final response = await ApiClient().get('${Constants.baseUrl}/properties/$id');
      return response;
    } catch (e) {
      // Handle error appropriately
      print('Error fetching property details: $e');
      return Future.error('Gagal memuat detail properti.');
    }
  }

  // Fungsi untuk membuka peta
  Future<void> _openMap(double? latitude, double? longitude, String? address) async {
    if (latitude != null && longitude != null) {
      final url = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Tidak dapat membuka peta.')),
        );
      }
    } else if (address != null && address.isNotEmpty) {
      final url = 'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(address)}';
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Tidak dapat membuka peta.')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lokasi tidak tersedia.')),
      );
    }
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
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Gagal memuat detail: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final property = snapshot.data!;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  if (property['image'] != null)
                    Image.network(
                      '${Constants.baseUrl}/storage/properties/${property['image']}',
                      width: double.infinity,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
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
                          property['address'] ?? 'Alamat',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ),
                      if (property['latitude'] != null && property['longitude'] != null || property['address'] != null && property['address'].isNotEmpty)
                        IconButton(
                          icon: Icon(Icons.map),
                          onPressed: () {
                            _openMap(
                              property['latitude']?.toDouble(),
                              property['longitude']?.toDouble(),
                              property['address'],
                            );
                          },
                        ),
                    ],
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    'Deskripsi:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(property['description'] ?? 'Tidak ada deskripsi.'),
                  SizedBox(height: 16.0),
                  Text(
                    'Harga: Rp ${property['price'] ?? '0'}',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16.0),
                  if (property['property_type_id'] == 1 &&
                      property['kost_detail'] != null)
                    _buildKostDetails(property['kost_detail']),
                  if (property['property_type_id'] == 2 &&
                      property['homestay_detail'] != null)
                    _buildHomestayDetails(property['homestay_detail']),
                  // Tambahkan detail lain sesuai kebutuhan
                ],
              ),
            );
          } else {
            return Center(child: Text('Detail properti tidak ditemukan.'));
          }
        },
      ),
    );
  }

  Widget _buildKostDetails(dynamic details) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('Detail Kost:', style: TextStyle(fontWeight: FontWeight.bold)),
        Text('Tipe: ${details['kost_type'] ?? '-'}'),
        Text('Total Kamar: ${details['total_rooms'] ?? '-'}'),
        Text('Kamar Tersedia: ${details['available_rooms'] ?? '-'}'),
        Text('Kapasitas: ${details['capacity'] ?? '-'} Orang'),
        Text('Makan Termasuk: ${details['meal_included'] ? 'Ya' : 'Tidak'}'),
        Text('Laundry Termasuk: ${details['laundry_included'] ? 'Ya' : 'Tidak'}'),
        Text('Peraturan: ${details['rules'] ?? '-'}'),
      ],
    );
  }

  Widget _buildHomestayDetails(dynamic details) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('Detail Homestay:', style: TextStyle(fontWeight: FontWeight.bold)),
        Text('Total Unit: ${details['total_units'] ?? '-'}'),
        Text('Unit Tersedia: ${details['available_units'] ?? '-'}'),
        Text('Minimum Menginap: ${details['minimum_stay'] ?? '-'} malam'),
        Text('Maksimum Tamu: ${details['maximum_guest'] ?? '-'} orang'),
        Text('Waktu Check-in: ${details['checkin_time'] ?? '-'}'),
        Text('Waktu Check-out: ${details['checkout_time'] ?? '-'}'),
      ],
    );
  }
}