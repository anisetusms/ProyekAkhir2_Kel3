import 'package:flutter/material.dart';
import 'package:front/features/auth/presentation/screens/login_screen.dart';
import 'package:front/features/auth/presentation/screens/register_screen.dart';
import 'package:front/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:front/features/property/presentation/screens/add_property_screen.dart';
import 'package:front/features/property/presentation/screens/edit_property_screen.dart';
import 'package:front/features/property/presentation/screens/property_detail.dart';
import 'package:front/features/property/presentation/screens/property_list.dart';

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
        PropertyListScreen.routeName: (context) => PropertyListScreen(),
        PropertyDetailScreen.routeName: (context) => PropertyDetailScreen(),
        AddPropertyScreen.routeName: (context) => AddPropertyScreen(),
        EditPropertyScreen.routeName: (context) => EditPropertyScreen(propertyId: ModalRoute.of(context)?.settings.arguments as int?,),
      },
    );
  }
}
