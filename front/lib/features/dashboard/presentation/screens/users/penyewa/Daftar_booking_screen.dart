// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:front/core/network/api_client.dart';
// import 'package:front/features/dashboard/presentation/screens/users/penyewa/service/booking_service.dart';
// import 'package:front/features/dashboard/presentation/screens/users/penyewa/models/booking_model.dart';
// import 'package:front/features/dashboard/presentation/screens/users/penyewa/booking_card_screen.dart';
// import 'package:front/features/dashboard/presentation/screens/users/penyewa/booking_detail_screen.dart';
// import 'package:front/features/dashboard/presentation/screens/users/penyewa/review_booking_screen.dart';
// import 'package:front/core/utils/constants.dart';
// import 'package:front/core/widgets/loading_indicator.dart';
// import 'package:front/core/widgets/error_state.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:share_plus/share_plus.dart';
// import 'dart:io';
// import 'package:http/http.dart' as http;
// import 'package:front/core/utils/theme_config.dart';

// class BookingListScreen extends StatefulWidget {
//   const BookingListScreen({Key? key}) : super(key: key);

//   @override
//   _BookingListScreenState createState() => _BookingListScreenState();
// }

// class _BookingListScreenState extends State<BookingListScreen>
//     with SingleTickerProviderStateMixin {
//   late TabController _tabController;
//   late BookingService _bookingService;
//   List<Booking> _allBookings = [];
//   bool _isLoading = true;
//   bool _isRefreshing = false;
//   String? _errorMessage;

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 4, vsync: this);
//     _bookingService = BookingService(ApiClient());
//     _loadBookings();

//     // Listen to tab changes to refresh the UI
//     _tabController.addListener(() {
//       setState(() {});
//     });
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }

//   Future<void> _loadBookings() async {
//     if (_isRefreshing) return;

//     setState(() {
//       _isLoading = true;
//       _isRefreshing = true;
//       _errorMessage = null;
//     });

//     try {
//       final bookings = await _bookingService.getUserBookings();

//       // Log the number of bookings per status for debugging
//       final pendingCount =
//           bookings.where((b) => b.status.toLowerCase() == 'pending').length;
//       final confirmedCount =
//           bookings.where((b) => b.status.toLowerCase() == 'confirmed').length;
//       final cancelledCount =
//           bookings.where((b) => b.status.toLowerCase() == 'cancelled').length;
//       final completedCount =
//           bookings.where((b) => b.status.toLowerCase() == 'completed').length;

//       debugPrint('Loaded ${bookings.length} bookings:');
//       debugPrint('- Pending: $pendingCount');
//       debugPrint('- Confirmed: $confirmedCount');
//       debugPrint('- Cancelled: $cancelledCount');
//       debugPrint('- Completed: $completedCount');

//       setState(() {
//         _allBookings = bookings;
//         _isLoading = false;
//         _isRefreshing = false;
//       });
//     } catch (e) {
//       setState(() {
//         _errorMessage = 'Gagal memuat data booking: $e';
//         _isLoading = false;
//         _isRefreshing = false;
//       });
//     }
//   }

//   List<Booking> _getFilteredBookings() {
//     String statusFilter;

//     switch (_tabController.index) {
//       case 0:
//         statusFilter = 'pending';
//         break;
//       case 1:
//         statusFilter = 'confirmed';
//         break;
//       case 2:
//         statusFilter = 'cancelled';
//         break;
//       case 3:
//         statusFilter = 'completed';
//         break;
//       default:
//         statusFilter = '';
//     }

//     return _allBookings
//         .where((booking) => booking.status.toLowerCase() == statusFilter)
//         .toList();
//   }

//   Future<void> _refreshBookings() async {
//     await _loadBookings();
//   }

//   Future<void> _downloadBookingCard(Booking booking) async {
//     try {
//       // Show loading dialog
//       showDialog(
//         context: context,
//         barrierDismissible: false,
//         builder: (BuildContext context) {
//           return const AlertDialog(
//             content: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 CircularProgressIndicator(),
//                 SizedBox(height: 16),
//                 Text('Mengunduh kartu booking...'),
//               ],
//             ),
//           );
//         },
//       );

//       // Download booking card
//       final response = await http.get(
//         Uri.parse('${Constants.baseUrl}/api/bookings/${booking.id}/card'),
//         headers: await _bookingService.getAuthHeaders(),
//       );

//       // Close loading dialog
//       Navigator.pop(context);

//       if (response.statusCode == 200) {
//         // Save PDF to temporary file
//         final directory = await getTemporaryDirectory();
//         final filePath = '${directory.path}/booking_card_${booking.id}.pdf';
//         final file = File(filePath);
//         await file.writeAsBytes(response.bodyBytes);

//         // Show success dialog with options
//         showDialog(
//           context: context,
//           builder: (BuildContext context) {
//             return AlertDialog(
//               title: const Text('Kartu Booking Berhasil Diunduh'),
//               content: const Text(
//                 'Apa yang ingin Anda lakukan dengan kartu booking ini?',
//               ),
//               actions: [
//                 TextButton(
//                   onPressed: () {
//                     Navigator.pop(context);
//                     _openBookingCard(booking);
//                   },
//                   child: const Text('Lihat'),
//                 ),
//                 TextButton(
//                   onPressed: () {
//                     Navigator.pop(context);
//                     Share.shareFiles([
//                       filePath,
//                     ], text: 'Kartu Booking #${booking.id}');
//                   },
//                   child: const Text('Bagikan'),
//                 ),
//                 TextButton(
//                   onPressed: () {
//                     Navigator.pop(context);
//                   },
//                   child: const Text('Tutup'),
//                 ),
//               ],
//             );
//           },
//         );
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text(
//               'Gagal mengunduh kartu booking: ${response.statusCode}',
//             ),
//           ),
//         );
//       }
//     } catch (e) {
//       // Close loading dialog if still open
//       if (Navigator.canPop(context)) {
//         Navigator.pop(context);
//       }

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Gagal mengunduh kartu booking: $e')),
//       );
//     }
//   }

//   void _openBookingCard(Booking booking) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => BookingCardScreen(booking: booking),
//       ),
//     ).then((_) {
//       // Refresh bookings when returning from booking card screen
//       _refreshBookings();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Daftar Booking'),
//         elevation: 0,
//         bottom: TabBar(
//           controller: _tabController,
//           isScrollable: true,
//           labelColor: ThemeConfig.primaryColor,
//           unselectedLabelColor: Colors.grey,
//           indicatorColor: ThemeConfig.primaryColor,
//           tabs: const [
//             Tab(text: 'Menunggu'),
//             Tab(text: 'Disetujui'),
//             Tab(text: 'Ditolak'),
//             Tab(text: 'Selesai'),
//           ],
//         ),
//       ),
//       body:
//           _isLoading
//               ? const LoadingIndicator()
//               : _errorMessage != null
//               ? ErrorState(message: _errorMessage!, onRetry: _refreshBookings)
//               : RefreshIndicator(
//                 onRefresh: _refreshBookings,
//                 child: _buildBookingList(),
//               ),
//     );
//   }

//   Widget _buildBookingList() {
//     final filteredBookings = _getFilteredBookings();

//     if (filteredBookings.isEmpty) {
//       return Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(_getEmptyStateIcon(), size: 64, color: Colors.grey[400]),
//             const SizedBox(height: 16),
//             Text(
//               _getEmptyStateMessage(),
//               style: TextStyle(fontSize: 16, color: Colors.grey[600]),
//               textAlign: TextAlign.center,
//             ),
//           ],
//         ),
//       );
//     }

//     return ListView.builder(
//       padding: const EdgeInsets.all(12),
//       itemCount: filteredBookings.length,
//       itemBuilder: (context, index) {
//         final booking = filteredBookings[index];
//         return BookingCard(
//           booking: booking,
//           onCancel: () async {
//             final confirm = await showDialog<bool>(
//               context: context,
//               builder:
//                   (context) => AlertDialog(
//                     title: const Text('Konfirmasi Pembatalan'),
//                     content: const Text(
//                       'Apakah Anda yakin ingin membatalkan booking ini?',
//                     ),
//                     actions: [
//                       TextButton(
//                         onPressed: () => Navigator.pop(context, false),
//                         child: const Text('Tidak'),
//                       ),
//                       TextButton(
//                         onPressed: () => Navigator.pop(context, true),
//                         child: const Text('Ya'),
//                       ),
//                     ],
//                   ),
//             );

//             if (confirm == true) {
//               try {
//                 await _bookingService.cancelBooking(booking.id!);
//                 _refreshBookings();
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(content: Text('Booking berhasil dibatalkan')),
//                 );
//               } catch (e) {
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(content: Text('Gagal membatalkan: $e')),
//                 );
//               }
//             }
//           },
//           onViewDetails: () {
//             // Navigate to booking details
//             Navigator.pushNamed(
//               context,
//               '/booking-details',
//               arguments: booking.id,
//             ).then((_) {
//               // Refresh bookings when returning from details
//               _refreshBookings();
//             });
//           },
//           onDownloadCard:
//               booking.status.toLowerCase() == 'completed'
//                   ? () => _downloadBookingCard(booking)
//                   : null,
//         );
//       },
//     );
//   }

//   IconData _getEmptyStateIcon() {
//     switch (_tabController.index) {
//       case 0:
//         return Icons.hourglass_empty;
//       case 1:
//         return Icons.check_circle_outline;
//       case 2:
//         return Icons.cancel_outlined;
//       case 3:
//         return Icons.done_all;
//       default:
//         return Icons.list_alt;
//     }
//   }

//   String _getEmptyStateMessage() {
//     switch (_tabController.index) {
//       case 0:
//         return 'Belum ada booking yang menunggu persetujuan';
//       case 1:
//         return 'Belum ada booking yang disetujui';
//       case 2:
//         return 'Tidak ada booking yang ditolak';
//       case 3:
//         return 'Belum ada booking yang selesai';
//       default:
//         return 'Belum ada booking';
//     }
//   }
// }

// class BookingCard extends StatelessWidget {
//   final Booking booking;
//   final VoidCallback onCancel;
//   final VoidCallback onViewDetails;
//   final VoidCallback? onDownloadCard;

//   const BookingCard({
//     required this.booking,
//     required this.onCancel,
//     required this.onViewDetails,
//     this.onDownloadCard,
//     Key? key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final dateFormat = DateFormat('dd MMM yyyy');
//     final currencyFormat = NumberFormat.currency(
//       locale: 'id_ID',
//       symbol: 'Rp',
//       decimalDigits: 0,
//     );

//     Color statusColor;
//     String statusText;

//     switch (booking.status.toLowerCase()) {
//       case 'confirmed':
//         statusColor = Colors.green;
//         statusText = 'Disetujui';
//         break;
//       case 'pending':
//         statusColor = Colors.orange;
//         statusText = 'Menunggu';
//         break;
//       case 'cancelled':
//         statusColor = Colors.red;
//         statusText = 'Ditolak';
//         break;
//       case 'completed':
//         statusColor = Colors.blue;
//         statusText = 'Selesai';
//         break;
//       default:
//         statusColor = Colors.grey;
//         statusText = booking.status;
//     }

//     // Determine property image URL
//     String? propertyImageUrl;
//     if (booking.propertyImage != null) {
//       if (booking.propertyImage!.startsWith('http')) {
//         propertyImageUrl = booking.propertyImage;
//       } else {
//         propertyImageUrl =
//             '${Constants.baseUrl}/storage/${booking.propertyImage}';
//       }
//     }

//     return Card(
//       margin: const EdgeInsets.only(bottom: 16),
//       elevation: 2,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: InkWell(
//         onTap: onViewDetails,
//         borderRadius: BorderRadius.circular(12),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Header with property image and status
//             Stack(
//               children: [
//                 ClipRRect(
//                   borderRadius: const BorderRadius.vertical(
//                     top: Radius.circular(12),
//                   ),
//                   child:
//                       propertyImageUrl != null
//                           ? Image.network(
//                             propertyImageUrl,
//                             height: 120,
//                             width: double.infinity,
//                             fit: BoxFit.cover,
//                             errorBuilder: (context, error, stackTrace) {
//                               debugPrint('Error loading image: $error');
//                               return Container(
//                                 height: 120,
//                                 color: Colors.grey[200],
//                                 child: const Center(
//                                   child: Icon(
//                                     Icons.image_not_supported,
//                                     size: 40,
//                                     color: Colors.grey,
//                                   ),
//                                 ),
//                               );
//                             },
//                           )
//                           : Container(
//                             height: 120,
//                             color: Colors.grey[200],
//                             width: double.infinity,
//                             child: const Center(
//                               child: Icon(
//                                 Icons.home,
//                                 size: 40,
//                                 color: Colors.grey,
//                               ),
//                             ),
//                           ),
//                 ),
//                 Positioned(
//                   top: 12,
//                   right: 12,
//                   child: Container(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 12,
//                       vertical: 6,
//                     ),
//                     decoration: BoxDecoration(
//                       color: statusColor.withOpacity(0.2),
//                       borderRadius: BorderRadius.circular(20),
//                       border: Border.all(color: statusColor.withOpacity(0.5)),
//                     ),
//                     child: Text(
//                       statusText,
//                       style: TextStyle(
//                         color: statusColor,
//                         fontWeight: FontWeight.bold,
//                         fontSize: 12,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),

//             // Booking details
//             Padding(
//               padding: const EdgeInsets.all(16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Property name
//                   Text(
//                     booking.propertyName ?? 'Properti #${booking.propertyId}',
//                     style: const TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                     ),
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                   ),

//                   const SizedBox(height: 12),

//                   // Booking ID
//                   Row(
//                     children: [
//                       Icon(
//                         Icons.confirmation_number_outlined,
//                         size: 16,
//                         color: Colors.grey[600],
//                       ),
//                       const SizedBox(width: 8),
//                       Text(
//                         'Booking ID: #${booking.id}',
//                         style: TextStyle(fontSize: 14, color: Colors.grey[700]),
//                       ),
//                     ],
//                   ),

//                   const SizedBox(height: 8),

//                   // Check-in and check-out dates
//                   Row(
//                     children: [
//                       Expanded(
//                         child: _buildDetailRow(
//                           Icons.calendar_today,
//                           'Check-in',
//                           dateFormat.format(booking.checkIn),
//                         ),
//                       ),
//                       Expanded(
//                         child: _buildDetailRow(
//                           Icons.calendar_today,
//                           'Check-out',
//                           dateFormat.format(booking.checkOut),
//                         ),
//                       ),
//                     ],
//                   ),

//                   const SizedBox(height: 8),

//                   // Total price
//                   _buildDetailRow(
//                     Icons.attach_money,
//                     'Total',
//                     currencyFormat.format(booking.totalPrice),
//                   ),

//                   // Special requests if any
//                   if (booking.specialRequests != null &&
//                       booking.specialRequests!.isNotEmpty)
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         const SizedBox(height: 8),
//                         _buildDetailRow(
//                           Icons.note,
//                           'Permintaan Khusus',
//                           booking.specialRequests!,
//                           maxLines: 2,
//                         ),
//                       ],
//                     ),

//                   const SizedBox(height: 16),
//                   Row(
//                     children: [
//                       // Cancel button for pending and confirmed bookings
//                       if ([
//                         'pending',
//                         'confirmed',
//                       ].contains(booking.status.toLowerCase()))
//                         Expanded(
//                           child: OutlinedButton.icon(
//                             onPressed: onCancel,
//                             icon: const Icon(Icons.cancel, size: 16),
//                             label: const Text('Batalkan'),
//                             style: OutlinedButton.styleFrom(
//                               foregroundColor: Colors.red,
//                               side: const BorderSide(color: Colors.red),
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(8),
//                               ),
//                             ),
//                           ),
//                         ),

//                       // Download card button for completed bookings
//                       if (booking.status.toLowerCase() == 'completed' &&
//                           onDownloadCard != null)
//                         Expanded(
//                           child: ElevatedButton.icon(
//                             onPressed: onDownloadCard,
//                             icon: const Icon(Icons.download, size: 16),
//                             label: const Text('Kartu Booking'),
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: ThemeConfig.primaryColor,
//                               foregroundColor: Colors.white,
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(8),
//                               ),
//                             ),
//                           ),
//                         ),

//                       // New "Give Review" button next to "Download Booking Card"
//                       if (booking.status.toLowerCase() == 'completed')
//                         Expanded(
//                           child: ElevatedButton.icon(
//                             onPressed: () {
//                               final bookingId =
//                                   booking.id ??
//                                   0; // Jika booking.id null, berikan default 0
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder:
//                                       (context) => ReviewBookingScreen(
//                                         bookingId: bookingId, // Mengirimkan bookingId, bahkan jika 0
//                                         propertyId: booking.propertyId,
//                                       ),
//                                 ),
//                               );
//                             },
//                             icon: const Icon(Icons.rate_review, size: 16),
//                             label: const Text('Berikan Ulasan'),
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: ThemeConfig.primaryColor,
//                               foregroundColor: Colors.white,
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(8),
//                               ),
//                             ),
//                           ),
//                         ),
//                       if (booking.status.toLowerCase() != 'completed' ||
//                           onDownloadCard == null)
//                         Expanded(
//                           child: ElevatedButton.icon(
//                             onPressed: () {
//                               // Panggil screen detail booking dan pass ID booking
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder:
//                                       (context) => BookingDetailScreen(
//                                         bookingId:
//                                             booking
//                                                 .id, // Mengirimkan ID booking ke BookingDetailScreen
//                                       ),
//                                 ),
//                               );
//                             },
//                             icon: const Icon(Icons.visibility, size: 16),
//                             label: const Text('Lihat Detail'),
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: ThemeConfig.primaryColor,
//                               foregroundColor: Colors.white,
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(8),
//                               ),
//                             ),
//                           ),
//                         ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildDetailRow(
//     IconData icon,
//     String label,
//     String value, {
//     int maxLines = 1,
//   }) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Icon(icon, size: 16, color: Colors.grey[600]),
//         const SizedBox(width: 8),
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 label,
//                 style: TextStyle(fontSize: 12, color: Colors.grey[600]),
//               ),
//               const SizedBox(height: 2),
//               Text(
//                 value,
//                 style: const TextStyle(
//                   fontSize: 14,
//                   fontWeight: FontWeight.w500,
//                 ),
//                 maxLines: maxLines,
//                 overflow: TextOverflow.ellipsis,
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:front/core/network/api_client.dart';
import 'package:front/features/dashboard/presentation/screens/users/penyewa/service/booking_service.dart';
import 'package:front/features/dashboard/presentation/screens/users/penyewa/models/booking_model.dart';
import 'package:front/features/dashboard/presentation/screens/users/penyewa/booking_card_screen.dart';
import 'package:front/features/dashboard/presentation/screens/users/penyewa/booking_detail_screen.dart';
import 'package:front/features/dashboard/presentation/screens/users/penyewa/review_booking_screen.dart';
import 'package:front/core/utils/constants.dart';
import 'package:front/core/widgets/loading_indicator.dart';
import 'package:front/core/widgets/error_state.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:front/core/utils/theme_config.dart';

class BookingListScreen extends StatefulWidget {
  const BookingListScreen({Key? key}) : super(key: key);

  @override
  _BookingListScreenState createState() => _BookingListScreenState();
}

class _BookingListScreenState extends State<BookingListScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late BookingService _bookingService;
  List<Booking> _allBookings = [];
  bool _isLoading = true;
  bool _isRefreshing = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _bookingService = BookingService(ApiClient());
    _loadBookings();

    // Listen to tab changes to refresh the UI
    _tabController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadBookings() async {
    if (_isRefreshing) return;

    setState(() {
      _isLoading = true;
      _isRefreshing = true;
      _errorMessage = null;
    });

    try {
      final bookings = await _bookingService.getUserBookings();

      // Log the number of bookings per status for debugging
      final pendingCount =
          bookings.where((b) => b.status.toLowerCase() == 'pending').length;
      final confirmedCount =
          bookings.where((b) => b.status.toLowerCase() == 'confirmed').length;
      final cancelledCount =
          bookings.where((b) => b.status.toLowerCase() == 'cancelled').length;
      final completedCount =
          bookings.where((b) => b.status.toLowerCase() == 'completed').length;

      debugPrint('Loaded ${bookings.length} bookings:');
      debugPrint('- Pending: $pendingCount');
      debugPrint('- Confirmed: $confirmedCount');
      debugPrint('- Cancelled: $cancelledCount');
      debugPrint('- Completed: $completedCount');

      setState(() {
        _allBookings = bookings;
        _isLoading = false;
        _isRefreshing = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Gagal memuat data booking: $e';
        _isLoading = false;
        _isRefreshing = false;
      });
    }
  }

  List<Booking> _getFilteredBookings() {
    String statusFilter;

    switch (_tabController.index) {
      case 0:
        statusFilter = 'pending';
        break;
      case 1:
        statusFilter = 'confirmed';
        break;
      case 2:
        statusFilter = 'cancelled';
        break;
      case 3:
        statusFilter = 'completed';
        break;
      default:
        statusFilter = '';
    }

    return _allBookings
        .where((booking) => booking.status.toLowerCase() == statusFilter)
        .toList();
  }

  Future<void> _refreshBookings() async {
    await _loadBookings();
  }

  Future<void> _downloadBookingCard(Booking booking) async {
    try {
      // Show loading dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Mengunduh kartu booking...'),
              ],
            ),
          );
        },
      );

      // Download booking card
      final response = await http.get(
        Uri.parse('${Constants.baseUrl}/api/bookings/${booking.id}/card'),
        headers: await _bookingService.getAuthHeaders(),
      );

      // Close loading dialog
      Navigator.pop(context);

      if (response.statusCode == 200) {
        // Save PDF to temporary file
        final directory = await getTemporaryDirectory();
        final filePath = '${directory.path}/booking_card_${booking.id}.pdf';
        final file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);

        // Show success dialog with options
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Kartu Booking Berhasil Diunduh'),
              content: const Text(
                'Apa yang ingin Anda lakukan dengan kartu booking ini?',
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _openBookingCard(booking);
                  },
                  child: const Text('Lihat'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Share.shareFiles([
                      filePath,
                    ], text: 'Kartu Booking #${booking.id}');
                  },
                  child: const Text('Bagikan'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Tutup'),
                ),
              ],
            );
          },
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Gagal mengunduh kartu booking: ${response.statusCode}',
            ),
          ),
        );
      }
    } catch (e) {
      // Close loading dialog if still open
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengunduh kartu booking: $e')),
      );
    }
  }

  void _openBookingCard(Booking booking) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BookingCardScreen(booking: booking),
      ),
    ).then((_) {
      // Refresh bookings when returning from booking card screen
      _refreshBookings();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Booking'),
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: ThemeConfig.primaryColor,
          unselectedLabelColor: Colors.grey,
          indicatorColor: ThemeConfig.primaryColor,
          tabs: const [
            Tab(text: 'Menunggu'),
            Tab(text: 'Disetujui'),
            Tab(text: 'Ditolak'),
            Tab(text: 'Selesai'),
          ],
        ),
      ),
      body:
          _isLoading
              ? const LoadingIndicator()
              : _errorMessage != null
              ? ErrorState(message: _errorMessage!, onRetry: _refreshBookings)
              : RefreshIndicator(
                onRefresh: _refreshBookings,
                child: _buildBookingList(),
              ),
    );
  }

  Widget _buildBookingList() {
    final filteredBookings = _getFilteredBookings();

    if (filteredBookings.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(_getEmptyStateIcon(), size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              _getEmptyStateMessage(),
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: filteredBookings.length,
      itemBuilder: (context, index) {
        final booking = filteredBookings[index];
        return BookingCard(
          booking: booking,
          onCancel: () async {
            final confirm = await showDialog<bool>(
              context: context,
              builder:
                  (context) => AlertDialog(
                    title: const Text('Konfirmasi Pembatalan'),
                    content: const Text(
                      'Apakah Anda yakin ingin membatalkan booking ini?',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Tidak'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text('Ya'),
                      ),
                    ],
                  ),
            );

            if (confirm == true) {
              try {
                await _bookingService.cancelBooking(booking.id!);
                _refreshBookings();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Booking berhasil dibatalkan')),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Gagal membatalkan: $e')),
                );
              }
            }
          },
          onViewDetails: () {
            // Navigate to booking details
            Navigator.pushNamed(
              context,
              '/booking-details',
              arguments: booking.id,
            ).then((_) {
              // Refresh bookings when returning from details
              _refreshBookings();
            });
          },
          onDownloadCard:
              booking.status.toLowerCase() == 'completed'
                  ? () => _downloadBookingCard(booking)
                  : null,
        );
      },
    );
  }

  IconData _getEmptyStateIcon() {
    switch (_tabController.index) {
      case 0:
        return Icons.hourglass_empty;
      case 1:
        return Icons.check_circle_outline;
      case 2:
        return Icons.cancel_outlined;
      case 3:
        return Icons.done_all;
      default:
        return Icons.list_alt;
    }
  }

  String _getEmptyStateMessage() {
    switch (_tabController.index) {
      case 0:
        return 'Belum ada booking yang menunggu persetujuan';
      case 1:
        return 'Belum ada booking yang disetujui';
      case 2:
        return 'Tidak ada booking yang ditolak';
      case 3:
        return 'Belum ada booking yang selesai';
      default:
        return 'Belum ada booking';
    }
  }
}

class BookingCard extends StatelessWidget {
  final Booking booking;
  final VoidCallback onCancel;
  final VoidCallback onViewDetails;
  final VoidCallback? onDownloadCard;

  const BookingCard({
    required this.booking,
    required this.onCancel,
    required this.onViewDetails,
    this.onDownloadCard,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd MMM yyyy');
    final currencyFormat = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp',
      decimalDigits: 0,
    );

    // Status styling
    final statusInfo = _getStatusInfo(booking.status);

    // Property image URL
    final propertyImageUrl = _getPropertyImageUrl(booking.propertyImage);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onViewDetails,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Property image with status badge
            _buildPropertyImageSection(propertyImageUrl, statusInfo),

            // Booking details
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Property name
                  Text(
                    booking.propertyName ?? 'Properti #${booking.propertyId}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 12),

                  // Booking ID
                  _buildDetailRow(
                    icon: Icons.confirmation_number_outlined,
                    label: 'Booking ID',
                    value: '#${booking.id}',
                  ),

                  const SizedBox(height: 12),

                  // Date section
                  _buildDateSection(dateFormat, booking),

                  const SizedBox(height: 12),

                  // Price and special requests
                  _buildPriceAndRequestsSection(currencyFormat, booking),

                  const SizedBox(height: 16),

                  // Action buttons
                  _buildActionButtons(context, statusInfo, booking),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to get status information
  static _StatusInfo _getStatusInfo(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return _StatusInfo(Colors.green, 'Disetujui');
      case 'pending':
        return _StatusInfo(Colors.orange, 'Menunggu');
      case 'cancelled':
        return _StatusInfo(Colors.red, 'Ditolak');
      case 'completed':
        return _StatusInfo(Colors.blue, 'Selesai');
      default:
        return _StatusInfo(Colors.grey, status);
    }
  }

  // Helper method to get property image URL
  static String? _getPropertyImageUrl(String? propertyImage) {
    if (propertyImage == null) return null;
    return propertyImage.startsWith('http')
        ? propertyImage
        : '${Constants.baseUrl}/storage/$propertyImage';
  }

  // Property image section
  Widget _buildPropertyImageSection(String? imageUrl, _StatusInfo statusInfo) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
          child:
              imageUrl != null
                  ? Image.network(
                    imageUrl,
                    height: 140,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      debugPrint('Error loading image: $error');
                      return _buildPlaceholderImage();
                    },
                  )
                  : _buildPlaceholderImage(),
        ),
        Positioned(
          top: 12,
          right: 12,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: statusInfo.color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: statusInfo.color.withOpacity(0.5)),
            ),
            child: Text(
              statusInfo.text,
              style: TextStyle(
                color: statusInfo.color,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Placeholder image widget
  Widget _buildPlaceholderImage() {
    return Container(
      height: 140,
      color: Colors.grey[200],
      width: double.infinity,
      child: const Center(
        child: Icon(Icons.home, size: 40, color: Colors.grey),
      ),
    );
  }

  // Date section widget
  Widget _buildDateSection(DateFormat dateFormat, Booking booking) {
    return Row(
      children: [
        Expanded(
          child: _buildDetailRow(
            icon: Icons.calendar_today,
            label: 'Check-in',
            value: dateFormat.format(booking.checkIn),
          ),
        ),
        const SizedBox(width: 8), // Pindahkan ke sini
        Expanded(
          child: _buildDetailRow(
            icon: Icons.calendar_today,
            label: 'Check-out',
            value: dateFormat.format(booking.checkOut),
          ),
        ),
      ],
    );
  }

  // Price and special requests section
  Widget _buildPriceAndRequestsSection(
    NumberFormat currencyFormat,
    Booking booking,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDetailRow(
          icon: Icons.attach_money,
          label: 'Total',
          value: currencyFormat.format(booking.totalPrice),
        ),
        if (booking.specialRequests != null &&
            booking.specialRequests!.isNotEmpty)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              _buildDetailRow(
                icon: Icons.note,
                label: 'Permintaan Khusus',
                value: booking.specialRequests!,
                maxLines: 2,
              ),
            ],
          ),
      ],
    );
  }

  // Action buttons section
  Widget _buildActionButtons(
    BuildContext context,
    _StatusInfo statusInfo,
    Booking booking,
  ) {
    final isCompleted = statusInfo.text == 'Selesai';
    final isPendingOrConfirmed = [
      'Menunggu',
      'Disetujui',
    ].contains(statusInfo.text);

    return Row(
      children: [
        if (isPendingOrConfirmed)
          Expanded(
            child: OutlinedButton.icon(
              onPressed: onCancel,
              icon: const Icon(Icons.cancel, size: 16),
              label: const Text('Batalkan'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red,
                side: const BorderSide(color: Colors.red),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),

        if (isPendingOrConfirmed) const SizedBox(width: 8),

        // if (isCompleted && onDownloadCard != null)
        //   Expanded(
        //     child: ElevatedButton.icon(
        //       onPressed: onDownloadCard,
        //       icon: const Icon(Icons.download, size: 16),
        //       label: const Text('Kartu Booking'),
        //       style: ElevatedButton.styleFrom(
        //         backgroundColor: ThemeConfig.primaryColor,
        //         foregroundColor: Colors.white,
        //         shape: RoundedRectangleBorder(
        //           borderRadius: BorderRadius.circular(8),
        //         ),
        //         padding: const EdgeInsets.symmetric(vertical: 12),
        //       ),
        //     ),
        //   ),

        if (isCompleted && onDownloadCard != null) const SizedBox(width: 8),

        if (isCompleted)
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => ReviewBookingScreen(
                          bookingId: booking.id ?? 0,
                          propertyId: booking.propertyId,
                        ),
                  ),
                );
              },
              icon: const Icon(Icons.rate_review, size: 16),
              label: const Text('Berikan Ulasan'),
              style: ElevatedButton.styleFrom(
                backgroundColor: ThemeConfig.primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),

        if (!isCompleted || onDownloadCard == null)
          Expanded(
            child: ElevatedButton.icon(
              onPressed: onViewDetails,
              icon: const Icon(Icons.visibility, size: 16),
              label: const Text('Lihat Detail'),
              style: ElevatedButton.styleFrom(
                backgroundColor: ThemeConfig.primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
      ],
    );
  }

  // Detail row widget
  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
    int maxLines = 1,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[800],
                  fontWeight: FontWeight.w500,
                ),
                maxLines: maxLines,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// Helper class for status information
class _StatusInfo {
  final Color color;
  final String text;

  _StatusInfo(this.color, this.text);
}
