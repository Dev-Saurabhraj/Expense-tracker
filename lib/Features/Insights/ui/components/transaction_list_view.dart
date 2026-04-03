import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../../../../Core/Colors/app_colors.dart';
import '../../../../Core/Constants/text_styles.dart';
import '../../../../Data/models/transaction_model.dart';
import '../../../Transactions/ui/widgets/transaction_item.dart';

/// Widget for displaying a list of transactions with animations
class TransactionListView extends StatelessWidget {
  final List<TransactionModel> transactions;
  final bool isEmpty;

  const TransactionListView({
    required this.transactions,
    required this.isEmpty,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Text(
            'No transactions this month',
            style: AppTextStyles.bodyMedium,
          ),
        ),
      );
    }

    return Column(
      children: List.generate(transactions.length, (index) {
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
                child: TransactionItem(transaction: transactions[index]),
              ),
            ),
          ),
        );
      }),
    );
  }
}
