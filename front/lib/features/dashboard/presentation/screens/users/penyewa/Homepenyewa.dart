import 'package:flutter/material.dart';
import 'package:front/core/network/api_client.dart';
import 'package:front/features/dashboard/presentation/screens/users/penyewa/models/property_model.dart';
import 'package:front/features/dashboard/presentation/screens/users/penyewa/home_header.dart';
import 'package:front/features/dashboard/presentation/screens/users/penyewa/service/wishlist_service.dart';
import 'package:front/features/dashboard/presentation/screens/users/penyewa/wishlist_manager.dart';
import 'package:front/features/dashboard/presentation/screens/users/penyewa/property_detail_screen.dart';
import 'package:front/features/dashboard/presentation/screens/users/penyewa/all_properties_screen.dart';
import 'package:front/features/dashboard/presentation/screens/users/penyewa/widgets/property_rating.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late final WishlistManager _wishlistManager;
  List<PropertyModel> homestayList = [];
  String _errorMessage = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    final apiClient = ApiClient();
    _wishlistManager = WishlistManager(WishlistService(apiClient));
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    try {
      await fetchHomestays();
      await _wishlistManager.initializeUserWishlists();
      setState(() {}); // Refresh UI setelah data dimuat
    } catch (e) {
      setState(() {
        _errorMessage = 'Gagal memuat data: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> fetchHomestays() async {
    try {
      final response = await ApiClient().get('/dashboardc');
      if (response != null && response['latest_properties'] != null) {
        setState(() {
          homestayList =
              (response['latest_properties'] as List)
                  .where(
                    (property) =>
                        property['propertytype'] == 'Kos' ||
                        property['propertytype'] == 'Homestay',
                  )
                  .map((property) => PropertyModel.fromJson(property))
                  .toList();
        });
      } else {
        setState(() {
          _errorMessage = 'Data homestay tidak ditemukan.';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Terjadi kesalahan saat mengambil data homestay: $e';
      });
      rethrow;
    }
  }

  Future<void> _toggleWishlist(int propertyId) async {
    try {
      await _wishlistManager.toggleWishlist(propertyId);
      setState(() {}); // Refresh UI untuk menampilkan perubahan
      
      // Tampilkan snackbar untuk memberikan feedback ke pengguna
      final isWishlisted = await _wishlistManager.isWishlisted(propertyId);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isWishlisted 
                ? 'Properti ditambahkan ke wishlist' 
                : 'Properti dihapus dari wishlist'
          ),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          action: SnackBarAction(
            label: 'Lihat Wishlist',
            onPressed: () {
              Navigator.pushNamed(context, '/wishlist');
            },
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal mengubah wishlist: ${e.toString()}'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  Widget _buildHorizontalPropertyCard(PropertyModel property) {
    return FutureBuilder<bool>(
      future: _wishlistManager.isWishlisted(property.id),
      builder: (context, snapshot) {
        final isWishlisted = snapshot.data ?? false;

        return GestureDetector(
          onTap: () {
            // Navigasi ke detail properti
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PropertyDetailScreen(propertyId: property.id),
              ),
            ).then((_) => setState(() {})); // Refresh setelah kembali dari detail
          },
          child: Container(
            width: 160,
            margin: EdgeInsets.only(
              right: homestayList.last == property ? 0 : 16,
            ),
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
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(12),
                      ),
                      child: Image.network(
                        property.image,
                        height: 120,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder:
                            (context, error, stackTrace) => Container(
                              height: 120,
                              color: Colors.grey[200],
                              child: const Icon(Icons.broken_image),
                            ),
                      ),
                    ),
                    Positioned(
                      right: 8,
                      top: 8,
                      child: GestureDetector(
                        onTap: () => _toggleWishlist(property.id),
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                spreadRadius: 1,
                                blurRadius: 2,
                              ),
                            ],
                          ),
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            transitionBuilder: (child, animation) {
                              return ScaleTransition(scale: animation, child: child);
                            },
                            child: Icon(
                              isWishlisted ? Icons.favorite : Icons.favorite_border,
                              key: ValueKey<bool>(isWishlisted),
                              size: 20,
                              color: isWishlisted ? Colors.red : Colors.grey[600],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
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
                          fontSize: 14,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        property.district,
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Rp ${property.price.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}',
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          // Ganti rating statis dengan widget PropertyRating
                          PropertyRating(
                            propertyId: property.id,
                            iconSize: 14,
                            textSize: 12,
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
      },
    );
  }

  Widget _buildVerticalPropertyCard(PropertyModel property) {
    return FutureBuilder<bool>(
      future: _wishlistManager.isWishlisted(property.id),
      builder: (context, snapshot) {
        final isWishlisted = snapshot.data ?? false;

        return GestureDetector(
          onTap: () {
            // Navigasi ke detail properti
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PropertyDetailScreen(propertyId: property.id),
              ),
            ).then((_) => setState(() {})); // Refresh setelah kembali dari detail
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
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(12),
                      ),
                      child: Image.network(
                        property.image,
                        height: 160,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder:
                            (context, error, stackTrace) => Container(
                              height: 160,
                              color: Colors.grey[200],
                              child: const Icon(Icons.broken_image, size: 40),
                            ),
                      ),
                    ),
                    Positioned(
                      right: 12,
                      top: 12,
                      child: GestureDetector(
                        onTap: () => _toggleWishlist(property.id),
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                spreadRadius: 1,
                                blurRadius: 3,
                              ),
                            ],
                          ),
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            transitionBuilder: (child, animation) {
                              return ScaleTransition(scale: animation, child: child);
                            },
                            child: Icon(
                              isWishlisted ? Icons.favorite : Icons.favorite_border,
                              key: ValueKey<bool>(isWishlisted),
                              size: 22,
                              color: isWishlisted ? Colors.red : Colors.grey[600],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
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
                        '${property.district}, ${property.subdistrict}',
                        style: TextStyle(color: Colors.grey[600], fontSize: 14),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Rp ${property.price.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')} / Bulan',
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          // Ganti rating statis dengan widget PropertyRating
                          PropertyRating(
                            propertyId: property.id,
                            iconSize: 16,
                            textSize: 14,
                            showCount: true,
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
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: DashboardHeader(
                onWishlistUpdated: () {
                  // Refresh wishlist status ketika kembali dari halaman wishlist
                  _wishlistManager.initializeUserWishlists().then((_) {
                    setState(() {});
                  });
                },
              ),
            ),
            Expanded(
              child:
                  _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : RefreshIndicator(
                          onRefresh: _loadInitialData,
                          child: ListView(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            children: [
                              const SizedBox(height: 20),

                              // Horizontal Scroll - New Properties
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "Kost / Homestay Terbaru",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => AllPropertiesScreen(),
                                        ),
                                      ).then((_) => setState(() {})); // Refresh setelah kembali
                                    },
                                    child: Text(
                                      "Lihat Semua",
                                      style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              SizedBox(
                                height: 220,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: homestayList.length,
                                  itemBuilder: (context, index) {
                                    return _buildHorizontalPropertyCard(
                                      homestayList[index],
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(height: 20),

                              // Error Message
                              if (_errorMessage.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    _errorMessage,
                                    style: const TextStyle(color: Colors.red),
                                  ),
                                ),

                              // Vertical List - Recommendations
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "Rekomendasi Untuk Anda",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => AllPropertiesScreen(),
                                        ),
                                      ).then((_) => setState(() {})); // Refresh setelah kembali
                                    },
                                    child: Text(
                                      "Lihat Semua",
                                      style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              homestayList.isEmpty
                                  ? const Center(child: Text('Tidak ada data'))
                                  : Column(
                                    children:
                                        homestayList.map((property) {
                                          return _buildVerticalPropertyCard(
                                            property,
                                          );
                                        }).toList(),
                                  ),
                              const SizedBox(height: 24),
                            ],
                          ),
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
