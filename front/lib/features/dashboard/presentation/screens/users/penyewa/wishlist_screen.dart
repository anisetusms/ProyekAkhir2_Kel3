import 'package:flutter/material.dart';
import 'package:front/core/network/api_client.dart';
import 'package:front/features/dashboard/presentation/screens/users/penyewa/models/wishlist_model.dart';
import 'package:front/features/dashboard/presentation/screens/users/penyewa/service/wishlist_service.dart';
import 'package:front/features/dashboard/presentation/screens/users/penyewa/property_detail_screen.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  _WishlistScreenState createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  final WishlistService _wishlistService = WishlistService(ApiClient());
  List<WishlistModel> _wishlists = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadWishlists();
  }

  Future<void> _loadWishlists() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = '';
      });

      final wishlists = await _wishlistService.getUserWishlists();
      setState(() {
        _wishlists = wishlists;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Gagal memuat wishlist: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  Future<void> _removeFromWishlist(int propertyId) async {
    try {
      await _wishlistService.toggleWishlist(propertyId);
      // Refresh wishlist setelah menghapus
      _loadWishlists();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal menghapus dari wishlist: ${e.toString()}'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wishlist Saya'),
        backgroundColor: Color(0xFF4CAF50),
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
              ? Center(child: Text(_errorMessage))
              : _wishlists.isEmpty
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.favorite_border, size: 64, color: Colors.grey),
                          SizedBox(height: 16),
                          Text(
                            'Belum ada properti yang disimpan',
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Tambahkan properti favorit Anda ke wishlist',
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                        ],
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: _loadWishlists,
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _wishlists.length,
                        itemBuilder: (context, index) {
                          final wishlist = _wishlists[index];
                          return _buildWishlistItem(wishlist);
                        },
                      ),
                    ),
    );
  }

  Widget _buildWishlistItem(WishlistModel wishlist) {
    return Dismissible(
      key: Key('wishlist-${wishlist.id}'),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: Colors.red,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (direction) {
        _removeFromWishlist(wishlist.property.id);
      },
      child: Card(
        margin: const EdgeInsets.only(bottom: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 2,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PropertyDetailScreen(propertyId: wishlist.property.id),
              ),
            ).then((_) => _loadWishlists()); // Refresh setelah kembali dari detail
          },
          borderRadius: BorderRadius.circular(12),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                ),
                child: Image.network(
                  wishlist.property.image,
                  width: 120,
                  height: 120,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 120,
                    height: 120,
                    color: Colors.grey[200],
                    child: const Icon(Icons.broken_image, size: 40),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        wishlist.property.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Rp ${wishlist.property.price.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}',
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.star, size: 16, color: Colors.orange),
                              const SizedBox(width: 4),
                              Text('5.0', style: TextStyle(color: Colors.grey[600])),
                            ],
                          ),
                          IconButton(
                            icon: const Icon(Icons.favorite, color: Colors.red),
                            onPressed: () => _removeFromWishlist(wishlist.property.id),
                            tooltip: 'Hapus dari wishlist',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
