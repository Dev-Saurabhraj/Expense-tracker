import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../Core/Colors/app_colors.dart';
import '../../../Core/Constants/text_styles.dart';
import '../../../Core/Widgets/custom_button.dart';
import '../../../Core/Widgets/custom_textfield.dart';
import '../../../Data/models/transaction_model.dart';
import '../Bloc/transactions_bloc.dart';

class AddTransactionScreen extends StatefulWidget {
  final TransactionModel? transaction;

  const AddTransactionScreen({super.key, this.transaction});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _notesController = TextEditingController();

  late TransactionType _selectedType;
  late String _selectedCategory;
  late DateTime _selectedDate;
  late bool _isEditMode;

  final List<String> _categories = [
    'Food',
    'Transport',
    'Shopping',
    'Bills',
    'Salary',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    _isEditMode = widget.transaction != null;

    if (_isEditMode) {
      final tx = widget.transaction!;
      _titleController.text = tx.title;
      _amountController.text = tx.amount.toString();
      _notesController.text = tx.notes;
      _selectedType = tx.type;
      _selectedCategory = tx.category;
      _selectedDate = tx.date;
    } else {
      _selectedType = TransactionType.expense;
      _selectedCategory = 'Food';
      _selectedDate = DateTime.now();
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _saveTransaction() {
    if (_formKey.currentState!.validate()) {
      final tx = _isEditMode ? widget.transaction! : null;
      final newTx = TransactionModel(
        id: tx?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text,
        amount: double.parse(_amountController.text),
        type: _selectedType,
        category: _selectedCategory,
        date: tx?.date ?? _selectedDate,
        notes: _notesController.text,
      );

      context.read<TransactionsBloc>().add(AddTransaction(newTx));
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text(
          _isEditMode ? 'Edit Transaction' : 'New Transaction',
          style: AppTextStyles.h2,
        ),
        leading: const BackButton(color: AppColors.textPrimary),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: _TypeSelector(
                      title: 'Expense',
                      isSelected: _selectedType == TransactionType.expense,
                      onTap: () => setState(
                        () => _selectedType = TransactionType.expense,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _TypeSelector(
                      title: 'Income',
                      isSelected: _selectedType == TransactionType.income,
                      onTap: () => setState(
                        () => _selectedType = TransactionType.income,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              CustomTextField(
                controller: _titleController,
                hintText: 'Title',
                validator: (val) =>
                    val == null || val.isEmpty ? 'Please enter a title' : null,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _amountController,
                hintText: 'Amount',
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                validator: (val) {
                  if (val == null || val.isEmpty)
                    return 'Please enter an amount';
                  if (double.tryParse(val) == null)
                    return 'Please enter a valid number';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              _buildCategoryDropdown(),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _notesController,
                hintText: 'Notes (Optional)',
                maxLines: 3,
              ),
              const SizedBox(height: 48),
              CustomButton(
                text: _isEditMode ? 'Update Transaction' : 'Save Transaction',
                onPressed: _saveTransaction,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedCategory,
          isExpanded: true,
          dropdownColor: AppColors.surface,
          style: AppTextStyles.bodyLarge,
          items: _categories.map((String value) {
            return DropdownMenuItem<String>(value: value, child: Text(value));
          }).toList(),
          onChanged: (newValue) {
            setState(() {
              _selectedCategory = newValue!;
            });
          },
        ),
      ),
    );
  }
}

class _TypeSelector extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const _TypeSelector({
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          title,
          style: AppTextStyles.bodyLarge.copyWith(
            color: isSelected ? AppColors.surface : AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
