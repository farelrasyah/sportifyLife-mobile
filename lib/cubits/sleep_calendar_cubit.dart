import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';
import '../data/repositories/sleep_repository.dart';
import '../data/models/sleep_record_model.dart';
import 'sleep_calendar_state.dart';

/// Sleep Calendar Cubit for managing calendar data and date selection
class SleepCalendarCubit extends Cubit<SleepCalendarState> {
  final SleepRepository _sleepRepository;

  SleepCalendarCubit({required SleepRepository sleepRepository})
    : _sleepRepository = sleepRepository,
      super(const SleepCalendarInitial());

  /// Load sleep calendar data for a specific date
  Future<void> loadCalendarData(DateTime selectedDate) async {
    try {
      emit(
        SleepCalendarDateLoading(
          selectedDate: selectedDate,
          previousWeeklyData: _getPreviousWeeklyData(),
        ),
      );

      // Get data for the selected date
      final selectedDateData = await _sleepRepository.getSleepCalendarData(
        selectedDate,
      );

      // Get weekly data starting from the beginning of the week
      final weekStart = _getWeekStart(selectedDate);
      final weeklyData = await _sleepRepository.getWeeklyCalendarData(
        weekStart,
      );

      emit(
        SleepCalendarLoaded(
          selectedDateData: selectedDateData,
          weeklyData: weeklyData,
          selectedDate: selectedDate,
        ),
      );
    } catch (e) {
      emit(
        SleepCalendarError(message: e.toString(), selectedDate: selectedDate),
      );
      debugPrint('Error loading calendar data: $e');
    }
  }

  /// Load initial calendar data for today
  Future<void> loadInitialCalendarData() async {
    final today = DateTime.now();
    await loadCalendarData(today);
  }

  /// Change selected date
  Future<void> changeSelectedDate(DateTime newDate) async {
    final currentState = state;

    // If we're changing to a date in the same week, just update selected date data
    if (currentState is SleepCalendarLoaded &&
        _isSameWeek(newDate, currentState.selectedDate)) {
      emit(
        SleepCalendarDateLoading(
          selectedDate: newDate,
          previousWeeklyData: currentState.weeklyData,
        ),
      );

      try {
        final selectedDateData = await _sleepRepository.getSleepCalendarData(
          newDate,
        );

        emit(
          currentState.copyWith(
            selectedDateData: selectedDateData,
            selectedDate: newDate,
          ),
        );
      } catch (e) {
        emit(SleepCalendarError(message: e.toString(), selectedDate: newDate));
      }
    } else {
      // Load full calendar data for new week
      await loadCalendarData(newDate);
    }
  }

  /// Refresh calendar data
  Future<void> refreshCalendarData() async {
    final currentState = state;
    DateTime dateToRefresh = DateTime.now();

    if (currentState is SleepCalendarLoaded) {
      dateToRefresh = currentState.selectedDate;
    } else if (currentState is SleepCalendarError &&
        currentState.selectedDate != null) {
      dateToRefresh = currentState.selectedDate!;
    }

    await loadCalendarData(dateToRefresh);
  }

  /// Get calendar data for a specific month
  Future<void> loadMonthData(DateTime month) async {
    try {
      emit(const SleepCalendarLoading());

      final monthStart = DateTime(month.year, month.month, 1);
      final monthEnd = DateTime(month.year, month.month + 1, 0);

      // Load weekly data for the entire month
      final List<SleepCalendarDataModel> monthlyData = [];

      for (
        DateTime date = monthStart;
        date.isBefore(monthEnd.add(const Duration(days: 1)));
        date = date.add(const Duration(days: 1))
      ) {
        try {
          final dayData = await _sleepRepository.getSleepCalendarData(date);
          monthlyData.add(dayData);
        } catch (e) {
          // If no data for a specific day, create empty data
          monthlyData.add(
            SleepCalendarDataModel(
              date: _formatDate(date),
              totalSleepDuration: 0,
              averageQuality: 0.0,
              sleepRecords: [],
              activeSchedules: [],
              hasAlarm: false,
            ),
          );
        }
      }

      // Select the first day of the month by default
      final selectedDateData = monthlyData.isNotEmpty
          ? monthlyData.first
          : SleepCalendarDataModel(
              date: _formatDate(monthStart),
              totalSleepDuration: 0,
              averageQuality: 0.0,
              sleepRecords: [],
              activeSchedules: [],
              hasAlarm: false,
            );

      emit(
        SleepCalendarLoaded(
          selectedDateData: selectedDateData,
          weeklyData: monthlyData,
          selectedDate: monthStart,
        ),
      );
    } catch (e) {
      emit(SleepCalendarError(message: e.toString()));
      debugPrint('Error loading month data: $e');
    }
  }

  /// Get sleep statistics for current loaded period
  Map<String, dynamic> getCalendarStatistics() {
    final currentState = state;
    if (currentState is! SleepCalendarLoaded) {
      return {
        'totalDays': 0,
        'daysWithSleep': 0,
        'averageSleepDuration': 0.0,
        'averageQuality': 0.0,
        'daysWithAlarms': 0,
      };
    }

    final weeklyData = currentState.weeklyData;

    final daysWithSleep = weeklyData
        .where((day) => day.totalSleepDuration > 0)
        .length;
    final totalSleepMinutes = weeklyData.fold<int>(
      0,
      (sum, day) => sum + day.totalSleepDuration,
    );
    final averageSleepDuration = daysWithSleep > 0
        ? totalSleepMinutes / daysWithSleep / 60.0
        : 0.0;

    final qualitySum = weeklyData.fold<double>(
      0.0,
      (sum, day) => sum + day.averageQuality,
    );
    final averageQuality = weeklyData.isNotEmpty
        ? qualitySum / weeklyData.length
        : 0.0;

    final daysWithAlarms = weeklyData.where((day) => day.hasAlarm).length;

    return {
      'totalDays': weeklyData.length,
      'daysWithSleep': daysWithSleep,
      'averageSleepDuration': averageSleepDuration,
      'averageQuality': averageQuality,
      'daysWithAlarms': daysWithAlarms,
    };
  }

  /// Check if a date has sleep data
  bool hasDataForDate(DateTime date) {
    final currentState = state;
    if (currentState is! SleepCalendarLoaded) return false;

    final dateString = _formatDate(date);
    return currentState.weeklyData.any(
      (day) => day.date == dateString && day.totalSleepDuration > 0,
    );
  }

  /// Get sleep data for a specific date from loaded data
  SleepCalendarDataModel? getDataForDate(DateTime date) {
    final currentState = state;
    if (currentState is! SleepCalendarLoaded) return null;

    final dateString = _formatDate(date);
    try {
      return currentState.weeklyData.firstWhere(
        (day) => day.date == dateString,
      );
    } catch (e) {
      return null;
    }
  }

  /// Reset to initial state
  void reset() {
    emit(const SleepCalendarInitial());
  }

  /// Get the start of the week (Monday) for a given date
  DateTime _getWeekStart(DateTime date) {
    final weekday = date.weekday;
    return date.subtract(Duration(days: weekday - 1));
  }

  /// Check if two dates are in the same week
  bool _isSameWeek(DateTime date1, DateTime date2) {
    final week1Start = _getWeekStart(date1);
    final week2Start = _getWeekStart(date2);
    return week1Start.isAtSameMomentAs(week2Start);
  }

  /// Get previous weekly data from current state
  List<SleepCalendarDataModel>? _getPreviousWeeklyData() {
    final currentState = state;
    if (currentState is SleepCalendarLoaded) {
      return currentState.weeklyData;
    }
    return null;
  }

  /// Format date to YYYY-MM-DD
  String _formatDate(DateTime date) {
    return '${date.year.toString().padLeft(4, '0')}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.day.toString().padLeft(2, '0')}';
  }
}
