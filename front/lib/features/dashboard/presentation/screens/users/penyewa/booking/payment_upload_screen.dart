// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:front/features/dashboard/presentation/screens/users/penyewa/booking/booking_repository.dart';
// import 'package:image_picker/image_picker.dart';
// import 'dart:io';

// class PaymentUploadScreen extends StatefulWidget {
//   final int bookingId;

//   const PaymentUploadScreen({Key? key, required this.bookingId}) : super(key: key);

//   @override
//   _PaymentUploadScreenState createState() => _PaymentUploadScreenState();
// }

// class _PaymentUploadScreenState extends State<PaymentUploadScreen> {
//   final BookingRepository _bookingRepository = BookingRepository();
//   File? _paymentProofImage;
//   bool _isUploading = false;
//   final _formKey = GlobalKey<FormState>();
//   final _nameController = TextEditingController();
//   final _bankController = TextEditingController();
//   final _amountController = TextEditingController();
//   final _dateController = TextEditingController();
//   DateTime? _selectedDate;

//   @override
//   void initState() {
//     super.initState();
//     _selectedDate = DateTime.now();
//     _dateController.text = _formatDate(_selectedDate!);
//   }

//   @override
//   void dispose() {
//     _nameController.dispose();
//     _bankController.dispose();
//     _amountController.dispose();
//     _dateController.dispose();
//     super.dispose();
//   }

//   String _formatDate(DateTime date) {
//     return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
//   }

//   Future<void> _selectDate(BuildContext context) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: _selectedDate ?? DateTime.now(),
//       firstDate: DateTime.now().subtract(const Duration(days: 30)),
//       lastDate: DateTime.now(),
//     );
//     if (picked != null && picked != _selectedDate) {
//       setState(() {
//         _selectedDate = picked;
//         _dateController.text = _formatDate(picked);
//       });
//     }
//   }

//   Future<void> _pickPaymentProofImage() async {
//     final picker = ImagePicker();
//     final pickedFile = await picker.pickImage(
//       source: ImageSource.gallery,
//       imageQuality: 70,
//     );

//     if (pickedFile != null) {
//       setState(() {
//         _paymentProofImage = File(pickedFile.path);
//       });
      
//       // Haptic feedback when image is selected
//       HapticFeedback.mediumImpact();
//     }
//   }

//   Future<void> _uploadPaymentProof() async {
//     if (!_formKey.currentState!.validate()) {
//       return;
//     }
    
//     if (_paymentProofImage == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Harap pilih bukti pembayaran terlebih dahulu')),
//       );
//       return;
//     }

//     setState(() {
//       _isUploading = true;
//     });

//     try {
//       await _bookingRepository.uploadPaymentProof(widget.bookingId, _paymentProofImage!);
      
//       // Haptic feedback for successful upload
//       HapticFeedback.heavyImpact();
      
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Bukti pembayaran berhasil diunggah'),
//           backgroundColor: Colors.green,
//         ),
//       );
      
//       Navigator.pop(context, true);
//     } catch (e) {
//       // Haptic feedback for error
//       HapticFeedback.vibrate();
      
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Gagal mengunggah bukti pembayaran: $e'),
//           backgroundColor: Colors.red,
//         ),
//       );
//     } finally {
//       setState(() {
//         _isUploading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Upload Bukti Pembayaran'),
//         elevation: 0,
//         backgroundColor: Colors.white,
//         foregroundColor: Colors.black,
//       ),
//       body: Form(
//         key: _formKey,
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Informasi Pembayaran
//               Card(
//                 elevation: 0,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                   side: BorderSide(color: Colors.grey.shade200),
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.all(16),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         children: [
//                           Container(
//                             padding: const EdgeInsets.all(10),
//                             decoration: BoxDecoration(
//                               color: Colors.orange.withOpacity(0.1),
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                             child: const Icon(
//                               Icons.payment_outlined,
//                               color: Colors.orange,
//                             ),
//                           ),
//                           const SizedBox(width: 12),
//                           const Expanded(
//                             child: Text(
//                               'Informasi Pembayaran',
//                               style: TextStyle(
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 16),
//                       TextFormField(
//                         controller: _nameController,
//                         decoration: InputDecoration(
//                           labelText: 'Nama Pengirim',
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                           prefixIcon: const Icon(Icons.person_outline),
//                         ),
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return 'Harap masukkan nama pengirim';
//                           }
//                           return null;
//                         },
//                       ),
//                       const SizedBox(height: 16),
//                       TextFormField(
//                         controller: _bankController,
//                         decoration: InputDecoration(
//                           labelText: 'Bank Pengirim',
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                           prefixIcon: const Icon(Icons.account_balance_outlined),
//                         ),
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return 'Harap masukkan bank pengirim';
//                           }
//                           return null;
//                         },
//                       ),
//                       const SizedBox(height: 16),
//                       TextFormField(
//                         controller: _amountController,
//                         decoration: InputDecoration(
//                           labelText: 'Jumlah Transfer',
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                           prefixIcon: const Icon(Icons.attach_money_outlined),
//                           prefixText: 'Rp ',
//                         ),
//                         keyboardType: TextInputType.number,
//                         inputFormatters: [
//                           FilteringTextInputFormatter.digitsOnly,
//                         ],
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return 'Harap masukkan jumlah transfer';
//                           }
//                           return null;
//                         },
//                       ),
//                       const SizedBox(height: 16),
//                       GestureDetector(
//                         onTap: () => _selectDate(context),
//                         child: AbsorbPointer(
//                           child: TextFormField(
//                             controller: _dateController,
//                             decoration: InputDecoration(
//                               labelText: 'Tanggal Transfer',
//                               border: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(8),
//                               ),
//                               prefixIcon: const Icon(Icons.calendar_today_outlined),
//                               suffixIcon: const Icon(Icons.arrow_drop_down),
//                             ),
//                             validator: (value) {
//                               if (value == null || value.isEmpty) {
//                                 return 'Harap pilih tanggal transfer';
//                               }
//                               return null;
//                             },
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 16),
              
//               // Upload Bukti Pembayaran
//               Card(
//                 elevation: 0,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                   side: BorderSide(color: Colors.grey.shade200),
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.all(16),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         children: [
//                           Container(
//                             padding: const EdgeInsets.all(10),
//                             decoration: BoxDecoration(
//                               color: Colors.blue.withOpacity(0.1),
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                             child: const Icon(
//                               Icons.upload_file_outlined,
//                               color: Colors.blue,
//                             ),
//                           ),
//                           const SizedBox(width: 12),
//                           const Expanded(
//                             child: Text(
//                               'Upload Bukti Pembayaran',
//                               style: TextStyle(
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 16),
//                       GestureDetector(
//                         onTap: _pickPaymentProofImage,
//                         child: Container(
//                           width: double.infinity,
//                           padding: const EdgeInsets.all(16),
//                           decoration: BoxDecoration(
//                             border: Border.all(
//                               color: _paymentProofImage == null ? Colors.grey.shade300 : Colors.green,
//                             ),
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                           child: Column(
//                             children: [
//                               Icon(
//                                 _paymentProofImage == null ? Icons.upload_file : Icons.check_circle,
//                                 size: 48,
//                                 color: _paymentProofImage == null ? Colors.grey : Colors.green,
//                               ),
//                               const SizedBox(height: 8),
//                               Text(
//                                 _paymentProofImage == null 
//                                     ? 'Unggah Bukti Pembayaran (Wajib)' 
//                                     : 'Bukti pembayaran berhasil diunggah',
//                                 style: TextStyle(
//                                   color: _paymentProofImage == null ? Colors.grey : Colors.green,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                               if (_paymentProofImage == null) ...[
//                                 const SizedBox(height: 8),
//                                 Text(
//                                   'Klik untuk memilih file',
//                                   style: TextStyle(
//                                     color: Colors.grey.shade600,
//                                     fontSize: 12,
//                                   ),
//                                 ),
//                               ],
//                               if (_paymentProofImage != null) ...[
//                                 const SizedBox(height: 16),
//                                 ClipRRect(
//                                   borderRadius: BorderRadius.circular(8),
//                                   child: Image.file(
//                                     _paymentProofImage!,
//                                     height: 200,
//                                     width: double.infinity,
//                                     fit: BoxFit.cover,
//                                   ),
//                                 ),
//                                 const SizedBox(height: 8),
//                                 TextButton.icon(
//                                   onPressed: _pickPaymentProofImage,
//                                   icon: const Icon(Icons.refresh, size: 16),
//                                   label: const Text('Ganti Foto'),
//                                   style: TextButton.styleFrom(
//                                     foregroundColor: Colors.blue,
//                                   ),
//                                 ),
//                               ],
//                             ],
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 16),
//                       const Text(
//                         'Catatan:',
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 14,
//                         ),
//                       ),
//                       const SizedBox(height: 8),
//                       const Text(
//                         '• Pastikan bukti pembayaran terlihat jelas dan lengkap',
//                         style: TextStyle(fontSize: 14),
//                       ),
//                       const SizedBox(height: 4),
//                       const Text(
//                         '• Pastikan jumlah transfer sesuai dengan total pembayaran',
//                         style: TextStyle(fontSize: 14),
//                       ),
//                       const SizedBox(height: 4),
//                       const Text(
//                         '• Pembayaran akan diverifikasi dalam 1x24 jam',
//                         style: TextStyle(fontSize: 14),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 24),
              
//               // Tombol Submit
//               SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton(
//                   onPressed: _isUploading ? null : _uploadPaymentProof,
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.blue,
//                     foregroundColor: Colors.white,
//                     padding: const EdgeInsets.symmetric(vertical: 16),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                   ),
//                   child: _isUploading
//                       ? const SizedBox(
//                           height: 20,
//                           width: 20,
//                           child: CircularProgressIndicator(
//                             color: Colors.white,
//                             strokeWidth: 2,
//                           ),
//                         )
//                       : const Text('Kirim Bukti Pembayaran'),
//                 ),
//               ),
//               const SizedBox(height: 8),
//               SizedBox(
//                 width: double.infinity,
//                 child: OutlinedButton(
//                   onPressed: () {
//                     Navigator.pop(context);
//                   },
//                   style: OutlinedButton.styleFrom(
//                     padding: const EdgeInsets.symmetric(vertical: 16),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                   ),
//                   child: const Text('Batal'),
//                 ),
//               ),
//               const SizedBox(height: 24),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }