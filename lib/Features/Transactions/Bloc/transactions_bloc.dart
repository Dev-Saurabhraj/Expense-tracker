import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../Data/models/transaction_model.dart';
import '../../../Data/repositories/finance_repository.dart';

part 'transactions_event.dart';
part 'transactions_state.dart';

class TransactionsBloc extends Bloc<TransactionsEvent, TransactionsState> {
  final FinanceRepository _repository;
  String _searchQuery = '';
  List<String> _selectedCategories = [];

  TransactionsBloc({required FinanceRepository repository})
    : _repository = repository,
      super(TransactionsInitial()) {
    on<LoadTransactions>(_onLoadTransactions);
    on<AddTransaction>(_onAddTransaction);
    on<DeleteTransaction>(_onDeleteTransaction);
    on<SearchTransactions>(_onSearchTransactions);
    on<FilterByCategory>(_onFilterByCategory);
    on<ClearFilters>(_onClearFilters);
  }

  Future<void> _onLoadTransactions(
    LoadTransactions event,
    Emitter<TransactionsState> emit,
  ) async {
    emit(TransactionsLoading());
    try {
      final transactions = await _repository.getTransactions();
      _applyFilters(emit, transactions);
    } catch (e) {
      emit(TransactionsError(message: 'Failed to load transactions.'));
    }
  }

  Future<void> _onAddTransaction(
    AddTransaction event,
    Emitter<TransactionsState> emit,
  ) async {
    try {
      await _repository.saveTransaction(event.transaction);
      add(LoadTransactions());
    } catch (e) {
      emit(TransactionsError(message: 'Failed to add transaction.'));
    }
  }

  Future<void> _onDeleteTransaction(
    DeleteTransaction event,
    Emitter<TransactionsState> emit,
  ) async {
    try {
      await _repository.deleteTransaction(event.id);
      add(LoadTransactions());
    } catch (e) {
      emit(TransactionsError(message: 'Failed to delete transaction.'));
    }
  }

  Future<void> _onSearchTransactions(
    SearchTransactions event,
    Emitter<TransactionsState> emit,
  ) async {
    _searchQuery = event.query;
    try {
      final transactions = await _repository.getTransactions();
      _applyFilters(emit, transactions);
    } catch (e) {
      emit(TransactionsError(message: 'Failed to search transactions.'));
    }
  }

  Future<void> _onFilterByCategory(
    FilterByCategory event,
    Emitter<TransactionsState> emit,
  ) async {
    _selectedCategories = event.categories;
    try {
      final transactions = await _repository.getTransactions();
      _applyFilters(emit, transactions);
    } catch (e) {
      emit(TransactionsError(message: 'Failed to filter transactions.'));
    }
  }

  Future<void> _onClearFilters(
    ClearFilters event,
    Emitter<TransactionsState> emit,
  ) async {
    _searchQuery = '';
    _selectedCategories = [];
    try {
      final transactions = await _repository.getTransactions();
      _applyFilters(emit, transactions);
    } catch (e) {
      emit(TransactionsError(message: 'Failed to clear filters.'));
    }
  }

  void _applyFilters(
    Emitter<TransactionsState> emit,
    List<TransactionModel> allTransactions,
  ) {
    var filtered = allTransactions;

    // Apply category filter
    if (_selectedCategories.isNotEmpty) {
      filtered = filtered
          .where((tx) => _selectedCategories.contains(tx.category))
          .toList();
    }

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      filtered = filtered
          .where(
            (tx) =>
                tx.title.toLowerCase().contains(query) ||
                tx.category.toLowerCase().contains(query) ||
                tx.notes.toLowerCase().contains(query),
          )
          .toList();
    }

    emit(
      TransactionsLoaded(
        transactions: filtered,
        allTransactions: allTransactions,
        searchQuery: _searchQuery,
        selectedCategories: _selectedCategories,
      ),
    );
  }
}
