import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../Core/Colors/app_colors.dart';
import '../../../Core/Constants/text_styles.dart';
import '../../../Core/Icons/app_icons.dart';
import '../Bloc/transactions_bloc.dart';
import 'widgets/shimmer_transaction_list.dart';
import '../Widgets/transactions_list.dart';
import '../Widgets/empty_transactions_state.dart';
import '../../../Features/Dashboard/Widgets/pagination_controls.dart';

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
              return const EmptyTransactionsState();
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
                TransactionsList(
                  transactions: paginatedTransactions,
                  isLoading: false,
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
            );
          }
          return const Center(child: Text('Error loading transactions'));
        },
      ),
    );
  }
        }