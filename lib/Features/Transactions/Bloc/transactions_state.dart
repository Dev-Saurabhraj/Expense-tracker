part of 'transactions_bloc.dart';

abstract class TransactionsState extends Equatable {
  const TransactionsState();

  @override
  List<Object> get props => [];
}

class TransactionsInitial extends TransactionsState {}

class TransactionsLoading extends TransactionsState {}

class TransactionsLoaded extends TransactionsState {
  final List<TransactionModel> transactions;
  final List<TransactionModel> allTransactions;
  final String searchQuery;
  final List<String> selectedCategories;

  const TransactionsLoaded({
    required this.transactions,
    required this.allTransactions,
    this.searchQuery = '',
    this.selectedCategories = const [],
  });

  @override
  List<Object> get props => [
    transactions,
    allTransactions,
    searchQuery,
    selectedCategories,
  ];
}

class TransactionsError extends TransactionsState {
  final String message;

  const TransactionsError({required this.message});

  @override
  List<Object> get props => [message];
}
