import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';
import '../../data/models/exercise_model.dart';
import '../../services/favorite_service.dart';
import 'favorite_exercises_state.dart';

/// Favorite Exercises Cubit for managing user's favorite exercises
class FavoriteExercisesCubit extends Cubit<FavoriteExercisesState> {
  final FavoriteExerciseService _favoriteService;

  FavoriteExercisesCubit({required FavoriteExerciseService favoriteService})
    : _favoriteService = favoriteService,
      super(const FavoriteExercisesInitial());

  /// Load all favorite exercises
  Future<void> loadFavorites() async {
    try {
      emit(const FavoriteExercisesLoading());

      final favorites = await _favoriteService.getFavorites();

      emit(FavoriteExercisesLoaded(favorites: favorites));
    } catch (e) {
      emit(FavoriteExercisesError(message: e.toString()));
      debugPrint('Error loading favorites: $e');
    }
  }

  /// Add exercise to favorites
  Future<void> addFavorite(ExerciseModel exercise) async {
    final currentState = state;
    if (currentState is! FavoriteExercisesLoaded) {
      await loadFavorites();
      return addFavorite(exercise);
    }

    try {
      await _favoriteService.addFavorite(exercise);

      // Update state with new favorite
      final updatedFavorites = [...currentState.favorites, exercise];
      emit(currentState.copyWith(favorites: updatedFavorites));
    } catch (e) {
      debugPrint('Error adding favorite: $e');
    }
  }

  /// Remove exercise from favorites
  Future<void> removeFavorite(String exerciseId) async {
    final currentState = state;
    if (currentState is! FavoriteExercisesLoaded) return;

    try {
      await _favoriteService.removeFavorite(exerciseId);

      // Update state without the removed favorite
      final updatedFavorites = currentState.favorites
          .where((e) => e.id != exerciseId)
          .toList();
      emit(currentState.copyWith(favorites: updatedFavorites));
    } catch (e) {
      debugPrint('Error removing favorite: $e');
    }
  }

  /// Toggle favorite status
  Future<bool> toggleFavorite(ExerciseModel exercise) async {
    final currentState = state;
    if (currentState is! FavoriteExercisesLoaded) {
      await loadFavorites();
      return toggleFavorite(exercise);
    }

    final isFav = currentState.isFavorite(exercise.id);
    if (isFav) {
      await removeFavorite(exercise.id);
      return false;
    } else {
      await addFavorite(exercise);
      return true;
    }
  }

  /// Check if exercise is favorite
  bool isFavorite(String exerciseId) {
    final currentState = state;
    if (currentState is FavoriteExercisesLoaded) {
      return currentState.isFavorite(exerciseId);
    }
    return false;
  }

  /// Clear all favorites
  Future<void> clearFavorites() async {
    try {
      await _favoriteService.clearFavorites();
      emit(const FavoriteExercisesLoaded(favorites: []));
    } catch (e) {
      debugPrint('Error clearing favorites: $e');
    }
  }

  /// Refresh favorites
  Future<void> refreshFavorites() async {
    await loadFavorites();
  }
}
