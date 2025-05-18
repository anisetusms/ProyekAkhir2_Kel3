// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:front/features/dashboard/presentation/screens/users/penyewa/service/booking_service.dart';
// import 'package:front/core/network/api_client.dart';
// import 'package:front/core/widgets/loading_indicator.dart';
// import 'package:front/core/widgets/error_state.dart';
// import 'dart:developer' as developer;

// class BookingDetailScreenSimple extends StatefulWidget {
//   final dynamic bookingId;

//   const BookingDetailScreenSimple({
//     Key? key,
//     required this.bookingId,
//   }) : super(key: key);

//   @override
//   State<BookingDetailScreenSimple> createState() => _BookingDetailScreenSimpleState();
// }

// class _BookingDetailScreenSimpleState extends State<BookingDetailScreenSimple> {
//   bool _isLoading = true;
//   String? _errorMessage;
//   Map<String, dynamic>? _rawBookingData;
//   late BookingService _bookingService;
//   int? _parsedBookingId;

//   @override
//   void initState() {
//     super.initState();
//     _bookingService = BookingService(ApiClient());
//     _parseBookingId();
//     _loadRawBookingData();
//   }

//   void _parseBookingId() {
//     // Handle different types of bookingId (from navigation arguments)
//     dynamic rawId = widget.bookingId;
    
//     developer.log('Raw booking ID: $rawId (type: ${rawId.runtimeType})', name: 'BookingDetailScreenSimple');
    
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
//         developer.log('Error parsing booking ID from string: $e', name: 'BookingDetailScreenSimple');
//         _parsedBookingId = null;
//       }
//     } else {
//       _parsedBookingId = null;
//     }
//     developer.log('Parsed booking ID: $_parsedBookingId', name: 'BookingDetailScreenSimple');
//   }

//   Future<void> _loadRawBookingData() async {
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
//       developer.log('Loading raw booking data for ID: $_parsedBookingId', name: 'BookingDetailScreenSimple');
      
//       // Gunakan ApiClient langsung untuk mendapatkan data mentah
//       final apiClient = ApiClient();
//       final response = await apiClient.get('/bookings/$_parsedBookingId');
      
//       if (response['statusCode'] != 200) {
//         throw Exception('Failed to fetch booking data: ${response['message']}');
//       }
      
//       if (response['data'] == null) {
//         throw Exception('Booking data is null');
//       }
      
//       setState(() {
//         if (response['data'] is Map) {
//           if (response['data']['data'] != null) {
//             _rawBookingData = Map<String, dynamic>.from(response['data']['data']);
//           } else {
//             _rawBookingData = Map<String, dynamic>.from(response['data']);
//           }
//         } else {
//           throw Exception('Invalid response format');
//         }
//         _isLoading = false;
//       });
      
//       developer.log('Raw booking data loaded successfully', name: 'BookingDetailScreenSimple');
//     } catch (e) {
//       developer.log('Error loading raw booking data: $e', name: 'BookingDetailScreenSimple');
//       setState(() {
//         _errorMessage = 'Gagal memuat data booking: $e';
//         _isLoading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Detail Booking ${_parsedBookingId != null ? "#$_parsedBookingId" : ""}'),
//       ),
//       body: _isLoading
//           ? const LoadingIndicator()
//           : _errorMessage != null
//               ? ErrorState(
//                   message: _errorMessage!,
//                   onRetry: _loadRawBookingData,
//                 )
//               : _rawBookingData == null
//                   ? const Center(
//                       child: Text('Data booking tidak ditemukan'),
//                     )
//                   : _buildRawBookingDetails(),
//     );
//   }

//   Widget _buildRawBookingDetails() {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Card(
//             child: Padding(
//               padding: const EdgeInsets.all(16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text(
//                     'Data Booking (Raw)',
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//                   ..._rawBookingData!.entries.map((entry) {
//                     return Padding(
//                       padding: const EdgeInsets.only(bottom: 8),
//                       child: Row(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Expanded(
//                             flex: 2,
//                             child: Text(
//                               '${entry.key}:',
//                               style: const TextStyle(
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ),
//                           Expanded(
//                             flex: 3,
//                             child: Text(
//                               _formatValue(entry.value),
//                               style: const TextStyle(
//                                 fontFamily: 'monospace',
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     );
//                   }).toList(),
//                 ],
//               ),
//             ),
//           ),
          
//           const SizedBox(height: 16),
          
//           if (_rawBookingData!.containsKey('property') && _rawBookingData!['property'] is Map) ...[
//             Card(
//               child: Padding(
//                 padding: const EdgeInsets.all(16),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Text(
//                       'Data Properti (Raw)',
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 16),
//                     ...Map<String, dynamic>.from(_rawBookingData!['property']).entries.map((entry) {
//                       return Padding(
//                         padding: const EdgeInsets.only(bottom: 8),
//                         child: Row(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Expanded(
//                               flex: 2,
//                               child: Text(
//                                 '${entry.key}:',
//                                 style: const TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                             ),
//                             Expanded(
//                               flex: 3,
//                               child: Text(
//                                 _formatValue(entry.value),
//                                 style: const TextStyle(
//                                   fontFamily: 'monospace',
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       );
//                     }).toList(),
//                   ],
//                 ),
//               ),
//             ),
//           ],
          
//           const SizedBox(height: 16),
          
//           ElevatedButton(
//             onPressed: _loadRawBookingData,
//             child: const Text('Refresh Data'),
//           ),
//         ],
//       ),
//     );
//   }

//   String _formatValue(dynamic value) {
//     if (value == null) {
//       return 'null';
//     } else if (value is Map || value is List) {
//       return json.encode(value);
//     } else {
//       return value.toString();
//     }
//   }
// }
