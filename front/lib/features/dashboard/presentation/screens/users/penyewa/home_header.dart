import 'package:flutter/material.dart';
import 'package:front/features/dashboard/presentation/screens/users/penyewa/search_result_screen.dart';
import 'package:front/features/dashboard/presentation/screens/users/penyewa/filter_dialog.dart';
import 'package:front/features/dashboard/presentation/widgets/notification_badge.dart';
import 'package:front/features/dashboard/presentation/screens/users/penyewa/notification_screen.dart';
import 'package:front/features/dashboard/presentation/screens/users/penyewa/wishlist_screen.dart';

class DashboardHeader extends StatefulWidget {
  final Function? onWishlistUpdated;
  
  const DashboardHeader({
    super.key,
    this.onWishlistUpdated,
  });

  @override
  State<DashboardHeader> createState() => _DashboardHeaderState();
}

class _DashboardHeaderState extends State<DashboardHeader> {
  final TextEditingController _searchController = TextEditingController();
  
  // Filter state
  String _selectedPropertyType = 'Semua';
  String _selectedPriceRange = 'Semua';
  String _selectedLocation = 'Semua';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Bagian atas header (logo + ikon notifikasi)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Hommie",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.brown,
              ),
            ),
            Row(
              children: [
                GestureDetector(
                  onTap: () => _navigateToWishlist(),
                  child: const Icon(Icons.favorite, color: Colors.red),
                ),
                const SizedBox(width: 12),
                NotificationBadge(
                  onTap: () => _navigateToNotifications(),
                  child: const Icon(Icons.notifications_none),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 20),
        
        // TextField untuk pencarian dengan tombol filter
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Cari kost atau homestay...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade200,
                ),
                onSubmitted: (value) {
                  // Ketika tombol Enter ditekan, kirim pencarian ke halaman hasil pencarian
                  if (value.isNotEmpty) {
                    _navigateToSearchResults(value);
                  }
                },
              ),
            ),
            const SizedBox(width: 8),
            InkWell(
              onTap: () => _showFilterDialog(),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(Icons.tune, color: Colors.black54),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _navigateToWishlist() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const WishlistScreen(),
      ),
    );
    
    // Jika ada perubahan pada wishlist, refresh dashboard
    if (result == true && widget.onWishlistUpdated != null) {
      widget.onWishlistUpdated!();
    }
  }

  void _navigateToNotifications() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const NotificationScreen(),
      ),
    );
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

      // If search field has text, navigate to search results with filters
      if (_searchController.text.isNotEmpty) {
        _navigateToSearchResults(_searchController.text);
      }
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
