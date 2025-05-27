import 'package:flutter/material.dart';
import 'package:front/features/dashboard/presentation/screens/users/penyewa/booking/create_booking.dart';
import 'package:front/features/room/data/models/new_room_model.dart';
import 'package:front/core/utils/constants.dart';
import 'package:front/features/dashboard/presentation/screens/users/penyewa/RoomDetailScreen.dart';
import 'package:front/core/network/api_client.dart';

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

      if (response is Map<String, dynamic>) {
        if (response['success'] == true && response['data'] != null) {
          if (response['data']['data'] != null &&
              response['data']['data'] is List) {
            return (response['data']['data'] as List)
                .map((roomJson) => Room.fromJson(roomJson))
                .toList();
          }
        }
      }
      throw Exception('Gagal memuat kamar: ${response['message']}');
    } catch (e) {
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
    // Format price based on property type
    final priceText =
        widget.propertyTypeId == 1
            ? 'Rp ${_formatPrice(room.price)}/bulan'
            : 'Rp ${_formatPrice(room.price)}/hari';

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row with room info and availability
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Kamar ${room.roomNumber}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      room.roomType,
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                  ],
                ),
                Container(
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
              ],
            ),

            const SizedBox(height: 16),

            // Room details in a compact row
            Row(
              children: [
                if (room.capacity != null) ...[
                  _buildDetailChip(
                    icon: Icons.people,
                    label: '${room.capacity} orang',
                  ),
                  const SizedBox(width: 8),
                ],
                if (room.size != null) ...[
                  _buildDetailChip(
                    icon: Icons.square_foot,
                    label: '${room.size} m²',
                  ),
                ],
              ],
            ),

            const SizedBox(height: 16),

            // Price section with highlighted background
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Harga Sewa',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[700],
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Rp ${_formatPrice(room.price)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                        TextSpan(
                          text: widget.propertyTypeId == 1 ? ' / bulan' : ' / hari',
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
            ),

            // Description (if available)
            if (room.description != null && room.description!.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(
                room.description!,
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
            ],

            const SizedBox(height: 16),

            // Action buttons
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
                                      (context) => CreateBookingEnhancedScreen(
                                        propertyId: widget.propertyId,
                                        propertyTypeId: widget.propertyTypeId,
                                        room: room,
                                      ),
                                ),
                              );
                            }
                            : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4CAF50),
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
    );
  }

  Widget _buildDetailChip({required IconData icon, required String label}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.blue),
          const SizedBox(width: 4),
          Text(label, style: TextStyle(fontSize: 12, color: Colors.blue[800])),
        ],
      ),
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
