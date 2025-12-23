import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';
import '../../data/repositories/workout_repository.dart';
import '../../data/models/workout_plan_model.dart';
import 'workout_plan_state.dart';

/// Workout Plan Cubit for managing custom workout plans
class WorkoutPlanCubit extends Cubit<WorkoutPlanState> {
  final WorkoutRepository _workoutRepository;

  WorkoutPlanCubit({required WorkoutRepository workoutRepository})
    : _workoutRepository = workoutRepository,
      super(const WorkoutPlanInitial());

  /// Load all workout plans
  Future<void> loadWorkoutPlans() async {
    try {
      emit(const WorkoutPlanLoading());

      final plans = await _workoutRepository.getWorkoutPlans();

      emit(WorkoutPlanListLoaded(plans: plans));
    } catch (e) {
      emit(WorkoutPlanError(message: e.toString()));
      debugPrint('Error loading workout plans: $e');
    }
  }

  /// Load single workout plan by ID
  Future<void> loadWorkoutPlanById(String id) async {
    try {
      emit(const WorkoutPlanLoading());

      final plan = await _workoutRepository.getWorkoutPlanById(id);

      emit(WorkoutPlanDetailLoaded(plan: plan));
    } catch (e) {
      emit(WorkoutPlanError(message: e.toString()));
      debugPrint('Error loading workout plan: $e');
    }
  }

  /// Create new workout plan
  Future<void> createWorkoutPlan(CustomWorkoutPlanModel plan) async {
    try {
      emit(const WorkoutPlanSaving());

      final createdPlan = await _workoutRepository.createWorkoutPlan(plan);

      emit(
        WorkoutPlanSaved(
          plan: createdPlan,
          message: 'Workout plan created successfully!',
        ),
      );
    } catch (e) {
      emit(WorkoutPlanError(message: e.toString()));
      debugPrint('Error creating workout plan: $e');
    }
  }

  /// Update existing workout plan
  Future<void> updateWorkoutPlan(String id, CustomWorkoutPlanModel plan) async {
    try {
      emit(const WorkoutPlanSaving());

      final updatedPlan = await _workoutRepository.updateWorkoutPlan(id, plan);

      emit(
        WorkoutPlanSaved(
          plan: updatedPlan,
          message: 'Workout plan updated successfully!',
        ),
      );
    } catch (e) {
      emit(WorkoutPlanError(message: e.toString()));
      debugPrint('Error updating workout plan: $e');
    }
  }

  /// Delete workout plan
  Future<void> deleteWorkoutPlan(String id) async {
    final currentState = state;

    try {
      if (currentState is WorkoutPlanListLoaded) {
        emit(currentState.copyWith(isDeleting: true, deletingId: id));
      }

      await _workoutRepository.deleteWorkoutPlan(id);

      if (currentState is WorkoutPlanListLoaded) {
        final updatedPlans = currentState.plans
            .where((p) => p.id != id)
            .toList();
        emit(WorkoutPlanListLoaded(plans: updatedPlans));
      } else {
        emit(
          const WorkoutPlanDeleted(
            message: 'Workout plan deleted successfully!',
          ),
        );
      }
    } catch (e) {
      if (currentState is WorkoutPlanListLoaded) {
        emit(currentState.copyWith(isDeleting: false, deletingId: null));
      }
      emit(WorkoutPlanError(message: e.toString()));
      debugPrint('Error deleting workout plan: $e');
    }
  }

  /// Refresh workout plans
  Future<void> refreshWorkoutPlans() async {
    await loadWorkoutPlans();
  }
}
