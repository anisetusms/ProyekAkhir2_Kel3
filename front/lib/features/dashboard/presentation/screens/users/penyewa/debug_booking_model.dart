import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:front/features/dashboard/presentation/screens/users/penyewa/models/booking_room.dart';

class DebugBookingModel extends StatefulWidget {
  const DebugBookingModel({Key? key}) : super(key: key);

  @override
  State<DebugBookingModel> createState() => _DebugBookingModelState();
}

class _DebugBookingModelState extends State<DebugBookingModel> {
  final TextEditingController _jsonController = TextEditingController();
  String _result = '';
  bool _isLoading = false;
  bool _isSuccess = false;

  @override
  void dispose() {
    _jsonController.dispose();
    super.dispose();
  }

  void _parseJson() {
    setState(() {
      _isLoading = true;
      _result = '';
      _isSuccess = false;
    });

    try {
      // Parse JSON string to Map
      final jsonMap = json.decode(_jsonController.text);
      
      // Try to create Booking object
      final booking = Booking.fromJson(jsonMap);
      
      // If successful, show booking details
      setState(() {
        _result = '''
Parsing berhasil!

Booking ID: ${booking.id}
Property ID: ${booking.propertyId}
Status: ${booking.status}
Check-in: ${booking.checkIn}
Check-out: ${booking.checkOut}
Total Price: ${booking.totalPrice}
Guest Name: ${booking.guestName}
Property Name: ${booking.propertyName}
Property Image: ${booking.propertyImage}
Property Address: ${booking.propertyAddress}
Is Kost: ${booking.isKost}
Is Homestay: ${booking.isHomestay}
Booking Rooms: ${booking.bookingRooms?.length ?? 0}
''';
        _isSuccess = true;
      });
    } catch (e) {
      // If error, show error message
      setState(() {
        _result = 'Error parsing JSON: $e';
        _isSuccess = false;
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Debug Booking Model'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Paste JSON response here:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Expanded(
              flex: 2,
              child: TextField(
                controller: _jsonController,
                maxLines: null,
                expands: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: '{"id": 1, "property_id": 2, ...}',
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isLoading ? null : _parseJson,
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Parse JSON'),
            ),
            const SizedBox(height: 16),
            const Text(
              'Result:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Expanded(
              flex: 3,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _isSuccess ? Colors.green[50] : Colors.red[50],
                  border: Border.all(
                    color: _isSuccess ? Colors.green : Colors.red,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: SingleChildScrollView(
                  child: Text(
                    _result,
                    style: TextStyle(
                      color: _isSuccess ? Colors.green[900] : Colors.red[900],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
