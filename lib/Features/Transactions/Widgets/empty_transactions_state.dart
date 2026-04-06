import 'package:flutter/material.dart';
import '../../../Core/Constants/text_styles.dart';
import '../../../Core/Icons/app_icons.dart';
import '../../../Core/Colors/app_colors.dart';

class EmptyTransactionsState extends StatelessWidget {
  const EmptyTransactionsState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(AppIcons.transactions, size: 48, color: AppColors.border),
          const SizedBox(height: 16),
          Text('No transactions yet', style: AppTextStyles.bodyLarge),
        ],
      ),
    );
  }
}
