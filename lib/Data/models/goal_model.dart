import 'dart:convert';
import 'package:equatable/equatable.dart';

class GoalModel extends Equatable {
  final String id;
  final String name;
  final double targetAmount;
  final double currentAmount;
  final DateTime monthYear;

  const GoalModel({
    required this.id,
    required this.name,
    required this.targetAmount,
    required this.currentAmount,
    required this.monthYear,
  });

  GoalModel copyWith({
    String? id,
    String? name,
    double? targetAmount,
    double? currentAmount,
    DateTime? monthYear,
  }) {
    return GoalModel(
      id: id ?? this.id,
      name: name ?? this.name,
      targetAmount: targetAmount ?? this.targetAmount,
      currentAmount: currentAmount ?? this.currentAmount,
      monthYear: monthYear ?? this.monthYear,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'targetAmount': targetAmount,
      'currentAmount': currentAmount,
      'monthYear': monthYear.toIso8601String(),
    };
  }

  factory GoalModel.fromMap(Map<String, dynamic> map) {
    return GoalModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      targetAmount: map['targetAmount']?.toDouble() ?? 0.0,
      currentAmount: map['currentAmount']?.toDouble() ?? 0.0,
      monthYear: DateTime.parse(map['monthYear']),
    );
  }

  String toJson() => json.encode(toMap());

  factory GoalModel.fromJson(String source) => GoalModel.fromMap(json.decode(source));

  @override
  List<Object?> get props => [id, name, targetAmount, currentAmount, monthYear];
}
