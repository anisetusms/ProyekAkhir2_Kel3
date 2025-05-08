import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:front/core/network/api_client.dart';
import 'package:front/features/property/data/models/property_model.dart';
import 'package:front/features/dashboard/presentation/screens/users/penyewa/search_result_screen.dart';
import 'package:front/features/dashboard/presentation/screens/users/penyewa/filter_dialog.dart';

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
  List<PropertyModel> _nearbyProperties = [];
  bool _isLoading = true;
  Position? _currentPosition;
  String _currentAddress = 'Mendeteksi lokasi...';

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _fetchNearbyProperties();
  }

  Future<void> _getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          _currentAddress = 'Lokasi tidak aktif';
        });
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        // Meminta izin lokasi
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _showPermissionDialog(
            'Izin lokasi ditolak',
            'Aplikasi memerlukan izin lokasi untuk berfungsi.',
          );
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _showPermissionDialog(
          'Izin lokasi ditolak permanen',
          'Pergi ke pengaturan untuk mengaktifkan izin lokasi.',
        );
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );

      setState(() {
        _currentPosition = position;
        _currentAddress = 'Lokasi saat ini';
      });
    } catch (e) {
      setState(() {
        _currentAddress = 'Gagal mendapatkan lokasi';
      });
    }
  }

  // Menampilkan dialog pemberitahuan izin lokasi
  void _showPermissionDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('Tutup'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Pengaturan'),
              onPressed: () async {
                Navigator.of(context).pop();
                await Geolocator.openLocationSettings(); // Mengarahkan ke pengaturan lokasi
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _fetchNearbyProperties() async {
    try {
      setState(() {
        _isLoading = true;
        _nearbyProperties = [];
      });

      // 1. Ambil semua properti dari API
      final response = await ApiClient().get('/properties');

      if (response != null && response['data'] != null) {
        List<PropertyModel> allProperties =
            (response['data'] as List)
                .map((item) => PropertyModel.fromJson(item))
                .toList();

        // 2. Filter dan urutkan berdasarkan jarak jika ada lokasi pengguna
        if (_currentPosition != null) {
          allProperties.sort((a, b) {
            if (a.latitude == null || a.longitude == null) return 1;
            if (b.latitude == null || b.longitude == null) return -1;

            double distanceA = Geolocator.distanceBetween(
              _currentPosition!.latitude,
              _currentPosition!.longitude,
              a.latitude!,
              a.longitude!,
            );

            double distanceB = Geolocator.distanceBetween(
              _currentPosition!.latitude,
              _currentPosition!.longitude,
              b.latitude!,
              b.longitude!,
            );

            return distanceA.compareTo(distanceB);
          });
        }

        // 3. Filter berdasarkan tipe properti jika dipilih
        if (_selectedPropertyType != 'Semua') {
          allProperties =
              allProperties.where((property) {
                return _selectedPropertyType == 'Kost'
                    ? property.isKost
                    : property.isHomestay;
              }).toList();
        }

        setState(() {
          _nearbyProperties = allProperties;
        });
      }
    } catch (e) {
      print('Error fetching properties: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
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
              // Search Bar dengan tombol filter
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

              // Lokasi
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
                ],
              ),

              const SizedBox(height: 16),

              // Filter buttons
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildFilterButton(
                      "Semua",
                      _selectedPropertyType == "Semua",
                      () {
                        setState(() {
                          _selectedPropertyType = "Semua";
                          _fetchNearbyProperties();
                        });
                      },
                    ),
                    const SizedBox(width: 8),
                    _buildFilterButton(
                      "Kost",
                      _selectedPropertyType == "Kost",
                      () {
                        setState(() {
                          _selectedPropertyType = "Kost";
                          _fetchNearbyProperties();
                        });
                      },
                    ),
                    const SizedBox(width: 8),
                    _buildFilterButton(
                      "Homestay",
                      _selectedPropertyType == "Homestay",
                      () {
                        setState(() {
                          _selectedPropertyType = "Homestay";
                          _fetchNearbyProperties();
                        });
                      },
                    ),
                    const SizedBox(width: 8),
                    _buildFilterButton(
                      "< Rp1jt",
                      _selectedPriceRange == "< Rp1jt",
                      () {
                        setState(() {
                          _selectedPriceRange = "< Rp1jt";
                          _fetchNearbyProperties();
                        });
                      },
                    ),
                    const SizedBox(width: 8),
                    _buildFilterButton(
                      "Rp1jt - Rp3jt",
                      _selectedPriceRange == "Rp1jt - Rp3jt",
                      () {
                        setState(() {
                          _selectedPriceRange = "Rp1jt - Rp3jt";
                          _fetchNearbyProperties();
                        });
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Daftar Properti Terdekat
              Expanded(
                child:
                    _isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : _nearbyProperties.isEmpty
                        ? const Center(
                          child: Text('Tidak ada properti terdekat'),
                        )
                        : ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          itemCount: _nearbyProperties.length,
                          itemBuilder: (context, index) {
                            final property = _nearbyProperties[index];
                            return _buildPropertyCard(property);
                          },
                        ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterButton(String label, bool selected, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? Colors.deepOrange : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildPropertyCard(PropertyModel property) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          // Navigasi ke detail properti
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar properti
            Container(
              height: 180,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
                image:
                    property.image != null
                        ? DecorationImage(
                          image: NetworkImage(property.imageUrl),
                          fit: BoxFit.cover,
                        )
                        : null,
              ),
              child:
                  property.image == null
                      ? const Center(
                        child: Icon(Icons.home, size: 40, color: Colors.grey),
                      )
                      : null,
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    property.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    property.address,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Rp ${property.price.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')} / bulan',
                        style: const TextStyle(
                          color: Colors.deepOrange,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          property.isKost ? 'Kost' : 'Homestay',
                          style: const TextStyle(fontSize: 12),
                        ),
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

  void _showFilterDialog() async {
    final result = await showDialog<Map<String, String>>(
      context: context,
      builder:
          (context) => FilterDialog(
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
      _fetchNearbyProperties();
    }
  }

  void _navigateToSearchResults(String keyword) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => SearchResultScreen(
              searchKeyword: keyword,
              propertyType: _selectedPropertyType,
              priceRange: _selectedPriceRange,
              location: _selectedLocation,
            ),
      ),
    );
  }
}
