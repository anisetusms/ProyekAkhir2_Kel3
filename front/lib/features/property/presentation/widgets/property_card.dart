// import 'package:flutter/material.dart';
// import 'package:front/core/utils/constants.dart';
// import 'package:intl/intl.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'dart:developer';

// class PropertyCard extends StatelessWidget {
//   final Map<String, dynamic> property;
//   final VoidCallback? onTap;
//   final VoidCallback? onManageRooms;
//   final VoidCallback? onEdit;
//   final VoidCallback? onToggleStatus; // Tambahkan callback untuk toggle status

//   const PropertyCard({
//     Key? key,
//     required this.property,
//     this.onTap,
//     this.onManageRooms,
//     this.onEdit,
//     this.onToggleStatus, // Tambahkan parameter
//   }) : super(key: key);

//   String _getImageUrl() {
//     if (property['image'] == null || property['image'].isEmpty) {
//       return '';
//     }

//     String imagePath = property['image'].toString();

//     // Clean path prefixes
//     if (imagePath.startsWith('/')) {
//       imagePath = imagePath.substring('/'.length);
//     }
//     if (imagePath.startsWith('storage/')) {
//       imagePath = imagePath.substring('storage/'.length);
//     } else if (imagePath.startsWith('/storage/')) {
//       imagePath = imagePath.substring('/storage/'.length);
//     }

//     final base = Constants.baseUrl.replaceAll(RegExp(r'/$'), '');
//     return '$base/storage/$imagePath';
//   }

//   Widget _buildImageWidget() {
//     final imageUrl = _getImageUrl();

//     if (imageUrl.isEmpty) {
//       return _buildPlaceholderImage();
//     }

//     log('Loading image from: $imageUrl');

//     return CachedNetworkImage(
//       imageUrl: imageUrl,
//       fit: BoxFit.cover,
//       placeholder: (context, url) => _buildLoadingIndicator(),
//       errorWidget: (context, url, error) {
//         log('Error loading image from $imageUrl. Error: $error');
//         return _buildPlaceholderImage();
//       },
//       httpHeaders: {'Accept': 'image/*'},
//     );
//   }

//   Widget _buildLoadingIndicator() {
//     return Container(
//       color: Colors.grey[200],
//       child: const Center(child: CircularProgressIndicator()),
//     );
//   }

//   Widget _buildPlaceholderImage() {
//     return Container(
//       color: Colors.grey[200],
//       child: const Center(
//         child: Icon(Icons.home, size: 50, color: Colors.grey),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final NumberFormat currencyFormat = NumberFormat.currency(
//       locale: 'id_ID',
//       symbol: 'Rp',
//       decimalDigits: 0,
//     );

//     final bool isActive = property['status'] == 'active' || property['isDeleted'] == false;

//     return InkWell(
//       onTap: onTap,
//       borderRadius: BorderRadius.circular(8),
//       child: Card(
//         margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
//         elevation: 2,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: <Widget>[
//             // Image Section
//             Stack(
//               children: [
//                 SizedBox(
//                   width: double.infinity,
//                   height: 180.0,
//                   child: _buildImageWidget(),
//                 ),
//                 if (property['status'] != null || property['isDeleted'] != null)
//                   Positioned(
//                     top: 8,
//                     right: 8,
//                     child: Container(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 8, vertical: 4),
//                       decoration: BoxDecoration(
//                         color: isActive ? Colors.green : Colors.orange,
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       child: Text(
//                         isActive ? 'AKTIF' : 'NONAKTIF',
//                         style: const TextStyle(
//                           color: Colors.white,
//                           fontSize: 12,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   ),
//                 // Tambahkan tombol toggle status
//                 if (onToggleStatus != null)
//                   Positioned(
//                     top: 8,
//                     left: 8,
//                     child: Container(
//                       decoration: BoxDecoration(
//                         color: Colors.black.withOpacity(0.6),
//                         borderRadius: BorderRadius.circular(20),
//                       ),
//                       child: IconButton(
//                         icon: Icon(
//                           isActive ? Icons.visibility_off : Icons.visibility,
//                           color: Colors.white,
//                         ),
//                         tooltip: isActive ? 'Nonaktifkan' : 'Aktifkan',
//                         onPressed: onToggleStatus,
//                       ),
//                     ),
//                   ),
//               ],
//             ),

//             // Content Section
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: <Widget>[
//                   // Property Name and Price
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Expanded(
//                         child: Text(
//                           property['name']?.toString() ?? 'Nama Properti',
//                           style: const TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 18.0,
//                           ),
//                           maxLines: 1,
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                       ),
//                       Text(
//                         currencyFormat.format(property['price'] ?? 0),
//                         style: const TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 16.0,
//                           color: Colors.blue,
//                         ),
//                       ),
//                     ],
//                   ),

//                   const SizedBox(height: 8.0),
//                   Text(
//                     property['address']?.toString() ?? 'Alamat tidak tersedia',
//                     style: const TextStyle(color: Colors.grey),
//                     maxLines: 2,
//                     overflow: TextOverflow.ellipsis,
//                   ),

//                   const SizedBox(height: 12.0),

//                   // Property Features
//                   Wrap(
//                     spacing: 8,
//                     runSpacing: 4,
//                     children: [
//                       if (property['property_type']?['name'] != null)
//                         _buildFeatureChip(
//                           icon: Icons.home_outlined,
//                           label: property['property_type']!['name'].toString(),
//                         ),
//                       if (property['capacity'] != null)
//                         _buildFeatureChip(
//                           icon: Icons.people_outline,
//                           label: '${property['capacity']} Orang',
//                         ),
//                       if (property['total_rooms'] != null)
//                         _buildFeatureChip(
//                           icon: Icons.king_bed_outlined,
//                           label: '${property['total_rooms']} Kamar',
//                         ),
//                       if (property['total_units'] != null)
//                         _buildFeatureChip(
//                           icon: Icons.holiday_village_outlined,
//                           label: '${property['total_units']} Unit',
//                         ),
//                     ],
//                   ),

//                   // Action Buttons
//                   if (onManageRooms != null || onEdit != null) ...[
//                     const SizedBox(height: 16.0),
//                     Row(
//                       children: [
//                         if (onManageRooms != null)
//                           Expanded(
//                             child: OutlinedButton.icon(
//                               icon: const Icon(Icons.room_preferences, size: 16),
//                               label: const Text('Kelola Kamar'),
//                               onPressed: onManageRooms,
//                             ),
//                           ),
//                         if (onManageRooms != null && onEdit != null)
//                           const SizedBox(width: 8),
//                         if (onEdit != null)
//                           Expanded(
//                             child: ElevatedButton.icon(
//                               icon: const Icon(Icons.edit, size: 16),
//                               label: const Text('Edit'),
//                               onPressed: onEdit,
//                             ),
//                           ),
//                       ],
//                     ),
//                   ],
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildFeatureChip({required IconData icon, required String label}) {
//     return Chip(
//       labelPadding: const EdgeInsets.symmetric(horizontal: 4),
//       backgroundColor: Colors.grey[100],
//       side: BorderSide.none,
//       avatar: Icon(icon, size: 16, color: Colors.grey),
//       label: Text(
//         label,
//         style: const TextStyle(fontSize: 12),
//       ),
//       materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:front/core/utils/constants.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:developer';

class PropertyCard extends StatelessWidget {
  final Map<String, dynamic> property;
  final VoidCallback? onTap;
  final VoidCallback? onManageRooms;
  final VoidCallback? onEdit;
  final VoidCallback? onToggleStatus;

  const PropertyCard({
    Key? key,
    required this.property,
    this.onTap,
    this.onManageRooms,
    this.onEdit,
    this.onToggleStatus,
  }) : super(key: key);

  String _getImageUrl() {
    if (property['image'] == null || property['image'].isEmpty) {
      return '';
    }

    String imagePath = property['image'].toString();

    // Clean path prefixes
    if (imagePath.startsWith('/')) {
      imagePath = imagePath.substring('/'.length);
    }
    if (imagePath.startsWith('storage/')) {
      imagePath = imagePath.substring('storage/'.length);
    } else if (imagePath.startsWith('/storage/')) {
      imagePath = imagePath.substring('/storage/'.length);
    }

    final base = Constants.baseUrl.replaceAll(RegExp(r'/$'), '');
    return '$base/storage/$imagePath';
  }

  Widget _buildImageWidget() {
    final imageUrl = _getImageUrl();

    if (imageUrl.isEmpty) {
      return _buildPlaceholderImage();
    }

    log('Loading image from: $imageUrl');

    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: BoxFit.cover,
      placeholder: (context, url) => _buildLoadingIndicator(),
      errorWidget: (context, url, error) {
        log('Error loading image from $imageUrl. Error: $error');
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

    final bool isActive = property['status'] == 'active' || property['isDeleted'] == false;
    
    // Warna tema yang konsisten dengan dashboard
    final Color addPropertyColor = const Color(0xFF4CAF50); // Hijau untuk tombol tambah properti
    final Color viewPropertiesColor = const Color(0xFF2196F3); // Biru untuk tombol lihat properti

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        color: isActive ? Colors.white : Colors.grey[100],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Image Section
            Stack(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 180.0,
                  child: _buildImageWidget(),
                ),
                if (property['status'] != null || property['isDeleted'] != null)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: isActive ? addPropertyColor : Colors.orange,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        isActive ? 'AKTIF' : 'NONAKTIF',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                if (onToggleStatus != null)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: IconButton(
                        icon: Icon(
                          isActive ? Icons.visibility_off : Icons.visibility,
                          color: Colors.white,
                        ),
                        tooltip: isActive ? 'Nonaktifkan' : 'Aktifkan',
                        onPressed: onToggleStatus,
                      ),
                    ),
                  ),
              ],
            ),

            // Content Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // Property Name and Price
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          property['name']?.toString() ?? 'Nama Properti',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        currencyFormat.format(property['price'] ?? 0),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                          color: viewPropertiesColor,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8.0),
                  Text(
                    property['address']?.toString() ?? 'Alamat tidak tersedia',
                    style: const TextStyle(color: Colors.grey),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 12.0),

                  // Property Features
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: [
                      if (property['property_type']?['name'] != null)
                        _buildFeatureChip(
                          icon: Icons.home_outlined,
                          label: property['property_type']!['name'].toString(),
                        ),
                      if (property['capacity'] != null)
                        _buildFeatureChip(
                          icon: Icons.people_outline,
                          label: '${property['capacity']} Orang',
                        ),
                      if (property['total_rooms'] != null)
                        _buildFeatureChip(
                          icon: Icons.king_bed_outlined,
                          label: '${property['total_rooms']} Kamar',
                        ),
                      if (property['total_units'] != null)
                        _buildFeatureChip(
                          icon: Icons.holiday_village_outlined,
                          label: '${property['total_units']} Unit',
                        ),
                    ],
                  ),

                  // Action Buttons
                  if (onManageRooms != null || onEdit != null || !isActive) ...[
                    const SizedBox(height: 16.0),
                    Row(
                      children: [
                        if (onManageRooms != null && isActive)
                          Expanded(
                            child: OutlinedButton.icon(
                              icon: const Icon(Icons.room_preferences, size: 16),
                              label: const Text('Kelola Kamar'),
                              onPressed: onManageRooms,
                              style: OutlinedButton.styleFrom(
                                foregroundColor: viewPropertiesColor,
                              ),
                            ),
                          ),
                        if (onManageRooms != null && onEdit != null && isActive)
                          const SizedBox(width: 8),
                        if (onEdit != null)
                          Expanded(
                            child: ElevatedButton.icon(
                              icon: const Icon(Icons.edit, size: 16),
                              label: const Text('Edit'),
                              onPressed: onEdit,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: viewPropertiesColor,
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ),
                        if (!isActive && onToggleStatus != null) ...[
                          if (onEdit != null) const SizedBox(width: 8),
                          Expanded(
                            child: ElevatedButton.icon(
                              icon: const Icon(Icons.visibility, size: 16),
                              label: const Text('Aktifkan'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: addPropertyColor,
                                foregroundColor: Colors.white,
                              ),
                              onPressed: onToggleStatus,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureChip({required IconData icon, required String label}) {
    return Chip(
      labelPadding: const EdgeInsets.symmetric(horizontal: 4),
      backgroundColor: Colors.grey[100],
      side: BorderSide.none,
      avatar: Icon(icon, size: 16, color: Colors.grey),
      label: Text(
        label,
        style: const TextStyle(fontSize: 12),
      ),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }
}
