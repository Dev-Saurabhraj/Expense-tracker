part of 'insights_bloc.dart';

abstract class InsightsEvent extends Equatable {
  const InsightsEvent();

  @override
  List<Object> get props => [];
}

class LoadInsights extends InsightsEvent {}

class FilterByCategory extends InsightsEvent {
  final String? category;
  const FilterByCategory(this.category);

  @override
  List<Object> get props => [category ?? ''];
}

class FilterByPeriod extends InsightsEvent {
  final InsightsPeriod period;
  const FilterByPeriod(this.period);

  @override
  List<Object> get props => [period];
}

enum InsightsPeriod { daily, weekly, monthly }
