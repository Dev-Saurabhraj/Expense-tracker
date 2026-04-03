import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../Data/models/transaction_model.dart';
import '../../../Data/repositories/finance_repository.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final FinanceRepository _repository;

  DashboardBloc({required FinanceRepository repository})
      : _repository = repository,
        super(DashboardInitial()) {
    on<LoadDashboard>(_onLoadDashboard);
  }

  Future<void> _onLoadDashboard(LoadDashboard event, Emitter<DashboardState> emit) async {
    emit(DashboardLoading());
    try {
      final transactions = await _repository.getTransactions();
      
      double totalIncome = 0;
      double totalExpense = 0;
      
      for (var tx in transactions) {
        if (tx.type == TransactionType.income) {
          totalIncome += tx.amount;
        } else {
          totalExpense += tx.amount;
        }
      }

      final double currentBalance = totalIncome - totalExpense;
      final recentTransactions = transactions.take(5).toList();

      emit(DashboardLoaded(
        totalBalance: currentBalance,
        totalIncome: totalIncome,
        totalExpense: totalExpense,
        recentTransactions: recentTransactions,
      ));
    } catch (e) {
      emit(DashboardError(message: 'Failed to load dashboard.'));
    }
  }
}
