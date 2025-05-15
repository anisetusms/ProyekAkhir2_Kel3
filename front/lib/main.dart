// import 'package:flutter/material.dart';
// import 'package:front/features/dashboard/presentation/screens/users/penyewa/booking_detail_screen.dart';
// import 'package:front/features/dashboard/presentation/screens/users/penyewa/models/booking_model.dart';
// import 'package:get/get.dart';
// import 'package:front/features/auth/presentation/screens/login_screen.dart';
// import 'package:front/features/auth/presentation/screens/register_screen.dart';
// import 'package:front/features/dashboard/presentation/screens/dashboard_screen.dart';
// import 'package:front/features/property/presentation/screens/add_property_screen.dart';
// import 'package:front/features/property/presentation/screens/edit_property_screen.dart';
// import 'package:front/features/property/presentation/screens/property_detail.dart';
// import 'package:front/features/property/presentation/screens/property_list.dart';
// import 'package:front/features/room/presentation/screens/room_list_screen.dart';
// import 'package:front/features/room/presentation/screens/add_room_screen.dart';
// import 'package:front/features/room/presentation/screens/edit_room_screen.dart';
// import 'package:front/features/room/data/models/room_model.dart';
// import 'package:front/features/dashboard/presentation/screens/users/button_navbar.dart';
// import 'package:front/features/dashboard/presentation/screens/users/penyewa/booking_detail_screen.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return GetMaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Hommie App',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//         visualDensity: VisualDensity.adaptivePlatformDensity,
//       ),
//       initialRoute: '/login',
//       getPages: [
//         GetPage(name: '/login', page: () => LoginScreen()),
//         GetPage(name: '/register', page: () => RegisterScreen()),
//         GetPage(name: '/dashboard', page: () => DashboardScreen()),
//         GetPage(name: '/bottombar', page: () => BottomBar()),
//         GetPage(
//           name: '/manage_rooms',
//           page: () => RoomListScreen(propertyId: Get.arguments as int),
//         ),
//         GetPage(
//           name: PropertyListScreen.routeName,
//           page: () => PropertyListScreen(),
//         ),
//         GetPage(
//           name: PropertyDetailScreen.routeName,
//           page: () => PropertyDetailScreen(),
//         ),
//         GetPage(
//           name: AddPropertyScreen.routeName,
//           page: () => AddPropertyScreen(),
//         ),
//         GetPage(
//           name: EditPropertyScreen.routeName,
//           page: () => EditPropertyScreen(
//             property: Get.arguments as Map<String, dynamic>,
//           ),
//         ),
//         GetPage(
//           name: AddRoomScreen.routeName,
//           page: () => AddRoomScreen(propertyId: Get.arguments as int),
//         ),
//         GetPage(
//           name: EditRoomScreen.routeName,
//           page: () => EditRoomScreen(room: Get.arguments as Room),
//         ),
//         // Tambahkan route untuk BookingDetailScreen
//         GetPage(
//           name: '/booking-details',
//           page: () => BookingDetailScreen(bookingId: Get.arguments),
//         ),
//       ],
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:front/features/auth/presentation/screens/login_screen.dart';
import 'package:front/features/auth/presentation/screens/register_screen.dart';
import 'package:front/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:front/features/property/presentation/screens/add_property_screen.dart';
import 'package:front/features/property/presentation/screens/edit_property_screen.dart';
import 'package:front/features/property/presentation/screens/property_detail.dart';
import 'package:front/features/property/presentation/screens/property_list.dart';
import 'package:front/features/room/presentation/screens/room_list_screen.dart';
import 'package:front/features/room/presentation/screens/add_room_screen.dart';
import 'package:front/features/room/presentation/screens/edit_room_screen.dart';
import 'package:front/features/room/data/models/room_model.dart';
import 'package:front/features/dashboard/presentation/screens/users/button_navbar.dart';
import 'package:front/features/dashboard/presentation/screens/users/penyewa/booking_detail_screen.dart';
import 'package:front/features/wellcome/wellcome_page.dart'; // Import welcome page

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hommie App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/', // Ubah initial route ke welcome page
      getPages: [
        GetPage(name: '/', page: () => WelcomePage()), // Tambahkan welcome page
        GetPage(name: '/login', page: () => LoginScreen()),
        GetPage(name: '/register', page: () => RegisterScreen()),
        GetPage(name: '/dashboard', page: () => DashboardScreen()),
        GetPage(name: '/bottombar', page: () => BottomBar()),
        GetPage(
          name: '/manage_rooms',
          page: () => RoomListScreen(propertyId: Get.arguments as int),
        ),
        GetPage(
          name: PropertyListScreen.routeName,
          page: () => PropertyListScreen(),
        ),
        GetPage(
          name: PropertyDetailScreen.routeName,
          page: () => PropertyDetailScreen(),
        ),
        GetPage(
          name: AddPropertyScreen.routeName,
          page: () => AddPropertyScreen(),
        ),
        GetPage(
          name: EditPropertyScreen.routeName,
          page: () => EditPropertyScreen(
            property: Get.arguments as Map<String, dynamic>,
          ),
        ),
        GetPage(
          name: AddRoomScreen.routeName,
          page: () => AddRoomScreen(propertyId: Get.arguments as int),
        ),
        GetPage(
          name: EditRoomScreen.routeName,
          page: () => EditRoomScreen(room: Get.arguments as Room),
        ),
        // Tambahkan route untuk BookingDetailScreen
        GetPage(
          name: '/booking-details',
          page: () => BookingDetailScreen(bookingId: Get.arguments),
        ),
      ],
    );
  }
}