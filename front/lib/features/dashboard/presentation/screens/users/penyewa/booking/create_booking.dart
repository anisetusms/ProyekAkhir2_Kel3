// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:front/features/dashboard/presentation/screens/users/penyewa/booking/booking_repository.dart';
// import 'package:front/features/dashboard/presentation/screens/users/penyewa/booking/BookingSuccessScreen.dart';
// import 'package:front/core/network/api_client.dart';
// import 'package:front/features/room/data/models/new_room_model.dart';
// import 'package:intl/intl.dart';
// import 'dart:io';
// import 'package:flutter/services.dart';

// class CreateBookingEnhancedScreen extends StatefulWidget {
//   final int propertyId;
//   final int? propertyTypeId;
//   final Room? room;
//   final List<Room>? rooms;
//   final bool isWholePropertyBooking;

//   const CreateBookingEnhancedScreen({
//     Key? key,
//     required this.propertyId,
//     this.room,
//     this.rooms,
//     this.propertyTypeId,
//     this.isWholePropertyBooking = false,
//   }) : super(key: key);

//   @override
//   _CreateBookingEnhancedScreenState createState() =>
//       _CreateBookingEnhancedScreenState();
// }

// class _CreateBookingEnhancedScreenState
//     extends State<CreateBookingEnhancedScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _pageController = PageController();
//   File? _ktpImage;
//   bool _isLoading = false;
//   bool _isLoadingPropertyType = true;
//   late BookingRepository _bookingRepository;
//   late DateTime _checkInDate;
//   late DateTime _checkOutDate;
//   final TextEditingController _guestNameController = TextEditingController();
//   final TextEditingController _guestPhoneController = TextEditingController();
//   final TextEditingController _ktpController = TextEditingController();
//   final TextEditingController _specialRequestsController =
//       TextEditingController();
//   bool _isForOthers = false;
//   int _propertyTypeId = 1; // Default to Kost
//   String? _errorMessage;
//   int _currentStep = 0;
//   bool _termsAccepted = false;

//   @override
//   void initState() {
//     super.initState();
//     _bookingRepository = BookingRepository(apiClient: ApiClient());

//     final now = DateTime.now();
//     _checkInDate = DateTime(now.year, now.month, now.day);

//     // Set default checkout date based on property type
//     if (widget.propertyTypeId == 2) {
//       // Homestay - default to 1 day
//       _checkOutDate = DateTime(
//         _checkInDate.year,
//         _checkInDate.month,
//         _checkInDate.day + 1,
//       );
//     } else {
//       // Kost - default to 30 days (1 month)
//       _checkOutDate = DateTime(
//         _checkInDate.year,
//         _checkInDate.month,
//         _checkInDate.day + 30,
//       );
//     }

//     // If propertyTypeId is provided, use it directly
//     if (widget.propertyTypeId != null) {
//       _propertyTypeId = widget.propertyTypeId!;
//       _isLoadingPropertyType = false;
//     } else {
//       // Otherwise fetch property type
//       _fetchPropertyType();
//     }

//     // Debug log untuk melihat tanggal awal
//     debugPrint(
//       'Initial dates: ${DateFormat('yyyy-MM-dd').format(_checkInDate)} to ${DateFormat('yyyy-MM-dd').format(_checkOutDate)}',
//     );
//     debugPrint('Initial days: ${_calculateDays()}');
//   }

//   // Fetch property type from server
//   Future<void> _fetchPropertyType() async {
//     setState(() {
//       _isLoadingPropertyType = true;
//       _errorMessage = null;
//     });

//     try {
//       final property = await _bookingRepository.getPropertyDetails(
//         widget.propertyId,
//       );
//       setState(() {
//         _propertyTypeId = property.propertyTypeId;
//         _isLoadingPropertyType = false;

//         // Update checkout date based on property type
//         if (_isHomestay) {
//           // For homestay, default to 30 days
//           _checkOutDate = DateTime(
//             _checkInDate.year,
//             _checkInDate.month,
//             _checkInDate.day + 30,
//           );
//         } else {
//           // For kost, default to 2 days (untuk memastikan selisih minimal 1 hari)
//           _checkOutDate = DateTime(
//             _checkInDate.year,
//             _checkInDate.month,
//             _checkInDate.day + 2,
//           );
//         }

//         // Debug log setelah update tanggal
//         debugPrint(
//           'Updated dates after property fetch: ${DateFormat('yyyy-MM-dd').format(_checkInDate)} to ${DateFormat('yyyy-MM-dd').format(_checkOutDate)}',
//         );
//         debugPrint('Updated days: ${_calculateDays()}');
//       });
//     } catch (e) {
//       setState(() {
//         _isLoadingPropertyType = false;
//         _errorMessage = 'Gagal memuat tipe properti: $e';
//       });
//     }
//   }

//   // Getter for convenience
//   bool get _isHomestay => _propertyTypeId == 2;

//   // Hitung selisih hari sesuai dengan Carbon::diffInDays di server
//   int _calculateDays() {
//     // Pastikan tanggal tidak memiliki komponen waktu
//     final startDate = DateTime(
//       _checkInDate.year,
//       _checkInDate.month,
//       _checkInDate.day,
//     );
//     final endDate = DateTime(
//       _checkOutDate.year,
//       _checkOutDate.month,
//       _checkOutDate.day,
//     );

//     // Hitung selisih dalam hari
//     return endDate.difference(startDate).inDays;
//   }

//   double _calculateTotalPrice() {
//     final days = _calculateDays();

//     if (widget.isWholePropertyBooking) {
//       // Logic for whole property booking price would go here
//       // This would need to be fetched from the property data
//       return 0.0; // Placeholder
//     } else if (widget.room != null) {
//       // Single room booking
//       if (_isHomestay) {
//         return widget.room!.price * days; // Price per day * number of days
//       } else {
//         // For Kost, price is per month (30 days)
//         // Calculate number of months (rounded up)
//         int months = (days / 30).ceil();
//         return widget.room!.price * months;
//       }
//     } else if (widget.rooms != null && widget.rooms!.isNotEmpty) {
//       // Multiple room booking
//       double total = 0;
//       for (var room in widget.rooms!) {
//         if (_isHomestay) {
//           total += room.price * days; // Homestay price per day
//         } else {
//           // For Kost, price is per month (30 days)
//           int months = (days / 30).ceil();
//           total += room.price * months;
//         }
//       }
//       return total;
//     }

//     return 0.0;
//   }

//   Future<void> _pickKTPImage() async {
//     final picker = ImagePicker();
//     final pickedFile = await picker.pickImage(
//       source: ImageSource.gallery,
//       imageQuality: 70,
//     );

//     if (pickedFile != null) {
//       setState(() {
//         _ktpImage = File(pickedFile.path);
//       });

//       // Haptic feedback when image is selected
//       HapticFeedback.mediumImpact();

//       // Show success snackbar
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('KTP berhasil diunggah'),
//           backgroundColor: Colors.green,
//           duration: Duration(seconds: 2),
//         ),
//       );
//     }
//   }

//   Future<void> _selectDate(BuildContext context, bool isCheckIn) async {
//     final DateTime today = DateTime(
//       DateTime.now().year,
//       DateTime.now().month,
//       DateTime.now().day,
//     );

//     final picked = await showDatePicker(
//       context: context,
//       initialDate: isCheckIn ? _checkInDate : _checkOutDate,
//       firstDate:
//           isCheckIn
//               ? today
//               : DateTime(
//                 _checkInDate.year,
//                 _checkInDate.month,
//                 _checkInDate.day +
//                     (_isHomestay ? 1 : 30), // Minimum 30 days for Kost
//               ),
//       lastDate: DateTime(DateTime.now().year + 2),
//       builder: (context, child) {
//         return Theme(
//           data: Theme.of(context).copyWith(
//             colorScheme: ColorScheme.light(
//               primary: Theme.of(context).primaryColor,
//               onPrimary: Colors.white,
//               surface: Colors.white,
//               onSurface: Colors.black,
//             ),
//             dialogBackgroundColor: Colors.white,
//           ),
//           child: child!,
//         );
//       },
//     );

//     if (picked != null) {
//       setState(() {
//         if (isCheckIn) {
//           _checkInDate = DateTime(picked.year, picked.month, picked.day);

//           // For Kost, set checkout to at least 30 days later
//           if (!_isHomestay) {
//             _checkOutDate = DateTime(
//               _checkInDate.year,
//               _checkInDate.month,
//               _checkInDate.day + 30,
//             );
//           } else {
//             // For Homestay, default to 1 day later
//             _checkOutDate = DateTime(
//               _checkInDate.year,
//               _checkInDate.month,
//               _checkInDate.day + 1,
//             );
//           }
//         } else {
//           // Only allow date changes for Homestay
//           if (_isHomestay) {
//             _checkOutDate = DateTime(picked.year, picked.month, picked.day);

//             // Ensure at least 1 day difference
//             if (_calculateDays() < 1) {
//               ScaffoldMessenger.of(context).showSnackBar(
//                 const SnackBar(
//                   content: Text(
//                     'Tanggal check-out harus minimal 1 hari setelah check-in',
//                   ),
//                   backgroundColor: Colors.red,
//                 ),
//               );
//               _checkOutDate = DateTime(
//                 _checkInDate.year,
//                 _checkInDate.month,
//                 _checkInDate.day + 1,
//               );
//             }
//           } else {
//             // For Kost, show message that checkout is fixed based on checkin
//             ScaffoldMessenger.of(context).showSnackBar(
//               const SnackBar(
//                 content: Text(
//                   'Untuk Kost, durasi booking adalah per bulan (30 hari)',
//                 ),
//                 backgroundColor: Colors.blue,
//               ),
//             );
//           }
//         }
//       });

//       HapticFeedback.selectionClick();
//     }
//   }

//   void _nextStep() {
//     if (_currentStep < 2) {
//       setState(() {
//         _currentStep++;
//       });
//       _pageController.animateToPage(
//         _currentStep,
//         duration: const Duration(milliseconds: 300),
//         curve: Curves.easeInOut,
//       );
//     }
//   }

//   void _prevStep() {
//     if (_currentStep > 0) {
//       setState(() {
//         _currentStep--;
//       });
//       _pageController.animateToPage(
//         _currentStep,
//         duration: const Duration(milliseconds: 300),
//         curve: Curves.easeInOut,
//       );
//     }
//   }

//   Future<void> _submitBooking() async {
//     if (!_formKey.currentState!.validate()) return;
//     if (_ktpImage == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Harap unggah foto KTP'),
//           backgroundColor: Colors.red,
//         ),
//       );
//       return;
//     }

//     if (!_isHomestay) {
//       final days = _calculateDays();
//       if (days % 30 != 0) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text(
//               'Untuk Kost, durasi booking harus kelipatan 30 hari (1 bulan)',
//             ),
//             backgroundColor: Colors.red,
//           ),
//         );
//         return;
//       }
//     }

//     if (!_termsAccepted) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Harap setujui syarat dan ketentuan'),
//           backgroundColor: Colors.red,
//         ),
//       );
//       return;
//     }

//     // Validasi tanggal dengan lebih ketat
//     final days = _calculateDays();
//     debugPrint('Days before submit: $days');

//     if (days < 1) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text(
//             'Tanggal check-out harus minimal 1 hari setelah check-in',
//           ),
//           backgroundColor: Colors.red,
//         ),
//       );
//       return;
//     }

//     setState(() {
//       _isLoading = true;
//       _errorMessage = null;
//     });

//     try {
//       // Prepare room IDs if booking specific rooms
//       List<int>? roomIds;
//       if (!widget.isWholePropertyBooking) {
//         if (widget.room != null) {
//           roomIds = [widget.room!.id];
//         } else if (widget.rooms != null && widget.rooms!.isNotEmpty) {
//           roomIds = widget.rooms!.map((room) => room.id).toList();
//         }
//       }

//       debugPrint(
//         'Submitting booking with dates: ${DateFormat('yyyy-MM-dd').format(_checkInDate)} to ${DateFormat('yyyy-MM-dd').format(_checkOutDate)}',
//       );
//       debugPrint('Days: $days');

//       final booking = await _bookingRepository.createBooking(
//         propertyId: widget.propertyId,
//         roomIds: roomIds,
//         checkIn: _checkInDate,
//         checkOut: _checkOutDate,
//         isForOthers: _isForOthers,
//         guestName: _isForOthers ? _guestNameController.text : null,
//         guestPhone: _isForOthers ? _guestPhoneController.text : null,
//         ktpImage: _ktpImage!,
//         identityNumber: _ktpController.text,
//         specialRequests:
//             _specialRequestsController.text.isNotEmpty
//                 ? _specialRequestsController.text
//                 : null,
//       );

//       // Haptic feedback for successful booking
//       HapticFeedback.heavyImpact();

//       Navigator.of(context).pushReplacement(
//         MaterialPageRoute(
//           builder: (_) => BookingSuccessScreen(booking: booking),
//         ),
//       );
//     } catch (e) {
//       setState(() {
//         _isLoading = false;
//         _errorMessage = e.toString();
//       });

//       // Haptic feedback for error
//       HapticFeedback.vibrate();

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Gagal membuat booking: $e'),
//           backgroundColor: Colors.red,
//           duration: const Duration(seconds: 5),
//           action: SnackBarAction(
//             label: 'Detail',
//             textColor: Colors.white,
//             onPressed: () {
//               showDialog(
//                 context: context,
//                 builder:
//                     (context) => AlertDialog(
//                       title: const Text('Detail Error'),
//                       content: SingleChildScrollView(child: Text(e.toString())),
//                       actions: [
//                         TextButton(
//                           onPressed: () => Navigator.pop(context),
//                           child: const Text('Tutup'),
//                         ),
//                       ],
//                     ),
//               );
//             },
//           ),
//         ),
//       );
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     // Show loading indicator while fetching property type
//     if (_isLoadingPropertyType) {
//       return Scaffold(
//         appBar: AppBar(title: const Text('Buat Booking'), elevation: 0),
//         body: const Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               CircularProgressIndicator(),
//               SizedBox(height: 16),
//               Text('Memuat informasi properti...'),
//             ],
//           ),
//         ),
//       );
//     }

//     final days = _calculateDays();
//     final totalPrice = _calculateTotalPrice();
//     final bookingType =
//         widget.isWholePropertyBooking
//             ? 'Seluruh Properti'
//             : (widget.room != null
//                 ? 'Kamar ${widget.room!.roomNumber}'
//                 : 'Multiple Kamar');
//     final currencyFormat = NumberFormat.currency(
//       locale: 'id_ID',
//       symbol: 'Rp',
//       decimalDigits: 0,
//     );

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Buat Booking'),
//         elevation: 0,
//         backgroundColor: Theme.of(context).primaryColor,
//         foregroundColor: Colors.white,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.info_outline),
//             onPressed: () {
//               showDialog(
//                 context: context,
//                 builder:
//                     (context) => AlertDialog(
//                       title: const Text('Informasi Booking'),
//                       content: const SingleChildScrollView(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             Text('• Durasi minimal pemesanan adalah 1 hari'),
//                             SizedBox(height: 8),
//                             Text(
//                               '• Pembayaran dilakukan setelah booking dikonfirmasi',
//                             ),
//                             SizedBox(height: 8),
//                             Text('• Pastikan data yang dimasukkan sudah benar'),
//                             SizedBox(height: 8),
//                             Text(
//                               '• Foto KTP digunakan untuk verifikasi identitas',
//                             ),
//                           ],
//                         ),
//                       ),
//                       actions: [
//                         TextButton(
//                           onPressed: () => Navigator.pop(context),
//                           child: const Text('Mengerti'),
//                         ),
//                       ],
//                     ),
//               );
//             },
//           ),
//         ],
//       ),
//       body:
//           _isLoading
//               ? const Center(child: CircularProgressIndicator())
//               : Form(
//                 key: _formKey,
//                 child: Column(
//                   children: [
//                     // Progress indicator
//                     Container(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 16,
//                         vertical: 8,
//                       ),
//                       child: Row(
//                         children: [
//                           for (int i = 0; i < 3; i++)
//                             Expanded(
//                               child: Container(
//                                 margin: const EdgeInsets.symmetric(
//                                   horizontal: 4,
//                                 ),
//                                 height: 4,
//                                 decoration: BoxDecoration(
//                                   color:
//                                       i <= _currentStep
//                                           ? Theme.of(context).primaryColor
//                                           : Colors.grey.shade300,
//                                   borderRadius: BorderRadius.circular(2),
//                                 ),
//                               ),
//                             ),
//                         ],
//                       ),
//                     ),

//                     // Step title
//                     Padding(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 16,
//                         vertical: 8,
//                       ),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(
//                             _currentStep == 0
//                                 ? 'Detail Pemesanan'
//                                 : _currentStep == 1
//                                 ? 'Informasi Pemesan'
//                                 : 'Konfirmasi',
//                             style: const TextStyle(
//                               fontSize: 18,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           Text(
//                             'Langkah ${_currentStep + 1}/3',
//                             style: TextStyle(color: Colors.grey.shade600),
//                           ),
//                         ],
//                       ),
//                     ),

//                     // Error message if any
//                     if (_errorMessage != null)
//                       Container(
//                         width: double.infinity,
//                         padding: const EdgeInsets.all(12),
//                         margin: const EdgeInsets.symmetric(
//                           horizontal: 16,
//                           vertical: 8,
//                         ),
//                         decoration: BoxDecoration(
//                           color: Colors.red[50],
//                           borderRadius: BorderRadius.circular(8),
//                           border: Border.all(color: Colors.red),
//                         ),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             const Text(
//                               'Error:',
//                               style: TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.red,
//                               ),
//                             ),
//                             const SizedBox(height: 4),
//                             Text(
//                               _errorMessage!,
//                               style: TextStyle(color: Colors.red[800]),
//                             ),
//                           ],
//                         ),
//                       ),

//                     // Page content
//                     Expanded(
//                       child: PageView(
//                         controller: _pageController,
//                         physics: const NeverScrollableScrollPhysics(),
//                         children: [
//                           // Page 1: Booking Details
//                           _buildBookingDetailsPage(
//                             bookingType,
//                             days,
//                             totalPrice,
//                             currencyFormat,
//                           ),
//                           _buildGuestInformationPage(),
//                           _buildConfirmationPage(
//                             bookingType,
//                             days,
//                             totalPrice,
//                             currencyFormat,
//                           ),
//                         ],
//                       ),
//                     ),

//                     Container(
//                       padding: const EdgeInsets.all(16),
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.black.withOpacity(0.05),
//                             blurRadius: 10,
//                             offset: const Offset(0, -5),
//                           ),
//                         ],
//                       ),
//                       child: Row(
//                         children: [
//                           if (_currentStep > 0)
//                             Expanded(
//                               child: OutlinedButton(
//                                 onPressed: _prevStep,
//                                 style: OutlinedButton.styleFrom(
//                                   padding: const EdgeInsets.symmetric(
//                                     vertical: 16,
//                                   ),
//                                   side: BorderSide(
//                                     color: Theme.of(context).primaryColor,
//                                   ),
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(8),
//                                   ),
//                                 ),
//                                 child: const Text('Kembali'),
//                               ),
//                             ),
//                           if (_currentStep > 0) const SizedBox(width: 16),
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:front/features/dashboard/presentation/screens/users/penyewa/booking/booking_repository.dart';
import 'package:front/features/dashboard/presentation/screens/users/penyewa/booking/BookingSuccessScreen.dart';
import 'package:front/core/network/api_client.dart';
import 'package:front/features/room/data/models/new_room_model.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:flutter/services.dart';

class CreateBookingEnhancedScreen extends StatefulWidget {
  final int propertyId;
  final int? propertyTypeId;
  final Room? room;
  final List<Room>? rooms;
  final bool isWholePropertyBooking;

  const CreateBookingEnhancedScreen({
    Key? key,
    required this.propertyId,
    this.room,
    this.rooms,
    this.propertyTypeId,
    this.isWholePropertyBooking = false,
  }) : super(key: key);

  @override
  _CreateBookingEnhancedScreenState createState() =>
      _CreateBookingEnhancedScreenState();
}

class _CreateBookingEnhancedScreenState
    extends State<CreateBookingEnhancedScreen> {
  final _formKey = GlobalKey<FormState>();
  final _pageController = PageController();
  File? _ktpImage;
  bool _isLoading = false;
  bool _isLoadingPropertyType = true;
  late BookingRepository _bookingRepository;
  late DateTime _checkInDate;
  late DateTime _checkOutDate;
  final TextEditingController _guestNameController = TextEditingController();
  final TextEditingController _guestPhoneController = TextEditingController();
  final TextEditingController _ktpController = TextEditingController();
  final TextEditingController _specialRequestsController =
      TextEditingController();
  bool _isForOthers = false;
  int _propertyTypeId = 1; // Default to Kost
  String? _errorMessage;
  int _currentStep = 0;
  bool _termsAccepted = false;
  int _selectedMonth = 1; // Default 1 bulan untuk Kost

  @override
  void initState() {
    super.initState();
    _bookingRepository = BookingRepository(apiClient: ApiClient());

    final now = DateTime.now();
    _checkInDate = DateTime(now.year, now.month, now.day);

    // Set default checkout date based on property type
    if (widget.propertyTypeId == 2) {
      // Homestay - default to 1 day
      _checkOutDate = DateTime(
        _checkInDate.year,
        _checkInDate.month,
        _checkInDate.day + 1,
      );
    } else {
      // Kost - default to 30 days (1 month)
      _checkOutDate = DateTime(
        _checkInDate.year,
        _checkInDate.month + _selectedMonth,
        _checkInDate.day,
      );
    }

    // If propertyTypeId is provided, use it directly
    if (widget.propertyTypeId != null) {
      _propertyTypeId = widget.propertyTypeId!;
      _isLoadingPropertyType = false;
    } else {
      // Otherwise fetch property type
      _fetchPropertyType();
    }
  }

  // Fetch property type from server
  Future<void> _fetchPropertyType() async {
    setState(() {
      _isLoadingPropertyType = true;
      _errorMessage = null;
    });

    try {
      final property = await _bookingRepository.getPropertyDetails(
        widget.propertyId,
      );
      setState(() {
        _propertyTypeId = property.propertyTypeId;
        _isLoadingPropertyType = false;

        // Update checkout date based on property type
        if (_isHomestay) {
          _checkOutDate = DateTime(
            _checkInDate.year,
            _checkInDate.month,
            _checkInDate.day + 1,
          );
        } else {
          _checkOutDate = DateTime(
            _checkInDate.year,
            _checkInDate.month + _selectedMonth,
            _checkInDate.day,
          );
        }
      });
    } catch (e) {
      setState(() {
        _isLoadingPropertyType = false;
        _errorMessage = 'Gagal memuat tipe properti: $e';
      });
    }
  }

  bool get _isHomestay => _propertyTypeId == 2;

  int _calculateDays() {
    if (_isHomestay) {
      final startDate = DateTime(
        _checkInDate.year,
        _checkInDate.month,
        _checkInDate.day,
      );
      final endDate = DateTime(
        _checkOutDate.year,
        _checkOutDate.month,
        _checkOutDate.day,
      );
      return endDate.difference(startDate).inDays;
    } else {
      return 30 * _selectedMonth;
    }
  }

  double _calculateTotalPrice() {
    if (widget.isWholePropertyBooking) {
      return 0.0; // Placeholder
    } else if (widget.room != null) {
      if (_isHomestay) {
        return widget.room!.price * _calculateDays();
      } else {
        return widget.room!.price * _selectedMonth;
      }
    } else if (widget.rooms != null && widget.rooms!.isNotEmpty) {
      double total = 0;
      for (var room in widget.rooms!) {
        if (_isHomestay) {
          total += room.price * _calculateDays();
        } else {
          total += room.price * _selectedMonth;
        }
      }
      return total;
    }
    return 0.0;
  }

  Future<void> _pickKTPImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );

    if (pickedFile != null) {
      setState(() {
        _ktpImage = File(pickedFile.path);
      });
      HapticFeedback.mediumImpact();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('KTP berhasil diunggah'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _selectDate(BuildContext context, bool isCheckIn) async {
    if (!_isHomestay && !isCheckIn) return;

    final DateTime today = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );

    final picked = await showDatePicker(
      context: context,
      initialDate: isCheckIn ? _checkInDate : _checkOutDate,
      firstDate: isCheckIn ? today : _checkInDate.add(const Duration(days: 1)),
      lastDate: DateTime(DateTime.now().year + 2),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Theme.of(context).primaryColor,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _checkInDate = DateTime(picked.year, picked.month, picked.day);
        if (!_isHomestay) {
          _checkOutDate = DateTime(
            _checkInDate.year,
            _checkInDate.month + _selectedMonth,
            _checkInDate.day,
          );
        }
      });
      HapticFeedback.selectionClick();
    }
  }

  Widget _buildMonthSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Durasi Sewa',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: List.generate(12, (index) {
            final month = index + 1;
            return ChoiceChip(
              label: Text('$month Bulan'),
              selected: _selectedMonth == month,
              selectedColor: Theme.of(context).primaryColor,
              onSelected: (selected) {
                setState(() {
                  _selectedMonth = month;
                  _checkOutDate = DateTime(
                    _checkInDate.year,
                    _checkInDate.month + month,
                    _checkInDate.day,
                  );
                });
                HapticFeedback.selectionClick();
              },
            );
          }),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Total Durasi:'),
              Text(
                '$_selectedMonth Bulan (${_calculateDays()} Hari)',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _nextStep() {
    if (_currentStep < 2) {
      setState(() {
        _currentStep++;
      });
      _pageController.animateToPage(
        _currentStep,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _prevStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
      _pageController.animateToPage(
        _currentStep,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _submitBooking() async {
    if (!_formKey.currentState!.validate()) return;
    if (_ktpImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Harap unggah foto KTP'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (!_termsAccepted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Harap setujui syarat dan ketentuan'),
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
      List<int>? roomIds;
      if (!widget.isWholePropertyBooking) {
        if (widget.room != null) {
          roomIds = [widget.room!.id];
        } else if (widget.rooms != null && widget.rooms!.isNotEmpty) {
          roomIds = widget.rooms!.map((room) => room.id).toList();
        }
      }

      final booking = await _bookingRepository.createBooking(
        propertyId: widget.propertyId,
        roomIds: roomIds,
        checkIn: _checkInDate,
        checkOut: _checkOutDate,
        isForOthers: _isForOthers,
        guestName: _isForOthers ? _guestNameController.text : null,
        guestPhone: _isForOthers ? _guestPhoneController.text : null,
        ktpImage: _ktpImage!,
        identityNumber: _ktpController.text,
        specialRequests:
            _specialRequestsController.text.isNotEmpty
                ? _specialRequestsController.text
                : null,
      );

      HapticFeedback.heavyImpact();
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
      HapticFeedback.vibrate();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal membuat booking: $e'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 5),
          action: SnackBarAction(
            label: 'Detail',
            textColor: Colors.white,
            onPressed: () {
              showDialog(
                context: context,
                builder:
                    (context) => AlertDialog(
                      title: const Text('Detail Error'),
                      content: SingleChildScrollView(child: Text(e.toString())),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Tutup'),
                        ),
                      ],
                    ),
              );
            },
          ),
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
    if (_isLoadingPropertyType) {
      return Scaffold(
        appBar: AppBar(title: const Text('Buat Booking'), elevation: 0),
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
    final bookingType =
        widget.isWholePropertyBooking
            ? 'Seluruh Properti'
            : (widget.room != null
                ? 'Kamar ${widget.room!.roomNumber}'
                : 'Multiple Kamar');
    final currencyFormat = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp',
      decimalDigits: 0,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Buat Booking'),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              showDialog(
                context: context,
                builder:
                    (context) => AlertDialog(
                      title: const Text('Informasi Booking'),
                      content: const SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('• Durasi minimal pemesanan adalah 1 hari'),
                            SizedBox(height: 8),
                            Text(
                              '• Pembayaran dilakukan setelah booking dikonfirmasi',
                            ),
                            SizedBox(height: 8),
                            Text('• Pastikan data yang dimasukkan sudah benar'),
                            SizedBox(height: 8),
                            Text(
                              '• Foto KTP digunakan untuk verifikasi identitas',
                            ),
                          ],
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Mengerti'),
                        ),
                      ],
                    ),
              );
            },
          ),
        ],
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Form(
                key: _formKey,
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: Row(
                        children: [
                          for (int i = 0; i < 3; i++)
                            Expanded(
                              child: Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                ),
                                height: 4,
                                decoration: BoxDecoration(
                                  color:
                                      i <= _currentStep
                                          ? Theme.of(context).primaryColor
                                          : Colors.grey.shade300,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _currentStep == 0
                                ? 'Detail Pemesanan'
                                : _currentStep == 1
                                ? 'Informasi Pemesan'
                                : 'Konfirmasi',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Langkah ${_currentStep + 1}/3',
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                        ],
                      ),
                    ),
                    if (_errorMessage != null)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
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
                    Expanded(
                      child: PageView(
                        controller: _pageController,
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          _buildBookingDetailsPage(
                            bookingType,
                            days,
                            totalPrice,
                            currencyFormat,
                          ),
                          _buildGuestInformationPage(),
                          _buildConfirmationPage(
                            bookingType,
                            days,
                            totalPrice,
                            currencyFormat,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, -5),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          if (_currentStep > 0)
                            Expanded(
                              child: OutlinedButton(
                                onPressed: _prevStep,
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                  side: BorderSide(
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Text('Kembali'),
                              ),
                            ),
                          if (_currentStep > 0) const SizedBox(width: 16),
                          Expanded(
                            child: ElevatedButton(
                              onPressed:
                                  _currentStep < 2 ? _nextStep : _submitBooking,
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                backgroundColor: Color(0xFF4CAF50),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                elevation: 0,
                              ),
                              child: Text(
                                _currentStep < 2 ? 'Lanjutkan' : 'Buat Booking',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
    );
  }

  Widget _buildBookingDetailsPage(
    String bookingType,
    int days,
    double totalPrice,
    NumberFormat currencyFormat,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.grey.shade200),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Theme.of(
                            context,
                          ).primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.home_outlined,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Tipe Booking: $bookingType',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    _isHomestay
                                        ? Colors.amber[100]
                                        : Colors.blue[100],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                _isHomestay ? 'Homestay' : 'Kost',
                                style: TextStyle(
                                  fontSize: 12,
                                  color:
                                      _isHomestay
                                          ? Colors.amber[900]
                                          : Colors.blue[900],
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (widget.room != null) ...[
                    Row(
                      children: [
                        const Icon(
                          Icons.meeting_room_outlined,
                          color: Colors.grey,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text('Tipe Kamar: ${widget.room!.roomType}'),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(
                          Icons.attach_money,
                          color: Colors.grey,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _isHomestay
                              ? 'Harga: Rp ${NumberFormat("#,###").format(widget.room!.price)}/hari'
                              : 'Harga: Rp ${NumberFormat("#,###").format(widget.room!.price)}/bulan',
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],
                  const Divider(),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Check-in',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 8),
                            InkWell(
                              onTap: () => _selectDate(context, true),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.grey.shade300,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.calendar_today, size: 16),
                                    const SizedBox(width: 8),
                                    Text(
                                      DateFormat(
                                        'dd MMM yyyy',
                                      ).format(_checkInDate),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Check-out',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 8),
                            InkWell(
                              onTap: () => _selectDate(context, false),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.grey.shade300,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.calendar_today, size: 16),
                                    const SizedBox(width: 8),
                                    Text(
                                      DateFormat(
                                        'dd MMM yyyy',
                                      ).format(_checkOutDate),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Durasi:'),
                        Text(
                          '$days hari',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  if (totalPrice > 0) ...[
                    const SizedBox(height: 16),
                    const Divider(),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total:',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          currencyFormat.format(totalPrice),
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.grey.shade200),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.amber.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.lightbulb_outline,
                          color: Colors.amber,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          'Tips Booking',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Row(
                    children: [
                      Icon(Icons.check_circle, color: Colors.green, size: 16),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Pastikan tanggal check-in dan check-out sudah benar',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Row(
                    children: [
                      Icon(Icons.check_circle, color: Colors.green, size: 16),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text('Siapkan KTP untuk verifikasi identitas'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Row(
                    children: [
                      Icon(Icons.check_circle, color: Colors.green, size: 16),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text('Durasi minimal pemesanan adalah 1 hari'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGuestInformationPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.grey.shade200),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Theme.of(
                            context,
                          ).primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.person_outline,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          'Informasi Pemesan',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Booking untuk orang lain'),
                    value: _isForOthers,
                    activeColor: Theme.of(context).primaryColor,
                    onChanged: (value) => setState(() => _isForOthers = value),
                  ),
                  if (_isForOthers) ...[
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _guestNameController,
                      decoration: InputDecoration(
                        labelText: 'Nama Tamu',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        prefixIcon: const Icon(Icons.person),
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
                      decoration: InputDecoration(
                        labelText: 'Nomor Telepon Tamu',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        prefixIcon: const Icon(Icons.phone),
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
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.grey.shade200),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.credit_card,
                          color: Colors.blue,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          'Identitas',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _ktpController,
                    decoration: InputDecoration(
                      labelText: 'Nomor KTP',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      prefixIcon: const Icon(Icons.credit_card),
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
                        border: Border.all(
                          color:
                              _ktpImage == null
                                  ? Colors.grey.shade300
                                  : Colors.green,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            _ktpImage == null
                                ? Icons.upload_file
                                : Icons.check_circle,
                            size: 48,
                            color:
                                _ktpImage == null ? Colors.grey : Colors.green,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _ktpImage == null
                                ? 'Unggah Foto KTP (Wajib)'
                                : 'KTP berhasil diunggah',
                            style: TextStyle(
                              color:
                                  _ktpImage == null
                                      ? Colors.grey
                                      : Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (_ktpImage == null) ...[
                            const SizedBox(height: 8),
                            Text(
                              'Klik untuk memilih file',
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 12,
                              ),
                            ),
                          ],
                          if (_ktpImage != null) ...[
                            const SizedBox(height: 16),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.file(
                                _ktpImage!,
                                height: 120,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextButton.icon(
                              onPressed: _pickKTPImage,
                              icon: const Icon(Icons.refresh, size: 16),
                              label: const Text('Ganti Foto'),
                              style: TextButton.styleFrom(
                                foregroundColor: Theme.of(context).primaryColor,
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
          const SizedBox(height: 16),
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.grey.shade200),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.purple.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.message_outlined,
                          color: Colors.purple,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          'Permintaan Khusus',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _specialRequestsController,
                    decoration: InputDecoration(
                      hintText: 'Masukkan permintaan khusus Anda (opsional)',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    maxLines: 3,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConfirmationPage(
    String bookingType,
    int days,
    double totalPrice,
    NumberFormat currencyFormat,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.grey.shade200),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Ringkasan Booking',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: 16),
                  _buildConfirmationItem(
                    'Tipe Booking',
                    bookingType,
                    Icons.home_outlined,
                  ),
                  const Divider(),
                  _buildConfirmationItem(
                    'Check-in',
                    DateFormat('dd MMM yyyy').format(_checkInDate),
                    Icons.calendar_today,
                  ),
                  const Divider(),
                  _buildConfirmationItem(
                    'Check-out',
                    DateFormat('dd MMM yyyy').format(_checkOutDate),
                    Icons.calendar_today,
                  ),
                  const Divider(),
                  _buildConfirmationItem(
                    'Durasi',
                    '$days hari',
                    Icons.timelapse,
                  ),
                  if (_isForOthers) ...[
                    const Divider(),
                    _buildConfirmationItem(
                      'Tamu',
                      _guestNameController.text,
                      Icons.person,
                    ),
                    const Divider(),
                    _buildConfirmationItem(
                      'Telepon Tamu',
                      _guestPhoneController.text,
                      Icons.phone,
                    ),
                  ],
                  const Divider(),
                  _buildConfirmationItem(
                    'Nomor KTP',
                    _ktpController.text.isEmpty
                        ? 'Belum diisi'
                        : _ktpController.text,
                    Icons.credit_card,
                  ),
                  if (_specialRequestsController.text.isNotEmpty) ...[
                    const Divider(),
                    _buildConfirmationItem(
                      'Permintaan Khusus',
                      _specialRequestsController.text,
                      Icons.message,
                    ),
                  ],
                  const Divider(),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total Pembayaran',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        currencyFormat.format(totalPrice),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.grey.shade200),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Metode Pembayaran',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.blue),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Pembayaran akan dilakukan setelah booking dikonfirmasi',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.grey.shade200),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Checkbox(
                        value: _termsAccepted,
                        onChanged: (value) {
                          setState(() {
                            _termsAccepted = value ?? false;
                          });
                        },
                        activeColor: Theme.of(context).primaryColor,
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _termsAccepted = !_termsAccepted;
                            });
                          },
                          child: const Text(
                            'Saya menyetujui syarat dan ketentuan yang berlaku',
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 48),
                    child: TextButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder:
                              (context) => AlertDialog(
                                title: const Text('Syarat dan Ketentuan'),
                                content: const SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        '1. Pembatalan booking dikenakan biaya sesuai ketentuan',
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        '2. Identitas yang diberikan harus valid dan dapat diverifikasi',
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        '3. Penyewa wajib mematuhi peraturan yang berlaku di properti',
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        '4. Pembayaran harus dilakukan sesuai dengan ketentuan yang berlaku',
                                      ),
                                    ],
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('Tutup'),
                                  ),
                                ],
                              ),
                        );
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        'Lihat Syarat dan Ketentuan',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConfirmationItem(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.grey),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
