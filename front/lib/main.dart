import 'package:flutter/material.dart';
import 'package:get/get.dart'; // Tambahkan impor ini
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
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
<<<<<<< Updated upstream
    return MaterialApp(
=======
    return GetMaterialApp(
      // Ganti MaterialApp dengan GetMaterialApp
      debugShowCheckedModeBanner: false,
>>>>>>> Stashed changes
      title: 'Hommie App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/login',
      getPages: [
        // Ganti routes dengan getPages untuk GetX
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
          page:
              () => EditPropertyScreen(
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
      ],
      // Untuk navigasi yang masih menggunakan ModalRoute, tambahkan juga routes biasa
      routes: {
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
<<<<<<< Updated upstream
        '/dashboard': (context) => DashboardScreen(),
        '/bottombar': (context) => BottomBar(),
        '/manage_rooms': (context) => RoomListScreen(propertyId: ModalRoute.of(context)?.settings.arguments as int),
        PropertyListScreen.routeName: (context) => PropertyListScreen(),
        PropertyDetailScreen.routeName: (context) => PropertyDetailScreen(),
        AddPropertyScreen.routeName: (context) => AddPropertyScreen(),
        EditPropertyScreen.routeName: (context) => EditPropertyScreen(propertyId: ModalRoute.of(context)?.settings.arguments as int?,),
        AddRoomScreen.routeName: (context) => AddRoomScreen(propertyId: ModalRoute.of(context)?.settings.arguments as int),
        EditRoomScreen.routeName: (context) => EditRoomScreen(room: ModalRoute.of(context)?.settings.arguments as Room),
=======
>>>>>>> Stashed changes
      },
    );
  }
}
