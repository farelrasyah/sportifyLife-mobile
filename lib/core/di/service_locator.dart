import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/exercise_repository.dart';
import '../../data/repositories/workout_repository.dart';
import '../../services/favorite_service.dart';
import '../../cubits/exercise/exercise_cubits.dart';
import '../../cubits/workout/workout_cubits.dart';

/// Service Locator / Dependency Injection Container
class ServiceLocator {
  static final ServiceLocator _instance = ServiceLocator._internal();
  factory ServiceLocator() => _instance;
  ServiceLocator._internal();

  // Repositories (Singletons)
  late final ExerciseRepository exerciseRepository;
  late final WorkoutRepository workoutRepository;

  // Services (Singletons)
  late final FavoriteExerciseService favoriteService;

  bool _isInitialized = false;

  /// Initialize all services and repositories
  Future<void> init() async {
    if (_isInitialized) return;

    // Initialize repositories
    exerciseRepository = ExerciseRepository();
    workoutRepository = WorkoutRepository();

    // Initialize services
    favoriteService = FavoriteExerciseService();

    _isInitialized = true;
  }

  /// Get singleton instance
  static ServiceLocator get instance => _instance;
}

/// Global service locator instance
final serviceLocator = ServiceLocator.instance;

/// Extension to easily access repositories
extension ServiceLocatorExtension on BuildContext {
  ExerciseRepository get exerciseRepository =>
      serviceLocator.exerciseRepository;
  WorkoutRepository get workoutRepository => serviceLocator.workoutRepository;
  FavoriteExerciseService get favoriteService => serviceLocator.favoriteService;
}

/// BLoC Provider wrapper that provides all exercise and workout cubits
class ExerciseWorkoutBlocProvider extends StatelessWidget {
  final Widget child;

  const ExerciseWorkoutBlocProvider({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // Exercise Cubits
        BlocProvider<ExerciseListCubit>(
          create: (context) => ExerciseListCubit(
            exerciseRepository: serviceLocator.exerciseRepository,
          ),
        ),
        BlocProvider<ExerciseDetailCubit>(
          create: (context) => ExerciseDetailCubit(
            exerciseRepository: serviceLocator.exerciseRepository,
            favoriteService: serviceLocator.favoriteService,
          ),
        ),
        BlocProvider<ExerciseFiltersCubit>(
          create: (context) => ExerciseFiltersCubit(
            exerciseRepository: serviceLocator.exerciseRepository,
          ),
        ),
        BlocProvider<FavoriteExercisesCubit>(
          create: (context) => FavoriteExercisesCubit(
            favoriteService: serviceLocator.favoriteService,
          ),
        ),

        // Workout Cubits
        BlocProvider<WorkoutPlanCubit>(
          create: (context) => WorkoutPlanCubit(
            workoutRepository: serviceLocator.workoutRepository,
          ),
        ),
        BlocProvider<WorkoutScheduleCubit>(
          create: (context) => WorkoutScheduleCubit(
            workoutRepository: serviceLocator.workoutRepository,
          ),
        ),
        BlocProvider<WorkoutSessionCubit>(
          create: (context) => WorkoutSessionCubit(
            workoutRepository: serviceLocator.workoutRepository,
          ),
        ),
        BlocProvider<WorkoutStatisticsCubit>(
          create: (context) => WorkoutStatisticsCubit(
            workoutRepository: serviceLocator.workoutRepository,
          ),
        ),
        BlocProvider<WorkoutHistoryCubit>(
          create: (context) => WorkoutHistoryCubit(
            workoutRepository: serviceLocator.workoutRepository,
          ),
        ),
      ],
      child: child,
    );
  }
}

/// Mixin for screens that need exercise cubits
mixin ExerciseCubitsMixin<T extends StatefulWidget> on State<T> {
  ExerciseListCubit get exerciseListCubit => context.read<ExerciseListCubit>();
  ExerciseDetailCubit get exerciseDetailCubit =>
      context.read<ExerciseDetailCubit>();
  ExerciseFiltersCubit get exerciseFiltersCubit =>
      context.read<ExerciseFiltersCubit>();
  FavoriteExercisesCubit get favoriteExercisesCubit =>
      context.read<FavoriteExercisesCubit>();
}

/// Mixin for screens that need workout cubits
mixin WorkoutCubitsMixin<T extends StatefulWidget> on State<T> {
  WorkoutPlanCubit get workoutPlanCubit => context.read<WorkoutPlanCubit>();
  WorkoutScheduleCubit get workoutScheduleCubit =>
      context.read<WorkoutScheduleCubit>();
  WorkoutSessionCubit get workoutSessionCubit =>
      context.read<WorkoutSessionCubit>();
  WorkoutStatisticsCubit get workoutStatisticsCubit =>
      context.read<WorkoutStatisticsCubit>();
  WorkoutHistoryCubit get workoutHistoryCubit =>
      context.read<WorkoutHistoryCubit>();
}
