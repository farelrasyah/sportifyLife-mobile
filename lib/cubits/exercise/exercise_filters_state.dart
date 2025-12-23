import 'package:equatable/equatable.dart';
import '../data/models/exercise_model.dart';

/// Exercise Filters States
abstract class ExerciseFiltersState extends Equatable {
  const ExerciseFiltersState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class ExerciseFiltersInitial extends ExerciseFiltersState {
  const ExerciseFiltersInitial();
}

/// Loading state
class ExerciseFiltersLoading extends ExerciseFiltersState {
  const ExerciseFiltersLoading();
}

/// Success state with filters loaded
class ExerciseFiltersLoaded extends ExerciseFiltersState {
  final ExerciseFiltersModel filters;
  final ExerciseActiveFilters activeFilters;

  const ExerciseFiltersLoaded({
    required this.filters,
    this.activeFilters = const ExerciseActiveFilters(),
  });

  int get activeFilterCount => activeFilters.count;

  ExerciseFiltersLoaded copyWith({
    ExerciseFiltersModel? filters,
    ExerciseActiveFilters? activeFilters,
  }) {
    return ExerciseFiltersLoaded(
      filters: filters ?? this.filters,
      activeFilters: activeFilters ?? this.activeFilters,
    );
  }

  @override
  List<Object?> get props => [filters, activeFilters];
}

/// Error state
class ExerciseFiltersError extends ExerciseFiltersState {
  final String message;
  final String? errorCode;

  const ExerciseFiltersError({required this.message, this.errorCode});

  @override
  List<Object?> get props => [message, errorCode];
}

/// Active filters model to track selected filter values
class ExerciseActiveFilters extends Equatable {
  final String? type;
  final String? bodyPart;
  final String? equipment;
  final String? targetMuscle;
  final String? difficulty;
  final String? sortBy;
  final String? sortOrder;

  const ExerciseActiveFilters({
    this.type,
    this.bodyPart,
    this.equipment,
    this.targetMuscle,
    this.difficulty,
    this.sortBy,
    this.sortOrder,
  });

  int get count {
    int count = 0;
    if (type != null) count++;
    if (bodyPart != null) count++;
    if (equipment != null) count++;
    if (targetMuscle != null) count++;
    if (difficulty != null) count++;
    return count;
  }

  bool get hasFilters => count > 0;

  ExerciseActiveFilters copyWith({
    String? type,
    String? bodyPart,
    String? equipment,
    String? targetMuscle,
    String? difficulty,
    String? sortBy,
    String? sortOrder,
    bool clearType = false,
    bool clearBodyPart = false,
    bool clearEquipment = false,
    bool clearTargetMuscle = false,
    bool clearDifficulty = false,
  }) {
    return ExerciseActiveFilters(
      type: clearType ? null : (type ?? this.type),
      bodyPart: clearBodyPart ? null : (bodyPart ?? this.bodyPart),
      equipment: clearEquipment ? null : (equipment ?? this.equipment),
      targetMuscle: clearTargetMuscle
          ? null
          : (targetMuscle ?? this.targetMuscle),
      difficulty: clearDifficulty ? null : (difficulty ?? this.difficulty),
      sortBy: sortBy ?? this.sortBy,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }

  ExerciseQueryParams toQueryParams() {
    return ExerciseQueryParams(
      type: type,
      bodyPart: bodyPart,
      equipment: equipment,
      targetMuscle: targetMuscle,
      difficulty: difficulty,
      sortBy: sortBy,
      sortOrder: sortOrder,
    );
  }

  @override
  List<Object?> get props => [
    type,
    bodyPart,
    equipment,
    targetMuscle,
    difficulty,
    sortBy,
    sortOrder,
  ];
}
