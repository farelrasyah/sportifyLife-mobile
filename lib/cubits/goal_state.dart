part of 'goal_cubit.dart';

/// States for GoalCubit
abstract class GoalState extends Equatable {
  const GoalState();

  @override
  List<Object> get props => [];
}

class GoalInitial extends GoalState {}

class GoalLoading extends GoalState {}

class GoalSuccess extends GoalState {}

class GoalFailure extends GoalState {
  final String error;

  const GoalFailure(this.error);

  @override
  List<Object> get props => [error];
}
