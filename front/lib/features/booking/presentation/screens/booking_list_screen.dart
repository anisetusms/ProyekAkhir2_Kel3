import 'package:flutter/material.dart';
import 'package:front/core/network/api_client.dart';
import 'package:front/core/utils/constants.dart';
import 'package:intl/intl.dart';

class BookingListScreen extends StatefulWidget {
  static const routeName = '/bookings';

  @override
  _BookingListScreenState createState() => _BookingListScreenState();
}

class _BookingListScreenState extends State<BookingListScreen> {
  late Future<List<dynamic>> _bookingsFuture;

  @override
  void initState() {
    super.initState();
    _bookingsFuture = _fetchBookings();
  }

  Future<List<dynamic>> _fetchBookings() async {
    try {
      final response = await ApiClient().get('${Constants.baseUrl}/bookings');
      return response['data'] as List<dynamic>;
    } catch (e) {
      print('Error fetching bookings: $e');
      return Future.error('Gagal memuat daftar pemesanan.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Pemesanan'),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            _bookingsFuture = _fetchBookings();
          });
        },
        child: FutureBuilder<List<dynamic>>(
          future: _bookingsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Gagal memuat daftar: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              final bookings = snapshot.data!;
              if (bookings.isEmpty) {
                return const Center(child: Text('Belum ada pemesanan.'));
              }
              return ListView.builder(
                itemCount: bookings.length,
                itemBuilder: (context, index) {
                  final booking = bookings[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            booking['property']['name'] ?? 'Nama Properti',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                          ),
                          const SizedBox(height: 8.0),
                          Text('Check-in: ${DateFormat('dd MMM yyyy').format(DateTime.parse(booking['check_in_date']))}'),
                          Text('Check-out: ${DateFormat('dd MMM yyyy').format(DateTime.parse(booking['check_out_date']))}'),
                          Text('Jumlah Tamu: ${booking['guests']}'),
                          Text('Tanggal Pemesanan: ${DateFormat('dd MMM yyyy HH:mm').format(DateTime.parse(booking['created_at']))}'),
                          // Tambahkan informasi lain jika perlu
                        ],
                      ),
                    ),
                  );
                },
              );
            } else {
              return const Center(child: Text('Tidak ada data pemesanan.'));
            }
          },
        ),
      ),
    );
  }
}