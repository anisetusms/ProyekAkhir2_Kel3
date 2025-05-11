import 'package:intl/intl.dart';

class FormatUtils {
  static String formatCurrency(dynamic value) {
    if (value == null) return 'Rp 0';
    
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    
    try {
      final numValue = value is String ? double.parse(value) : value;
      return formatter.format(numValue);
    } catch (e) {
      return 'Rp 0';
    }
  }

  static String formatNumber(dynamic value) {
    if (value == null) return '0';
    
    final formatter = NumberFormat.decimalPattern('id_ID');
    
    try {
      final numValue = value is String ? int.parse(value) : value;
      return formatter.format(numValue);
    } catch (e) {
      return '0';
    }
  }

  static String formatDateTime(dynamic dateTime) {
    if (dateTime == null) return '';
    
    try {
      final date = dateTime is String 
          ? DateTime.parse(dateTime) 
          : dateTime;
      
      return DateFormat('dd MMM yyyy, HH:mm').format(date);
    } catch (e) {
      return '';
    }
  }

  static String formatDate(dynamic date) {
    if (date == null) return '';
    
    try {
      final dateObj = date is String 
          ? DateTime.parse(date) 
          : date;
      
      return DateFormat('dd MMM yyyy').format(dateObj);
    } catch (e) {
      return '';
    }
  }

  static String getTimeAgo(dynamic dateTime) {
    if (dateTime == null) return '';
    
    try {
      final date = dateTime is String 
          ? DateTime.parse(dateTime) 
          : dateTime;
      
      final now = DateTime.now();
      final difference = now.difference(date);
      
      if (difference.inDays > 365) {
        return '${(difference.inDays / 365).floor()} tahun yang lalu';
      } else if (difference.inDays > 30) {
        return '${(difference.inDays / 30).floor()} bulan yang lalu';
      } else if (difference.inDays > 0) {
        return '${difference.inDays} hari yang lalu';
      } else if (difference.inHours > 0) {
        return '${difference.inHours} jam yang lalu';
      } else if (difference.inMinutes > 0) {
        return '${difference.inMinutes} menit yang lalu';
      } else {
        return 'Baru saja';
      }
    } catch (e) {
      return '';
    }
  }
}
