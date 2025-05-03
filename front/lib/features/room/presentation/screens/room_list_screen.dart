import 'package:flutter/material.dart';
import 'package:front/features/room/data/models/room_model.dart';
import 'package:front/features/room/data/repositories/room_repository.dart';
import 'package:front/core/widgets/loading_indicator.dart';
import 'package:front/core/widgets/error_state.dart';
import 'package:front/features/room/presentation/screens/add_room_screen.dart';
import 'package:front/features/room/presentation/screens/edit_room_screen.dart';
import 'package:intl/intl.dart';

class RoomListScreen extends StatefulWidget {
  static const routeName = '/manage_rooms';
  final int propertyId;

  const RoomListScreen({Key? key, required this.propertyId}) : super(key: key);

  @override
  _RoomListScreenState createState() => _RoomListScreenState();
}

class _RoomListScreenState extends State<RoomListScreen> {
  final RoomRepository _roomRepository = RoomRepository();
  late Future<List<Room>> _roomsFuture;

  @override
  void initState() {
    super.initState();
    _loadRooms();
    print(
      'Property ID di RoomListScreen: ${widget.propertyId}',
    ); // Verifikasi propertyId
  }

  Future<void> _loadRooms() async {
    setState(() {
      _roomsFuture = _roomRepository.getRoomsByPropertyId(widget.propertyId);
    });
  }

  Future<void> _deleteRoom(int roomId) async {
  bool success = await _roomRepository.deleteRoom(roomId, widget.propertyId); // Tambahkan widget.propertyId
  if (success) {
   ScaffoldMessenger.of(
    context,
   ).showSnackBar(const SnackBar(content: Text('Kamar berhasil dihapus')));
   _loadRooms();
  } else {
   ScaffoldMessenger.of(
    context,
   ).showSnackBar(const SnackBar(content: Text('Gagal menghapus kamar')));
  }
 }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Kamar Properti ${widget.propertyId}')),
      body: RefreshIndicator(
        onRefresh: _loadRooms,
        child: FutureBuilder<List<Room>>(
          future: _roomsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const LoadingIndicator();
            }
            if (snapshot.hasError) {
              return ErrorState(
                message: 'Gagal memuat kamar: ${snapshot.error}',
                onRetry: _loadRooms,
              );
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                child: Text('Belum ada kamar. Tambahkan kamar baru.'),
              );
            }
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final room = snapshot.data![index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${room.roomType} - No. ${room.roomNumber}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              'Rp ${NumberFormat('#,###').format(room.price)}',
                              style: const TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        if (room.size != null) Text('Ukuran: ${room.size}'),
                        if (room.capacity != null)
                          Text('Kapasitas: ${room.capacity} orang'),
                        Text(
                          'Status: ${room.isAvailable ? 'Tersedia' : 'Tidak Tersedia'}',
                        ),
                        if (room.facilities != null &&
                            room.facilities!.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 4,
                            children:
                                room.facilities!
                                    .map(
                                      (f) => Chip(
                                        label: Text(f.facilityName),
                                        backgroundColor: Colors.grey[200],
                                        labelPadding:
                                            const EdgeInsets.symmetric(
                                              horizontal: 4,
                                            ),
                                      ),
                                    )
                                    .toList(),
                          ),
                        ],
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed:
                                  () => Navigator.pushNamed(
                                    context,
                                    EditRoomScreen.routeName,
                                    arguments: room,
                                  ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _deleteRoom(room.id),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.pushNamed(
            context,
            AddRoomScreen.routeName,
            arguments: widget.propertyId,
          );
        },
      ),
    );
  }
}
