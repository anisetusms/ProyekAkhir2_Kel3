import 'package:flutter/material.dart';
import 'package:front/core/network/api_clientowner.dart';
import 'package:front/core/utils/constants.dart';

class LocationInput extends StatefulWidget {
  final Function(int?) onProvinceChanged;
  final Function(int?) onCityChanged;
  final Function(int?) onDistrictChanged;
  final Function(int?) onSubdistrictChanged;
  final Function(double?, double?) onCoordinatesChanged;
  final int? initialProvinceId;
  final int? initialCityId;
  final int? initialDistrictId;
  final int? initialSubdistrictId;
  final double? initialLatitude;
  final double? initialLongitude;

  const LocationInput({
    Key? key,
    required this.onProvinceChanged,
    required this.onCityChanged,
    required this.onDistrictChanged,
    required this.onSubdistrictChanged,
    required this.onCoordinatesChanged,
    this.initialProvinceId,
    this.initialCityId,
    this.initialDistrictId,
    this.initialSubdistrictId,
    this.initialLatitude,
    this.initialLongitude,
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
  TextEditingController _latitudeController = TextEditingController();
  TextEditingController _longitudeController = TextEditingController();
  
  String? _latitudeError;
  String? _longitudeError;

  @override
  void initState() {
    super.initState();
    _fetchProvinces();
    _selectedProvinceId = widget.initialProvinceId;
    _selectedCityId = widget.initialCityId;
    _selectedDistrictId = widget.initialDistrictId;
    _selectedSubdistrictId = widget.initialSubdistrictId;
    _latitudeController.text = widget.initialLatitude?.toString() ?? '';
    _longitudeController.text = widget.initialLongitude?.toString() ?? '';

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
      setState(() {
        _provinces = (response as List<dynamic>).cast<Map<String, dynamic>>();
      });
    } catch (e) {
      print('Error fetching provinces: $e');
    }
  }

  Future<void> _fetchCities(int provinceId) async {
    try {
      final response = await ApiClient().get('${Constants.baseUrl}/cities/$provinceId');
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
    }
  }

  Future<void> _fetchDistricts(int cityId) async {
    try {
      final response = await ApiClient().get('${Constants.baseUrl}/districts/$cityId');
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
    }
  }

  Future<void> _fetchSubdistricts(int districtId) async {
    try {
      final response = await ApiClient().get('${Constants.baseUrl}/subdistricts/$districtId');
      setState(() {
        _subdistricts = (response as List<dynamic>).cast<Map<String, dynamic>>();
        _selectedSubdistrictId = null;
        widget.onSubdistrictChanged(null);
      });
    } catch (e) {
      print('Error fetching subdistricts: $e');
    }
  }
  
  bool _validateLatitude(String value) {
    if (value.isEmpty) {
      setState(() => _latitudeError = 'Latitude harus diisi');
      return false;
    }
    
    double? latitude = double.tryParse(value);
    if (latitude == null) {
      setState(() => _latitudeError = 'Latitude harus berupa angka');
      return false;
    }
    
    if (latitude < -90 || latitude > 90) {
      setState(() => _latitudeError = 'Latitude harus antara -90 dan 90');
      return false;
    }
    
    setState(() => _latitudeError = null);
    return true;
  }

  bool _validateLongitude(String value) {
    if (value.isEmpty) {
      setState(() => _longitudeError = 'Longitude harus diisi');
      return false;
    }
    
    double? longitude = double.tryParse(value);
    if (longitude == null) {
      setState(() => _longitudeError = 'Longitude harus berupa angka');
      return false;
    }
    
    if (longitude < -180 || longitude > 180) {
      setState(() => _longitudeError = 'Longitude harus antara -180 dan 180');
      return false;
    }
    
    setState(() => _longitudeError = null);
    return true;
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
          items: _provinces
              .map(
                (province) => DropdownMenuItem<int>(
                  value: province['id'] as int?,
                  child: Text((province['prov_name'] ?? '') as String),
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
          items: _cities
              .map(
                (city) => DropdownMenuItem<int>(
                  value: city['id'] as int?,
                  child: Text((city['city_name'] ?? '') as String),
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
          validator: (value) => _cities.isNotEmpty && value == null ? 'Kota/Kabupaten harus dipilih' : null,
        ),
        const SizedBox(height: 16.0),
        DropdownButtonFormField<int>(
          decoration: const InputDecoration(
            labelText: 'Kecamatan',
            border: OutlineInputBorder(),
          ),
          value: _selectedDistrictId,
          items: _districts
              .map(
                (district) => DropdownMenuItem<int>(
                  value: district['id'] as int?,
                  child: Text((district['dis_name'] ?? '') as String),
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
          validator: (value) => _districts.isNotEmpty && value == null ? 'Kecamatan harus dipilih' : null,
        ),
        const SizedBox(height: 16.0),
        DropdownButtonFormField<int>(
          decoration: const InputDecoration(
            labelText: 'Kelurahan/Desa',
            border: OutlineInputBorder(),
          ),
          value: _selectedSubdistrictId,
          items: _subdistricts
              .map(
                (subdistrict) => DropdownMenuItem<int>(
                  value: subdistrict['id'] as int?,
                  child: Text((subdistrict['subdis_name'] ?? '') as String),
                ),
              )
              .toList(),
          onChanged: (value) {
            setState(() {
              _selectedSubdistrictId = value;
            });
            widget.onSubdistrictChanged(value);
          },
          validator: (value) => _subdistricts.isNotEmpty && value == null ? 'Kelurahan/Desa harus dipilih' : null,
        ),
        const SizedBox(height: 16.0),

        // Latitude field with validation
        TextFormField(
          controller: _latitudeController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            labelText: 'Latitude',
            border: const OutlineInputBorder(),
            helperText: 'Nilai latitude harus antara -90 dan 90',
            errorText: _latitudeError,
          ),
          onChanged: (value) {
            _validateLatitude(value);
            double? lat, lng;
            if (_latitudeError == null && value.isNotEmpty) {
              lat = double.tryParse(value);
            }
            if (_longitudeError == null && _longitudeController.text.isNotEmpty) {
              lng = double.tryParse(_longitudeController.text);
            }
            widget.onCoordinatesChanged(lat, lng);
          },
          validator: (value) {
            return _validateLatitude(value ?? '') ? null : _latitudeError;
          },
        ),
        const SizedBox(height: 16.0),

        // Longitude field with validation
        TextFormField(
          controller: _longitudeController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            labelText: 'Longitude',
            border: const OutlineInputBorder(),
            helperText: 'Nilai longitude harus antara -180 dan 180',
            errorText: _longitudeError,
          ),
          onChanged: (value) {
            _validateLongitude(value);
            double? lat, lng;
            if (_latitudeError == null && _latitudeController.text.isNotEmpty) {
              lat = double.tryParse(_latitudeController.text);
            }
            if (_longitudeError == null && value.isNotEmpty) {
              lng = double.tryParse(value);
            }
            widget.onCoordinatesChanged(lat, lng);
          },
          validator: (value) {
            return _validateLongitude(value ?? '') ? null : _longitudeError;
          },
        ),
      ],
    );
  }
}
