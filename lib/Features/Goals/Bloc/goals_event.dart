part of 'goals_bloc.dart';

abstract class GoalsEvent extends Equatable {
  const GoalsEvent();

  @override
  List<Object> get props => [];
}

class LoadGoal extends GoalsEvent {}

class SaveGoal extends GoalsEvent {
  final GoalModel goal;
  const SaveGoal(this.goal);

  @override
  List<Object> get props => [goal];
}
