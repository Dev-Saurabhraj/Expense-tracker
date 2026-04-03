import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../../../Core/Colors/app_colors.dart';
import '../../../Core/Constants/text_styles.dart';
import '../../../Core/Icons/app_icons.dart';
import '../../../Core/Widgets/custom_card.dart';
import '../Bloc/transactions_bloc.dart';
import 'widgets/shimmer_transaction_list.dart';
import 'widgets/transaction_item.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  static const int itemsPerPage = 10;
  int currentPage = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text('Transactions', style: AppTextStyles.h2),
        actions: [
          IconButton(
            icon: const Icon(AppIcons.add, color: AppColors.textPrimary),
            onPressed: () {
              context.push('/add-transaction');
            },
          ),
        ],
      ),
      body: BlocBuilder<TransactionsBloc, TransactionsState>(
        builder: (context, state) {
          if (state is TransactionsLoading) {
            return const ShimmerTransactionList(itemCount: 8);
          } else if (state is TransactionsLoaded) {
            if (state.transactions.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      AppIcons.transactions,
                      size: 48,
                      color: AppColors.border,
                    ),
                    const SizedBox(height: 16),
                    Text('No transactions yet', style: AppTextStyles.bodyLarge),
                  ],
                ),
              );
            }

            final totalItems = state.transactions.length;
            final totalPages = (totalItems / itemsPerPage).ceil();
            final startIndex = (currentPage - 1) * itemsPerPage;
            final endIndex = (startIndex + itemsPerPage).clamp(0, totalItems);
            final paginatedTransactions = state.transactions.sublist(
              startIndex,
              endIndex,
            );

            return Column(
              children: [
                Expanded(
                  child: AnimationLimiter(
                    child: ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: paginatedTransactions.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        return AnimationConfiguration.staggeredList(
                          position: index,
                          duration: const Duration(milliseconds: 375),
                          child: SlideAnimation(
                            verticalOffset: 50.0,
                            child: FadeInAnimation(
                              child: TransactionItem(
                                transaction: paginatedTransactions[index],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                // Pagination controls
                if (totalPages > 1)
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
                            backgroundColor: currentPage < totalPages
                                ? AppColors.primary
                                : AppColors.border,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            );
          }
          return const Center(child: Text('Error loading transactions'));
        },
      ),
    );
  }
}
