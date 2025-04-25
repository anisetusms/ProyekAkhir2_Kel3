import 'package:flutter/material.dart';
import 'package:front/features/room/data/models/room_model.dart';
import 'package:front/features/room/data/repositories/room_repository.dart';

class AddRoomScreen extends StatefulWidget {
  static const routeName = '/add_room';

  final int propertyId;

  const AddRoomScreen({super.key, required this.propertyId});

  @override
  State<AddRoomScreen> createState() => _AddRoomScreenState();
}

class _AddRoomScreenState extends State<AddRoomScreen> {
  final _formKey = GlobalKey<FormState>();

  final _roomTypeController = TextEditingController();
  final _roomNumberController = TextEditingController();
  final _priceController = TextEditingController();
  final _sizeController = TextEditingController();
  final _capacityController = TextEditingController();
  final _descriptionController = TextEditingController();

  bool _isAvailable = true;

  List<TextEditingController> _facilityControllers = [];

  final RoomRepository _roomRepository = RoomRepository();

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

  Future<void> _submitRoom() async {
    if (_formKey.currentState!.validate()) {
      final roomWithoutFacilities = Room(
        id: 0,
        propertyId: widget.propertyId,
        roomType: _roomTypeController.text.trim(),
        roomNumber: _roomNumberController.text.trim(),
        price: num.tryParse(_priceController.text) ?? 0,
        size:
            _sizeController.text.isNotEmpty
                ? _sizeController.text.trim()
                : null,
        capacity:
            _capacityController.text.isNotEmpty
                ? int.tryParse(_capacityController.text)
                : null,
        isAvailable: _isAvailable,
        description:
            _descriptionController.text.isNotEmpty
                ? _descriptionController.text.trim()
                : null,
        facilities: [], // Fasilitas diinisialisasi kosong
      );

      try {
        Room? addedRoom = await _roomRepository.addRoom(roomWithoutFacilities);
        print('Hasil addRoom: $addedRoom'); // Debugging: cek hasil addRoom

        if (!mounted) return;

        if (addedRoom != null) {
          // Tambahkan fasilitas satu per satu setelah kamar berhasil dibuat
          for (var controller in _facilityControllers) {
            if (controller.text.trim().isNotEmpty) {
              try {
                final facility = await _roomRepository.addRoomFacility(
                  addedRoom.id,
                  controller.text.trim(),
                  propertyId: widget.propertyId, // Pastikan ini ada
                );
                print('Fasilitas berhasil ditambahkan: $facility'); // Debugging
                if (facility == null) {
                  print(
                    'Gagal menambahkan fasilitas: ${controller.text.trim()}',
                  ); // Debugging
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Gagal menambahkan fasilitas: ${controller.text.trim()}',
                      ),
                    ),
                  );
                }
              } catch (e) {
                print(
                  'Error menambahkan fasilitas ${controller.text.trim()}: $e',
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Gagal menambahkan fasilitas: ${controller.text.trim()} - $e',
                    ),
                  ),
                );
              }
            }
          }
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Kamar berhasil ditambahkan')),
          );
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Gagal menambahkan kamar (respon null)'),
            ),
          );
        }
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menambahkan kamar: $error')),
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
      appBar: AppBar(title: const Text('Tambah Kamar')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _roomTypeController,
                decoration: const InputDecoration(labelText: 'Tipe Kamar'),
                validator:
                    (value) => value!.isEmpty ? 'Tipe kamar wajib diisi' : null,
              ),
              TextFormField(
                controller: _roomNumberController,
                decoration: const InputDecoration(labelText: 'Nomor Kamar'),
                validator:
                    (value) =>
                        value!.isEmpty ? 'Nomor kamar wajib diisi' : null,
              ),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'Harga'),
                keyboardType: TextInputType.number,
                validator:
                    (value) => value!.isEmpty ? 'Harga wajib diisi' : null,
              ),
              TextFormField(
                controller: _sizeController,
                decoration: const InputDecoration(
                  labelText: 'Ukuran (opsional)',
                ),
              ),
              TextFormField(
                controller: _capacityController,
                decoration: const InputDecoration(
                  labelText: 'Kapasitas (opsional)',
                ),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Deskripsi (opsional)',
                ),
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
                onPressed: _submitRoom,
                child: const Text('Simpan Kamar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
