import 'package:intl/intl.dart';

/// Date-related utilities and formatting
class DateUtils {
  /// Format date to "MMM" format (e.g., "Jan", "Feb")
  static String formatMonthShort(DateTime date) {
    return DateFormat('MMM').format(date);
  }

  /// Format date to "MMMM" format (e.g., "January", "February")
  static String formatMonthLong(DateTime date) {
    return DateFormat('MMMM').format(date);
  }

  /// Format date to "dd MMM yyyy" format (e.g., "15 Jan 2024")
  static String formatDateShort(DateTime date) {
    return DateFormat('dd MMM yyyy').format(date);
  }

  /// Format date to "EEEE, dd MMM" format (e.g., "Monday, 15 Jan")
  static String formatDateWithDay(DateTime date) {
    return DateFormat('EEEE, dd MMM').format(date);
  }

  /// Get month year string (e.g., "January 2024")
  static String formatMonthYear(DateTime date) {
    return DateFormat('MMMM yyyy').format(date);
  }

  /// Check if two dates are in the same month
  static bool isSameMonth(DateTime date1, DateTime date2) {
    return date1.year == date2.year && date1.month == date2.month;
  }

  /// Get first day of month
  static DateTime getFirstDayOfMonth(DateTime date) {
    return DateTime(date.year, date.month, 1);
  }

  /// Get last day of month
  static DateTime getLastDayOfMonth(DateTime date) {
    return DateTime(date.year, date.month + 1, 0);
  }

  /// Get number of days in month
  static int daysInMonth(DateTime date) {
    return getLastDayOfMonth(date).day;
  }
}
