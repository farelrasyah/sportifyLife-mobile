import 'package:equatable/equatable.dart';
import '../data/models/sleep_record_model.dart';

/// Sleep Activity States
abstract class SleepActivityState extends Equatable {
  const SleepActivityState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class SleepActivityInitial extends SleepActivityState {
  const SleepActivityInitial();
}

/// Loading state
class SleepActivityLoading extends SleepActivityState {
  const SleepActivityLoading();
}

/// Success state with activity data loaded
class SleepActivityLoaded extends SleepActivityState {
  final List<SleepDailySummaryModel> weeklyData;
  final SleepDailySummaryModel? todaysSummary;
  final List<double> chartData; // For chart visualization

  const SleepActivityLoaded({
    required this.weeklyData,
    this.todaysSummary,
    required this.chartData,
  });

  SleepActivityLoaded copyWith({
    List<SleepDailySummaryModel>? weeklyData,
    SleepDailySummaryModel? todaysSummary,
    List<double>? chartData,
  }) {
    return SleepActivityLoaded(
      weeklyData: weeklyData ?? this.weeklyData,
      todaysSummary: todaysSummary ?? this.todaysSummary,
      chartData: chartData ?? this.chartData,
    );
  }

  @override
  List<Object?> get props => [weeklyData, todaysSummary, chartData];
}

/// Error state
class SleepActivityError extends SleepActivityState {
  final String message;
  final String? errorCode;

  const SleepActivityError({required this.message, this.errorCode});

  @override
  List<Object?> get props => [message, errorCode];
}
