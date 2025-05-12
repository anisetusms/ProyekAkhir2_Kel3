import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:front/features/dashboard/presentation/screens/users/penyewa/models/booking_model.dart';
import 'package:front/features/dashboard/presentation/screens/users/penyewa/service/booking_service.dart';
import 'package:front/core/network/api_client.dart';
import 'package:front/core/utils/constants.dart';
import 'package:front/core/widgets/loading_indicator.dart';
import 'package:front/core/widgets/error_state.dart';
import 'package:front/features/dashboard/presentation/screens/users/penyewa/booking_card_screen.dart';
import 'dart:developer' as developer;
import 'package:get/get.dart';

class BookingDetailScreen extends StatefulWidget {
  final dynamic bookingId;

  const BookingDetailScreen({
    Key? key,
    this.bookingId,
  }) : super(key: key);

  @override
  _BookingDetailScreenState createState() => _BookingDetailScreenState();
}

class _BookingDetailScreenState extends State<BookingDetailScreen> {
  bool _isLoading = true;
  String? _errorMessage;
  Booking? _booking;
  late BookingService _bookingService;
  late int? _parsedBookingId;

  @override
  void initState() {
    super.initState();
    _bookingService = BookingService(ApiClient());
    _parseBookingId();
    _loadBookingDetails();
  }

  void _parseBookingId() {
    // Handle different types of bookingId (from Get.arguments or widget.bookingId)
    dynamic rawId = widget.bookingId ?? Get.arguments;
    
    if (rawId == null) {
      _parsedBookingId = null;
      return;
    }
    
    if (rawId is int) {
      _parsedBookingId = rawId;
    } else if (rawId is String) {
      _parsedBookingId = int.tryParse(rawId);
    } else {
      _parsedBookingId = null;
    }
    
    developer.log('Parsed booking ID: $_parsedBookingId from raw: $rawId', name: 'BookingDetailScreen');
  }

  Future<void> _loadBookingDetails() async {
    if (_parsedBookingId == null) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'ID Booking tidak valid';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      developer.log('Loading booking details for ID: $_parsedBookingId', name: 'BookingDetailScreen');
      final booking = await _bookingService.getBookingDetail(_parsedBookingId!);
      
      setState(() {
        _booking = booking;
        _isLoading = false;
      });
      
      developer.log('Booking details loaded successfully', name: 'BookingDetailScreen');
    } catch (e) {
      developer.log('Error loading booking details: $e', name: 'BookingDetailScreen');
      setState(() {
        _errorMessage = 'Gagal memuat detail booking: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _cancelBooking() async {
    if (_booking?.id == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      await _bookingService.cancelBooking(_booking!.id!);
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Booking berhasil dibatalkan'),
          backgroundColor: Colors.green,
        ),
      );
      
      // Refresh booking details
      await _loadBookingDetails();
    } catch (e) {
      setState(() {
        _errorMessage = 'Gagal membatalkan booking: $e';
        _isLoading = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal membatalkan booking: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showCancelConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi Pembatalan'),
        content: const Text(
          'Apakah Anda yakin ingin membatalkan booking ini? Tindakan ini tidak dapat dibatalkan.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('TIDAK'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _cancelBooking();
            },
            child: const Text('YA, BATALKAN'),
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
          ),
        ],
      ),
    );
  }

  void _openBookingCard() {
    if (_booking == null) return;
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BookingCardScreen(booking: _booking!),
      ),
    ).then((_) {
      // Refresh booking details when returning from booking card
      _loadBookingDetails();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Booking ${_booking?.id != null ? "#${_booking!.id}" : ""}'),
        elevation: 0,
        actions: [
          if (_booking?.status.toLowerCase() == 'completed')
            IconButton(
              icon: const Icon(Icons.download),
              onPressed: _openBookingCard,
              tooltip: 'Unduh Kartu Booking',
            ),
        ],
      ),
      body: _isLoading
          ? const LoadingIndicator()
          : _errorMessage != null
              ? ErrorState(
                  message: _errorMessage!,
                  onRetry: _loadBookingDetails,
                )
              : _booking == null
                  ? const Center(
                      child: Text('Data booking tidak ditemukan'),
                    )
                  : _buildBookingDetails(),
    );
  }

  Widget _buildBookingDetails() {
    final dateFormat = DateFormat('dd MMMM yyyy', 'id_ID');
    final currencyFormat = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp',
      decimalDigits: 0,
    );

    // Determine property image URL
    String? propertyImageUrl;
    if (_booking?.propertyImage != null) {
      if (_booking!.propertyImage!.startsWith('http')) {
        propertyImageUrl = _booking!.propertyImage;
      } else {
        propertyImageUrl = '${Constants.baseUrl}/storage/${_booking!.propertyImage}';
      }
    }

    // Determine status color and text
    Color statusColor;
    String statusText;
    
    switch (_booking!.status.toLowerCase()) {
      case 'confirmed':
        statusColor = Colors.green;
        statusText = 'Disetujui';
        break;
      case 'pending':
        statusColor = Colors.orange;
        statusText = 'Menunggu';
        break;
      case 'cancelled':
        statusColor = Colors.red;
        statusText = 'Ditolak';
        break;
      case 'completed':
        statusColor = Colors.blue;
        statusText = 'Selesai';
        break;
      default:
        statusColor = Colors.grey;
        statusText = _booking!.status;
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Status Card
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.grey.shade200),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _getStatusIcon(_booking!.status),
                      color: statusColor,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Status Booking',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          statusText,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: statusColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (_booking!.status.toLowerCase() == 'completed')
                    ElevatedButton.icon(
                      onPressed: _openBookingCard,
                      icon: const Icon(Icons.download, size: 16),
                      label: const Text('Kartu Booking'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Property Card
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.grey.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Property Image
                if (propertyImageUrl != null)
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(12),
                    ),
                    child: Image.network(
                      propertyImageUrl,
                      height: 180,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        developer.log('Error loading property image: $error', name: 'BookingDetailScreen');
                        return Container(
                          height: 180,
                          color: Colors.grey[200],
                          child: const Center(
                            child: Icon(Icons.image_not_supported, size: 40, color: Colors.grey),
                          ),
                        );
                      },
                    ),
                  ),
                
                // Property Details
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _booking!.propertyName ?? 'Properti #${_booking!.propertyId}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (_booking!.propertyAddress != null) ...[
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                _booking!.propertyAddress!,
                                style: TextStyle(
                                  color: Colors.grey[600],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: _booking!.isKost ? Colors.blue[100] : Colors.amber[100],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          _booking!.isKost ? 'Kost' : _booking!.isHomestay ? 'Homestay' : 'Properti',
                          style: TextStyle(
                            fontSize: 12,
                            color: _booking!.isKost ? Colors.blue[800] : Colors.amber[800],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Booking Details Card
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
                    'Detail Booking',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildDetailRow(
                    'ID Booking',
                    '#${_booking!.id}',
                    Icons.confirmation_number,
                  ),
                  const Divider(),
                  _buildDetailRow(
                    'Tanggal Booking',
                    dateFormat.format(_booking!.createdAt),
                    Icons.event_note,
                  ),
                  const Divider(),
                  _buildDetailRow(
                    'Check-in',
                    dateFormat.format(_booking!.checkIn),
                    Icons.login,
                  ),
                  const Divider(),
                  _buildDetailRow(
                    'Check-out',
                    dateFormat.format(_booking!.checkOut),
                    Icons.logout,
                  ),
                  const Divider(),
                  _buildDetailRow(
                    'Durasi',
                    '${_booking!.checkOut.difference(_booking!.checkIn).inDays} hari',
                    Icons.timelapse,
                  ),
                  const Divider(),
                  _buildDetailRow(
                    'Total Pembayaran',
                    currencyFormat.format(_booking!.totalPrice),
                    Icons.payment,
                    valueStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Guest Information Card
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
                    'Informasi Tamu',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildDetailRow(
                    'Nama Tamu',
                    _booking!.guestName ?? 'Diri Sendiri',
                    Icons.person,
                  ),
                  if (_booking!.guestPhone != null) ...[
                    const Divider(),
                    _buildDetailRow(
                      'Telepon Tamu',
                      _booking!.guestPhone!,
                      Icons.phone,
                    ),
                  ],
                  const Divider(),
                  _buildDetailRow(
                    'Nomor Identitas',
                    _booking!.identityNumber,
                    Icons.credit_card,
                  ),
                  if (_booking!.specialRequests != null && _booking!.specialRequests!.isNotEmpty) ...[
                    const Divider(),
                    _buildDetailRow(
                      'Permintaan Khusus',
                      _booking!.specialRequests!,
                      Icons.message,
                      maxLines: 5,
                    ),
                  ],
                ],
              ),
            ),
          ),
          
          // Room Details Card (if available)
          if (_booking!.bookingRooms != null && _booking!.bookingRooms!.isNotEmpty) ...[
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
                      'Detail Kamar',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ..._booking!.bookingRooms!.map((room) {
                      final roomName = room.room != null && room.room!.containsKey('name')
                          ? room.room!['name']
                          : 'Kamar #${room.roomId}';
                      
                      return Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    const Icon(Icons.meeting_room, size: 16, color: Colors.grey),
                                    const SizedBox(width: 8),
                                    Expanded(child: Text(roomName)),
                                  ],
                                ),
                              ),
                              Text(
                                currencyFormat.format(room.price),
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          if (_booking!.bookingRooms!.last != room)
                            const Divider(),
                        ],
                      );
                    }).toList(),
                  ],
                ),
              ),
            ),
          ],
          
          // Action Buttons
          if (['pending', 'confirmed'].contains(_booking!.status.toLowerCase())) ...[
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _showCancelConfirmation,
                icon: const Icon(Icons.cancel),
                label: const Text('Batalkan Booking'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
          
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildDetailRow(
    String label,
    String value,
    IconData icon, {
    TextStyle? valueStyle,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: valueStyle ?? const TextStyle(fontSize: 16),
                  maxLines: maxLines,
                  overflow: maxLines > 1 ? TextOverflow.ellipsis : null,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Icons.hourglass_empty;
      case 'confirmed':
        return Icons.check_circle;
      case 'cancelled':
        return Icons.cancel;
      case 'completed':
        return Icons.done_all;
      default:
        return Icons.info;
    }
  }
}
