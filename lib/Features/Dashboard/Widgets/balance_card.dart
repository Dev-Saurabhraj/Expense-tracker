import 'package:flutter/material.dart';
import '../../../../Core/Colors/app_colors.dart';
import '../../../../Core/Constants/text_styles.dart';
import '../../../../Core/Icons/app_icons.dart';
import '../../../../Core/Widgets/custom_card.dart';

class BalanceCard extends StatelessWidget {
  final double balance;
  final double income;
  final double expense;

  const BalanceCard({
    super.key,
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
