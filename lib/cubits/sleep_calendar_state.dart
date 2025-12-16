import 'package:equatable/equatable.dart';
import '../data/models/sleep_record_model.dart';

/// Sleep Calendar States
abstract class SleepCalendarState extends Equatable {
  const SleepCalendarState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class SleepCalendarInitial extends SleepCalendarState {
  const SleepCalendarInitial();
}

/// Loading state
class SleepCalendarLoading extends SleepCalendarState {
  const SleepCalendarLoading();
}

/// Success state with calendar data loaded
class SleepCalendarLoaded extends SleepCalendarState {
  final SleepCalendarDataModel selectedDateData;
  final List<SleepCalendarDataModel> weeklyData;
  final DateTime selectedDate;

  const SleepCalendarLoaded({
    required this.selectedDateData,
    required this.weeklyData,
    required this.selectedDate,
  });

  SleepCalendarLoaded copyWith({
    SleepCalendarDataModel? selectedDateData,
    List<SleepCalendarDataModel>? weeklyData,
    DateTime? selectedDate,
  }) {
    return SleepCalendarLoaded(
      selectedDateData: selectedDateData ?? this.selectedDateData,
      weeklyData: weeklyData ?? this.weeklyData,
      selectedDate: selectedDate ?? this.selectedDate,
    );
  }

  @override
  List<Object?> get props => [selectedDateData, weeklyData, selectedDate];
}

/// Date selection loading state
class SleepCalendarDateLoading extends SleepCalendarState {
  final DateTime selectedDate;
  final List<SleepCalendarDataModel>? previousWeeklyData;

  const SleepCalendarDateLoading({
    required this.selectedDate,
    this.previousWeeklyData,
  });

  @override
  List<Object?> get props => [selectedDate, previousWeeklyData];
}

/// Error state
class SleepCalendarError extends SleepCalendarState {
  final String message;
  final String? errorCode;
  final DateTime? selectedDate;

  const SleepCalendarError({
    required this.message,
    this.errorCode,
    this.selectedDate,
  });

  @override
  List<Object?> get props => [message, errorCode, selectedDate];
}
