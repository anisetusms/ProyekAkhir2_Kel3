// // screens/create_booking_screen.dart
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:front/features/dashboard/presentation/screens/users/penyewa/service/booking_service.dart';
// import 'package:front/features/dashboard/presentation/screens/users/penyewa/models/booking_model.dart';
// import 'package:front/features/dashboard/presentation/screens/users/penyewa/booking/BookingSuccessScreen.dart';
// import 'package:front/core/network/api_client.dart';
// import 'dart:io';
// class CreateBookingScreen extends StatefulWidget {
//   final int propertyId;
//   final List<int>? selectedRoomIds;

//   const CreateBookingScreen({
//     required this.propertyId,
//     this.selectedRoomIds,
//     Key? key,
//   }) : super(key: key);

//   @override
//   _CreateBookingScreenState createState() => _CreateBookingScreenState();
// }

// class _CreateBookingScreenState extends State<CreateBookingScreen> {
//   final _formKey = GlobalKey<FormState>();
//   late Booking _booking;
//   File? _ktpImage;
//   bool _isLoading = false;
//   late BookingService _bookingService;

//   @override
//   void initState() {
//     super.initState();
//     _booking = Booking(
//       propertyId: widget.propertyId,
//       roomIds: widget.selectedRoomIds,
//       checkIn: DateTime.now(),
//       checkOut: DateTime.now().add(const Duration(days: 1)),
//       isForOthers: false,
//       ktpImagePath: '',
//       identityNumber: '',
//       totalPrice: 0,
//     );
//     _bookingService = BookingService(ApiClient());
//   }

//   Future<void> _pickKTPImage() async {
//     final picker = ImagePicker();
//     final pickedFile = await picker.pickImage(source: ImageSource.gallery);

//     if (pickedFile != null) {
//       setState(() {
//         _ktpImage = File(pickedFile.path);
//       });
//     }
//   }

//   Future<void> _submitBooking() async {
//     if (!_formKey.currentState!.validate()) return;
//     if (_ktpImage == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Harap unggah foto KTP')),
//       );
//       return;
//     }

//     _formKey.currentState!.save();
//     setState(() => _isLoading = true);

//     try {
//       final createdBooking = await _bookingService.createBooking(_booking, _ktpImage!);
      
//       Navigator.of(context).pushReplacement(
//         MaterialPageRoute(
//           builder: (_) => BookingSuccessScreen(booking: createdBooking),
//         ),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Gagal membuat booking: $e')),
//       );
//     } finally {
//       setState(() => _isLoading = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Buat Booking')),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Form fields sama seperti sebelumnya
//               // ...
              
//               // Tombol submit
//               const SizedBox(height: 20),
//               Center(
//                 child: ElevatedButton(
//                   onPressed: _isLoading ? null : _submitBooking,
//                   child: _isLoading 
//                       ? const CircularProgressIndicator(color: Colors.white)
//                       : const Text('Buat Booking'),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
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
  final Room? room;
  final bool isWholePropertyBooking;

  const CreateBookingScreen({
    Key? key,
    required this.propertyId,
    this.room,
    this.isWholePropertyBooking = false,
  }) : super(key: key);

  @override
  _CreateBookingScreenState createState() => _CreateBookingScreenState();
}

class _CreateBookingScreenState extends State<CreateBookingScreen> {
  final _formKey = GlobalKey<FormState>();
  late Booking _booking;
  File? _ktpImage;
  bool _isLoading = false;
  late BookingService _bookingService;
  late DateTime _checkInDate;
  late DateTime _checkOutDate;
  final TextEditingController _guestNameController = TextEditingController();
  final TextEditingController _guestPhoneController = TextEditingController();
  final TextEditingController _ktpController = TextEditingController();
  final TextEditingController _specialRequestsController = TextEditingController();
  bool _isForOthers = false;

  @override
  void initState() {
    super.initState();
    _bookingService = BookingService(ApiClient());
    _checkInDate = DateTime.now();
    _checkOutDate = DateTime.now().add(Duration(days: widget.room != null ? 30 : 1));

    _booking = Booking(
      propertyId: widget.propertyId,
      roomId: widget.isWholePropertyBooking ? null : widget.room?.id,
      checkIn: _checkInDate,
      checkOut: _checkOutDate,
      isForOthers: _isForOthers,
      guestName: null,
      guestPhone: null,
      ktpImagePath: '',
      identityNumber: '',
      specialRequests: '',
      totalPrice: 1,
      status: 'pending',
    );
  }

  // double _calculateInitialPrice() {
  //   if (widget.isWholePropertyBooking) {
  //     return 0; // Will be set from property price
  //   }
  //   return widget.room != null
  //       ? (widget.room!.price * _calculateDays(_checkInDate, _checkOutDate))
  //       : 0;
  // }

  int _calculateDays(DateTime start, DateTime end) {
    return end.difference(start).inDays;
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
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
    );

    if (picked != null) {
      setState(() {
        if (isCheckIn) {
          _checkInDate = picked;
          if (_checkOutDate.isBefore(_checkInDate.add(const Duration(days: 1)))) {
            _checkOutDate = _checkInDate.add(Duration(days: widget.room != null ? 30 : 1));
          }
        } else {
          _checkOutDate = picked;
          if (_checkOutDate.isBefore(_checkInDate.add(const Duration(days: 1)))) {
            _checkInDate = _checkOutDate.subtract(Duration(days: widget.room != null ? 30 : 1));
          }
        }
        
        _booking = _booking.copyWith(
          checkIn: _checkInDate,
          checkOut: _checkOutDate,
          // totalPrice: widget.isWholePropertyBooking
          //     ? _booking.totalPrice // Property price will be set separately
          //     : widget.room != null
          //         ? widget.room!.price * _calculateDays(_checkInDate, _checkOutDate)
          //         : 0,
        );
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

    _formKey.currentState!.save();
    setState(() => _isLoading = true);

    try {
      _booking = _booking.copyWith(
        guestName: _isForOthers ? _guestNameController.text : null,
        guestPhone: _isForOthers ? _guestPhoneController.text : null,
        identityNumber: _ktpController.text,
        specialRequests: _specialRequestsController.text,
        isForOthers: _isForOthers,
        ktpImagePath: _ktpImage?.path ?? '',
      );

      final createdBooking = await _bookingService.createBooking(_booking, _ktpImage!);
      
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => BookingSuccessScreen(booking: createdBooking),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal membuat booking: ${e.toString()}')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final days = _calculateDays(_checkInDate, _checkOutDate);
    final price = widget.isWholePropertyBooking
        ? _booking.totalPrice
        : widget.room != null
            ? widget.room!.price * days
            : 0;

    return Scaffold(
      appBar: AppBar(title: const Text('Buat Booking')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.room != null) ...[
                Text(
                  'Kamar: ${widget.room!.roomType} - ${widget.room!.roomNumber}',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  'Rp ${NumberFormat("#,###").format(widget.room!.price)}/${widget.room != null ? 'bulan' : 'malam'}',
                  style: const TextStyle(fontSize: 16),
                ),
              ] else if (widget.isWholePropertyBooking) ...[
                Text(
                  'Properti ID: ${widget.propertyId}',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  'Pemesanan untuk seluruh properti',
                  style: const TextStyle(fontSize: 16),
                ),
              ],
              const Divider(height: 32),

              SwitchListTile(
                title: const Text('Booking untuk orang lain'),
                value: _isForOthers,
                onChanged: (value) => setState(() => _isForOthers = value),
              ),

              if (_isForOthers)
                TextFormField(
                  controller: _guestNameController,
                  decoration: const InputDecoration(labelText: 'Nama Tamu'),
                  validator: (value) {
                    if (_isForOthers && (value == null || value.isEmpty)) {
                      return 'Harap masukkan nama tamu';
                    }
                    return null;
                  },
                ),

              if (_isForOthers)
                TextFormField(
                  controller: _guestPhoneController,
                  decoration: const InputDecoration(labelText: 'Nomor Telepon Tamu'),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (_isForOthers && (value == null || value.isEmpty)) {
                      return 'Harap masukkan nomor telepon tamu';
                    }
                    return null;
                  },
                ),

              TextFormField(
                controller: _ktpController,
                decoration: const InputDecoration(labelText: 'Nomor KTP'),
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

              Row(
                children: [
                  const Text('Check-in: '),
                  TextButton(
                    onPressed: () => _selectDate(context, true),
                    child: Text(DateFormat('dd MMM yyyy').format(_checkInDate)),
                  ),
                ],
              ),

              Row(
                children: [
                  const Text('Check-out: '),
                  TextButton(
                    onPressed: () => _selectDate(context, false),
                    child: Text(DateFormat('dd MMM yyyy').format(_checkOutDate)),
                  ),
                ],
              ),
              Text('Durasi: $days ${widget.room != null ? 'bulan' : 'malam'}'),

              if (price > 0)
                Text(
                  'Total: Rp ${NumberFormat("#,###").format(price)}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),

              const SizedBox(height: 16),
              GestureDetector(
                onTap: _pickKTPImage,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      const Icon(Icons.upload_file, size: 48),
                      Text(_ktpImage == null 
                          ? 'Unggah Foto KTP' 
                          : 'File terpilih: ${_ktpImage!.path.split('/').last}'),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),
              TextFormField(
                controller: _specialRequestsController,
                decoration: const InputDecoration(
                  labelText: 'Permintaan Khusus (opsional)',
                  alignLabelWithHint: true,
                ),
                maxLines: 3,
              ),

              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submitBooking,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Buat Booking'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}