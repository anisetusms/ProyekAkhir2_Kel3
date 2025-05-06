import 'dart:async';
import 'package:flutter/material.dart';
import 'package:front/core/network/api_client.dart';
import 'package:front/features/property/data/models/property_model.dart';
import 'package:front/features/dashboard/presentation/screens/users/penyewa/property_detail_screen.dart';


class SearchResultScreen extends StatefulWidget {
  final String searchKeyword;

  const SearchResultScreen({super.key, required this.searchKeyword});

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

  // Filter variables
  String _locationFilter = 'Semua';
  String _priceFilter = 'Semua';
  final List<String> _locationOptions = ['Semua', 'Terdekat', 'Jakarta', 'Bandung', 'Surabaya'];
  final List<String> _priceOptions = ['Semua', '< Rp1jt', 'Rp1jt - Rp3jt', 'Rp3jt - Rp5jt', '> Rp5jt'];

  @override
  void initState() {
    super.initState();
    _searchController.text = widget.searchKeyword;
    _fetchAndFilterProperties();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  Future<void> _fetchAndFilterProperties() async {
    try {
      final response = await ApiClient().get(
        '/property/search',
        queryParameters: {'keyword': widget.searchKeyword},
      );

      if (response != null && response is Map && response.containsKey('data')) {
        final List<PropertyModel> results = (response['data'] as List).map((item) {
          return PropertyModel.fromJson(item);
        }).toList();

        setState(() {
          _originalProperties = results;
          _filteredProperties = results;
          _errorMessage = results.isEmpty
              ? 'Tidak ditemukan hasil untuk "${widget.searchKeyword}".'
              : '';
        });
      } else {
        setState(() {
          _errorMessage = 'Format data tidak valid.';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Gagal memuat data: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _applyFilters() {
    List<PropertyModel> filtered = List.from(_originalProperties);

    // Apply location filter
    if (_locationFilter != 'Semua') {
      if (_locationFilter == 'Terdekat') {
        // Here you would implement actual location-based filtering
        // For demo, we'll just sort by a fake "distance" field
        filtered.sort((a, b) => (a.distance ?? 0).compareTo(b.distance ?? 0));
      } else {
        filtered = filtered.where((property) => 
          property.address.toLowerCase().contains(_locationFilter.toLowerCase()))
          .toList();
      }
    }

    // Apply price filter
    if (_priceFilter != 'Semua') {
      switch (_priceFilter) {
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

    setState(() {
      _filteredProperties = filtered;
      _errorMessage = filtered.isEmpty ? 'Tidak ada properti yang sesuai dengan filter.' : '';
    });
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
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
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
                        'Rp ${property.price.toString().replaceAllMapped(
                          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), 
                          (Match m) => '${m[1]}.',
                        )} / Bulan',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.star, size: 16, color: Colors.orange),
                          const SizedBox(width: 4),
                          Text(
                            '5.0',
                            style: TextStyle(color: Colors.grey[600]),
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

  void _performSearch(String keyword) {
    if (keyword.isNotEmpty) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => SearchResultScreen(searchKeyword: keyword),
        ),
      );
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
            // Search and Filter Bar
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
                      onChanged: (value) {
                        if (_debounce?.isActive ?? false) _debounce?.cancel();
                        _debounce = Timer(const Duration(milliseconds: 500), () {
                          _performSearch(value);
                        });
                      },
                      onSubmitted: _performSearch,
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Location Filter Dropdown
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _locationFilter,
                        icon: const Icon(Icons.location_on, size: 20),
                        items: _locationOptions.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value, style: const TextStyle(fontSize: 14)),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _locationFilter = newValue!;
                            _applyFilters();
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Price Filter Dropdown
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _priceFilter,
                        icon: const Icon(Icons.attach_money, size: 20),
                        items: _priceOptions.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value, style: const TextStyle(fontSize: 14)),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _priceFilter = newValue!;
                            _applyFilters();
                          });
                        },
                      ),
                    ),
                  ),
                ],
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
                              const Icon(Icons.search_off, size: 48, color: Colors.grey),
                              const SizedBox(height: 16),
                              Text(
                                _errorMessage,
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
}