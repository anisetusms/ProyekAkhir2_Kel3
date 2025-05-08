import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:front/features/dashboard/presentation/screens/users/penyewa/service/booking_service.dart';
import 'package:front/features/dashboard/presentation/screens/users/penyewa/models/booking_model.dart';
import 'package:front/features/dashboard/presentation/screens/users/penyewa/booking/BookingSuccessScreen.dart';
import 'package:front/core/network/api_client.dart';
import 'package:front/features/room/data/models/new_room_model.dart';
import 'package:intl/intl.dart';
import 'dart:io';

class CreateBookingScreen extends StatefulWidget {
  final int propertyId;
  final String? propertyTypeId;
  final Room? room; // Single room for room booking
  final List<Room>? rooms; // Multiple rooms for multi-room booking
  final bool isWholePropertyBooking;

  const CreateBookingScreen({
    Key? key,
    required this.propertyId,
    this.room,
    this.rooms,
    this.propertyTypeId,
    this.isWholePropertyBooking = false,
  }) : super(key: key);

  @override
  _CreateBookingScreenState createState() => _CreateBookingScreenState();
}

class _CreateBookingScreenState extends State<CreateBookingScreen> {
  final _formKey = GlobalKey<FormState>();
  File? _ktpImage;
  bool _isLoading = false;
  bool _isLoadingPropertyType = true;
  late BookingService _bookingService;
  late DateTime _checkInDate;
  late DateTime _checkOutDate;
  final TextEditingController _guestNameController = TextEditingController();
  final TextEditingController _guestPhoneController = TextEditingController();
  final TextEditingController _ktpController = TextEditingController();
  final TextEditingController _specialRequestsController = TextEditingController();
  bool _isForOthers = false;
  int _propertyTypeId = 1; // Default to Kost
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _bookingService = BookingService(ApiClient());
    _checkInDate = DateTime.now();
    _checkOutDate = DateTime.now().add(const Duration(days: 1)); // Default to 1 day
    
    // Fetch property type
    _fetchPropertyType();
  }

  // Fetch property type from server
  Future<void> _fetchPropertyType() async {
    setState(() {
      _isLoadingPropertyType = true;
      _errorMessage = null;
    });
    
    try {
      final property = await _bookingService.getPropertyDetails(widget.propertyId);
      setState(() {
        _propertyTypeId = property.propertyTypeId;
        _isLoadingPropertyType = false;
        
        // Update checkout date based on property type
        if (_isHomestay && widget.room != null) {
          // For homestay rooms, default to 30 days
          _checkOutDate = _checkInDate.add(const Duration(days: 30));
        }
      });
    } catch (e) {
      setState(() {
        _isLoadingPropertyType = false;
        _errorMessage = 'Gagal memuat tipe properti: $e';
      });
    }
  }

  // Getter for convenience
  bool get _isHomestay => _propertyTypeId == 2;

  int _calculateDays() {
    return _checkOutDate.difference(_checkInDate).inDays;
  }

  double _calculateTotalPrice() {
    final days = _calculateDays();
    
    if (widget.isWholePropertyBooking) {
      // Logic for whole property booking price would go here
      // This would need to be fetched from the property data
      return 0.0; // Placeholder
    } else if (widget.room != null) {
      // Single room booking
      return widget.room!.price * days;
    } else if (widget.rooms != null && widget.rooms!.isNotEmpty) {
      // Multiple room booking
      // return widget.rooms!.fold(0, (sum, room) => sum + room.price) * days;
    }
    
    return 0.0;
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
    final picked = await showDatePicker(
      context: context,
      initialDate: isCheckIn ? _checkInDate : _checkOutDate,
      firstDate: isCheckIn ? DateTime.now() : _checkInDate.add(const Duration(days: 1)),
      lastDate: DateTime(DateTime.now().year + 1),
    );

    if (picked != null) {
      setState(() {
        if (isCheckIn) {
          _checkInDate = picked;
          // Ensure checkout is after checkin by at least 1 day
          if (_checkOutDate.difference(_checkInDate).inDays < 1) {
            if (_isHomestay && widget.room != null) {
              _checkOutDate = _checkInDate.add(const Duration(days: 30));
            } else {
              _checkOutDate = _checkInDate.add(const Duration(days: 1));
            }
          }
        } else {
          // Ensure the selected checkout date is at least 1 day after checkin
          if (picked.difference(_checkInDate).inDays >= 1) {
            _checkOutDate = picked;
          } else {
            // Show error message
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Tanggal check-out harus minimal 1 hari setelah check-in'),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      });
    }
  }

  Future<void> _submitBooking() async {
    if (!_formKey.currentState!.validate()) return;
    if (_ktpImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Harap unggah foto KTP')),
      );
      return;
    }
    
    // Validate dates
    if (_checkOutDate.difference(_checkInDate).inDays < 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tanggal check-out harus minimal 1 hari setelah check-in'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Prepare room IDs if booking specific rooms
      List<int>? roomIds;
      if (!widget.isWholePropertyBooking) {
        if (widget.room != null) {
          roomIds = [widget.room!.id];
        } else if (widget.rooms != null && widget.rooms!.isNotEmpty) {
          roomIds = widget.rooms!.map((room) => room.id).toList();
        }
      }

      final booking = await _bookingService.createBooking(
        propertyId: widget.propertyId,
        roomIds: roomIds,
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
        _errorMessage = e.toString();
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal membuat booking: $e'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 5),
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Show loading indicator while fetching property type
    if (_isLoadingPropertyType) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Buat Booking'),
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
    
    final days = _calculateDays();
    final totalPrice = _calculateTotalPrice();
    final bookingType = widget.isWholePropertyBooking 
        ? 'Seluruh Properti' 
        : (widget.room != null ? 'Kamar ${widget.room!.roomNumber}' : 'Multiple Kamar');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Buat Booking'),
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
                                Text('Tipe Booking: $bookingType'),
                                const Spacer(),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: _isHomestay ? Colors.amber[100] : Colors.blue[100],
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    _isHomestay ? 'Homestay' : 'Kost',
                                    style: TextStyle(
                                      color: _isHomestay ? Colors.amber[900] : Colors.blue[900],
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            if (widget.room != null) ...[
                              Text('Tipe Kamar: ${widget.room!.roomType}'),
                              Text('Harga: Rp ${NumberFormat("#,###").format(widget.room!.price)}/${_isHomestay ? "bulan" : "malam"}'),
                            ],
                            const SizedBox(height: 16),
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
                            Text('Durasi: $days ${_isHomestay && widget.room != null ? "bulan" : "malam"}'),
                            if (totalPrice > 0) ...[
                              const SizedBox(height: 8),
                              Text(
                                'Total: Rp ${NumberFormat("#,###").format(totalPrice)}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                    
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
                    
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _submitBooking,
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