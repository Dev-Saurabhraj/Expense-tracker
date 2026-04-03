import 'package:flutter/material.dart';
import '../../../../Core/Colors/app_colors.dart';
import '../../../../Core/Constants/text_styles.dart';
import '../../../../Core/Widgets/custom_card.dart';

class GoalProgressCard extends StatelessWidget {
  final double currentAmount;
  final double targetAmount;
  final VoidCallback onUpdatePressed;

  const GoalProgressCard({
    super.key,
    required this.currentAmount,
    required this.targetAmount,
    required this.onUpdatePressed,
  });

  @override
  Widget build(BuildContext context) {
    double progress = targetAmount > 0
        ? (currentAmount / targetAmount).clamp(0.0, 1.0)
        : 0;

    return CustomCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 180,
                height: 180,
                child: CircularProgressIndicator(
                  value: progress > 0 ? progress : 0.01,
                  backgroundColor: AppColors.goalTrack,
                  color: AppColors.goalProgress,
                  strokeWidth: 12,
                  strokeCap: StrokeCap.round,
                ),
              ),
              Column(
                children: [
                  Text(
                    '${(progress * 100).toStringAsFixed(0)}%',
                    style: AppTextStyles.h1,
                  ),
                  Text('Saved', style: AppTextStyles.bodyMedium),
                ],
              ),
            ],
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Current', style: AppTextStyles.bodySmall),
                  Text(
                    '\$${currentAmount.toStringAsFixed(2)}',
                    style: AppTextStyles.h3,
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('Target', style: AppTextStyles.bodySmall),
                  Text(
                    '\$${targetAmount.toStringAsFixed(2)}',
                    style: AppTextStyles.h3,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: onUpdatePressed,
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            child: Text(
              'Update Challenge Target',
              style: AppTextStyles.buttonText,
            ),
          ),
        ],
      ),
    );
  }
}
