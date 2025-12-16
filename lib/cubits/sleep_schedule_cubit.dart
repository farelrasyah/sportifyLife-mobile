import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';
import '../data/repositories/sleep_repository.dart';
import '../data/models/sleep_schedule_model.dart';
import 'sleep_schedule_state.dart';

/// Sleep Schedule Cubit for managing sleep schedules
class SleepScheduleCubit extends Cubit<SleepScheduleState> {
  final SleepRepository _sleepRepository;

  SleepScheduleCubit({required SleepRepository sleepRepository})
    : _sleepRepository = sleepRepository,
      super(const SleepScheduleInitial());

  /// Load all sleep schedules with optional filtering and fallback
  Future<void> loadSleepSchedules({
    int? month,
    int? year,
    bool? isActive,
  }) async {
    try {
      emit(const SleepScheduleLoading());

      final schedules = await _sleepRepository.getSleepSchedules(
        month: month,
        year: year,
        isActive: isActive,
      );

      emit(SleepScheduleLoaded(schedules: schedules));
    } catch (e) {
      // Provide fallback empty data instead of error state
      emit(const SleepScheduleLoaded(schedules: []));
      debugPrint('Error loading sleep schedules, using empty fallback: $e');
    }
  }

  /// Load sleep schedule by ID
  Future<void> loadSleepScheduleById(String id) async {
    try {
      emit(const SleepScheduleLoading());

      final schedule = await _sleepRepository.getSleepScheduleById(id);
      final currentState = state;

      if (currentState is SleepScheduleLoaded) {
        emit(currentState.copyWith(selectedSchedule: schedule));
      } else {
        emit(SleepScheduleLoaded(schedules: [], selectedSchedule: schedule));
      }
    } catch (e) {
      emit(SleepScheduleError(message: e.toString()));
      debugPrint('Error loading sleep schedule by ID: $e');
    }
  }

  /// Create a new sleep schedule
  Future<void> createSleepSchedule({
    required String bedtime,
    required double sleepHours,
    required List<String> repeatDays,
    bool isVibrate = true,
    String alarmSound = 'default',
    bool alarmEnabled = true,
    String? notes,
  }) async {
    try {
      emit(const SleepScheduleCreating());

      final request = CreateSleepScheduleRequest(
        bedtime: bedtime,
        sleepHours: sleepHours,
        repeatDays: repeatDays,
        isVibrate: isVibrate,
        alarmSound: alarmSound,
        alarmEnabled: alarmEnabled,
        notes: notes,
      );

      final newSchedule = await _sleepRepository.createSleepSchedule(request);

      emit(SleepScheduleCreated(newSchedule));

      // Reload schedules to get updated list
      await loadSleepSchedules();
    } catch (e) {
      emit(SleepScheduleError(message: e.toString()));
      debugPrint('Error creating sleep schedule: $e');
    }
  }

  /// Update an existing sleep schedule
  Future<void> updateSleepSchedule({
    required String id,
    String? bedtime,
    double? sleepHours,
    List<String>? repeatDays,
    bool? isVibrate,
    String? alarmSound,
    bool? isActive,
    bool? alarmEnabled,
    String? notes,
  }) async {
    try {
      emit(const SleepScheduleUpdating());

      final request = UpdateSleepScheduleRequest(
        bedtime: bedtime,
        sleepHours: sleepHours,
        repeatDays: repeatDays,
        isVibrate: isVibrate,
        alarmSound: alarmSound,
        isActive: isActive,
        alarmEnabled: alarmEnabled,
        notes: notes,
      );

      final updatedSchedule = await _sleepRepository.updateSleepSchedule(
        id,
        request,
      );

      emit(SleepScheduleUpdated(updatedSchedule));

      // Reload schedules to get updated list
      await loadSleepSchedules();
    } catch (e) {
      emit(SleepScheduleError(message: e.toString()));
      debugPrint('Error updating sleep schedule: $e');
    }
  }

  /// Delete a sleep schedule
  Future<void> deleteSleepSchedule(String id) async {
    try {
      emit(const SleepScheduleDeleting());

      await _sleepRepository.deleteSleepSchedule(id);

      emit(SleepScheduleDeleted(id));

      // Reload schedules to get updated list
      await loadSleepSchedules();
    } catch (e) {
      emit(SleepScheduleError(message: e.toString()));
      debugPrint('Error deleting sleep schedule: $e');
    }
  }

  /// Toggle sleep schedule active status
  Future<void> toggleScheduleActiveStatus(String id, bool isActive) async {
    try {
      emit(const SleepScheduleUpdating());

      final updatedSchedule = await _sleepRepository.toggleScheduleActiveStatus(
        id,
        isActive,
      );

      emit(SleepScheduleUpdated(updatedSchedule));

      // Update the schedule in current loaded state if available
      final currentState = state;
      if (currentState is SleepScheduleLoaded) {
        final updatedSchedules = currentState.schedules.map((schedule) {
          return schedule.id == id ? updatedSchedule : schedule;
        }).toList();

        emit(currentState.copyWith(schedules: updatedSchedules));
      }
    } catch (e) {
      emit(SleepScheduleError(message: e.toString()));
      debugPrint('Error toggling schedule active status: $e');
    }
  }

  /// Get active schedules for today
  Future<void> loadActivSchedulesForToday() async {
    try {
      final now = DateTime.now();
      await loadSleepSchedules(
        month: now.month,
        year: now.year,
        isActive: true,
      );
    } catch (e) {
      emit(SleepScheduleError(message: e.toString()));
      debugPrint('Error loading active schedules for today: $e');
    }
  }

  /// Clear selected schedule
  void clearSelectedSchedule() {
    final currentState = state;
    if (currentState is SleepScheduleLoaded) {
      emit(currentState.copyWith(selectedSchedule: null));
    }
  }

  /// Reset to initial state
  void reset() {
    emit(const SleepScheduleInitial());
  }

  /// Check if there are any conflicting schedules
  bool hasConflictingSchedule(
    List<String> newRepeatDays,
    String newBedtime,
    double newSleepHours, {
    String? excludeScheduleId,
  }) {
    final currentState = state;
    if (currentState is! SleepScheduleLoaded) return false;

    for (final schedule in currentState.schedules) {
      // Skip the schedule being updated
      if (excludeScheduleId != null && schedule.id == excludeScheduleId) {
        continue;
      }

      // Check if there's any overlap in repeat days
      final hasOverlapDays = schedule.repeatDays.any(
        (day) => newRepeatDays.contains(day),
      );

      if (hasOverlapDays && schedule.isActive) {
        // Check if time ranges overlap
        final existingBedtimeMinutes = _timeToMinutes(schedule.bedtime);
        final existingWakeTimeMinutes = _timeToMinutes(schedule.wakeTime);
        final newBedtimeMinutes = _timeToMinutes(newBedtime);
        final newWakeTimeMinutes =
            newBedtimeMinutes + (newSleepHours * 60).round();

        // Handle overnight schedules
        if (_timesOverlap(
          existingBedtimeMinutes,
          existingWakeTimeMinutes,
          newBedtimeMinutes,
          newWakeTimeMinutes,
        )) {
          return true;
        }
      }
    }

    return false;
  }

  /// Convert time string to minutes since midnight
  int _timeToMinutes(String time) {
    try {
      final parts = time.split(':');
      final hours = int.parse(parts[0]);
      final minutes = int.parse(parts[1]);
      return hours * 60 + minutes;
    } catch (e) {
      return 0;
    }
  }

  /// Check if two time ranges overlap
  bool _timesOverlap(int start1, int end1, int start2, int end2) {
    // Handle overnight schedules
    if (end1 < start1) end1 += 24 * 60; // Add 24 hours
    if (end2 < start2) end2 += 24 * 60; // Add 24 hours

    return start1 < end2 && start2 < end1;
  }
}
