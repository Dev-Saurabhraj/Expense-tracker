import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../Core/Colors/app_colors.dart';
import '../../../Core/Constants/text_styles.dart';
import '../../../Core/Widgets/custom_button.dart';
import '../../../Core/Widgets/custom_card.dart';
import '../../../Core/Widgets/custom_textfield.dart';
import '../../../Data/models/goal_model.dart';
import '../Bloc/goals_bloc.dart';

class GoalsScreen extends StatelessWidget {
  const GoalsScreen({super.key});

  void _showSetGoalDialog(BuildContext context, double currentSavings, [GoalModel? existing]) {
    final controller = TextEditingController(text: existing?.targetAmount.toStringAsFixed(0) ?? '');
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: AppColors.surface,
          title: Text(existing == null ? 'Set Monthly Goal' : 'Update Goal', style: AppTextStyles.h3),
          content: CustomTextField(
            controller: controller,
            hintText: 'Target Amount (\$)',
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text('Cancel', style: AppTextStyles.bodyLarge),
            ),
            ElevatedButton(
              onPressed: () {
                final target = double.tryParse(controller.text);
                if (target != null && target > 0) {
                  final newGoal = GoalModel(
                    id: existing?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
                    name: 'Monthly Savings Focus',
                    targetAmount: target,
                    currentAmount: currentSavings,
                    monthYear: DateTime.now(),
                  );
                  context.read<GoalsBloc>().add(SaveGoal(newGoal));
                  Navigator.pop(ctx);
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
              child: Text('Save', style: AppTextStyles.buttonText),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text('Savings Challenge', style: AppTextStyles.h2),
      ),
      body: BlocBuilder<GoalsBloc, GoalsState>(
        builder: (context, state) {
          if (state is GoalsLoading) {
            return const Center(child: CircularProgressIndicator(color: AppColors.primary));
          } else if (state is GoalsLoaded) {
            final goal = state.goal;
            final savings = goal?.currentAmount ?? state.currentSavings;
            final target = goal?.targetAmount ?? 0.0;
            
            double progress = target > 0 ? (savings / target).clamp(0.0, 1.0) : 0;
            String header = goal == null ? 'Ready for a Challenge?' : 'Monthly Progress';

            return Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(header, style: AppTextStyles.h2),
                  const SizedBox(height: 8),
                  Text(
                    'Track your income against expenses to build a savings streak.',
                    style: AppTextStyles.bodyMedium,
                  ),
                  const SizedBox(height: 32),
                  CustomCard(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        if (goal != null) ...[
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
                              )
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
                                  Text('\$${savings.toStringAsFixed(2)}', style: AppTextStyles.h3),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text('Target', style: AppTextStyles.bodySmall),
                                  Text('\$${target.toStringAsFixed(2)}', style: AppTextStyles.h3),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          CustomButton(
                            text: 'Update Challenge Target',
                            isOutlined: true,
                            onPressed: () => _showSetGoalDialog(context, savings, goal),
                          ),
                        ] else ...[
                          Icon(Icons.emoji_events_rounded, size: 64, color: AppColors.textTertiary),
                          const SizedBox(height: 16),
                          Text(
                            'You currently have no active monthly goal. Set one up to keep your savings on track!',
                            textAlign: TextAlign.center,
                            style: AppTextStyles.bodyLarge,
                          ),
                          const SizedBox(height: 24),
                          CustomButton(
                            text: 'Set Goal',
                            onPressed: () => _showSetGoalDialog(context, savings),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
          return const Center(child: Text('Error loading goals'));
        },
      ),
    );
  }
}
