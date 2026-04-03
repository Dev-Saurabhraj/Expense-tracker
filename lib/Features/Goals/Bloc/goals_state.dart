part of 'goals_bloc.dart';

abstract class GoalsState extends Equatable {
  const GoalsState();
  
  @override
  List<Object?> get props => [];
}

class GoalsInitial extends GoalsState {}

class GoalsLoading extends GoalsState {}

class GoalsLoaded extends GoalsState {
  final GoalModel? goal;
  final double currentSavings;

  const GoalsLoaded({this.goal, this.currentSavings = 0});

  @override
  List<Object?> get props => [goal, currentSavings];
}

class GoalsError extends GoalsState {
  final String message;
  const GoalsError({required this.message});

  @override
  List<Object> get props => [message];
}
