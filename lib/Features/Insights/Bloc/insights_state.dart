part of 'insights_bloc.dart';

abstract class InsightsState extends Equatable {
  const InsightsState();

  @override
  List<Object> get props => [];
}

class InsightsInitial extends InsightsState {}

class InsightsLoading extends InsightsState {}

class InsightsLoaded extends InsightsState {
  final List<double> dailyExpenses;
  final List<DateTime> sortedDays;
  final List<String> weekLabels;
  final List<TransactionModel> transactions;

  const InsightsLoaded({
    required this.dailyExpenses,
    required this.sortedDays,
    required this.weekLabels,
    required this.transactions,
  });

  @override
  List<Object> get props => [
    dailyExpenses,
    sortedDays,
    weekLabels,
    transactions,
  ];
}

class InsightsError extends InsightsState {
  final String message;
  const InsightsError({required this.message});

  @override
  List<Object> get props => [message];
}
