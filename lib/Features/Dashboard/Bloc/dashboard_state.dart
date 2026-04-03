part of 'dashboard_bloc.dart';

abstract class DashboardState extends Equatable {
  const DashboardState();
  
  @override
  List<Object> get props => [];
}

class DashboardInitial extends DashboardState {}

class DashboardLoading extends DashboardState {}

class DashboardLoaded extends DashboardState {
  final double totalBalance;
  final double totalIncome;
  final double totalExpense;
  final List<TransactionModel> recentTransactions;

  const DashboardLoaded({
    required this.totalBalance,
    required this.totalIncome,
    required this.totalExpense,
    required this.recentTransactions,
  });

  @override
  List<Object> get props => [totalBalance, totalIncome, totalExpense, recentTransactions];
}

class DashboardError extends DashboardState {
  final String message;
  const DashboardError({required this.message});

  @override
  List<Object> get props => [message];
}
