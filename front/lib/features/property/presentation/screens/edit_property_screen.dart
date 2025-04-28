import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:front/core/utils/constants.dart';
import 'package:front/features/property/presentation/widgets/location_input.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cached_network_image/cached_network_image.dart';

class EditPropertyScreen extends StatefulWidget {
  static const routeName = '/edit_property';
  final Map<String, dynamic> property;

  const EditPropertyScreen({Key? key, required this.property})
    : super(key: key);

  @override
  _EditPropertyScreenState createState() => _EditPropertyScreenState();
}

class _EditPropertyScreenState extends State<EditPropertyScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _priceController;
  late final TextEditingController _addressController;
  late final TextEditingController _capacityController;
  late final TextEditingController _availableRoomsController;
  late final TextEditingController _rulesController;
  late final TextEditingController _totalRoomsController;
  late final TextEditingController _totalUnitsController;
  late final TextEditingController _availableUnitsController;
  late final TextEditingController _minimumStayController;
  late final TextEditingController _maximumGuestController;
  late final TextEditingController _checkinTimeController;
  late final TextEditingController _checkoutTimeController;

  late int? _propertyTypeId;
  late int? _provinceId;
  late int? _cityId;
  late int? _districtId;
  late int? _subdistrictId;
  late String? _kostType;
  late bool _mealIncluded;
  late bool _laundryIncluded;
  bool _isLoading = false;
  String? _errorMessage;
  double? _latitude;
  double? _longitude;
  File? _imageFile;
  String? _currentImageUrl;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _parseLocationData();
  }

  void _parseLocationData() {
    final latitude = widget.property['latitude'];
    final longitude = widget.property['longitude'];

    _latitude = _parseDouble(latitude);
    _longitude = _parseDouble(longitude);
  }

  double? _parseDouble(dynamic value) {
    if (value == null) {
      return null;
    }
    if (value is num) {
      return value.toDouble();
    }
    if (value is String) {
      return double.tryParse(value);
    }
    return null; // Jika tipe data tidak valid
  }

  void _initializeControllers() {
    _nameController = TextEditingController(text: widget.property['name']);
    _descriptionController = TextEditingController(
      text: widget.property['description'],
    );
    _priceController = TextEditingController(
      text: widget.property['price']?.toString(),
    );
    _addressController = TextEditingController(
      text: widget.property['address'],
    );
    _capacityController = TextEditingController(
      text: widget.property['capacity']?.toString(),
    );
    _availableRoomsController = TextEditingController(
      text: widget.property['available_rooms']?.toString(),
    );
    _rulesController = TextEditingController(text: widget.property['rules']);
    _totalRoomsController = TextEditingController(
      text: widget.property['total_rooms']?.toString(),
    );
    _totalUnitsController = TextEditingController(
      text: widget.property['total_units']?.toString(),
    );
    _availableUnitsController = TextEditingController(
      text: widget.property['available_units']?.toString(),
    );
    _minimumStayController = TextEditingController(
      text: widget.property['minimum_stay']?.toString(),
    );
    _maximumGuestController = TextEditingController(
      text: widget.property['maximum_guest']?.toString(),
    );
    _checkinTimeController = TextEditingController(
      text: widget.property['checkin_time'],
    );
    _checkoutTimeController = TextEditingController(
      text: widget.property['checkout_time'],
    );
    _propertyTypeId = widget.property['property_type_id'];
    _provinceId = widget.property['province_id'];
    _cityId = widget.property['city_id'];
    _districtId = widget.property['district_id'];
    _subdistrictId = widget.property['subdistrict_id'];
    _kostType = widget.property['kost_type'];
    _mealIncluded = widget.property['meal_included'] == 1;
    _laundryIncluded = widget.property['laundry_included'] == 1;
    // _latitude dan _longitude akan di-parse di _parseLocationData()
    _currentImageUrl =
        widget.property['image'] != null
            ? '${Constants.baseUrl}/storage/properties/${widget.property['image']}'
            : null;
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
        _currentImageUrl = null;
      });
    }
  }

  Future<void> _updateProperty() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      try {
        final prefs = await SharedPreferences.getInstance();
        final token = prefs.getString('token');

        if (token == null) {
          setState(() {
            _errorMessage = 'Token tidak ditemukan. Silakan login ulang.';
          });
          return;
        }

        var uri = Uri.parse(
          '${Constants.baseUrl}/properties/${widget.property['id']}',
        );
        var request = http.MultipartRequest('PUT', uri);

        request.headers['Authorization'] = 'Bearer $token';
        request.headers['Accept'] = 'application/json';

        request.fields['_method'] = 'PUT'; // Untuk Laravel
        request.fields['name'] = _nameController.text;
        request.fields['description'] = _descriptionController.text;
        request.fields['property_type_id'] = _propertyTypeId.toString();
        request.fields['price'] = _priceController.text;
        request.fields['address'] = _addressController.text;

        if (_provinceId != null)
          request.fields['province_id'] = _provinceId.toString();
        if (_cityId != null) request.fields['city_id'] = _cityId.toString();
        if (_districtId != null)
          request.fields['district_id'] = _districtId.toString();
        if (_subdistrictId != null)
          request.fields['subdistrict_id'] = _subdistrictId.toString();
        if (_latitude != null)
          request.fields['latitude'] = _latitude.toString();
        if (_longitude != null)
          request.fields['longitude'] = _longitude.toString();

        if (_propertyTypeId == 1) {
          if (_capacityController.text.isNotEmpty)
            request.fields['capacity'] = _capacityController.text;
          if (_rulesController.text.isNotEmpty)
            request.fields['rules'] = _rulesController.text;
          if (_totalRoomsController.text.isNotEmpty)
            request.fields['total_rooms'] = _totalRoomsController.text;
          if (_availableRoomsController.text.isNotEmpty)
            request.fields['available_rooms'] = _availableRoomsController.text;
          if (_kostType != null) request.fields['kost_type'] = _kostType!;
          request.fields['meal_included'] = _mealIncluded ? '1' : '0';
          request.fields['laundry_included'] = _laundryIncluded ? '1' : '0';
        } else if (_propertyTypeId == 2) {
          if (_totalUnitsController.text.isNotEmpty)
            request.fields['total_units'] = _totalUnitsController.text;
          if (_availableUnitsController.text.isNotEmpty)
            request.fields['available_units'] = _availableUnitsController.text;
          if (_minimumStayController.text.isNotEmpty)
            request.fields['minimum_stay'] = _minimumStayController.text;
          if (_maximumGuestController.text.isNotEmpty)
            request.fields['maximum_guest'] = _maximumGuestController.text;
          if (_checkinTimeController.text.isNotEmpty)
            request.fields['checkin_time'] = _checkinTimeController.text;
          if (_checkoutTimeController.text.isNotEmpty)
            request.fields['checkout_time'] = _checkoutTimeController.text;
        }

        if (_imageFile != null) {
          request.files.add(
            await http.MultipartFile.fromPath('image', _imageFile!.path),
          );
        }

        var response = await request.send();
        var responseBody = await response.stream.bytesToString();
        var parsedResponse = jsonDecode(responseBody);

        debugPrint('Response update: $parsedResponse');

        if (response.statusCode == 200 && parsedResponse['success'] == true) {
          Navigator.pop(context, true);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Properti berhasil diperbarui')),
          );
        } else {
          setState(() {
            _errorMessage =
                parsedResponse['message'] ?? 'Gagal memperbarui properti';
          });
        }
      } catch (e) {
        setState(() {
          _errorMessage = 'Terjadi kesalahan: $e';
        });
        debugPrint('Error updating property: $e');
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Widget _buildImagePreview() {
    if (_imageFile != null) {
      if (kIsWeb) {
        return FutureBuilder<Uint8List>(
          future: _imageFile!.readAsBytes(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              String base64Image = base64Encode(snapshot.data!);
              return Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: SizedBox(
                  height: 150,
                  width: double.infinity,
                  child: Image.network(
                    'data:image/png;base64,$base64Image',
                    fit: BoxFit.cover,
                  ),
                ),
              );
            } else if (snapshot.hasError) {
              return Text(
                'Gagal menampilkan gambar',
                style: TextStyle(color: Colors.red),
              );
            }
            return const CircularProgressIndicator();
          },
        );
      } else {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: SizedBox(
            height: 150,
            width: double.infinity,
            child: Image.file(_imageFile!, fit: BoxFit.cover),
          ),
        );
      }
    } else if (_currentImageUrl != null) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: SizedBox(
          height: 150,
          width: double.infinity,
          child: CachedNetworkImage(
            imageUrl: _currentImageUrl!,
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(color: Colors.grey[200]),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: Text('Tidak ada gambar', style: TextStyle(color: Colors.grey)),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _addressController.dispose();
    _capacityController.dispose();
    _availableRoomsController.dispose();
    _rulesController.dispose();
    _totalRoomsController.dispose();
    _totalUnitsController.dispose();
    _availableUnitsController.dispose();
    _minimumStayController.dispose();
    _maximumGuestController.dispose();
    _checkinTimeController.dispose();
    _checkoutTimeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Properti'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildImagePreview(),
              ElevatedButton(
                onPressed: _pickImage,
                child: const Text('Ubah Gambar'),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nama Properti',
                  border: OutlineInputBorder(),
                ),
                validator:
                    (value) =>
                        value!.isEmpty ? 'Nama tidak boleh kosong' : null,
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Deskripsi',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(
                  labelText: 'Harga',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator:
                    (value) =>
                        value!.isEmpty ? 'Harga tidak boleh kosong' : null,
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(
                  labelText: 'Alamat',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
                validator:
                    (value) =>
                        value!.isEmpty ? 'Alamat tidak boleh kosong' : null,
              ),
              const SizedBox(height: 16.0),
              LocationInput(
                initialProvinceId: _provinceId,
                initialCityId: _cityId,
                initialDistrictId: _districtId,
                initialSubdistrictId: _subdistrictId,
                initialLatitude: _latitude,
                initialLongitude: _longitude,
                onProvinceChanged:
                    (value) => setState(() => _provinceId = value),
                onCityChanged: (value) => setState(() => _cityId = value),
                onDistrictChanged:
                    (value) => setState(() => _districtId = value),
                onSubdistrictChanged:
                    (value) => setState(() => _subdistrictId = value),
                onCoordinatesChanged: (lat, lng) {
                  setState(() {
                    _latitude = lat;
                    _longitude = lng;
                  });
                },
              ),
              const SizedBox(height: 16.0),
              DropdownButtonFormField<int>(
                decoration: const InputDecoration(
                  labelText: 'Jenis Properti',
                  border: OutlineInputBorder(),
                ),
                value: _propertyTypeId,
                items: const [
                  DropdownMenuItem(value: 1, child: Text('Kost')),
                  DropdownMenuItem(value: 2, child: Text('Homestay')),
                ],
                onChanged: (value) {
                  setState(() {
                    _propertyTypeId = value;
                  });
                },
              ),
              const SizedBox(height: 16.0),
              if (_propertyTypeId == 1)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: _capacityController,
                      decoration: const InputDecoration(
                        labelText: 'Kapasitas (Orang)',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16.0),
                    TextFormField(
                      controller: _totalRoomsController,
                      decoration: const InputDecoration(
                        labelText: 'Total Kamar',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16.0),
                    TextFormField(
                      controller: _availableRoomsController,
                      decoration: const InputDecoration(
                        labelText: 'Kamar Tersedia',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16.0),
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: 'Tipe Kost',
                        border: OutlineInputBorder(),
                      ),
                      value: _kostType,
                      items: const [
                        DropdownMenuItem(value: 'putra', child: Text('Putra')),
                        DropdownMenuItem(value: 'putri', child: Text('Putri')),
                        DropdownMenuItem(
                          value: 'campur',
                          child: Text('Campur'),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _kostType = value;
                        });
                      },
                    ),
                    const SizedBox(height: 16.0),
                    CheckboxListTile(
                      title: const Text('Makan Termasuk'),
                      value: _mealIncluded,
                      onChanged: (value) {
                        setState(() {
                          _mealIncluded = value ?? false;
                        });
                      },
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                    CheckboxListTile(
                      title: const Text('Laundry Termasuk'),
                      value: _laundryIncluded,
                      onChanged: (value) {
                        setState(() {
                          _laundryIncluded = value ?? false;
                        });
                      },
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                    const SizedBox(height: 16.0),
                    TextFormField(
                      controller: _rulesController,
                      decoration: const InputDecoration(
                        labelText: 'Peraturan Kost',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                    ),
                  ],
                ),
              if (_propertyTypeId == 2)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: _totalUnitsController,
                      decoration: const InputDecoration(
                        labelText: 'Total Unit',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16.0),
                    TextFormField(
                      controller: _availableUnitsController,
                      decoration: const InputDecoration(
                        labelText: 'Unit Tersedia',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16.0),
                    TextFormField(
                      controller: _minimumStayController,
                      decoration: const InputDecoration(
                        labelText: 'Minimum Menginap (Malam)',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16.0),
                    TextFormField(
                      controller: _maximumGuestController,
                      decoration: const InputDecoration(
                        labelText: 'Maksimum Tamu',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16.0),
                    TextFormField(
                      controller: _checkinTimeController,
                      decoration: const InputDecoration(
                        labelText: 'Waktu Check-in (HH:MM)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    TextFormField(
                      controller: _checkoutTimeController,
                      decoration: const InputDecoration(
                        labelText: 'Waktu Check-out (HH:MM)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 24.0),
              if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              ElevatedButton(
                onPressed: _isLoading ? null : _updateProperty,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
                child:
                    _isLoading
                        ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(),
                        )
                        : const Text('SIMPAN PERUBAHAN'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
