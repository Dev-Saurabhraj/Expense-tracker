import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../../../Core/Colors/app_colors.dart';
import '../../../Core/Constants/text_styles.dart';
import '../../../Core/Widgets/custom_card.dart';
import '../../../Data/models/transaction_model.dart';
import '../../Transactions/ui/widgets/transaction_item.dart';
import '../Bloc/insights_bloc.dart';

/// Holds the result of the mathematical intersection computation.
class _IntersectionResult {
  const _IntersectionResult({required this.yData, required this.topPx});

  /// Interpolated spend value in data units (dollars).
  final double yData;

  /// Pixel distance from the top of the chart drawing area to the intersection.
  final double topPx;
}

class InsightsScreen extends StatefulWidget {
  const InsightsScreen({super.key});

  @override
  State<InsightsScreen> createState() => _InsightsScreenState();
}

class _InsightsScreenState extends State<InsightsScreen> {
  final ScrollController _scrollController = ScrollController();

  /// The month index (0–5) whose label is currently highlighted in the chart.
  int _activeIndex = 5;

  // ── Pagination ────────────────────────────────────────────────────────────
  static const int _itemsPerPage = 8;
  int _currentPage = 1;

  // ── Chart layout constants ─────────────────────────────────────────────────

  static const double _pointSpacing = 80.0;

  /// Total height of the fl_chart SizedBox (drawing area + labels).
  static const double _chartTotalHeight = 250.0;

  /// Height reserved by fl_chart for the bottom-axis labels.
  static const double _labelsReservedHeight = 50.0;

  /// Height of the actual drawing area (where the line lives).
  /// Drawing area: top = maxY, bottom = 0.
  static const double _drawingAreaHeight =
      _chartTotalHeight - _labelsReservedHeight; // 200 px

  // ── Life-cycle ────────────────────────────────────────────────────────────

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);

    // After first layout, jump to the most-recent month (rightmost point).
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  void _onScroll() {
    // Snap the active-index to the nearest integer data point.
    int active = (_scrollController.offset / _pointSpacing).round().clamp(0, 5);
    if (_activeIndex != active) {
      setState(() {
        _activeIndex = active;
        _currentPage = 1;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  //
  _IntersectionResult _computeIntersection(
    List<double> expenses,
    double maxY,
  ) {
    // Exact fractional index where the viewport center sits.
    final double exactIndex = _scrollController.hasClients
        ? (_scrollController.offset / _pointSpacing)
            .clamp(0.0, (expenses.length - 1).toDouble())
        : _activeIndex.toDouble();

    final int lower = exactIndex.floor().clamp(0, expenses.length - 1);
    final int upper = exactIndex.ceil().clamp(0, expenses.length - 1);

    // Linear interpolation (line equation between the two bracketing points).
    final double yData = (lower == upper)
        ? expenses[lower]
        : expenses[lower] +
            (expenses[upper] - expenses[lower]) * (exactIndex - lower);

    // Map from data space → pixel space.
    final double topPx = _drawingAreaHeight * (1.0 - yData / maxY);

    return _IntersectionResult(yData: yData, topPx: topPx);
  }



  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    final double horizontalPadding = (screenWidth + 32) / 2;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text('Insights', style: AppTextStyles.h2),
      ),
      body: BlocBuilder<InsightsBloc, InsightsState>(
        builder: (context, state) {
          if (state is InsightsLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          if (state is InsightsLoaded) {
            final expenses = state.dailyExpenses;
            final months = state.sortedDays;
            final transactions = state.transactions;

            // Max Y with 20 % headroom so the highest bar never clips.
            double maxY = expenses.isEmpty
                ? 100
                : expenses.reduce((a, b) => a > b ? a : b);
            if (maxY == 0) maxY = 100;
            maxY *= 1.2;

            // fl_chart data points: (monthIndex, monthSpend).
            final List<FlSpot> spots = [
              for (int i = 0; i < expenses.length; i++)
                FlSpot(i.toDouble(), expenses[i]),
            ];

            // Transactions for the currently snapped month.
            final activeMonthAnchor = months[_activeIndex];
            final activeTransactions = transactions
                .where(
                  (tx) =>
                      tx.date.year == activeMonthAnchor.year &&
                      tx.date.month == activeMonthAnchor.month,
                )
                .toList();

            return CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                // ── Large monthly-spend header (outside the chart card) ──────
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Month name label
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 250),
                          child: Text(
                            state.weekLabels[_activeIndex],
                            key: ValueKey('label_$_activeIndex'),
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.textSecondary,
                              letterSpacing: 1.4,
                              fontSize: 18
                            ),
                          ),
                        ),
                        // Bold spend amount — fade+slide on month change
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          transitionBuilder: (child, animation) =>
                              FadeTransition(
                                opacity: animation,
                                child: SlideTransition(
                                  position: Tween<Offset>(
                                    begin: const Offset(0, 0.25),
                                    end: Offset.zero,
                                  ).animate(animation),
                                  child: child,
                                ),
                              ),
                          child: Text(
                            '\$${expenses[_activeIndex].toStringAsFixed(0)}',
                            key: ValueKey('spend_$_activeIndex'),
                            textAlign: TextAlign.center,
                            style: AppTextStyles.h2.copyWith(
                              fontWeight: FontWeight.w800,
                              fontSize: 38,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // ── Chart card ───────────────────────────────────────────────
                SliverToBoxAdapter(
                  child: CustomCard(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    padding: const EdgeInsets.only(top: 24, bottom: 16),
                    child: Stack(
                      alignment: Alignment.center,

                      clipBehavior: Clip.none,
                      children: [

                        SingleChildScrollView(
                          controller: _scrollController,
                          scrollDirection: Axis.horizontal,
                          physics: const ClampingScrollPhysics(),
                          child: Padding(
                            padding: EdgeInsets.only(
                              left: horizontalPadding - 32,
                              right: horizontalPadding - 32,
                            ),
                            child: SizedBox(
                              width: _pointSpacing * 5,
                              height: _chartTotalHeight,
                              child: LineChart(
                                LineChartData(
                                  gridData: FlGridData(
                                    show: true,
                                    drawVerticalLine: false,
                                    horizontalInterval:
                                        maxY / 4 == 0 ? 1 : maxY / 4,
                                    getDrawingHorizontalLine: (_) => FlLine(
                                      color: AppColors.border.withValues(
                                        alpha: 0.45,
                                      ),
                                      strokeWidth: 1,
                                    ),
                                  ),
                                  titlesData: FlTitlesData(
                                    show: true,
                                    rightTitles: const AxisTitles(
                                      sideTitles:
                                          SideTitles(showTitles: false),
                                    ),
                                    topTitles: const AxisTitles(
                                      sideTitles:
                                          SideTitles(showTitles: false),
                                    ),
                                    leftTitles: const AxisTitles(
                                      sideTitles:
                                          SideTitles(showTitles: false),
                                    ),
                                    bottomTitles: AxisTitles(
                                      sideTitles: SideTitles(
                                        showTitles: true,
                                        reservedSize: _labelsReservedHeight,
                                        interval: 1,
                                        getTitlesWidget: (value, meta) {
                                          final int index = value.toInt();
                                          if (index < 0 ||
                                              index >= state.weekLabels.length) {
                                            return const SizedBox.shrink();
                                          }
                                          final bool isActive =
                                              index == _activeIndex;
                                          return SideTitleWidget(
                                            meta: meta,
                                            space: 15,
                                            child: AnimatedContainer(
                                              duration: const Duration(
                                                  milliseconds: 300),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 12,
                                                vertical: 3,
                                              ),
                                              decoration: BoxDecoration(
                                                color: isActive
                                                    ? Colors.black
                                                    : Colors.transparent,
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              child: Text(
                                                state.weekLabels[index],
                                                style: AppTextStyles.bodySmall
                                                    .copyWith(
                                                  color: isActive
                                                      ? Colors.white
                                                      : AppColors.textSecondary,
                                                  fontWeight: isActive
                                                      ? FontWeight.bold
                                                      : FontWeight.normal,
                                                  fontSize:
                                                      isActive ? 13 : 12,
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
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
                                      barWidth: 4,
                                      isStrokeCapRound: true,
                                      dotData: const FlDotData(show: false),
                                    ),
                                  ],
                                  lineTouchData:
                                      const LineTouchData(enabled: false),
                                ),
                              ),
                            ),
                          ),
                        ),

                        // ── Pill-shaped vertical selection indicator ─────────
                        Positioned(
                          top: 20,
                          bottom: _labelsReservedHeight -15,
                          child: Container(
                            width: 32,
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ),

                        AnimatedBuilder(
                          animation: _scrollController,
                          builder: (context, _) {
                            const double dotDiameter = 18.0;
                            const double dotRadius = dotDiameter / 2;
                            const double badgeHeight = 30.0;
                            const double gap = 4.0;

                            final _IntersectionResult result =
                                _computeIntersection(expenses, maxY);

                            // Column top so dot-center lands exactly on the line.
                            final double colTop =
                                result.topPx - badgeHeight - gap - dotRadius;

                            return Positioned(
                              top: colTop,
                              left: 0,
                              right: 0,
                              child: Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    // Value badge
                                    SizedBox(height: 35,),

                                    Container(
                                      width: dotDiameter,
                                      height: dotDiameter,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: AppColors.primary,
                                          width: 3,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: AppColors.primary
                                                .withValues(alpha: 0.3),
                                            blurRadius: 8,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),

                // ── Transactions header ──────────────────────────────────────
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 28, 16, 16),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 250),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '${state.weekLabels[_activeIndex]} Transactions',
                          key: ValueKey('txhdr_$_activeIndex'),
                          style: AppTextStyles.h3,
                        ),
                      ),
                    ),
                  ),
                ),

                // ── Transaction list ─────────────────────────────────────────
                if (activeTransactions.isEmpty)
                  SliverToBoxAdapter(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: Text(
                          'No transactions this month',
                          style: AppTextStyles.bodyMedium,
                        ),
                      ),
                    ),
                  )
                else
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        ...List.generate(
                          _getPaginatedTransactions(activeTransactions).length,
                          (index) {
                            final tx = _getPaginatedTransactions(
                              activeTransactions,
                            )[index];
                            return AnimationConfiguration.staggeredList(
                              position: index,
                              duration: const Duration(milliseconds: 375),
                              child: SlideAnimation(
                                verticalOffset: 50.0,
                                child: FadeInAnimation(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0,
                                      vertical: 6.0,
                                    ),
                                    child: TransactionItem(transaction: tx),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        if (_getTotalPages(activeTransactions) > 1)
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton.icon(
                                  onPressed: _currentPage > 1
                                      ? () =>
                                          setState(() => _currentPage--)
                                      : null,
                                  icon: const Icon(Icons.chevron_left),
                                  label: const Text('Previous'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: _currentPage > 1
                                        ? AppColors.primary
                                        : AppColors.border,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                CustomCard(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                  child: Text(
                                    'Page $_currentPage of '
                                    '${_getTotalPages(activeTransactions)}',
                                    style: AppTextStyles.bodyMedium,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                ElevatedButton.icon(
                                  onPressed: _currentPage <
                                          _getTotalPages(activeTransactions)
                                      ? () =>
                                          setState(() => _currentPage++)
                                      : null,
                                  icon: const Icon(Icons.chevron_right),
                                  label: const Text('Next'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: _currentPage <
                                            _getTotalPages(activeTransactions)
                                        ? AppColors.primary
                                        : AppColors.border,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),

                const SliverToBoxAdapter(child: SizedBox(height: 40)),
              ],
            );
          }

          return const Center(child: Text('Error loading insights'));
        },
      ),
    );
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  List<TransactionModel> _getPaginatedTransactions(
    List<TransactionModel> transactions,
  ) {
    final int totalPages = _getTotalPages(transactions);
    if (_currentPage > totalPages) _currentPage = totalPages;
    final int start = (_currentPage - 1) * _itemsPerPage;
    final int end = (start + _itemsPerPage).clamp(0, transactions.length);
    return transactions.sublist(start, end);
  }

  int _getTotalPages(List<TransactionModel> transactions) {
    return (transactions.length / _itemsPerPage).ceil();
  }
}
