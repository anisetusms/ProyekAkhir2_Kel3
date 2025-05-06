import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:front/features/dashboard/presentation/screens/users/penyewa/models/booking_model.dart';
import 'package:front/features/dashboard/presentation/screens/users/penyewa/booking/booking_repository.dart';
import 'package:intl/intl.dart';
import 'package:front/core/utils/constants.dart';
class BookingDetailScreen extends StatefulWidget {
  final String bookingId;

  const BookingDetailScreen({super.key, required this.bookingId});

  @override
  State<BookingDetailScreen> createState() => _BookingDetailScreenState();
}

class _BookingDetailScreenState extends State<BookingDetailScreen> {
  late Future<BookingModel> _bookingFuture;
  final BookingRepository _bookingRepository = BookingRepository();
  bool _isCancelling = false;

  @override
  void initState() {
    super.initState();
    _bookingFuture = _bookingRepository.getBookingDetail(widget.bookingId);
  }

  Future<void> _cancelBooking() async {
    setState(() {
      _isCancelling = true;
    });

    try {
      await _bookingRepository.cancelBooking(widget.bookingId);
      setState(() {
        _bookingFuture = _bookingRepository.getBookingDetail(widget.bookingId);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Booking berhasil dibatalkan')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal membatalkan booking: $e')),
      );
    } finally {
      setState(() {
        _isCancelling = false;
      });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Booking'),
      ),
      body: FutureBuilder<BookingModel>(
        future: _bookingFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 50),
                  const SizedBox(height: 16),
                  const Text('Gagal memuat detail booking'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _bookingFuture = _bookingRepository.getBookingDetail(widget.bookingId);
                      });
                    },
                    child: const Text('Coba Lagi'),
                  ),
                ],
              ),
            );
          }

          if (!snapshot.hasData) {
            return const Center(child: Text('Data booking tidak ditemukan'));
          }

          final booking = snapshot.data!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Status Booking
                Center(
                  child: Chip(
                    label: Text(
                      booking.status.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    backgroundColor: _getStatusColor(booking.status),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  ),
                ),
                const SizedBox(height: 24),

                // Informasi Properti
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Informasi Properti',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            booking.propertyImage != null
                                ? Image.network(
                                    '${Constants.baseUrl}/storage/${booking.propertyImage}',
                                    width: 80,
                                    height: 80,
                                    fit: BoxFit.cover,
                                  )
                                : const Icon(Icons.home, size: 80),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    booking.propertyName,
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(booking.propertyAddress),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Detail Booking
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Detail Booking',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 16),
                        _buildDetailRow('ID Booking', booking.bookingCode),
                        _buildDetailRow('Tanggal Booking', booking.createdAt),
                        _buildDetailRow('Check-in', booking.checkIn),
                        _buildDetailRow('Check-out', booking.checkOut),
                        _buildDetailRow('Durasi', '${booking.totalDays} ${booking.isKost ? 'Bulan' : 'Malam'}'),
                        if (booking.roomNames.isNotEmpty)
                          _buildDetailRow('Kamar', booking.roomNames.join(', ')),
                        _buildDetailRow('Total Harga', 'Rp ${NumberFormat('#,###').format(booking.totalPrice)}'),
                        if (booking.specialRequests.isNotEmpty)
                          _buildDetailRow('Permintaan Khusus', booking.specialRequests),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Informasi Tamu
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Informasi Tamu',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 16),
                        _buildDetailRow('Nama Tamu', booking.guestName),
                        _buildDetailRow('Nomor Telepon', booking.guestPhone),
                        _buildDetailRow('Nomor KTP', booking.identityNumber),
                        if (booking.ktpImage.isNotEmpty)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Foto KTP', style: TextStyle(fontWeight: FontWeight.bold)),
                              const SizedBox(height: 8),
                              GestureDetector(
                                onTap: () {
                                  // Tampilkan gambar full screen
                                },
                                child: Image.network(
                                  '${Constants.baseUrl}/storage/${booking.ktpImage}',
                                  height: 150,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Tombol Aksi
                if (booking.status.toLowerCase() == 'pending' || booking.status.toLowerCase() == 'confirmed')
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isCancelling ? null : _cancelBooking,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: _isCancelling
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text('Batalkan Booking'),
                    ),
                  ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Kembali'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const Text(': '),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}