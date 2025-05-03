import 'package:intl/intl.dart';

class FormatUtils {
  static String formatNumber(dynamic number) {
    final formatter = NumberFormat('#,###');
    if (number is int || number is double) {
      return formatter.format(number);
    } else if (number is String) {
      final parsed = int.tryParse(number) ?? double.tryParse(number);
      if (parsed != null) {
        return formatter.format(parsed);
      }
    }
    return number.toString();
  }

  static String formatDateTime(String? dateString) {
    if (dateString == null) return '-';
    try {
      final dateTime = DateTime.parse(dateString);
      return DateFormat('dd MMM yyyy, HH:mm').format(dateTime);
    } catch (e) {
      return dateString;
    }
  }

  static String formatCurrency(dynamic amount) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp',
      decimalDigits: 0,
    );
    if (amount is int || amount is double) {
      return formatter.format(amount);
    } else if (amount is String) {
      final parsed = int.tryParse(amount) ?? double.tryParse(amount);
      if (parsed != null) {
        return formatter.format(parsed);
      }
    }
    return amount.toString();
  }
}