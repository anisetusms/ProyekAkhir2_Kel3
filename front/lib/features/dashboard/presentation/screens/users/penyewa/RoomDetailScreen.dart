import 'package:flutter/material.dart';
import 'package:front/features/room/data/models/room_detail.dart';
import 'package:front/features/room/data/models/room_image.dart';
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
  late Future<Map<String, dynamic>> _dataFuture;

  @override
  void initState() {
    super.initState();
    // Mengambil data kamar dan gambar sekaligus
    _dataFuture = _fetchRoomDetailAndImages();
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
      body: FutureBuilder<Map<String, dynamic>>(
        future: _dataFuture,
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
                          _dataFuture = _fetchRoomDetailAndImages();
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

          final data = snapshot.data!;
          final roomDetail = data['roomDetail'] as RoomDetail;
          final roomImages = data['roomImages'] as List<RoomImage>;

          return _buildRoomDetailContent(roomDetail, roomImages);
        },
      ),
    );
  }

  Widget _buildRoomDetailContent(
    RoomDetail roomDetail,
    List<RoomImage> images,
  ) {
    // Debug print untuk memeriksa apakah gambar tersedia
    print('Room images: ${images.length}');

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Gambar utama kamar
          if (images.isNotEmpty)
            Stack(
              children: [
                Image.network(
                  '${Constants.baseUrlImage}/storage/${images[0].imageUrl}',
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
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Rp ${_formatPrice(roomDetail.price)}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                          TextSpan(
                            text:
                                widget.propertyId == 1 ? '/bulan' : '/hari',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color:
                                  Colors
                                      .black, // Warna hitam untuk "bulan"/"hari"
                            ),
                          ),
                        ],
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
                          Text('${roomDetail.size} m²'),
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
                if (images.length > 1) ...[
                  const Text(
                    'Galeri Gambar',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 120,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: images.length,
                      itemBuilder: (context, index) {
                        // Skip the first image as it's already shown at the top
                        if (index == 0 && images.length > 1) {
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
                                '${Constants.baseUrlImage}/storage/${images[index].imageUrl}',
                                fit: BoxFit.cover,
                                height: 120,
                                width: 120,
                                errorBuilder: (context, error, stackTrace) {
                                  print("Error loading gallery image: $error");
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

  // Metode untuk mengambil data kamar dan gambar sekaligus
  Future<Map<String, dynamic>> _fetchRoomDetailAndImages() async {
    try {
      final apiClient = ApiClient();

      // Ambil detail kamar
      final roomDetailResponse = await apiClient.get(
        '/properties/${widget.propertyId}/rooms/${widget.roomId}',
      );

      print('API Response for room detail: $roomDetailResponse');

      RoomDetail roomDetail;
      if (roomDetailResponse != null &&
          roomDetailResponse is Map<String, dynamic>) {
        if (roomDetailResponse.containsKey('success') &&
            roomDetailResponse.containsKey('data')) {
          roomDetail = RoomDetail.fromJson(
            roomDetailResponse['data'] as Map<String, dynamic>,
          );
        } else if (roomDetailResponse.containsKey('data')) {
          roomDetail = RoomDetail.fromJson(
            roomDetailResponse['data'] as Map<String, dynamic>,
          );
        } else {
          roomDetail = RoomDetail.fromJson(roomDetailResponse);
        }
      } else {
        throw Exception('Format respons tidak valid untuk detail kamar');
      }

      // Ambil gambar kamar langsung dari database
      List<RoomImage> roomImages = [];

      // Buat endpoint baru untuk mengambil gambar kamar
      final imagesResponse = await apiClient.get(
        '/room-images/${widget.roomId}',
      );
      print('API Response for room images: $imagesResponse');

      if (imagesResponse != null &&
          imagesResponse is Map<String, dynamic> &&
          imagesResponse.containsKey('success') &&
          imagesResponse['success'] == true) {
        if (imagesResponse.containsKey('data') &&
            imagesResponse['data'] is List) {
          final List<dynamic> imagesData = imagesResponse['data'];
          roomImages =
              imagesData
                  .map(
                    (item) => RoomImage.fromJson(item as Map<String, dynamic>),
                  )
                  .toList();
        }
      }

      // // Jika tidak ada gambar dari API, buat gambar dummy untuk testing
      // if (roomImages.isEmpty) {
      //   print('No images found from API, creating dummy images for testing');
      //   // Gunakan data dari database yang Anda berikan
      //   roomImages = [
      //     RoomImage(
      //       id: 56,
      //       roomId: widget.roomId,
      //       imageUrl:
      //           'room_images/zd3nM1mR9n6rZbHbJ4Z31IXSmOgrLbbRxymxuYql.jpg',
      //       isMain: true,
      //     ),
      //     RoomImage(
      //       id: 57,
      //       roomId: widget.roomId,
      //       imageUrl:
      //           'room_images/gallery/uope1LIC0KHUHSL8q6If4IHTMHCwP2WzZAYmTr6T.jpg',
      //       isMain: false,
      //     ),
      //     RoomImage(
      //       id: 58,
      //       roomId: widget.roomId,
      //       imageUrl:
      //           'room_images/gallery/wB3vYeFowVsPIK1OhNAAXY0AemuN4rwCpWqIfpOJ.jpg',
      //       isMain: false,
      //     ),
      //     RoomImage(
      //       id: 59,
      //       roomId: widget.roomId,
      //       imageUrl:
      //           'room_images/gallery/1DPdSgfAgwVcPWRNKprUZaasKChwO5fg6MaaIdcW.jpg',
      //       isMain: false,
      //     ),
      //     RoomImage(
      //       id: 60,
      //       roomId: widget.roomId,
      //       imageUrl:
      //           'room_images/gallery/c7yIhOY85RxogEEiWhhgmG2Aw4luhnZyDiNCfMRs.jpg',
      //       isMain: false,
      //     ),
      //     RoomImage(
      //       id: 61,
      //       roomId: widget.roomId,
      //       imageUrl:
      //           'room_images/gallery/b1kJLBp8DVu576wDD3UwpmeOIIFhYgNNJAbGpzCJ.jpg',
      //       isMain: false,
      //     ),
      //   ];
      // }

      return {'roomDetail': roomDetail, 'roomImages': roomImages};
    } catch (e) {
      print('Error fetching room details and images: $e');
      throw Exception('Error: $e');
    }
  }
String _formatPrice(double price) {
    return price
        .toStringAsFixed(0)
        .replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
        );
  }
}
