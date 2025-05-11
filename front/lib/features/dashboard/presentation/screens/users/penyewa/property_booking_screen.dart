import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:front/features/dashboard/presentation/screens/users/penyewa/booking/booking_repository.dart';
import 'package:front/features/dashboard/presentation/screens/users/penyewa/booking/BookingSuccessScreen.dart';
import 'package:front/core/network/api_client.dart';
import 'package:front/features/property/data/models/property_model.dart';
import 'package:intl/intl.dart';
import 'dart:io';

class PropertyBookingScreen extends StatefulWidget {
  final int propertyId;
  final PropertyModel? property;

  const PropertyBookingScreen({
    Key? key,
    required this.propertyId,
    this.property,
  }) : super(key: key);

  @override
  _PropertyBookingScreenState createState() => _PropertyBookingScreenState();
}

class _PropertyBookingScreenState extends State<PropertyBookingScreen> {
  final _formKey = GlobalKey<FormState>();
  File? _ktpImage;
  bool _isLoading = false;
  bool _isLoadingProperty = true;
  late BookingRepository _bookingRepository;
  late DateTime _checkInDate;
  late DateTime _checkOutDate;
  final TextEditingController _guestNameController = TextEditingController();
  final TextEditingController _guestPhoneController = TextEditingController();
  final TextEditingController _ktpController = TextEditingController();
  final TextEditingController _specialRequestsController = TextEditingController();
  bool _isForOthers = false;
  String? _errorMessage;
  PropertyModel? _property;

  @override
  void initState() {
    super.initState();
    _bookingRepository = BookingRepository(apiClient: ApiClient());
    
    // Set tanggal check-in ke hari ini tanpa komponen waktu
    final now = DateTime.now();
    _checkInDate = DateTime(now.year, now.month, now.day);
    
    // Default to 30 days for homestay
    _checkOutDate = DateTime(_checkInDate.year, _checkInDate.month, _checkInDate.day + 30);
    
    // Fetch property details if not provided
    if (widget.property != null) {
      _property = widget.property;
      _isLoadingProperty = false;
    } else {
      _fetchPropertyDetails();
    }
    
    // Debug log untuk melihat tanggal awal
    debugPrint('Initial dates: ${DateFormat('yyyy-MM-dd').format(_checkInDate)} to ${DateFormat('yyyy-MM-dd').format(_checkOutDate)}');
    debugPrint('Initial days: ${_calculateDays()}');
  }

  Future<void> _fetchPropertyDetails() async {
    setState(() {
      _isLoadingProperty = true;
      _errorMessage = null;
    });
    
    try {
      final property = await _bookingRepository.getPropertyDetails(widget.propertyId);
      setState(() {
        _property = property;
        _isLoadingProperty = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingProperty = false;
        _errorMessage = 'Gagal memuat detail properti: $e';
      });
    }
  }

  // Hitung selisih hari sesuai dengan Carbon::diffInDays di server
  int _calculateDays() {
    // Pastikan tanggal tidak memiliki komponen waktu
    final startDate = DateTime(_checkInDate.year, _checkInDate.month, _checkInDate.day);
    final endDate = DateTime(_checkOutDate.year, _checkOutDate.month, _checkOutDate.day);
    
    // Hitung selisih dalam hari
    return endDate.difference(startDate).inDays;
  }

  double _calculateTotalPrice() {
    if (_property == null) return 0.0;
    
    final days = _calculateDays();
    return _property!.price * days;
  }

  Future<void> _pickKTPImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _ktpImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _selectDate(BuildContext context, bool isCheckIn) async {
    final DateTime today = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    
    final picked = await showDatePicker(
      context: context,
      initialDate: isCheckIn ? _checkInDate : _checkOutDate,
      firstDate: isCheckIn ? today : DateTime(_checkInDate.year, _checkInDate.month, _checkInDate.day + 1),
      lastDate: DateTime(DateTime.now().year + 2),
    );

    if (picked != null) {
      setState(() {
        if (isCheckIn) {
          // Set check-in date without time component
          _checkInDate = DateTime(picked.year, picked.month, picked.day);
          
          // Ensure checkout is after checkin by at least 1 day
          final days = _calculateDays();
          debugPrint('After check-in update, days: $days');
          
          if (days < 1) {
            _checkOutDate = DateTime(_checkInDate.year, _checkInDate.month, _checkInDate.day + 30);
            debugPrint('Updated check-out date to: ${DateFormat('yyyy-MM-dd').format(_checkOutDate)}');
          }
        } else {
          // Set check-out date without time component
          _checkOutDate = DateTime(picked.year, picked.month, picked.day);
          
          // Ensure the selected checkout date is at least 1 day after checkin
          final days = _calculateDays();
          debugPrint('After check-out update, days: $days');
          
          if (days < 1) {
            // Show error message
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Tanggal check-out harus minimal 1 hari setelah check-in'),
                backgroundColor: Colors.red,
              ),
            );
            
            // Reset to valid date
            _checkOutDate = DateTime(_checkInDate.year, _checkInDate.month, _checkInDate.day + 30);
            debugPrint('Reset check-out date to: ${DateFormat('yyyy-MM-dd').format(_checkOutDate)}');
          }
        }
      });
    }
  }

  Future<void> _checkAvailability() async {
    // Validasi tanggal dengan lebih ketat
    final days = _calculateDays();
    debugPrint('Days before check availability: $days');
    
    if (days < 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tanggal check-out harus minimal 1 hari setelah check-in'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    
    if (!_formKey.currentState!.validate()) {
      return;
    }
    
    if (_ktpImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Harap unggah foto KTP')),
      );
      return;
    }
    
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Debug log untuk melihat tanggal yang dikirim
      debugPrint('Checking availability with dates: ${DateFormat('yyyy-MM-dd').format(_checkInDate)} to ${DateFormat('yyyy-MM-dd').format(_checkOutDate)}');
      
      final result = await _bookingRepository.checkAvailability(
        widget.propertyId,
        _checkInDate,
        _checkOutDate
      );

      if (result['is_available'] == true) {
        _submitBooking();
      } else {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Properti tidak tersedia untuk tanggal yang dipilih';
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_errorMessage!),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Gagal memeriksa ketersediaan: $e';
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_errorMessage!),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _submitBooking() async {
    try {
      // Debug log untuk melihat data yang akan dikirim
      debugPrint('Submitting booking with dates: ${DateFormat('yyyy-MM-dd').format(_checkInDate)} to ${DateFormat('yyyy-MM-dd').format(_checkOutDate)}');
      
      final booking = await _bookingRepository.createBooking(
        propertyId: widget.propertyId,
        roomIds: null, // No room IDs for homestay booking
        checkIn: _checkInDate,
        checkOut: _checkOutDate,
        isForOthers: _isForOthers,
        guestName: _isForOthers ? _guestNameController.text : null,
        guestPhone: _isForOthers ? _guestPhoneController.text : null,
        ktpImage: _ktpImage!,
        identityNumber: _ktpController.text,
        specialRequests: _specialRequestsController.text.isNotEmpty 
            ? _specialRequestsController.text 
            : null,
      );
      
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => BookingSuccessScreen(booking: booking),
        ),
      );
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = e.toString();
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal membuat booking: $e'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 5),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Show loading indicator while fetching property details
    if (_isLoadingProperty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Booking Homestay'),
          elevation: 0,
        ),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Memuat informasi properti...'),
            ],
          ),
        ),
      );
    }
    
    if (_property == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Booking Homestay'),
          elevation: 0,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 50),
              const SizedBox(height: 16),
              Text(_errorMessage ?? 'Properti tidak ditemukan'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _fetchPropertyDetails,
                child: const Text('Coba Lagi'),
              ),
            ],
          ),
        ),
      );
    }
    
    final days = _calculateDays();
    final totalPrice = _calculateTotalPrice();
    final currencyFormat = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp',
      decimalDigits: 0,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking Homestay'),
        elevation: 0,
      ),
      body: _isLoading 
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Error message if any
                    if (_errorMessage != null)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: Colors.red[50],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.red),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Error:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _errorMessage!,
                              style: TextStyle(color: Colors.red[800]),
                            ),
                          ],
                        ),
                      ),
                    
                    // Property Info Card
                    Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Detail Properti',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const Divider(),
                            Text('Nama: ${_property!.name}'),
                            const SizedBox(height: 8),
                            Text('Alamat: ${_property!.address}'),
                            const SizedBox(height: 8),
                            Text('Kapasitas: ${_property!.capacity} orang'),
                            const SizedBox(height: 8),
                            Text(
                              'Harga: ${currencyFormat.format(_property!.price)}/hari',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    // Booking Details Card
                    Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Detail Pemesanan',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const Divider(),
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text('Check-in'),
                                      TextButton.icon(
                                        onPressed: () => _selectDate(context, true),
                                        icon: const Icon(Icons.calendar_today, size: 16),
                                        label: Text(DateFormat('dd MMM yyyy').format(_checkInDate)),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text('Check-out'),
                                      TextButton.icon(
                                        onPressed: () => _selectDate(context, false),
                                        icon: const Icon(Icons.calendar_today, size: 16),
                                        label: Text(DateFormat('dd MMM yyyy').format(_checkOutDate)),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Text('Durasi: $days hari'),
                            const SizedBox(height: 8),
                            Text(
                              'Total: ${currencyFormat.format(totalPrice)}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    // Guest Information Card
                    Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Informasi Pemesan',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const Divider(),
                            SwitchListTile(
                              contentPadding: EdgeInsets.zero,
                              title: const Text('Booking untuk orang lain'),
                              value: _isForOthers,
                              onChanged: (value) => setState(() => _isForOthers = value),
                            ),
                            if (_isForOthers) ...[
                              TextFormField(
                                controller: _guestNameController,
                                decoration: const InputDecoration(
                                  labelText: 'Nama Tamu',
                                  border: OutlineInputBorder(),
                                ),
                                validator: (value) {
                                  if (_isForOthers && (value == null || value.isEmpty)) {
                                    return 'Harap masukkan nama tamu';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: _guestPhoneController,
                                decoration: const InputDecoration(
                                  labelText: 'Nomor Telepon Tamu',
                                  border: OutlineInputBorder(),
                                ),
                                keyboardType: TextInputType.phone,
                                validator: (value) {
                                  if (_isForOthers && (value == null || value.isEmpty)) {
                                    return 'Harap masukkan nomor telepon tamu';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                            ],
                            TextFormField(
                              controller: _ktpController,
                              decoration: const InputDecoration(
                                labelText: 'Nomor KTP',
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Harap masukkan nomor KTP';
                                }
                                if (value.length != 16) {
                                  return 'Nomor KTP harus 16 digit';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            GestureDetector(
                              onTap: _pickKTPImage,
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  children: [
                                    Icon(
                                      _ktpImage == null ? Icons.upload_file : Icons.check_circle,
                                      size: 48,
                                      color: _ktpImage == null ? Colors.grey : Colors.green,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      _ktpImage == null 
                                          ? 'Unggah Foto KTP (Wajib)' 
                                          : 'KTP berhasil diunggah',
                                      style: TextStyle(
                                        color: _ktpImage == null ? Colors.grey : Colors.green,
                                      ),
                                    ),
                                    if (_ktpImage != null) ...[
                                      const SizedBox(height: 8),
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.file(
                                          _ktpImage!,
                                          height: 100,
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    // Special Requests Card
                    Card(
                      margin: const EdgeInsets.only(bottom: 24),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Permintaan Khusus',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const Divider(),
                            TextFormField(
                              controller: _specialRequestsController,
                              decoration: const InputDecoration(
                                hintText: 'Masukkan permintaan khusus Anda (opsional)',
                                border: OutlineInputBorder(),
                              ),
                              maxLines: 3,
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    // Submit Button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _checkAvailability,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Buat Booking',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}