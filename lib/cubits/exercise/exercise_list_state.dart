import 'package:equatable/equatable.dart';
import '../data/models/exercise_model.dart';

/// Exercise List States
abstract class ExerciseListState extends Equatable {
  const ExerciseListState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class ExerciseListInitial extends ExerciseListState {
  const ExerciseListInitial();
}

/// Loading state (initial load)
class ExerciseListLoading extends ExerciseListState {
  const ExerciseListLoading();
}

/// Success state with exercises loaded
class ExerciseListLoaded extends ExerciseListState {
  final List<ExerciseModel> exercises;
  final PaginationModel pagination;
  final bool isLoadingMore;
  final ExerciseQueryParams? currentQuery;
  final String? searchQuery;

  const ExerciseListLoaded({
    required this.exercises,
    required this.pagination,
    this.isLoadingMore = false,
    this.currentQuery,
    this.searchQuery,
  });

  bool get hasMore => pagination.page < pagination.totalPages;

  ExerciseListLoaded copyWith({
    List<ExerciseModel>? exercises,
    PaginationModel? pagination,
    bool? isLoadingMore,
    ExerciseQueryParams? currentQuery,
    String? searchQuery,
  }) {
    return ExerciseListLoaded(
      exercises: exercises ?? this.exercises,
      pagination: pagination ?? this.pagination,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      currentQuery: currentQuery ?? this.currentQuery,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  List<Object?> get props => [
    exercises,
    pagination,
    isLoadingMore,
    currentQuery,
    searchQuery,
  ];
}

/// Error state
class ExerciseListError extends ExerciseListState {
  final String message;
  final String? errorCode;
  final ExerciseQueryParams? lastQuery;

  const ExerciseListError({
    required this.message,
    this.errorCode,
    this.lastQuery,
  });

  @override
  List<Object?> get props => [message, errorCode, lastQuery];
}
