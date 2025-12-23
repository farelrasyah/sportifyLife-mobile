import 'package:equatable/equatable.dart';
import 'exercise_model.dart';

/// Custom Workout Plan Exercise Model
class CustomWorkoutExerciseModel extends Equatable {
  final String id;
  final String exerciseId;
  final int exerciseOrder;
  final int? customReps;
  final int? customSets;
  final double? customWeight;
  final int? restTimeSeconds;
  final String? notes;
  final ExerciseModel? exercise;

  const CustomWorkoutExerciseModel({
    required this.id,
    required this.exerciseId,
    required this.exerciseOrder,
    this.customReps,
    this.customSets,
    this.customWeight,
    this.restTimeSeconds,
    this.notes,
    this.exercise,
  });

  factory CustomWorkoutExerciseModel.fromJson(Map<String, dynamic> json) {
    return CustomWorkoutExerciseModel(
      id: json['id'] as String? ?? '',
      exerciseId: json['exerciseId'] as String? ?? '',
      exerciseOrder: json['exerciseOrder'] as int? ?? 0,
      customReps: json['customReps'] as int?,
      customSets: json['customSets'] as int?,
      customWeight: (json['customWeight'] as num?)?.toDouble(),
      restTimeSeconds: json['restTimeSeconds'] as int?,
      notes: json['notes'] as String?,
      exercise: json['exercise'] != null
          ? ExerciseModel.fromJson(json['exercise'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'exerciseId': exerciseId,
      'exerciseOrder': exerciseOrder,
      'customReps': customReps,
      'customSets': customSets,
      'customWeight': customWeight,
      'restTimeSeconds': restTimeSeconds,
      'notes': notes,
      'exercise': exercise?.toJson(),
    };
  }

  /// For creating a new exercise in workout plan
  Map<String, dynamic> toCreateJson() {
    return {
      'exerciseId': exerciseId,
      'customReps': customReps,
      'customSets': customSets,
      'customWeight': customWeight,
      'restTimeSeconds': restTimeSeconds,
      'notes': notes,
    };
  }

  CustomWorkoutExerciseModel copyWith({
    String? id,
    String? exerciseId,
    int? exerciseOrder,
    int? customReps,
    int? customSets,
    double? customWeight,
    int? restTimeSeconds,
    String? notes,
    ExerciseModel? exercise,
  }) {
    return CustomWorkoutExerciseModel(
      id: id ?? this.id,
      exerciseId: exerciseId ?? this.exerciseId,
      exerciseOrder: exerciseOrder ?? this.exerciseOrder,
      customReps: customReps ?? this.customReps,
      customSets: customSets ?? this.customSets,
      customWeight: customWeight ?? this.customWeight,
      restTimeSeconds: restTimeSeconds ?? this.restTimeSeconds,
      notes: notes ?? this.notes,
      exercise: exercise ?? this.exercise,
    );
  }

  @override
  List<Object?> get props => [
    id,
    exerciseId,
    exerciseOrder,
    customReps,
    customSets,
    customWeight,
    restTimeSeconds,
    notes,
    exercise,
  ];
}

/// Custom Workout Plan Model
class CustomWorkoutPlanModel extends Equatable {
  final String id;
  final String? userId;
  final String name;
  final String? description;
  final String difficulty;
  final List<CustomWorkoutExerciseModel> exercises;
  final int estimatedDurationMinutes;
  final int? estimatedCalories;
  final String? category;
  final List<String> targetMuscleGroups;
  final bool isActive;
  final int timesUsed;
  final double? averageRating;
  final int? exercisesCount;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const CustomWorkoutPlanModel({
    required this.id,
    this.userId,
    required this.name,
    this.description,
    required this.difficulty,
    required this.exercises,
    required this.estimatedDurationMinutes,
    this.estimatedCalories,
    this.category,
    required this.targetMuscleGroups,
    this.isActive = true,
    this.timesUsed = 0,
    this.averageRating,
    this.exercisesCount,
    required this.createdAt,
    this.updatedAt,
  });

  factory CustomWorkoutPlanModel.fromJson(Map<String, dynamic> json) {
    return CustomWorkoutPlanModel(
      id: json['id'] as String? ?? '',
      userId: json['userId'] as String?,
      name: json['name'] as String? ?? '',
      description: json['description'] as String?,
      difficulty: json['difficulty'] as String? ?? 'beginner',
      exercises:
          (json['exercises'] as List<dynamic>?)
              ?.map(
                (e) => CustomWorkoutExerciseModel.fromJson(
                  e as Map<String, dynamic>,
                ),
              )
              .toList() ??
          [],
      estimatedDurationMinutes: json['estimatedDurationMinutes'] as int? ?? 0,
      estimatedCalories: json['estimatedCalories'] as int?,
      category: json['category'] as String?,
      targetMuscleGroups:
          (json['targetMuscleGroups'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      isActive: json['isActive'] as bool? ?? true,
      timesUsed: json['timesUsed'] as int? ?? 0,
      averageRating: (json['averageRating'] as num?)?.toDouble(),
      exercisesCount: json['exercisesCount'] as int?,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'name': name,
      'description': description,
      'difficulty': difficulty,
      'exercises': exercises.map((e) => e.toJson()).toList(),
      'estimatedDurationMinutes': estimatedDurationMinutes,
      'estimatedCalories': estimatedCalories,
      'category': category,
      'targetMuscleGroups': targetMuscleGroups,
      'isActive': isActive,
      'timesUsed': timesUsed,
      'averageRating': averageRating,
      'exercisesCount': exercisesCount,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  /// For creating a new workout plan
  Map<String, dynamic> toCreateJson() {
    return {
      'name': name,
      'description': description,
      'difficulty': difficulty,
      'exercises': exercises.map((e) => e.toCreateJson()).toList(),
      'estimatedDurationMinutes': estimatedDurationMinutes,
      'estimatedCalories': estimatedCalories,
      'category': category,
      'targetMuscleGroups': targetMuscleGroups,
    };
  }

  /// Get total exercise count
  int get totalExercises => exercisesCount ?? exercises.length;

  /// Get formatted duration string
  String get formattedDuration {
    if (estimatedDurationMinutes < 60) {
      return '$estimatedDurationMinutes min';
    }
    final hours = estimatedDurationMinutes ~/ 60;
    final mins = estimatedDurationMinutes % 60;
    return mins > 0 ? '$hours h $mins min' : '$hours h';
  }

  /// Get difficulty label
  String get difficultyLabel {
    switch (difficulty.toLowerCase()) {
      case 'beginner':
        return 'Beginner';
      case 'intermediate':
        return 'Intermediate';
      case 'advanced':
        return 'Advanced';
      default:
        return difficulty;
    }
  }

  CustomWorkoutPlanModel copyWith({
    String? id,
    String? userId,
    String? name,
    String? description,
    String? difficulty,
    List<CustomWorkoutExerciseModel>? exercises,
    int? estimatedDurationMinutes,
    int? estimatedCalories,
    String? category,
    List<String>? targetMuscleGroups,
    bool? isActive,
    int? timesUsed,
    double? averageRating,
    int? exercisesCount,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CustomWorkoutPlanModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      description: description ?? this.description,
      difficulty: difficulty ?? this.difficulty,
      exercises: exercises ?? this.exercises,
      estimatedDurationMinutes:
          estimatedDurationMinutes ?? this.estimatedDurationMinutes,
      estimatedCalories: estimatedCalories ?? this.estimatedCalories,
      category: category ?? this.category,
      targetMuscleGroups: targetMuscleGroups ?? this.targetMuscleGroups,
      isActive: isActive ?? this.isActive,
      timesUsed: timesUsed ?? this.timesUsed,
      averageRating: averageRating ?? this.averageRating,
      exercisesCount: exercisesCount ?? this.exercisesCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    userId,
    name,
    description,
    difficulty,
    exercises,
    estimatedDurationMinutes,
    estimatedCalories,
    category,
    targetMuscleGroups,
    isActive,
    timesUsed,
    averageRating,
    exercisesCount,
    createdAt,
    updatedAt,
  ];
}

/// Workout Schedule Model
class WorkoutScheduleModel extends Equatable {
  final String id;
  final String? userId;
  final String customWorkoutPlanId;
  final String scheduledDate;
  final String scheduledTime;
  final bool reminderEnabled;
  final String? reminderMessage;
  final int reminderMinutesBefore;
  final bool isCompleted;
  final bool isActive;
  final CustomWorkoutPlanModel? customWorkoutPlan;
  final DateTime createdAt;

  const WorkoutScheduleModel({
    required this.id,
    this.userId,
    required this.customWorkoutPlanId,
    required this.scheduledDate,
    required this.scheduledTime,
    this.reminderEnabled = true,
    this.reminderMessage,
    this.reminderMinutesBefore = 15,
    this.isCompleted = false,
    this.isActive = true,
    this.customWorkoutPlan,
    required this.createdAt,
  });

  factory WorkoutScheduleModel.fromJson(Map<String, dynamic> json) {
    return WorkoutScheduleModel(
      id: json['id'] as String? ?? '',
      userId: json['userId'] as String?,
      customWorkoutPlanId: json['customWorkoutPlanId'] as String? ?? '',
      scheduledDate: json['scheduledDate'] as String? ?? '',
      scheduledTime: json['scheduledTime'] as String? ?? '',
      reminderEnabled: json['reminderEnabled'] as bool? ?? true,
      reminderMessage: json['reminderMessage'] as String?,
      reminderMinutesBefore: json['reminderMinutesBefore'] as int? ?? 15,
      isCompleted: json['isCompleted'] as bool? ?? false,
      isActive: json['isActive'] as bool? ?? true,
      customWorkoutPlan: json['customWorkoutPlan'] != null
          ? CustomWorkoutPlanModel.fromJson(
              json['customWorkoutPlan'] as Map<String, dynamic>,
            )
          : null,
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
      'scheduledDate': scheduledDate,
      'scheduledTime': scheduledTime,
      'reminderEnabled': reminderEnabled,
      'reminderMessage': reminderMessage,
      'reminderMinutesBefore': reminderMinutesBefore,
      'isCompleted': isCompleted,
      'isActive': isActive,
      'customWorkoutPlan': customWorkoutPlan?.toJson(),
      'createdAt': createdAt.toIso8601String(),
    };
  }

  /// For creating a new schedule
  Map<String, dynamic> toCreateJson() {
    return {
      'customWorkoutPlanId': customWorkoutPlanId,
      'scheduledDate': scheduledDate,
      'scheduledTime': scheduledTime,
      'reminderEnabled': reminderEnabled,
      'reminderMessage': reminderMessage,
      'reminderMinutesBefore': reminderMinutesBefore,
    };
  }

  /// Get scheduled DateTime
  DateTime get scheduledDateTime {
    try {
      return DateTime.parse('$scheduledDate $scheduledTime');
    } catch (e) {
      return DateTime.now();
    }
  }

  /// Get formatted date time string
  String get formattedSchedule {
    final date = DateTime.tryParse(scheduledDate);
    if (date == null) return '$scheduledDate, $scheduledTime';

    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    return '${months[date.month - 1]} ${date.day}, $scheduledTime';
  }

  WorkoutScheduleModel copyWith({
    String? id,
    String? userId,
    String? customWorkoutPlanId,
    String? scheduledDate,
    String? scheduledTime,
    bool? reminderEnabled,
    String? reminderMessage,
    int? reminderMinutesBefore,
    bool? isCompleted,
    bool? isActive,
    CustomWorkoutPlanModel? customWorkoutPlan,
    DateTime? createdAt,
  }) {
    return WorkoutScheduleModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      customWorkoutPlanId: customWorkoutPlanId ?? this.customWorkoutPlanId,
      scheduledDate: scheduledDate ?? this.scheduledDate,
      scheduledTime: scheduledTime ?? this.scheduledTime,
      reminderEnabled: reminderEnabled ?? this.reminderEnabled,
      reminderMessage: reminderMessage ?? this.reminderMessage,
      reminderMinutesBefore:
          reminderMinutesBefore ?? this.reminderMinutesBefore,
      isCompleted: isCompleted ?? this.isCompleted,
      isActive: isActive ?? this.isActive,
      customWorkoutPlan: customWorkoutPlan ?? this.customWorkoutPlan,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    userId,
    customWorkoutPlanId,
    scheduledDate,
    scheduledTime,
    reminderEnabled,
    reminderMessage,
    reminderMinutesBefore,
    isCompleted,
    isActive,
    customWorkoutPlan,
    createdAt,
  ];
}
