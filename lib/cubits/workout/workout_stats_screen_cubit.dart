import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';
import '../../data/repositories/new_workout_repository.dart';
import '../../data/models/workout_model.dart';
import 'workout_stats_screen_state.dart';

/// Workout Stats Screen Cubit
/// Manages all data for the main workout stats screen
/// Menggunakan API baru sesuai dokumentasi
class WorkoutStatsScreenCubit extends Cubit<WorkoutStatsScreenState> {
  final NewWorkoutRepository _workoutRepository;

  WorkoutStatsScreenCubit({required NewWorkoutRepository workoutRepository})
    : _workoutRepository = workoutRepository,
      super(const WorkoutStatsScreenInitial());

  /// Load all data for the workout stats screen
  Future<void> loadWorkoutStatsData() async {
    try {
      emit(const WorkoutStatsScreenLoading());

      // Fetch all data in parallel with proper error handling
      final results = await Future.wait([
        _workoutRepository.getWeeklyProgress().catchError((e) {
          debugPrint('Error loading weekly progress: $e');
          return null;
        }),
        _workoutRepository.getTodaySchedules().catchError((e) {
          debugPrint('Error loading today schedules: $e');
          return <NewWorkoutScheduleModel>[];
        }),
        _workoutRepository.getUpcomingSchedules().catchError((e) {
          debugPrint('Error loading upcoming schedules: $e');
          return <NewWorkoutScheduleModel>[];
        }),
        _workoutRepository.getWorkouts(page: 1, limit: 10).catchError((e) {
          debugPrint('Error loading workouts: $e');
          return PaginatedWorkoutsModel(
            data: [],
            total: 0,
            page: 1,
            limit: 10,
            totalPages: 0,
          );
        }),
      ]);

      final weeklyProgress = results[0] as WeeklyProgressModel?;
      final todaySchedules = results[1] as List<NewWorkoutScheduleModel>;
      final upcomingSchedules = results[2] as List<NewWorkoutScheduleModel>;
      final paginatedWorkouts = results[3] as PaginatedWorkoutsModel;

      // Check if we have any data
      if (weeklyProgress == null &&
          todaySchedules.isEmpty &&
          upcomingSchedules.isEmpty &&
          paginatedWorkouts.data.isEmpty) {
        emit(const WorkoutStatsScreenEmpty());
        return;
      }

      emit(
        WorkoutStatsScreenLoaded(
          weeklyProgress: weeklyProgress,
          todaySchedules: todaySchedules,
          upcomingSchedules: upcomingSchedules,
          workouts: paginatedWorkouts.data,
          categories: WorkoutCategory.values.toList(),
          currentPage: paginatedWorkouts.page,
          totalPages: paginatedWorkouts.totalPages,
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

  /// Filter workouts by level
  Future<void> filterByLevel(WorkoutLevel? level) async {
    final currentState = state;
    if (currentState is! WorkoutStatsScreenLoaded) return;

    try {
      emit(currentState.copyWith(isLoadingMore: true));

      final paginatedWorkouts = await _workoutRepository.getWorkouts(
        page: 1,
        limit: 10,
        level: level?.value,
        category: currentState.selectedCategory?.value,
        search: currentState.searchQuery,
      );

      emit(
        currentState.copyWith(
          selectedLevel: level,
          workouts: paginatedWorkouts.data,
          currentPage: paginatedWorkouts.page,
          totalPages: paginatedWorkouts.totalPages,
          isLoadingMore: false,
        ),
      );
    } catch (e) {
      debugPrint('Error filtering by level: $e');
      emit(currentState.copyWith(isLoadingMore: false));
    }
  }

  /// Filter workouts by category
  Future<void> filterByCategory(WorkoutCategory? category) async {
    final currentState = state;
    if (currentState is! WorkoutStatsScreenLoaded) return;

    try {
      emit(currentState.copyWith(isLoadingMore: true));

      final paginatedWorkouts = await _workoutRepository.getWorkouts(
        page: 1,
        limit: 10,
        level: currentState.selectedLevel?.value,
        category: category?.value,
        search: currentState.searchQuery,
      );

      emit(
        currentState.copyWith(
          selectedCategory: category,
          workouts: paginatedWorkouts.data,
          currentPage: paginatedWorkouts.page,
          totalPages: paginatedWorkouts.totalPages,
          isLoadingMore: false,
        ),
      );
    } catch (e) {
      debugPrint('Error filtering by category: $e');
      emit(currentState.copyWith(isLoadingMore: false));
    }
  }

  /// Search workouts
  Future<void> searchWorkouts(String query) async {
    final currentState = state;
    if (currentState is! WorkoutStatsScreenLoaded) return;

    try {
      emit(currentState.copyWith(isLoadingMore: true));

      final paginatedWorkouts = await _workoutRepository.getWorkouts(
        page: 1,
        limit: 10,
        level: currentState.selectedLevel?.value,
        category: currentState.selectedCategory?.value,
        search: query.isEmpty ? null : query,
      );

      emit(
        currentState.copyWith(
          searchQuery: query.isEmpty ? null : query,
          workouts: paginatedWorkouts.data,
          currentPage: paginatedWorkouts.page,
          totalPages: paginatedWorkouts.totalPages,
          isLoadingMore: false,
        ),
      );
    } catch (e) {
      debugPrint('Error searching workouts: $e');
      emit(currentState.copyWith(isLoadingMore: false));
    }
  }

  /// Load more workouts (pagination)
  Future<void> loadMoreWorkouts() async {
    final currentState = state;
    if (currentState is! WorkoutStatsScreenLoaded) return;
    if (!currentState.hasMore || currentState.isLoadingMore) return;

    try {
      emit(currentState.copyWith(isLoadingMore: true));

      final paginatedWorkouts = await _workoutRepository.getWorkouts(
        page: currentState.currentPage + 1,
        limit: 10,
        level: currentState.selectedLevel?.value,
        category: currentState.selectedCategory?.value,
        search: currentState.searchQuery,
      );

      emit(
        currentState.copyWith(
          workouts: [...currentState.workouts, ...paginatedWorkouts.data],
          currentPage: paginatedWorkouts.page,
          totalPages: paginatedWorkouts.totalPages,
          isLoadingMore: false,
        ),
      );
    } catch (e) {
      debugPrint('Error loading more workouts: $e');
      emit(currentState.copyWith(isLoadingMore: false));
    }
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

  /// Start a workout session
  Future<NewWorkoutSessionModel> startWorkout(String workoutId) async {
    try {
      return await _workoutRepository.startWorkoutSession(workoutId: workoutId);
    } catch (e) {
      debugPrint('Error starting workout: $e');
      rethrow;
    }
  }

  /// Complete a workout session
  Future<NewWorkoutSessionModel> completeWorkout({
    required String sessionId,
    int? caloriesBurned,
    String? notes,
  }) async {
    try {
      return await _workoutRepository.completeWorkoutSession(
        sessionId: sessionId,
        caloriesBurned: caloriesBurned,
        notes: notes,
      );
    } catch (e) {
      debugPrint('Error completing workout: $e');
      rethrow;
    }
  }

  /// Create a workout schedule
  Future<NewWorkoutScheduleModel> createSchedule({
    required String workoutId,
    required DateTime scheduledDate,
    String? scheduledTime,
    bool reminderEnabled = false,
  }) async {
    try {
      final schedule = await _workoutRepository.createWorkoutSchedule(
        workoutId: workoutId,
        scheduledDate: scheduledDate,
        scheduledTime: scheduledTime,
        reminderEnabled: reminderEnabled,
      );

      // Refresh data to show new schedule
      await refreshData();

      return schedule;
    } catch (e) {
      debugPrint('Error creating schedule: $e');
      rethrow;
    }
  }

  /// Delete a workout schedule
  Future<void> deleteSchedule(String scheduleId) async {
    try {
      await _workoutRepository.deleteWorkoutSchedule(scheduleId);

      // Update the state
      final currentState = state;
      if (currentState is WorkoutStatsScreenLoaded) {
        emit(
          currentState.copyWith(
            todaySchedules: currentState.todaySchedules
                .where((s) => s.id != scheduleId)
                .toList(),
            upcomingSchedules: currentState.upcomingSchedules
                .where((s) => s.id != scheduleId)
                .toList(),
          ),
        );
      }
    } catch (e) {
      debugPrint('Error deleting schedule: $e');
      rethrow;
    }
  }
}
