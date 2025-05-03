// import 'package:flutter/material.dart';
// import 'package:front/core/utils/constants.dart';
// import 'package:front/features/dashboard/presentation/screens/users/penyewa/service/property_detail_api_service.dart';
// import 'package:front/features/property/data/models/property_model.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:latlong2/latlong.dart';

// class PropertyDetailScreen extends StatefulWidget {
//   final int propertyId;

//   const PropertyDetailScreen({super.key, required this.propertyId});

//   @override
//   State<PropertyDetailScreen> createState() => _PropertyDetailScreenState();
// }

// class _PropertyDetailScreenState extends State<PropertyDetailScreen> {
//   late final PropertyApiService _apiService;
//   late Future<PropertyModel> _propertyFuture;

//   @override
//   void initState() {
//     super.initState();
//     _apiService = PropertyApiService();
//     _loadProperty();
//     _propertyFuture = _apiService.getPropertyDetail(widget.propertyId);
//   }

//   void _loadProperty() {
//   setState(() {
//     _propertyFuture = _apiService.getPropertyDetail(widget.propertyId);
//   });
// }


//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Detail Properti'),
//       ),
//       body: FutureBuilder<PropertyModel>(
//         future: _propertyFuture,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           if (snapshot.hasError) {
//             return _buildErrorWidget(snapshot.error.toString());
//           }

//           if (!snapshot.hasData) {
//             return const Center(child: Text('Data properti tidak ditemukan'));
//           }

//           final property = snapshot.data!;
//           return _buildDetailContent(property);
//         },
//       ),
//     );
//   }

//   Widget _buildErrorWidget(String error) {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           const Icon(Icons.error_outline, color: Colors.red, size: 50),
//           const SizedBox(height: 16),
//           Text(
//             'Gagal memuat data',
//             style: Theme.of(context).textTheme.headlineSmall,
//           ),
//           const SizedBox(height: 8),
//           Text(
//             error,
//             textAlign: TextAlign.center,
//             style: const TextStyle(color: Colors.red),
//           ),
//           const SizedBox(height: 16),
//           ElevatedButton(
//             onPressed: _loadProperty,
//             child: const Text('Coba Lagi'),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildDetailContent(PropertyModel property) {
//     return SingleChildScrollView(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Gambar Utama
//           _buildMainImage(property),
          
//           // Info Dasar
//           _buildBasicInfo(property),
          
//           // Deskripsi
//           _buildDescriptionSection(property),
          
//           // Kapasitas
//           _buildCapacitySection(property),
          
//           // Peraturan (jika ada)
//           if (property.rules != null && property.rules!.isNotEmpty)
//             _buildRulesSection(property),
          
//           // Lokasi
//           _buildLocationSection(property),
          
//           // Tombol Aksi
//           _buildActionButtons(),
//         ],
//       ),
//     );
//   }

//   Widget _buildMainImage(PropertyModel property) {
//     final imageUrl = property.image != null
//         ? '${Constants.baseUrl}/storage/${property.image}'
//         : 'https://via.placeholder.com/400x250?text=No+Image';

//     return Container(
//       height: 250,
//       width: double.infinity,
//       decoration: BoxDecoration(
//         image: DecorationImage(
//           image: NetworkImage(imageUrl),
//           fit: BoxFit.cover,
//           // errorBuilder: (_, __, ___) => Container(color: Colors.grey[200]),
//         ),
//       ),
//     );
//   }

//   Widget _buildBasicInfo(PropertyModel property) {
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             property.name,
//             style: Theme.of(context).textTheme.headlineSmall?.copyWith(
//                   fontWeight: FontWeight.bold,
//                 ),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             property.address,
//             style: Theme.of(context).textTheme.bodyLarge,
//           ),
//           const SizedBox(height: 12),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 'Rp ${property.price.toStringAsFixed(0).replaceAllMapped(
//                       RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
//                       (Match m) => '${m[1]}.',
//                     )} / ${property.isKost ? 'Bulan' : 'Malam'}',
//                 style: const TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.green,
//                 ),
//               ),
//               if (property.isKost)
//                 Text(
//                   '${property.availableRooms} Kamar Tersedia',
//                   style: const TextStyle(
//                     color: Colors.blue,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildDescriptionSection(PropertyModel property) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text(
//             'Deskripsi',
//             style: TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             property.description.isNotEmpty
//                 ? property.description
//                 : 'Tidak ada deskripsi tersedia',
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildCapacitySection(PropertyModel property) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text(
//             'Kapasitas',
//             style: TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             property.isKost
//                 ? 'Kapasitas per kamar: ${property.capacity} orang'
//                 : 'Kapasitas maksimal: ${property.capacity} orang',
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildRulesSection(PropertyModel property) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text(
//             'Peraturan',
//             style: TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           const SizedBox(height: 8),
//           Text(property.rules!),
//         ],
//       ),
//     );
//   }

//   // Widget _buildLocationSection(PropertyModel property) {
//   //   return Padding(
//   //     padding: const EdgeInsets.all(16.0),
//   //     child: Column(
//   //       crossAxisAlignment: CrossAxisAlignment.start,
//   //       children: [
//   //         const Text(
//   //           'Lokasi',
//   //           style: TextStyle(
//   //             fontSize: 18,
//   //             fontWeight: FontWeight.bold,
//   //           ),
//   //         ),
//   //         const SizedBox(height: 12),
//   //         Container(
//   //           height: 200,
//   //           decoration: BoxDecoration(
//   //             color: Colors.grey[200],
//   //             borderRadius: BorderRadius.circular(8),
//   //           ),
//   //           child: property.latitude != null && property.longitude != null
//   //               ? const Center(
//   //                   child: Column(
//   //                     mainAxisAlignment: MainAxisAlignment.center,
//   //                     children: [
//   //                       Icon(Icons.map, size: 50),
//   //                       SizedBox(height: 8),
//   //                       Text('Peta Lokasi'),
//   //                       Text('Lat: ${property.latitude}, Long: ${property.longitude}'),
//   //                     ],
//   //                   ),
//   //                 )
//   //               : const Center(child: Text('Lokasi tidak tersedia')),
//   //         ),
//   //       ],
//   //     ),
//   //   );
//   // }
// Widget _buildLocationSection(PropertyModel property) {
//   return Padding(
//     padding: const EdgeInsets.all(16.0),
//     child: Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           'Lokasi',
//           style: TextStyle(
//             fontSize: 18,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         const SizedBox(height: 12),
//         Container(
//           height: 200,
//           decoration: BoxDecoration(
//             color: Colors.grey[200],
//             borderRadius: BorderRadius.circular(8),
//           ),
//           child: property.latitude != null && property.longitude != null
//               ? ClipRRect(
//                   borderRadius: BorderRadius.circular(8),
//                   child: _OSMMapWidget(
//                     latitude: double.parse(property.latitude.toString()),
//                     longitude: double.parse(property.longitude.toString()),
//                   ),
//                 )
//               : const Center(child: Text('Lokasi tidak tersedia')),
//         ),
//         if (property.latitude != null && property.longitude != null)
//           Padding(
//             padding: const EdgeInsets.only(top: 8.0),
//             child: Text(
//               'Lat: ${property.latitude}, Long: ${property.longitude}',
//               style: const TextStyle(fontSize: 12),
//             ),
//           ),
//       ],
//     ),
//   );
// }

//   Widget _buildActionButtons() {
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Column(
//         children: [
//           SizedBox(
//             width: double.infinity,
//             child: ElevatedButton(
//               onPressed: () {},
//               style: ElevatedButton.styleFrom(
//                 padding: const EdgeInsets.symmetric(vertical: 16),
//               ),
//               child: const Text('Lihat Kamar'),
//             ),
//           ),
//           const SizedBox(height: 8),
//           SizedBox(
//             width: double.infinity,
//             child: ElevatedButton(
//               onPressed: () {},
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.green,
//                 padding: const EdgeInsets.symmetric(vertical: 16),
//               ),
//               child: const Text('Pesan Sekarang'),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _OSMMapWidget extends StatefulWidget {
//   final double latitude;
//   final double longitude;

//   const _OSMMapWidget({
//     required this.latitude,
//     required this.longitude,
//   });

//   @override
//   State<_OSMMapWidget> createState() => _OSMMapWidgetState();
// }

// class _OSMMapWidgetState extends State<_OSMMapWidget> {
//   late final MapController mapController;
//   double zoomLevel = 15.0;

//   @override
//   void initState() {
//     super.initState();
//     mapController = MapController();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final location = LatLng(widget.latitude, widget.longitude);

//     return Stack(
//       children: [
//         FlutterMap(
//           mapController: mapController,
//           options: MapOptions(
//             initialCenter: location,
//             initialZoom: zoomLevel,
//             interactionOptions: const InteractionOptions(
//               flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
//             ),
//           ),
//           children: [
//             TileLayer(
//               urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
//               userAgentPackageName: 'com.example.app',
//             ),
//             MarkerLayer(
//               markers: [
//                 Marker(
//                   point: location,
//                   child: const Icon(
//                     Icons.location_pin,
//                     color: Colors.red,
//                     size: 40,
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//         Positioned(
//           bottom: 16,
//           right: 16,
//           child: Column(
//             children: [
//               FloatingActionButton.small(
//                 heroTag: 'zoomIn',
//                 onPressed: () {
//                   setState(() => zoomLevel += 1);
//                   mapController.move(mapController.camera.center, zoomLevel);
//                 },
//                 child: const Icon(Icons.add),
//               ),
//               const SizedBox(height: 8),
//               FloatingActionButton.small(
//                 heroTag: 'zoomOut',
//                 onPressed: () {
//                   setState(() => zoomLevel -= 1);
//                   mapController.move(mapController.camera.center, zoomLevel);
//                 },
//                 child: const Icon(Icons.remove),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:front/core/utils/constants.dart';
import 'package:front/features/dashboard/presentation/screens/users/penyewa/service/property_detail_api_service.dart';
import 'package:front/features/property/data/models/property_model.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geocoding/geocoding.dart';
import 'package:front/features/dashboard/presentation/screens/users/penyewa/Room_list_screen.dart';  // Tambahkan import ini

class PropertyDetailScreen extends StatefulWidget {
  final int propertyId;

  const PropertyDetailScreen({super.key, required this.propertyId});

  @override
  State<PropertyDetailScreen> createState() => _PropertyDetailScreenState();
}

class _PropertyDetailScreenState extends State<PropertyDetailScreen> {
  late final PropertyApiService _apiService;
  late Future<PropertyModel> _propertyFuture;
  String? _locationName; // Variabel untuk menyimpan nama lokasi

  @override
  void initState() {
    super.initState();
    _apiService = PropertyApiService();
    _loadProperty();
    _propertyFuture = _apiService.getPropertyDetail(widget.propertyId);
  }

  void _loadProperty() {
    setState(() {
      _propertyFuture = _apiService.getPropertyDetail(widget.propertyId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Properti'),
      ),
      body: FutureBuilder<PropertyModel>(
        future: _propertyFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return _buildErrorWidget(snapshot.error.toString());
          }

          if (!snapshot.hasData) {
            return const Center(child: Text('Data properti tidak ditemukan'));
          }

          final property = snapshot.data!;
          return _buildDetailContent(property);
        },
      ),
    );
  }

  Widget _buildErrorWidget(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 50),
          const SizedBox(height: 16),
          Text(
            'Gagal memuat data',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            error,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.red),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _loadProperty,
            child: const Text('Coba Lagi'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailContent(PropertyModel property) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Gambar Utama
          _buildMainImage(property),

          // Info Dasar
          _buildBasicInfo(property),

          // Deskripsi
          _buildDescriptionSection(property),

          // Kapasitas
          _buildCapacitySection(property),

          // Peraturan (jika ada)
          if (property.rules != null && property.rules!.isNotEmpty)
            _buildRulesSection(property),

          // Lokasi
          _buildLocationSection(property),

          // Tombol Aksi
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildMainImage(PropertyModel property) {
    final imageUrl = property.image != null
        ? '${Constants.baseUrl}/storage/${property.image}'
        : 'https://via.placeholder.com/400x250?text=No+Image';

    return Container(
      height: 250,
      width: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(imageUrl),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildBasicInfo(PropertyModel property) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            property.name,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            property.address,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Rp ${property.price.toStringAsFixed(0).replaceAllMapped(
                      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                      (Match m) => '${m[1]}.',
                    )} / ${property.isKost ? 'Bulan' : 'Malam'}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              if (property.isKost)
                Text(
                  '${property.availableRooms} Kamar Tersedia',
                  style: const TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDescriptionSection(PropertyModel property) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Deskripsi',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            property.description.isNotEmpty
                ? property.description
                : 'Tidak ada deskripsi tersedia',
          ),
        ],
      ),
    );
  }

  Widget _buildCapacitySection(PropertyModel property) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Kapasitas',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            property.isKost
                ? 'Kapasitas per kamar: ${property.capacity} orang'
                : 'Kapasitas maksimal: ${property.capacity} orang',
          ),
        ],
      ),
    );
  }

  Widget _buildRulesSection(PropertyModel property) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Peraturan',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(property.rules!),
        ],
      ),
    );
  }

  Widget _buildLocationSection(PropertyModel property) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Lokasi',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            height: 200,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            child: property.latitude != null && property.longitude != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: _OSMMapWidget(
                      latitude: double.parse(property.latitude.toString()),
                      longitude: double.parse(property.longitude.toString()),
                    ),
                  )
                : const Center(child: Text('Lokasi tidak tersedia')),
          ),
          if (_locationName != null)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                _locationName!,
                style: const TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          SizedBox(
  width: double.infinity,
  child: ElevatedButton(
    onPressed: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RoomListScreen(
            propertyId: widget.propertyId, // Mengirim propertyId // Mengirim nama properti
          ),
        ),
      );
    },
    style: ElevatedButton.styleFrom(
      padding: const EdgeInsets.symmetric(vertical: 16),
      backgroundColor: Colors.blue, // Warna background
      foregroundColor: Colors.white, // Warna teks
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8), // Border radius
      ),
      elevation: 2, // Shadow
    ),
    child: const Text(
      'Lihat Kamar',
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    ),
  ),
),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Pesan Sekarang'),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _getLocationName(double latitude, double longitude) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);
      setState(() {
        _locationName = placemarks.isNotEmpty ? '${placemarks[0].name}, ${placemarks[0].locality}' : 'Lokasi tidak dikenal';
      });
    } catch (e) {
      setState(() {
        _locationName = 'Gagal mendapatkan nama lokasi';
      });
    }
  }
}

class _OSMMapWidget extends StatefulWidget {
  final double latitude;
  final double longitude;

  const _OSMMapWidget({
    required this.latitude,
    required this.longitude,
  });

  @override
  State<_OSMMapWidget> createState() => _OSMMapWidgetState();
}

class _OSMMapWidgetState extends State<_OSMMapWidget> {
  late final MapController mapController;
  double zoomLevel = 15.0;

  @override
  void initState() {
    super.initState();
    mapController = MapController();
    // Panggil fungsi untuk mendapatkan nama lokasi saat peta diinisialisasi
    Future.delayed(Duration.zero, () {
      final screenState = context.findAncestorStateOfType<_PropertyDetailScreenState>();
      if (screenState != null) {
        screenState._getLocationName(widget.latitude, widget.longitude);
      }
    });
  }

  @override
Widget build(BuildContext context) {
  final location = LatLng(widget.latitude, widget.longitude);

  return Stack(
    children: [
      FlutterMap(
        mapController: mapController,
        options: MapOptions(
          initialCenter: location,
          initialZoom: zoomLevel,
          interactionOptions: const InteractionOptions(
            flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
          ),
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.app',
          ),
          MarkerLayer(
            markers: [
              Marker(
                point: location,
                child: const Icon(
                  Icons.location_on,
                  color: Colors.red,
                  size: 40,
                ),
              ),
            ],
          ),
        ],
      ),
      Positioned(
        top: 16,
        right: 16,
        child: Column(
          children: [
            IconButton(
              onPressed: () {
                setState(() => zoomLevel += 1);
                mapController.move(mapController.camera.center, zoomLevel);
              },
              icon: const Icon(Icons.add),
            ),
            IconButton(
              onPressed: () {
                setState(() => zoomLevel -= 1);
                mapController.move(mapController.camera.center, zoomLevel);
              },
              icon: const Icon(Icons.remove), // ← sebelumnya salah pakai 'child'
            ),
          ],
        ),
      ),
    ],
  );
}
}
