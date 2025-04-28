import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:front/features/dashboard/presentation/screens/users/owner/Homeowner.dart';
import 'package:front/features/dashboard/presentation/screens/users/penyewa/HomePenyewa.dart';
// import 'package:front/features/dashboard/presentation/screens/users/owner/Properti.dart';
import 'package:front/features/property/presentation/screens/property_list.dart';
import 'package:front/features/dashboard/presentation/screens/users/owner/Profil.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({super.key});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  late int _selectedIndex = 0;
  int? _role; // Nullable sampai SharedPreferences dimuat

  @override
  void initState() {
    super.initState();
    _loadRole(); // Memuat role dari SharedPreferences
  }

  // Fungsi untuk mengambil role dari SharedPreferences
  Future<void> _loadRole() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _role = prefs.getInt('user_role_id') ?? 4; // 2 = Owner, 4 = Customer
    });
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
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
      body: _getBody(),
    );
  }

  // Mengambil menu bottom navigation sesuai role
  List<BottomNavigationBarItem> _getBottomNavItems() {
    if (_role == 2) { // Owner
      return [
        _bottomNavigationBarItem('Home', 'assets/icons/home.svg'),
        _bottomNavigationBarItem('Properti', 'assets/icons/Properti.svg'),
        _bottomNavigationBarItem('Booking', 'assets/icons/pesanan_owner.svg'),
        _bottomNavigationBarItem('Ulasan', 'assets/icons/ulasan.svg'),
        _bottomNavigationBarItem('Profile', 'assets/icons/profil.svg'),
      ];
    } else if (_role == 4) { // Customer
      return [
        _bottomNavigationBarItem('Home', 'assets/icons/home.svg'),
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
    icon: ColorFiltered(
      colorFilter: ColorFilter.mode(
        Colors.black, // Mengubah warna menjadi hitam
        BlendMode.srcIn, // Menerapkan warna hitam ke ikon
      ),
      child: SvgPicture.asset(
        svgPath,
        width: 24,
        height: 24,
        semanticsLabel: label, // Menambahkan label untuk aksesibilitas
      ),
    ),
    activeIcon: ColorFiltered(
      colorFilter: ColorFilter.mode(
        Colors.black, // Mengubah warna menjadi hitam ketika aktif
        BlendMode.srcIn,
      ),
      child: SvgPicture.asset(
        svgPath,
        width: 24,
        height: 24,
        semanticsLabel: label,
      ),
    ),
    label: label,
  );
}


  // Halaman yang akan ditampilkan berdasarkan tab yang dipilih
  Widget _getBody() {
    if (_role == 2) { // Owner
      switch (_selectedIndex) {
        case 0:
          return const HomeOwner();
        case 1:
          return  PropertyListScreen();
        case 2:
          return const BookingOwner();
        case 3:
          return const Ulasan();
        case 4:
          return const ProfileOwner();
        default:
          return const HomeOwner();
      }
    } else { // Customer
      switch (_selectedIndex) {
        case 0:
          return const DashboardPage();
        case 1:
          return const Search();
        case 2:
          return const BookingCustomer();
          case 3:
          return const ProfileCustomer();
        default:
          return const DashboardPage();
      }
    }
  }
}

// Dummy halaman untuk Owner/Admin
// class HomeOwner extends StatelessWidget {
//   const HomeOwner({super.key});
//   @override
//   Widget build(BuildContext context) {
//     return const Center(child: Text('Home Owner'));
//   }
// }

// class PropertyListScreen extends StatelessWidget {
//   const PropertyListScreen({super.key});
//   @override
//   Widget build(BuildContext context) {
//     return const Center(child: Text('Properti Owner'));
//   }
// }

class BookingOwner extends StatelessWidget {
  const BookingOwner({super.key});
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Booking Owner'));
  }
}
class Search extends StatelessWidget {
  const Search({super.key});
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Search Owner'));
  }
}

class Ulasan extends StatelessWidget {
  const Ulasan({super.key});
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Ulasan Owner'));
  }
}

// class ProfileOwner extends StatelessWidget {
//   const ProfileOwner({super.key});
//   @override
//   Widget build(BuildContext context) {
//     return const Center(child: Text('Profile Owner'));
//   }
// }

// Dummy halaman untuk Customer


class BookingCustomer extends StatelessWidget {
  const BookingCustomer({super.key});
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Booking Customer'));
  }
}

class ProfileCustomer extends StatelessWidget {
  const ProfileCustomer({super.key});
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Profile Customer'));
  }
}
