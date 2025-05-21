import 'package:flutter/material.dart';
import 'package:front/features/dashboard/presentation/screens/users/penyewa/booking/create_booking.dart';
import 'package:front/features/room/data/models/new_room_model.dart';
import 'package:front/core/utils/constants.dart';
import 'package:front/features/dashboard/presentation/screens/users/penyewa/RoomDetailScreen.dart';
import 'package:front/core/network/api_client.dart';
import 'package:front/features/room/data/models/room_image.dart';

class RoomListScreen extends StatefulWidget {
  final int propertyId;
  final int propertyTypeId;

  const RoomListScreen({
    Key? key,
    required this.propertyId,
    required this.propertyTypeId,
  }) : super(key: key);

  @override
  _RoomListScreenState createState() => _RoomListScreenState();
}

class _RoomListScreenState extends State<RoomListScreen> {
  late Future<List<Room>> _roomsFuture;
  final String _baseurl = Constants.baseUrl;

  @override
  void initState() {
    super.initState();
    _loadRooms();
  }

  Future<List<Room>> _fetchRoomsByProperty(int propertyId) async {
    try {
      final apiClient = ApiClient();
      final response = await apiClient.get(
        '$_baseurl/properties/$propertyId/rooms',
      );

      print('Response: $response');

      if (response is Map<String, dynamic>) {
        if (response['success'] == true && response['data'] != null) {
          if (response['data']['data'] != null &&
              response['data']['data'] is List) {
            final rooms =
                (response['data']['data'] as List)
                    .map((roomJson) => Room.fromJson(roomJson))
                    .toList();
            return rooms;
          } else {
            throw Exception(
              'Format data tidak mengandung List kamar yang valid',
            );
          }
        }
      }

      throw Exception('Gagal memuat kamar: ${response['message']}');
    } catch (e) {
      print('Error fetching rooms: $e');
      throw Exception('Error fetching rooms: $e');
    }
  }

  void _loadRooms() {
    setState(() {
      _roomsFuture = _fetchRoomsByProperty(widget.propertyId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Kamar'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadRooms,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: FutureBuilder<List<Room>>(
        future: _roomsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return _buildErrorWidget(snapshot.error.toString());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.king_bed, size: 50, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text(
                    'Tidak ada kamar tersedia',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loadRooms,
                    child: const Text('Coba Lagi'),
                  ),
                ],
              ),
            );
          }
          return RefreshIndicator(
            onRefresh: () async => _loadRooms(),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final room = snapshot.data![index];
                return _buildRoomCard(room);
              },
            ),
          );
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
          const Text(
            'Gagal memuat data kamar',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              error,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.red),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(onPressed: _loadRooms, child: const Text('Coba Lagi')),
        ],
      ),
    );
  }

  Widget _buildRoomCard(Room room) {
    String? imageUrl;
    if (room.images.isNotEmpty) {
      imageUrl = '${Constants.baseUrlImage}/storage/${room.images[0].imageUrl}';
    }

    // Menghitung harga berdasarkan tipe properti
    String priceText = 'Rp ${_formatPrice(room.price)}';
    if (widget.propertyTypeId == 1) {
      priceText =
          'Rp ${_formatPrice(room.price)}/bulan'; 
    } else {
      priceText = 'Rp ${_formatPrice(room.price)}/hari';
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                height: 180,
                width: double.infinity,
                color: Colors.grey[200],
                child:
                    imageUrl != null
                        ? Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                          height: 180,
                          width: double.infinity,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                value:
                                    loadingProgress.expectedTotalBytes != null
                                        ? loadingProgress
                                                .cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                        : null,
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return _buildPlaceholderImage();
                          },
                        )
                        : _buildPlaceholderImage(),
              ),
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: room.isAvailable ? Colors.green : Colors.red,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    room.isAvailable ? 'Tersedia' : 'Terisi',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ],
          ),
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
                        '${room.roomType} - ${room.roomNumber}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Text(
                      priceText, // Menggunakan priceText yang sudah disesuaikan
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                if (room.size != null || room.capacity != null)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        if (room.capacity != null) ...[
                          const Icon(
                            Icons.people,
                            color: Color(0xFF4CAF50),
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text('${room.capacity} orang'),
                          const SizedBox(width: 16),
                        ],
                        if (room.size != null) ...[
                          const Icon(
                            Icons.square_foot,
                            color: Color(0xFF4CAF50),
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text('${room.size} m²'),
                        ],
                      ],
                    ),
                  ),
                const SizedBox(height: 12),
                if (room.description != null && room.description!.isNotEmpty)
                  Text(
                    room.description!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => RoomDetailScreen(
                                    propertyId: widget.propertyId,
                                    roomId: room.id,
                                  ),
                            ),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          side: const BorderSide(color: Color(0xFF4CAF50)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Detail',
                          style: TextStyle(color: Color(0xFF4CAF50)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed:
                            room.isAvailable
                                ? () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) =>
                                              CreateBookingEnhancedScreen(
                                                propertyId: widget.propertyId,
                                                propertyTypeId:
                                                    widget.propertyTypeId,
                                                room: room,
                                              ),
                                    ),
                                  );
                                }
                                : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF4CAF50),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Pesan',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholderImage() {
    return const Center(
      child: Icon(Icons.king_bed, size: 60, color: Colors.grey),
    );
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
