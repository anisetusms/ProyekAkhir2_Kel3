import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart'; // Import ini diperlukan untuk inisialisasi locale
import 'package:front/features/dashboard/presentation/screens/users/penyewa/models/booking_model.dart';
import 'package:front/features/dashboard/presentation/screens/users/penyewa/service/new_booking_service.dart';
import 'package:front/core/network/api_client.dart';
import 'package:front/core/utils/constants.dart';
import 'package:front/core/widgets/loading_indicator.dart';
import 'package:front/core/widgets/error_state.dart';
import 'package:front/features/dashboard/presentation/screens/users/penyewa/booking_card_screen.dart';
import 'dart:developer' as developer;

class BookingDetailScreen extends StatefulWidget {
  final dynamic bookingId;

  const BookingDetailScreen({
    Key? key,
    required this.bookingId,
  }) : super(key: key);

  @override
  State<BookingDetailScreen> createState() => _BookingDetailScreenState();
}

class _BookingDetailScreenState extends State<BookingDetailScreen> {
  bool _isLoading = true;
  String? _errorMessage;
  dynamic _bookingData;
  Booking? _booking;
  late BookingService _bookingService;
  late ApiClient _apiClient;
  int? _parsedBookingId;
  bool _localeInitialized = false;

  @override
  void initState() {
    super.initState();
    _apiClient = ApiClient();
    _bookingService = BookingService(ApiClient());
    _parseBookingId();
    _initializeLocale();
  }

  // Inisialisasi locale untuk format tanggal
  Future<void> _initializeLocale() async {
    try {
      await initializeDateFormatting('id_ID', null);
      setState(() {
        _localeInitialized = true;
      });
      _loadBookingDetails();
    } catch (e) {
      developer.log('Error initializing locale: $e', name: 'BookingDetailScreen');
      // Fallback ke locale default jika gagal
      setState(() {
        _localeInitialized = true;
      });
      _loadBookingDetails();
    }
  }

  void _parseBookingId() {
    // Handle different types of bookingId (from navigation arguments)
    dynamic rawId = widget.bookingId;
    
    developer.log('Raw booking ID: $rawId (type: ${rawId.runtimeType})', name: 'BookingDetailScreen');
    
    if (rawId == null) {
      _parsedBookingId = null;
      return;
    }
    
    if (rawId is int) {
      _parsedBookingId = rawId;
    } else if (rawId is String) {
      try {
        _parsedBookingId = int.parse(rawId);
      } catch (e) {
        developer.log('Error parsing booking ID from string: $e', name: 'BookingDetailScreen');
        _parsedBookingId = null;
      }
    } else {
      _parsedBookingId = null;
    }
    developer.log('Parsed booking ID: $_parsedBookingId', name: 'BookingDetailScreen');
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
      
      // Coba menggunakan endpoint API langsung terlebih dahulu
      final response = await _apiClient.get('/bookings/$_parsedBookingId');
      
      developer.log('API Response: $response', name: 'BookingDetailScreen');
      
      if (response == null) {
        throw Exception('Tidak ada respons dari server');
      }
      
      // Periksa struktur respons
      if (response is Map<String, dynamic> && 
          response.containsKey('status') && 
          response['status'] == 'success' &&
          response.containsKey('data')) {
        
        _bookingData = response['data'];
        developer.log('Booking data from API: $_bookingData', name: 'BookingDetailScreen');
        
        // Coba parse ke model Booking
        try {
          _booking = await _bookingService.getBookingDetail(_parsedBookingId!);
          developer.log('Booking parsed to model: ${_booking?.id}', name: 'BookingDetailScreen');
        } catch (modelError) {
          developer.log('Error parsing to model: $modelError, will use raw data', name: 'BookingDetailScreen');
          // Tetap gunakan data mentah jika parsing ke model gagal
        }
        
        setState(() {
          _isLoading = false;
        });
      } else {
        throw Exception('Format respons tidak valid atau data tidak ditemukan');
      }
    } catch (e) {
      developer.log('Error loading booking details: $e', name: 'BookingDetailScreen');
      
      // Coba fallback ke BookingService jika API langsung gagal
      try {
        developer.log('Trying fallback to BookingService', name: 'BookingDetailScreen');
        final booking = await _bookingService.getBookingDetail(_parsedBookingId!);
        
        if (mounted) {
          setState(() {
            _booking = booking;
            _isLoading = false;
          });
          
          developer.log('Booking details loaded via BookingService: ${booking.id}', name: 'BookingDetailScreen');
        }
      } catch (serviceError) {
        developer.log('BookingService also failed: $serviceError', name: 'BookingDetailScreen');
        if (mounted) {
          setState(() {
            _errorMessage = 'Gagal memuat detail booking: $e';
            _isLoading = false;
          });
        }
      }
    }
  }

  Future<void> _cancelBooking() async {
    if (_parsedBookingId == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      await _bookingService.cancelBooking(_parsedBookingId!);
      
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

  void _debugPrintBookingData() {
    if (_booking != null) {
      developer.log('Booking ID: ${_booking!.id}', name: 'BookingDetailScreen');
      developer.log('Property ID: ${_booking!.propertyId}', name: 'BookingDetailScreen');
      developer.log('Status: ${_booking!.status}', name: 'BookingDetailScreen');
      developer.log('Check-in: ${_booking!.checkIn}', name: 'BookingDetailScreen');
      developer.log('Check-out: ${_booking!.checkOut}', name: 'BookingDetailScreen');
      developer.log('Total Price: ${_booking!.totalPrice}', name: 'BookingDetailScreen');
      developer.log('Guest Name: ${_booking!.guestName}', name: 'BookingDetailScreen');
      developer.log('Property Name: ${_booking!.propertyName}', name: 'BookingDetailScreen');
    } else if (_bookingData != null) {
      developer.log('Raw Booking Data: $_bookingData', name: 'BookingDetailScreen');
    } else {
      developer.log('No booking data available', name: 'BookingDetailScreen');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Debug print booking data jika tersedia
    _debugPrintBookingData();
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Booking ${_booking?.id != null ? "#${_booking!.id}" : _bookingData != null ? "#${_bookingData['id']}" : ""}'),
        elevation: 0,
        actions: [
          if ((_booking?.status.toLowerCase() == 'completed') || 
              (_bookingData != null && _bookingData['status'].toString().toLowerCase() == 'completed'))
            IconButton(
              icon: const Icon(Icons.download),
              onPressed: _openBookingCard,
              tooltip: 'Unduh Kartu Booking',
            ),
        ],
      ),
      body: !_localeInitialized
          ? const Center(child: CircularProgressIndicator())
          : _isLoading
              ? const LoadingIndicator()
              : _errorMessage != null
                  ? ErrorState(
                      message: _errorMessage!,
                      onRetry: _loadBookingDetails,
                    )
                  : _booking != null
                      ? _buildBookingDetailsFromModel()
                      : _bookingData != null
                          ? _buildBookingDetailsFromRawData()
                          : const Center(
                              child: Text('Data booking tidak ditemukan'),
                            ),
    );
  }

  Widget _buildBookingDetailsFromModel() {
    // Implementasi yang sudah ada untuk model Booking
    // Gunakan locale default jika id_ID tidak tersedia
    final dateFormat = DateFormat('dd MMMM yyyy');
    final currencyFormat = NumberFormat.currency(
      locale: 'id',
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
                        backgroundColor: Color(0xFF4CAF50),
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
                      color: Color(0xFF4CAF50),
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
                  if (_booking!.ktpImage != null) ...[
                    const Divider(),
                    const SizedBox(height: 8),
                    const Text(
                      'Foto KTP',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildKtpImage(),
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
          
          // Payment Information Card
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
                    'Informasi Pembayaran',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: Colors.blue[700],
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Pembayaran di Tempat',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.blue[700],
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Silakan lakukan pembayaran langsung di tempat saat check-in.',
                                style: TextStyle(
                                  color: Colors.blue[700],
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          
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

  Widget _buildBookingDetailsFromRawData() {
    // Implementasi untuk data mentah (Map)
    // Gunakan locale default jika id_ID tidak tersedia
    final dateFormat = DateFormat('dd MMMM yyyy');
    final currencyFormat = NumberFormat.currency(
      locale: 'id',
      symbol: 'Rp',
      decimalDigits: 0,
    );

    // Determine property image URL
    String? propertyImageUrl;
    if (_bookingData['property'] != null && _bookingData['property']['image'] != null) {
      final image = _bookingData['property']['image'].toString();
      if (image.startsWith('http')) {
        propertyImageUrl = image;
      } else {
        propertyImageUrl = '${Constants.baseUrl}/storage/$image';
      }
    }

    // Determine status color and text
    Color statusColor;
    String statusText;
    
    switch (_bookingData['status'].toString().toLowerCase()) {
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
        statusText = _bookingData['status'].toString();
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
                      _getStatusIcon(_bookingData['status'].toString()),
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
                  if (_bookingData['status'].toString().toLowerCase() == 'completed')
                    ElevatedButton.icon(
                      onPressed: _openBookingCard,
                      icon: const Icon(Icons.download, size: 16),
                      label: const Text('Kartu Booking'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF4CAF50),
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
                        _bookingData['property'] != null && _bookingData['property']['name'] != null
                            ? _bookingData['property']['name']
                            : 'Properti #${_bookingData['property_id']}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (_bookingData['property'] != null && _bookingData['property']['address'] != null) ...[
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                _bookingData['property']['address'],
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
                          color: _isKost() ? Colors.blue[100] : Colors.amber[100],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          _isKost() ? 'Kost' : _isHomestay() ? 'Homestay' : 'Properti',
                          style: TextStyle(
                            fontSize: 12,
                            color: _isKost() ? Colors.blue[800] : Colors.amber[800],
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
                    '#${_bookingData['id']}',
                    Icons.confirmation_number,
                  ),
                  const Divider(),
                  _buildDetailRow(
                    'Tanggal Booking',
                    dateFormat.format(DateTime.parse(_bookingData['created_at'])),
                    Icons.event_note,
                  ),
                  const Divider(),
                  _buildDetailRow(
                    'Check-in',
                    dateFormat.format(DateTime.parse(_bookingData['check_in'])),
                    Icons.login,
                  ),
                  const Divider(),
                  _buildDetailRow(
                    'Check-out',
                    dateFormat.format(DateTime.parse(_bookingData['check_out'])),
                    Icons.logout,
                  ),
                  const Divider(),
                  _buildDetailRow(
                    'Durasi',
                    '${DateTime.parse(_bookingData['check_out']).difference(DateTime.parse(_bookingData['check_in'])).inDays} hari',
                    Icons.timelapse,
                  ),
                  const Divider(),
                  _buildDetailRow(
                    'Total Pembayaran',
                    currencyFormat.format(double.parse(_bookingData['total_price'].toString())),
                    Icons.payment,
                    valueStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Color(0xFF4CAF50),
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
                    _bookingData['guest_name'] ?? 'Diri Sendiri',
                    Icons.person,
                  ),
                  if (_bookingData['guest_phone'] != null) ...[
                    const Divider(),
                    _buildDetailRow(
                      'Telepon Tamu',
                      _bookingData['guest_phone'],
                      Icons.phone,
                    ),
                  ],
                  const Divider(),
                  _buildDetailRow(
                    'Nomor Identitas',
                    _bookingData['identity_number'] ?? '',
                    Icons.credit_card,
                  ),
                  if (_bookingData['special_requests'] != null && _bookingData['special_requests'].toString().isNotEmpty) ...[
                    const Divider(),
                    _buildDetailRow(
                      'Permintaan Khusus',
                      _bookingData['special_requests'],
                      Icons.message,
                      maxLines: 5,
                    ),
                  ],
                  if (_bookingData['ktp_image'] != null) ...[
                    const Divider(),
                    const SizedBox(height: 8),
                    const Text(
                      'Foto KTP',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildKtpImageFromRawData(),
                  ],
                ],
              ),
            ),
          ),
          
          // Room Details Card (if available)
          if (_bookingData.containsKey('rooms') && _bookingData['rooms'] is List && (_bookingData['rooms'] as List).isNotEmpty) ...[
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
                    ...(_bookingData['rooms'] as List).map((room) {
                      final roomName = room.containsKey('room') && room['room'] != null && room['room'].containsKey('room_number')
                          ? room['room']['room_number']
                          : 'Kamar #${room['room_id']}';
                      
                      final roomPrice = room.containsKey('price') ? double.parse(room['price'].toString()) : 0.0;
                      
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
                                currencyFormat.format(roomPrice),
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          if ((_bookingData['rooms'] as List).last != room)
                            const Divider(),
                        ],
                      );
                    }).toList(),
                  ],
                ),
              ),
            ),
          ],
          
          // Payment Information Card
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
                    'Informasi Pembayaran',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: Colors.blue[700],
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Pembayaran di Tempat',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.blue[700],
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Silakan lakukan pembayaran langsung di tempat saat check-in.',
                                style: TextStyle(
                                  color: Colors.blue[700],
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Action Buttons
          if (['pending', 'confirmed'].contains(_bookingData['status'].toString().toLowerCase())) ...[
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

  Widget _buildKtpImage() {
    if (_booking?.ktpImage == null) {
      return const SizedBox.shrink();
    }

    // Try different URL formats for KTP image
    List<String> possibleUrls = [
      '${Constants.baseUrl}/storage/${_booking!.ktpImage}',
      '${Constants.baseUrl}/api/storage/${_booking!.ktpImage}',
      _booking!.ktpImage!.startsWith('http') ? _booking!.ktpImage! : '${Constants.baseUrl}/storage/${_booking!.ktpImage}'
    ];

    return GestureDetector(
      onTap: () {
        // Show full screen image
        showDialog(
          context: context,
          builder: (context) => Dialog(
            insetPadding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppBar(
                  title: const Text('Foto KTP'),
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  leading: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                Flexible(
                  child: InteractiveViewer(
                    minScale: 0.5,
                    maxScale: 3.0,
                    child: Image.network(
                      possibleUrls[0],
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        // Try alternative URL if first one fails
                        return Image.network(
                          possibleUrls[1],
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            // Try third URL if second one fails
                            return Image.network(
                              possibleUrls[2],
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) {
                                return const Center(
                                  child: Text('Gagal memuat gambar KTP'),
                                );
                              },
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      child: Container(
        height: 150,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            possibleUrls[0],
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              // Try alternative URL if first one fails
              return Image.network(
                possibleUrls[1],
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  // Try third URL if second one fails
                  return Image.network(
                    possibleUrls[2],
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.image_not_supported, size: 40, color: Colors.grey),
                            SizedBox(height: 8),
                            Text('Gagal memuat gambar KTP'),
                          ],
                        ),
                      );
                    },
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildKtpImageFromRawData() {
    if (_bookingData == null || !_bookingData.containsKey('ktp_image') || _bookingData['ktp_image'] == null) {
      return const SizedBox.shrink();
    }

    // Try different URL formats for KTP image
    List<String> possibleUrls = [
      '${Constants.baseUrl}/storage/${_bookingData['ktp_image']}',
      '${Constants.baseUrl}/api/storage/${_bookingData['ktp_image']}',
      _bookingData['ktp_image'].toString().startsWith('http') ? _bookingData['ktp_image'] : '${Constants.baseUrl}/storage/${_bookingData['ktp_image']}'
    ];

    return GestureDetector(
      onTap: () {
        // Show full screen image
        showDialog(
          context: context,
          builder: (context) => Dialog(
            insetPadding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppBar(
                  title: const Text('Foto KTP'),
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  leading: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                Flexible(
                  child: InteractiveViewer(
                    minScale: 0.5,
                    maxScale: 3.0,
                    child: Image.network(
                      possibleUrls[0],
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        // Try alternative URL if first one fails
                        return Image.network(
                          possibleUrls[1],
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            // Try third URL if second one fails
                            return Image.network(
                              possibleUrls[2],
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) {
                                return const Center(
                                  child: Text('Gagal memuat gambar KTP'),
                                );
                              },
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      child: Container(
        height: 150,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            possibleUrls[0],
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              // Try alternative URL if first one fails
              return Image.network(
                possibleUrls[1],
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  // Try third URL if second one fails
                  return Image.network(
                    possibleUrls[2],
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.image_not_supported, size: 40, color: Colors.grey),
                            SizedBox(height: 8),
                            Text('Gagal memuat gambar KTP'),
                          ],
                        ),
                      );
                    },
                  );
                },
              );
            },
          ),
        ),
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

  // Helper methods untuk menentukan tipe properti
  bool _isKost() {
    if (_bookingData != null && 
        _bookingData.containsKey('property') && 
        _bookingData['property'] != null && 
        _bookingData['property'].containsKey('property_type_id')) {
      return _bookingData['property']['property_type_id'].toString() == '1';
    }
    return false;
  }

  bool _isHomestay() {
    if (_bookingData != null && 
        _bookingData.containsKey('property') && 
        _bookingData['property'] != null && 
        _bookingData['property'].containsKey('property_type_id')) {
      return _bookingData['property']['property_type_id'].toString() == '2';
    }
    return false;
  }
}





