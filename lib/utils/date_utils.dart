import 'dart:math';

import 'utils_index.dart';
import 'package:intl/intl.dart';

/// date format,difference, remaining days,  today-yesterday-this-week-days ago-years-ago etc...
class MyDateUtils {
  static Duration? durationDifference(String? start, String? end) {
    if (start == null || end == null) {
      return null;
    }
    final startDate = DateTime.tryParse(start);
    final endDate = DateTime.tryParse(end);
    if (startDate == null || endDate == null) {
      if (startDate!.isBefore(DateTime.now())) {
        return null;
      }
      return null;
    }
    logger.i('startDate: $startDate endDate: $endDate');
    return endDate.difference(startDate);
  }

  /// Find time Difference in between [Today and the given date-time] in format of today, yesterday otherwise dd/MM/yyyy
  static String formatDateAsToday(dynamic dt,
      [String? format, bool getToday = false]) {
    DateTime? dateTime = dt is DateTime ? dt : DateTime.tryParse(dt ?? '');
    if (dateTime != null) {
      final now = DateTime.now();
      if (dateTime.year == now.year &&
          dateTime.month == now.month &&
          dateTime.day == now.day) {
        // If the date matches today, return the time in "jm" format
        return getToday ? 'Today' : formatDate(dateTime, "jm");
      } else if (dateTime.year == now.year &&
          dateTime.month == now.month &&
          dateTime.day == now.day - 1) {
        // If the date matches yesterday, return "Yesterday"
        return "Yesterday";
      } else {
        // For other dates, return the date in "dd/MM/yyyy" format
        return formatDate(dateTime, format ?? "dd MMMM yyyy");
      }
    }
    return 'Invalid Date';
  }

  /// Find [Time Difference] in between today and the given date-time
  static String getTimeDifference(dynamic d) {
    var date = d is DateTime ? d : DateTime.tryParse(d);
    if (date != null) {
      final now = DateTime.now();
      final difference = now.difference(date);
      if (difference.inDays > 365) {
        return '${difference.inDays ~/ 365} years ago';
      } else if (difference.inDays > 30) {
        return '${difference.inDays ~/ 30} months ago';
      } else if (difference.inDays > 7) {
        return '${difference.inDays ~/ 7} weeks ago';
      } else if (difference.inDays > 0) {
        return '${difference.inDays} days ago';
      } else if (difference.inHours > 0) {
        return '${difference.inHours} hours ago';
      } else if (difference.inMinutes > 0) {
        return '${difference.inMinutes} minutes ago';
      } else if (difference.inSeconds > 0) {
        return '${difference.inSeconds} seconds ago';
      } else {
        return 'Just now';
      }
    }
    return 'Invalid Date';
  }

  /// format a date with format of you choice
  static String formatDate(dynamic dateTime, [String? format]) {
    final formatter = DateFormat(format ?? 'dd MMM yyyy');
    return formatter
        .format(dateTime is DateTime ? dateTime : DateTime.parse(dateTime));
  }

  static DateTime randomDate([int days = 365]) {
    final random = Random();
    final currentDate = DateTime.now();
    final daysToSubtract = random.nextInt(days); // Maximum of 365 days
    final newDate = currentDate.subtract(Duration(days: daysToSubtract));
    return newDate;
  }

  // compare to dates are same and return boolean
  static bool isSameDay(dynamic date1, dynamic date2) {
    DateTime _date1 = date1 is DateTime ? date1 : DateTime.parse(date1);
    DateTime _date2 = date2 is DateTime ? date2 : DateTime.parse(date2);
    return _date1.day == _date2.day;
  }
}
