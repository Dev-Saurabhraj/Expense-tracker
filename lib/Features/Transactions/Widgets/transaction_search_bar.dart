import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../Core/Colors/app_colors.dart';
import '../../../Core/Constants/text_styles.dart';
import '../Bloc/transactions_bloc.dart';

class TransactionSearchBar extends StatefulWidget {
  const TransactionSearchBar({super.key});

  @override
  State<TransactionSearchBar> createState() => _TransactionSearchBarState();
}

class _TransactionSearchBarState extends State<TransactionSearchBar> {
  late TextEditingController _searchController;
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    setState(() {
      _isSearching = _searchController.text.isNotEmpty;
    });

    try {
      if (_searchController.text.isEmpty) {
        context.read<TransactionsBloc>().add(const SearchTransactions(''));
      } else {
        context.read<TransactionsBloc>().add(
          SearchTransactions(_searchController.text),
        );
      }
    } catch (e) {
      debugPrint('Search error: $e');
    }
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: TextField(
        controller: _searchController,
        style: AppTextStyles.bodyLarge,
        decoration: InputDecoration(
          hintText: 'Search transactions...',
          hintStyle: AppTextStyles.bodyLarge.copyWith(
            color: AppColors.textTertiary,
          ),
          prefixIcon: Icon(Icons.search, color: AppColors.textSecondary),
          suffixIcon: _isSearching
              ? IconButton(
                  icon: Icon(Icons.clear, color: AppColors.textSecondary),
                  onPressed: () {
                    _searchController.clear();
                    try {
                      context.read<TransactionsBloc>().add(
                        const ClearFilters(),
                      );
                    } catch (e) {
                      debugPrint('Clear filters error: $e');
                    }
                  },
                )
              : null,
          filled: true,
          fillColor: AppColors.surface,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 12,
            horizontal: 12,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
