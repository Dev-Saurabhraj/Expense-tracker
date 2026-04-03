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

class InsightsScreen extends StatefulWidget {
  const InsightsScreen({super.key});

  @override
  State<InsightsScreen> createState() => _InsightsScreenState();
}

class _InsightsScreenState extends State<InsightsScreen> {
  final ScrollController _scrollController = ScrollController();
  int _activeIndex = 5;

  // Pagination
  static const int itemsPerPage = 8;
  int currentPage = 1;

  // Define spacing between charted points
  final double _pointSpacing = 80.0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);

    // Jump to the end (most recent month) after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  void _onScroll() {
    // Calculate which index is currently at the center
    // Offset represents how much we have scrolled left.
    int active = (_scrollController.offset / _pointSpacing).round();
    if (active < 0) active = 0;
    if (active > 5) active = 5;

    if (_activeIndex != active) {
      setState(() {
        _activeIndex = active;
        currentPage = 1; // Reset pagination when month changes
      });
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    // Padding needed so the first and last point can sit exactly in the center
    final horizontalPadding = screenWidth / 1.9;

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
          } else if (state is InsightsLoaded) {
            final expenses = state.dailyExpenses;
            final months = state.sortedDays;
            final transactions = state.transactions;

            // max Y for the graph
            double maxY = expenses.isEmpty
                ? 100
                : expenses.reduce((a, b) => a > b ? a : b);
            if (maxY == 0) maxY = 100;
            maxY = maxY * 1.2;

            List<FlSpot> spots = [];
            for (int i = 0; i < expenses.length; i++) {
              spots.add(FlSpot(i.toDouble(), expenses[i]));
            }

            // Filter transactions for the active month
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
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text('6-Month Trend', style: AppTextStyles.h3),
                  ),
                ),
                SliverToBoxAdapter(
                  child: CustomCard(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    padding: const EdgeInsets.only(top: 32, bottom: 40),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // The scrolling Chart
                        SingleChildScrollView(
                          controller: _scrollController,
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          child: Padding(
                            // Paddings ensure 0 index and max index can reach center
                            padding: EdgeInsets.only(
                              left: horizontalPadding - 32,
                              right: horizontalPadding - 32,
                            ),
                            child: SizedBox(
                              width:
                                  _pointSpacing * 5, // 6 points = 5 intervals
                              height: 250,
                              child: LineChart(
                                LineChartData(
                                  gridData: FlGridData(
                                    show: true,
                                    drawVerticalLine: false,
                                    horizontalInterval: maxY / 4 == 0
                                        ? 1
                                        : maxY / 4,
                                    getDrawingHorizontalLine: (value) => FlLine(
                                      color: AppColors.border.withValues(
                                        alpha: 0.5,
                                      ),
                                      strokeWidth: 1,
                                    ),
                                  ),
                                  titlesData: FlTitlesData(
                                    show: true,
                                    rightTitles: const AxisTitles(
                                      sideTitles: SideTitles(showTitles: false),
                                    ),
                                    topTitles: const AxisTitles(
                                      sideTitles: SideTitles(showTitles: false),
                                    ),
                                    leftTitles: const AxisTitles(
                                      sideTitles: SideTitles(showTitles: false),
                                    ),
                                    bottomTitles: AxisTitles(
                                      sideTitles: SideTitles(
                                        showTitles: true,
                                        reservedSize: 50,
                                        interval: 1,
                                        getTitlesWidget: (value, meta) {
                                          final index = value.toInt();
                                          if (index < 0 ||
                                              index >=
                                                  state.weekLabels.length) {
                                            return const SizedBox.shrink();
                                          }
                                          // Highlight the active month in a black box
                                          final isActive =
                                              index == _activeIndex;
                                          return SideTitleWidget(
                                            meta: meta,
                                            space: 8,
                                            child: AnimatedContainer(
                                              duration: const Duration(
                                                milliseconds: 300,
                                              ),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 12,
                                                    vertical: 6,
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
                                                          : AppColors
                                                                .textSecondary,
                                                      fontWeight: isActive
                                                          ? FontWeight.bold
                                                          : FontWeight.normal,
                                                      fontSize: isActive
                                                          ? 13
                                                          : 12,
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
                                      isCurved: true,
                                      color: AppColors.primary,
                                      barWidth: 4,
                                      isStrokeCapRound: true,
                                      dotData: FlDotData(
                                        show: true,
                                        checkToShowDot: (spot, barData) {
                                          // ONLY show dot on the currently active intersecting index
                                          return spot.x == _activeIndex;
                                        },
                                        getDotPainter:
                                            (spot, percent, barData, index) =>
                                                FlDotCirclePainter(
                                                  radius: 6,
                                                  color: Colors.white,
                                                  strokeWidth: 4,
                                                  strokeColor:
                                                      AppColors.primary,
                                                ),
                                      ),
                                    ),
                                  ],
                                  lineTouchData: const LineTouchData(
                                    enabled: false,
                                  ), // Disable manual touch
                                ),
                              ),
                            ),
                          ),
                        ),
                        // The Permanent Vertical Selection Bar (Above the chart)
                        Positioned(
                          top: 0,
                          bottom: 60, // Increased to keep it above month labels
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            width: 35,
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(17.5),
                            ),
                          ),
                        ),

                        Positioned(
                          top: 0,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.05),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 300),
                              child: Text(
                                '\$${expenses[_activeIndex].toStringAsFixed(0)}',
                                key: ValueKey(_activeIndex),
                                style: AppTextStyles.h3.copyWith(
                                  color: AppColors.primary,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 32, 16, 16),
                    child: Text(
                      '${state.weekLabels[_activeIndex]} Transactions',
                      style: AppTextStyles.h3,
                    ),
                  ),
                ),
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
                        // Transactions list
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
                        // Pagination controls
                        if (_getTotalPages(activeTransactions) > 1)
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton.icon(
                                  onPressed: currentPage > 1
                                      ? () {
                                          setState(() {
                                            currentPage--;
                                          });
                                        }
                                      : null,
                                  icon: const Icon(Icons.chevron_left),
                                  label: const Text('Previous'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: currentPage > 1
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
                                    'Page $currentPage of ${_getTotalPages(activeTransactions)}',
                                    style: AppTextStyles.bodyMedium,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                ElevatedButton.icon(
                                  onPressed:
                                      currentPage <
                                          _getTotalPages(activeTransactions)
                                      ? () {
                                          setState(() {
                                            currentPage++;
                                          });
                                        }
                                      : null,
                                  icon: const Icon(Icons.chevron_right),
                                  label: const Text('Next'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        currentPage <
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

  List<TransactionModel> _getPaginatedTransactions(
    List<TransactionModel> transactions,
  ) {
    final totalPages = _getTotalPages(transactions);
    if (currentPage > totalPages) {
      currentPage = totalPages;
    }
    final startIndex = (currentPage - 1) * itemsPerPage;
    final endIndex = (startIndex + itemsPerPage).clamp(0, transactions.length);
    return transactions.sublist(startIndex, endIndex);
  }

  int _getTotalPages(List<TransactionModel> transactions) {
    return (transactions.length / itemsPerPage).ceil();
  }
}
