import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';
import '../../data/repositories/workout_repository.dart';
import '../../data/repositories/exercise_repository.dart';
import '../../data/models/workout_plan_model.dart';
import '../../data/models/exercise_model.dart';
import '../../data/models/workout_statistics_model.dart';
import 'workout_stats_screen_state.dart';

/// Workout Stats Screen Cubit
/// Manages all data for the main workout stats screen
class WorkoutStatsScreenCubit extends Cubit<WorkoutStatsScreenState> {
  final WorkoutRepository _workoutRepository;
  final ExerciseRepository _exerciseRepository;

  WorkoutStatsScreenCubit({
    required WorkoutRepository workoutRepository,
    required ExerciseRepository exerciseRepository,
  }) : _workoutRepository = workoutRepository,
       _exerciseRepository = exerciseRepository,
       super(const WorkoutStatsScreenInitial());

  /// Load all data for the workout stats screen
  Future<void> loadWorkoutStatsData() async {
    try {
      emit(const WorkoutStatsScreenLoading());

      // Fetch all data in parallel with proper error handling
      final results = await Future.wait([
        _workoutRepository.getWeeklyStatistics().catchError((e) {
          debugPrint('Error loading weekly statistics: $e');
          return null; // Return null directly, not Future.value()
        }),
        _workoutRepository.getTodaySchedules().catchError((e) {
          debugPrint('Error loading today schedules: $e');
          return <WorkoutScheduleModel>[]; // Return empty list directly
        }),
        _workoutRepository.getUpcomingSchedules().catchError((e) {
          debugPrint('Error loading upcoming schedules: $e');
          return <WorkoutScheduleModel>[]; // Return empty list directly
        }),
        _exerciseRepository.getBodyParts().catchError((e) {
          debugPrint('Error loading body parts: $e');
          return <FilterOptionModel>[]; // Return empty list directly
        }),
      ]);

      final weeklyProgress = results[0] as WeeklyStatisticsModel?;
      final todaySchedules = results[1] as List<WorkoutScheduleModel>;
      final upcomingSchedules = results[2] as List<WorkoutScheduleModel>;
      final bodyParts = results[3] as List<FilterOptionModel>;

      // Check if we have any data
      if (weeklyProgress == null &&
          todaySchedules.isEmpty &&
          upcomingSchedules.isEmpty &&
          bodyParts.isEmpty) {
        emit(const WorkoutStatsScreenEmpty());
        return;
      }

      emit(
        WorkoutStatsScreenLoaded(
          weeklyProgress: weeklyProgress,
          todaySchedules: todaySchedules,
          upcomingSchedules: upcomingSchedules,
          bodyParts: bodyParts,
        ),
      );
    } catch (e) {
      emit(WorkoutStatsScreenError(message: e.toString()));
      debugPrint('Error loading workout stats data: $e');
    }
  }

  /// Refresh all data
  Future<void> refreshData() async {
    await loadWorkoutStatsData();
  }

  /// Toggle reminder for a schedule
  Future<void> toggleReminder(String scheduleId, bool isEnabled) async {
    try {
      await _workoutRepository.toggleScheduleReminder(scheduleId, isEnabled);

      // Update the state
      final currentState = state;
      if (currentState is WorkoutStatsScreenLoaded) {
        final updatedToday = currentState.todaySchedules.map((schedule) {
          if (schedule.id == scheduleId) {
            return schedule.copyWith(reminderEnabled: isEnabled);
          }
          return schedule;
        }).toList();

        final updatedUpcoming = currentState.upcomingSchedules.map((schedule) {
          if (schedule.id == scheduleId) {
            return schedule.copyWith(reminderEnabled: isEnabled);
          }
          return schedule;
        }).toList();

        emit(
          currentState.copyWith(
            todaySchedules: updatedToday,
            upcomingSchedules: updatedUpcoming,
          ),
        );
      }
    } catch (e) {
      debugPrint('Error toggling reminder: $e');
      rethrow;
    }
  }
}
