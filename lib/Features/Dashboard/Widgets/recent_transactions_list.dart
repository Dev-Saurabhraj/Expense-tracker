import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../../../../Core/Constants/text_styles.dart';
import '../../Transactions/ui/widgets/transaction_item.dart';
import '../../../../Data/models/transaction_model.dart';

class RecentTransactionsList extends StatelessWidget {
  final List<TransactionModel> transactions;
  final bool isLoading;

  const RecentTransactionsList({
    super.key,
    required this.transactions,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const SizedBox(height: 300);
    }

    if (transactions.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Text('No recent activity', style: AppTextStyles.bodyMedium),
        ),
      );
    }

    return Column(
      children: AnimationConfiguration.toStaggeredList(
        duration: const Duration(milliseconds: 375),
        childAnimationBuilder: (widget) => SlideAnimation(
          verticalOffset: 50.0,
          child: FadeInAnimation(child: widget),
        ),
        children: transactions
            .map(
              (tx) => Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: TransactionItem(transaction: tx),
              ),
            )
            .toList(),
      ),
    );
  }
}
