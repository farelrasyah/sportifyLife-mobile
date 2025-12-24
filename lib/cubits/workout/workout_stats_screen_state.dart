import 'package:equatable/equatable.dart';
import '../../data/models/workout_statistics_model.dart';
import '../../data/models/workout_plan_model.dart';
import '../../data/models/exercise_model.dart';

/// Workout Stats Screen State
/// Combines all data needed for the main workout stats screen
abstract class WorkoutStatsScreenState extends Equatable {
  const WorkoutStatsScreenState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class WorkoutStatsScreenInitial extends WorkoutStatsScreenState {
  const WorkoutStatsScreenInitial();
}

/// Loading state
class WorkoutStatsScreenLoading extends WorkoutStatsScreenState {
  const WorkoutStatsScreenLoading();
}

/// Loaded state - all data successfully loaded
class WorkoutStatsScreenLoaded extends WorkoutStatsScreenState {
  final WeeklyStatisticsModel? weeklyProgress;
  final List<WorkoutScheduleModel> todaySchedules;
  final List<WorkoutScheduleModel> upcomingSchedules;
  final List<FilterOptionModel> bodyParts;

  const WorkoutStatsScreenLoaded({
    this.weeklyProgress,
    required this.todaySchedules,
    required this.upcomingSchedules,
    required this.bodyParts,
  });

  WorkoutStatsScreenLoaded copyWith({
    WeeklyStatisticsModel? weeklyProgress,
    List<WorkoutScheduleModel>? todaySchedules,
    List<WorkoutScheduleModel>? upcomingSchedules,
    List<FilterOptionModel>? bodyParts,
  }) {
    return WorkoutStatsScreenLoaded(
      weeklyProgress: weeklyProgress ?? this.weeklyProgress,
      todaySchedules: todaySchedules ?? this.todaySchedules,
      upcomingSchedules: upcomingSchedules ?? this.upcomingSchedules,
      bodyParts: bodyParts ?? this.bodyParts,
    );
  }

  @override
  List<Object?> get props => [
    weeklyProgress,
    todaySchedules,
    upcomingSchedules,
    bodyParts,
  ];
}

/// Error state
class WorkoutStatsScreenError extends WorkoutStatsScreenState {
  final String message;

  const WorkoutStatsScreenError({required this.message});

  @override
  List<Object?> get props => [message];
}

/// Empty state - no data available
class WorkoutStatsScreenEmpty extends WorkoutStatsScreenState {
  const WorkoutStatsScreenEmpty();
}
