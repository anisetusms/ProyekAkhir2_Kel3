// import 'package:flutter/material.dart';
// import 'package:front/features/room/data/models/room_detail.dart';
// import 'package:front/core/utils/constants.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert'; // Sesuaikan dengan import path Anda

// class RoomDetailScreen extends StatelessWidget {
//   final int propertyId;
//   final int roomId;

//   const RoomDetailScreen({
//     Key? key,
//     required this.propertyId,
//     required this.roomId,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Detail Kamar')),
//       body: FutureBuilder<RoomDetail>(
//         future: _fetchRoomDetail(
//           propertyId,
//           roomId,
//         ), // Mengambil detail kamar dari API
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           }

//           if (snapshot.hasError) {
//             return Center(child: Text('Gagal memuat data kamar'));
//           }

//           if (!snapshot.hasData) {
//             return Center(child: Text('Kamar tidak ditemukan'));
//           }

//           final roomDetail = snapshot.data!;
//           return SingleChildScrollView(
//             child: Column(
//               children: [
//                 // Gambar utama kamar
//                 Image.network(
//                   '${Constants.baseUrl}/storage/${roomDetail.images[0].imageUrl}',
//                   fit: BoxFit.cover,
//                   height: 250,
//                   width: double.infinity,
//                 ),

//                 SizedBox(height: 16),
//                 // Informasi kamar
//                 ListTile(
//                   title: Text(
//                     '${roomDetail.roomType} - ${roomDetail.roomNumber}',
//                     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                   ),
//                   subtitle: Text(
//                     'Rp${roomDetail.price.toStringAsFixed(2)}/malam',
//                     style: TextStyle(color: Colors.green),
//                   ),
//                 ),
//                 SizedBox(height: 16),
//                 // Fasilitas
//                 Text('Fasilitas:', style: TextStyle(fontSize: 16)),
//                 Wrap(
//                   spacing: 8,
//                   children:
//                       roomDetail.facilities
//                           .map(
//                             (facility) => Chip(
//                               label: Text(facility.facilityName),
//                               backgroundColor: Colors.blue[50],
//                             ),
//                           )
//                           .toList(),
//                 ),
//                 SizedBox(height: 16),
//                 // Galeri Gambar
//                 roomDetail.images.isNotEmpty
//                     ? Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text('Galeri Gambar:', style: TextStyle(fontSize: 16)),
//                         Wrap(
//                           spacing: 8,
//                           children:
//                               roomDetail.images
//                                   .map(
//                                     (image) => ClipRRect(
//                                       borderRadius: BorderRadius.circular(8),
//                                       child: Image.network(
//                                         '${Constants.baseUrl}/storage/${image.imageUrl}',
//                                         fit: BoxFit.cover,
//                                         height: 120,
//                                         width: 120,
//                                       ),
//                                     ),
//                                   )
//                                   .toList(),
//                         ),
//                       ],
//                     )
//                     : SizedBox(),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Future<RoomDetail> _fetchRoomDetail(int propertyId, int roomId) async {
//     final response = await http.get(
//       Uri.parse('${Constants.baseUrl}/properties/$propertyId/rooms/$roomId'),
//       headers: {'Accept': 'application/json'},
//     );

//     if (response.statusCode == 200) {
//       final data = json.decode(response.body);
//       return RoomDetail.fromJson(data['data']);
//     } else {
//       throw Exception('Failed to load room details');
//     }
//   }
// }

import 'package:flutter/material.dart';
import 'package:front/features/room/data/models/room_detail.dart';
import 'package:front/core/utils/constants.dart';
import 'package:front/core/network/api_client.dart';

class RoomDetailScreen extends StatefulWidget {
  final int propertyId;
  final int roomId;

  const RoomDetailScreen({
    Key? key,
    required this.propertyId,
    required this.roomId,
  }) : super(key: key);

  @override
  State<RoomDetailScreen> createState() => _RoomDetailScreenState();
}

class _RoomDetailScreenState extends State<RoomDetailScreen> {
  late Future<RoomDetail> _roomDetailFuture;

  @override
  void initState() {
    super.initState();
    _roomDetailFuture = _fetchRoomDetail(widget.propertyId, widget.roomId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Kamar'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: FutureBuilder<RoomDetail>(
        future: _roomDetailFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 60,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Gagal memuat data kamar: ${snapshot.error}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _roomDetailFuture = _fetchRoomDetail(
                            widget.propertyId,
                            widget.roomId,
                          );
                        });
                      },
                      child: const Text('Coba Lagi'),
                    ),
                  ],
                ),
              ),
            );
          }

          if (!snapshot.hasData) {
            return const Center(child: Text('Kamar tidak ditemukan'));
          }

          final roomDetail = snapshot.data!;
          return _buildRoomDetailContent(roomDetail);
        },
      ),
    );
  }

  Widget _buildRoomDetailContent(RoomDetail roomDetail) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Gambar utama kamar
          if (roomDetail.images.isNotEmpty)
            Stack(
              children: [
                Image.network(
                  '${Constants.baseUrlImage}/storage/${roomDetail.images[0].imageUrl}',
                  fit: BoxFit.cover,
                  height: 250,
                  width: double.infinity,
                  errorBuilder: (context, error, stackTrace) {
                    print("Error loading image: $error"); // Debugging error
                    return Container(
                      height: 250,
                      width: double.infinity,
                      color: Colors.grey[300],
                      child: const Center(
                        child: Icon(
                          Icons.image_not_supported,
                          size: 50,
                          color: Colors.grey,
                        ),
                      ),
                    );
                  },
                ),
                Positioned(
                  top: 16,
                  right: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: roomDetail.isAvailable ? Colors.green : Colors.red,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      roomDetail.isAvailable ? 'Tersedia' : 'Tidak Tersedia',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ],
            )
          else
            Container(
              height: 250,
              width: double.infinity,
              color: Colors.grey[300],
              child: const Center(
                child: Icon(
                  Icons.image_not_supported,
                  size: 50,
                  color: Colors.grey,
                ),
              ),
            ),

          // Informasi kamar
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        '${roomDetail.roomType} - ${roomDetail.roomNumber}',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Text(
                      'Rp ${roomDetail.price.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}/malam',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Kapasitas dan ukuran
                if (roomDetail.capacity != null || roomDetail.size != null)
                  Container(
                    margin: const EdgeInsets.only(top: 8, bottom: 16),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        if (roomDetail.capacity != null) ...[
                          const Icon(Icons.people, color: Colors.blue),
                          const SizedBox(width: 8),
                          Text('${roomDetail.capacity} orang'),
                          const SizedBox(width: 24),
                        ],
                        if (roomDetail.size != null) ...[
                          const Icon(Icons.square_foot, color: Colors.blue),
                          const SizedBox(width: 8),
                          Text(roomDetail.size!),
                        ],
                      ],
                    ),
                  ),

                // Deskripsi
                if (roomDetail.description != null &&
                    roomDetail.description!.isNotEmpty) ...[
                  const Text(
                    'Deskripsi',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    roomDetail.description!,
                    style: const TextStyle(fontSize: 16, height: 1.5),
                  ),
                  const SizedBox(height: 24),
                ],

                // Fasilitas
                if (roomDetail.roomFacilities.isNotEmpty) ...[
                  const Text(
                    'Fasilitas',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children:
                        roomDetail.roomFacilities
                            .map(
                              (facility) => Chip(
                                label: Text(facility.facilityName),
                                backgroundColor: Colors.blue[50],
                                labelStyle: TextStyle(color: Colors.blue[800]),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 0,
                                ),
                              ),
                            )
                            .toList(),
                  ),
                  const SizedBox(height: 24),
                ],

                // Galeri Gambar
                if (roomDetail.images.length > 1) ...[
                  const Text(
                    'Galeri Gambar',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 120,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: roomDetail.images.length,
                      itemBuilder: (context, index) {
                        // Skip the first image as it's already shown at the top
                        if (index == 0 && roomDetail.images.length > 1) {
                          return const SizedBox.shrink();
                        }
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: GestureDetector(
                            onTap: () {
                              // Implement image viewer here if needed
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                '${Constants.baseUrlImage}/storage/${roomDetail.images[index].imageUrl}',
                                fit: BoxFit.cover,
                                height: 120,
                                width: 120,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    height: 120,
                                    width: 120,
                                    color: Colors.grey[300],
                                    child: const Center(
                                      child: Icon(
                                        Icons.image_not_supported,
                                        size: 30,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<RoomDetail> _fetchRoomDetail(int propertyId, int roomId) async {
    try {
      final apiClient = ApiClient();

      final response = await apiClient.get(
        '/properties/$propertyId/rooms/$roomId',
      );

      print('API Response: $response'); // Debugging

      if (response != null) {
        if (response is Map<String, dynamic>) {
          if (response.containsKey('success') && response.containsKey('data')) {
            if (response['data'] is Map<String, dynamic>) {
              return RoomDetail.fromJson(
                response['data'] as Map<String, dynamic>,
              );
            }
          } else if (response.containsKey('data')) {
            return RoomDetail.fromJson(
              response['data'] as Map<String, dynamic>,
            );
          } else {
            return RoomDetail.fromJson(response);
          }
        }
        throw Exception('Format respons tidak valid: ${response.runtimeType}');
      } else {
        throw Exception('Tidak ada respons dari server');
      }
    } catch (e) {
      print('Error fetching room details: $e');
      throw Exception('Error: $e');
    }
  }
}
