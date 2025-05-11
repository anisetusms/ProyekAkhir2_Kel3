import 'package:flutter/material.dart';
import 'package:front/features/dashboard/presentation/screens/users/owner/bookings/admin_booking_list_screen.dart';

class DashboardScreen extends StatelessWidget {
  static const String routeName = '/dashboard';

  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Selamat Datang di Dashboard!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            const Text(
              'Pilih tindakan yang ingin Anda lakukan:',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 16.0,
              runSpacing: 16.0,
              children: [
                _buildActionButton(
                  icon: Icons.people,
                  label: 'Kelola Pengguna',
                  onPressed: () {
                    // TODO: Implement navigation to manage users
                  },
                ),
                _buildActionButton(
                  icon: Icons.settings,
                  label: 'Pengaturan',
                  onPressed: () {
                    // TODO: Implement navigation to settings
                  },
                ),
                _buildActionButton(
                  icon: Icons.book,
                  label: 'Kelola Pemesanan',
                  onPressed: () => Navigator.pushNamed(context, AdminBookingListScreen.routeName),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      icon: Icon(icon),
      label: Text(label),
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
        textStyle: const TextStyle(fontSize: 16),
      ),
    );
  }
}
