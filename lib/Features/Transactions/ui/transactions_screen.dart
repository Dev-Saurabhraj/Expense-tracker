import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../Core/Colors/app_colors.dart';
import '../../../Core/Constants/text_styles.dart';
import '../../../Core/Icons/app_icons.dart';
import '../Bloc/transactions_bloc.dart';
import '../widgets/shimmer_transaction_list.dart';
import '../widgets/transactions_list.dart';
import '../../../Features/Dashboard/Widgets/pagination_controls.dart';
import '../../../Data/models/transaction_model.dart';
import '../widgets/transaction_search_bar.dart';
import '../widgets/transaction_category_filter.dart';

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
          try {
            if (state is TransactionsLoading) {
              return const ShimmerTransactionList(itemCount: 8);
            } else if (state is TransactionsLoaded) {
              final List<TransactionModel> transactions = state.transactions;
              final String searchQuery = state.searchQuery;
              final List<String> selectedCategories = state.selectedCategories;

              // Build filtered list display
              final totalItems = transactions.length;
              final totalPages = totalItems == 0
                  ? 1
                  : (totalItems / itemsPerPage).ceil();
              final startIndex = (currentPage - 1) * itemsPerPage;
              final endIndex = (startIndex + itemsPerPage).clamp(0, totalItems);
              final List<TransactionModel> paginatedTransactions =
                  totalItems == 0
                  ? []
                  : transactions.sublist(startIndex, endIndex);

              return Column(
                children: [
                  // ── Search Bar ──────────────────────────────────────────
                  const TransactionSearchBar(),

                  // ── Category Filter Chips ────────────────────────────────
                  const TransactionCategoryFilter(),

                  // ── Results Counter ──────────────────────────────────────
                  if (searchQuery.isNotEmpty || selectedCategories.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Found ${transactions.length} ${transactions.length == 1 ? 'transaction' : 'transactions'}',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ),

                  // ── Empty State or Transaction List ─────────────────────
                  if (transactions.isEmpty)
                    Expanded(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.search_off,
                              size: 48,
                              color: AppColors.textTertiary,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              searchQuery.isNotEmpty ||
                                      selectedCategories.isNotEmpty
                                  ? 'No matching transactions found'
                                  : 'No transactions yet',
                              style: AppTextStyles.bodyLarge.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    Expanded(
                      child: Column(
                        children: [
                          Expanded(
                            child: TransactionsList(
                              transactions: paginatedTransactions,
                              isLoading: false,
                            ),
                          ),
                          if (totalPages > 1)
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
                      ),
                    ),
                ],
              );
            } else if (state is TransactionsError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 48,
                      color: AppColors.expense,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Error loading transactions',
                      style: AppTextStyles.bodyLarge.copyWith(
                        color: AppColors.expense,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      state.message,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            }

            return Center(
              child: Text(
                'Unknown state',
                style: AppTextStyles.bodyLarge.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            );
          } catch (e) {
            debugPrint('Transactions screen error: $e');
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 48, color: AppColors.expense),
                  const SizedBox(height: 16),
                  Text(
                    'An error occurred',
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: AppColors.expense,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    e.toString(),
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
