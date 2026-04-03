import '../Utils/date_utils.dart';

/// DateTime extension methods for convenient date operations
extension DateTimeExtensions on DateTime {
  /// Get month name in short format (e.g., "Jan")
  String get monthNameShort => DateUtils.formatMonthShort(this);

  /// Get month name in long format (e.g., "January")
  String get monthNameLong => DateUtils.formatMonthLong(this);

  /// Get formatted date string (e.g., "15 Jan 2024")
  String get dateString => DateUtils.formatDateShort(this);

  /// Get formatted date with day (e.g., "Monday, 15 Jan")
  String get dateWithDayString => DateUtils.formatDateWithDay(this);

  /// Get month and year (e.g., "January 2024")
  String get monthYearString => DateUtils.formatMonthYear(this);

  /// Check if this date is today
  bool get isToday {
    final today = DateTime.now();
    return year == today.year && month == today.month && day == today.day;
  }

  /// Check if this date is yesterday
  bool get isYesterday {
    final yesterday = DateTime.now().subtract(Duration(days: 1));
    return year == yesterday.year &&
        month == yesterday.month &&
        day == yesterday.day;
  }

  /// Check if this date is in the current week
  bool get isThisWeek {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek.add(Duration(days: 7));
    return isAfter(startOfWeek) && isBefore(endOfWeek);
  }

  /// Check if this date is in the current month
  bool get isThisMonth {
    final now = DateTime.now();
    return year == now.year && month == now.month;
  }

  /// Get start of day
  DateTime get startOfDay => DateTime(year, month, day);

  /// Get end of day
  DateTime get endOfDay => DateTime(year, month, day, 23, 59, 59, 999);

  /// Add months to date
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

  /// Subtract months from date
  DateTime subtractMonths(int months) => addMonths(-months);
}
