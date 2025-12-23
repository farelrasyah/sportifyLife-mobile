import 'package:equatable/equatable.dart';
import 'exercise_model.dart';
import 'workout_plan_model.dart';

/// Exercise Progress Model
class ExerciseProgressModel extends Equatable {
  final String id;
  final String sessionId;
  final String exerciseId;
  final int? plannedSets;
  final int? plannedReps;
  final double? plannedWeight;
  final int? completedSets;
  final int? completedReps;
  final double? actualWeight;
  final bool isCompleted;
  final DateTime? startTime;
  final DateTime? endTime;
  final String? notes;
  final ExerciseModel? exercise;

  const ExerciseProgressModel({
    required this.id,
    required this.sessionId,
    required this.exerciseId,
    this.plannedSets,
    this.plannedReps,
    this.plannedWeight,
    this.completedSets,
    this.completedReps,
    this.actualWeight,
    this.isCompleted = false,
    this.startTime,
    this.endTime,
    this.notes,
    this.exercise,
  });

  factory ExerciseProgressModel.fromJson(Map<String, dynamic> json) {
    return ExerciseProgressModel(
      id: json['id'] as String? ?? '',
      sessionId: json['sessionId'] as String? ?? '',
      exerciseId: json['exerciseId'] as String? ?? '',
      plannedSets: json['plannedSets'] as int?,
      plannedReps: json['plannedReps'] as int?,
      plannedWeight: (json['plannedWeight'] as num?)?.toDouble(),
      completedSets: json['completedSets'] as int?,
      completedReps: json['completedReps'] as int?,
      actualWeight: (json['actualWeight'] as num?)?.toDouble(),
      isCompleted: json['isCompleted'] as bool? ?? false,
      startTime: json['startTime'] != null
          ? DateTime.parse(json['startTime'] as String)
          : null,
      endTime: json['endTime'] != null
          ? DateTime.parse(json['endTime'] as String)
          : null,
      notes: json['notes'] as String?,
      exercise: json['exercise'] != null
          ? ExerciseModel.fromJson(json['exercise'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sessionId': sessionId,
      'exerciseId': exerciseId,
      'plannedSets': plannedSets,
      'plannedReps': plannedReps,
      'plannedWeight': plannedWeight,
      'completedSets': completedSets,
      'completedReps': completedReps,
      'actualWeight': actualWeight,
      'isCompleted': isCompleted,
      'startTime': startTime?.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
      'notes': notes,
      'exercise': exercise?.toJson(),
    };
  }

  /// For updating progress
  Map<String, dynamic> toUpdateJson() {
    return {
      'exerciseId': exerciseId,
      'completedSets': completedSets,
      'completedReps': completedReps,
      'actualWeight': actualWeight,
      'isCompleted': isCompleted,
      'notes': notes,
    };
  }

  /// Get progress percentage
  double get progressPercent {
    if (plannedSets == null || plannedSets == 0) return 0;
    return ((completedSets ?? 0) / plannedSets!) * 100;
  }

  ExerciseProgressModel copyWith({
    String? id,
    String? sessionId,
    String? exerciseId,
    int? plannedSets,
    int? plannedReps,
    double? plannedWeight,
    int? completedSets,
    int? completedReps,
    double? actualWeight,
    bool? isCompleted,
    DateTime? startTime,
    DateTime? endTime,
    String? notes,
    ExerciseModel? exercise,
  }) {
    return ExerciseProgressModel(
      id: id ?? this.id,
      sessionId: sessionId ?? this.sessionId,
      exerciseId: exerciseId ?? this.exerciseId,
      plannedSets: plannedSets ?? this.plannedSets,
      plannedReps: plannedReps ?? this.plannedReps,
      plannedWeight: plannedWeight ?? this.plannedWeight,
      completedSets: completedSets ?? this.completedSets,
      completedReps: completedReps ?? this.completedReps,
      actualWeight: actualWeight ?? this.actualWeight,
      isCompleted: isCompleted ?? this.isCompleted,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      notes: notes ?? this.notes,
      exercise: exercise ?? this.exercise,
    );
  }

  @override
  List<Object?> get props => [
    id,
    sessionId,
    exerciseId,
    plannedSets,
    plannedReps,
    plannedWeight,
    completedSets,
    completedReps,
    actualWeight,
    isCompleted,
    startTime,
    endTime,
    notes,
    exercise,
  ];
}

/// Workout Session Status
enum WorkoutSessionStatus { active, paused, completed }

/// Workout Session Model
class WorkoutSessionModel extends Equatable {
  final String id;
  final String? userId;
  final String customWorkoutPlanId;
  final String? scheduleId;
  final DateTime startTime;
  final DateTime? endTime;
  final int? caloriesBurned;
  final bool isCompleted;
  final String? overallNotes;
  final int? difficultyRating;
  final int? satisfactionRating;
  final int completedExercisesCount;
  final int totalExercisesCount;
  final int? duration;
  final WorkoutSessionStatus status;
  final DateTime? pausedAt;
  final int? totalPausedTime;
  final CustomWorkoutPlanModel? customWorkoutPlan;
  final List<ExerciseProgressModel> exerciseProgress;
  final DateTime createdAt;

  const WorkoutSessionModel({
    required this.id,
    this.userId,
    required this.customWorkoutPlanId,
    this.scheduleId,
    required this.startTime,
    this.endTime,
    this.caloriesBurned,
    this.isCompleted = false,
    this.overallNotes,
    this.difficultyRating,
    this.satisfactionRating,
    this.completedExercisesCount = 0,
    this.totalExercisesCount = 0,
    this.duration,
    this.status = WorkoutSessionStatus.active,
    this.pausedAt,
    this.totalPausedTime,
    this.customWorkoutPlan,
    this.exerciseProgress = const [],
    required this.createdAt,
  });

  factory WorkoutSessionModel.fromJson(Map<String, dynamic> json) {
    WorkoutSessionStatus status = WorkoutSessionStatus.active;
    if (json['status'] != null) {
      switch (json['status']) {
        case 'paused':
          status = WorkoutSessionStatus.paused;
          break;
        case 'completed':
          status = WorkoutSessionStatus.completed;
          break;
        default:
          status = WorkoutSessionStatus.active;
      }
    } else if (json['isCompleted'] == true) {
      status = WorkoutSessionStatus.completed;
    }

    return WorkoutSessionModel(
      id: json['id'] as String? ?? '',
      userId: json['userId'] as String?,
      customWorkoutPlanId: json['customWorkoutPlanId'] as String? ?? '',
      scheduleId: json['scheduleId'] as String?,
      startTime: json['startTime'] != null
          ? DateTime.parse(json['startTime'] as String)
          : DateTime.now(),
      endTime: json['endTime'] != null
          ? DateTime.parse(json['endTime'] as String)
          : null,
      caloriesBurned: json['caloriesBurned'] as int?,
      isCompleted: json['isCompleted'] as bool? ?? false,
      overallNotes: json['overallNotes'] as String?,
      difficultyRating: json['difficultyRating'] as int?,
      satisfactionRating: json['satisfactionRating'] as int?,
      completedExercisesCount: json['completedExercisesCount'] as int? ?? 0,
      totalExercisesCount: json['totalExercisesCount'] as int? ?? 0,
      duration: json['duration'] as int?,
      status: status,
      pausedAt: json['pausedAt'] != null
          ? DateTime.parse(json['pausedAt'] as String)
          : null,
      totalPausedTime: json['totalPausedTime'] as int?,
      customWorkoutPlan: json['customWorkoutPlan'] != null
          ? CustomWorkoutPlanModel.fromJson(
              json['customWorkoutPlan'] as Map<String, dynamic>,
            )
          : null,
      exerciseProgress:
          (json['exerciseProgress'] as List<dynamic>?)
              ?.map(
                (e) =>
                    ExerciseProgressModel.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          [],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'customWorkoutPlanId': customWorkoutPlanId,
      'scheduleId': scheduleId,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
      'caloriesBurned': caloriesBurned,
      'isCompleted': isCompleted,
      'overallNotes': overallNotes,
      'difficultyRating': difficultyRating,
      'satisfactionRating': satisfactionRating,
      'completedExercisesCount': completedExercisesCount,
      'totalExercisesCount': totalExercisesCount,
      'duration': duration,
      'status': status.name,
      'pausedAt': pausedAt?.toIso8601String(),
      'totalPausedTime': totalPausedTime,
      'customWorkoutPlan': customWorkoutPlan?.toJson(),
      'exerciseProgress': exerciseProgress.map((e) => e.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
    };
  }

  /// Get current duration in minutes
  int get currentDuration {
    if (duration != null) return duration!;
    final now = endTime ?? DateTime.now();
    return now.difference(startTime).inMinutes - (totalPausedTime ?? 0);
  }

  /// Get formatted duration string
  String get formattedDuration {
    final mins = currentDuration;
    if (mins < 60) return '$mins min';
    final hours = mins ~/ 60;
    final remainingMins = mins % 60;
    return remainingMins > 0 ? '$hours h $remainingMins min' : '$hours h';
  }

  /// Get progress percentage
  double get progressPercent {
    if (totalExercisesCount == 0) return 0;
    return (completedExercisesCount / totalExercisesCount) * 100;
  }

  /// Check if session is active
  bool get isActive => status == WorkoutSessionStatus.active;

  /// Check if session is paused
  bool get isPaused => status == WorkoutSessionStatus.paused;

  WorkoutSessionModel copyWith({
    String? id,
    String? userId,
    String? customWorkoutPlanId,
    String? scheduleId,
    DateTime? startTime,
    DateTime? endTime,
    int? caloriesBurned,
    bool? isCompleted,
    String? overallNotes,
    int? difficultyRating,
    int? satisfactionRating,
    int? completedExercisesCount,
    int? totalExercisesCount,
    int? duration,
    WorkoutSessionStatus? status,
    DateTime? pausedAt,
    int? totalPausedTime,
    CustomWorkoutPlanModel? customWorkoutPlan,
    List<ExerciseProgressModel>? exerciseProgress,
    DateTime? createdAt,
  }) {
    return WorkoutSessionModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      customWorkoutPlanId: customWorkoutPlanId ?? this.customWorkoutPlanId,
      scheduleId: scheduleId ?? this.scheduleId,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      caloriesBurned: caloriesBurned ?? this.caloriesBurned,
      isCompleted: isCompleted ?? this.isCompleted,
      overallNotes: overallNotes ?? this.overallNotes,
      difficultyRating: difficultyRating ?? this.difficultyRating,
      satisfactionRating: satisfactionRating ?? this.satisfactionRating,
      completedExercisesCount:
          completedExercisesCount ?? this.completedExercisesCount,
      totalExercisesCount: totalExercisesCount ?? this.totalExercisesCount,
      duration: duration ?? this.duration,
      status: status ?? this.status,
      pausedAt: pausedAt ?? this.pausedAt,
      totalPausedTime: totalPausedTime ?? this.totalPausedTime,
      customWorkoutPlan: customWorkoutPlan ?? this.customWorkoutPlan,
      exerciseProgress: exerciseProgress ?? this.exerciseProgress,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    userId,
    customWorkoutPlanId,
    scheduleId,
    startTime,
    endTime,
    caloriesBurned,
    isCompleted,
    overallNotes,
    difficultyRating,
    satisfactionRating,
    completedExercisesCount,
    totalExercisesCount,
    duration,
    status,
    pausedAt,
    totalPausedTime,
    customWorkoutPlan,
    exerciseProgress,
    createdAt,
  ];
}

/// Start Workout Session Request
class StartWorkoutSessionRequest extends Equatable {
  final String customWorkoutPlanId;
  final String? scheduleId;
  final DateTime? startTime;

  const StartWorkoutSessionRequest({
    required this.customWorkoutPlanId,
    this.scheduleId,
    this.startTime,
  });

  Map<String, dynamic> toJson() {
    return {
      'customWorkoutPlanId': customWorkoutPlanId,
      if (scheduleId != null) 'scheduleId': scheduleId,
      if (startTime != null) 'startTime': startTime!.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [customWorkoutPlanId, scheduleId, startTime];
}

/// Complete Workout Session Request
class CompleteWorkoutSessionRequest {
  final int duration; // Add this property
  final int? caloriesBurned;
  final String? notes;
  final int? rating;
  final List<ExerciseProgressModel> exerciseProgress;

  CompleteWorkoutSessionRequest({
    required this.duration, // Add this required parameter
    this.caloriesBurned,
    this.notes,
    this.rating,
    required this.exerciseProgress,
  });

  Map<String, dynamic> toJson() {
    return {
      'duration': duration,
      if (caloriesBurned != null) 'caloriesBurned': caloriesBurned,
      if (notes != null) 'notes': notes,
      if (rating != null) 'rating': rating,
      'exerciseProgress': exerciseProgress
          .map((e) => e.toUpdateJson())
          .toList(),
    };
  }
}

/// Workout History Response Model
class WorkoutHistoryResponseModel extends Equatable {
  final List<WorkoutSessionModel> data;
  final WorkoutHistoryMeta meta;

  const WorkoutHistoryResponseModel({required this.data, required this.meta});

  factory WorkoutHistoryResponseModel.fromJson(Map<String, dynamic> json) {
    return WorkoutHistoryResponseModel(
      data:
          (json['data'] as List<dynamic>?)
              ?.map(
                (e) => WorkoutSessionModel.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          [],
      meta: json['meta'] != null
          ? WorkoutHistoryMeta.fromJson(json['meta'] as Map<String, dynamic>)
          : const WorkoutHistoryMeta(
              page: 1,
              limit: 20,
              total: 0,
              totalPages: 0,
              hasNextPage: false,
              hasPreviousPage: false,
            ),
    );
  }

  @override
  List<Object?> get props => [data, meta];
}

/// Workout History Meta
class WorkoutHistoryMeta extends Equatable {
  final int page;
  final int limit;
  final int total;
  final int totalPages;
  final bool hasNextPage;
  final bool hasPreviousPage;

  const WorkoutHistoryMeta({
    required this.page,
    required this.limit,
    required this.total,
    required this.totalPages,
    required this.hasNextPage,
    required this.hasPreviousPage,
  });

  factory WorkoutHistoryMeta.fromJson(Map<String, dynamic> json) {
    return WorkoutHistoryMeta(
      page: json['page'] as int? ?? 1,
      limit: json['limit'] as int? ?? 20,
      total: json['total'] as int? ?? 0,
      totalPages: json['totalPages'] as int? ?? 0,
      hasNextPage: json['hasNextPage'] as bool? ?? false,
      hasPreviousPage: json['hasPreviousPage'] as bool? ?? false,
    );
  }

  @override
  List<Object?> get props => [
    page,
    limit,
    total,
    totalPages,
    hasNextPage,
    hasPreviousPage,
  ];
}
