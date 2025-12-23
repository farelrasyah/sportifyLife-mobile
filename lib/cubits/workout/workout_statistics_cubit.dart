import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';
import '../../data/repositories/workout_repository.dart';
import 'workout_statistics_state.dart';

/// Workout Statistics Cubit for managing workout statistics and analytics
class WorkoutStatisticsCubit extends Cubit<WorkoutStatisticsState> {
  final WorkoutRepository _workoutRepository;

  WorkoutStatisticsCubit({required WorkoutRepository workoutRepository})
    : _workoutRepository = workoutRepository,
      super(const WorkoutStatisticsInitial());

  /// Load all statistics
  Future<void> loadStatistics() async {
    try {
      emit(const WorkoutStatisticsLoading());

      final statistics = await _workoutRepository.getWorkoutStatistics();

      emit(WorkoutStatisticsLoaded(statistics: statistics));

      // Load additional statistics in background
      _loadWeeklyStatistics();
      _loadMonthlyStatistics();
    } catch (e) {
      emit(WorkoutStatisticsError(message: e.toString()));
      debugPrint('Error loading statistics: $e');
    }
  }

  /// Load weekly statistics
  Future<void> _loadWeeklyStatistics() async {
    try {
      final currentState = state;
      if (currentState is! WorkoutStatisticsLoaded) return;

      final weeklyStats = await _workoutRepository.getWeeklyStatistics();

      emit(currentState.copyWith(weeklyStatistics: weeklyStats));
    } catch (e) {
      debugPrint('Error loading weekly statistics: $e');
    }
  }

  /// Load monthly statistics
  Future<void> _loadMonthlyStatistics({int? year, int? month}) async {
    try {
      final currentState = state;
      if (currentState is! WorkoutStatisticsLoaded) return;

      final monthlyStats = await _workoutRepository.getMonthlyStatistics(
        year: year,
        month: month,
      );

      emit(currentState.copyWith(monthlyStatistics: monthlyStats));
    } catch (e) {
      debugPrint('Error loading monthly statistics: $e');
    }
  }

  /// Refresh statistics
  Future<void> refreshStatistics() async {
    await loadStatistics();
  }
}

/// Workout History Cubit for managing workout history with pagination
class WorkoutHistoryCubit extends Cubit<WorkoutHistoryState> {
  final WorkoutRepository _workoutRepository;

  WorkoutHistoryCubit({required WorkoutRepository workoutRepository})
    : _workoutRepository = workoutRepository,
      super(const WorkoutHistoryInitial());

  /// Load workout history
  Future<void> loadHistory({
    String? startDate,
    String? endDate,
    String? workoutType,
    bool? completedOnly,
  }) async {
    try {
      emit(const WorkoutHistoryLoading());

      final response = await _workoutRepository.getWorkoutHistory(
        page: 1,
        limit: 20,
        startDate: startDate,
        endDate: endDate,
        workoutType: workoutType,
        completedOnly: completedOnly,
      );

      emit(
        WorkoutHistoryLoaded(
          sessions: response.sessions,
          totalCount: response.pagination.total,
          currentPage: response.pagination.page,
          totalPages: response.pagination.totalPages,
        ),
      );
    } catch (e) {
      emit(WorkoutHistoryError(message: e.toString()));
      debugPrint('Error loading history: $e');
    }
  }

  /// Load more history (pagination)
  Future<void> loadMoreHistory() async {
    final currentState = state;
    if (currentState is! WorkoutHistoryLoaded || currentState.isLoadingMore) {
      return;
    }

    if (!currentState.hasMore) {
      debugPrint('No more history to load');
      return;
    }

    try {
      emit(currentState.copyWith(isLoadingMore: true));

      final response = await _workoutRepository.getWorkoutHistory(
        page: currentState.currentPage + 1,
        limit: 20,
      );

      emit(
        currentState.copyWith(
          sessions: [...currentState.sessions, ...response.sessions],
          currentPage: response.pagination.page,
          totalPages: response.pagination.totalPages,
          isLoadingMore: false,
        ),
      );
    } catch (e) {
      emit(currentState.copyWith(isLoadingMore: false));
      debugPrint('Error loading more history: $e');
    }
  }

  /// Refresh history
  Future<void> refreshHistory() async {
    await loadHistory();
  }
}
