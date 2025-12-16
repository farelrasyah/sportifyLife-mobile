import 'package:equatable/equatable.dart';
import '../data/models/sleep_schedule_model.dart';

/// Sleep Schedule States
abstract class SleepScheduleState extends Equatable {
  const SleepScheduleState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class SleepScheduleInitial extends SleepScheduleState {
  const SleepScheduleInitial();
}

/// Loading state
class SleepScheduleLoading extends SleepScheduleState {
  const SleepScheduleLoading();
}

/// Success state with schedules loaded
class SleepScheduleLoaded extends SleepScheduleState {
  final List<SleepScheduleModel> schedules;
  final SleepScheduleModel? selectedSchedule;

  const SleepScheduleLoaded({required this.schedules, this.selectedSchedule});

  SleepScheduleLoaded copyWith({
    List<SleepScheduleModel>? schedules,
    SleepScheduleModel? selectedSchedule,
  }) {
    return SleepScheduleLoaded(
      schedules: schedules ?? this.schedules,
      selectedSchedule: selectedSchedule ?? this.selectedSchedule,
    );
  }

  @override
  List<Object?> get props => [schedules, selectedSchedule];
}

/// Creating schedule state
class SleepScheduleCreating extends SleepScheduleState {
  const SleepScheduleCreating();
}

/// Schedule created successfully
class SleepScheduleCreated extends SleepScheduleState {
  final SleepScheduleModel schedule;

  const SleepScheduleCreated(this.schedule);

  @override
  List<Object?> get props => [schedule];
}

/// Updating schedule state
class SleepScheduleUpdating extends SleepScheduleState {
  const SleepScheduleUpdating();
}

/// Schedule updated successfully
class SleepScheduleUpdated extends SleepScheduleState {
  final SleepScheduleModel schedule;

  const SleepScheduleUpdated(this.schedule);

  @override
  List<Object?> get props => [schedule];
}

/// Deleting schedule state
class SleepScheduleDeleting extends SleepScheduleState {
  const SleepScheduleDeleting();
}

/// Schedule deleted successfully
class SleepScheduleDeleted extends SleepScheduleState {
  final String scheduleId;

  const SleepScheduleDeleted(this.scheduleId);

  @override
  List<Object?> get props => [scheduleId];
}

/// Error state
class SleepScheduleError extends SleepScheduleState {
  final String message;
  final String? errorCode;

  const SleepScheduleError({required this.message, this.errorCode});

  @override
  List<Object?> get props => [message, errorCode];
}
