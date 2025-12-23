import 'package:equatable/equatable.dart';
import '../data/models/exercise_model.dart';

/// Exercise Detail States
abstract class ExerciseDetailState extends Equatable {
  const ExerciseDetailState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class ExerciseDetailInitial extends ExerciseDetailState {
  const ExerciseDetailInitial();
}

/// Loading state
class ExerciseDetailLoading extends ExerciseDetailState {
  const ExerciseDetailLoading();
}

/// Success state with exercise detail loaded
class ExerciseDetailLoaded extends ExerciseDetailState {
  final ExerciseModel exercise;
  final bool isFavorite;

  const ExerciseDetailLoaded({required this.exercise, this.isFavorite = false});

  ExerciseDetailLoaded copyWith({ExerciseModel? exercise, bool? isFavorite}) {
    return ExerciseDetailLoaded(
      exercise: exercise ?? this.exercise,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  @override
  List<Object?> get props => [exercise, isFavorite];
}

/// Error state
class ExerciseDetailError extends ExerciseDetailState {
  final String message;
  final String? errorCode;

  const ExerciseDetailError({required this.message, this.errorCode});

  @override
  List<Object?> get props => [message, errorCode];
}
