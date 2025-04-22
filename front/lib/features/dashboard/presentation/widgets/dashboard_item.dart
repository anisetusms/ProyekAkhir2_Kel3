import 'package:flutter/material.dart';

class DashboardItem extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const DashboardItem({
    Key? key,
    required this.title,
    required this.value,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(icon, size: 32.0, color: Theme.of(context).primaryColor),
              SizedBox(height: 8.0),
              Text(title, textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 4.0),
              Text(value, style: TextStyle(fontSize: 18.0)),
            ],
          ),
        ),
      ),
    );
  }
}