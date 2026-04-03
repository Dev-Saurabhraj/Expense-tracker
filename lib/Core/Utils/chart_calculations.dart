import 'chart_constants.dart';

/// Utility class for chart-related calculations
class ChartCalculations {
  /// Calculate Y value by interpolating between two points
  static double interpolateYValue(double exactIndex, List<double> expenses) {
    int lower = exactIndex.floor();
    int upper = exactIndex.ceil();

    if (lower < 0) lower = 0;
    if (upper >= expenses.length) upper = expenses.length - 1;

    if (lower == upper) {
      return expenses[lower];
    }

    final fraction = exactIndex - lower;
    return expenses[lower] + (expenses[upper] - expenses[lower]) * fraction;
  }

  /// Calculate vertical position offset on chart based on Y value
  static double calculateTopOffset(double yVal, double maxY) {
    final offset =
        ChartConstants.drawingAreaHeight -
        (yVal / maxY) * ChartConstants.drawingAreaHeight;
    return offset - ChartConstants.dotTopOffset;
  }

  /// Clamp offset to keep within bounds
  static double clampOffset(double offset) {
    return offset.clamp(0, ChartConstants.drawingAreaHeight);
  }

  /// Calculate exact index from scroll offset
  static double calculateExactIndex(double scrollOffset, int expensesLength) {
    double exactIndex = scrollOffset / ChartConstants.pointSpacing;
    final maxIndex = (expensesLength - 1).toDouble();

    if (exactIndex < 0) exactIndex = 0;
    if (exactIndex > maxIndex) exactIndex = maxIndex;

    return exactIndex;
  }

  /// Validate and constrain active index
  static int validateActiveIndex(double activeIndex) {
    int active = activeIndex.round();
    if (active < 0) active = 0;
    if (active > 5) active = 5;
    return active;
  }

  /// Calculate maximum Y value for chart
  static double calculateMaxY(List<double> expenses) {
    if (expenses.isEmpty) return 100;

    double maxY = expenses.reduce((a, b) => a > b ? a : b);
    if (maxY == 0) maxY = 100;

    return maxY * 1.2; // Add 20% padding
  }

  /// Generate FlSpot points from expenses
  static List<(double, double)> generateSpots(List<double> expenses) {
    return List.generate(expenses.length, (i) => (i.toDouble(), expenses[i]));
  }
}
