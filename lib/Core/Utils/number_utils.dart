/// Number formatting and calculation utilities
class NumberUtils {
  /// Format number to currency format
  static String toCurrency(double amount) {
    return '\$${amount.toStringAsFixed(2)}';
  }

  /// Format number with commas (e.g., 1000 -> "1,000")
  static String formatWithCommas(double number) {
    return number
        .toStringAsFixed(0)
        .replaceAllMapped(
          RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
        );
  }

  /// Format currency with commas
  static String formatCurrencyWithCommas(double amount) {
    final formatted = formatWithCommas(amount);
    final decimals = (amount % 1).toStringAsFixed(2).substring(1);
    return '\$$formatted$decimals';
  }

  /// Calculate percentage
  static double calculatePercentage(double value, double total) {
    if (total == 0) return 0;
    return (value / total) * 100;
  }

  /// Format percentage with symbol
  static String formatPercentage(double percentage) {
    return '${percentage.toStringAsFixed(1)}%';
  }

  /// Round to nearest whole number
  static double roundToNearest(double value) {
    return (value).round().toDouble();
  }

  /// Clamp value between min and max
  static double clamp(double value, double min, double max) {
    return value < min ? min : (value > max ? max : value);
  }
}
