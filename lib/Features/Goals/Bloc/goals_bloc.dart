import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../Data/models/goal_model.dart';
import '../../../Data/models/transaction_model.dart';
import '../../../Data/repositories/finance_repository.dart';

part 'goals_event.dart';
part 'goals_state.dart';

class GoalsBloc extends Bloc<GoalsEvent, GoalsState> {
  final FinanceRepository _repository;

  GoalsBloc({required FinanceRepository repository})
      : _repository = repository,
        super(GoalsInitial()) {
    on<LoadGoal>(_onLoadGoal);
    on<SaveGoal>(_onSaveGoal);
  }

  Future<void> _onLoadGoal(LoadGoal event, Emitter<GoalsState> emit) async {
    emit(GoalsLoading());
    try {
      final GoalModel? goal = await _repository.getGoal();
      final transactions = await _repository.getTransactions();
      
      final now = DateTime.now();
      
      double totalIncome = 0;
      double totalExpense = 0;

      for (var tx in transactions) {
        if (tx.date.year == now.year && tx.date.month == now.month) {
          if (tx.type == TransactionType.income) {
            totalIncome += tx.amount;
          } else {
            totalExpense += tx.amount;
          }
        }
      }

      final double currentSavings = totalIncome - totalExpense;

      if (goal != null) {
        final updatedGoal = goal.copyWith(currentAmount: currentSavings, monthYear: now);
        emit(GoalsLoaded(goal: updatedGoal));
      } else {
        emit(GoalsLoaded(goal: null, currentSavings: currentSavings));
      }
    } catch (e) {
      emit(GoalsError(message: 'Failed to load goal.'));
    }
  }

  Future<void> _onSaveGoal(SaveGoal event, Emitter<GoalsState> emit) async {
    try {
      await _repository.saveGoal(event.goal);
      add(LoadGoal());
    } catch (e) {
      emit(GoalsError(message: 'Failed to save goal.'));
    }
  }
}
