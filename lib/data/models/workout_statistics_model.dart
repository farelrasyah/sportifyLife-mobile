import 'package:equatable/equatable.dart';

/// Workout Statistics Model
class WorkoutStatisticsModel extends Equatable {
  final int totalWorkouts;
  final int totalMinutes;
  final int totalCalories;
  final double averageWorkoutDuration;
  final double averageCaloriesPerWorkout;
  final double completionRate;
  final FavoriteWorkoutPlan? favoriteWorkoutPlan;
  final WeeklyAverageModel weeklyAverage;
  final MonthlyProgressModel monthlyProgress;
  final Map<String, int> difficultyDistribution;
  final AverageRatingsModel averageRatings;

  const WorkoutStatisticsModel({
    required this.totalWorkouts,
    required this.totalMinutes,
    required this.totalCalories,
    required this.averageWorkoutDuration,
    required this.averageCaloriesPerWorkout,
    required this.completionRate,
    this.favoriteWorkoutPlan,
    required this.weeklyAverage,
    required this.monthlyProgress,
    required this.difficultyDistribution,
    required this.averageRatings,
  });

  factory WorkoutStatisticsModel.fromJson(Map<String, dynamic> json) {
    return WorkoutStatisticsModel(
      totalWorkouts: json['totalWorkouts'] as int? ?? 0,
      totalMinutes: json['totalMinutes'] as int? ?? 0,
      totalCalories: json['totalCalories'] as int? ?? 0,
      averageWorkoutDuration:
          (json['averageWorkoutDuration'] as num?)?.toDouble() ?? 0,
      averageCaloriesPerWorkout:
          (json['averageCaloriesPerWorkout'] as num?)?.toDouble() ?? 0,
      completionRate: (json['completionRate'] as num?)?.toDouble() ?? 0,
      favoriteWorkoutPlan: json['favoriteWorkoutPlan'] != null
          ? FavoriteWorkoutPlan.fromJson(
              json['favoriteWorkoutPlan'] as Map<String, dynamic>,
            )
          : null,
      weeklyAverage: json['weeklyAverage'] != null
          ? WeeklyAverageModel.fromJson(
              json['weeklyAverage'] as Map<String, dynamic>,
            )
          : const WeeklyAverageModel(workouts: 0, minutes: 0, calories: 0),
      monthlyProgress: json['monthlyProgress'] != null
          ? MonthlyProgressModel.fromJson(
              json['monthlyProgress'] as Map<String, dynamic>,
            )
          : MonthlyProgressModel.empty(),
      difficultyDistribution:
          (json['difficultyDistribution'] as Map<String, dynamic>?)?.map(
            (key, value) => MapEntry(key, (value as num).toInt()),
          ) ??
          {},
      averageRatings: json['averageRatings'] != null
          ? AverageRatingsModel.fromJson(
              json['averageRatings'] as Map<String, dynamic>,
            )
          : const AverageRatingsModel(difficulty: 0, satisfaction: 0),
    );
  }

  factory WorkoutStatisticsModel.empty() {
    return WorkoutStatisticsModel(
      totalWorkouts: 0,
      totalMinutes: 0,
      totalCalories: 0,
      averageWorkoutDuration: 0,
      averageCaloriesPerWorkout: 0,
      completionRate: 0,
      weeklyAverage: const WeeklyAverageModel(
        workouts: 0,
        minutes: 0,
        calories: 0,
      ),
      monthlyProgress: MonthlyProgressModel.empty(),
      difficultyDistribution: {},
      averageRatings: const AverageRatingsModel(difficulty: 0, satisfaction: 0),
    );
  }

  /// Get formatted total duration
  String get formattedTotalDuration {
    if (totalMinutes < 60) return '$totalMinutes min';
    final hours = totalMinutes ~/ 60;
    final mins = totalMinutes % 60;
    return mins > 0 ? '$hours h $mins min' : '$hours h';
  }

  @override
  List<Object?> get props => [
    totalWorkouts,
    totalMinutes,
    totalCalories,
    averageWorkoutDuration,
    averageCaloriesPerWorkout,
    completionRate,
    favoriteWorkoutPlan,
    weeklyAverage,
    monthlyProgress,
    difficultyDistribution,
    averageRatings,
  ];
}

/// Favorite Workout Plan
class FavoriteWorkoutPlan extends Equatable {
  final String name;
  final int timesUsed;

  const FavoriteWorkoutPlan({required this.name, required this.timesUsed});

  factory FavoriteWorkoutPlan.fromJson(Map<String, dynamic> json) {
    return FavoriteWorkoutPlan(
      name: json['name'] as String? ?? '',
      timesUsed: json['timesUsed'] as int? ?? 0,
    );
  }

  @override
  List<Object?> get props => [name, timesUsed];
}

/// Weekly Average Model
class WeeklyAverageModel extends Equatable {
  final double workouts;
  final int minutes;
  final int calories;

  const WeeklyAverageModel({
    required this.workouts,
    required this.minutes,
    required this.calories,
  });

  factory WeeklyAverageModel.fromJson(Map<String, dynamic> json) {
    return WeeklyAverageModel(
      workouts: (json['workouts'] as num?)?.toDouble() ?? 0,
      minutes: json['minutes'] as int? ?? 0,
      calories: json['calories'] as int? ?? 0,
    );
  }

  @override
  List<Object?> get props => [workouts, minutes, calories];
}

/// Monthly Progress Model
class MonthlyProgressModel extends Equatable {
  final MonthDataModel thisMonth;
  final MonthDataModel lastMonth;
  final ChangePercentageModel changePercentage;

  const MonthlyProgressModel({
    required this.thisMonth,
    required this.lastMonth,
    required this.changePercentage,
  });

  factory MonthlyProgressModel.fromJson(Map<String, dynamic> json) {
    return MonthlyProgressModel(
      thisMonth: json['thisMonth'] != null
          ? MonthDataModel.fromJson(json['thisMonth'] as Map<String, dynamic>)
          : MonthDataModel.empty(),
      lastMonth: json['lastMonth'] != null
          ? MonthDataModel.fromJson(json['lastMonth'] as Map<String, dynamic>)
          : MonthDataModel.empty(),
      changePercentage: json['changePercentage'] != null
          ? ChangePercentageModel.fromJson(
              json['changePercentage'] as Map<String, dynamic>,
            )
          : const ChangePercentageModel(workouts: 0, minutes: 0, calories: 0),
    );
  }

  factory MonthlyProgressModel.empty() {
    return MonthlyProgressModel(
      thisMonth: MonthDataModel.empty(),
      lastMonth: MonthDataModel.empty(),
      changePercentage: const ChangePercentageModel(
        workouts: 0,
        minutes: 0,
        calories: 0,
      ),
    );
  }

  @override
  List<Object?> get props => [thisMonth, lastMonth, changePercentage];
}

/// Month Data Model
class MonthDataModel extends Equatable {
  final int workouts;
  final int minutes;
  final int calories;

  const MonthDataModel({
    required this.workouts,
    required this.minutes,
    required this.calories,
  });

  factory MonthDataModel.fromJson(Map<String, dynamic> json) {
    return MonthDataModel(
      workouts: json['workouts'] as int? ?? 0,
      minutes: json['minutes'] as int? ?? 0,
      calories: json['calories'] as int? ?? 0,
    );
  }

  factory MonthDataModel.empty() {
    return const MonthDataModel(workouts: 0, minutes: 0, calories: 0);
  }

  @override
  List<Object?> get props => [workouts, minutes, calories];
}

/// Change Percentage Model
class ChangePercentageModel extends Equatable {
  final double workouts;
  final double minutes;
  final double calories;

  const ChangePercentageModel({
    required this.workouts,
    required this.minutes,
    required this.calories,
  });

  factory ChangePercentageModel.fromJson(Map<String, dynamic> json) {
    return ChangePercentageModel(
      workouts: (json['workouts'] as num?)?.toDouble() ?? 0,
      minutes: (json['minutes'] as num?)?.toDouble() ?? 0,
      calories: (json['calories'] as num?)?.toDouble() ?? 0,
    );
  }

  @override
  List<Object?> get props => [workouts, minutes, calories];
}

/// Average Ratings Model
class AverageRatingsModel extends Equatable {
  final double difficulty;
  final double satisfaction;

  const AverageRatingsModel({
    required this.difficulty,
    required this.satisfaction,
  });

  factory AverageRatingsModel.fromJson(Map<String, dynamic> json) {
    return AverageRatingsModel(
      difficulty: (json['difficulty'] as num?)?.toDouble() ?? 0,
      satisfaction: (json['satisfaction'] as num?)?.toDouble() ?? 0,
    );
  }

  @override
  List<Object?> get props => [difficulty, satisfaction];
}

/// Weekly Statistics Model
class WeeklyStatisticsModel extends Equatable {
  final CurrentWeekModel currentWeek;
  final WeekSummaryModel previousWeek;
  final ImprovementModel improvement;
  final StreakModel streak;
  final WeeklyGoalModel weeklyGoal;

  const WeeklyStatisticsModel({
    required this.currentWeek,
    required this.previousWeek,
    required this.improvement,
    required this.streak,
    required this.weeklyGoal,
  });

  factory WeeklyStatisticsModel.fromJson(Map<String, dynamic> json) {
    return WeeklyStatisticsModel(
      currentWeek: json['currentWeek'] != null
          ? CurrentWeekModel.fromJson(
              json['currentWeek'] as Map<String, dynamic>,
            )
          : CurrentWeekModel.empty(),
      previousWeek: json['previousWeek'] != null
          ? WeekSummaryModel.fromJson(
              json['previousWeek'] as Map<String, dynamic>,
            )
          : const WeekSummaryModel(
              totalWorkouts: 0,
              totalMinutes: 0,
              totalCalories: 0,
            ),
      improvement: json['improvement'] != null
          ? ImprovementModel.fromJson(
              json['improvement'] as Map<String, dynamic>,
            )
          : const ImprovementModel(workouts: 0, minutes: 0, calories: 0),
      streak: json['streak'] != null
          ? StreakModel.fromJson(json['streak'] as Map<String, dynamic>)
          : const StreakModel(current: 0, longest: 0),
      weeklyGoal: json['weeklyGoal'] != null
          ? WeeklyGoalModel.fromJson(json['weeklyGoal'] as Map<String, dynamic>)
          : const WeeklyGoalModel(
              targetWorkouts: 0,
              targetMinutes: 0,
              progressWorkouts: 0,
              progressMinutes: 0,
            ),
    );
  }

  factory WeeklyStatisticsModel.empty() {
    return WeeklyStatisticsModel(
      currentWeek: CurrentWeekModel.empty(),
      previousWeek: const WeekSummaryModel(
        totalWorkouts: 0,
        totalMinutes: 0,
        totalCalories: 0,
      ),
      improvement: const ImprovementModel(workouts: 0, minutes: 0, calories: 0),
      streak: const StreakModel(current: 0, longest: 0),
      weeklyGoal: const WeeklyGoalModel(
        targetWorkouts: 0,
        targetMinutes: 0,
        progressWorkouts: 0,
        progressMinutes: 0,
      ),
    );
  }

  @override
  List<Object?> get props => [
    currentWeek,
    previousWeek,
    improvement,
    streak,
    weeklyGoal,
  ];
}

/// Current Week Model
class CurrentWeekModel extends Equatable {
  final String weekStart;
  final String weekEnd;
  final int totalWorkouts;
  final int totalMinutes;
  final int totalCalories;
  final List<WorkoutDayModel> workoutDays;

  const CurrentWeekModel({
    required this.weekStart,
    required this.weekEnd,
    required this.totalWorkouts,
    required this.totalMinutes,
    required this.totalCalories,
    required this.workoutDays,
  });

  factory CurrentWeekModel.fromJson(Map<String, dynamic> json) {
    return CurrentWeekModel(
      weekStart: json['weekStart'] as String? ?? '',
      weekEnd: json['weekEnd'] as String? ?? '',
      totalWorkouts: json['totalWorkouts'] as int? ?? 0,
      totalMinutes: json['totalMinutes'] as int? ?? 0,
      totalCalories: json['totalCalories'] as int? ?? 0,
      workoutDays:
          (json['workoutDays'] as List<dynamic>?)
              ?.map((e) => WorkoutDayModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  factory CurrentWeekModel.empty() {
    return const CurrentWeekModel(
      weekStart: '',
      weekEnd: '',
      totalWorkouts: 0,
      totalMinutes: 0,
      totalCalories: 0,
      workoutDays: [],
    );
  }

  @override
  List<Object?> get props => [
    weekStart,
    weekEnd,
    totalWorkouts,
    totalMinutes,
    totalCalories,
    workoutDays,
  ];
}

/// Workout Day Model
class WorkoutDayModel extends Equatable {
  final String date;
  final int workouts;
  final int minutes;
  final int calories;
  final String? dayOfWeek;

  const WorkoutDayModel({
    required this.date,
    required this.workouts,
    required this.minutes,
    required this.calories,
    this.dayOfWeek,
  });

  factory WorkoutDayModel.fromJson(Map<String, dynamic> json) {
    return WorkoutDayModel(
      date: json['date'] as String? ?? '',
      workouts: json['workouts'] as int? ?? 0,
      minutes: json['minutes'] as int? ?? 0,
      calories: json['calories'] as int? ?? 0,
      dayOfWeek: json['dayOfWeek'] as String?,
    );
  }

  @override
  List<Object?> get props => [date, workouts, minutes, calories, dayOfWeek];
}

/// Week Summary Model
class WeekSummaryModel extends Equatable {
  final int totalWorkouts;
  final int totalMinutes;
  final int totalCalories;

  const WeekSummaryModel({
    required this.totalWorkouts,
    required this.totalMinutes,
    required this.totalCalories,
  });

  factory WeekSummaryModel.fromJson(Map<String, dynamic> json) {
    return WeekSummaryModel(
      totalWorkouts: json['totalWorkouts'] as int? ?? 0,
      totalMinutes: json['totalMinutes'] as int? ?? 0,
      totalCalories: json['totalCalories'] as int? ?? 0,
    );
  }

  @override
  List<Object?> get props => [totalWorkouts, totalMinutes, totalCalories];
}

/// Improvement Model
class ImprovementModel extends Equatable {
  final double workouts;
  final double minutes;
  final double calories;

  const ImprovementModel({
    required this.workouts,
    required this.minutes,
    required this.calories,
  });

  factory ImprovementModel.fromJson(Map<String, dynamic> json) {
    return ImprovementModel(
      workouts: (json['workouts'] as num?)?.toDouble() ?? 0,
      minutes: (json['minutes'] as num?)?.toDouble() ?? 0,
      calories: (json['calories'] as num?)?.toDouble() ?? 0,
    );
  }

  @override
  List<Object?> get props => [workouts, minutes, calories];
}

/// Streak Model
class StreakModel extends Equatable {
  final int current;
  final int longest;

  const StreakModel({required this.current, required this.longest});

  factory StreakModel.fromJson(Map<String, dynamic> json) {
    return StreakModel(
      current: json['current'] as int? ?? 0,
      longest: json['longest'] as int? ?? 0,
    );
  }

  @override
  List<Object?> get props => [current, longest];
}

/// Weekly Goal Model
class WeeklyGoalModel extends Equatable {
  final int targetWorkouts;
  final int targetMinutes;
  final double progressWorkouts;
  final double progressMinutes;

  const WeeklyGoalModel({
    required this.targetWorkouts,
    required this.targetMinutes,
    required this.progressWorkouts,
    required this.progressMinutes,
  });

  factory WeeklyGoalModel.fromJson(Map<String, dynamic> json) {
    return WeeklyGoalModel(
      targetWorkouts: json['targetWorkouts'] as int? ?? 0,
      targetMinutes: json['targetMinutes'] as int? ?? 0,
      progressWorkouts: (json['progressWorkouts'] as num?)?.toDouble() ?? 0,
      progressMinutes: (json['progressMinutes'] as num?)?.toDouble() ?? 0,
    );
  }

  @override
  List<Object?> get props => [
    targetWorkouts,
    targetMinutes,
    progressWorkouts,
    progressMinutes,
  ];
}

/// Monthly Statistics Model
class MonthlyStatisticsModel extends Equatable {
  final CurrentMonthModel currentMonth;
  final MonthSummaryModel previousMonth;
  final MonthlyComparisonModel monthlyComparison;
  final MonthlyGoalsModel monthlyGoals;
  final Map<String, int> workoutTypeDistribution;
  final int consistencyScore;
  final String? bestPerformingDay;
  final int longestStreak;

  const MonthlyStatisticsModel({
    required this.currentMonth,
    required this.previousMonth,
    required this.monthlyComparison,
    required this.monthlyGoals,
    required this.workoutTypeDistribution,
    required this.consistencyScore,
    this.bestPerformingDay,
    required this.longestStreak,
  });

  factory MonthlyStatisticsModel.fromJson(Map<String, dynamic> json) {
    return MonthlyStatisticsModel(
      currentMonth: json['currentMonth'] != null
          ? CurrentMonthModel.fromJson(
              json['currentMonth'] as Map<String, dynamic>,
            )
          : CurrentMonthModel.empty(),
      previousMonth: json['previousMonth'] != null
          ? MonthSummaryModel.fromJson(
              json['previousMonth'] as Map<String, dynamic>,
            )
          : MonthSummaryModel.empty(),
      monthlyComparison: json['monthlyComparison'] != null
          ? MonthlyComparisonModel.fromJson(
              json['monthlyComparison'] as Map<String, dynamic>,
            )
          : MonthlyComparisonModel.empty(),
      monthlyGoals: json['monthlyGoals'] != null
          ? MonthlyGoalsModel.fromJson(
              json['monthlyGoals'] as Map<String, dynamic>,
            )
          : MonthlyGoalsModel.empty(),
      workoutTypeDistribution:
          (json['workoutTypeDistribution'] as Map<String, dynamic>?)?.map(
            (key, value) => MapEntry(key, (value as num).toInt()),
          ) ??
          {},
      consistencyScore: json['consistencyScore'] as int? ?? 0,
      bestPerformingDay: json['bestPerformingDay'] as String?,
      longestStreak: json['longestStreak'] as int? ?? 0,
    );
  }

  factory MonthlyStatisticsModel.empty() {
    return MonthlyStatisticsModel(
      currentMonth: CurrentMonthModel.empty(),
      previousMonth: MonthSummaryModel.empty(),
      monthlyComparison: MonthlyComparisonModel.empty(),
      monthlyGoals: MonthlyGoalsModel.empty(),
      workoutTypeDistribution: {},
      consistencyScore: 0,
      longestStreak: 0,
    );
  }

  @override
  List<Object?> get props => [
    currentMonth,
    previousMonth,
    monthlyComparison,
    monthlyGoals,
    workoutTypeDistribution,
    consistencyScore,
    bestPerformingDay,
    longestStreak,
  ];
}

/// Current Month Model
class CurrentMonthModel extends Equatable {
  final int year;
  final int month;
  final String monthName;
  final int totalWorkouts;
  final int totalMinutes;
  final int totalCalories;
  final double averageWorkoutsPerWeek;
  final double averageMinutesPerWorkout;
  final double averageCaloriesPerWorkout;
  final double completionRate;
  final List<WorkoutDayModel> dailyBreakdown;

  const CurrentMonthModel({
    required this.year,
    required this.month,
    required this.monthName,
    required this.totalWorkouts,
    required this.totalMinutes,
    required this.totalCalories,
    required this.averageWorkoutsPerWeek,
    required this.averageMinutesPerWorkout,
    required this.averageCaloriesPerWorkout,
    required this.completionRate,
    required this.dailyBreakdown,
  });

  factory CurrentMonthModel.fromJson(Map<String, dynamic> json) {
    return CurrentMonthModel(
      year: json['year'] as int? ?? DateTime.now().year,
      month: json['month'] as int? ?? DateTime.now().month,
      monthName: json['monthName'] as String? ?? '',
      totalWorkouts: json['totalWorkouts'] as int? ?? 0,
      totalMinutes: json['totalMinutes'] as int? ?? 0,
      totalCalories: json['totalCalories'] as int? ?? 0,
      averageWorkoutsPerWeek:
          (json['averageWorkoutsPerWeek'] as num?)?.toDouble() ?? 0,
      averageMinutesPerWorkout:
          (json['averageMinutesPerWorkout'] as num?)?.toDouble() ?? 0,
      averageCaloriesPerWorkout:
          (json['averageCaloriesPerWorkout'] as num?)?.toDouble() ?? 0,
      completionRate: (json['completionRate'] as num?)?.toDouble() ?? 0,
      dailyBreakdown:
          (json['dailyBreakdown'] as List<dynamic>?)
              ?.map((e) => WorkoutDayModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  factory CurrentMonthModel.empty() {
    return CurrentMonthModel(
      year: DateTime.now().year,
      month: DateTime.now().month,
      monthName: '',
      totalWorkouts: 0,
      totalMinutes: 0,
      totalCalories: 0,
      averageWorkoutsPerWeek: 0,
      averageMinutesPerWorkout: 0,
      averageCaloriesPerWorkout: 0,
      completionRate: 0,
      dailyBreakdown: [],
    );
  }

  @override
  List<Object?> get props => [
    year,
    month,
    monthName,
    totalWorkouts,
    totalMinutes,
    totalCalories,
    averageWorkoutsPerWeek,
    averageMinutesPerWorkout,
    averageCaloriesPerWorkout,
    completionRate,
    dailyBreakdown,
  ];
}

/// Month Summary Model
class MonthSummaryModel extends Equatable {
  final int totalWorkouts;
  final int totalMinutes;
  final int totalCalories;
  final double averageWorkoutsPerWeek;

  const MonthSummaryModel({
    required this.totalWorkouts,
    required this.totalMinutes,
    required this.totalCalories,
    required this.averageWorkoutsPerWeek,
  });

  factory MonthSummaryModel.fromJson(Map<String, dynamic> json) {
    return MonthSummaryModel(
      totalWorkouts: json['totalWorkouts'] as int? ?? 0,
      totalMinutes: json['totalMinutes'] as int? ?? 0,
      totalCalories: json['totalCalories'] as int? ?? 0,
      averageWorkoutsPerWeek:
          (json['averageWorkoutsPerWeek'] as num?)?.toDouble() ?? 0,
    );
  }

  factory MonthSummaryModel.empty() {
    return const MonthSummaryModel(
      totalWorkouts: 0,
      totalMinutes: 0,
      totalCalories: 0,
      averageWorkoutsPerWeek: 0,
    );
  }

  @override
  List<Object?> get props => [
    totalWorkouts,
    totalMinutes,
    totalCalories,
    averageWorkoutsPerWeek,
  ];
}

/// Monthly Comparison Model
class MonthlyComparisonModel extends Equatable {
  final double workoutsChange;
  final double minutesChange;
  final double caloriesChange;
  final String workoutsChangeType;
  final String minutesChangeType;
  final String caloriesChangeType;

  const MonthlyComparisonModel({
    required this.workoutsChange,
    required this.minutesChange,
    required this.caloriesChange,
    required this.workoutsChangeType,
    required this.minutesChangeType,
    required this.caloriesChangeType,
  });

  factory MonthlyComparisonModel.fromJson(Map<String, dynamic> json) {
    return MonthlyComparisonModel(
      workoutsChange: (json['workoutsChange'] as num?)?.toDouble() ?? 0,
      minutesChange: (json['minutesChange'] as num?)?.toDouble() ?? 0,
      caloriesChange: (json['caloriesChange'] as num?)?.toDouble() ?? 0,
      workoutsChangeType: json['workoutsChangeType'] as String? ?? 'same',
      minutesChangeType: json['minutesChangeType'] as String? ?? 'same',
      caloriesChangeType: json['caloriesChangeType'] as String? ?? 'same',
    );
  }

  factory MonthlyComparisonModel.empty() {
    return const MonthlyComparisonModel(
      workoutsChange: 0,
      minutesChange: 0,
      caloriesChange: 0,
      workoutsChangeType: 'same',
      minutesChangeType: 'same',
      caloriesChangeType: 'same',
    );
  }

  @override
  List<Object?> get props => [
    workoutsChange,
    minutesChange,
    caloriesChange,
    workoutsChangeType,
    minutesChangeType,
    caloriesChangeType,
  ];
}

/// Monthly Goals Model
class MonthlyGoalsModel extends Equatable {
  final int targetWorkouts;
  final int targetMinutes;
  final int targetCalories;
  final double progressWorkouts;
  final double progressMinutes;
  final double progressCalories;

  const MonthlyGoalsModel({
    required this.targetWorkouts,
    required this.targetMinutes,
    required this.targetCalories,
    required this.progressWorkouts,
    required this.progressMinutes,
    required this.progressCalories,
  });

  factory MonthlyGoalsModel.fromJson(Map<String, dynamic> json) {
    return MonthlyGoalsModel(
      targetWorkouts: json['targetWorkouts'] as int? ?? 0,
      targetMinutes: json['targetMinutes'] as int? ?? 0,
      targetCalories: json['targetCalories'] as int? ?? 0,
      progressWorkouts: (json['progressWorkouts'] as num?)?.toDouble() ?? 0,
      progressMinutes: (json['progressMinutes'] as num?)?.toDouble() ?? 0,
      progressCalories: (json['progressCalories'] as num?)?.toDouble() ?? 0,
    );
  }

  factory MonthlyGoalsModel.empty() {
    return const MonthlyGoalsModel(
      targetWorkouts: 0,
      targetMinutes: 0,
      targetCalories: 0,
      progressWorkouts: 0,
      progressMinutes: 0,
      progressCalories: 0,
    );
  }

  @override
  List<Object?> get props => [
    targetWorkouts,
    targetMinutes,
    targetCalories,
    progressWorkouts,
    progressMinutes,
    progressCalories,
  ];
}
