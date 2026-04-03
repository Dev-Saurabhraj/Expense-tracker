import '../Utils/number_utils.dart';

/// Number extension methods for formatting and calculations
extension NumExtensions on num {
  /// Convert to currency string
  String get toCurrency => NumberUtils.toCurrency(toDouble());

  /// Format with commas (e.g., 1000 -> "1,000")
  String get formatted => NumberUtils.formatWithCommas(toDouble());

  /// Format as currency with commas
  String get formattedCurrency =>
      NumberUtils.formatCurrencyWithCommas(toDouble());

  /// Get percentage of total
  String getPercentage(num total) {
    return NumberUtils.formatPercentage(
      NumberUtils.calculatePercentage(toDouble(), total.toDouble()),
    );
  }

  /// Clamp between min and max
  num clamp(num min, num max) {
    return NumberUtils.clamp(toDouble(), min.toDouble(), max.toDouble());
  }

  /// Check if number is positive
  bool get isPositive => this > 0;

  /// Check if number is negative
  bool get isNegative => this < 0;

  /// Check if number is zero
  bool get isZero => this == 0;
}
