import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:front/features/dashboard/presentation/screens/users/owner/homeowner.dart';
import 'package:front/features/dashboard/presentation/screens/users/penyewa/HomePenyewa.dart';
import 'package:front/features/dashboard/presentation/screens/users/penyewa/Search_screen.dart';
import 'package:front/features/property/presentation/screens/property_list.dart';
import 'package:front/features/dashboard/presentation/screens/users/penyewa/profil/profil_user.dart';
import 'package:front/features/dashboard/presentation/screens/users/owner/profil.dart';
import 'package:front/features/dashboard/presentation/screens/users/owner/admin_booking_list_screen.dart';
import 'package:front/features/dashboard/presentation/screens/users/penyewa/Daftar_booking_screen.dart';
  

class BottomBar extends StatefulWidget {
  const BottomBar({super.key});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  late int _selectedIndex = 0;
  int? _role; // Nullable sampai SharedPreferences dimuat
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _loadUserData(); // Memuat role dan status login dari SharedPreferences
  }

  // Fungsi untuk mengambil role dan status login dari SharedPreferences
  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    
    setState(() {
      _role = prefs.getInt('user_role_id') ?? 4; // 2 = Owner, 4 = Customer
      _isLoggedIn = token != null && token.isNotEmpty;
    });
  }
  
  // Fungsi untuk memeriksa apakah user sudah login
  Future<bool> _checkLoginStatus() async {
    if (_isLoggedIn) return true;
    
    // Jika belum login, tampilkan dialog konfirmasi
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Login Diperlukan'),
        content: const Text('Anda perlu login untuk mengakses fitur ini. Apakah Anda ingin login sekarang?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Nanti'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Login'),
          ),
        ],
      ),
    );
    
    // Jika user memilih login, arahkan ke halaman login
    if (result == true) {
      Get.toNamed('/login');
    }
    
    return false;
  }

  @override
  Widget build(BuildContext context) {
    // Jika role belum dimuat, tampilkan loading
    if (_role == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: _getBottomNavItems(),
        currentIndex: _selectedIndex,
        onTap: (index) async {
          // Cek apakah perlu login untuk mengakses tab tertentu
          if (_role == 4) { // Customer
            if (index == 2 || index == 3) { // Booking atau Profile
              final canProceed = await _checkLoginStatus();
              if (!canProceed) return;
            }
          }
          
          setState(() {
            _selectedIndex = index;
          });
        },
        selectedItemColor: Colors.black, // Color for selected item (icon color)
        unselectedItemColor: Colors.grey, // Color for unselected items
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold), // Bold label when selected
      ),
      body: _getBody(),
    );
  }

  // Mengambil menu bottom navigation sesuai role
  List<BottomNavigationBarItem> _getBottomNavItems() {
    if (_role == 2) { // Owner
      return [
        _bottomNavigationBarItem('Home', 'assets/icons/h.svg'),
        _bottomNavigationBarItem('Properti', 'assets/icons/Vector.svg'),
        _bottomNavigationBarItem('Booking', 'assets/icons/pesanan_owner.svg'),
        _bottomNavigationBarItem('Ulasan', 'assets/icons/ulasan.svg'),
        _bottomNavigationBarItem('Profile', 'assets/icons/profil.svg'),
      ];
    } else if (_role == 4) { // Customer
      return [
        _bottomNavigationBarItem('Home', 'assets/icons/h.svg'),
        _bottomNavigationBarItem('Pencarian', 'assets/icons/Search.svg'),
        _bottomNavigationBarItem('Booking', 'assets/icons/pesanan_owner.svg'),
        _bottomNavigationBarItem('Profile', 'assets/icons/profil.svg'),
      ];
    } else { // Default
      return [
        _bottomNavigationBarItem('Home', 'assets/icons/home_icon.svg'),
        _bottomNavigationBarItem('Profile', 'assets/icons/profile_icon.svg'),
      ];
    }
  }

  // Fungsi untuk membuat BottomNavigationBarItem dengan SVG
  BottomNavigationBarItem _bottomNavigationBarItem(String label, String svgPath) {
    return BottomNavigationBarItem(
      icon: SvgPicture.asset(
        svgPath,
        width: 24,
        height: 24,
        semanticsLabel: label, // Menambahkan label untuk aksesibilitas
        color: Colors.black.withOpacity(0.6), // Default color for the icon
      ),
      activeIcon: SvgPicture.asset(
        svgPath,
        width: 24,
        height: 24,
        semanticsLabel: label,
        color: Colors.black, // Color when active (selected)
      ),
      label: label,
    );
  }

  // Halaman yang akan ditampilkan berdasarkan tab yang dipilih
  Widget _getBody() {
    if (_role == 2) { // Owner
      switch (_selectedIndex) {
        case 0:
          return DashboardScreen();
        case 1:
          return PropertyListScreen();
        case 2:
          return const AdminBookingListScreen();
        case 3:
          return const Ulasan();
        case 4:
          return const ProfileOwner();
        default:
          return DashboardScreen();
      }
    } else { // Customer
      switch (_selectedIndex) {
        case 0:
          return const DashboardPage();
        case 1:
          return const SearchScreen();
        case 2:
          // Jika belum login, tampilkan halaman login required
          return _isLoggedIn 
              ? const BookingListScreen()
              : _buildLoginRequiredScreen('booking');
        case 3:
          // Jika belum login, tampilkan halaman login required
          return _isLoggedIn 
              ? const ProfileUser()
              : _buildLoginRequiredScreen('profil');
        default:
          return const DashboardPage();
      }
    }
  }
  
  // Widget untuk menampilkan halaman yang memerlukan login
  Widget _buildLoginRequiredScreen(String feature) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.lock_outline,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 24),
            Text(
              'Login Diperlukan',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'Anda perlu login untuk melihat ${feature == 'booking' ? 'daftar booking' : 'profil'} Anda',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Get.toNamed('/login');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: const Text(
                  'Login Sekarang',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                Get.toNamed('/register');
              },
              child: const Text(
                'Belum punya akun? Daftar di sini',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.blue,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Ulasan extends StatelessWidget {
  const Ulasan({super.key});
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Ulasan Owner'));
  }
}