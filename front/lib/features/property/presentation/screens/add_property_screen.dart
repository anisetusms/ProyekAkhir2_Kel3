import 'package:flutter/material.dart';
import 'package:front/core/network/api_client.dart';
import 'package:front/core/utils/constants.dart';
import 'package:front/features/property/presentation/widgets/location_input.dart';

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

  Future<void> _addProperty() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      try {
        final Map<String, dynamic> body = {
          'name': _nameController.text,
          'description': _descriptionController.text,
          'property_type_id': _propertyTypeId,
          if (_provinceId != null)
            'province_id': _provinceId, // Tambahkan null check
          if (_cityId != null) 'city_id': _cityId, // Tambahkan null check
          if (_districtId != null)
            'district_id': _districtId, // Tambahkan null check
          if (_subdistrictId != null)
            'subdistrict_id': _subdistrictId, // Tambahkan null check
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
          '${Constants.baseUrl}/properties',
          body: body,
        );

        if (response != null && response['id'] != null) {
          // Properti berhasil ditambahkan
          Navigator.pop(context); // Kembali ke daftar properti
        } else {
          setState(() {
            _errorMessage =
                response['message'] ?? 'Gagal menambahkan properti.';
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
      appBar: AppBar(title: Text('Tambah Properti Baru')),
      body: SingleChildScrollView(
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
                onPressed: _isLoading ? null : _addProperty,
                child:
                    _isLoading
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
