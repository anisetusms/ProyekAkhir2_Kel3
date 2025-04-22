import 'package:flutter/material.dart';
import 'package:front/core/network/api_client.dart';
import 'package:front/core/utils/constants.dart';

class LocationInput extends StatefulWidget {
  final Function(int?) onProvinceChanged;
  final Function(int?) onCityChanged;
  final Function(int?) onDistrictChanged;
  final Function(int?) onSubdistrictChanged;
  final int? initialProvinceId;
  final int? initialCityId;
  final int? initialDistrictId;
  final int? initialSubdistrictId;

  const LocationInput({
    Key? key,
    required this.onProvinceChanged,
    required this.onCityChanged,
    required this.onDistrictChanged,
    required this.onSubdistrictChanged,
    this.initialProvinceId,
    this.initialCityId,
    this.initialDistrictId,
    this.initialSubdistrictId,
  }) : super(key: key);

  @override
  _LocationInputState createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  List<Map<String, dynamic>> _provinces = [];
  List<Map<String, dynamic>> _cities = [];
  List<Map<String, dynamic>> _districts = [];
  List<Map<String, dynamic>> _subdistricts = [];

  int? _selectedProvinceId;
  int? _selectedCityId;
  int? _selectedDistrictId;
  int? _selectedSubdistrictId;

  @override
  void initState() {
    super.initState();
    _fetchProvinces();
    _selectedProvinceId = widget.initialProvinceId;
    _selectedCityId = widget.initialCityId;
    _selectedDistrictId = widget.initialDistrictId;
    _selectedSubdistrictId = widget.initialSubdistrictId;
    if (_selectedProvinceId != null) {
      _fetchCities(_selectedProvinceId!);
    }
    if (_selectedCityId != null) {
      _fetchDistricts(_selectedCityId!);
    }
    if (_selectedDistrictId != null) {
      _fetchSubdistricts(_selectedDistrictId!);
    }
  }

  Future<void> _fetchProvinces() async {
    try {
      final response = await ApiClient().get('${Constants.baseUrl}/provinces');
      print('Response Provinces: $response'); // Tambahkan ini
      setState(() {
        _provinces = (response as List<dynamic>).cast<Map<String, dynamic>>();
      });
    } catch (e) {
      print('Error fetching provinces: $e');
      // Handle error appropriately, e.g., show a snackbar
    }
  }

  Future<void> _fetchCities(int provinceId) async {
    try {
      final response = await ApiClient().get(
        '${Constants.baseUrl}/cities/$provinceId',
      );
      setState(() {
        _cities = (response as List<dynamic>).cast<Map<String, dynamic>>();
        _districts.clear();
        _subdistricts.clear();
        _selectedCityId = null;
        _selectedDistrictId = null;
        _selectedSubdistrictId = null;
        widget.onCityChanged(null);
        widget.onDistrictChanged(null);
        widget.onSubdistrictChanged(null);
      });
    } catch (e) {
      print('Error fetching cities: $e');
      // Handle error appropriately
    }
  }

  Future<void> _fetchDistricts(int cityId) async {
    try {
      final response = await ApiClient().get(
        '${Constants.baseUrl}/districts/$cityId',
      );
      setState(() {
        _districts = (response as List<dynamic>).cast<Map<String, dynamic>>();
        _subdistricts.clear();
        _selectedDistrictId = null;
        _selectedSubdistrictId = null;
        widget.onDistrictChanged(null);
        widget.onSubdistrictChanged(null);
      });
    } catch (e) {
      print('Error fetching districts: $e');
      // Handle error appropriately
    }
  }

  Future<void> _fetchSubdistricts(int districtId) async {
    try {
      final response = await ApiClient().get(
        '${Constants.baseUrl}/subdistricts/$districtId',
      );
      setState(() {
        _subdistricts =
            (response as List<dynamic>).cast<Map<String, dynamic>>();
        _selectedSubdistrictId = null;
        widget.onSubdistrictChanged(null);
      });
    } catch (e) {
      print('Error fetching subdistricts: $e');
      // Handle error appropriately
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        DropdownButtonFormField<int>(
          decoration: const InputDecoration(
            labelText: 'Provinsi',
            border: OutlineInputBorder(),
          ),
          value: _selectedProvinceId,
          items:
              _provinces
                  .map(
                    (province) => DropdownMenuItem<int>(
                      value: province['id'] as int?,
                      child: Text(
                        (province['name'] ?? '') as String,
                      ), // Null check
                    ),
                  )
                  .toList(),
          onChanged: (value) {
            setState(() {
              _selectedProvinceId = value;
              _cities.clear();
              _districts.clear();
              _subdistricts.clear();
              _selectedCityId = null;
              _selectedDistrictId = null;
              _selectedSubdistrictId = null;
            });
            widget.onProvinceChanged(value);
            if (value != null) {
              _fetchCities(value);
            }
          },
          validator: (value) => value == null ? 'Provinsi harus dipilih' : null,
        ),
        const SizedBox(height: 16.0),
        DropdownButtonFormField<int>(
          decoration: const InputDecoration(
            labelText: 'Kota/Kabupaten',
            border: OutlineInputBorder(),
          ),
          value: _selectedCityId,
          items:
              _cities
                  .map(
                    (city) => DropdownMenuItem<int>(
                      value: city['id'] as int?,
                      child: Text((city['name'] ?? '') as String), // Null check
                    ),
                  )
                  .toList(),
          onChanged: (value) {
            setState(() {
              _selectedCityId = value;
              _districts.clear();
              _subdistricts.clear();
              _selectedDistrictId = null;
              _selectedSubdistrictId = null;
            });
            widget.onCityChanged(value);
            if (value != null) {
              _fetchDistricts(value);
            }
          },
          validator:
              (value) =>
                  _cities.isNotEmpty && value == null
                      ? 'Kota/Kabupaten harus dipilih'
                      : null,
        ),
        const SizedBox(height: 16.0),
        DropdownButtonFormField<int>(
          decoration: const InputDecoration(
            labelText: 'Kecamatan',
            border: OutlineInputBorder(),
          ),
          value: _selectedDistrictId,
          items:
              _districts
                  .map(
                    (district) => DropdownMenuItem<int>(
                      value: district['id'] as int?,
                      child: Text(
                        (district['name'] ?? '') as String,
                      ), // Null check
                    ),
                  )
                  .toList(),
          onChanged: (value) {
            setState(() {
              _selectedDistrictId = value;
              _subdistricts.clear();
              _selectedSubdistrictId = null;
            });
            widget.onDistrictChanged(value);
            if (value != null) {
              _fetchSubdistricts(value);
            }
          },
          validator:
              (value) =>
                  _districts.isNotEmpty && value == null
                      ? 'Kecamatan harus dipilih'
                      : null,
        ),
        const SizedBox(height: 16.0),
        DropdownButtonFormField<int>(
          decoration: const InputDecoration(
            labelText: 'Kelurahan/Desa',
            border: OutlineInputBorder(),
          ),
          value: _selectedSubdistrictId,
          items:
              _subdistricts
                  .map(
                    (subdistrict) => DropdownMenuItem<int>(
                      value: subdistrict['id'] as int?,
                      child: Text(
                        (subdistrict['name'] ?? '') as String,
                      ), // Null check
                    ),
                  )
                  .toList(),
          onChanged: (value) {
            setState(() {
              _selectedSubdistrictId = value;
            });
            widget.onSubdistrictChanged(value);
          },
          validator:
              (value) =>
                  _subdistricts.isNotEmpty && value == null
                      ? 'Kelurahan/Desa harus dipilih'
                      : null,
        ),
      ],
    );
  }
}
