import 'package:equatable/equatable.dart';

/// Workout Model - berdasarkan API GET /workouts
class WorkoutModel extends Equatable {
  final String id;
  final String name;
  final String level;
  final String category;
  final String description;
  final int exerciseCount;

  const WorkoutModel({
    required this.id,
    required this.name,
    required this.level,
    required this.category,
    required this.description,
    required this.exerciseCount,
  });

  factory WorkoutModel.fromJson(Map<String, dynamic> json) {
    return WorkoutModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      level: json['level'] as String? ?? 'beginner',
      category: json['category'] as String? ?? 'fullbody',
      description: json['description'] as String? ?? '',
      exerciseCount: json['exerciseCount'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'level': level,
      'category': category,
      'description': description,
      'exerciseCount': exerciseCount,
    };
  }

  /// Get display level
  String get displayLevel {
    switch (level.toLowerCase()) {
      case 'beginner':
        return 'Pemula';
      case 'intermediate':
        return 'Menengah';
      case 'advanced':
        return 'Lanjutan';
      default:
        return level;
    }
  }

  /// Get display category
  String get displayCategory {
    switch (category.toLowerCase().replaceAll('_', '')) {
      case 'fullbody':
      case 'full body':
        return 'Full Body';
      case 'strength':
        return 'Strength';
      case 'cardio':
        return 'Cardio';
      case 'flexibility':
        return 'Flexibility';
      case 'balance':
        return 'Balance';
      default:
        return category;
    }
  }

  @override
  List<Object?> get props => [
    id,
    name,
    level,
    category,
    description,
    exerciseCount,
  ];
}

/// Workout Exercise Model - exercise di dalam workout detail
class WorkoutExerciseModel extends Equatable {
  final String id;
  final String exerciseId;
  final String exerciseName;
  final int order;
  final int? sets;
  final int? reps;
  final int? durationSeconds;
  final int? restSeconds;

  const WorkoutExerciseModel({
    required this.id,
    required this.exerciseId,
    required this.exerciseName,
    required this.order,
    this.sets,
    this.reps,
    this.durationSeconds,
    this.restSeconds,
  });

  factory WorkoutExerciseModel.fromJson(Map<String, dynamic> json) {
    return WorkoutExerciseModel(
      id: json['id'] as String? ?? '',
      exerciseId: json['exerciseId'] as String? ?? '',
      exerciseName: json['exerciseName'] as String? ?? '',
      order: json['order'] as int? ?? 0,
      sets: json['sets'] as int?,
      reps: json['reps'] as int?,
      durationSeconds: json['durationSeconds'] as int?,
      restSeconds: json['restSeconds'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'exerciseId': exerciseId,
      'exerciseName': exerciseName,
      'order': order,
      'sets': sets,
      'reps': reps,
      'durationSeconds': durationSeconds,
      'restSeconds': restSeconds,
    };
  }

  /// Get formatted sets/reps or duration string
  String get formattedSetReps {
    if (durationSeconds != null && durationSeconds! > 0) {
      return '${sets ?? 1} sets x ${durationSeconds}s';
    }
    return '${sets ?? 1} sets x ${reps ?? 0} reps';
  }

  @override
  List<Object?> get props => [
    id,
    exerciseId,
    exerciseName,
    order,
    sets,
    reps,
    durationSeconds,
    restSeconds,
  ];
}

/// Workout Detail Model - detail workout dengan exercises
class WorkoutDetailModel extends Equatable {
  final String id;
  final String name;
  final String level;
  final String category;
  final String description;
  final List<WorkoutExerciseModel> exercises;
  final DateTime createdAt;
  final DateTime updatedAt;

  const WorkoutDetailModel({
    required this.id,
    required this.name,
    required this.level,
    required this.category,
    required this.description,
    required this.exercises,
    required this.createdAt,
    required this.updatedAt,
  });

  factory WorkoutDetailModel.fromJson(Map<String, dynamic> json) {
    return WorkoutDetailModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      level: json['level'] as String? ?? 'beginner',
      category: json['category'] as String? ?? 'fullbody',
      description: json['description'] as String? ?? '',
      exercises:
          (json['exercises'] as List<dynamic>?)
              ?.map(
                (e) => WorkoutExerciseModel.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          [],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'level': level,
      'category': category,
      'description': description,
      'exercises': exercises.map((e) => e.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  int get exerciseCount => exercises.length;

  /// Get display level
  String get displayLevel {
    switch (level.toLowerCase()) {
      case 'beginner':
        return 'Pemula';
      case 'intermediate':
        return 'Menengah';
      case 'advanced':
        return 'Lanjutan';
      default:
        return level;
    }
  }

  /// Get display category
  String get displayCategory {
    switch (category.toLowerCase().replaceAll('_', '')) {
      case 'fullbody':
      case 'full body':
        return 'Full Body';
      case 'strength':
        return 'Strength';
      case 'cardio':
        return 'Cardio';
      case 'flexibility':
        return 'Flexibility';
      case 'balance':
        return 'Balance';
      default:
        return category;
    }
  }

  @override
  List<Object?> get props => [
    id,
    name,
    level,
    category,
    description,
    exercises,
    createdAt,
    updatedAt,
  ];
}

/// Paginated Workouts Response Model
class PaginatedWorkoutsModel extends Equatable {
  final List<WorkoutModel> data;
  final int total;
  final int page;
  final int limit;
  final int totalPages;

  const PaginatedWorkoutsModel({
    required this.data,
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
  });

  factory PaginatedWorkoutsModel.fromJson(Map<String, dynamic> json) {
    // Handle nested response structure: { success: true, data: { data: [...], meta: {...} } }
    final responseData = json['data'] as Map<String, dynamic>?;
    final workoutsData = responseData?['data'] as List<dynamic>? ?? [];
    final meta = responseData?['meta'] as Map<String, dynamic>? ?? {};

    return PaginatedWorkoutsModel(
      data: workoutsData
          .map((e) => WorkoutModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: meta['total'] as int? ?? 0,
      page: meta['page'] as int? ?? 1,
      limit: meta['limit'] as int? ?? 10,
      totalPages: meta['totalPages'] as int? ?? 0,
    );
  }

  bool get hasMore => page < totalPages;

  @override
  List<Object?> get props => [data, total, page, limit, totalPages];
}

/// New Workout Session Model - sesuai API baru
class NewWorkoutSessionModel extends Equatable {
  final String id;
  final String workoutId;
  final String workoutName;
  final DateTime startTime;
  final DateTime? endTime;
  final int? caloriesBurned;
  final String? notes;
  final DateTime createdAt;

  const NewWorkoutSessionModel({
    required this.id,
    required this.workoutId,
    required this.workoutName,
    required this.startTime,
    this.endTime,
    this.caloriesBurned,
    this.notes,
    required this.createdAt,
  });

  factory NewWorkoutSessionModel.fromJson(Map<String, dynamic> json) {
    return NewWorkoutSessionModel(
      id: json['id'] as String? ?? '',
      workoutId: json['workoutId'] as String? ?? '',
      workoutName: json['workoutName'] as String? ?? '',
      startTime: json['startTime'] != null
          ? DateTime.parse(json['startTime'] as String)
          : DateTime.now(),
      endTime: json['endTime'] != null
          ? DateTime.parse(json['endTime'] as String)
          : null,
      caloriesBurned: json['caloriesBurned'] as int?,
      notes: json['notes'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'workoutId': workoutId,
      'workoutName': workoutName,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
      'caloriesBurned': caloriesBurned,
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  /// Get formatted duration
  String get formattedDuration {
    if (endTime == null) return 'In Progress';
    final duration = endTime!.difference(startTime);
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    }
    return '${minutes}m';
  }

  /// Check if session is completed
  bool get isCompleted => endTime != null;

  @override
  List<Object?> get props => [
    id,
    workoutId,
    workoutName,
    startTime,
    endTime,
    caloriesBurned,
    notes,
    createdAt,
  ];
}

/// New Workout Schedule Model - sesuai API baru
class NewWorkoutScheduleModel extends Equatable {
  final String id;
  final String workoutId;
  final String workoutName;
  final DateTime scheduledDate;
  final String? scheduledTime;
  final bool reminderEnabled;
  final DateTime createdAt;

  const NewWorkoutScheduleModel({
    required this.id,
    required this.workoutId,
    required this.workoutName,
    required this.scheduledDate,
    this.scheduledTime,
    required this.reminderEnabled,
    required this.createdAt,
  });

  factory NewWorkoutScheduleModel.fromJson(Map<String, dynamic> json) {
    return NewWorkoutScheduleModel(
      id: json['id'] as String? ?? '',
      workoutId: json['workoutId'] as String? ?? '',
      workoutName: json['workoutName'] as String? ?? '',
      scheduledDate: json['scheduledDate'] != null
          ? DateTime.parse(json['scheduledDate'] as String)
          : DateTime.now(),
      scheduledTime: json['scheduledTime'] as String?,
      reminderEnabled: json['reminderEnabled'] as bool? ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'workoutId': workoutId,
      'workoutName': workoutName,
      'scheduledDate': scheduledDate.toIso8601String(),
      'scheduledTime': scheduledTime,
      'reminderEnabled': reminderEnabled,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  /// Create request body for creating schedule
  Map<String, dynamic> toCreateJson() {
    return {
      'workoutId': workoutId,
      'scheduledDate': scheduledDate.toIso8601String(),
      if (scheduledTime != null) 'scheduledTime': scheduledTime,
      'reminderEnabled': reminderEnabled,
    };
  }

  /// Get formatted date
  String get formattedDate {
    return '${scheduledDate.day}/${scheduledDate.month}/${scheduledDate.year}';
  }

  /// Get formatted date and time
  String get formattedDateTime {
    if (scheduledTime != null && scheduledTime!.isNotEmpty) {
      return '${formattedDate}, $scheduledTime';
    }
    return formattedDate;
  }

  /// Check if schedule is today
  bool get isToday {
    final now = DateTime.now();
    return scheduledDate.year == now.year &&
        scheduledDate.month == now.month &&
        scheduledDate.day == now.day;
  }

  /// Check if schedule is upcoming (after today)
  bool get isUpcoming {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final scheduleDay = DateTime(
      scheduledDate.year,
      scheduledDate.month,
      scheduledDate.day,
    );
    return scheduleDay.isAfter(today);
  }

  NewWorkoutScheduleModel copyWith({
    String? id,
    String? workoutId,
    String? workoutName,
    DateTime? scheduledDate,
    String? scheduledTime,
    bool? reminderEnabled,
    DateTime? createdAt,
  }) {
    return NewWorkoutScheduleModel(
      id: id ?? this.id,
      workoutId: workoutId ?? this.workoutId,
      workoutName: workoutName ?? this.workoutName,
      scheduledDate: scheduledDate ?? this.scheduledDate,
      scheduledTime: scheduledTime ?? this.scheduledTime,
      reminderEnabled: reminderEnabled ?? this.reminderEnabled,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    workoutId,
    workoutName,
    scheduledDate,
    scheduledTime,
    reminderEnabled,
    createdAt,
  ];
}

/// Weekly Progress Model - sesuai API baru
class WeeklyProgressModel extends Equatable {
  final DateTime weekStart;
  final DateTime weekEnd;
  final int totalSessions;
  final int totalCalories;
  final int totalDuration;
  final List<DailyProgressModel> dailyProgress;

  const WeeklyProgressModel({
    required this.weekStart,
    required this.weekEnd,
    required this.totalSessions,
    required this.totalCalories,
    required this.totalDuration,
    required this.dailyProgress,
  });

  factory WeeklyProgressModel.fromJson(Map<String, dynamic> json) {
    return WeeklyProgressModel(
      weekStart: json['weekStart'] != null
          ? DateTime.parse(json['weekStart'] as String)
          : DateTime.now().subtract(const Duration(days: 7)),
      weekEnd: json['weekEnd'] != null
          ? DateTime.parse(json['weekEnd'] as String)
          : DateTime.now(),
      totalSessions: json['totalSessions'] as int? ?? 0,
      totalCalories: json['totalCalories'] as int? ?? 0,
      totalDuration: json['totalDuration'] as int? ?? 0,
      dailyProgress:
          (json['dailyProgress'] as List<dynamic>?)
              ?.map(
                (e) => DailyProgressModel.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'weekStart': weekStart.toIso8601String(),
      'weekEnd': weekEnd.toIso8601String(),
      'totalSessions': totalSessions,
      'totalCalories': totalCalories,
      'totalDuration': totalDuration,
      'dailyProgress': dailyProgress.map((e) => e.toJson()).toList(),
    };
  }

  /// Get formatted total duration
  String get formattedTotalDuration {
    if (totalDuration < 60) return '$totalDuration min';
    final hours = totalDuration ~/ 60;
    final mins = totalDuration % 60;
    return mins > 0 ? '$hours h $mins min' : '$hours h';
  }

  @override
  List<Object?> get props => [
    weekStart,
    weekEnd,
    totalSessions,
    totalCalories,
    totalDuration,
    dailyProgress,
  ];
}

/// Daily Progress Model
class DailyProgressModel extends Equatable {
  final String date;
  final int sessions;
  final int calories;
  final int duration;

  const DailyProgressModel({
    required this.date,
    required this.sessions,
    required this.calories,
    required this.duration,
  });

  factory DailyProgressModel.fromJson(Map<String, dynamic> json) {
    return DailyProgressModel(
      date: json['date'] as String? ?? '',
      sessions: json['sessions'] as int? ?? 0,
      calories: json['calories'] as int? ?? 0,
      duration: json['duration'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'sessions': sessions,
      'calories': calories,
      'duration': duration,
    };
  }

  /// Get DateTime from date string
  DateTime? get dateTime {
    try {
      return DateTime.parse(date);
    } catch (e) {
      return null;
    }
  }

  @override
  List<Object?> get props => [date, sessions, calories, duration];
}

/// Workout Level Enum
enum WorkoutLevel {
  beginner,
  intermediate,
  advanced;

  String get value {
    switch (this) {
      case WorkoutLevel.beginner:
        return 'beginner';
      case WorkoutLevel.intermediate:
        return 'intermediate';
      case WorkoutLevel.advanced:
        return 'advanced';
    }
  }

  String get displayName {
    switch (this) {
      case WorkoutLevel.beginner:
        return 'Pemula';
      case WorkoutLevel.intermediate:
        return 'Menengah';
      case WorkoutLevel.advanced:
        return 'Lanjutan';
    }
  }

  static WorkoutLevel? fromString(String? value) {
    if (value == null) return null;
    switch (value.toLowerCase()) {
      case 'beginner':
        return WorkoutLevel.beginner;
      case 'intermediate':
        return WorkoutLevel.intermediate;
      case 'advanced':
        return WorkoutLevel.advanced;
      default:
        return null;
    }
  }
}

/// Workout Category Enum
enum WorkoutCategory {
  fullBody,
  upperBody,
  lowerBody,
  abs,
  cardio,
  flexibility;

  String get value {
    switch (this) {
      case WorkoutCategory.fullBody:
        return 'fullbody';
      case WorkoutCategory.upperBody:
        return 'upper';
      case WorkoutCategory.lowerBody:
        return 'lower';
      case WorkoutCategory.abs:
        return 'abs';
      case WorkoutCategory.cardio:
        return 'cardio';
      case WorkoutCategory.flexibility:
        return 'flexibility';
    }
  }

  String get displayName {
    switch (this) {
      case WorkoutCategory.fullBody:
        return 'Full Body';
      case WorkoutCategory.upperBody:
        return 'Upper Body';
      case WorkoutCategory.lowerBody:
        return 'Lower Body';
      case WorkoutCategory.abs:
        return 'Abs';
      case WorkoutCategory.cardio:
        return 'Cardio';
      case WorkoutCategory.flexibility:
        return 'Flexibility';
    }
  }

  static WorkoutCategory? fromString(String? value) {
    if (value == null) return null;
    switch (value.toLowerCase().trim()) {
      case 'fullbody':
      case 'full_body':
      case 'full body':
        return WorkoutCategory.fullBody;
      case 'upper':
      case 'upper_body':
      case 'upperbody':
        return WorkoutCategory.upperBody;
      case 'lower':
      case 'lower_body':
      case 'lowerbody':
        return WorkoutCategory.lowerBody;
      case 'abs':
        return WorkoutCategory.abs;
      case 'cardio':
        return WorkoutCategory.cardio;
      case 'flexibility':
        return WorkoutCategory.flexibility;
      default:
        return null;
    }
  }
}
