import 'package:equatable/equatable.dart';
import '../../data/models/workout_model.dart';

/// Workout Stats Screen State
/// Combines all data needed for the main workout stats screen
abstract class WorkoutStatsScreenState extends Equatable {
  const WorkoutStatsScreenState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class WorkoutStatsScreenInitial extends WorkoutStatsScreenState {
  const WorkoutStatsScreenInitial();
}

/// Loading state
class WorkoutStatsScreenLoading extends WorkoutStatsScreenState {
  const WorkoutStatsScreenLoading();
}

/// Loaded state - all data successfully loaded
class WorkoutStatsScreenLoaded extends WorkoutStatsScreenState {
  /// Weekly progress data from API
  final WeeklyProgressModel? weeklyProgress;

  /// Today's scheduled workouts
  final List<NewWorkoutScheduleModel> todaySchedules;

  /// Upcoming scheduled workouts
  final List<NewWorkoutScheduleModel> upcomingSchedules;

  /// All available workouts (paginated)
  final List<WorkoutModel> workouts;

  /// Workout categories for filtering
  final List<WorkoutCategory> categories;

  /// Current selected level filter
  final WorkoutLevel? selectedLevel;

  /// Current selected category filter
  final WorkoutCategory? selectedCategory;

  /// Search query
  final String? searchQuery;

  /// Pagination info
  final int currentPage;
  final int totalPages;
  final bool isLoadingMore;

  const WorkoutStatsScreenLoaded({
    this.weeklyProgress,
    required this.todaySchedules,
    required this.upcomingSchedules,
    required this.workouts,
    this.categories = const [],
    this.selectedLevel,
    this.selectedCategory,
    this.searchQuery,
    this.currentPage = 1,
    this.totalPages = 1,
    this.isLoadingMore = false,
  });

  WorkoutStatsScreenLoaded copyWith({
    WeeklyProgressModel? weeklyProgress,
    List<NewWorkoutScheduleModel>? todaySchedules,
    List<NewWorkoutScheduleModel>? upcomingSchedules,
    List<WorkoutModel>? workouts,
    List<WorkoutCategory>? categories,
    WorkoutLevel? selectedLevel,
    WorkoutCategory? selectedCategory,
    String? searchQuery,
    int? currentPage,
    int? totalPages,
    bool? isLoadingMore,
  }) {
    return WorkoutStatsScreenLoaded(
      weeklyProgress: weeklyProgress ?? this.weeklyProgress,
      todaySchedules: todaySchedules ?? this.todaySchedules,
      upcomingSchedules: upcomingSchedules ?? this.upcomingSchedules,
      workouts: workouts ?? this.workouts,
      categories: categories ?? this.categories,
      selectedLevel: selectedLevel ?? this.selectedLevel,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      searchQuery: searchQuery ?? this.searchQuery,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }

  /// Check if there are more pages to load
  bool get hasMore => currentPage < totalPages;

  @override
  List<Object?> get props => [
    weeklyProgress,
    todaySchedules,
    upcomingSchedules,
    workouts,
    categories,
    selectedLevel,
    selectedCategory,
    searchQuery,
    currentPage,
    totalPages,
    isLoadingMore,
  ];
}

/// Error state
class WorkoutStatsScreenError extends WorkoutStatsScreenState {
  final String message;

  const WorkoutStatsScreenError({required this.message});

  @override
  List<Object?> get props => [message];
}

/// Empty state - no data available
class WorkoutStatsScreenEmpty extends WorkoutStatsScreenState {
  const WorkoutStatsScreenEmpty();
}
