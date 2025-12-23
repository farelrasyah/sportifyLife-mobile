import 'package:equatable/equatable.dart';
import '../../data/models/exercise_model.dart';

/// Favorite Exercises States
abstract class FavoriteExercisesState extends Equatable {
  const FavoriteExercisesState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class FavoriteExercisesInitial extends FavoriteExercisesState {
  const FavoriteExercisesInitial();
}

/// Loading state
class FavoriteExercisesLoading extends FavoriteExercisesState {
  const FavoriteExercisesLoading();
}

/// Success state with favorites loaded
class FavoriteExercisesLoaded extends FavoriteExercisesState {
  final List<ExerciseModel> favorites;

  const FavoriteExercisesLoaded({required this.favorites});

  int get count => favorites.length;

  bool isFavorite(String exerciseId) {
    return favorites.any((e) => e.id == exerciseId);
  }

  FavoriteExercisesLoaded copyWith({List<ExerciseModel>? favorites}) {
    return FavoriteExercisesLoaded(favorites: favorites ?? this.favorites);
  }

  @override
  List<Object?> get props => [favorites];
}

/// Error state
class FavoriteExercisesError extends FavoriteExercisesState {
  final String message;

  const FavoriteExercisesError({required this.message});

  @override
  List<Object?> get props => [message];
}
