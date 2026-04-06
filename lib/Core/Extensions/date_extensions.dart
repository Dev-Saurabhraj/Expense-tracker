import '../Utils/date_utils.dart';

/// DateTime methods
extension DateTimeExtensions on DateTime {
  /// month name in short format 
  String get monthNameShort => DateUtils.formatMonthShort(this);

  /// month name in long format
  String get monthNameLong => DateUtils.formatMonthLong(this);

  /// Get formatted date string
  String get dateString => DateUtils.formatDateShort(this);

  /// Get formatted date with day
  String get dateWithDayString => DateUtils.formatDateWithDay(this);

  /// Get month and year
  String get monthYearString => DateUtils.formatMonthYear(this);

  
  bool get isToday {
    final today = DateTime.now();
    return year == today.year && month == today.month && day == today.day;
  }

  ///if  date is yesterday
  bool get isYesterday {
    final yesterday = DateTime.now().subtract(Duration(days: 1));
    return year == yesterday.year &&
        month == yesterday.month &&
        day == yesterday.day;
  }

  /// is current  week
  bool get isThisWeek {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek.add(Duration(days: 7));
    return isAfter(startOfWeek) && isBefore(endOfWeek);
  }

  /// is current month
  bool get isThisMonth {
    final now = DateTime.now();
    return year == now.year && month == now.month;
  }

  /// Get start of day
  DateTime get startOfDay => DateTime(year, month, day);

  /// Get end of day
  DateTime get endOfDay => DateTime(year, month, day, 23, 59, 59, 999);

  
  DateTime addMonths(int months) {
    var newMonth = month + months;
    var newYear = year;

    while (newMonth > 12) {
      newMonth -= 12;
      newYear++;
    }
    while (newMonth < 1) {
      newMonth += 12;
      newYear--;
    }

    return DateTime(newYear, newMonth, day);
  }

  
  DateTime subtractMonths(int months) => addMonths(-months);
}
