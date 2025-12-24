import 'package:equatable/equatable.dart';

/// Weekly Statistics Model
/// Represents workout statistics for the current week
class WeeklyStatisticsModel extends Equatable {
  final int completedWorkouts;
  final int totalWorkouts;
  final double totalCalories;
  final double totalDuration; // in minutes
  final List<DailyWorkoutModel> dailyWorkouts;

  const WeeklyStatisticsModel({
    required this.completedWorkouts,
    required this.totalWorkouts,
    required this.totalCalories,
    required this.totalDuration,
    required this.dailyWorkouts,
  });

  /// Calculate completion percentage
  double get completionPercentage {
    if (totalWorkouts == 0) return 0.0;
    return (completedWorkouts / totalWorkouts) * 100;
  }

  /// Factory constructor from JSON
  factory WeeklyStatisticsModel.fromJson(Map<String, dynamic> json) {
    return WeeklyStatisticsModel(
      completedWorkouts: json['completed_workouts'] as int? ?? 0,
      totalWorkouts: json['total_workouts'] as int? ?? 0,
      totalCalories: (json['total_calories'] as num?)?.toDouble() ?? 0.0,
      totalDuration: (json['total_duration'] as num?)?.toDouble() ?? 0.0,
      dailyWorkouts:
          (json['daily_workouts'] as List<dynamic>?)
              ?.map(
                (e) => DailyWorkoutModel.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          [],
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'completed_workouts': completedWorkouts,
      'total_workouts': totalWorkouts,
      'total_calories': totalCalories,
      'total_duration': totalDuration,
      'daily_workouts': dailyWorkouts.map((e) => e.toJson()).toList(),
    };
  }

  /// Create a copy with updated fields
  WeeklyStatisticsModel copyWith({
    int? completedWorkouts,
    int? totalWorkouts,
    double? totalCalories,
    double? totalDuration,
    List<DailyWorkoutModel>? dailyWorkouts,
  }) {
    return WeeklyStatisticsModel(
      completedWorkouts: completedWorkouts ?? this.completedWorkouts,
      totalWorkouts: totalWorkouts ?? this.totalWorkouts,
      totalCalories: totalCalories ?? this.totalCalories,
      totalDuration: totalDuration ?? this.totalDuration,
      dailyWorkouts: dailyWorkouts ?? this.dailyWorkouts,
    );
  }

  @override
  List<Object?> get props => [
    completedWorkouts,
    totalWorkouts,
    totalCalories,
    totalDuration,
    dailyWorkouts,
  ];
}

/// Daily Workout Model
/// Represents workout data for a single day
class DailyWorkoutModel extends Equatable {
  final String day; // e.g., "Mon", "Tue", etc.
  final DateTime date;
  final int workoutsCompleted;
  final bool isToday;

  const DailyWorkoutModel({
    required this.day,
    required this.date,
    required this.workoutsCompleted,
    this.isToday = false,
  });

  /// Factory constructor from JSON
  factory DailyWorkoutModel.fromJson(Map<String, dynamic> json) {
    return DailyWorkoutModel(
      day: json['day'] as String? ?? '',
      date: DateTime.parse(json['date'] as String),
      workoutsCompleted: json['workouts_completed'] as int? ?? 0,
      isToday: json['is_today'] as bool? ?? false,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'day': day,
      'date': date.toIso8601String(),
      'workouts_completed': workoutsCompleted,
      'is_today': isToday,
    };
  }

  @override
  List<Object?> get props => [day, date, workoutsCompleted, isToday];
}
