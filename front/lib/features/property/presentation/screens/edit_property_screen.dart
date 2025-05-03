import 'package:flutter/material.dart';
<<<<<<< Updated upstream
import 'package:front/core/network/api_client.dart';
import 'package:front/core/utils/constants.dart';
import 'package:front/features/property/presentation/widgets/location_input.dart';
=======
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:front/features/property/presentation/widgets/location_input.dart';
import 'package:front/core/utils/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
>>>>>>> Stashed changes

class EditPropertyScreen extends StatefulWidget {
  static const routeName = '/edit_property';
  final int? propertyId; // Sekarang propertyId bisa null

  const EditPropertyScreen({Key? key, this.propertyId})
      : super(key: key); // required dihapus
  @override
  _EditPropertyScreenState createState() => _EditPropertyScreenState();
}

class _EditPropertyScreenState extends State<EditPropertyScreen> {
  final _formKey = GlobalKey<FormState>();
<<<<<<< Updated upstream
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _capacityController = TextEditingController();
  final TextEditingController _availableRoomsController =
      TextEditingController();
  final TextEditingController _rulesController = TextEditingController();
  final TextEditingController _totalRoomsController = TextEditingController();
  final TextEditingController _totalUnitsController = TextEditingController();
  final TextEditingController _availableUnitsController =
      TextEditingController();
  final TextEditingController _minimumStayController = TextEditingController();
  final TextEditingController _maximumGuestController = TextEditingController();
  final TextEditingController _checkinTimeController = TextEditingController();
  final TextEditingController _checkoutTimeController = TextEditingController();

=======
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

>>>>>>> Stashed changes
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
  Map<String, dynamic>? _propertyData;
  double? _latitude;
  double? _longitude;

  @override
  void initState() {
    super.initState();
<<<<<<< Updated upstream
    if (widget.propertyId != null) {
      _fetchPropertyDetails(widget.propertyId!);
    } else {
      // Handle kasus jika propertyId null
      print(
        'Error: propertyId tidak ditemukan saat inisialisasi EditPropertyScreen.',
      );
      // Mungkin Navigator.pop(context);
    }
  }

  Future<void> _fetchPropertyDetails(int id) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final response = await ApiClient().get(
        '${Constants.baseUrl}/properties/$id',
      );
      if (response != null) {
        setState(() {
          _propertyData = response;
          _nameController.text = response['name'] ?? '';
          _descriptionController.text = response['description'] ?? '';
          _priceController.text = response['price']?.toString() ?? '';
          _addressController.text = response['address'] ?? '';
          _propertyTypeId = response['property_type_id'];
          _provinceId = response['province_id'];
          _cityId = response['city_id'];
          _districtId = response['district_id'];
          _subdistrictId = response['subdistrict_id'];
          _latitude = response['latitude']?.toDouble();
          _longitude = response['longitude']?.toDouble();
          _capacityController.text = response['capacity']?.toString() ?? '';
          _rulesController.text = response['rules'] ?? '';

          if (response['kost_detail'] != null) {
            _kostType = response['kost_detail']['kost_type'];
            _totalRoomsController.text =
                response['kost_detail']['total_rooms']?.toString() ?? '';
            _availableRoomsController.text =
                response['kost_detail']['available_rooms']?.toString() ?? '';
            _mealIncluded = response['kost_detail']['meal_included'] ?? false;
            _laundryIncluded =
                response['kost_detail']['laundry_included'] ?? false;
          }

          if (response['homestay_detail'] != null) {
            _totalUnitsController.text =
                response['homestay_detail']['total_units']?.toString() ?? '';
            _availableUnitsController.text =
                response['homestay_detail']['available_units']?.toString() ??
                    '';
            _minimumStayController.text =
                response['homestay_detail']['minimum_stay']?.toString() ?? '';
            _maximumGuestController.text =
                response['homestay_detail']['maximum_guest']?.toString() ?? '';
            _checkinTimeController.text =
                response['homestay_detail']['checkin_time'] ?? '';
            _checkoutTimeController.text =
                response['homestay_detail']['checkout_time'] ?? '';
          }
        });
      } else {
        setState(() {
          _errorMessage = 'Gagal memuat detail properti.';
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
=======
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
    _currentImageUrl =
        widget.property['image'] != null
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
>>>>>>> Stashed changes
    }
  }

  Future<void> _updateProperty() async {
    if (!_formKey.currentState!.validate()) return;

<<<<<<< Updated upstream
      try {
        final Map<String, dynamic> body = {
          'name': _nameController.text,
          'description': _descriptionController.text,
          if (_provinceId != null) 'province_id': _provinceId,
          if (_cityId != null) 'city_id': _cityId,
          if (_districtId != null) 'district_id': _districtId,
          if (_subdistrictId != null) 'subdistrict_id': _subdistrictId,
          'price': double.tryParse(_priceController.text),
          'address': _addressController.text,
          if (_latitude != null) 'latitude': _latitude,
          if (_longitude != null) 'longitude': _longitude,
          if (_capacityController.text.isNotEmpty)
            'capacity': int.tryParse(_capacityController.text),
          if (_rulesController.text.isNotEmpty) 'rules': _rulesController.text,
          if (_propertyTypeId == 1) ...{
            if (_availableRoomsController.text.isNotEmpty)
              'available_rooms': int.tryParse(_availableRoomsController.text),
            if (_totalRoomsController.text.isNotEmpty)
              'total_rooms': int.tryParse(_totalRoomsController.text),
            'kost_type': _kostType,
            'meal_included': _mealIncluded,
            'laundry_included': _laundryIncluded,
          },
          if (_propertyTypeId == 2) ...{
            if (_totalUnitsController.text.isNotEmpty)
              'total_units': int.tryParse(_totalUnitsController.text),
            if (_availableUnitsController.text.isNotEmpty)
              'available_units': int.tryParse(_availableUnitsController.text),
            if (_minimumStayController.text.isNotEmpty)
              'minimum_stay': int.tryParse(_minimumStayController.text),
            if (_maximumGuestController.text.isNotEmpty)
              'maximum_guest': int.tryParse(_maximumGuestController.text),
            if (_checkinTimeController.text.isNotEmpty)
              'checkin_time': _checkinTimeController.text,
            if (_checkoutTimeController.text.isNotEmpty)
              'checkout_time': _checkoutTimeController.text,
          },
        };

        final response = await ApiClient().put( // Gunakan PUT untuk update
          '${Constants.baseUrl}/properties/${widget.propertyId}',
          body: body,
        );

        if (response != null) {
          // Properti berhasil diperbarui
          Navigator.pop(context); // Kembali ke daftar properti
        } else {
          setState(() {
            _errorMessage =
                response['message'] ?? 'Gagal memperbarui properti.';
          });
        }
      } catch (e) {
        setState(() {
          _errorMessage = 'Terjadi kesalahan: $e';
        });
      } finally {
        setState(() {
          _isLoading = false;
=======
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
              'POST', // Gunakan 'POST' untuk permintaan ini
              Uri.parse(
                '${Constants.baseUrl}/properties/${widget.property['id']}',
              ),
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
          if (_kostType != null) 'kost_type': _kostType!,
          'meal_included': _mealIncluded ? '1' : '0',
          'laundry_included': _laundryIncluded ? '1' : '0',
>>>>>>> Stashed changes
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

      if (response.statusCode == 200 && parsedResponse['success'] == true) {
        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Properti berhasil diperbarui')),
        );
      } else {
        setState(
          () =>
              _errorMessage =
                  parsedResponse['message'] ?? 'Gagal memperbarui properti',
        );
      }
    } catch (e) {
      setState(() => _errorMessage = 'Terjadi kesalahan: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

<<<<<<< Updated upstream
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Properti')),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(child: Text(_errorMessage!))
              : _propertyData == null
                  ? Center(child: Text('Data properti tidak ditemukan.'))
                  : SingleChildScrollView(
                      padding: const EdgeInsets.all(16.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            TextFormField(
                              controller: _nameController,
                              decoration: InputDecoration(
                                labelText: 'Nama Properti',
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) => value == null || value.isEmpty
                                  ? 'Nama tidak boleh kosong'
                                  : null,
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
                              validator: (value) => value == null || value.isEmpty
                                  ? 'Harga tidak boleh kosong'
                                  : null,
                            ),
                            SizedBox(height: 16.0),
                            TextFormField(
                              controller: _addressController,
                              maxLines: 2,
                              decoration: InputDecoration(
                                labelText: 'Alamat',
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) => value == null || value.isEmpty
                                  ? 'Alamat tidak boleh kosong'
                                  : null,
                            ),
                            SizedBox(height: 16.0),
                            LocationInput(
                              initialProvinceId: _provinceId,
                              initialCityId: _cityId,
                              initialDistrictId: _districtId,
                              initialSubdistrictId: _subdistrictId,
                              initialLatitude: _latitude,
                              initialLongitude: _longitude,
                              onProvinceChanged: (value) => _provinceId = value,
                              onCityChanged: (value) => _cityId = value,
                              onDistrictChanged: (value) => _districtId = value,
                              onSubdistrictChanged: (value) =>
                                  _subdistrictId = value,
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
                                DropdownMenuItem(
                                    value: 2, child: Text('Homestay')),
                              ],
                              onChanged: (value) {
                                setState(() {
                                  _propertyTypeId = value;
                                });
                              },
                              validator: (value) => value == null
                                  ? 'Jenis properti harus dipilih'
                                  : null,
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
                                      DropdownMenuItem(
                                          value: 'putra', child: Text('Putra')),
                                      DropdownMenuItem(
                                          value: 'putri', child: Text('Putri')),
                                      DropdownMenuItem(
                                          value: 'campur',
                                          child: Text('Campur')),
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
                                    controlAffinity:
                                        ListTileControlAffinity.leading,
                                  ),
                                  CheckboxListTile(
                                    title: Text('Laundry Termasuk'),
                                    value: _laundryIncluded,
                                    onChanged: (value) {
                                      setState(() {
                                        _laundryIncluded = value ?? false;
                                      });
                                    },
                                    controlAffinity:
                                        ListTileControlAffinity.leading,
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
                              onPressed: _isLoading ? null : _updateProperty,
                              child: _isLoading
                                  ? CircularProgressIndicator()
                                  : Text('Simpan Perubahan'),
                            ),
                          ],
                        ),
                      ),
                    ),
=======
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
                    : _currentImageUrl != null
                    ? ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: CachedNetworkImage(
                        imageUrl: _currentImageUrl!,
                        fit: BoxFit.cover,
                        placeholder:
                            (context, url) =>
                                Container(color: Colors.grey[200]),
                        errorWidget:
                            (context, url, error) => _buildPlaceholder(),
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
                  onPressed: _isLoading ? null : _updateProperty,
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
>>>>>>> Stashed changes
    );
  }
}