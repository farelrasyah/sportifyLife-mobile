import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';
import '../../data/repositories/exercise_repository.dart';
import '../../services/favorite_service.dart';
import 'exercise_detail_state.dart';

/// Exercise Detail Cubit for managing single exercise details
class ExerciseDetailCubit extends Cubit<ExerciseDetailState> {
  final ExerciseRepository _exerciseRepository;
  final FavoriteExerciseService _favoriteService;

  ExerciseDetailCubit({
    required ExerciseRepository exerciseRepository,
    required FavoriteExerciseService favoriteService,
  }) : _exerciseRepository = exerciseRepository,
       _favoriteService = favoriteService,
       super(const ExerciseDetailInitial());

  /// Load exercise by ID
  Future<void> loadExercise(String exerciseId) async {
    try {
      emit(const ExerciseDetailLoading());

      final exercise = await _exerciseRepository.getExerciseById(exerciseId);
      final isFavorite = await _favoriteService.isFavorite(exerciseId);

      emit(ExerciseDetailLoaded(exercise: exercise, isFavorite: isFavorite));
    } catch (e) {
      emit(ExerciseDetailError(message: e.toString()));
      debugPrint('Error loading exercise detail: $e');
    }
  }

  /// Toggle favorite status
  Future<void> toggleFavorite() async {
    final currentState = state;
    if (currentState is! ExerciseDetailLoaded) return;

    try {
      final newFavoriteStatus = !currentState.isFavorite;

      if (newFavoriteStatus) {
        await _favoriteService.addFavorite(currentState.exercise);
      } else {
        await _favoriteService.removeFavorite(currentState.exercise.id);
      }

      emit(currentState.copyWith(isFavorite: newFavoriteStatus));
    } catch (e) {
      debugPrint('Error toggling favorite: $e');
    }
  }

  /// Refresh exercise detail
  Future<void> refreshExercise() async {
    final currentState = state;
    if (currentState is ExerciseDetailLoaded) {
      await loadExercise(currentState.exercise.id);
    }
  }
}
