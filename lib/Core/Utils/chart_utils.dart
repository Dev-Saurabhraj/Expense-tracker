/// Chart-related utilities and calculations
class ChartUtils {
  // Chart dimensions
  static const double chartHeight = 250.0;
  static const double bottomReservedSize = 50.0;

  // Point spacing and sizing
  static const double pointSpacing = 80.0;
  static const double dotSize = 18.0;
  static const double lineWidth = 4.0;

  /// Calculate maximum Y value for chart scaling
  static double calculateMaxY(List<double> values) {
    if (values.isEmpty) return 100.0;

    final max = values.reduce((a, b) => a > b ? a : b);
    if (max == 0) return 100.0;

    // Round up to nearest nice number
    final rounded = (max * 1.2).ceil();
    return (rounded / 4).ceil() * 4.0;
  }

  /// Generate chart spots from expense data
  static List<(double x, double y)> generateSpots(List<double> expenses) {
    return List.generate(
      expenses.length,
      (index) => (index.toDouble(), expenses[index]),
    );
  }

  /// Format currency for display
  static String formatCurrency(double amount) {
    return '\$${amount.toStringAsFixed(2)}';
  }
}
