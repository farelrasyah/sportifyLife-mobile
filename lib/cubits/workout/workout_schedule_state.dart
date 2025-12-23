import 'package:equatable/equatable.dart';
import '../data/models/workout_plan_model.dart';

/// Workout Schedule States
abstract class WorkoutScheduleState extends Equatable {
  const WorkoutScheduleState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class WorkoutScheduleInitial extends WorkoutScheduleState {
  const WorkoutScheduleInitial();
}

/// Loading state
class WorkoutScheduleLoading extends WorkoutScheduleState {
  const WorkoutScheduleLoading();
}

/// Success state with schedules loaded
class WorkoutScheduleLoaded extends WorkoutScheduleState {
  final List<WorkoutScheduleModel> schedules;
  final List<WorkoutScheduleModel> todaySchedules;
  final List<WorkoutScheduleModel> upcomingSchedules;

  const WorkoutScheduleLoaded({
    required this.schedules,
    required this.todaySchedules,
    required this.upcomingSchedules,
  });

  WorkoutScheduleLoaded copyWith({
    List<WorkoutScheduleModel>? schedules,
    List<WorkoutScheduleModel>? todaySchedules,
    List<WorkoutScheduleModel>? upcomingSchedules,
  }) {
    return WorkoutScheduleLoaded(
      schedules: schedules ?? this.schedules,
      todaySchedules: todaySchedules ?? this.todaySchedules,
      upcomingSchedules: upcomingSchedules ?? this.upcomingSchedules,
    );
  }

  @override
  List<Object?> get props => [schedules, todaySchedules, upcomingSchedules];
}

/// Schedule created state
class WorkoutScheduleCreated extends WorkoutScheduleState {
  final WorkoutScheduleModel schedule;
  final String message;

  const WorkoutScheduleCreated({required this.schedule, required this.message});

  @override
  List<Object?> get props => [schedule, message];
}

/// Schedule deleted state
class WorkoutScheduleDeleted extends WorkoutScheduleState {
  final String message;

  const WorkoutScheduleDeleted({required this.message});

  @override
  List<Object?> get props => [message];
}

/// Error state
class WorkoutScheduleError extends WorkoutScheduleState {
  final String message;
  final String? errorCode;

  const WorkoutScheduleError({required this.message, this.errorCode});

  @override
  List<Object?> get props => [message, errorCode];
}
