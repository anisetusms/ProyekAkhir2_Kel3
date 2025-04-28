import 'package:front/features/dashboard/presentation/screens/users/penyewa/service/wishlist_service.dart';

class WishlistManager {
  final WishlistService _service;
  final Map<int, bool> _statusCache = {};

  WishlistManager(this._service);

  Future<void> initializeUserWishlists() async {
    try {
      final wishlists = await _service.getUserWishlists();
      for (var wishlist in wishlists) {
        _statusCache[wishlist.property.id] = true;
      }
    } catch (e) {
      // Penanganan error jika diperlukan
    }
  }

  Future<bool> isWishlisted(int propertyId) async {
    if (_statusCache.containsKey(propertyId)) return _statusCache[propertyId]!;
    final status = await _service.checkWishlist(propertyId);
    _statusCache[propertyId] = status;
    return status;
  }

  Future<bool> toggleWishlist(int propertyId) async {
    final newStatus = await _service.toggleWishlist(propertyId);
    _statusCache[propertyId] = newStatus;
    return newStatus;
  }
}