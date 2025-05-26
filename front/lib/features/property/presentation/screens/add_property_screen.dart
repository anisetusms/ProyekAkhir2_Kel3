import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:front/features/property/presentation/widgets/location_input.dart';
import 'package:front/core/utils/constants.dart';
import 'package:front/features/property/presentation/screens/property_list.dart'; // Impor PropertyListScreen

class AddPropertyScreen extends StatefulWidget {
  static const routeName = '/add_property';

  @override
  _AddPropertyScreenState createState() => _AddPropertyScreenState();
}

class _AddPropertyScreenState extends State<AddPropertyScreen> {
  final _formKey = GlobalKey<FormState>();
  final _scrollController = ScrollController();
  final List<TextEditingController> _controllers = List.generate(
    13,
    (index) => TextEditingController(),
  );

  // Controllers mapping for better readability
  TextEditingController get _nameController => _controllers[0];
  TextEditingController get _descriptionController => _controllers[1];
  TextEditingController get _priceController => _controllers[2];
  TextEditingController get _addressController => _controllers[3];
  TextEditingController get _capacityController => _controllers[4];
  TextEditingController get _availableRoomsController => _controllers[5];
  TextEditingController get _rulesController => _controllers[6];
  TextEditingController get _totalRoomsController => _controllers[7];
  TextEditingController get _totalUnitsController => _controllers[8];
  TextEditingController get _availableUnitsController => _controllers[9];
  TextEditingController get _minimumStayController => _controllers[10];
  TextEditingController get _maximumGuestController => _controllers[11];
  TextEditingController get _checkinTimeController => _controllers[12];
  TextEditingController get _checkoutTimeController => _controllers[13];

  int? _propertyTypeId;
  int? _provinceId;
  int? _cityId;
  int? _districtId;
  int? _subdistrictId;
  String? _kostType;
  bool _isLoading = false;
  String? _errorMessage;
  double? _latitude;
  double? _longitude;
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _scrollController.dispose();
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() => _imageFile = File(pickedFile.path));
      }
    } catch (e) {
      setState(() => _errorMessage = 'Gagal memilih gambar: $e');
    }
  }

  Future<void> _uploadPropertyWithImage() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        setState(
          () => _errorMessage = 'Token tidak ditemukan. Silakan login ulang.',
        );
        return;
      }

      var request =
          http.MultipartRequest(
              'POST',
              Uri.parse('${Constants.baseUrl}/properties'),
            )
            ..headers.addAll({
              'Authorization': 'Bearer $token',
              'Accept': 'application/json',
            })
            ..fields.addAll({
              'name': _nameController.text,
              'description': _descriptionController.text,
              'property_type_id': _propertyTypeId.toString(),
              'price': _priceController.text,
              'address': _addressController.text,
              if (_provinceId != null) 'province_id': _provinceId.toString(),
              if (_cityId != null) 'city_id': _cityId.toString(),
              if (_districtId != null) 'district_id': _districtId.toString(),
              if (_subdistrictId != null)
                'subdistrict_id': _subdistrictId.toString(),
              if (_latitude != null) 'latitude': _latitude.toString(),
              if (_longitude != null) 'longitude': _longitude.toString(),
              if (_capacityController.text.isNotEmpty)
                'capacity': _capacityController.text,
              if (_rulesController.text.isNotEmpty)
                'rules': _rulesController.text,
            });

      if (_propertyTypeId == 1) {
        request.fields.addAll({
          if (_availableRoomsController.text.isNotEmpty)
            'available_rooms': _availableRoomsController.text,
          if (_totalRoomsController.text.isNotEmpty)
            'total_rooms': _totalRoomsController.text,
        });
      }

      if (_propertyTypeId == 2) {
        request.fields.addAll({
          if (_totalUnitsController.text.isNotEmpty)
            'total_units': _totalUnitsController.text,
          if (_availableUnitsController.text.isNotEmpty)
            'available_units': _availableUnitsController.text,
          if (_minimumStayController.text.isNotEmpty)
            'minimum_stay': _minimumStayController.text,
          if (_maximumGuestController.text.isNotEmpty)
            'maximum_guest': _maximumGuestController.text,
          if (_checkinTimeController.text.isNotEmpty)
            'checkin_time': _checkinTimeController.text,
          if (_checkoutTimeController.text.isNotEmpty)
            'checkout_time': _checkoutTimeController.text,
        });
      }

      if (_imageFile != null) {
        request.files.add(
          await http.MultipartFile.fromPath('image', _imageFile!.path),
        );
      }

      var response = await request.send();
      var responseBody = await response.stream.bytesToString();
      var parsedResponse = jsonDecode(responseBody);
      if (response.statusCode == 200 &&
          parsedResponse['message'] == 'Properti berhasil dibuat') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => PropertyListScreen(),
          ), // Ganti ke layar daftar properti setelah sukses
        );
      } else {
        setState(
          () =>
              _errorMessage =
                  parsedResponse['message'] ?? 'Gagal menambahkan properti.',
        );
      }
    } catch (e) {
      setState(() => _errorMessage = 'Terjadi kesalahan: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Widget _buildImagePreview() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Foto Properti',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        SizedBox(height: 8),
        GestureDetector(
          onTap: _pickImage,
          child: Container(
            height: 150,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.grey[100],
              border: Border.all(color: Colors.grey[300]!),
            ),
            child:
                _imageFile != null
                    ? ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child:
                          kIsWeb
                              ? FutureBuilder<Uint8List>(
                                future: _imageFile!.readAsBytes(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    return Image.memory(
                                      snapshot.data!,
                                      fit: BoxFit.cover,
                                    );
                                  }
                                  return _buildPlaceholder();
                                },
                              )
                              : Image.file(_imageFile!, fit: BoxFit.cover),
                    )
                    : _buildPlaceholder(),
          ),
        ),
        SizedBox(height: 8),
        TextButton.icon(
          onPressed: _pickImage,
          icon: Icon(Icons.camera_alt, size: 20),
          label: Text('Pilih Gambar'),
        ),
      ],
    );
  }

  Widget _buildPlaceholder() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.camera_alt, size: 40, color: Colors.grey[400]),
          SizedBox(height: 8),
          Text(
            'Tambahkan Foto Properti',
            style: TextStyle(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildFormField({
    required String label,
    required TextEditingController controller,
    int? maxLines = 1,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    bool required = false,
    bool isPriceField =
        false, // Added flag to check if the field is price-related
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label + (required ? ' *' : ''),
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 4),
          if (isPriceField) // Show custom message if it's the price field
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Masukkan harga per bulan jika tipe properti adalah Kost, dan harga per hari jika tipe properti adalah Homestay.',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                SizedBox(height: 8),
              ],
            ),
          TextFormField(
            controller: controller,
            maxLines: maxLines,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              filled: true,
              fillColor: Colors.grey[50],
              hintText:
                  isPriceField
                      ? 'Contoh: 500000'
                      : null, 
            ),
            validator:
                validator ??
                (required
                    ? (v) => v!.isEmpty ? '$label wajib diisi' : null
                    : null),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Text(
        title,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _buildPropertyTypeSpecificFields() {
    if (_propertyTypeId == 1) {
      return Column(
        children: [
          _buildSectionTitle('Detail Kost'),
          _buildFormField(
            label: 'Total Kamar',
            controller: _totalRoomsController,
            keyboardType: TextInputType.number,
          ),
          _buildFormField(
            label: 'Kamar Tersedia',
            controller: _availableRoomsController,
            keyboardType: TextInputType.number,
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tipe Kost',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 4),
                DropdownButtonFormField<String>(
                  value: _kostType,
                  items:
                      ['putra', 'putri', 'campur']
                          .map(
                            (type) => DropdownMenuItem(
                              value: type,
                              child: Text(
                                type[0].toUpperCase() + type.substring(1),
                              ),
                            ),
                          )
                          .toList(),
                  onChanged: (value) => setState(() => _kostType = value),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    filled: true,
                    fillColor: Colors.grey[50],
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    } else if (_propertyTypeId == 2) {
      return Column(
        children: [
          _buildSectionTitle('Detail Homestay'),
          _buildFormField(
            label: 'Total Unit',
            controller: _totalUnitsController,
            keyboardType: TextInputType.number,
          ),
          _buildFormField(
            label: 'Unit Tersedia',
            controller: _availableUnitsController,
            keyboardType: TextInputType.number,
          ),
          _buildFormField(
            label: 'Minimum Menginap (Malam)',
            controller: _minimumStayController,
            keyboardType: TextInputType.number,
          ),
          _buildFormField(
            label: 'Maksimum Tamu',
            controller: _maximumGuestController,
            keyboardType: TextInputType.number,
          ),
          _buildFormField(
            label: 'Waktu Check-in (HH:MM)',
            controller: _checkinTimeController,
          ),
          _buildFormField(
            label: 'Waktu Check-out (HH:MM)',
            controller: _checkoutTimeController,
          ),
        ],
      );
    }
    return SizedBox();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Properti Baru'),
        elevation: 0,
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          controller: _scrollController,
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildImagePreview(),
              SizedBox(height: 24),
              _buildSectionTitle('Informasi Dasar'),
              _buildFormField(
                label: 'Nama Properti',
                controller: _nameController,
                required: true,
              ),
              _buildFormField(
                label: 'Deskripsi',
                controller: _descriptionController,
                maxLines: 3,
              ),
              _buildFormField(
                label: 'Harga',
                controller: _priceController,
                keyboardType: TextInputType.number,
                required: true,
                isPriceField: true, // Mark the field as price-related
              ),
              _buildFormField(
                label: 'Alamat',
                controller: _addressController,
                maxLines: 2,
                required: true,
              ),
              _buildFormField(
                label: 'Kapasitas (Orang)',
                controller: _capacityController,
                keyboardType: TextInputType.number,
              ),
              _buildFormField(
                label: 'Peraturan',
                controller: _rulesController,
                maxLines: 3,
              ),
              SizedBox(height: 16),
              LocationInput(
                onProvinceChanged: (value) => _provinceId = value,
                onCityChanged: (value) => _cityId = value,
                onDistrictChanged: (value) => _districtId = value,
                onSubdistrictChanged: (value) => _subdistrictId = value,
                onCoordinatesChanged: (lat, lng) {
                  setState(() {
                    _latitude = lat;
                    _longitude = lng;
                  });
                },
              ),
              SizedBox(height: 24),
              _buildSectionTitle('Jenis Properti'),
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Jenis Properti *',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 4),
                    DropdownButtonFormField<int>(
                      value: _propertyTypeId,
                      items: [
                        DropdownMenuItem(value: 1, child: Text('Kost')),
                        DropdownMenuItem(value: 2, child: Text('Homestay')),
                      ],
                      onChanged:
                          (value) => setState(() => _propertyTypeId = value),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        filled: true,
                        fillColor: Colors.grey[50],
                      ),
                      validator:
                          (value) =>
                              value == null ? 'Pilih jenis properti' : null,
                    ),
                  ],
                ),
              ),
              if (_propertyTypeId != null) _buildPropertyTypeSpecificFields(),
              SizedBox(height: 24),
              if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Text(
                    _errorMessage!,
                    style: TextStyle(color: Colors.red[700]),
                  ),
                ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _uploadPropertyWithImage,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child:
                      _isLoading
                          ? SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation(Colors.white),
                            ),
                          )
                          : Text(
                            'Simpan Properti',
                            style: TextStyle(fontSize: 16),
                          ),
                ),
              ),
              SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
