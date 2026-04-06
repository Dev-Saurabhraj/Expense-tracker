import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../Core/Colors/app_colors.dart';
import '../../../Core/Constants/text_styles.dart';
import '../Bloc/transactions_bloc.dart';

class TransactionCategoryFilter extends StatelessWidget {
  final List<String> categories = const [
    'Food',
    'Transport',
    'Shopping',
    'Bills',
    'Salary',
    'Other',
  ];

  const TransactionCategoryFilter({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransactionsBloc, TransactionsState>(
      buildWhen: (previous, current) {
        return previous.runtimeType != current.runtimeType ||
            (current is TransactionsLoaded &&
                previous is TransactionsLoaded &&
                current.selectedCategories != previous.selectedCategories);
      },
      builder: (context, state) {
        final selectedCategories = state is TransactionsLoaded
            ? state.selectedCategories
            : <String>[];

        try {
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                const SizedBox(width: 4),
                ...categories.map((category) {
                  final isSelected = selectedCategories.contains(category);
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: FilterChip(
                      label: Text(category),
                      selected: isSelected,
                      onSelected: (_) {
                        try {
                          if (isSelected) {
                            final updated = List<String>.from(
                              selectedCategories,
                            )..remove(category);
                            if (updated.isEmpty) {
                              context.read<TransactionsBloc>().add(
                                const ClearFilters(),
                              );
                            } else {
                              context.read<TransactionsBloc>().add(
                                FilterByCategory(updated),
                              );
                            }
                          } else {
                            final updated = List<String>.from(
                              selectedCategories,
                            )..add(category);
                            context.read<TransactionsBloc>().add(
                              FilterByCategory(updated),
                            );
                          }
                        } catch (e) {
                          debugPrint('Category filter error: $e');
                        }
                      },
                      labelStyle: AppTextStyles.bodySmall.copyWith(
                        color: isSelected
                            ? AppColors.surface
                            : AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                      backgroundColor: AppColors.surface,
                      selectedColor: AppColors.primary,
                      side: BorderSide(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.border,
                      ),
                    ),
                  );
                }).toList(),
                const SizedBox(width: 4),
              ],
            ),
          );
        } catch (e) {
          debugPrint('Category filter widget build error: $e');
          return const SizedBox.shrink();
        }
      },
    );
  }
}
