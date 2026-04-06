import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';
import '../../../Data/models/transaction_model.dart';
import '../../../Data/repositories/finance_repository.dart';

part 'insights_event.dart';
part 'insights_state.dart';

class InsightsBloc extends Bloc<InsightsEvent, InsightsState> {
  final FinanceRepository _repository;
  String? _selectedCategory;
  InsightsPeriod _selectedPeriod = InsightsPeriod.monthly;

  InsightsBloc({required FinanceRepository repository})
    : _repository = repository,
      super(InsightsInitial()) {
    on<LoadInsights>(_onLoadInsights);
    on<FilterByCategory>(_onFilterByCategory);
    on<FilterByPeriod>(_onFilterByPeriod);
  }

  Future<void> _onLoadInsights(
    LoadInsights event,
    Emitter<InsightsState> emit,
  ) async {
    emit(InsightsLoading());
    try {
      final transactions = await _repository.getTransactions();
      _emitLoadedState(emit, transactions);
    } catch (e) {
      emit(InsightsError(message: 'Failed to load insights.'));
    }
  }

  Future<void> _onFilterByCategory(
    FilterByCategory event,
    Emitter<InsightsState> emit,
  ) async {
    _selectedCategory = event.category;
    try {
      final transactions = await _repository.getTransactions();
      _emitLoadedState(emit, transactions);
    } catch (e) {
      emit(InsightsError(message: 'Failed to apply filter.'));
    }
  }

  Future<void> _onFilterByPeriod(
    FilterByPeriod event,
    Emitter<InsightsState> emit,
  ) async {
    _selectedPeriod = event.period;
    try {
      final transactions = await _repository.getTransactions();
      _emitLoadedState(emit, transactions);
    } catch (e) {
      emit(InsightsError(message: 'Failed to apply filter.'));
    }
  }

  void _emitLoadedState(
    Emitter<InsightsState> emit,
    List<TransactionModel> allTransactions,
  ) {
    final now = DateTime.now();
    final Map<DateTime, double> periodData = {};
    late final List<DateTime> sortedPeriods;
    late final List<String> periodLabels;

    // Filter by category if selected
    var transactions = _selectedCategory == null
        ? allTransactions
        : allTransactions
              .where((tx) => tx.category == _selectedCategory)
              .toList();

    // Filter to only expenses
    transactions = transactions
        .where((tx) => tx.type == TransactionType.expense)
        .toList();

    // Calculate data based on period
    if (_selectedPeriod == InsightsPeriod.daily) {
      // Last 6 days (to match chart display)
      for (int i = 5; i >= 0; i--) {
        final date = now.subtract(Duration(days: i));
        final dayAnchor = DateTime(date.year, date.month, date.day);
        periodData[dayAnchor] = 0.0;
      }

      for (var tx in transactions) {
        final txDate = tx.date;
        final dayAnchor = DateTime(txDate.year, txDate.month, txDate.day);
        if (periodData.containsKey(dayAnchor)) {
          periodData[dayAnchor] = periodData[dayAnchor]! + tx.amount;
        }
      }

      sortedPeriods = periodData.keys.toList()..sort();
      periodLabels = sortedPeriods
          .map((date) => DateFormat('MMM d').format(date))
          .toList();
    } else if (_selectedPeriod == InsightsPeriod.weekly) {
      // Last 6 weeks - but current week only shows up to today
      final nowStartOfDay = DateTime(now.year, now.month, now.day);
      final currentWeekStart = nowStartOfDay.subtract(
        Duration(days: nowStartOfDay.weekday - 1),
      );

      for (int i = 5; i >= 0; i--) {
        final date = now.subtract(Duration(days: i * 7));
        final weekAnchor = date.subtract(Duration(days: date.weekday - 1));
        final weekStart = DateTime(
          weekAnchor.year,
          weekAnchor.month,
          weekAnchor.day,
        );
        if (!periodData.containsKey(weekStart)) {
          periodData[weekStart] = 0.0;
        }
      }

      for (var tx in transactions) {
        final txDate = tx.date;
        final txDateStartOfDay = DateTime(
          txDate.year,
          txDate.month,
          txDate.day,
        );
        final weekAnchor = txDateStartOfDay.subtract(
          Duration(days: txDateStartOfDay.weekday - 1),
        );
        final weekStart = DateTime(
          weekAnchor.year,
          weekAnchor.month,
          weekAnchor.day,
        );

        // For current incomplete week, only include transactions up to today
        if (weekStart == currentWeekStart &&
            txDateStartOfDay.isAfter(nowStartOfDay)) {
          continue;
        }

        if (periodData.containsKey(weekStart)) {
          periodData[weekStart] = periodData[weekStart]! + tx.amount;
        }
      }

      sortedPeriods = periodData.keys.toList()..sort();
      periodLabels = sortedPeriods
          .map((date) => 'W${DateFormat('MMM d').format(date)}')
          .toList();
    } else {
      // Monthly (default)
      for (int i = 0; i < 6; i++) {
        int targetMonth = now.month - i;
        int targetYear = now.year;
        while (targetMonth <= 0) {
          targetMonth += 12;
          targetYear -= 1;
        }
        final monthAnchor = DateTime(targetYear, targetMonth, 1);
        periodData[monthAnchor] = 0.0;
      }

      for (var tx in transactions) {
        final txDate = tx.date;
        final monthAnchor = DateTime(txDate.year, txDate.month, 1);
        if (periodData.containsKey(monthAnchor)) {
          periodData[monthAnchor] = periodData[monthAnchor]! + tx.amount;
        }
      }

      sortedPeriods = periodData.keys.toList()..sort();
      periodLabels = sortedPeriods
          .map((month) => DateFormat('MMM').format(month))
          .toList();
    }

    final List<double> expensesList = sortedPeriods
        .map((p) => periodData[p]!)
        .toList();

    emit(
      InsightsLoaded(
        dailyExpenses: expensesList,
        sortedDays: sortedPeriods,
        weekLabels: periodLabels,
        transactions: allTransactions,
        selectedCategory: _selectedCategory,
        selectedPeriod: _selectedPeriod,
      ),
    );
  }
}
