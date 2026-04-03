import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../../Core/Colors/app_colors.dart';
import '../../../../Core/Constants/text_styles.dart';
import '../../../../Core/Utils/chart_constants.dart';
import '../../../../Core/Utils/chart_calculations.dart';

/// Widget for rendering the expense trend chart
class ExpenseTrendChart extends StatelessWidget {
  final List<double> expenses;
  final List<String> monthLabels;
  final int activeIndex;
  final ScrollController scrollController;
  final double maxY;
  final double horizontalPadding;
  final Function(int) onActiveIndexChanged;

  const ExpenseTrendChart({
    required this.expenses,
    required this.monthLabels,
    required this.activeIndex,
    required this.scrollController,
    required this.maxY,
    required this.horizontalPadding,
    required this.onActiveIndexChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final spots = ChartCalculations.generateSpots(
      expenses,
    ).map((spot) => FlSpot(spot.$1, spot.$2)).toList();

    return SingleChildScrollView(
      controller: scrollController,
      scrollDirection: Axis.horizontal,
      physics: const ClampingScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.only(
          left: horizontalPadding - 32,
          right: horizontalPadding - 32,
        ),
        child: SizedBox(
          width: ChartConstants.pointSpacing * 5,
          height: ChartConstants.chartHeight,
          child: LineChart(
            LineChartData(
              gridData: _buildGridData(),
              titlesData: _buildTitlesData(),
              borderData: FlBorderData(show: false),
              minX: 0,
              maxX: 5,
              minY: 0,
              maxY: maxY,
              lineBarsData: [
                LineChartBarData(
                  spots: spots,
                  isCurved: false,
                  color: AppColors.primary,
                  barWidth: ChartConstants.lineWidth,
                  isStrokeCapRound: true,
                  dotData: const FlDotData(show: false),
                ),
              ],
              lineTouchData: const LineTouchData(enabled: false),
            ),
          ),
        ),
      ),
    );
  }

  FlGridData _buildGridData() {
    return FlGridData(
      show: true,
      drawVerticalLine: false,
      horizontalInterval: maxY / 4 == 0 ? 1 : maxY / 4,
      getDrawingHorizontalLine: (value) => FlLine(
        color: AppColors.border.withValues(
          alpha: ChartConstants.gridBorderAlpha,
        ),
        strokeWidth: 1,
      ),
    );
  }

  FlTitlesData _buildTitlesData() {
    return FlTitlesData(
      show: true,
      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: ChartConstants.bottomReservedSize,
          interval: 1,
          getTitlesWidget: (value, meta) {
            final index = value.toInt();
            if (index < 0 || index >= monthLabels.length) {
              return const SizedBox.shrink();
            }

            final isActive = index == activeIndex;
            return SideTitleWidget(
              meta: meta,
              space: ChartConstants.monthLabelSpace,
              child: AnimatedContainer(
                duration: ChartConstants.animationDuration,
                padding: const EdgeInsets.symmetric(
                  horizontal: ChartConstants.labelHorizontalPadding,
                  vertical: ChartConstants.labelVerticalPadding,
                ),
                decoration: BoxDecoration(
                  color: isActive ? Colors.black : Colors.transparent,
                  borderRadius: BorderRadius.circular(
                    ChartConstants.labelBorderRadius,
                  ),
                ),
                child: Text(
                  monthLabels[index],
                  style: AppTextStyles.bodySmall.copyWith(
                    color: isActive ? Colors.white : AppColors.textSecondary,
                    fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                    fontSize: isActive
                        ? ChartConstants.activeLabelFontSize
                        : ChartConstants.inactiveLabelFontSize,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
