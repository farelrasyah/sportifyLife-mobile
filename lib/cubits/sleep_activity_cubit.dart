import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';
import '../data/repositories/sleep_repository.dart';
import '../data/models/sleep_record_model.dart';
import 'sleep_activity_state.dart';

/// Sleep Activity Cubit for managing sleep activity data and charts
class SleepActivityCubit extends Cubit<SleepActivityState> {
  final SleepRepository _sleepRepository;

  SleepActivityCubit({required SleepRepository sleepRepository})
    : _sleepRepository = sleepRepository,
      super(const SleepActivityInitial());

  /// Load sleep activity data for the last week
  Future<void> loadSleepActivityData() async {
    try {
      emit(const SleepActivityLoading());

      // Get sleep activity data for the last 7 days
      final weeklyData = await _sleepRepository.getSleepActivityData();

      // Get today's summary
      final today = DateTime.now();
      SleepDailySummaryModel? todaysSummary;

      try {
        todaysSummary = await _sleepRepository.getSleepDailySummary(today);
      } catch (e) {
        // If no data for today, create empty summary
        todaysSummary = SleepDailySummaryModel(
          date: _formatDate(today),
          totalSleepTime: 0,
          records: [],
          adherenceToSchedule: false,
        );
      }

      // Convert weekly data to chart data (sleep hours)
      final chartData = weeklyData.map((summary) {
        return summary.totalSleepTime / 60.0; // Convert minutes to hours
      }).toList();

      emit(
        SleepActivityLoaded(
          weeklyData: weeklyData,
          todaysSummary: todaysSummary,
          chartData: chartData,
        ),
      );
    } catch (e) {
      emit(SleepActivityError(message: e.toString()));
      debugPrint('Error loading sleep activity data: $e');
    }
  }

  /// Refresh sleep activity data
  Future<void> refreshSleepActivityData() async {
    await loadSleepActivityData();
  }

  /// Get sleep data for a specific date
  Future<void> loadSleepDataForDate(DateTime date) async {
    try {
      final summary = await _sleepRepository.getSleepDailySummary(date);

      final currentState = state;
      if (currentState is SleepActivityLoaded) {
        emit(currentState.copyWith(todaysSummary: summary));
      }
    } catch (e) {
      emit(SleepActivityError(message: e.toString()));
      debugPrint('Error loading sleep data for date: $e');
    }
  }

  /// Calculate sleep statistics
  Map<String, dynamic> calculateSleepStatistics() {
    final currentState = state;
    if (currentState is! SleepActivityLoaded) {
      return {
        'averageSleepHours': 0.0,
        'totalSleepThisWeek': 0.0,
        'averageQuality': 0.0,
        'adherencePercentage': 0.0,
      };
    }

    final weeklyData = currentState.weeklyData;

    if (weeklyData.isEmpty) {
      return {
        'averageSleepHours': 0.0,
        'totalSleepThisWeek': 0.0,
        'averageQuality': 0.0,
        'adherencePercentage': 0.0,
      };
    }

    // Calculate average sleep hours
    final totalSleepMinutes = weeklyData.fold<int>(
      0,
      (sum, summary) => sum + summary.totalSleepTime,
    );
    final averageSleepHours = totalSleepMinutes / 60.0 / weeklyData.length;

    // Calculate average quality
    final qualitySum = weeklyData.fold<double>(
      0.0,
      (sum, summary) => sum + (summary.averageQuality ?? 0.0),
    );
    final averageQuality = qualitySum / weeklyData.length;

    // Calculate adherence percentage
    final adherentDays = weeklyData
        .where((summary) => summary.adherenceToSchedule)
        .length;
    final adherencePercentage = (adherentDays / weeklyData.length) * 100;

    return {
      'averageSleepHours': averageSleepHours,
      'totalSleepThisWeek': totalSleepMinutes / 60.0,
      'averageQuality': averageQuality,
      'adherencePercentage': adherencePercentage,
    };
  }

  /// Get sleep trend (improving, declining, stable)
  String getSleepTrend() {
    final currentState = state;
    if (currentState is! SleepActivityLoaded ||
        currentState.weeklyData.length < 4) {
      return 'stable';
    }

    final weeklyData = currentState.weeklyData;

    // Compare first half vs second half of the week
    final firstHalf = weeklyData.take(3).toList();
    final secondHalf = weeklyData.skip(4).toList();

    if (firstHalf.isEmpty || secondHalf.isEmpty) return 'stable';

    final firstHalfAvg =
        firstHalf.fold<double>(
          0.0,
          (sum, summary) => sum + (summary.totalSleepTime / 60.0),
        ) /
        firstHalf.length;

    final secondHalfAvg =
        secondHalf.fold<double>(
          0.0,
          (sum, summary) => sum + (summary.totalSleepTime / 60.0),
        ) /
        secondHalf.length;

    const threshold = 0.5; // 30 minutes difference

    if (secondHalfAvg - firstHalfAvg > threshold) {
      return 'improving';
    } else if (firstHalfAvg - secondHalfAvg > threshold) {
      return 'declining';
    } else {
      return 'stable';
    }
  }

  /// Get last night's sleep summary
  SleepDailySummaryModel? getLastNightSummary() {
    final currentState = state;
    if (currentState is! SleepActivityLoaded) return null;

    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    final yesterdayString = _formatDate(yesterday);

    return currentState.weeklyData.cast<SleepDailySummaryModel?>().firstWhere(
      (summary) => summary?.date == yesterdayString,
      orElse: () => null,
    );
  }

  /// Reset to initial state
  void reset() {
    emit(const SleepActivityInitial());
  }

  /// Format date to YYYY-MM-DD
  String _formatDate(DateTime date) {
    return '${date.year.toString().padLeft(4, '0')}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.day.toString().padLeft(2, '0')}';
  }
}
