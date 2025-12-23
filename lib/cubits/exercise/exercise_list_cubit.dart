import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';
import '../../data/repositories/exercise_repository.dart';
import '../../data/models/exercise_model.dart';
import 'exercise_list_state.dart';

/// Exercise List Cubit for managing exercise list with pagination and filtering
class ExerciseListCubit extends Cubit<ExerciseListState> {
  final ExerciseRepository _exerciseRepository;

  ExerciseListCubit({required ExerciseRepository exerciseRepository})
    : _exerciseRepository = exerciseRepository,
      super(const ExerciseListInitial());

  /// Load initial exercises
  Future<void> loadExercises([ExerciseQueryParams? params]) async {
    try {
      emit(const ExerciseListLoading());

      final queryParams = params ?? const ExerciseQueryParams();
      final response = await _exerciseRepository.getExercises(
        params: queryParams,
      );

      emit(
        ExerciseListLoaded(
          exercises: response.data,
          pagination: response.pagination,
          currentQuery: queryParams,
        ),
      );
    } catch (e) {
      emit(ExerciseListError(message: e.toString(), lastQuery: params));
      debugPrint('Error loading exercises: $e');
    }
  }

  /// Load more exercises (pagination)
  Future<void> loadMoreExercises() async {
    final currentState = state;
    if (currentState is! ExerciseListLoaded || currentState.isLoadingMore) {
      return;
    }

    if (!currentState.hasMore) {
      debugPrint('No more exercises to load');
      return;
    }

    try {
      emit(currentState.copyWith(isLoadingMore: true));

      final nextPage = currentState.pagination.page + 1;
      final queryParams =
          (currentState.currentQuery ?? const ExerciseQueryParams()).copyWith(
            page: nextPage,
          );

      final response = await _exerciseRepository.getExercises(
        params: queryParams,
      );

      emit(
        currentState.copyWith(
          exercises: [...currentState.exercises, ...response.data],
          pagination: response.pagination,
          isLoadingMore: false,
          currentQuery: queryParams,
        ),
      );
    } catch (e) {
      emit(currentState.copyWith(isLoadingMore: false));
      debugPrint('Error loading more exercises: $e');
    }
  }

  /// Search exercises
  Future<void> searchExercises(String query) async {
    if (query.isEmpty) {
      await loadExercises();
      return;
    }

    try {
      emit(const ExerciseListLoading());

      final response = await _exerciseRepository.searchExercises(query: query);

      emit(
        ExerciseListLoaded(
          exercises: response.data,
          pagination: response.pagination,
          searchQuery: query,
        ),
      );
    } catch (e) {
      emit(ExerciseListError(message: e.toString()));
      debugPrint('Error searching exercises: $e');
    }
  }

  /// Apply filters to exercise list
  Future<void> applyFilters({
    String? type,
    String? bodyPart,
    String? equipment,
    String? targetMuscle,
    String? difficulty,
    String? sortBy,
    String? sortOrder,
  }) async {
    try {
      emit(const ExerciseListLoading());

      final queryParams = ExerciseQueryParams(
        type: type,
        bodyPart: bodyPart,
        equipment: equipment,
        targetMuscle: targetMuscle,
        difficulty: difficulty,
        sortBy: sortBy,
        sortOrder: sortOrder,
      );

      final response = await _exerciseRepository.getExercises(params: queryParams);

      emit(
        ExerciseListLoaded(
          exercises: response.data,
          pagination: response.pagination,
          currentQuery: queryParams,
        ),
      );
    } catch (e) {
      emit(ExerciseListError(message: e.toString()));
      debugPrint('Error applying filters: $e');
    }
  }

  /// Clear all filters
  Future<void> clearFilters() async {
    await loadExercises(const ExerciseQueryParams());
  }

  /// Refresh exercise list
  Future<void> refreshExercises() async {
    final currentState = state;
    ExerciseQueryParams? params;

    if (currentState is ExerciseListLoaded) {
      params = currentState.currentQuery?.copyWith(page: 1);
    }

    await loadExercises(params);
  }
}
