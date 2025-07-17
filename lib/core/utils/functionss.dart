 import 'package:intl/intl.dart';

String formatDateTime(DateTime dateTime, {String format = 'MMM d, yyyy hh:mm a'}) {
  final DateFormat formatter = DateFormat(format);
  return formatter.format(dateTime);
}


  String formatDateTimeFromString(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return formatDateTime(
        date, format: 'dd MMM yyyy'
      );
    } catch (e) {
      return dateString;
    }
  }