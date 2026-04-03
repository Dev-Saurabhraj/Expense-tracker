/// Constants for chart-related calculations and configurations
class ChartConstants {
  // Chart dimensions
  static const double chartHeight = 250.0;
  static const double bottomReservedSize = 50.0;
  static const double drawingAreaHeight = chartHeight - bottomReservedSize;

  // Point spacing and sizing
  static const double pointSpacing = 80.0;
  static const double dotSize = 18.0;
  static const double dotBorderWidth = 3.0;
  static const double lineWidth = 4.0;

  // Vertical line
  static const double verticalLineWidth = 35.0;
  static const double verticalLineRadius = 17.5;
  static const double verticalLineTopOffset = 20.0;
  static const double verticalLineBottomOffset = 35.0;

  // Dot positioning
  static const double dotTopOffset = -42.0;
  static const double dotColumnHeight = 35.0;

  // Animation durations
  static const Duration animationDuration = Duration(milliseconds: 300);
  static const Duration staggeredAnimationDuration = Duration(
    milliseconds: 375,
  );

  // Grid and spacing
  static const double gridBorderAlpha = 0.5;
  static const double primaryAlpha = 0.1;

  // Typography
  static const double activeLabelFontSize = 13.0;
  static const double inactiveLabelFontSize = 12.0;
  static const double labelHorizontalPadding = 12.0;
  static const double labelVerticalPadding = 3.0;
  static const double labelBorderRadius = 12.0;

  // Month label spacing
  static const double monthLabelSpace = 25.0;
}
