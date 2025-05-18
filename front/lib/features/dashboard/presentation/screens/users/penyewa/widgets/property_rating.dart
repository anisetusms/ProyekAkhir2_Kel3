import 'package:flutter/material.dart';
import 'package:front/features/dashboard/presentation/screens/users/penyewa/service/property_rating_service.dart';
import 'package:front/core/network/api_client.dart';

class PropertyRating extends StatefulWidget {
  final int propertyId;
  final double iconSize;
  final double textSize;
  final bool showCount;

  const PropertyRating({
    Key? key,
    required this.propertyId,
    this.iconSize = 16,
    this.textSize = 14,
    this.showCount = false,
  }) : super(key: key);

  @override
  State<PropertyRating> createState() => _PropertyRatingState();
}

class _PropertyRatingState extends State<PropertyRating> {
  late final PropertyRatingService _ratingService;
  double _rating = 0;
  int _reviewCount = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _ratingService = PropertyRatingService(ApiClient());
    _loadRating();
  }

  Future<void> _loadRating() async {
    try {
      final rating = await _ratingService.getPropertyRating(widget.propertyId);

      if (widget.showCount) {
        final count = await _ratingService.getReviewCount(widget.propertyId);
        if (mounted) {
          setState(() {
            _rating = rating;
            _reviewCount = count;
            _isLoading = false;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _rating = rating;
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return SizedBox(
        height: widget.iconSize,
        width: widget.iconSize * 3,
        child: const Center(
          child: SizedBox(
            width: 10,
            height: 10,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      );
    }

    // Jika tidak ada rating, tampilkan pesan
    if (_rating == 0) {
      Row(
        children: [
          const Icon(Icons.star, size: 16, color: Colors.orange),
          const SizedBox(width: 4),
          Text('0.0', style: TextStyle(color: Colors.grey[600])),
        ],
      );
    }

    return Row(
      children: [
        Icon(Icons.star, size: widget.iconSize, color: Colors.orange),
        const SizedBox(width: 4),
        Text(
          _rating.toStringAsFixed(1),
          style: TextStyle(color: Colors.grey[600], fontSize: widget.textSize),
        ),
        if (widget.showCount) ...[
          const SizedBox(width: 4),
          Text(
            '($_reviewCount)',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: widget.textSize - 2,
            ),
          ),
        ],
      ],
    );
  }
}
