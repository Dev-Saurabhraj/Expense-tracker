import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../Core/Colors/app_colors.dart';
import '../../../Core/Constants/text_styles.dart';
import '../../../Core/Icons/app_icons.dart';
import '../../../Core/Widgets/custom_card.dart';
import '../../../Data/models/transaction_model.dart';
import '../Bloc/transactions_bloc.dart';

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

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text('Delete Transaction', style: AppTextStyles.h3),
        content: Text(
          'Are you sure you want to delete this transaction?',
          style: AppTextStyles.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: Text('Cancel', style: AppTextStyles.bodyLarge.copyWith(color: AppColors.textSecondary)),
          ),
          TextButton(
            onPressed: () {
              context.read<TransactionsBloc>().add(DeleteTransaction(widget.transaction.id));
              context.pop();
            },
            child: Text('Delete', style: AppTextStyles.bodyLarge.copyWith(color: AppColors.expense)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tx = widget.transaction;
    final isIncome = tx.type == TransactionType.income;
    final color = isIncome ? AppColors.income : AppColors.expense;
    final prefix = isIncome ? '+' : '-';

    return CustomCard(
      padding: EdgeInsets.zero,
      child: GestureDetector(
        onLongPress: () => _showDeleteConfirmation(context),
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '$prefix\$${tx.amount.toStringAsFixed(2)}',
                        style: AppTextStyles.h3.copyWith(color: color),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            height: 32,
                            width: 32,
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              iconSize: 18,
                              icon: Icon(Icons.edit, color: AppColors.textSecondary),
                              onPressed: () {
                                context.push('/edit-transaction', extra: tx);
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          SizedBox(
                            height: 32,
                            width: 32,
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              iconSize: 18,
                              icon: Icon(Icons.delete_outline, color: AppColors.expense),
                              onPressed: () => _showDeleteConfirmation(context),
                            ),
                          ),
                        ],
                      ),
                    ],
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
    ));
  }
}
