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
  late TextEditingController _priceController;
  late TextEditingController _sizeController;
  late TextEditingController _capacityController;
  late TextEditingController _descriptionController;

  late bool _isAvailable;
  List<TextEditingController> _facilityControllers = [];
  final RoomRepository _roomRepository = RoomRepository();

  @override
  void initState() {
    super.initState();
    _roomTypeController = TextEditingController(text: widget.room.roomType);
    _roomNumberController = TextEditingController(text: widget.room.roomNumber);
    _priceController = TextEditingController(text: widget.room.price.toString());
    _sizeController = TextEditingController(text: widget.room.size ?? '');
    _capacityController = TextEditingController(text: widget.room.capacity?.toString() ?? '');
    _descriptionController = TextEditingController(text: widget.room.description ?? '');
    _isAvailable = widget.room.isAvailable;
    _loadFacilities();
  }

  Future<void> _loadFacilities() async {
    if (widget.room.id != 0) {
      final facilities = await _roomRepository.getRoomFacilities(widget.room.id);
      setState(() {
        _facilityControllers = facilities
            .map((facility) => TextEditingController(text: facility.facilityName))
            .toList();
      });
    }
  }

  void _addFacilityField() {
    setState(() {
      _facilityControllers.add(TextEditingController());
    });
  }

  void _removeFacilityField(int index) {
    setState(() {
      _facilityControllers[index].dispose();
      _facilityControllers.removeAt(index);
    });
  }

  Future<void> _updateRoom() async {
    if (_formKey.currentState!.validate()) {
      final updatedRoom = Room(
        id: widget.room.id,
        propertyId: widget.room.propertyId,
        roomType: _roomTypeController.text.trim(),
        roomNumber: _roomNumberController.text.trim(),
        price: num.tryParse(_priceController.text) ?? 0,
        size: _sizeController.text.isNotEmpty ? _sizeController.text.trim() : null,
        capacity: _capacityController.text.isNotEmpty ? int.tryParse(_capacityController.text) : null,
        isAvailable: _isAvailable,
        description: _descriptionController.text.isNotEmpty ? _descriptionController.text.trim() : null,
        facilities: [], // Fasilitas akan diupdate terpisah
      );

      try {
        Room? editedRoom = await _roomRepository.updateRoom(updatedRoom);

        if (!mounted) return;

        if (editedRoom != null) {
          // Hapus semua fasilitas yang ada terlebih dahulu
          final existingFacilities = await _roomRepository.getRoomFacilities(widget.room.id);
          for (var facility in existingFacilities) {
            await _roomRepository.deleteRoomFacility(facility.id);
          }

          // Tambahkan fasilitas yang baru
          for (var controller in _facilityControllers) {
            if (controller.text.trim().isNotEmpty) {
              await _roomRepository.addRoomFacility(widget.room.id, controller.text.trim(), propertyId: widget.room.propertyId);
            }
          }

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Kamar berhasil diperbarui')),
          );
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Gagal memperbarui kamar')),
          );
        }
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal memperbarui kamar: $error')),
        );
      }
    }
  }

  @override
  void dispose() {
    _roomTypeController.dispose();
    _roomNumberController.dispose();
    _priceController.dispose();
    _sizeController.dispose();
    _capacityController.dispose();
    _descriptionController.dispose();
    for (var controller in _facilityControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Kamar')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _roomTypeController,
                decoration: const InputDecoration(labelText: 'Tipe Kamar'),
                validator: (value) => value!.isEmpty ? 'Tipe kamar wajib diisi' : null,
              ),
              TextFormField(
                controller: _roomNumberController,
                decoration: const InputDecoration(labelText: 'Nomor Kamar'),
                validator: (value) => value!.isEmpty ? 'Nomor kamar wajib diisi' : null,
              ),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'Harga'),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Harga wajib diisi' : null,
              ),
              TextFormField(
                controller: _sizeController,
                decoration: const InputDecoration(labelText: 'Ukuran (opsional)'),
              ),
              TextFormField(
                controller: _capacityController,
                decoration: const InputDecoration(labelText: 'Kapasitas (opsional)'),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Deskripsi (opsional)'),
                maxLines: 3,
              ),
              SwitchListTile(
                title: const Text('Kamar Tersedia'),
                value: _isAvailable,
                onChanged: (value) {
                  setState(() {
                    _isAvailable = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              const Text(
                'Fasilitas Kamar',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              ..._facilityControllers.asMap().entries.map((entry) {
                int index = entry.key;
                TextEditingController controller = entry.value;
                return Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: controller,
                        decoration: InputDecoration(
                          labelText: 'Fasilitas ${index + 1}',
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _removeFacilityField(index),
                    ),
                  ],
                );
              }).toList(),
              TextButton.icon(
                onPressed: _addFacilityField,
                icon: const Icon(Icons.add),
                label: const Text('Tambah Fasilitas'),
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