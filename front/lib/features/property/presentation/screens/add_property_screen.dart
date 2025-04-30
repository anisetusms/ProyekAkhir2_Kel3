import 'dart:io';
import 'dart:convert'; // Import untuk jsonDecode
import 'package:flutter/material.dart';
// import 'package:front/core/network/api_client.dart';
import 'package:front/core/utils/constants.dart';
import 'package:front/features/property/presentation/widgets/location_input.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
// import 'package:async/async.dart';
import 'package:flutter/foundation.dart'; 
import 'package:shared_preferences/shared_preferences.dart';

class AddPropertyScreen extends StatefulWidget {
  static const routeName = '/add_property';

  @override
  _AddPropertyScreenState createState() => _AddPropertyScreenState();
}

class _AddPropertyScreenState extends State<AddPropertyScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _capacityController = TextEditingController();
  final TextEditingController _availableRoomsController = TextEditingController();
  final TextEditingController _rulesController = TextEditingController();
  final TextEditingController _totalRoomsController = TextEditingController();
  final TextEditingController _totalUnitsController = TextEditingController();
  final TextEditingController _availableUnitsController = TextEditingController();
  final TextEditingController _minimumStayController = TextEditingController();
  final TextEditingController _maximumGuestController = TextEditingController();
  final TextEditingController _checkinTimeController = TextEditingController();
  final TextEditingController _checkoutTimeController = TextEditingController();

  int? _propertyTypeId;
  int? _provinceId;
  int? _cityId;
  int? _districtId;
  int? _subdistrictId;
  String? _kostType;
  bool _mealIncluded = false;
  bool _laundryIncluded = false;
  bool _isLoading = false;
  String? _errorMessage;
  double? _latitude;
  double? _longitude;
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
  try {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
      print('File berhasil dipilih: ${pickedFile.path}');
    } else {
      print('Tidak ada gambar yang dipilih.');
    }
  } catch (e) {
    print('Gagal memilih gambar: $e');
  }
}


  Future<void> _uploadPropertyWithImage() async {
  if (_formKey.currentState!.validate()) {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token'); // Ambil token dari SharedPreferences

      if (token == null) {
        setState(() {
          _errorMessage = 'Token tidak ditemukan. Silakan login ulang.';
        });
        return;
      }

      var uri = Uri.parse('${Constants.baseUrl}/properties');
      var request = http.MultipartRequest('POST', uri);

      // Tambahkan header Authorization
      request.headers['Authorization'] = 'Bearer $token';
      request.headers['Accept'] = 'application/json';

      // Isi semua fields seperti sebelumnya
      request.fields['name'] = _nameController.text;
      request.fields['description'] = _descriptionController.text;
      request.fields['property_type_id'] = _propertyTypeId.toString();
      if (_provinceId != null) request.fields['province_id'] = _provinceId.toString();
      if (_cityId != null) request.fields['city_id'] = _cityId.toString();
      if (_districtId != null) request.fields['district_id'] = _districtId.toString();
      if (_subdistrictId != null) request.fields['subdistrict_id'] = _subdistrictId.toString();
      request.fields['price'] = _priceController.text;
      request.fields['address'] = _addressController.text;
      if (_latitude != null) request.fields['latitude'] = _latitude.toString();
      if (_longitude != null) request.fields['longitude'] = _longitude.toString();
      if (_capacityController.text.isNotEmpty) request.fields['capacity'] = _capacityController.text;
      if (_rulesController.text.isNotEmpty) request.fields['rules'] = _rulesController.text;

      // Tambahan untuk property_type_id 1 (Kost)
      if (_propertyTypeId == 1) {
        if (_availableRoomsController.text.isNotEmpty) request.fields['available_rooms'] = _availableRoomsController.text;
        if (_totalRoomsController.text.isNotEmpty) request.fields['total_rooms'] = _totalRoomsController.text;
        if (_kostType != null) request.fields['kost_type'] = _kostType!;
        request.fields['meal_included'] = _mealIncluded ? '1' : '0';
        request.fields['laundry_included'] = _laundryIncluded ? '1' : '0';
      }

      // Tambahan untuk property_type_id 2 (Apartemen, Guesthouse, dll)
      if (_propertyTypeId == 2) {
        if (_totalUnitsController.text.isNotEmpty) request.fields['total_units'] = _totalUnitsController.text;
        if (_availableUnitsController.text.isNotEmpty) request.fields['available_units'] = _availableUnitsController.text;
        if (_minimumStayController.text.isNotEmpty) request.fields['minimum_stay'] = _minimumStayController.text;
        if (_maximumGuestController.text.isNotEmpty) request.fields['maximum_guest'] = _maximumGuestController.text;
        if (_checkinTimeController.text.isNotEmpty) request.fields['checkin_time'] = _checkinTimeController.text;
        if (_checkoutTimeController.text.isNotEmpty) request.fields['checkout_time'] = _checkoutTimeController.text;
      }

      if (_imageFile != null) {
        request.files.add(await http.MultipartFile.fromPath('image', _imageFile!.path));
      }

      var response = await request.send();
      var responseBody = await response.stream.bytesToString();
      var parsedResponse = jsonDecode(responseBody);

      print('Response Body: $parsedResponse'); // Untuk debug

      if (response.statusCode == 200 && parsedResponse['message'] == 'Properti berhasil dibuat') {
  Navigator.pop(context);
} else {
  setState(() {
    _errorMessage = parsedResponse['message'] ?? 'Gagal menambahkan properti.';
  });
}
    } catch (e) {
      setState(() {
        _errorMessage = 'Terjadi kesalahan: $e';
      });
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
        // Konversi File ke Uint8List (bytes)
        return FutureBuilder<Uint8List>(
          future: _imageFile!.readAsBytes(),
          builder: (BuildContext context, AsyncSnapshot<Uint8List> snapshot) {
            if (snapshot.hasData) {
              // Buat data URI
              String base64Image = base64Encode(snapshot.data!);
              return Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: SizedBox(
                  height: 100,
                  width: double.infinity,
                  child: Image.network(
                    'data:image/png;base64,$base64Image', // Sesuaikan mime type jika perlu
                    fit: BoxFit.cover,
                  ),
                ),
              );
            } else if (snapshot.hasError) {
              return Text('Gagal menampilkan gambar.', style: TextStyle(color: Colors.red));
            } else {
              return CircularProgressIndicator();
            }
          },
        );
      } else {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: SizedBox(
            height: 100,
            width: double.infinity,
            child: Image.file(
              _imageFile!,
              fit: BoxFit.cover,
            ),
          ),
        );
      }
    } else {
      return Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: Text('Tidak ada gambar yang dipilih.', style: TextStyle(color: Colors.grey)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tambah Properti Baru')),
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
                child: Text('Pilih Gambar'),
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Nama Properti',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Nama tidak boleh kosong' : null,
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Deskripsi',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Harga',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Harga tidak boleh kosong' : null,
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _addressController,
                maxLines: 2,
                decoration: InputDecoration(
                  labelText: 'Alamat',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Alamat tidak boleh kosong' : null,
              ),
              SizedBox(height: 16.0),
              LocationInput(
                onProvinceChanged: (value) => _provinceId = value,
                onCityChanged: (value) => _cityId = value,
                onDistrictChanged: (value) => _districtId = value,
                onSubdistrictChanged: (value) => _subdistrictId = value,
                onCoordinatesChanged: (latitude, longitude) {
                  setState(() {
                    _latitude = latitude;
                    _longitude = longitude;
                  });
                },
              ),
              SizedBox(height: 16.0),
              DropdownButtonFormField<int>(
                decoration: InputDecoration(
                  labelText: 'Jenis Properti',
                  border: OutlineInputBorder(),
                ),
                value: _propertyTypeId,
                items: [
                  DropdownMenuItem(value: 1, child: Text('Kost')),
                  DropdownMenuItem(value: 2, child: Text('Homestay')),
                ],
                onChanged: (value) {
                  setState(() {
                    _propertyTypeId = value;
                  });
                },
                validator: (value) =>
                    value == null ? 'Jenis properti harus dipilih' : null,
              ),
              SizedBox(height: 16.0),
              if (_propertyTypeId == 1)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: _capacityController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Kapasitas (Orang)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 16.0),
                    TextFormField(
                      controller: _totalRoomsController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Total Kamar',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 16.0),
                    TextFormField(
                      controller: _availableRoomsController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Kamar Tersedia',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 16.0),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: 'Tipe Kost',
                        border: OutlineInputBorder(),
                      ),
                      value: _kostType,
                      items: [
                        DropdownMenuItem(value: 'putra', child: Text('Putra')),
                        DropdownMenuItem(value: 'putri', child: Text('Putri')),
                        DropdownMenuItem(value: 'campur', child: Text('Campur')),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _kostType = value;
                        });
                      },
                    ),
                    SizedBox(height: 16.0),
                    CheckboxListTile(
                      title: Text('Makan Termasuk'),
                      value: _mealIncluded,
                      onChanged: (value) {
                        setState(() {
                          _mealIncluded = value ?? false;
                        });
                      },
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                    CheckboxListTile(
                      title: Text('Laundry Termasuk'),
                      value: _laundryIncluded,
                      onChanged: (value) {
                        setState(() {
                          _laundryIncluded = value ?? false;
                        });
                      },
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                    TextFormField(
                      controller: _rulesController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        labelText: 'Peraturan Kost',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              if (_propertyTypeId == 2)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: _capacityController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Kapasitas (Orang)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 16.0),
                    TextFormField(
                      controller: _totalUnitsController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Total Unit',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 16.0),
                    TextFormField(
                      controller: _availableUnitsController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Unit Tersedia',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 16.0),
                    TextFormField(
                      controller: _minimumStayController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Minimum Menginap (Malam)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 16.0),
                    TextFormField(
                      controller: _maximumGuestController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Maksimum Tamu',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 16.0),
                    TextFormField(
                      controller: _checkinTimeController,
                      decoration: InputDecoration(
                        labelText: 'Waktu Check-in (HH:MM)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 16.0),
                    TextFormField(
                      controller: _checkoutTimeController,
                      decoration: InputDecoration(
                        labelText: 'Waktu Check-out (HH:MM)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 16.0),
                    TextFormField(
                      controller: _rulesController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        labelText: 'Peraturan Kost',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              SizedBox(height: 24.0),
              if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Text(
                    _errorMessage!,
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ElevatedButton(
                onPressed: _isLoading ? null : _uploadPropertyWithImage,
                child: _isLoading
                    ? CircularProgressIndicator()
                    : Text('Tambah Properti'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}