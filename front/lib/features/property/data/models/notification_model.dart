import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NotificationModel {
  final int id;
  final int userId;
  final String type;
  final String title;
  final String message;
  final int? referenceId;
  final bool isRead;
  final DateTime createdAt;
  final DateTime updatedAt;

  NotificationModel({
    required this.id,
    required this.userId,
    required this.type,
    required this.title,
    required this.message,
    this.referenceId,
    required this.isRead,
    required this.createdAt,
    required this.updatedAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'],
      userId: json['user_id'],
      type: json['type'],
      title: json['title'],
      message: json['message'],
      referenceId: json['reference_id'],
      isRead: json['is_read'] == 1 || json['is_read'] == true,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'type': type,
      'title': title,
      'message': message,
      'reference_id': referenceId,
      'is_read': isRead,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  // Helper untuk mendapatkan icon berdasarkan tipe notifikasi
  // Helper untuk mendapatkan icon berdasarkan tipe notifikasi
  IconData getIcon() {
    switch (type) {
      case 'booking_new':
        return Icons.book_online;
      case 'booking_confirmed':
        return Icons.check_circle;
      case 'booking_rejected':
        return Icons.cancel;
      case 'booking_completed':
        return Icons.done_all;
      default:
        return Icons.notifications;
    }
  }

  // Helper untuk mendapatkan warna berdasarkan tipe notifikasi
  Color getColor() {
    switch (type) {
      case 'booking_new':
        return Colors.blue;
      case 'booking_confirmed':
        return Colors.green;
      case 'booking_rejected':
        return Colors.red;
      case 'booking_completed':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  // Helper untuk mendapatkan waktu relatif (misalnya "5 menit yang lalu")
  String getRelativeTime() {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inDays > 7) {
      return DateFormat('dd MMM yyyy').format(createdAt);
    } else if (difference.inDays > 0) {
      return '${difference.inDays} hari yang lalu';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} jam yang lalu';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} menit yang lalu';
    } else {
      return 'Baru saja';
    }
  }
}
