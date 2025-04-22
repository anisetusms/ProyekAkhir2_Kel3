import 'package:flutter/material.dart';
import 'package:front/core/network/api_client.dart';
import 'package:front/core/utils/constants.dart';
import 'package:front/features/property/presentation/widgets/location_input.dart';

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

  @override
  void initState() {
    super.initState();
    if (widget.propertyId != null) {
      _fetchPropertyDetails(
        widget.propertyId!,
      ); // Gunakan ! karena sudah diperiksa tidak null
    } else {
      // Handle kasus jika propertyId null
      // Misalnya, tampilkan pesan error atau kembali ke screen sebelumnya
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
    }
  }

  Future<void> _updateProperty() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      try {
        final Map<String, dynamic> body = {
          'name': _nameController.text,
          'description': _descriptionController.text,
          'province_id': _provinceId,
          'city_id': _cityId,
          'district_id': _districtId,
          'subdistrict_id': _subdistrictId,
          'price': double.tryParse(_priceController.text),
          'address': _addressController.text,
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

        final response = await ApiClient().post(
          // Menggunakan POST untuk update sesuai route
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
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Properti')),
      body:
          _isLoading
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
                        validator:
                            (value) =>
                                value == null || value.isEmpty
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
                        validator:
                            (value) =>
                                value == null || value.isEmpty
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
                        validator:
                            (value) =>
                                value == null || value.isEmpty
                                    ? 'Alamat tidak boleh kosong'
                                    : null,
                      ),
                      SizedBox(height: 16.0),
                      LocationInput(
                        initialProvinceId: _provinceId,
                        initialCityId: _cityId,
                        initialDistrictId: _districtId,
                        initialSubdistrictId: _subdistrictId,
                        onProvinceChanged: (value) => _provinceId = value,
                        onCityChanged: (value) => _cityId = value,
                        onDistrictChanged: (value) => _districtId = value,
                        onSubdistrictChanged: (value) => _subdistrictId = value,
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
                        validator:
                            (value) =>
                                value == null
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
                                  value: 'putra',
                                  child: Text('Putra'),
                                ),
                                DropdownMenuItem(
                                  value: 'putri',
                                  child: Text('Putri'),
                                ),
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
                        child:
                            _isLoading
                                ? CircularProgressIndicator()
                                : Text('Simpan Perubahan'),
                      ),
                    ],
                  ),
                ),
              ),
    );
  }
}
