import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:front/features/property/presentation/widgets/location_input.dart';
import 'package:front/core/utils/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:front/features/property/presentation/screens/property_list.dart';

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
  final _scrollController = ScrollController();
  final List<TextEditingController> _controllers = List.generate(
    14,
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
  bool _mealIncluded = false;
  bool _laundryIncluded = false;
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
    _initializeFormData();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _initializeFormData() {
    // Initialize controllers with property data
    _nameController.text = widget.property['name'] ?? '';
    _descriptionController.text = widget.property['description'] ?? '';
    _priceController.text = widget.property['price']?.toString() ?? '';
    _addressController.text = widget.property['address'] ?? '';
    _capacityController.text = widget.property['capacity']?.toString() ?? '';
    _availableRoomsController.text =
        widget.property['available_rooms']?.toString() ?? '';
    _rulesController.text = widget.property['rules'] ?? '';
    _totalRoomsController.text =
        widget.property['total_rooms']?.toString() ?? '';
    _totalUnitsController.text =
        widget.property['total_units']?.toString() ?? '';
    _availableUnitsController.text =
        widget.property['available_units']?.toString() ?? '';
    _minimumStayController.text =
        widget.property['minimum_stay']?.toString() ?? '';
    _maximumGuestController.text =
        widget.property['maximum_guest']?.toString() ?? '';
    _checkinTimeController.text = widget.property['checkin_time'] ?? '';
    _checkoutTimeController.text = widget.property['checkout_time'] ?? '';

    // Initialize other fields
    _propertyTypeId = widget.property['property_type_id'];
    _provinceId = widget.property['province_id'];
    _cityId = widget.property['city_id'];
    _districtId = widget.property['district_id'];
    _subdistrictId = widget.property['subdistrict_id'];
    _kostType = widget.property['kost_type'];
    _mealIncluded = widget.property['meal_included'] == 1;
    _laundryIncluded = widget.property['laundry_included'] == 1;
    _latitude = _parseDouble(widget.property['latitude']);
    _longitude = _parseDouble(widget.property['longitude']);
    _currentImageUrl = widget.property['image'] != null
        ? '${Constants.baseUrl}/storage/properties/${widget.property['image']}'
        : null;
  }

  double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

  Future<void> _pickImage() async {
    try {
      final pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );
      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
          _currentImageUrl = null;
        });
      }
    } catch (e) {
      setState(() => _errorMessage = 'Gagal memilih gambar: $e');
    }
  }

  Future<void> _updateProperty() async {
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

      var request = http.MultipartRequest(
        'POST', // Menggunakan POST karena server mungkin mengharapkan _method=PUT
        Uri.parse('${Constants.baseUrl}/properties/${widget.property['id']}'),
      )..headers.addAll({
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        })
        ..fields.addAll({
          '_method': 'POST', // Tambahkan field untuk method PUT
          'name': _nameController.text,
          'description': _descriptionController.text,
          'property_type_id': _propertyTypeId.toString(),
          'price': _priceController.text,
          'address': _addressController.text,
          if (_provinceId != null) 'province_id': _provinceId.toString(),
          if (_cityId != null) 'city_id': _cityId.toString(),
          if (_districtId != null) 'district_id': _districtId.toString(),
          if (_subdistrictId != null) 'subdistrict_id': _subdistrictId.toString(),
          if (_latitude != null) 'latitude': _latitude.toString(),
          if (_longitude != null) 'longitude': _longitude.toString(),
          if (_capacityController.text.isNotEmpty)
            'capacity': _capacityController.text,
          if (_rulesController.text.isNotEmpty) 'rules': _rulesController.text,
        });

      if (_propertyTypeId == 1) {
        request.fields.addAll({
          if (_availableRoomsController.text.isNotEmpty)
            'available_rooms': _availableRoomsController.text,
          if (_totalRoomsController.text.isNotEmpty)
            'total_rooms': _totalRoomsController.text,
          if (_kostType != null) 'kost_type': _kostType!,
          'meal_included': _mealIncluded ? '1' : '0',
          'laundry_included': _laundryIncluded ? '1' : '0',
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

      if (response.statusCode == 200 && parsedResponse['message'] != null &&
          parsedResponse['message'].toString().toLowerCase().contains('berhasil diperbarui')) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => PropertyListScreen(),
          ), // Langsung menuju PropertyListScreen setelah sukses
        );
      } else {
        setState(
          () => _errorMessage = parsedResponse['message'] ??
              'Gagal memperbarui properti. Status: ${response.statusCode}',
        );
        print('Error updating property: $responseBody');
      }
    } catch (e) {
      setState(() => _errorMessage = 'Terjadi kesalahan: $e');
      print('Exception during update: $e');
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
            child: _imageFile != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: kIsWeb
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
                : _currentImageUrl != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: CachedNetworkImage(
                          imageUrl: _currentImageUrl!,
                          fit: BoxFit.cover,
                          placeholder: (context, url) =>
                              Container(color: Colors.grey[200]),
                          errorWidget: (context, url, error) =>
                              _buildPlaceholder(),
                        ),
                      )
                    : _buildPlaceholder(),
          ),
        ),
        SizedBox(height: 8),
        TextButton.icon(
          onPressed: _pickImage,
          icon: Icon(Icons.camera_alt, size: 20),
          label: Text('Ubah Gambar'),
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
            ),
            validator: validator ??
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
                  items: ['putra', 'putri', 'campur']
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
          SwitchListTile(
            title: Text('Termasuk Makan'),
            value: _mealIncluded,
            onChanged: (value) => setState(() => _mealIncluded = value),
            contentPadding: EdgeInsets.zero,
          ),
          SwitchListTile(
            title: Text('Termasuk Laundry'),
            value: _laundryIncluded,
            onChanged: (value) => setState(() => _laundryIncluded = value),
            contentPadding: EdgeInsets.zero,
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
          _buildFormField(label: 'Unit Tersedia',
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
        title: Text('Edit Properti'),
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
                initialProvinceId: _provinceId,
                initialCityId: _cityId,
                initialDistrictId: _districtId,
                initialSubdistrictId: _subdistrictId,
                initialLatitude: _latitude,
                initialLongitude: _longitude,
                onProvinceChanged: (value) => _provinceId = value,
                onCityChanged: (value) => setState(() => _cityId = value),
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
                      onChanged: (value) =>
                          setState(() => _propertyTypeId = value),
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
                      validator: (value) =>
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
                  onPressed: _isLoading ? null : _updateProperty,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: _isLoading
                      ? SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation(Colors.white),
                          ),
                        )
                      : Text(
                          'Simpan Perubahan',
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
