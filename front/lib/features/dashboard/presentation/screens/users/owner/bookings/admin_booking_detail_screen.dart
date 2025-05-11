// import 'package:flutter/material.dart';
// import 'package:front/core/widgets/error_state.dart';
// import 'package:front/core/widgets/loading_indicator.dart';
// import 'package:front/features/property/data/models/admin_booking_model.dart';
// import 'package:front/features/dashboard/presentation/screens/users/owner/repositories/admin_booking_repository.dart';
// import 'package:intl/intl.dart';
// import 'package:url_launcher/url_launcher.dart';

// class AdminBookingDetailScreen extends StatefulWidget {
//   final int bookingId;
  
//   const AdminBookingDetailScreen({
//     Key? key,
//     required this.bookingId,
//   }) : super(key: key);

//   @override
//   _AdminBookingDetailScreenState createState() => _AdminBookingDetailScreenState();
// }

// class _AdminBookingDetailScreenState extends State<AdminBookingDetailScreen> {
//   final AdminBookingRepository _bookingRepository = AdminBookingRepository();
  
//   AdminBooking? _booking;
//   bool _isLoading = true;
//   String? _errorMessage;
//   final TextEditingController _notesController = TextEditingController();
  
//   @override
//   void initState() {
//     super.initState();
//     _loadBookingDetail();
//   }
  
//   Future<void> _loadBookingDetail() async {
//     setState(() {
//       _isLoading = true;
//       _errorMessage = null;
//     });
    
//     try {
//       final booking = await _bookingRepository.getBookingDetail(widget.bookingId);
//       setState(() {
//         _booking = booking;
//         _isLoading = false;
        
//         // Pre-fill notes if available
//         if (booking.adminNotes != null) {
//           _notesController.text = booking.adminNotes!;
//         }
//       });
//     } catch (e) {
//       setState(() {
//         _isLoading = false;
//         _errorMessage = 'Gagal memuat detail booking: $e';
//       });
//     }
//   }
  
//   Future<void> _updateBookingStatus(String status) async {
//     setState(() {
//       _isLoading = true;
//     });
    
//     try {
//       final updatedBooking = await _bookingRepository.updateBookingStatus(
//         widget.bookingId,
//         status,
//         notes: _notesController.text.isNotEmpty ? _notesController.text : null,
//       );
      
//       setState(() {
//         _booking = updatedBooking;
//         _isLoading = false;
//       });
      
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Status booking berhasil diperbarui'),
//           backgroundColor: Colors.green,
//         ),
//       );
      
//       // Return true to indicate the booking was updated
//       Navigator.pop(context, true);
//     } catch (e) {
//       setState(() {
//         _isLoading = false;
//       });
      
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Gagal memperbarui status: $e'),
//           backgroundColor: Colors.red,
//         ),
//       );
//     }
//   }
  
//   void _showStatusUpdateDialog() {
//     final List<Map<String, dynamic>> availableStatuses = [];
    
//     // Determine available status transitions based on current status
//     if (_booking!.status == 'pending') {
//       availableStatuses.addAll([
//         {'status': 'confirmed', 'label': 'Konfirmasi', 'color': Colors.green},
//         {'status': 'cancelled', 'label': 'Batalkan', 'color': Colors.red},
//       ]);
//     } else if (_booking!.status == 'confirmed') {
//       availableStatuses.addAll([
//         {'status': 'completed', 'label': 'Selesaikan', 'color': Colors.blue},
//         {'status': 'cancelled', 'label': 'Batalkan', 'color': Colors.red},
//       ]);
//     }
    
//     if (availableStatuses.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Tidak ada perubahan status yang tersedia'),
//           backgroundColor: Colors.orange,
//         ),
//       );
//       return;
//     }
    
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Perbarui Status Booking'),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text('Pilih status baru:'),
//             const SizedBox(height: 16),
//             ...availableStatuses.map((status) => ElevatedButton(
//               onPressed: () {
//                 Navigator.pop(context);
//                 _showConfirmationDialog(status['status'], status['label']);
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: status['color'],
//                 foregroundColor: Colors.white,
//                 minimumSize: const Size(double.infinity, 44),
//               ),
//               child: Text(status['label']),
//             )).toList(),
//             const SizedBox(height: 16),
//             const Text('Catatan Admin (opsional):'),
//             const SizedBox(height: 8),
//             TextField(
//               controller: _notesController,
//               decoration: const InputDecoration(
//                 border: OutlineInputBorder(),
//                 hintText: 'Tambahkan catatan untuk booking ini',
//               ),
//               maxLines: 3,
//             ),
//           ],
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Batal'),
//           ),
//         ],
//       ),
//     );
//   }
  
//   void _showConfirmationDialog(String status, String label) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text('Konfirmasi $label'),
//         content: Text('Apakah Anda yakin ingin $label booking ini?'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Batal'),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               Navigator.pop(context);
//               _updateBookingStatus(status);
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: status == 'cancelled' ? Colors.red : Theme.of(context).primaryColor,
//               foregroundColor: Colors.white,
//             ),
//             child: const Text('Ya, Lanjutkan'),
//           ),
//         ],
//       ),
//     );
//   }
  
//   Future<void> _makePhoneCall(String phoneNumber) async {
//     final Uri launchUri = Uri(
//       scheme: 'tel',
//       path: phoneNumber,
//     );
//     await launchUrl(launchUri);
//   }
  
//   Future<void> _sendEmail(String email) async {
//     final Uri launchUri = Uri(
//       scheme: 'mailto',
//       path: email,
//     );
//     await launchUrl(launchUri);
//   }
  
//   Future<void> _sendWhatsApp(String phoneNumber) async {
//     // Remove any non-numeric characters
//     final cleanPhone = phoneNumber.replaceAll(RegExp(r'[^0-9]'), '');
    
//     final Uri launchUri = Uri.parse('https://wa.me/$cleanPhone');
//     await launchUrl(launchUri, mode: LaunchMode.externalApplication);
//   }
  
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Detail Pemesanan'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.refresh),
//             onPressed: _loadBookingDetail,
//             tooltip: 'Refresh',
//           ),
//         ],
//       ),
//       body: _isLoading
//           ? const LoadingIndicator()
//           : _errorMessage != null
//               ? ErrorState(
//                   message: _errorMessage!,
//                   onRetry: _loadBookingDetail,
//                 )
//               : _buildBookingDetail(),
//       bottomNavigationBar: _booking != null && (_booking!.status == 'pending' || _booking!.status == 'confirmed')
//           ? Container(
//               padding: const EdgeInsets.all(16),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.05),
//                     blurRadius: 10,
//                     offset: const Offset(0, -5),
//                   ),
//                 ],
//               ),
//               child: ElevatedButton(
//                 onPressed: _showStatusUpdateDialog,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Theme.of(context).primaryColor,
//                   foregroundColor: Colors.white,
//                   padding: const EdgeInsets.symmetric(vertical: 16),
//                 ),
//                 child: const Text(
//                   'Perbarui Status',
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//             )
//           : null,
//     );
//   }
  
//   Widget _buildBookingDetail() {
//     if (_booking == null) return const SizedBox.shrink();
    
//     final booking = _booking!;
//     final propertyName = booking.property?.name ?? 'Properti #${booking.propertyId}';
    
//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Status Card
//           Card(
//             margin: const EdgeInsets.only(bottom: 16),
//             child: Padding(
//               padding: const EdgeInsets.all(16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       const Text(
//                         'Status Pemesanan',
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 16,
//                         ),
//                       ),
//                       Container(
//                         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                         decoration: BoxDecoration(
//                           color: booking.getStatusColor().withOpacity(0.1),
//                           borderRadius: BorderRadius.circular(16),
//                         ),
//                         child: Text(
//                           booking.statusInIndonesian,
//                           style: TextStyle(
//                             color: booking.getStatusColor(),
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 8),
//                   const Divider(),
//                   const SizedBox(height: 8),
//                   Row(
//                     children: [
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             const Text(
//                               'ID Booking',
//                               style: TextStyle(
//                                 color: Colors.grey,
//                                 fontSize: 12,
//                               ),
//                             ),
//                             const SizedBox(height: 4),
//                             Text(
//                               '#${booking.id}',
//                               style: const TextStyle(
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             const Text(
//                               'Tanggal Pemesanan',
//                               style: TextStyle(
//                                 color: Colors.grey,
//                                 fontSize: 12,
//                               ),
//                             ),
//                             const SizedBox(height: 4),
//                             Text(
//                               booking.formattedCreatedAt,
//                               style: const TextStyle(
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                   if (booking.adminNotes != null && booking.adminNotes!.isNotEmpty) ...[
//                     const SizedBox(height: 16),
//                     const Divider(),
//                     const SizedBox(height: 8),
//                     const Text(
//                       'Catatan Admin',
//                       style: TextStyle(
//                         color: Colors.grey,
//                         fontSize: 12,
//                       ),
//                     ),
//                     const SizedBox(height: 4),
//                     Container(
//                       padding: const EdgeInsets.all(12),
//                       decoration: BoxDecoration(
//                         color: Colors.grey[100],
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       child: Text(booking.adminNotes!),
//                     ),
//                   ],
//                 ],
//               ),
//             ),
//           ),
          
//           // Property and Room Info
//           Card(
//             margin: const EdgeInsets.only(bottom: 16),
//             child: Padding(
//               padding: const EdgeInsets.all(16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text(
//                     'Informasi Properti',
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 16,
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//                   Row(
//                     children: [
//                       const Icon(Icons.home_outlined, color: Colors.grey),
//                       const SizedBox(width: 8),
//                       Expanded(
//                         child: Text(
//                           propertyName,
//                           style: const TextStyle(fontWeight: FontWeight.w500),
//                         ),
//                       ),
//                     ],
//                   ),
//                   if (booking.property?.address != null) ...[
//                     const SizedBox(height: 8),
//                     Row(
//                       children: [
//                         const Icon(Icons.location_on_outlined, color: Colors.grey),
//                         const SizedBox(width: 8),
//                         Expanded(
//                           child: Text(booking.property!.address!),
//                         ),
//                       ],
//                     ),
//                   ],
//                   const SizedBox(height: 16),
//                   const Divider(),
//                   const SizedBox(height: 16),
                  
//                   // Room Information
//                   if (booking.rooms != null && booking.rooms!.isNotEmpty) ...[
//                     const Text(
//                       'Kamar yang Dipesan',
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 14,
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     ...booking.rooms!.map((room) => Padding(
//                       padding: const EdgeInsets.only(bottom: 8),
//                       child: Row(
//                         children: [
//                           const Icon(Icons.meeting_room_outlined, size: 16, color: Colors.grey),
//                           const SizedBox(width: 8),
//                           Expanded(
//                             child: Text(
//                               '${room.roomType} - ${room.roomNumber}',
//                               style: const TextStyle(fontWeight: FontWeight.w500),
//                             ),
//                           ),
//                           Text(
//                             NumberFormat.currency(
//                               locale: 'id_ID',
//                               symbol: 'Rp',
//                               decimalDigits: 0,
//                             ).format(room.price),
//                           ),
//                         ],
//                       ),
//                     )).toList(),
//                   ] else ...[
//                     const Text(
//                       'Seluruh Properti',
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 14,
//                       ),
//                     ),
//                   ],
//                 ],
//               ),
//             ),
//           ),
          
//           // Booking Details
//           Card(
//             margin: const EdgeInsets.only(bottom: 16),
//             child: Padding(
//               padding: const EdgeInsets.all(16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text(
//                     'Detail Pemesanan',
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 16,
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//                   Row(
//                     children: [
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             const Text(
//                               'Check-in',
//                               style: TextStyle(
//                                 color: Colors.grey,
//                                 fontSize: 12,
//                               ),
//                             ),
//                             const SizedBox(height: 4),
//                             Text(
//                               booking.formattedCheckIn,
//                               style: const TextStyle(fontWeight: FontWeight.bold),
//                             ),
//                           ],
//                         ),
//                       ),
//                       const Icon(Icons.arrow_forward, color: Colors.grey),
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             const Text(
//                               'Check-out',
//                               style: TextStyle(
//                                 color: Colors.grey,
//                                 fontSize: 12,
//                               ),
//                             ),
//                             const SizedBox(height: 4),
//                             Text(
//                               booking.formattedCheckOut,
//                               style: const TextStyle(fontWeight: FontWeight.bold),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 16),
//                   Row(
//                     children: [
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             const Text(
//                               'Durasi',
//                               style: TextStyle(
//                                 color: Colors.grey,
//                                 fontSize: 12,
//                               ),
//                             ),
//                             const SizedBox(height: 4),
//                             Text(
//                               '${booking.durationInDays} hari',
//                               style: const TextStyle(fontWeight: FontWeight.w500),
//                             ),
//                           ],
//                         ),
//                       ),
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             const Text(
//                               'Total Harga',
//                               style: TextStyle(
//                                 color: Colors.grey,
//                                 fontSize: 12,
//                               ),
//                             ),
//                             const SizedBox(height: 4),
//                             Text(
//                               booking.formattedTotalPrice,
//                               style: TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 color: Theme.of(context).primaryColor,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                   if (booking.specialRequests != null && booking.specialRequests!.isNotEmpty) ...[
//                     const SizedBox(height: 16),
//                     const Divider(),
//                     const SizedBox(height: 8),
//                     const Text(
//                       'Permintaan Khusus',
//                       style: TextStyle(
//                         color: Colors.grey,
//                         fontSize: 12,
//                       ),
//                     ),
//                     const SizedBox(height: 4),
//                     Container(
//                       padding: const EdgeInsets.all(12),
//                       decoration: BoxDecoration(
//                         color: Colors.grey[100],
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       child: Text(booking.specialRequests!),
//                     ),
//                   ],
//                 ],
//               ),
//             ),
//           ),
          
//           // Guest Information
//           Card(
//             margin: const EdgeInsets.only(bottom: 16),
//             child: Padding(
//               padding: const EdgeInsets.all(16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       const Text(
//                         'Informasi Tamu',
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 16,
//                         ),
//                       ),
//                       if (booking.isForOthers)
//                         Container(
//                           padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                           decoration: BoxDecoration(
//                             color: Colors.blue[50],
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           child: Text(
//                             'Untuk Orang Lain',
//                             style: TextStyle(
//                               color: Colors.blue[700],
//                               fontSize: 12,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ),
//                     ],
//                   ),
//                   const SizedBox(height: 16),
//                   Row(
//                     children: [
//                       const Icon(Icons.person_outline, color: Colors.grey),
//                       const SizedBox(width: 8),
//                       Expanded(
//                         child: Text(
//                           booking.guestName ?? 'Tidak ada nama',
//                           style: const TextStyle(fontWeight: FontWeight.w500),
//                         ),
//                       ),
//                     ],
//                   ),
//                   if (booking.guestPhone != null) ...[
//                     const SizedBox(height: 8),
//                     Row(
//                       children: [
//                         const Icon(Icons.phone_outlined, color: Colors.grey),
//                         const SizedBox(width: 8),
//                         Text(booking.guestPhone!),
//                         const Spacer(),
//                         Row(
//                           children: [
//                             IconButton(
//                               icon: const Icon(Icons.phone, color: Colors.green),
//                               onPressed: () => _makePhoneCall(booking.guestPhone!),
//                               tooltip: 'Telepon',
//                               constraints: const BoxConstraints(),
//                               padding: const EdgeInsets.all(8),
//                             ),
//                             IconButton(
//                               icon: const Icon(Icons.message, color: Colors.blue),
//                               onPressed: () => _sendWhatsApp(booking.guestPhone!),
//                               tooltip: 'WhatsApp',
//                               constraints: const BoxConstraints(),
//                               padding: const EdgeInsets.all(8),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ],
//                   if (booking.identityNumber != null) ...[
//                     const SizedBox(height: 8),
//                     Row(
//                       children: [
//                         const Icon(Icons.credit_card_outlined, color: Colors.grey),
//                         const SizedBox(width: 8),
//                         Text('KTP: ${booking.identityNumber!}'),
//                       ],
//                     ),
//                   ],
//                   if (booking.ktpImage != null) ...[
//                     const SizedBox(height: 16),
//                     const Text(
//                       'Foto KTP',
//                       style: TextStyle(
//                         color: Colors.grey,
//                         fontSize: 12,
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     ClipRRect(
//                       borderRadius: BorderRadius.circular(8),
//                       child: Image.network(
//                         'https://yourdomain.com/storage/${booking.ktpImage}',
//                         height: 120,
//                         width: double.infinity,
//                         fit: BoxFit.cover,
//                         errorBuilder: (context, error, stackTrace) => Container(
//                           height: 120,
//                           width: double.infinity,
//                           color: Colors.grey[200],
//                           child: const Center(
//                             child: Text('Tidak dapat memuat gambar'),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                   const SizedBox(height: 16),
//                   const Divider(),
//                   const SizedBox(height: 8),
//                   const Text(
//                     'Informasi Pemesan',
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 14,
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   if (booking.user != null) ...[
//                     Row(
//                       children: [
//                         const Icon(Icons.person_outline, color: Colors.grey),
//                         const SizedBox(width: 8),
//                         Text(booking.user!.name),
//                       ],
//                     ),
//                     const SizedBox(height: 8),
//                     Row(
//                       children: [
//                         const Icon(Icons.email_outlined, color: Colors.grey),
//                         const SizedBox(width: 8),
//                         Text(booking.user!.email),
//                         const Spacer(),
//                         IconButton(
//                           icon: const Icon(Icons.email, color: Colors.red),
//                           onPressed: () => _sendEmail(booking.user!.email),
//                           tooltip: 'Kirim Email',
//                           constraints: const BoxConstraints(),
//                           padding: const EdgeInsets.all(8),
//                         ),
//                       ],
//                     ),
//                     if (booking.user!.phone != null) ...[
//                       const SizedBox(height: 8),
//                       Row(
//                         children: [
//                           const Icon(Icons.phone_outlined, color: Colors.grey),
//                           const SizedBox(width: 8),
//                           Text(booking.user!.phone!),
//                           const Spacer(),
//                           Row(
//                             children: [
//                               IconButton(
//                                 icon: const Icon(Icons.phone, color: Colors.green),
//                                 onPressed: () => _makePhoneCall(booking.user!.phone!),
//                                 tooltip: 'Telepon',
//                                 constraints: const BoxConstraints(),
//                                 padding: const EdgeInsets.all(8),
//                               ),
//                               IconButton(
//                                 icon: const Icon(Icons.message, color: Colors.blue),
//                                 onPressed: () => _sendWhatsApp(booking.user!.phone!),
//                                 tooltip: 'WhatsApp',
//                                 constraints: const BoxConstraints(),
//                                 padding: const EdgeInsets.all(8),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ],
//                   ],
//                 ],
//               ),
//             ),
//           ),
          
//           // Payment Information
//           Card(
//             margin: const EdgeInsets.only(bottom: 16),
//             child: Padding(
//               padding: const EdgeInsets.all(16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text(
//                     'Informasi Pembayaran',
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 16,
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//                   Row(
//                     children: [
//                                             const Icon(Icons.payment_outlined, color: Colors.grey),
//                       const SizedBox(width: 8),
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             const Text(
//                               'Metode Pembayaran',
//                               style: TextStyle(
//                                 color: Colors.grey,
//                                 fontSize: 12,
//                               ),
//                             ),
//                             const SizedBox(height: 4),
//                             Text(
//                               booking.paymentMethod ?? 'Tidak diketahui',
//                               style: const TextStyle(fontWeight: FontWeight.w500),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 16),
//                   Row(
//                     children: [
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             const Text(
//                               'Status Pembayaran',
//                               style: TextStyle(
//                                 color: Colors.grey,
//                                 fontSize: 12,
//                               ),
//                             ),
//                             const SizedBox(height: 4),
//                             Container(
//                               padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                               decoration: BoxDecoration(
//                                 color: booking.paymentStatus == 'paid' 
//                                     ? Colors.green.withOpacity(0.1)
//                                     : Colors.orange.withOpacity(0.1),
//                                 borderRadius: BorderRadius.circular(16),
//                               ),
//                               child: Text(
//                                 booking.paymentStatus == 'paid' ? 'Lunas' : 'Belum Lunas',
//                                 style: TextStyle(
//                                   color: booking.paymentStatus == 'paid' 
//                                       ? Colors.green
//                                       : Colors.orange,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       if (booking.paymentDate != null) ...[
//                         Expanded(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               const Text(
//                                 'Tanggal Pembayaran',
//                                 style: TextStyle(
//                                   color: Colors.grey,
//                                   fontSize: 12,
//                                 ),
//                               ),
//                               const SizedBox(height: 4),
//                               Text(
//                                 DateFormat('dd MMMM yyyy, HH:mm').format(booking.paymentDate!),
//                                 style: const TextStyle(fontWeight: FontWeight.w500),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ],
//                   ),
//                   if (booking.paymentProof != null) ...[
//                     const SizedBox(height: 16),
//                     const Divider(),
//                     const SizedBox(height: 8),
//                     const Text(
//                       'Bukti Pembayaran',
//                       style: TextStyle(
//                         color: Colors.grey,
//                         fontSize: 12,
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     GestureDetector(
//                       onTap: () {
//                         // Show full screen image
//                         showDialog(
//                           context: context,
//                           builder: (context) => Dialog(
//                             child: PhotoView(
//                               imageProvider: NetworkImage(
//                                 'https://yourdomain.com/storage/${booking.paymentProof}',
//                               ),
//                             ),
//                           ),
//                         );
//                       },
//                       child: ClipRRect(
//                         borderRadius: BorderRadius.circular(8),
//                         child: Image.network(
//                           'https://yourdomain.com/storage/${booking.paymentProof}',
//                           height: 200,
//                           width: double.infinity,
//                           fit: BoxFit.cover,
//                           errorBuilder: (context, error, stackTrace) => Container(
//                             height: 200,
//                             width: double.infinity,
//                             color: Colors.grey[200],
//                             child: const Center(
//                               child: Text('Tidak dapat memuat bukti pembayaran'),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _notesController.dispose();
//     super.dispose();
//   }
// }
