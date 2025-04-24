import 'package:flutter/material.dart';
import 'package:front/features/room/data/models/room_model.dart';
import 'package:front/features/room/data/repositories/room_repository.dart';

class EditRoomScreen extends StatefulWidget {
  static const routeName = '/edit_room';
  final Room room;

  const EditRoomScreen({Key? key, required this.room}) : super(key: key);

  @override
  _EditRoomScreenState createState() => _EditRoomScreenState();
}

class _EditRoomScreenState extends State<EditRoomScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _roomTypeController;
  late TextEditingController _roomNumberController;
  late TextEditingController _descriptionController;
  late TextEditingController _priceController;
  late TextEditingController _sizeController;
  late TextEditingController _capacityController;
  late TextEditingController _isAvailableController;
  final RoomRepository _roomRepository = RoomRepository();

  @override
  void initState() {
    super.initState();
    _roomTypeController = TextEditingController(text: widget.room.roomType);
    _roomNumberController = TextEditingController(text: widget.room.roomNumber);
    _descriptionController = TextEditingController(text: widget.room.description ?? '');
    _priceController = TextEditingController(text: widget.room.price.toString());
    _sizeController = TextEditingController(text: widget.room.size ?? '');
    _capacityController = TextEditingController(text: widget.room.capacity?.toString() ?? '');
    _isAvailableController = TextEditingController(text: widget.room.isAvailable.toString());
  }

  Future<void> _updateRoom() async {
    if (_formKey.currentState!.validate()) {
      final updatedRoom = Room(
        id: widget.room.id,
        propertyId: widget.room.propertyId,
        roomType: _roomTypeController.text,
        roomNumber: _roomNumberController.text,
        description: _descriptionController.text,
        price: double.parse(_priceController.text),
        size: _sizeController.text.isNotEmpty ? _sizeController.text : null,
        capacity: int.tryParse(_capacityController.text),
        isAvailable: _isAvailableController.text.toLowerCase() == 'true',
      );

      Room? updated = await _roomRepository.updateRoom(updatedRoom);
      if (updated != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Kamar berhasil diperbarui')),
        );
        Navigator.pop(context); // Kembali ke daftar kamar
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal memperbarui kamar')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Kamar'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                controller: _roomTypeController,
                decoration: const InputDecoration(labelText: 'Tipe Kamar'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Tipe kamar tidak boleh kosong';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _roomNumberController,
                decoration: const InputDecoration(labelText: 'Nomor Kamar'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nomor kamar tidak boleh kosong';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Deskripsi (Opsional)'),
              ),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'Harga'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Harga tidak boleh kosong';
                  }
                  if (double.tryParse(value) == null || double.parse(value) < 0) {
                    return 'Masukkan harga yang valid';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _sizeController,
                decoration: const InputDecoration(labelText: 'Ukuran (Opsional)'),
              ),
              TextFormField(
                controller: _capacityController,
                decoration: const InputDecoration(labelText: 'Kapasitas (Opsional)'),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _isAvailableController,
                decoration: const InputDecoration(labelText: 'Ketersediaan (true/false)'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ketersediaan tidak boleh kosong';
                  }
                  if (value.toLowerCase() != 'true' && value.toLowerCase() != 'false') {
                    return 'Masukkan "true" atau "false"';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _updateRoom,
                child: const Text('Simpan Perubahan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}