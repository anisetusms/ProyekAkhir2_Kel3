import 'package:flutter/material.dart';

class ThemeConfig {
  // Warna utama aplikasi
  static const Color primaryColor = Color(0xFF4CAF50); 
  static const Color secondaryColor = Color(0xFF2196F3); 
  
  // Warna untuk tombol aksi
  static const Color addPropertyColor = Color(0xFF4CAF50); 
  static const Color viewPropertiesColor = Color(0xFF2196F3); 
  static const Color manageBookingsColor = Color(0xFF4CAF50); 
  
  // Warna untuk kartu statistik
  static const Color blueCardColor = Color(0xFFE3F2FD);
  static const Color greenCardColor = Color(0xFFE8F5E9);
  static const Color purpleCardColor = Color(0xFFF3E5F5);
  static const Color yellowCardColor = Color(0xFFFFF8E1);
  
  // Warna untuk status
  static const Color pendingColor = Color(0xFFFFA000); 
  static const Color confirmedColor = Color(0xFF4CAF50);
  static const Color completedColor = Color(0xFF2196F3); 
  static const Color cancelledColor = Color(0xFFF44336); 
  
  // Tema aplikasi
  static ThemeData getTheme() {
    return ThemeData(
      primaryColor: primaryColor,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        primary: primaryColor,
        secondary: secondaryColor,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryColor,
          side: BorderSide(color: primaryColor),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryColor,
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        selectedItemColor: primaryColor,
        unselectedItemColor: Colors.grey[600],
      ),
    );
  }
}