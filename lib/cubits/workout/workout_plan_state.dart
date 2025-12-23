import 'package:equatable/equatable.dart';
import '../data/models/workout_plan_model.dart';

/// Workout Plan States
abstract class WorkoutPlanState extends Equatable {
  const WorkoutPlanState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class WorkoutPlanInitial extends WorkoutPlanState {
  const WorkoutPlanInitial();
}

/// Loading state
class WorkoutPlanLoading extends WorkoutPlanState {
  const WorkoutPlanLoading();
}

/// Success state - list of workout plans
class WorkoutPlanListLoaded extends WorkoutPlanState {
  final List<CustomWorkoutPlanModel> plans;
  final bool isDeleting;
  final String? deletingId;

  const WorkoutPlanListLoaded({
    required this.plans,
    this.isDeleting = false,
    this.deletingId,
  });

  WorkoutPlanListLoaded copyWith({
    List<CustomWorkoutPlanModel>? plans,
    bool? isDeleting,
    String? deletingId,
  }) {
    return WorkoutPlanListLoaded(
      plans: plans ?? this.plans,
      isDeleting: isDeleting ?? this.isDeleting,
      deletingId: deletingId,
    );
  }

  @override
  List<Object?> get props => [plans, isDeleting, deletingId];
}

/// Success state - single workout plan detail
class WorkoutPlanDetailLoaded extends WorkoutPlanState {
  final CustomWorkoutPlanModel plan;

  const WorkoutPlanDetailLoaded({required this.plan});

  WorkoutPlanDetailLoaded copyWith({CustomWorkoutPlanModel? plan}) {
    return WorkoutPlanDetailLoaded(plan: plan ?? this.plan);
  }

  @override
  List<Object?> get props => [plan];
}

/// Creating/Updating plan state
class WorkoutPlanSaving extends WorkoutPlanState {
  const WorkoutPlanSaving();
}

/// Plan created/updated successfully
class WorkoutPlanSaved extends WorkoutPlanState {
  final CustomWorkoutPlanModel plan;
  final String message;

  const WorkoutPlanSaved({required this.plan, required this.message});

  @override
  List<Object?> get props => [plan, message];
}

/// Plan deleted successfully
class WorkoutPlanDeleted extends WorkoutPlanState {
  final String message;

  const WorkoutPlanDeleted({required this.message});

  @override
  List<Object?> get props => [message];
}

/// Error state
class WorkoutPlanError extends WorkoutPlanState {
  final String message;
  final String? errorCode;

  const WorkoutPlanError({required this.message, this.errorCode});

  @override
  List<Object?> get props => [message, errorCode];
}
