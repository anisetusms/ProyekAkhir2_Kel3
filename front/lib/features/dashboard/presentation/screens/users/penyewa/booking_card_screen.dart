import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:front/features/dashboard/presentation/screens/users/penyewa/models/booking_model.dart';
import 'package:front/core/network/api_client.dart';
import 'package:front/core/utils/constants.dart';
import 'package:front/core/widgets/loading_indicator.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:developer' as developer;
import 'dart:typed_data';

class BookingCardScreen extends StatefulWidget {
  final Booking booking;

  const BookingCardScreen({
    Key? key,
    required this.booking,
  }) : super(key: key);

  @override
  _BookingCardScreenState createState() => _BookingCardScreenState();
}

class _BookingCardScreenState extends State<BookingCardScreen> {
  bool _isLoading = false;
  String? _errorMessage;
  final ApiClient _apiClient = ApiClient();

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd MMMM yyyy', 'id_ID');
    final currencyFormat = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp',
      decimalDigits: 0,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kartu Booking'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: _shareBookingCard,
          ),
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: _downloadBookingCard,
          ),
        ],
      ),
      body: _isLoading
          ? const LoadingIndicator()
          : _errorMessage != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 64,
                          color: Colors.red[300],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _errorMessage!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _errorMessage = null;
                            });
                          },
                          child: const Text('Coba Lagi'),
                        ),
                        const SizedBox(height: 12),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('Kembali'),
                        ),
                      ],
                    ),
                  ),
                )
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        // Booking Card
                        Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            children: [
                              // Header
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(16),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.confirmation_number,
                                      color: Colors.white,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'KARTU BOOKING',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                          Text(
                                            'ID: #${widget.booking.id}',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        _getStatusText(widget.booking.status),
                                        style: TextStyle(
                                          color: _getStatusColor(widget.booking.status),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Property Details
                              if (widget.booking.propertyName != null)
                                Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Property Image
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.network(
                                          _getPropertyImageUrl(widget.booking.propertyImage),
                                          width: 80,
                                          height: 80,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) =>
                                                  Container(
                                            width: 80,
                                            height: 80,
                                            color: Colors.grey[200],
                                            child: const Icon(
                                              Icons.home,
                                              size: 40,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      // Property Info
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              widget.booking.propertyName ?? 'Properti',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              widget.booking.propertyAddress ?? 'Alamat tidak tersedia',
                                              style: TextStyle(
                                                color: Colors.grey[600],
                                                fontSize: 14,
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              widget.booking.isKost 
                                                  ? 'Kost' 
                                                  : widget.booking.isHomestay 
                                                      ? 'Homestay' 
                                                      : 'Properti',
                                              style: TextStyle(
                                                color: Colors.grey[600],
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                              // Room Details if available
                              if (widget.booking.bookingRooms != null && 
                                  widget.booking.bookingRooms!.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Kamar yang Dipesan',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      ...widget.booking.bookingRooms!.map((room) {
                                        final roomName = room.room != null && room.room!.containsKey('name') 
                                            ? room.room!['name'] 
                                            : 'Kamar #${room.roomId}';
                                        
                                        return Padding(
                                          padding: const EdgeInsets.only(bottom: 4),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                roomName,
                                                style: const TextStyle(fontSize: 14),
                                              ),
                                              Text(
                                                currencyFormat.format(room.price),
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      }).toList(),
                                    ],
                                  ),
                                ),

                              const Divider(),

                              // Booking Details
                              Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  children: [
                                    // Guest Info
                                    _buildInfoRow(
                                      'Tamu',
                                      widget.booking.guestName ?? (widget.booking.isForOthers == true
                                          ? 'Tamu Lain'
                                          : 'Diri Sendiri'),
                                    ),
                                    const SizedBox(height: 8),
                                    _buildInfoRow(
                                      'No. Telepon',
                                      widget.booking.guestPhone ?? 'N/A',
                                    ),
                                    const SizedBox(height: 8),
                                    _buildInfoRow(
                                      'No. Identitas',
                                      widget.booking.identityNumber,
                                    ),
                                    if (widget.booking.specialRequests != null &&
                                        widget.booking.specialRequests!.isNotEmpty) ...[
                                      const SizedBox(height: 8),
                                      _buildInfoRow(
                                        'Permintaan Khusus',
                                        widget.booking.specialRequests!,
                                      ),
                                    ],
                                    const SizedBox(height: 16),

                                    // Dates
                                    Row(
                                      children: [
                                        Expanded(
                                          child: _buildInfoRow(
                                            'Check-in',
                                            dateFormat
                                                .format(widget.booking.checkIn),
                                            icon: Icons.login,
                                          ),
                                        ),
                                        Expanded(
                                          child: _buildInfoRow(
                                            'Check-out',
                                            dateFormat
                                                .format(widget.booking.checkOut),
                                            icon: Icons.logout,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 16),

                                    // Payment Info
                                    _buildInfoRow(
                                      'Total Pembayaran',
                                      currencyFormat
                                          .format(widget.booking.totalPrice),
                                      icon: Icons.payment,
                                      valueStyle: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    ),
                                    
                                    // Booking Date
                                    const SizedBox(height: 16),
                                    _buildInfoRow(
                                      'Tanggal Booking',
                                      dateFormat.format(widget.booking.createdAt),
                                      icon: Icons.calendar_today,
                                    ),
                                  ],
                                ),
                              ),

                              const Divider(),

                              // QR Code
                              Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  children: [
                                    const Text(
                                      'Tunjukkan QR Code ini saat check-in',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    QrImageView(
                                      data:
                                          'BOOKING:${widget.booking.id}:${widget.booking.propertyId}',
                                      version: QrVersions.auto,
                                      size: 200,
                                      backgroundColor: Colors.white,
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      'Booking ID: #${widget.booking.id}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Footer
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: const BorderRadius.vertical(
                                    bottom: Radius.circular(16),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.info_outline,
                                      size: 16,
                                      color: Colors.grey,
                                    ),
                                    const SizedBox(width: 8),
                                    Flexible(
                                      child: Text(
                                        'Kartu booking ini adalah bukti sah reservasi Anda',
                                        style: TextStyle(
                                          color: Colors.grey[700],
                                          fontSize: 12,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Additional Info
                        Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Informasi Penting',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                _buildInfoItem(
                                  widget.booking.isKost
                                      ? 'Untuk kost, check-in sesuai dengan jadwal yang ditentukan'
                                      : 'Check-in dimulai pukul 14:00',
                                  Icons.access_time,
                                ),
                                _buildInfoItem(
                                  widget.booking.isKost
                                      ? 'Untuk kost, masa sewa sesuai dengan perjanjian'
                                      : 'Check-out sebelum pukul 12:00',
                                  Icons.access_time,
                                ),
                                _buildInfoItem(
                                  'Harap tunjukkan kartu identitas saat check-in',
                                  Icons.credit_card,
                                ),
                                _buildInfoItem(
                                  'Hubungi pemilik properti jika ada pertanyaan',
                                  Icons.phone,
                                ),
                                if (widget.booking.isHomestay)
                                  _buildInfoItem(
                                    'Untuk homestay, patuhi peraturan yang berlaku',
                                    Icons.rule,
                                  ),
                              ],
                            ),
                          ),
                        ),
                        
                        // Action buttons based on booking status
                        if (widget.booking.status == 'pending' || 
                            widget.booking.status == 'confirmed')
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 24),
                            child: ElevatedButton.icon(
                              onPressed: () {
                                // Implement cancel booking functionality
                                _showCancelConfirmation();
                              },
                              icon: const Icon(Icons.cancel),
                              label: const Text('Batalkan Booking'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 12,
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

  String _getPropertyImageUrl(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) {
      return 'https://via.placeholder.com/150';
    }
    
    if (imagePath.startsWith('http')) {
      return imagePath;
    }
    
    // Coba beberapa kemungkinan URL
    try {
      // Coba gunakan Constants.baseUrl jika tersedia
      return '${Constants.baseUrl}/storage/$imagePath';
    } catch (e) {
      // Jika tidak tersedia, gunakan URL default
      return 'https://via.placeholder.com/150';
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'confirmed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      case 'completed':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  String _getStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'MENUNGGU';
      case 'confirmed':
        return 'DIKONFIRMASI';
      case 'cancelled':
        return 'DIBATALKAN';
      case 'completed':
        return 'SELESAI';
      default:
        return status.toUpperCase();
    }
  }

  void _showCancelConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Batalkan Booking'),
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

  Future<void> _cancelBooking() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await _apiClient.put(
        '/bookings/${widget.booking.id}/cancel',
        body: {},
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Booking berhasil dibatalkan'),
            backgroundColor: Colors.green,
          ),
        );
        
        // Return to previous screen with result
        Navigator.pop(context, true);
      } else {
        setState(() {
          _errorMessage = 'Gagal membatalkan booking. Silakan coba lagi.';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Terjadi kesalahan: $e';
        _isLoading = false;
      });
    }
  }

  Widget _buildInfoRow(String label, String value,
      {IconData? icon, TextStyle? valueStyle}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (icon != null) ...[
          Icon(icon, size: 16, color: Colors.grey[600]),
          const SizedBox(width: 8),
        ],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: valueStyle ??
                    const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoItem(String text, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: Colors.grey[600]),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[800],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _shareBookingCard() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null; // Reset error message
    });

    try {
      final pdfFile = await _generatePdf();
      await Share.shareFiles([
        pdfFile.path,
      ], text: 'Kartu Booking #${widget.booking.id}');
    } catch (e) {
      developer.log('Error sharing booking card: $e', name: 'BookingCardScreen');
      setState(() {
        _errorMessage = 'Gagal membagikan kartu booking: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _downloadBookingCard() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null; // Reset error message
    });

    try {
      final pdfFile = await _generatePdf();
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Kartu booking berhasil diunduh ke ${pdfFile.path}'),
          action: SnackBarAction(
            label: 'Buka',
            onPressed: () {
              // Open the file with default PDF viewer
              // This would require a plugin like open_file
            },
          ),
        ),
      );
    } catch (e) {
      developer.log('Error downloading booking card: $e', name: 'BookingCardScreen');
      setState(() {
        _errorMessage = 'Gagal mengunduh kartu booking: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<File> _generatePdf() async {
    final pdf = pw.Document();
    final dateFormat = DateFormat('dd MMMM yyyy', 'id_ID');
    final currencyFormat = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp',
      decimalDigits: 0,
    );

    // Gunakan font default tanpa mencoba memuat font kustom
    final ttf = pw.Font.helvetica();
    final ttfBold = pw.Font.helveticaBold();

    // Load property image if available
    pw.MemoryImage? propertyImage;
    Uint8List? placeholderImageBytes;
    
    try {
      // Coba memuat gambar placeholder terlebih dahulu sebagai fallback
      final placeholderResponse = await http.get(Uri.parse('https://via.placeholder.com/150'));
      if (placeholderResponse.statusCode == 200) {
        placeholderImageBytes = placeholderResponse.bodyBytes;
      }
    } catch (e) {
      developer.log('Failed to load placeholder image: $e', name: 'BookingCardScreen');
    }
    
    if (widget.booking.propertyImage != null) {
      try {
        final imageUrl = _getPropertyImageUrl(widget.booking.propertyImage);
        developer.log('Loading property image from: $imageUrl', name: 'BookingCardScreen');
        
        final response = await http.get(Uri.parse(imageUrl));
        if (response.statusCode == 200) {
          propertyImage = pw.MemoryImage(response.bodyBytes);
          developer.log('Property image loaded successfully', name: 'BookingCardScreen');
        } else {
          developer.log('Failed to load property image. Status code: ${response.statusCode}', name: 'BookingCardScreen');
          // Gunakan placeholder jika tersedia
          if (placeholderImageBytes != null) {
            propertyImage = pw.MemoryImage(placeholderImageBytes);
          }
        }
      } catch (e) {
        developer.log('Failed to load property image: $e', name: 'BookingCardScreen');
        // Gunakan placeholder jika tersedia
        if (placeholderImageBytes != null) {
          propertyImage = pw.MemoryImage(placeholderImageBytes);
        }
      }
    } else if (placeholderImageBytes != null) {
      propertyImage = pw.MemoryImage(placeholderImageBytes);
    }

    // Generate QR code
    final qrData = 'BOOKING:${widget.booking.id ?? "0"}:${widget.booking.propertyId}';
    final qrCode = pw.BarcodeWidget(
      barcode: pw.Barcode.qrCode(),
      data: qrData,
      width: 160,
      height: 160,
    );

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Header
              pw.Container(
                padding: const pw.EdgeInsets.all(16),
                decoration: pw.BoxDecoration(
                  color: PdfColors.brown,
                  borderRadius: pw.BorderRadius.circular(8),
                ),
                child: pw.Row(
                  children: [
                    pw.Expanded(
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(
                            'KARTU BOOKING',
                            style: pw.TextStyle(
                              font: ttfBold,
                              color: PdfColors.white,
                              fontSize: 18,
                            ),
                          ),
                          pw.SizedBox(height: 4),
                          pw.Text(
                            'ID: #${widget.booking.id}',
                            style: pw.TextStyle(
                              font: ttf,
                              color: PdfColors.white,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    pw.Container(
                      padding: const pw.EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: pw.BoxDecoration(
                        color: PdfColors.white,
                        borderRadius: pw.BorderRadius.circular(20),
                      ),
                      child: pw.Text(
                        _getStatusText(widget.booking.status),
                        style: pw.TextStyle(
                          font: ttfBold,
                          color: PdfColors.brown,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              pw.SizedBox(height: 16),

              // Property Details
              if (widget.booking.propertyName != null)
                pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    // Property Image
                    propertyImage != null
                        ? pw.ClipRRect(
                            verticalRadius: 8,
                            horizontalRadius: 8,
                            child: pw.Image(
                              propertyImage,
                              width: 80,
                              height: 80,
                              fit: pw.BoxFit.cover,
                            ),
                          )
                        : pw.Container(
                            width: 80,
                            height: 80,
                            decoration: pw.BoxDecoration(
                              color: PdfColors.grey200,
                              borderRadius: pw.BorderRadius.circular(8),
                            ),
                            child: pw.Center(
                              child: pw.Text(
                                'No Image',
                                style: pw.TextStyle(
                                  font: ttf,
                                  color: PdfColors.grey,
                                ),
                              ),
                            ),
                          ),
                    pw.SizedBox(width: 16),
                    // Property Info
                    pw.Expanded(
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(
                            widget.booking.propertyName ?? 'Properti',
                            style: pw.TextStyle(
                              font: ttfBold,
                              fontSize: 16,
                            ),
                          ),
                          pw.SizedBox(height: 4),
                          pw.Text(
                            widget.booking.propertyAddress ?? 'Alamat tidak tersedia',
                            style: pw.TextStyle(
                              font: ttf,
                              color: PdfColors.grey700,
                              fontSize: 12,
                            ),
                          ),
                          pw.SizedBox(height: 4),
                          pw.Text(
                            widget.booking.isKost 
                                ? 'Kost' 
                                : widget.booking.isHomestay 
                                    ? 'Homestay' 
                                    : 'Properti',
                            style: pw.TextStyle(
                              font: ttf,
                              color: PdfColors.grey700,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

              // Room Details if available
              if (widget.booking.bookingRooms != null && 
                  widget.booking.bookingRooms!.isNotEmpty) ...[
                pw.SizedBox(height: 16),
                pw.Text(
                  'Kamar yang Dipesan',
                  style: pw.TextStyle(
                    font: ttfBold,
                    fontSize: 14,
                  ),
                ),
                pw.SizedBox(height: 8),
                ...widget.booking.bookingRooms!.map((room) {
                  final roomName = room.room != null && room.room!.containsKey('name') 
                      ? room.room!['name'] 
                      : 'Kamar #${room.roomId}';
                  
                  return pw.Padding(
                    padding: const pw.EdgeInsets.only(bottom: 4),
                    child: pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text(
                          roomName,
                          style: pw.TextStyle(
                            font: ttf,
                            fontSize: 12,
                          ),
                        ),
                        pw.Text(
                          currencyFormat.format(room.price),
                          style: pw.TextStyle(
                            font: ttfBold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ],

              pw.SizedBox(height: 16),
              pw.Divider(),
              pw.SizedBox(height: 16),

              // Booking Details
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  // Guest Info
                  _buildPdfInfoRow(
                    'Tamu',
                    widget.booking.guestName ?? (widget.booking.isForOthers == true
                        ? 'Tamu Lain'
                        : 'Diri Sendiri'),
                    ttf,
                    ttfBold,
                  ),
                  pw.SizedBox(height: 8),
                  _buildPdfInfoRow(
                    'No. Telepon',
                    widget.booking.guestPhone ?? 'N/A',
                    ttf,
                    ttfBold,
                  ),
                  pw.SizedBox(height: 8),
                  _buildPdfInfoRow(
                    'No. Identitas',
                    widget.booking.identityNumber,
                    ttf,
                    ttfBold,
                  ),
                  if (widget.booking.specialRequests != null &&
                      widget.booking.specialRequests!.isNotEmpty) ...[
                    pw.SizedBox(height: 8),
                    _buildPdfInfoRow(
                      'Permintaan Khusus',
                      widget.booking.specialRequests!,
                      ttf,
                      ttfBold,
                    ),
                  ],
                  pw.SizedBox(height: 16),

                  // Dates
                  pw.Row(
                    children: [
                      pw.Expanded(
                        child: _buildPdfInfoRow(
                          'Check-in',
                          dateFormat.format(widget.booking.checkIn),
                          ttf,
                          ttfBold,
                        ),
                      ),
                      pw.Expanded(
                        child: _buildPdfInfoRow(
                          'Check-out',
                          dateFormat.format(widget.booking.checkOut),
                          ttf,
                          ttfBold,
                        ),
                      ),
                    ],
                  ),
                  pw.SizedBox(height: 16),

                  // Payment Info
                  _buildPdfInfoRow(
                    'Total Pembayaran',
                    currencyFormat.format(widget.booking.totalPrice),
                    ttf,
                    ttfBold,
                    valueColor: PdfColors.brown,
                  ),
                  
                  // Booking Date
                  pw.SizedBox(height: 16),
                  _buildPdfInfoRow(
                    'Tanggal Booking',
                    dateFormat.format(widget.booking.createdAt),
                    ttf,
                    ttfBold,
                  ),
                ],
              ),

              pw.SizedBox(height: 16),
              pw.Divider(),
              pw.SizedBox(height: 16),

              // QR Code
              pw.Center(
                child: pw.Column(
                  children: [
                    pw.Text(
                      'Tunjukkan QR Code ini saat check-in',
                      style: pw.TextStyle(
                        font: ttfBold,
                        fontSize: 14,
                      ),
                    ),
                    pw.SizedBox(height: 16),
                    qrCode,
                    pw.SizedBox(height: 16),
                    pw.Text(
                      'Booking ID: #${widget.booking.id}',
                      style: pw.TextStyle(
                        font: ttfBold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),

              pw.SizedBox(height: 16),
              pw.Divider(),
              pw.SizedBox(height: 16),

              // Important Info
              pw.Container(
                padding: const pw.EdgeInsets.all(16),
                decoration: pw.BoxDecoration(
                  color: PdfColors.grey200,
                  borderRadius: pw.BorderRadius.circular(8),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'Informasi Penting',
                      style: pw.TextStyle(
                        font: ttfBold,
                        fontSize: 14,
                      ),
                    ),
                    pw.SizedBox(height: 8),
                    _buildPdfInfoItem(
                      widget.booking.isKost
                          ? 'Untuk kost, check-in sesuai dengan jadwal yang ditentukan'
                          : 'Check-in dimulai pukul 14:00',
                      ttf,
                    ),
                    _buildPdfInfoItem(
                      widget.booking.isKost
                          ? 'Untuk kost, masa sewa sesuai dengan perjanjian'
                          : 'Check-out sebelum pukul 12:00',
                      ttf,
                    ),
                    _buildPdfInfoItem(
                      'Harap tunjukkan kartu identitas saat check-in',
                      ttf,
                    ),
                    _buildPdfInfoItem(
                      'Hubungi pemilik properti jika ada pertanyaan',
                      ttf,
                    ),
                    if (widget.booking.isHomestay)
                      _buildPdfInfoItem(
                        'Untuk homestay, patuhi peraturan yang berlaku',
                        ttf,
                      ),
                  ],
                ),
              ),

              // Footer
              pw.Spacer(),
              pw.Center(
                child: pw.Text(
                  'Kartu booking ini adalah bukti sah reservasi Anda',
                  style: pw.TextStyle(
                    font: ttf,
                    color: PdfColors.grey700,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );

    try {
      // Coba mendapatkan direktori yang tersedia
      Directory directory;
      try {
        // Coba gunakan direktori dokumen terlebih dahulu
        directory = await getApplicationDocumentsDirectory();
      } catch (e) {
        // Jika gagal, gunakan direktori sementara
        directory = await getTemporaryDirectory();
      }
      
      final filePath = '${directory.path}/booking_card_${widget.booking.id}.pdf';
      developer.log('Saving PDF to: $filePath', name: 'BookingCardScreen');
      
      final file = File(filePath);
      await file.writeAsBytes(await pdf.save());
      return file;
    } catch (e) {
      developer.log('Error saving PDF: $e', name: 'BookingCardScreen');
      throw Exception('Gagal menyimpan PDF: $e');
    }
  }

  pw.Widget _buildPdfInfoRow(
    String label,
    String value,
    pw.Font font,
    pw.Font fontBold, {
    PdfColor? valueColor,
  }) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          label,
          style: pw.TextStyle(
            font: font,
            fontSize: 10,
            color: PdfColors.grey700,
          ),
        ),
        pw.SizedBox(height: 2),
        pw.Text(
          value,
          style: pw.TextStyle(
            font: fontBold,
            fontSize: 12,
            color: valueColor ?? PdfColors.black,
          ),
        ),
      ],
    );
  }

  pw.Widget _buildPdfInfoItem(
    String text,
    pw.Font font,
  ) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 4),
      child: pw.Text(
        '• $text',
        style: pw.TextStyle(
          font: font,
          fontSize: 10,
          color: PdfColors.grey800,
        ),
      ),
    );
  }
}
