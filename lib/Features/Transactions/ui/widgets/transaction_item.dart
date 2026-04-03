import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../Core/Colors/app_colors.dart';
import '../../../../Core/Constants/text_styles.dart';
import '../../../../Core/Icons/app_icons.dart';
import '../../../../Core/Widgets/custom_card.dart';
import '../../../../Data/models/transaction_model.dart';

class TransactionItem extends StatefulWidget {
  final TransactionModel transaction;
  final bool initiallyExpanded;

  const TransactionItem({
    super.key,
    required this.transaction,
    this.initiallyExpanded = false,
  });

  @override
  State<TransactionItem> createState() => _TransactionItemState();
}

class _TransactionItemState extends State<TransactionItem> {
  late bool _isExpanded;

  // Maximum word count for notes display
  static const int maxNotesWordCount = 50;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initiallyExpanded;
  }

  String _truncateNotes(String notes) {
    final words = notes.trim().split(RegExp(r'\s+'));
    if (words.length <= maxNotesWordCount) {
      return notes;
    }
    return '${words.take(maxNotesWordCount).join(' ')}...';
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'food':
        return AppIcons.food;
      case 'transport':
        return AppIcons.transport;
      case 'shopping':
        return AppIcons.shopping;
      case 'salary':
        return AppIcons.salary;
      default:
        return AppIcons.other;
    }
  }

  @override
  Widget build(BuildContext context) {
    final tx = widget.transaction;
    final isIncome = tx.type == TransactionType.income;
    final color = isIncome ? AppColors.income : AppColors.expense;
    final prefix = isIncome ? '+' : '-';

    return CustomCard(
      padding: EdgeInsets.zero,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          if (tx.notes.trim().isNotEmpty) {
            setState(() {
              _isExpanded = !_isExpanded;
            });
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Icon(
                      _getCategoryIcon(tx.category),
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(tx.title, style: AppTextStyles.bodyLarge),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Text(
                              DateFormat.yMMMd().format(tx.date),
                              style: AppTextStyles.bodySmall,
                            ),
                            if (tx.notes.trim().isNotEmpty) ...[
                              const SizedBox(width: 6),
                              Icon(
                                Icons.chat_bubble_outline,
                                size: 12,
                                color: AppColors.textTertiary,
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '$prefix\$${tx.amount.toStringAsFixed(2)}',
                    style: AppTextStyles.h3.copyWith(color: color),
                  ),
                ],
              ),
              AnimatedSize(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                child: _isExpanded && tx.notes.trim().isNotEmpty
                    ? Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(top: 16),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColors.border.withValues(alpha: 0.5),
                          ),
                        ),
                        child: Text(
                          _truncateNotes(tx.notes),
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textSecondary,
                            fontStyle: FontStyle.italic,
                          ),
                          maxLines: 5,
                          overflow: TextOverflow.ellipsis,
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
