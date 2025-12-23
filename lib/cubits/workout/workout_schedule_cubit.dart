import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';
import '../../data/repositories/workout_repository.dart';
import '../../data/models/workout_plan_model.dart';
import 'workout_schedule_state.dart';

/// Workout Schedule Cubit for managing workout schedules
class WorkoutScheduleCubit extends Cubit<WorkoutScheduleState> {
  final WorkoutRepository _workoutRepository;

  WorkoutScheduleCubit({required WorkoutRepository workoutRepository})
    : _workoutRepository = workoutRepository,
      super(const WorkoutScheduleInitial());

  /// Load upcoming workout schedules
  Future<void> loadUpcomingSchedules() async {
    try {
      emit(const WorkoutScheduleLoading());

      final schedules = await _workoutRepository.getUpcomingSchedules();

      // Separate today's schedules from future schedules
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final tomorrow = today.add(const Duration(days: 1));

      final todaySchedules = schedules.where((s) {
        final scheduleDate = s.scheduledDateTime;
        if (scheduleDate == null) return false;
        return scheduleDate.isAfter(
              today.subtract(const Duration(seconds: 1)),
            ) &&
            scheduleDate.isBefore(tomorrow);
      }).toList();

      final upcomingSchedules = schedules.where((s) {
        final scheduleDate = s.scheduledDateTime;
        if (scheduleDate == null) return false;
        return scheduleDate.isAfter(
          tomorrow.subtract(const Duration(seconds: 1)),
        );
      }).toList();

      emit(
        WorkoutScheduleLoaded(
          schedules: schedules,
          todaySchedules: todaySchedules,
          upcomingSchedules: upcomingSchedules,
        ),
      );
    } catch (e) {
      emit(WorkoutScheduleError(message: e.toString()));
      debugPrint('Error loading schedules: $e');
    }
  }

  /// Create new workout schedule
  Future<void> createWorkoutSchedule(WorkoutScheduleModel schedule) async {
    try {
      emit(const WorkoutScheduleLoading());

      final createdSchedule = await _workoutRepository.createWorkoutSchedule(
        schedule,
      );

      emit(
        WorkoutScheduleCreated(
          schedule: createdSchedule,
          message: 'Workout scheduled successfully!',
        ),
      );
    } catch (e) {
      emit(WorkoutScheduleError(message: e.toString()));
      debugPrint('Error creating schedule: $e');
    }
  }

  /// Delete workout schedule
  Future<void> deleteWorkoutSchedule(String id) async {
    try {
      await _workoutRepository.deleteWorkoutSchedule(id);

      final currentState = state;
      if (currentState is WorkoutScheduleLoaded) {
        final updatedSchedules = currentState.schedules
            .where((s) => s.id != id)
            .toList();
        final updatedToday = currentState.todaySchedules
            .where((s) => s.id != id)
            .toList();
        final updatedUpcoming = currentState.upcomingSchedules
            .where((s) => s.id != id)
            .toList();

        emit(
          currentState.copyWith(
            schedules: updatedSchedules,
            todaySchedules: updatedToday,
            upcomingSchedules: updatedUpcoming,
          ),
        );
      } else {
        emit(
          const WorkoutScheduleDeleted(message: 'Workout schedule deleted!'),
        );
      }
    } catch (e) {
      emit(WorkoutScheduleError(message: e.toString()));
      debugPrint('Error deleting schedule: $e');
    }
  }

  /// Get schedules for a specific date
  List<WorkoutScheduleModel> getSchedulesForDate(DateTime date) {
    final currentState = state;
    if (currentState is! WorkoutScheduleLoaded) return [];

    final targetDate = DateTime(date.year, date.month, date.day);
    final nextDay = targetDate.add(const Duration(days: 1));

    return currentState.schedules.where((s) {
      final scheduleDate = s.scheduledDateTime;
      if (scheduleDate == null) return false;
      return scheduleDate.isAfter(
            targetDate.subtract(const Duration(seconds: 1)),
          ) &&
          scheduleDate.isBefore(nextDay);
    }).toList();
  }

  /// Refresh schedules
  Future<void> refreshSchedules() async {
    await loadUpcomingSchedules();
  }
}
