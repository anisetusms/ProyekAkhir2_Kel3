import 'package:flutter/material.dart';
import 'package:front/core/utils/constants.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:developer';

class PropertyCard extends StatelessWidget {
  final Map<String, dynamic> property;
  final VoidCallback? onTap;

  const PropertyCard({Key? key, required this.property, this.onTap})
    : super(key: key);

  String _getImageUrl() {
    if (property['image'] == null || property['image'].isEmpty) {
      return '';
    }

    String imagePath = property['image'].toString();

    // Hapus awalan yang tidak perlu
    if (imagePath.startsWith('api/storage/')) {
      imagePath = imagePath.replaceFirst('api/storage/', '');
    }
    if (imagePath.startsWith('storage/')) {
      imagePath = imagePath.replaceFirst('storage/', '');
    }
    if (imagePath.startsWith('/')) {
      imagePath = imagePath.substring(1);
    }

    final base = Constants.baseUrl.replaceAll(RegExp(r'/$'), '');
    return '$base/storage/$imagePath';
  }

  Widget _buildImageWidget() {
    final imageUrl = _getImageUrl();

    if (imageUrl.isEmpty) {
      return _buildPlaceholderImage();
    }

    log('Mencoba memuat gambar dari URL: $imageUrl');

    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: BoxFit.cover,
      placeholder: (context, url) => _buildLoadingIndicator(),
      errorWidget: (context, url, error) {
        log('Error memuat gambar dari $imageUrl. Error: $error');
        return _buildPlaceholderImage();
      },
      httpHeaders: {'Accept': 'image/*'},
    );
  }

  Widget _buildLoadingIndicator() {
    return Container(
      color: Colors.grey[200],
      child: const Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      color: Colors.grey[200],
      child: const Center(
        child: Icon(Icons.home, size: 50, color: Colors.grey),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final NumberFormat currencyFormat = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp',
      decimalDigits: 0,
    );

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Bagian Gambar
            SizedBox(
              width: double.infinity,
              height: 180.0,
              child: _buildImageWidget(),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    property['name']?.toString() ?? 'Nama Properti',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    property['address']?.toString() ?? 'Alamat tidak tersedia',
                    style: const TextStyle(color: Colors.grey),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    'Rp ${currencyFormat.format(property['price'] ?? 0)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 12.0),
                  Row(
                    children: <Widget>[
                      const Icon(
                        Icons.home_outlined,
                        color: Colors.grey,
                        size: 16.0,
                      ),
                      const SizedBox(width: 4.0),
                      Text(
                        property['property_type']?['name']?.toString() ??
                            'Tidak diketahui',
                        style: const TextStyle(fontSize: 14.0),
                      ),
                      const SizedBox(width: 16.0),
                      if (property['capacity'] != null) ...[
                        const Icon(
                          Icons.people_outline,
                          color: Colors.grey,
                          size: 16.0,
                        ),
                        const SizedBox(width: 4.0),
                        Text(
                          '${property['capacity']} Orang',
                          style: const TextStyle(fontSize: 14.0),
                        ),
                      ],
                      if (property['total_rooms'] != null) ...[
                        const SizedBox(width: 16.0),
                        const Icon(
                          Icons.king_bed_outlined,
                          color: Colors.grey,
                          size: 16.0,
                        ),
                        const SizedBox(width: 4.0),
                        Text(
                          '${property['total_rooms']} Kamar',
                          style: const TextStyle(fontSize: 14.0),
                        ),
                      ],
                      if (property['total_units'] != null) ...[
                        const SizedBox(width: 16.0),
                        const Icon(
                          Icons.holiday_village_outlined,
                          color: Colors.grey,
                          size: 16.0,
                        ),
                        const SizedBox(width: 4.0),
                        Text(
                          '${property['total_units']} Unit',
                          style: const TextStyle(fontSize: 14.0),
                        ),
                      ],
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
}
