import 'package:flutter/material.dart';
import 'package:front/core/network/api_client.dart';
import 'package:front/core/utils/constants.dart';
import 'package:intl/intl.dart';

class BookingScreen extends StatefulWidget {
  static const routeName = '/booking';
  final int propertyId;

  const BookingScreen({Key? key, required this.propertyId}) : super(key: key);

  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  late Future<Map<String, dynamic>> _propertyDetailsFuture;
  final _formKey = GlobalKey<FormState>();
  DateTime? _checkInDate;
  DateTime? _checkOutDate;
  int _guests = 1;

  @override
  void initState() {
    super.initState();
    _propertyDetailsFuture = _fetchPropertyDetails();
  }

  Future<Map<String, dynamic>> _fetchPropertyDetails() async {
    try {
      final response = await ApiClient().get('${Constants.baseUrl}/properties/${widget.propertyId}');
      return response['data'];
    } catch (e) {
      print('Error fetching property details: $e');
      return Future.error('Gagal memuat detail properti.');
    }
  }

  Future<void> _selectCheckInDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != _checkInDate) {
      setState(() {
        _checkInDate = picked;
      });
    }
  }

  Future<void> _selectCheckOutDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _checkInDate ?? DateTime.now(),
      firstDate: _checkInDate ?? DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != _checkOutDate) {
      setState(() {
        _checkOutDate = picked;
      });
    }
  }

  Future<void> _submitBooking() async {
    if (_formKey.currentState!.validate()) {
      if (_checkInDate == null || _checkOutDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Harap pilih tanggal check-in dan check-out.')),
        );
        return;
      }

      try {
        final response = await ApiClient().post(
          '${Constants.baseUrl}/bookings',
          body: {
            'property_id': widget.propertyId,
            'check_in_date': DateFormat('yyyy-MM-dd').format(_checkInDate!),
            'check_out_date': DateFormat('yyyy-MM-dd').format(_checkOutDate!),
            'guests': _guests,
          },
        );

        if (response != null && response['success'] == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Pemesanan berhasil!')),
          );
          Navigator.pop(context); // Kembali ke layar sebelumnya
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(response['message'] ?? 'Gagal melakukan pemesanan.')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Terjadi kesalahan saat melakukan pemesanan.')),
        );
        print('Error submitting booking: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pesan Properti'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _propertyDetailsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Gagal memuat detail: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final property = snapshot.data!;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(property['name'] ?? 'Nama Properti', style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8.0),
                    Text(property['address'] ?? 'Alamat', style: const TextStyle(color: Colors.grey)),
                    const SizedBox(height: 16.0),
                    const Text('Detail Pemesanan', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16.0),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: InkWell(
                            onTap: () => _selectCheckInDate(context),
                            child: InputDecorator(
                              decoration: const InputDecoration(
                                labelText: 'Check-in',
                                border: OutlineInputBorder(),
                              ),
                              child: Text(
                                _checkInDate == null ? 'Pilih Tanggal' : DateFormat('dd MMM yyyy').format(_checkInDate!),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16.0),
                        Expanded(
                          child: InkWell(
                            onTap: () => _selectCheckOutDate(context),
                            child: InputDecorator(
                              decoration: const InputDecoration(
                                labelText: 'Check-out',
                                border: OutlineInputBorder(),
                              ),
                              child: Text(
                                _checkOutDate == null ? 'Pilih Tanggal' : DateFormat('dd MMM yyyy').format(_checkOutDate!),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16.0),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Jumlah Tamu',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      initialValue: '1',
                      validator: (value) {
                        if (value == null || value.isEmpty || int.tryParse(value) == null || int.parse(value) < 1) {
                          return 'Jumlah tamu harus lebih dari 0.';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        setState(() {
                          _guests = int.tryParse(value) ?? 1;
                        });
                      },
                    ),
                    const SizedBox(height: 24.0),
                    ElevatedButton(
                      onPressed: _submitBooking,
                      child: const Text('Lakukan Pemesanan'),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return const Center(child: Text('Properti tidak ditemukan.'));
          }
        },
      ),
    );
  }
}