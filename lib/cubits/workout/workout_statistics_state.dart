import 'package:equatable/equatable.dart';
import '../../data/models/workout_statistics_model.dart';
import '../../data/models/workout_session_model.dart';

/// Workout Statistics States
abstract class WorkoutStatisticsState extends Equatable {
  const WorkoutStatisticsState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class WorkoutStatisticsInitial extends WorkoutStatisticsState {
  const WorkoutStatisticsInitial();
}

/// Loading state
class WorkoutStatisticsLoading extends WorkoutStatisticsState {
  const WorkoutStatisticsLoading();
}

/// Success state with statistics loaded
class WorkoutStatisticsLoaded extends WorkoutStatisticsState {
  final WorkoutStatisticsModel statistics;
  final WeeklyStatisticsModel? weeklyStatistics;
  final MonthlyStatisticsModel? monthlyStatistics;

  const WorkoutStatisticsLoaded({
    required this.statistics,
    this.weeklyStatistics,
    this.monthlyStatistics,
  });

  WorkoutStatisticsLoaded copyWith({
    WorkoutStatisticsModel? statistics,
    WeeklyStatisticsModel? weeklyStatistics,
    MonthlyStatisticsModel? monthlyStatistics,
  }) {
    return WorkoutStatisticsLoaded(
      statistics: statistics ?? this.statistics,
      weeklyStatistics: weeklyStatistics ?? this.weeklyStatistics,
      monthlyStatistics: monthlyStatistics ?? this.monthlyStatistics,
    );
  }

  @override
  List<Object?> get props => [statistics, weeklyStatistics, monthlyStatistics];
}

/// Error state
class WorkoutStatisticsError extends WorkoutStatisticsState {
  final String message;
  final String? errorCode;

  const WorkoutStatisticsError({required this.message, this.errorCode});

  @override
  List<Object?> get props => [message, errorCode];
}

/// Workout History States
abstract class WorkoutHistoryState extends Equatable {
  const WorkoutHistoryState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class WorkoutHistoryInitial extends WorkoutHistoryState {
  const WorkoutHistoryInitial();
}

/// Loading state
class WorkoutHistoryLoading extends WorkoutHistoryState {
  const WorkoutHistoryLoading();
}

/// Success state with history loaded
class WorkoutHistoryLoaded extends WorkoutHistoryState {
  final List<WorkoutSessionModel> sessions;
  final int totalCount;
  final int currentPage;
  final int totalPages;
  final bool isLoadingMore;

  const WorkoutHistoryLoaded({
    required this.sessions,
    required this.totalCount,
    required this.currentPage,
    required this.totalPages,
    this.isLoadingMore = false,
  });

  bool get hasMore => currentPage < totalPages;

  WorkoutHistoryLoaded copyWith({
    List<WorkoutSessionModel>? sessions,
    int? totalCount,
    int? currentPage,
    int? totalPages,
    bool? isLoadingMore,
  }) {
    return WorkoutHistoryLoaded(
      sessions: sessions ?? this.sessions,
      totalCount: totalCount ?? this.totalCount,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }

  @override
  List<Object?> get props => [
    sessions,
    totalCount,
    currentPage,
    totalPages,
    isLoadingMore,
  ];
}

/// Error state
class WorkoutHistoryError extends WorkoutHistoryState {
  final String message;
  final String? errorCode;

  const WorkoutHistoryError({required this.message, this.errorCode});

  @override
  List<Object?> get props => [message, errorCode];
}
