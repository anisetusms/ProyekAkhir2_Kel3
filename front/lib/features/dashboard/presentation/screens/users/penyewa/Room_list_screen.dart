import 'package:front/features/room/data/models/new_room_model.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:front/features/dashboard/presentation/screens/users/penyewa/booking/create_booking.dart';
class RoomListScreen extends StatefulWidget {
  final int propertyId;

  const RoomListScreen({
    Key? key,
    required this.propertyId,
  }) : super(key: key);

  @override
  _RoomListScreenState createState() => _RoomListScreenState();
}

class _RoomListScreenState extends State<RoomListScreen> {
  late Future<List<Room>> _roomsFuture;
  final String _baseUrl = 'http://192.168.43.197:8000/api';

  @override
  void initState() {
    super.initState();
    _loadRooms();
  }

  Future<List<Room>> _fetchRoomsByProperty(int propertyId) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/properties/$propertyId/rooms'),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return (data['data']['data'] as List)
            .map((roomJson) => Room.fromJson(roomJson))
            .toList();
      } else if (response.statusCode == 404) {
        throw Exception('Property not found');
      } else {
        throw Exception('Failed to load rooms: ${response.statusCode}');
      }
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
        title: Text('Kamar '),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _loadRooms,
          ),
        ],
      ),
      body: FutureBuilder<List<Room>>(
        future: _roomsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return _buildErrorWidget(snapshot.error.toString());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.king_bed, size: 50, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'Tidak ada kamar tersedia',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async => _loadRooms(),
            child: ListView.builder(
              padding: EdgeInsets.all(8),
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
          Icon(Icons.error_outline, color: Colors.red, size: 50),
          SizedBox(height: 16),
          Text(
            'Gagal memuat data kamar',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              error,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.red),
            ),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: _loadRooms,
            child: Text('Coba Lagi'),
          ),
        ],
      ),
    );
  }

  Widget _buildRoomCard(Room room) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          ListTile(
            title: Text(
              '${room.roomType} - ${room.roomNumber}',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              'Rp${room.price.toStringAsFixed(2)}/malam',
              style: TextStyle(color: Colors.green),
            ),
            trailing: Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: room.isAvailable ? Colors.green[50] : Colors.red[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: room.isAvailable ? Colors.green : Colors.red,
                  width: 1,
                ),
              ),
              child: Text(
                room.isAvailable ? 'Tersedia' : 'Terisi',
                style: TextStyle(
                  color: room.isAvailable ? Colors.green : Colors.red,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (room.size != null)
                  _buildDetailRow(Icons.aspect_ratio, 'Ukuran: ${room.size}'),
                if (room.capacity != null)
                  _buildDetailRow(Icons.people, 'Kapasitas: ${room.capacity} orang'),
                if (room.description != null)
                  _buildDetailRow(Icons.description, room.description!),
                if (room.facilities != null && room.facilities!.isNotEmpty) ...[
                  SizedBox(height: 8),
                  Text(
                    'Fasilitas:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  Wrap(
                    spacing: 4,
                    runSpacing: 4,
                    children: room.facilities!
                        .map((facility) => Chip(
                              label: Text(facility.facilityName),
                              visualDensity: VisualDensity.compact,
                              backgroundColor: Colors.blue[50],
                            ))
                        .toList(),
                  ),
                ],
                SizedBox(height: 12),
                // SizedBox(
                //   width: double.infinity,
                //   child: ElevatedButton(
                //     onPressed: room.isAvailable
                //         ? () {
                //             // Navigasi ke booking screen
                //           }
                //         : null,
                //     style: ElevatedButton.styleFrom(
                //       backgroundColor:
                //           room.isAvailable ? Colors.green : Colors.grey,
                //       shape: RoundedRectangleBorder(
                //         borderRadius: BorderRadius.circular(8),
                //       ),
                //     ),
                //     child: Text(
                //       room.isAvailable ? 'Pesan Sekarang' : 'Tidak Tersedia',
                //       style: TextStyle(color: Colors.white),
                //     ),
                //   ),
                // ),
                SizedBox(
  width: double.infinity,
  child: ElevatedButton(
    onPressed: room.isAvailable
        ? () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CreateBookingScreen(
                  propertyId: widget.propertyId,
                  room: room, // Kirim data kamar yang dipilih
                ),
              ),
            );
          }
        : null,
    style: ElevatedButton.styleFrom(
      backgroundColor: room.isAvailable ? Colors.green : Colors.grey,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
    child: Text(
      room.isAvailable ? 'Pesan Sekarang' : 'Tidak Tersedia',
      style: TextStyle(color: Colors.white),
    ),
  ),
),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: Colors.grey),
          SizedBox(width: 8),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}