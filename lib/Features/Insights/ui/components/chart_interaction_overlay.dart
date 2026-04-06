import 'package:flutter/material.dart';
import '../../../../Core/Colors/app_colors.dart';
import '../../../../Core/Utils/chart_constants.dart';
import '../../../../Core/Utils/chart_calculations.dart';

/// Widget for rendering the vertical selection line and animated dot
class ChartInteractionOverlay extends StatelessWidget {
  final ScrollController scrollController;
  final List<double> expenses;
  final double maxY;
  final double pointSpacing;

  const ChartInteractionOverlay({
    required this.scrollController,
    required this.expenses,
    required this.maxY,
    required this.pointSpacing,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Vertical selection line
        Positioned(
          top: ChartConstants.verticalLineTopOffset,
          bottom: ChartConstants.verticalLineBottomOffset,
          child: Container(
            width: ChartConstants.verticalLineWidth,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(
                alpha: ChartConstants.primaryAlpha,
              ),
              borderRadius: BorderRadius.circular(
                ChartConstants.verticalLineRadius,
              ),
            ),
          ),
        ),
        // Animated dot at intersection
        AnimatedBuilder(
          animation: scrollController,
          builder: (context, child) {
            double exactIndex = 5.0;
            if (scrollController.hasClients) {
              exactIndex = ChartCalculations.calculateExactIndex(
                scrollController.offset,
                expenses.length,
              );
            }

            final yVal = ChartCalculations.interpolateYValue(
              exactIndex,
              expenses,
            );
            final topOffset = ChartCalculations.calculateTopOffset(yVal, maxY);

            return Positioned(
              top: topOffset,
              left: 0,
              right: 0,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: ChartConstants.dotColumnHeight),
                    Container(
                      width: ChartConstants.dotSize,
                      height: ChartConstants.dotSize,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.primary,
                          width: ChartConstants.dotBorderWidth,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
