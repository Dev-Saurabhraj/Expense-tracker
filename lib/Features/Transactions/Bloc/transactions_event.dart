part of 'transactions_bloc.dart';

abstract class TransactionsEvent extends Equatable {
  const TransactionsEvent();

  @override
  List<Object> get props => [];
}

class LoadTransactions extends TransactionsEvent {}

class AddTransaction extends TransactionsEvent {
  final TransactionModel transaction;
  const AddTransaction(this.transaction);

  @override
  List<Object> get props => [transaction];
}

class DeleteTransaction extends TransactionsEvent {
  final String id;
  const DeleteTransaction(this.id);

  @override
  List<Object> get props => [id];
}

class SearchTransactions extends TransactionsEvent {
  final String query;
  const SearchTransactions(this.query);

  @override
  List<Object> get props => [query];
}

class FilterByCategory extends TransactionsEvent {
  final List<String> categories;
  const FilterByCategory(this.categories);

  @override
  List<Object> get props => [categories];
}

class ClearFilters extends TransactionsEvent {
  const ClearFilters();
}
