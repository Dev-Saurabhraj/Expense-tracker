import 'package:intl/intl.dart';


class DateUtils {

  static String formatMonthShort(DateTime date) {
    return DateFormat('MMM').format(date);
  }


  static String formatMonthLong(DateTime date) {
    return DateFormat('MMMM').format(date);
  }


  static String formatDateShort(DateTime date) {
    return DateFormat('dd MMM yyyy').format(date);
  }


  static String formatDateWithDay(DateTime date) {
    return DateFormat('EEEE, dd MMM').format(date);
  }

  static String formatMonthYear(DateTime date) {
    return DateFormat('MMMM yyyy').format(date);
  }


  static bool isSameMonth(DateTime date1, DateTime date2) {
    return date1.year == date2.year && date1.month == date2.month;
  }


  static DateTime getFirstDayOfMonth(DateTime date) {
    return DateTime(date.year, date.month, 1);
  }


  static DateTime getLastDayOfMonth(DateTime date) {
    return DateTime(date.year, date.month + 1, 0);
  }


  static int daysInMonth(DateTime date) {
    return getLastDayOfMonth(date).day;
  }
}
