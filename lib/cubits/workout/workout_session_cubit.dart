import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';
import '../../data/repositories/workout_repository.dart';
import '../../data/models/workout_session_model.dart';
import 'workout_session_state.dart';

/// Workout Session Cubit for managing active workout sessions
class WorkoutSessionCubit extends Cubit<WorkoutSessionState> {
  final WorkoutRepository _workoutRepository;
  Timer? _timer;
  DateTime? _sessionStartTime;

  WorkoutSessionCubit({required WorkoutRepository workoutRepository})
    : _workoutRepository = workoutRepository,
      super(const WorkoutSessionInitial());

  /// Check for active session on initialization
  Future<void> checkActiveSession() async {
    try {
      emit(const WorkoutSessionLoading());

      final activeSession = await _workoutRepository.getActiveSession();

      if (activeSession != null) {
        _startTimer();
        emit(WorkoutSessionActive(session: activeSession));
      } else {
        emit(const WorkoutSessionNoActive());
      }
    } catch (e) {
      emit(const WorkoutSessionNoActive());
      debugPrint('Error checking active session: $e');
    }
  }

  /// Start a new workout session
  Future<void> startWorkoutSession({
    required String workoutPlanId,
    String? scheduleId,
  }) async {
    try {
      emit(const WorkoutSessionLoading());

      final request = StartWorkoutSessionRequest(
        workoutPlanId: workoutPlanId,
        scheduleId: scheduleId,
      );

      final session = await _workoutRepository.startWorkoutSession(request);

      _sessionStartTime = DateTime.now();
      _startTimer();

      emit(WorkoutSessionActive(session: session));
    } catch (e) {
      emit(WorkoutSessionError(message: e.toString()));
      debugPrint('Error starting workout session: $e');
    }
  }

  /// Update exercise progress
  Future<void> updateExerciseProgress({
    required String exerciseId,
    int? completedSets,
    int? completedReps,
    double? weight,
    bool? isCompleted,
    int? duration,
    String? notes,
  }) async {
    final currentState = state;
    if (currentState is! WorkoutSessionActive) return;

    try {
      emit(currentState.copyWith(isUpdatingProgress: true));

      final progress = ExerciseProgressModel(
        id: '', // Will be assigned by backend
        exerciseId: exerciseId,
        completedSets: completedSets ?? 0,
        completedReps: completedReps ?? 0,
        weight: weight,
        isCompleted: isCompleted ?? false,
        duration: duration,
        notes: notes,
      );

      final updatedProgress = await _workoutRepository.updateExerciseProgress(
        currentState.session.id,
        progress,
      );

      // Update the session with new progress
      final updatedExercises = currentState.session.exerciseProgress.map((e) {
        return e.exerciseId == exerciseId ? updatedProgress : e;
      }).toList();

      final updatedSession = currentState.session.copyWith(
        exerciseProgress: updatedExercises,
      );

      emit(
        currentState.copyWith(
          session: updatedSession,
          isUpdatingProgress: false,
        ),
      );
    } catch (e) {
      emit(currentState.copyWith(isUpdatingProgress: false));
      debugPrint('Error updating exercise progress: $e');
    }
  }

  /// Mark current exercise as complete and move to next
  Future<void> completeCurrentExercise() async {
    final currentState = state;
    if (currentState is! WorkoutSessionActive) return;

    final currentExercise = currentState.currentExercise;
    if (currentExercise == null) return;

    await updateExerciseProgress(
      exerciseId: currentExercise.exerciseId,
      isCompleted: true,
    );

    // Move to next exercise
    if (currentState.currentExerciseIndex < currentState.totalExercises - 1) {
      emit(
        currentState.copyWith(
          currentExerciseIndex: currentState.currentExerciseIndex + 1,
        ),
      );
    }
  }

  /// Go to previous exercise
  void previousExercise() {
    final currentState = state;
    if (currentState is! WorkoutSessionActive) return;

    if (currentState.currentExerciseIndex > 0) {
      emit(
        currentState.copyWith(
          currentExerciseIndex: currentState.currentExerciseIndex - 1,
        ),
      );
    }
  }

  /// Go to next exercise
  void nextExercise() {
    final currentState = state;
    if (currentState is! WorkoutSessionActive) return;

    if (currentState.currentExerciseIndex < currentState.totalExercises - 1) {
      emit(
        currentState.copyWith(
          currentExerciseIndex: currentState.currentExerciseIndex + 1,
        ),
      );
    }
  }

  /// Pause workout session
  Future<void> pauseSession() async {
    final currentState = state;
    if (currentState is! WorkoutSessionActive) return;

    try {
      _stopTimer();

      final pausedSession = await _workoutRepository.pauseWorkoutSession(
        currentState.session.id,
      );

      emit(
        WorkoutSessionPaused(
          session: pausedSession,
          elapsedTime: currentState.elapsedTime,
        ),
      );
    } catch (e) {
      _startTimer();
      debugPrint('Error pausing session: $e');
    }
  }

  /// Resume workout session
  Future<void> resumeSession() async {
    final currentState = state;
    if (currentState is! WorkoutSessionPaused) return;

    try {
      final resumedSession = await _workoutRepository.resumeWorkoutSession(
        currentState.session.id,
      );

      _startTimer();

      emit(
        WorkoutSessionActive(
          session: resumedSession,
          elapsedTime: currentState.elapsedTime,
        ),
      );
    } catch (e) {
      debugPrint('Error resuming session: $e');
    }
  }

  /// Complete workout session
  Future<void> completeSession({
    String? notes,
    int? rating,
    int? caloriesBurned,
  }) async {
    final currentState = state;
    WorkoutSessionModel? session;
    Duration? elapsed;

    if (currentState is WorkoutSessionActive) {
      session = currentState.session;
      elapsed = currentState.elapsedTime;
    } else if (currentState is WorkoutSessionPaused) {
      session = currentState.session;
      elapsed = currentState.elapsedTime;
    }

    if (session == null) return;

    try {
      _stopTimer();
      emit(const WorkoutSessionLoading());

      final request = CompleteWorkoutSessionRequest(
        actualDuration: elapsed?.inMinutes ?? 0,
        caloriesBurned: caloriesBurned,
        notes: notes,
        rating: rating,
      );

      final completedSession = await _workoutRepository.completeWorkoutSession(
        session.id,
        request,
      );

      emit(WorkoutSessionCompleted(session: completedSession));
    } catch (e) {
      emit(WorkoutSessionError(message: e.toString()));
      debugPrint('Error completing session: $e');
    }
  }

  /// Cancel/abandon workout session
  Future<void> abandonSession() async {
    _stopTimer();
    emit(const WorkoutSessionNoActive());
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final currentState = state;
      if (currentState is WorkoutSessionActive) {
        emit(
          currentState.copyWith(
            elapsedTime: currentState.elapsedTime + const Duration(seconds: 1),
          ),
        );
      }
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  @override
  Future<void> close() {
    _stopTimer();
    return super.close();
  }
}
