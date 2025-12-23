import 'package:equatable/equatable.dart';
import '../../data/models/workout_session_model.dart';

/// Workout Session States
abstract class WorkoutSessionState extends Equatable {
  const WorkoutSessionState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class WorkoutSessionInitial extends WorkoutSessionState {
  const WorkoutSessionInitial();
}

/// Loading state
class WorkoutSessionLoading extends WorkoutSessionState {
  const WorkoutSessionLoading();
}

/// No active session state
class WorkoutSessionNoActive extends WorkoutSessionState {
  const WorkoutSessionNoActive();
}

/// Active session state
class WorkoutSessionActive extends WorkoutSessionState {
  final WorkoutSessionModel session;
  final int currentExerciseIndex;
  final bool isUpdatingProgress;
  final Duration elapsedTime;

  const WorkoutSessionActive({
    required this.session,
    this.currentExerciseIndex = 0,
    this.isUpdatingProgress = false,
    this.elapsedTime = Duration.zero,
  });

  int get totalExercises => session.exerciseProgress.length;
  int get completedExercises =>
      session.exerciseProgress.where((e) => e.isCompleted).length;
  double get progressPercent => session.progressPercent;
  bool get isPaused => session.status == WorkoutSessionStatus.paused;

  ExerciseProgressModel? get currentExercise {
    if (currentExerciseIndex < session.exerciseProgress.length) {
      return session.exerciseProgress[currentExerciseIndex];
    }
    return null;
  }

  WorkoutSessionActive copyWith({
    WorkoutSessionModel? session,
    int? currentExerciseIndex,
    bool? isUpdatingProgress,
    Duration? elapsedTime,
  }) {
    return WorkoutSessionActive(
      session: session ?? this.session,
      currentExerciseIndex: currentExerciseIndex ?? this.currentExerciseIndex,
      isUpdatingProgress: isUpdatingProgress ?? this.isUpdatingProgress,
      elapsedTime: elapsedTime ?? this.elapsedTime,
    );
  }

  @override
  List<Object?> get props => [
    session,
    currentExerciseIndex,
    isUpdatingProgress,
    elapsedTime,
  ];
}

/// Session paused state
class WorkoutSessionPaused extends WorkoutSessionState {
  final WorkoutSessionModel session;
  final Duration elapsedTime;

  const WorkoutSessionPaused({
    required this.session,
    required this.elapsedTime,
  });

  @override
  List<Object?> get props => [session, elapsedTime];
}

/// Session completed state
class WorkoutSessionCompleted extends WorkoutSessionState {
  final WorkoutSessionModel session;
  final String message;

  const WorkoutSessionCompleted({
    required this.session,
    this.message = 'Workout completed! Great job!',
  });

  @override
  List<Object?> get props => [session, message];
}

/// Error state
class WorkoutSessionError extends WorkoutSessionState {
  final String message;
  final String? errorCode;

  const WorkoutSessionError({required this.message, this.errorCode});

  @override
  List<Object?> get props => [message, errorCode];
}
