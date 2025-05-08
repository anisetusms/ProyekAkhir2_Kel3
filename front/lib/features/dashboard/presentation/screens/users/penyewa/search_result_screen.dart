import 'dart:async';
import 'package:flutter/material.dart';
import 'package:front/core/network/api_client.dart';
import 'package:front/features/property/data/models/property_model.dart';
import 'package:front/features/dashboard/presentation/screens/users/penyewa/property_detail_screen.dart';
import 'package:front/features/dashboard/presentation/screens/users/penyewa/filter_dialog.dart';

class SearchResultScreen extends StatefulWidget {
  final String searchKeyword;
  final String propertyType;
  final String priceRange;
  final String location;

  const SearchResultScreen({
    Key? key,
    required this.searchKeyword,
    this.propertyType = 'Semua',
    this.priceRange = 'Semua',
    this.location = 'Semua',
  }) : super(key: key);

  @override
  State<SearchResultScreen> createState() => _SearchResultScreenState();
}

class _SearchResultScreenState extends State<SearchResultScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<PropertyModel> _filteredProperties = [];
  List<PropertyModel> _originalProperties = [];
  bool _isLoading = true;
  String _errorMessage = '';
  Timer? _debounce;

  // Variabel filter
  late String _propertyTypeFilter;
  late String _priceRangeFilter;
  late String _locationFilter;

  @override
  void initState() {
    super.initState();
    _searchController.text = widget.searchKeyword;
    _propertyTypeFilter = widget.propertyType;
    _priceRangeFilter = widget.priceRange;
    _locationFilter = widget.location;
    _fetchAndFilterProperties();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  Future<void> _fetchAndFilterProperties() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      // Membuat parameter query
      final Map<String, dynamic> queryParams = {
        'keyword': widget.searchKeyword,
      };

      // Tambahkan filter jika bukan 'Semua'
      if (_propertyTypeFilter != 'Semua') {
        queryParams['property_type'] = _propertyTypeFilter.toLowerCase();
      }

      final response = await ApiClient().get(
        '/property/search',
        queryParameters: queryParams,
      );

      if (response != null && response is Map && response.containsKey('data')) {
        final List<PropertyModel> results =
            (response['data'] as List).map((item) {
              return PropertyModel.fromJson(item);
            }).toList();

        setState(() {
          _originalProperties = results;
          // Terapkan filter
          _applyFilters();
        });
      } else {
        setState(() {
          _errorMessage = 'Format data tidak valid.';
          _filteredProperties = [];
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Gagal memuat data: ${e.toString()}';
        _filteredProperties = [];
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _applyFilters() {
    List<PropertyModel> filtered = List.from(_originalProperties);

    // Filter berdasarkan jenis properti
    if (_propertyTypeFilter != 'Semua') {
      if (_propertyTypeFilter == 'Kost') {
        filtered = filtered.where((property) => property.isKost).toList();
      } else if (_propertyTypeFilter == 'Homestay') {
        filtered = filtered.where((property) => property.isHomestay).toList();
      }
    }

    // Filter berdasarkan harga
    if (_priceRangeFilter != 'Semua') {
      switch (_priceRangeFilter) {
        case '< Rp1jt':
          filtered = filtered.where((property) => property.price < 1000000).toList();
          break;
        case 'Rp1jt - Rp3jt':
          filtered = filtered.where((property) => 
              property.price >= 1000000 && property.price <= 3000000).toList();
          break;
        case 'Rp3jt - Rp5jt':
          filtered = filtered.where((property) => 
              property.price >= 3000000 && property.price <= 5000000).toList();
          break;
        case '> Rp5jt':
          filtered = filtered.where((property) => property.price > 5000000).toList();
          break;
      }
    }

    // Filter berdasarkan lokasi
    if (_locationFilter != 'Semua') {
      if (_locationFilter == 'Terdekat') {
        // Implementasi sorting berdasarkan lokasi terdekat
        // (Di sini Anda perlu menambahkan logika geolokasi)
        filtered.sort((a, b) => 0); // Placeholder
      } else {
        filtered = filtered.where((property) => 
            property.address.toLowerCase().contains(_locationFilter.toLowerCase()))
            .toList();
      }
    }

    setState(() {
      _filteredProperties = filtered;
      _errorMessage = filtered.isEmpty 
          ? 'Tidak ada properti yang sesuai dengan filter.' 
          : '';
    });
  }

  // Fungsi untuk mendapatkan teks jenis properti
  String _getPropertyTypeText(PropertyModel property) {
    if (property.isKost) return 'Kost';
    if (property.isHomestay) return 'Homestay';
    return 'Unknown';
  }

  Widget _buildPropertyCard(PropertyModel property) {
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
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: imageUrl != null
                  ? Image.network(
                      imageUrl,
                      height: 160,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => 
                          _buildImagePlaceholder(),
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
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Rp ${property.price.toInt().toString().replaceAllMapped(
                          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), 
                          (Match m) => '${m[1]}.')} / Bulan',
                        style: const TextStyle(
                          color: Colors.deepOrange,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          _getPropertyTypeText(property),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[800],
                          ),
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

  Widget _buildImagePlaceholder() {
    return Container(
      height: 160,
      color: Colors.grey[200],
      child: const Center(
        child: Icon(Icons.home, size: 40, color: Colors.grey),
      ),
    );
  }

  void _performSearch(String keyword) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (keyword.isNotEmpty) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => SearchResultScreen(
              searchKeyword: keyword,
              propertyType: _propertyTypeFilter,
              priceRange: _priceRangeFilter,
              location: _locationFilter,
            ),
          ),
        );
      }
    });
  }

  void _showFilterDialog() async {
    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (context) => FilterDialog(
        initialPropertyType: _propertyTypeFilter,
        initialPriceRange: _priceRangeFilter,
        initialLocation: _locationFilter,
      ),
    );

    if (result != null) {
      setState(() {
        _propertyTypeFilter = result['propertyType']!;
        _priceRangeFilter = result['priceRange']!;
        _locationFilter = result['location']!;
      });
      _applyFilters();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hasil Pencarian'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Search dan Filter Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  // Search Field
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Cari properti...',
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade200,
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            _searchController.clear();
                          },
                        ),
                      ),
                      onChanged: _performSearch,
                      onSubmitted: (value) {
                        if (value.isNotEmpty) _performSearch(value);
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Filter Button
                  InkWell(
                    onTap: _showFilterDialog,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.tune, color: Colors.black54),
                    ),
                  ),
                ],
              ),
            ),

            // Filter Aktif
            if (_propertyTypeFilter != 'Semua' ||
                _priceRangeFilter != 'Semua' ||
                _locationFilter != 'Semua')
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      if (_propertyTypeFilter != 'Semua')
                        _buildActiveFilterChip(_propertyTypeFilter, () {
                          setState(() {
                            _propertyTypeFilter = 'Semua';
                            _applyFilters();
                          });
                        }),
                      if (_priceRangeFilter != 'Semua')
                        _buildActiveFilterChip(_priceRangeFilter, () {
                          setState(() {
                            _priceRangeFilter = 'Semua';
                            _applyFilters();
                          });
                        }),
                      if (_locationFilter != 'Semua')
                        _buildActiveFilterChip(_locationFilter, () {
                          setState(() {
                            _locationFilter = 'Semua';
                            _applyFilters();
                          });
                        }),
                    ],
                  ),
                ),
              ),

            // Hasil Pencarian
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _filteredProperties.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.search_off,
                                size: 48,
                                color: Colors.grey,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                _errorMessage.isEmpty
                                    ? 'Tidak ada hasil untuk "${widget.searchKeyword}"'
                                    : _errorMessage,
                                style: const TextStyle(fontSize: 16),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: _filteredProperties.length,
                          itemBuilder: (context, index) {
                            return _buildPropertyCard(_filteredProperties[index]);
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActiveFilterChip(String label, VoidCallback onRemove) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.deepOrange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.deepOrange),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.deepOrange,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
          const SizedBox(width: 4),
          InkWell(
            onTap: onRemove,
            child: const Icon(Icons.close, size: 16, color: Colors.deepOrange),
          ),
        ],
      ),
    );
  }
}