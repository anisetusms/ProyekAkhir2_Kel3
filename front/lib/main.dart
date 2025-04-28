import 'package:flutter/material.dart';
import 'package:front/features/auth/presentation/screens/login_screen.dart';
import 'package:front/features/auth/presentation/screens/register_screen.dart';
import 'package:front/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:front/features/property/presentation/screens/add_property_screen.dart';
import 'package:front/features/property/presentation/screens/edit_property_screen.dart'; // Pastikan ini ada
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
    return MaterialApp(
      title: 'Hommie App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/dashboard': (context) => DashboardScreen(),
        '/bottombar': (context) => BottomBar(),
        '/manage_rooms': (context) => RoomListScreen(propertyId: ModalRoute.of(context)?.settings.arguments as int),
        PropertyListScreen.routeName: (context) => PropertyListScreen(),
        PropertyDetailScreen.routeName: (context) => PropertyDetailScreen(),
        AddPropertyScreen.routeName: (context) => AddPropertyScreen(),
        EditPropertyScreen.routeName: (context) => EditPropertyScreen(
              // Sekarang menerima Map<String, dynamic>
              property: ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>,
            ),
        AddRoomScreen.routeName: (context) => AddRoomScreen(propertyId: ModalRoute.of(context)?.settings.arguments as int),
        EditRoomScreen.routeName: (context) => EditRoomScreen(room: ModalRoute.of(context)?.settings.arguments as Room),
      },
    );
  }
}