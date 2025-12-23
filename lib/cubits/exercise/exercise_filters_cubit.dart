import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';
import '../../data/repositories/exercise_repository.dart';
import 'exercise_filters_state.dart';

/// Exercise Filters Cubit for managing filter options and active filters
class ExerciseFiltersCubit extends Cubit<ExerciseFiltersState> {
  final ExerciseRepository _exerciseRepository;

  ExerciseFiltersCubit({required ExerciseRepository exerciseRepository})
    : _exerciseRepository = exerciseRepository,
      super(const ExerciseFiltersInitial());

  /// Load all filter options from API
  Future<void> loadFilters() async {
    try {
      emit(const ExerciseFiltersLoading());

      final filters = await _exerciseRepository.getAllFilters();

      emit(ExerciseFiltersLoaded(filters: filters));
    } catch (e) {
      emit(ExerciseFiltersError(message: e.toString()));
      debugPrint('Error loading filters: $e');
    }
  }

  /// Set filter value
  void setType(String? value) {
    _updateActiveFilters(
      (current) => current.copyWith(type: value, clearType: value == null),
    );
  }

  void setBodyPart(String? value) {
    _updateActiveFilters(
      (current) =>
          current.copyWith(bodyPart: value, clearBodyPart: value == null),
    );
  }

  void setEquipment(String? value) {
    _updateActiveFilters(
      (current) =>
          current.copyWith(equipment: value, clearEquipment: value == null),
    );
  }

  void setTargetMuscle(String? value) {
    _updateActiveFilters(
      (current) => current.copyWith(
        targetMuscle: value,
        clearTargetMuscle: value == null,
      ),
    );
  }

  void setDifficulty(String? value) {
    _updateActiveFilters(
      (current) =>
          current.copyWith(difficulty: value, clearDifficulty: value == null),
    );
  }

  void setSorting(String? sortBy, String? sortOrder) {
    _updateActiveFilters(
      (current) => current.copyWith(sortBy: sortBy, sortOrder: sortOrder),
    );
  }

  /// Clear all active filters
  void clearAllFilters() {
    final currentState = state;
    if (currentState is ExerciseFiltersLoaded) {
      emit(currentState.copyWith(activeFilters: const ExerciseActiveFilters()));
    }
  }

  /// Clear specific filter
  void clearFilter(String filterType) {
    final currentState = state;
    if (currentState is! ExerciseFiltersLoaded) return;

    ExerciseActiveFilters newFilters;
    switch (filterType) {
      case 'type':
        newFilters = currentState.activeFilters.copyWith(clearType: true);
        break;
      case 'bodyPart':
        newFilters = currentState.activeFilters.copyWith(clearBodyPart: true);
        break;
      case 'equipment':
        newFilters = currentState.activeFilters.copyWith(clearEquipment: true);
        break;
      case 'targetMuscle':
        newFilters = currentState.activeFilters.copyWith(
          clearTargetMuscle: true,
        );
        break;
      case 'difficulty':
        newFilters = currentState.activeFilters.copyWith(clearDifficulty: true);
        break;
      default:
        return;
    }

    emit(currentState.copyWith(activeFilters: newFilters));
  }

  void _updateActiveFilters(
    ExerciseActiveFilters Function(ExerciseActiveFilters current) updater,
  ) {
    final currentState = state;
    if (currentState is ExerciseFiltersLoaded) {
      emit(
        currentState.copyWith(
          activeFilters: updater(currentState.activeFilters),
        ),
      );
    }
  }

  /// Get current active filters for applying to list
  ExerciseActiveFilters? get activeFilters {
    final currentState = state;
    if (currentState is ExerciseFiltersLoaded) {
      return currentState.activeFilters;
    }
    return null;
  }
}
