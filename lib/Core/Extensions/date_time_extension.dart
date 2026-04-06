
extension DateTimeExtension on DateTime {

  bool isSameMonth(DateTime other) {
    return year == other.year && month == other.month;
  }


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
