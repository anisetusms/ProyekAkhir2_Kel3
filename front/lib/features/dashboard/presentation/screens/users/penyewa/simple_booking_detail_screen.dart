// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:front/core/network/api_client.dart';
// import 'package:front/core/utils/constants.dart';
// import 'package:front/core/widgets/loading_indicator.dart';
// import 'package:front/core/widgets/error_state.dart';
// import 'dart:developer' as developer;

// class SimpleBookingDetailScreen extends StatefulWidget {
//   final dynamic bookingId;

//   const SimpleBookingDetailScreen({
//     Key? key,
//     required this.bookingId,
//   }) : super(key: key);

//   @override
//   _SimpleBookingDetailScreenState createState() => _SimpleBookingDetailScreenState();
// }

// class _SimpleBookingDetailScreenState extends State<SimpleBookingDetailScreen> {
//   bool _isLoading = true;
//   String? _errorMessage;
//   Map<String, dynamic>? _bookingData;
//   late ApiClient _apiClient;
//   int? _parsedBookingId;

//   @override
//   void initState() {
//     super.initState();
//     _apiClient = ApiClient();
//     _parseBookingId();
//     _loadBookingDetails();
//   }

//   void _parseBookingId() {
//     dynamic rawId = widget.bookingId;
    
//     developer.log('Raw booking ID: $rawId (type: ${rawId.runtimeType})', name: 'SimpleBookingDetailScreen');
    
//     if (rawId == null) {
//       _parsedBookingId = null;
//       return;
//     }
    
//     if (rawId is int) {
//       _parsedBookingId = rawId;
//     } else if (rawId is String) {
//       try {
//         _parsedBookingId = int.parse(rawId);
//       } catch (e) {
//         developer.log('Error parsing booking ID from string: $e', name: 'SimpleBookingDetailScreen');
//         _parsedBookingId = null;
//       }
//     } else {
//       _parsedBookingId = null;
//     }
    
//     developer.log('Parsed booking ID: $_parsedBookingId', name: 'SimpleBookingDetailScreen');
//   }

//   Future<void> _loadBookingDetails() async {
//     if (_parsedBookingId == null) {
//       setState(() {
//         _isLoading = false;
//         _errorMessage = 'ID Booking tidak valid';
//       });
//       return;
//     }

//     setState(() {
//       _isLoading = true;
//       _errorMessage = null;
//     });

//     try {
//       developer.log('Loading booking details for ID: $_parsedBookingId', name: 'SimpleBookingDetailScreen');
      
//       // Langsung menggunakan ApiClient untuk mendapatkan data
//       final response = await _apiClient.get('/bookings/$_parsedBookingId');
      
//       developer.log('Response status code: ${response['statusCode']}', name: 'SimpleBookingDetailScreen');
      
//       if (response['statusCode'] != 200) {
//         throw Exception('Failed to fetch booking details: ${response['data']}');
//       }

//       // Ambil data booking dari respons
//       Map<String, dynamic> bookingData;
//       if (response['data'] != null) {
//         if (response['data']['data'] != null) {
//           bookingData = Map<String, dynamic>.from(response['data']['data']);
//         } else {
//           bookingData = Map<String, dynamic>.from(response['data']);
//         }
        
//         setState(() {
//           _bookingData = bookingData;
//           _isLoading = false;
//         });
        
//         developer.log('Booking details loaded successfully', name: 'SimpleBookingDetailScreen');
//       } else {
//         throw Exception('Invalid booking data format');
//       }
//     } catch (e) {
//       developer.log('Error loading booking details: $e', name: 'SimpleBookingDetailScreen');
//       setState(() {
//         _errorMessage = 'Gagal memuat detail booking: $e';
//         _isLoading = false;
//       });
//     }
//   }

//   Future<void> _cancelBooking() async {
//     if (_bookingData == null || _bookingData!['id'] == null) return;

//     setState(() {
//       _isLoading = true;
//     });

//     try {
//       final response = await _apiClient.put('/bookings/${_bookingData!['id']}/cancel');
      
//       if (response['statusCode'] != 200) {
//         throw Exception('Failed to cancel booking: ${response['data']}');
//       }
      
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Booking berhasil dibatalkan'),
//           backgroundColor: Colors.green,
//         ),
//       );
      
//       // Refresh booking details
//       await _loadBookingDetails();
//     } catch (e) {
//       setState(() {
//         _errorMessage = 'Gagal membatalkan booking: $e';
//         _isLoading = false;
//       });
      
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Gagal membatalkan booking: $e'),
//           backgroundColor: Colors.red,
//         ),
//       );
//     }
//   }

//   void _showCancelConfirmation() {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Konfirmasi Pembatalan'),
//         content: const Text(
//           'Apakah Anda yakin ingin membatalkan booking ini? Tindakan ini tidak dapat dibatalkan.',
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('TIDAK'),
//           ),
//           TextButton(
//             onPressed: () {
//               Navigator.pop(context);
//               _cancelBooking();
//             },
//             child: const Text('YA, BATALKAN'),
//             style: TextButton.styleFrom(
//               foregroundColor: Colors.red,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Detail Booking ${_bookingData?['id'] != null ? "#${_bookingData!['id']}" : ""}'),
//         elevation: 0,
//       ),
//       body: _isLoading
//           ? const LoadingIndicator()
//           : _errorMessage != null
//               ? ErrorState(
//                   message: _errorMessage!,
//                   onRetry: _loadBookingDetails,
//                 )
//               : _bookingData == null
//                   ? const Center(
//                       child: Text('Data booking tidak ditemukan'),
//                     )
//                   : _buildBookingDetails(),
//     );
//   }

//   Widget _buildBookingDetails() {
//     final dateFormat = DateFormat('dd MMMM yyyy', 'id_ID');
//     final currencyFormat = NumberFormat.currency(
//       locale: 'id_ID',
//       symbol: 'Rp',
//       decimalDigits: 0,
//     );

//     // Parse dates
//     DateTime parseDate(String? dateStr) {
//       if (dateStr == null) return DateTime.now();
//       try {
//         return DateTime.parse(dateStr);
//       } catch (e) {
//         return DateTime.now();
//       }
//     }

//     final checkIn = parseDate(_bookingData!['check_in']);
//     final checkOut = parseDate(_bookingData!['check_out']);
//     final createdAt = parseDate(_bookingData!['created_at']);

//     // Get property data
//     final propertyData = _bookingData!['property'] as Map<String, dynamic>?;
//     final propertyName = propertyData?['name'] ?? 'Properti #${_bookingData!['property_id']}';
//     final propertyAddress = propertyData?['address'];
    
//     // Determine property image URL
//     String? propertyImageUrl;
//     if (propertyData != null && propertyData['image'] != null) {
//       final image = propertyData['image'];
//       if (image.toString().startsWith('http')) {
//         propertyImageUrl = image;
//       } else {
//         propertyImageUrl = '${Constants.baseUrl}/storage/$image';
//       }
//     }

//     // Determine property type
//     final propertyTypeId = propertyData?['property_type_id'];
//     final isKost = propertyTypeId == 1 || propertyTypeId == '1';
//     final isHomestay = propertyTypeId == 2 || propertyTypeId == '2';

//     // Determine status color and text
//     Color statusColor;
//     String statusText;
//     final status = _bookingData!['status']?.toString().toLowerCase() ?? '';
    
//     switch (status) {
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
//         statusText = _bookingData!['status'] ?? 'Tidak diketahui';
//     }

//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Status Card
//           Card(
//             elevation: 0,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(12),
//               side: BorderSide(color: Colors.grey.shade200),
//             ),
//             child: Padding(
//               padding: const EdgeInsets.all(16),
//               child: Row(
//                 children: [
//                   Container(
//                     padding: const EdgeInsets.all(12),
//                     decoration: BoxDecoration(
//                       color: statusColor.withOpacity(0.1),
//                       shape: BoxShape.circle,
//                     ),
//                     child: Icon(
//                       _getStatusIcon(status),
//                       color: statusColor,
//                     ),
//                   ),
//                   const SizedBox(width: 16),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           'Status Booking',
//                           style: TextStyle(
//                             color: Colors.grey[600],
//                             fontSize: 14,
//                           ),
//                         ),
//                         const SizedBox(height: 4),
//                         Text(
//                           statusText,
//                           style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 18,
//                             color: statusColor,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
          
//           const SizedBox(height: 16),
          
//           // Property Card
//           Card(
//             elevation: 0,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(12),
//               side: BorderSide(color: Colors.grey.shade200),
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Property Image
//                 if (propertyImageUrl != null)
//                   ClipRRect(
//                     borderRadius: const BorderRadius.vertical(
//                       top: Radius.circular(12),
//                     ),
//                     child: Image.network(
//                       propertyImageUrl,
//                       height: 180,
//                       width: double.infinity,
//                       fit: BoxFit.cover,
//                       errorBuilder: (context, error, stackTrace) {
//                         developer.log('Error loading property image: $error', name: 'SimpleBookingDetailScreen');
//                         return Container(
//                           height: 180,
//                           color: Colors.grey[200],
//                           child: const Center(
//                             child: Icon(Icons.image_not_supported, size: 40, color: Colors.grey),
//                           ),
//                         );
//                       },
//                     ),
//                   ),
                
//                 // Property Details
//                 Padding(
//                   padding: const EdgeInsets.all(16),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         propertyName,
//                         style: const TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       if (propertyAddress != null) ...[
//                         const SizedBox(height: 8),
//                         Row(
//                           children: [
//                             Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
//                             const SizedBox(width: 4),
//                             Expanded(
//                               child: Text(
//                                 propertyAddress,
//                                 style: TextStyle(
//                                   color: Colors.grey[600],
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                       const SizedBox(height: 8),
//                       Container(
//                         padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                         decoration: BoxDecoration(
//                           color: isKost ? Colors.blue[100] : Colors.amber[100],
//                           borderRadius: BorderRadius.circular(4),
//                         ),
//                         child: Text(
//                           isKost ? 'Kost' : isHomestay ? 'Homestay' : 'Properti',
//                           style: TextStyle(
//                             fontSize: 12,
//                             color: isKost ? Colors.blue[800] : Colors.amber[800],
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
          
//           const SizedBox(height: 16),
          
//           // Booking Details Card
//           Card(
//             elevation: 0,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(12),
//               side: BorderSide(color: Colors.grey.shade200),
//             ),
//             child: Padding(
//               padding: const EdgeInsets.all(16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text(
//                     'Detail Booking',
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//                   _buildDetailRow(
//                     'ID Booking',
//                     '#${_bookingData!['id']}',
//                     Icons.confirmation_number,
//                   ),
//                   const Divider(),
//                   _buildDetailRow(
//                     'Tanggal Booking',
//                     dateFormat.format(createdAt),
//                     Icons.event_note,
//                   ),
//                   const Divider(),
//                   _buildDetailRow(
//                     'Check-in',
//                     dateFormat.format(checkIn),
//                     Icons.login,
//                   ),
//                   const Divider(),
//                   _buildDetailRow(
//                     'Check-out',
//                     dateFormat.format(checkOut),
//                     Icons.logout,
//                   ),
//                   const Divider(),
//                   _buildDetailRow(
//                     'Durasi',
//                     '${checkOut.difference(checkIn).inDays} hari',
//                     Icons.timelapse,
//                   ),
//                   const Divider(),
//                   _buildDetailRow(
//                     'Total Pembayaran',
//                     currencyFormat.format(double.tryParse(_bookingData!['total_price'].toString()) ?? 0),
//                     Icons.payment,
//                     valueStyle: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 16,
//                       color: Theme.of(context).primaryColor,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
          
//           const SizedBox(height: 16),
          
//           // Guest Information Card
//           Card(
//             elevation: 0,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(12),
//               side: BorderSide(color: Colors.grey.shade200),
//             ),
//             child: Padding(
//               padding: const EdgeInsets.all(16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text(
//                     'Informasi Tamu',
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//                   _buildDetailRow(
//                     'Nama Tamu',
//                     _bookingData!['guest_name'] ?? 'Diri Sendiri',
//                     Icons.person,
//                   ),
//                   if (_bookingData!['guest_phone'] != null) ...[
//                     const Divider(),
//                     _buildDetailRow(
//                       'Telepon Tamu',
//                       _bookingData!['guest_phone'],
//                       Icons.phone,
//                     ),
//                   ],
//                   const Divider(),
//                   _buildDetailRow(
//                     'Nomor Identitas',
//                     _bookingData!['identity_number'] ?? '',
//                     Icons.credit_card,
//                   ),
//                   if (_bookingData!['special_requests'] != null && _bookingData!['special_requests'].toString().isNotEmpty) ...[
//                     const Divider(),
//                     _buildDetailRow(
//                       'Permintaan Khusus',
//                       _bookingData!['special_requests'],
//                       Icons.message,
//                       maxLines: 5,
//                     ),
//                   ],
//                 ],
//               ),
//             ),
//           ),
          
//           // Payment Information Card
//           const SizedBox(height: 16),
//           Card(
//             elevation: 0,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(12),
//               side: BorderSide(color: Colors.grey.shade200),
//             ),
//             child: Padding(
//               padding: const EdgeInsets.all(16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text(
//                     'Informasi Pembayaran',
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//                   Container(
//                     padding: const EdgeInsets.all(12),
//                     decoration: BoxDecoration(
//                       color: Colors.blue.withOpacity(0.1),
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     child: Row(
//                       children: [
//                         Icon(
//                           Icons.info_outline,
//                           color: Colors.blue[700],
//                           size: 24,
//                         ),
//                         const SizedBox(width: 12),
//                         Expanded(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 'Pembayaran di Tempat',
//                                 style: TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 16,
//                                   color: Colors.blue[700],
//                                 ),
//                               ),
//                               const SizedBox(height: 4),
//                               Text(
//                                 'Silakan lakukan pembayaran langsung di tempat saat check-in.',
//                                 style: TextStyle(
//                                   color: Colors.blue[700],
//                                   fontSize: 14,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
          
//           // Action Buttons
//           if (['pending', 'confirmed'].contains(status)) ...[
//             const SizedBox(height: 24),
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton.icon(
//                 onPressed: _showCancelConfirmation,
//                 icon: const Icon(Icons.cancel),
//                 label: const Text('Batalkan Booking'),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.red,
//                   foregroundColor: Colors.white,
//                   padding: const EdgeInsets.symmetric(vertical: 16),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                 ),
//               ),
//             ),
//           ],
          
//           const SizedBox(height: 24),
//         ],
//       ),
//     );
//   }

//   Widget _buildDetailRow(
//     String label,
//     String value,
//     IconData icon, {
//     TextStyle? valueStyle,
//     int maxLines = 1,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Icon(icon, size: 20, color: Colors.grey[600]),
//           const SizedBox(width: 12),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   label,
//                   style: TextStyle(
//                     color: Colors.grey[600],
//                     fontSize: 14,
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   value,
//                   style: valueStyle ?? const TextStyle(fontSize: 16),
//                   maxLines: maxLines,
//                   overflow: maxLines > 1 ? TextOverflow.ellipsis : null,
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   IconData _getStatusIcon(String status) {
//     switch (status.toLowerCase()) {
//       case 'pending':
//         return Icons.hourglass_empty;
//       case 'confirmed':
//         return Icons.check_circle;
//       case 'cancelled':
//         return Icons.cancel;
//       case 'completed':
//         return Icons.done_all;
//       default:
//         return Icons.info;
//     }
//   }
// }
