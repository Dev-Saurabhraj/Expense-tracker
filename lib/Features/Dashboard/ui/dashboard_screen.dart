import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../Core/Colors/app_colors.dart';
import '../../../Core/Constants/text_styles.dart';
import '../../../Core/Icons/app_icons.dart';
import '../../../Core/Widgets/custom_card.dart';
import '../../Transactions/ui/widgets/shimmer_transaction_list.dart';
import '../../Transactions/ui/widgets/transaction_item.dart';
import '../Bloc/dashboard_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  static const int itemsPerPage = 6;
  int currentPage = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text('Overview', style: AppTextStyles.h2),
      ),
      body: BlocBuilder<DashboardBloc, DashboardState>(
        builder: (context, state) {
          if (state is DashboardLoading) {
            return const ShimmerTransactionList(itemCount: 4);
          } else if (state is DashboardLoaded) {
            final totalItems = state.recentTransactions.length;
            final totalPages = (totalItems / itemsPerPage).ceil();
            final startIndex = (currentPage - 1) * itemsPerPage;
            final endIndex = (startIndex + itemsPerPage).clamp(0, totalItems);
            final paginatedTransactions = state.recentTransactions.sublist(
              startIndex,
              endIndex,
            );

            return AnimationLimiter(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: AnimationConfiguration.toStaggeredList(
                    duration: const Duration(milliseconds: 375),
                    childAnimationBuilder: (widget) => SlideAnimation(
                      verticalOffset: 50.0,
                      child: FadeInAnimation(child: widget),
                    ),
                    children: [
                      _BalanceCard(
                        balance: state.totalBalance,
                        income: state.totalIncome,
                        expense: state.totalExpense,
                      ),
                      const SizedBox(height: 32),
                      Text('Recent Transactions', style: AppTextStyles.h3),
                      const SizedBox(height: 16),
                      if (state.recentTransactions.isEmpty)
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(32.0),
                            child: Text(
                              'No recent activity',
                              style: AppTextStyles.bodyMedium,
                            ),
                          ),
                        )
                      else
                        Column(
                          children: [
                            ...paginatedTransactions.map(
                              (tx) => Padding(
                                padding: const EdgeInsets.only(bottom: 12.0),
                                child: TransactionItem(transaction: tx),
                              ),
                            ),
                            if (totalPages > 1) ...[
                              const SizedBox(height: 24),
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
                                        'Page $currentPage of $totalPages',
                                        style: AppTextStyles.bodyMedium,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    ElevatedButton.icon(
                                      onPressed: currentPage < totalPages
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
                                            currentPage < totalPages
                                            ? AppColors.primary
                                            : AppColors.border,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ],
                        ),
                    ],
                  ),
                ),
              ),
            );
          }
          return const Center(child: Text('Error loading dashboard'));
        },
      ),
    );
  }
}

class _BalanceCard extends StatelessWidget {
  final double balance;
  final double income;
  final double expense;

  const _BalanceCard({
    required this.balance,
    required this.income,
    required this.expense,
  });

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      backgroundColor: AppColors.primary,
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Total Balance',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.surface.withOpacity(0.8),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '\$${balance.toStringAsFixed(2)}',
            style: AppTextStyles.h1.copyWith(
              color: AppColors.surface,
              fontSize: 40,
            ),
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStat(title: 'Income', amount: income, isIncome: true),
              _buildStat(title: 'Expenses', amount: expense, isIncome: false),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStat({
    required String title,
    required double amount,
    required bool isIncome,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.surface.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            isIncome ? AppIcons.income : AppIcons.expense,
            color: AppColors.surface,
            size: 16,
          ),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.surface.withOpacity(0.8),
              ),
            ),
            Text(
              '\$${amount.toStringAsFixed(2)}',
              style: AppTextStyles.bodyLarge.copyWith(color: AppColors.surface),
            ),
          ],
        ),
      ],
    );
  }
}
