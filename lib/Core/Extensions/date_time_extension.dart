/// Extension methods for DateTime
extension DateTimeExtension on DateTime {
  /// Check if date is in the same month and year
  bool isSameMonth(DateTime other) {
    return year == other.year && month == other.month;
  }

  /// Get month abbreviation (Jan, Feb, etc.)
  String getMonthAbbreviation() {
    const monthNames = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return monthNames[month - 1];
  }
}
