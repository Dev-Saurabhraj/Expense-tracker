import 'package:flutter/material.dart';
import '../../../../Core/Colors/app_colors.dart';
import '../../../../Core/Constants/text_styles.dart';

class EmptyGoalState extends StatelessWidget {
  final VoidCallback onSetGoalPressed;

  const EmptyGoalState({super.key, required this.onSetGoalPressed});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.emoji_events_rounded,
          size: 64,
          color: AppColors.textTertiary,
        ),
        const SizedBox(height: 16),
        Text(
          'You currently have no active monthly goal. Set one up to keep your savings on track!',
          textAlign: TextAlign.center,
          style: AppTextStyles.bodyLarge,
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: onSetGoalPressed,
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
          child: Text('Set Goal', style: AppTextStyles.buttonText),
        ),
      ],
    );
  }
}
