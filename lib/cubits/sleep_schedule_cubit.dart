import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';
import '../data/repositories/sleep_repository.dart';
import '../data/models/sleep_schedule_model.dart';
import '../utils/api.dart';
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

      // Pre-validate input
      if (bedtime.trim().isEmpty) {
        throw ApiException('Bedtime cannot be empty');
      }

      if (repeatDays.isEmpty) {
        throw ApiException('Please select at least one repeat day');
      }

      // Ensure bedtime is in correct HH:mm format
      final formattedBedtime = _formatBedtime(bedtime);
      debugPrint(
        'Original bedtime: "$bedtime" -> Formatted: "$formattedBedtime"',
      );

      // Ensure repeatDays are in correct format for API: "Monday", "Tuesday", etc.
      final formattedRepeatDays = repeatDays.map((day) {
        final dayLower = day.toLowerCase().trim();
        // Convert to proper case format: Monday, Tuesday, etc.
        return dayLower[0].toUpperCase() + dayLower.substring(1);
      }).toList();
      debugPrint('Formatted repeat days: $formattedRepeatDays');

      // Ensure alarmSound is valid
      final validAlarmSound = _validateAlarmSound(alarmSound);
      debugPrint('Validated alarm sound: "$alarmSound" -> "$validAlarmSound"');

      final request = CreateSleepScheduleRequest(
        bedtime: formattedBedtime,
        sleepHours: sleepHours,
        repeatDays: formattedRepeatDays,
        isVibrate: isVibrate,
        alarmSound: validAlarmSound,
        alarmEnabled: alarmEnabled,
        notes: notes,
      );

      // Final validation and logging
      final payload = request.toJson();
      debugPrint('=== FINAL REQUEST PAYLOAD ===');
      debugPrint('Bedtime type: ${payload['bedtime'].runtimeType}');
      debugPrint('Bedtime value: "${payload['bedtime']}"');
      debugPrint('Full payload: $payload');
      debugPrint('========================');

      // Ensure bedtime is definitely a string
      if (payload['bedtime'] is! String) {
        throw ApiException(
          'Bedtime must be a string, got ${payload['bedtime'].runtimeType}',
        );
      }

      // Validate format one more time
      final bedtimeStr = payload['bedtime'] as String;
      if (!RegExp(r'^\d{2}:\d{2}$').hasMatch(bedtimeStr)) {
        throw ApiException(
          'Bedtime format invalid: "$bedtimeStr", expected HH:mm',
        );
      }

      final newSchedule = await _sleepRepository.createSleepSchedule(request);

      emit(SleepScheduleCreated(newSchedule));

      // Reload schedules to get updated list
      await loadSleepSchedules();
    } catch (e) {
      final errorMessage = _extractErrorMessage(e);
      debugPrint('Error creating sleep schedule: $e');
      emit(SleepScheduleError(message: errorMessage));
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

  /// Format bedtime to ensure HH:mm format with strict validation
  String _formatBedtime(String bedtime) {
    try {
      // Remove any whitespace
      final cleanBedtime = bedtime.trim();

      // If already in correct format, validate and return
      if (RegExp(r'^\d{2}:\d{2}$').hasMatch(cleanBedtime)) {
        final parts = cleanBedtime.split(':');
        final hour = int.parse(parts[0]);
        final minute = int.parse(parts[1]);

        // Validate hour and minute ranges
        if (hour >= 0 && hour <= 23 && minute >= 0 && minute <= 59) {
          return cleanBedtime;
        }
      }

      // Try to parse various formats
      final parts = cleanBedtime.split(':');
      if (parts.length == 2) {
        final hour = int.parse(parts[0]);
        final minute = int.parse(parts[1]);

        // Validate ranges
        if (hour >= 0 && hour <= 23 && minute >= 0 && minute <= 59) {
          final formattedHour = hour.toString().padLeft(2, '0');
          final formattedMinute = minute.toString().padLeft(2, '0');
          final formatted = '$formattedHour:$formattedMinute';

          debugPrint('Formatted bedtime: $cleanBedtime -> $formatted');
          return formatted;
        }
      }

      // Fallback to default
      debugPrint('Using fallback bedtime for invalid input: $cleanBedtime');
      return '21:00';
    } catch (e) {
      debugPrint('Error formatting bedtime "$bedtime": $e');
      return '21:00';
    }
  }

  /// Validate and format alarm sound
  String _validateAlarmSound(String alarmSound) {
    // Valid alarm sounds based on API
    const validSounds = [
      'default',
      'gentle',
      'nature',
      'classical',
      'vibration_only',
    ];

    // Remove underscores and convert to lowercase for comparison
    final normalized = alarmSound.toLowerCase().replaceAll('_', '');

    // Check if valid
    if (validSounds.contains(normalized)) {
      return normalized;
    }

    // Try to match partial names
    for (final valid in validSounds) {
      if (normalized.contains(valid) || valid.contains(normalized)) {
        return valid;
      }
    }

    // Default fallback
    return 'default';
  }

  /// Extract error message from various error types
  String _extractErrorMessage(dynamic error) {
    try {
      if (error is ApiException) {
        return error.errorMessage;
      }

      final errorString = error.toString();

      // Try to extract meaningful message from common error patterns
      if (errorString.contains('Bedtime must be in HH:mm format')) {
        return 'Invalid bedtime format. Please use HH:mm format.';
      }

      if (errorString.contains('Invalid day of week')) {
        return 'Invalid day selection. Please check your repeat days.';
      }

      if (errorString.contains('type') &&
          errorString.contains('is not a subtype')) {
        return 'Server response error. Please try again.';
      }

      // If it's a long error message, try to extract the useful part
      if (errorString.length > 100) {
        // Look for common patterns in API error responses
        final lines = errorString.split('\n');
        for (final line in lines) {
          if (line.contains('message') && line.contains(':')) {
            final parts = line.split(':');
            if (parts.length > 1) {
              final message = parts.sublist(1).join(':').trim();
              if (message.isNotEmpty && message.length < 200) {
                return message;
              }
            }
          }
        }
      }

      // Return the original error if we can't parse it nicely
      return errorString.length > 200
          ? 'An error occurred. Please try again.'
          : errorString;
    } catch (e) {
      // If error parsing fails, return a generic message
      return 'An unexpected error occurred. Please try again.';
    }
  }
}
