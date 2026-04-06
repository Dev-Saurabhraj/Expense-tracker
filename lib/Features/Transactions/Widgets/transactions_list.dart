import 'package:expense_tracker/Features/Transactions/widgets/transaction_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../../../../Data/models/transaction_model.dart';

class TransactionsList extends StatelessWidget {
  final List<TransactionModel> transactions;
  final bool isLoading;

  const TransactionsList({
    super.key,
    required this.transactions,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const SizedBox.shrink();
    }

    return Expanded(
      child: AnimationLimiter(
        child: ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: transactions.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            return AnimationConfiguration.staggeredList(
              position: index,
              duration: const Duration(milliseconds: 375),
              child: SlideAnimation(
                verticalOffset: 50.0,
                child: FadeInAnimation(
                  child: TransactionItem(transaction: transactions[index]),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
