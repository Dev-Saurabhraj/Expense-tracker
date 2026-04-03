import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../Data/models/transaction_model.dart';
import '../../../Data/repositories/finance_repository.dart';

part 'transactions_event.dart';
part 'transactions_state.dart';

class TransactionsBloc extends Bloc<TransactionsEvent, TransactionsState> {
  final FinanceRepository _repository;

  TransactionsBloc({required FinanceRepository repository})
      : _repository = repository,
        super(TransactionsInitial()) {
    on<LoadTransactions>(_onLoadTransactions);
    on<AddTransaction>(_onAddTransaction);
    on<DeleteTransaction>(_onDeleteTransaction);
  }

  Future<void> _onLoadTransactions(
      LoadTransactions event, Emitter<TransactionsState> emit) async {
    emit(TransactionsLoading());
    try {
      final transactions = await _repository.getTransactions();
      emit(TransactionsLoaded(transactions: transactions));
    } catch (e) {
      emit(TransactionsError(message: 'Failed to load transactions.'));
    }
  }

  Future<void> _onAddTransaction(
      AddTransaction event, Emitter<TransactionsState> emit) async {
    try {
      await _repository.saveTransaction(event.transaction);
      add(LoadTransactions());
    } catch (e) {
      emit(TransactionsError(message: 'Failed to add transaction.'));
    }
  }

  Future<void> _onDeleteTransaction(
      DeleteTransaction event, Emitter<TransactionsState> emit) async {
    try {
      await _repository.deleteTransaction(event.id);
      add(LoadTransactions());
    } catch (e) {
      emit(TransactionsError(message: 'Failed to delete transaction.'));
    }
  }
}
