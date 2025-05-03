import 'package:front/features/dashboard/presentation/screens/users/button_navbar.dart';
import 'package:get/get.dart';
class Routes {
  static final List<GetPage> pages = [
    GetPage(
      name: "/bottombar",
      page: () => const BottomBar(), // Halaman yang ingin Anda buat sebagai rute
    ),
    // Rute-rute lain bisa ditambahkan di sini
  ];
}

