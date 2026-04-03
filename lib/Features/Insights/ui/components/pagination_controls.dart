import 'package:flutter/material.dart';
import '../../../../Core/Colors/app_colors.dart';
import '../../../../Core/Constants/text_styles.dart';
import '../../../../Core/Widgets/custom_card.dart';

/// Widget for pagination controls
class PaginationControls extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  const PaginationControls({
    required this.currentPage,
    required this.totalPages,
    required this.onPrevious,
    required this.onNext,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton.icon(
            onPressed: currentPage > 1 ? onPrevious : null,
            icon: const Icon(Icons.chevron_left),
            label: const Text('Previous'),
            style: ElevatedButton.styleFrom(
              backgroundColor: currentPage > 1
                  ? AppColors.primary
                  : AppColors.border,
            ),
          ),
          const SizedBox(width: 16),
          CustomCard(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Text(
              'Page $currentPage of $totalPages',
              style: AppTextStyles.bodyMedium,
            ),
          ),
          const SizedBox(width: 16),
          ElevatedButton.icon(
            onPressed: currentPage < totalPages ? onNext : null,
            icon: const Icon(Icons.chevron_right),
            label: const Text('Next'),
            style: ElevatedButton.styleFrom(
              backgroundColor: currentPage < totalPages
                  ? AppColors.primary
                  : AppColors.border,
            ),
          ),
        ],
      ),
    );
  }
}
