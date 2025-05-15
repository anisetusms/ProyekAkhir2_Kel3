import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import 'package:front/core/network/api_client.dart';
import 'package:front/features/property/data/models/new_model.dart';
import 'package:front/features/dashboard/presentation/screens/users/penyewa/search_result_screen.dart';
import 'package:front/features/dashboard/presentation/screens/users/penyewa/filter_dialog.dart';
import 'package:front/features/dashboard/presentation/screens/users/penyewa/property_detail_screen.dart';
import 'package:front/core/utils/constants.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedPropertyType = 'Semua';
  String _selectedPriceRange = 'Semua';
  String _selectedLocation = 'Semua';
  List<PropertyModel> _properties = [];
  Map<int, double> _distanceMap = {}; // Simpan jarak berdasarkan ID properti
  bool _isLoading = true;
  Position? _currentPosition;
  String _currentAddress = 'Mendeteksi lokasi...';
  bool _locationAvailable = false;
  
  // Konstanta untuk filter jarak
  final double _maxDistance = 5000; // 5km dalam meter

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    setState(() {
      _isLoading = true;
      _properties = [];
      _distanceMap = {};
    });
    
    await _getCurrentLocation();
    await _fetchProperties();
    
    setState(() {
      _isLoading = false;
    });
  }

  // Get current location using geolocator
  Future<void> _getCurrentLocation() async {
    try {
      // Cek apakah layanan lokasi aktif
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (mounted) {
          setState(() {
            _currentAddress = 'Lokasi tidak aktif';
            _locationAvailable = false;
          });
        }
        print('[DEBUG] Lokasi tidak aktif');
        return;
      }

      // Cek izin lokasi
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          print('[DEBUG] Izin lokasi ditolak');
          if (mounted) {
            setState(() {
              _currentAddress = 'Izin lokasi ditolak';
              _locationAvailable = false;
            });
          }
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        print('[DEBUG] Izin lokasi ditolak permanen');
        if (mounted) {
          setState(() {
            _currentAddress = 'Izin lokasi ditolak permanen';
            _locationAvailable = false;
          });
        }
        return;
      }

      // Ambil posisi pengguna dengan timeout
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      ).catchError((error) {
        print('[DEBUG] Error getting position: $error');
        return Position(
          latitude: 0,
          longitude: 0,
          timestamp: DateTime.now(),
          accuracy: 0,
          altitude: 0,
          heading: 0,
          speed: 0,
          speedAccuracy: 0,
          altitudeAccuracy: 0,
          headingAccuracy: 0,
        );
      });

      if (position.latitude != 0 && position.longitude != 0) {
        print('[DEBUG] Lokasi pengguna: ${position.latitude}, ${position.longitude}');
        if (mounted) {
          setState(() {
            _currentPosition = position;
            _currentAddress = 'Lokasi saat ini';
            _locationAvailable = true;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _currentAddress = 'Gagal mendapatkan lokasi';
            _locationAvailable = false;
          });
        }
      }
    } catch (e) {
      print('[DEBUG] Error mendapatkan lokasi: $e');
      if (mounted) {
        setState(() {
          _currentAddress = 'Gagal mendapatkan lokasi';
          _locationAvailable = false;
        });
      }
    }
  }

  // Fetch properties
  Future<void> _fetchProperties() async {
    if (!mounted) return;
    
    try {
      final response = await ApiClient().get('/properties1');
      
      if (!mounted) return;
      
      if (response != null && response['data'] != null) {
        List<PropertyModel> allProperties = [];
        Map<int, double> distances = {};
        
        try {
          List<dynamic> dataList = response['data'] as List;
          
          for (var item in dataList) {
            try {
              PropertyModel property = PropertyModel.fromJson(item);
              
              // Hitung jarak jika lokasi tersedia dan koordinat valid
              if (_currentPosition != null && property.hasValidCoordinates) {
                try {
                  double distance = property.distanceFrom(
                    _currentPosition!.latitude,
                    _currentPosition!.longitude,
                  ) ?? double.infinity;
                  
                  // Hanya tambahkan properti dalam jarak 5km
                  if (distance <= _maxDistance) {
                    allProperties.add(property);
                    distances[property.id] = distance;
                    print('[DEBUG] Properti "${property.name}" berjarak ${distance.toStringAsFixed(2)} meter (dalam jangkauan)');
                  } else {
                    print('[DEBUG] Properti "${property.name}" berjarak ${distance.toStringAsFixed(2)} meter (di luar jangkauan)');
                  }
                } catch (e) {
                  print('[DEBUG] Error calculating distance for ${property.name}: $e');
                }
              } else {
                // Jika lokasi tidak tersedia atau koordinat tidak valid
                if (!property.hasValidCoordinates) {
                  print('[DEBUG] Properti "${property.name}" memiliki koordinat tidak valid');
                }
                
                // Tambahkan properti tanpa jarak jika lokasi pengguna tidak tersedia
                if (_currentPosition == null) {
                  allProperties.add(property);
                }
              }
            } catch (e) {
              print('[DEBUG] Error parsing property: $e');
            }
          }
        } catch (e) {
          print('[DEBUG] Error parsing properties list: $e');
        }

        print('[DEBUG] Jumlah properti dalam jangkauan 5km: ${allProperties.length}');

        // Filter berdasarkan tipe jika dipilih
        if (_selectedPropertyType != 'Semua') {
          allProperties = allProperties.where((property) {
            return _selectedPropertyType == 'Kost'
                ? property.isKost
                : property.isHomestay;
          }).toList();
        }
        
        // Urutkan berdasarkan jarak
        allProperties.sort((a, b) {
          double distanceA = distances[a.id] ?? double.infinity;
          double distanceB = distances[b.id] ?? double.infinity;
          return distanceA.compareTo(distanceB);
        });
        
        if (mounted) {
          setState(() {
            _properties = allProperties;
            _distanceMap = distances;
          });
        }
      } else {
        print('[DEBUG] Response API kosong atau tidak valid');
      }
    } catch (e) {
      print('[DEBUG] Error fetching properties: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Search Bar with filter button
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.search, color: Colors.black54),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              decoration: const InputDecoration(
                                hintText: "Cari kost atau homestay...",
                                border: InputBorder.none,
                                isDense: true,
                              ),
                              onSubmitted: (value) {
                                if (value.isNotEmpty) {
                                  _navigateToSearchResults(value);
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  InkWell(
                    onTap: () => _showFilterDialog(),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.tune, color: Colors.black54),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Current Location and Range Info
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        size: 20,
                        color: Colors.black54,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          _currentAddress,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      // Tombol refresh
                      IconButton(
                        icon: const Icon(Icons.refresh, size: 20),
                        onPressed: _initializeData,
                      ),
                    ],
                  ),
                  
                  // Informasi jangkauan
                  if (_locationAvailable)
                    Padding(
                      padding: const EdgeInsets.only(left: 24),
                    ),
                ],
              ),

              const SizedBox(height: 16),

              // Properties List
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _properties.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.location_off,
                              size: 48,
                              color: Colors.grey.shade400,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              _locationAvailable 
                                  ? 'Tidak ada properti dalam jarak 5 km'
                                  : 'Aktifkan lokasi untuk melihat properti terdekat',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            ElevatedButton(
                              onPressed: _initializeData,
                              child: const Text('Coba Lagi'),
                            ),
                          ],
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: _initializeData,
                        child: GridView.builder(
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
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemCount: _properties.length,
                          itemBuilder: (context, index) {
                            final property = _properties[index];
                            final distance = _distanceMap[property.id];
                            
                            return _buildPropertyCard(property, distance);
                          },
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Kartu properti dengan desain dari AllPropertiesScreen
  Widget _buildPropertyCard(PropertyModel property, double? distance) {
    final imageUrl = property.image != null
        ? '${Constants.baseUrlImage}/storage/${property.image}'
        : Constants.defaultPropertyImage;

    // Tentukan warna dan teks jarak
    Color distanceColor = Colors.black54;
    String distanceText = '';
    
    if (distance != null) {
      if (distance < 100) {
        distanceColor = Colors.green.shade700;
      } else if (distance < 1000) {
        distanceColor = Colors.orange;
      } else {
        distanceColor = Colors.blue.shade700;
      }
      
      if (distance < 1000) {
        distanceText = '${distance.toStringAsFixed(0)}m';
      } else {
        distanceText = '${(distance / 1000).toStringAsFixed(1)}km';
      }
    }

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
            // Gambar Properti dengan Badge Jarak
            Stack(
              children: [
                // Gambar properti
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
                
                // Badge tipe properti
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      property.isKost ? 'Kost' : 'Homestay',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: property.isKost ? Colors.blue : Colors.green,
                      ),
                    ),
                  ),
                ),
                
                // Badge jarak
                if (distance != null)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.directions_walk,
                            size: 10,
                            color: distanceColor,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            distanceText,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: distanceColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
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
                  
                  // Harga dan Jarak
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Harga
                      Flexible(
                        child: Text(
                          'Rp ${_formatPrice(property.price)}',
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      
                      // Jarak sebagai "rating"
                      // if (distance != null)
                      //   Row(
                      //     children: [
                      //       Icon(
                      //         Icons.directions_walk,
                      //         size: 14,
                      //         color: distanceColor,
                      //       ),
                      //       const SizedBox(width: 2),
                      //       Text(
                      //         distanceText,
                      //         style: TextStyle(
                      //           color: distanceColor,
                      //           fontSize: 12,
                      //           fontWeight: FontWeight.w500,
                      //         ),
                      //       ),
                      //     ],
                      //   ),
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

  // Format harga dengan pemisah ribuan
  String _formatPrice(dynamic price) {
    try {
      if (price is String) {
        price = double.tryParse(price) ?? 0;
      }
      
      if (price is double || price is int) {
        return price.toString().replaceAllMapped(
              RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
              (Match m) => '${m[1]}.',
            );
      }
      
      return '0';
    } catch (e) {
      return '0';
    }
  }

  void _showFilterDialog() async {
    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (context) => FilterDialog(
        initialPropertyType: _selectedPropertyType,
        initialPriceRange: _selectedPriceRange,
        initialLocation: _selectedLocation,
      ),
    );

    if (result != null) {
      setState(() {
        _selectedPropertyType = result['propertyType']!;
        _selectedPriceRange = result['priceRange']!;
        _selectedLocation = result['location']!;
      });
      _fetchProperties();
    }
  }

  void _navigateToSearchResults(String keyword) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchResultScreen(
          searchKeyword: keyword,
          propertyType: _selectedPropertyType,
          priceRange: _selectedPriceRange,
          location: _selectedLocation,
        ),
      ),
    );
  }
}