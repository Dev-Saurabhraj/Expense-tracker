import 'package:flutter/material.dart';
import '../../../../Core/Colors/app_colors.dart';
import '../../../../Core/Constants/text_styles.dart';
import '../../../../Core/Utils/chart_constants.dart';

/// Widget for displaying the current selected amount
class AmountDisplay extends StatelessWidget {
  final String monthLabel;
  final double amount;

  const AmountDisplay({
    required this.monthLabel,
    required this.amount,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            monthLabel,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 4),
          AnimatedSwitcher(
            duration: ChartConstants.animationDuration,
            transitionBuilder: (child, animation) => FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 0.2),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              ),
            ),
            child: Text(
              '\$${amount.toStringAsFixed(0)}',
              key: ValueKey(amount),
              textAlign: TextAlign.center,
              style: AppTextStyles.h2.copyWith(
                fontWeight: FontWeight.w800,
                fontSize: 36,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
