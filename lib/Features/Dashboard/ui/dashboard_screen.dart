import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../../../Core/Colors/app_colors.dart';
import '../../../Core/Constants/text_styles.dart';
import '../Bloc/dashboard_bloc.dart';
import '../Widgets/balance_card.dart';
import '../Widgets/recent_transactions_list.dart';
import '../Widgets/pagination_controls.dart';
import '../../Transactions/ui/widgets/shimmer_transaction_list.dart';

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
                      BalanceCard(
                        balance: state.totalBalance,
                        income: state.totalIncome,
                        expense: state.totalExpense,
                      ),
                      const SizedBox(height: 32),
                      Text('Recent Transactions', style: AppTextStyles.h3),
                      const SizedBox(height: 16),
                      RecentTransactionsList(
                        transactions: paginatedTransactions,
                        isLoading: false,
                      ),
                      if (totalPages > 1) ...[
                        const SizedBox(height: 24),
                        PaginationControls(
                          currentPage: currentPage,
                          totalPages: totalPages,
                          onPreviousPressed: () {
                            setState(() {
                              currentPage--;
                            });
                          },
                          onNextPressed: () {
                            setState(() {
                              currentPage++;
                            });
                          },
                        ),
                      ],
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
