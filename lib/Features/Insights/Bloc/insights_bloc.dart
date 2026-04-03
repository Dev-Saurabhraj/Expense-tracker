import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';
import '../../../Data/models/transaction_model.dart';
import '../../../Data/repositories/finance_repository.dart';

part 'insights_event.dart';
part 'insights_state.dart';

class InsightsBloc extends Bloc<InsightsEvent, InsightsState> {
  final FinanceRepository _repository;

  InsightsBloc({required FinanceRepository repository})
    : _repository = repository,
      super(InsightsInitial()) {
    on<LoadInsights>(_onLoadInsights);
  }

  Future<void> _onLoadInsights(
    LoadInsights event,
    Emitter<InsightsState> emit,
  ) async {
    emit(InsightsLoading());
    try {
      final transactions = await _repository.getTransactions();

      // Calculate monthly totals for the past 6 months
      final now = DateTime.now();
      final Map<DateTime, double> monthlyExpenses = {};

      for (int i = 0; i < 6; i++) {
        int targetMonth = now.month - i;
        int targetYear = now.year;
        while (targetMonth <= 0) {
          targetMonth += 12;
          targetYear -= 1;
        }
        final monthAnchor = DateTime(targetYear, targetMonth, 1);
        monthlyExpenses[monthAnchor] = 0.0;
      }

      for (var tx in transactions) {
        if (tx.type == TransactionType.expense) {
          final txDate = tx.date;
          final monthAnchor = DateTime(txDate.year, txDate.month, 1);
          if (monthlyExpenses.containsKey(monthAnchor)) {
            monthlyExpenses[monthAnchor] =
                monthlyExpenses[monthAnchor]! + tx.amount;
          }
        }
      }

      final sortedMonths = monthlyExpenses.keys.toList()..sort();
      final List<double> expensesList = sortedMonths
          .map((m) => monthlyExpenses[m]!)
          .toList();

      // Generate month labels (e.g., "Jan", "Feb", etc.)
      final weekLabels = sortedMonths
          .map((month) => DateFormat('MMM').format(month))
          .toList();

      emit(
        InsightsLoaded(
          dailyExpenses: expensesList,
          sortedDays: sortedMonths,
          weekLabels: weekLabels,
          transactions: transactions,
        ),
      );
    } catch (e) {
      emit(InsightsError(message: 'Failed to load insights.'));
    }
  }
}
