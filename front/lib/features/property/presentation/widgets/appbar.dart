import 'package:flutter/material.dart';

PreferredSizeWidget homeAppBar(String title, bool showBack) {
  return AppBar(
    title: Text(
      title,
      style: const TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 20,
        color: Colors.white,
      ),
    ),
    centerTitle: true,
    backgroundColor: Colors.blue, // Ganti sesuai tema utama aplikasi
    elevation: 0,
    automaticallyImplyLeading: showBack,
  );
}
