/// SportifyLife App Routes
///
/// This file contains all route definitions and navigation logic for the SportifyLife app.
///
/// Features:
/// - Centralized route management with consistent naming
/// - Proper argument handling for screens requiring parameters
/// - BLoC provider integration for state management
/// - Error handling for invalid routes
/// - Organized by feature modules (Auth, Home, Meal Stats, etc.)
///
/// Usage:
/// ```dart
/// Navigator.pushNamed(context, Routes.workoutStatsScreen);
///
/// // For screens with arguments:
/// Navigator.pushNamed(
///   context,
///   Routes.exerciseDetailScreen,
///   arguments: {'exerciseData': exerciseData}
/// );
/// ```

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Core Screens
import '../ui/screens/splash_screen.dart';
import '../ui/screens/profile/complete_profile_screen.dart';
import '../ui/screens/profile/goal_screen.dart';
import '../ui/screens/welcome_screen.dart';


// Onboarding Screens
import '../ui/screens/onboarding/view/onboarding_screen.dart';

// Auth Screens
import '../ui/screens/auth/login_screen.dart';
import '../ui/screens/auth/register_screen.dart';
import '../ui/screens/auth/verify_email_screen.dart';

// Home Screens
import '../ui/screens/home/main_screen.dart';
import '../ui/screens/home/fitness_tracker_screen.dart';
import '../ui/screens/home/notification_screen.dart';
import '../ui/screens/home/workout_complete_screen.dart';

// Navigation Screens
import '../ui/screens/navigation/activity_selection_screen.dart';
import '../ui/widgets/bottom_nav/bottom_nav_bar.dart';
// Meal Stats Screens
import '../ui/screens/meal_stats/food_detail_screen.dart';
import '../ui/screens/meal_stats/meal_detail_screen.dart';
import '../ui/screens/meal_stats/meal_organizer_screen.dart';
import '../ui/screens/meal_stats/meal_schedule_screen.dart';

// Profile Screens
import '../ui/screens/profile/profile_screen.dart';

// Progress Gallery Screens
import '../ui/screens/progress_gallery/progress_gallery_screen.dart';
import '../ui/screens/progress_gallery/report_screen.dart';
import '../ui/screens/progress_gallery/result_comparison_screen.dart';

// Sleep Stats Screens
import '../ui/screens/sleep_stats/add_alarm_screen.dart';
import '../ui/screens/sleep_stats/sleep_activity_screen.dart';
import '../ui/screens/sleep_stats/sleep_plan_screen.dart';

// Workout Stats Screens
import '../ui/screens/workout_stats/add_workout_plan_screen.dart';
import '../ui/screens/workout_stats/exercise_detail_screen.dart';
import '../ui/screens/workout_stats/workout_detail_screen.dart';
import '../ui/screens/workout_stats/workout_plan_screen.dart';
import '../ui/screens/workout_stats/workout_stats_screen.dart';

// Cubits
import '../cubits/auth_cubit.dart';
import '../cubits/verify_cubit.dart';
import '../cubits/user_details_cubit.dart';

// Repositories
import '../data/repositories/user_details_repository.dart';

/// Route names
class Routes {
  // Core Routes
  static const String splashScreen = '/';
  static const String completeProfileScreen = '/completeProfile';
  static const String goalScreen = '/goal';
  static const String welcomeScreen = '/welcome';
  static const String homeScreen = '/home';

  // Onboarding Routes
  static const String onboardingScreen = '/onboarding';

  // Auth Routes
  static const String loginScreen = '/login';
  static const String registerScreen = '/register';
  static const String verifyEmailScreen = '/verifyEmail';

  // Home Routes
  static const String mainScreen = '/main';
  static const String fitnessTrackerScreen = '/fitnessTracker';
  static const String notificationScreen = '/notification';
  static const String workoutCompleteScreen = '/workoutComplete';

  // Navigation Routes
  static const String activitySelectionScreen = '/activitySelection';
  static const String mainBottomNavigationScreen = '/mainBottomNavigation';
  static const String simpleBottomNavigationScreen = '/simpleBottomNavigation';

  // Meal Stats Routes
  static const String foodDetailScreen = '/foodDetail';
  static const String mealDetailScreen = '/mealDetail';
  static const String mealOrganizerScreen = '/mealOrganizer';
  static const String mealScheduleScreen = '/mealSchedule';

  // Profile Routes
  static const String profileScreen = '/profile';

  // Progress Gallery Routes
  static const String progressGalleryScreen = '/progressGallery';
  static const String reportScreen = '/report';
  static const String resultComparisonScreen = '/resultComparison';

  // Sleep Stats Routes
  static const String addAlarmScreen = '/addAlarm';
  static const String sleepActivityScreen = '/sleepActivity';
  static const String sleepPlanScreen = '/sleepPlan';

  // Workout Stats Routes
  static const String addWorkoutPlanScreen = '/addWorkoutPlan';
  static const String exerciseDetailScreen = '/exerciseDetail';
  static const String workoutDetailScreen = '/workoutDetail';
  static const String workoutPlanScreen = '/workoutPlan';
  static const String workoutStatsScreen = '/workoutStats';
}

/// Generate routes with proper BLoC providers
class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Extract arguments
    final args = settings.arguments;

    switch (settings.name) {
      // Core Routes
      case Routes.splashScreen:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const SplashScreen(),
        );

      case Routes.completeProfileScreen:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => BlocProvider(
            create: (_) => UserDetailsCubit(UserDetailsRepository()),
            child: const CompleteProfileScreen(),
          ),
        );

      case Routes.goalScreen:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const GoalScreen(),
        );

      case Routes.welcomeScreen:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const WelcomeView(),
        );


      // Onboarding Routes
      case Routes.onboardingScreen:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const AnimatedOnboardingScreen(),
        );

      // Auth Routes
      case Routes.loginScreen:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => BlocProvider(
            create: (_) => AuthCubit(),
            child: const LoginScreen(),
          ),
        );

      case Routes.registerScreen:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => BlocProvider(
            create: (_) => AuthCubit(),
            child: const RegisterScreen(),
          ),
        );

      case Routes.verifyEmailScreen:
        if (args is Map<String, dynamic>) {
          return MaterialPageRoute(
            settings: settings,
            builder: (_) => MultiBlocProvider(
              providers: [
                BlocProvider(create: (_) => AuthCubit()),
                BlocProvider(create: (_) => VerifyCubit()),
              ],
              child: VerifyEmailScreen(email: args['email'] as String),
            ),
          );
        }
        return _errorRoute();

      // Home Routes
      case Routes.mainScreen:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const MainScreen(),
        );

      case Routes.fitnessTrackerScreen:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const FitnessTrackerScreen(),
        );

      case Routes.notificationScreen:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const NotificationScreen(),
        );

      case Routes.workoutCompleteScreen:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const WorkoutCompleteScreen(),
        );

      // Navigation Routes
      case Routes.activitySelectionScreen:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const ActivitySelectionScreen(),
        );

      case Routes.mainBottomNavigationScreen:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const MainBottomNavigation(),
        );

      // Meal Stats Routes
      case Routes.foodDetailScreen:
        if (args is Map<String, dynamic>) {
          return MaterialPageRoute(
            settings: settings,
            builder: (_) => FoodDetailScreen(
              foodData: args['foodData'],
              mealData: args['mealData'],
            ),
          );
        }
        return _errorRoute();

      case Routes.mealDetailScreen:
        if (args is Map<String, dynamic>) {
          return MaterialPageRoute(
            settings: settings,
            builder: (_) =>
                MealDetailScreen(mealCategory: args['mealCategory']),
          );
        }
        return _errorRoute();

      case Routes.mealOrganizerScreen:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const MealOrganizerScreen(),
        );

      case Routes.mealScheduleScreen:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const MealScheduleScreen(),
        );

      // Profile Routes
      case Routes.profileScreen:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const ProfileScreen(),
        );

      // Progress Gallery Routes
      case Routes.progressGalleryScreen:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const ProgressGalleryScreen(),
        );

      case Routes.reportScreen:
        if (args is Map<String, dynamic>) {
          return MaterialPageRoute(
            settings: settings,
            builder: (_) => ReportScreen(
              startDate: args['startDate'] as DateTime,
              endDate: args['endDate'] as DateTime,
            ),
          );
        }
        return _errorRoute();

      case Routes.resultComparisonScreen:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const ResultComparisonScreen(),
        );

      // Sleep Stats Routes
      case Routes.addAlarmScreen:
        if (args is Map<String, dynamic>) {
          return MaterialPageRoute(
            settings: settings,
            builder: (_) =>
                AddAlarmScreen(selectedDate: args['selectedDate'] as DateTime),
          );
        }
        return _errorRoute();

      case Routes.sleepActivityScreen:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const SleepActivityScreen(),
        );

      case Routes.sleepPlanScreen:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const SleepPlanScreen(),
        );

      // Workout Stats Routes
      case Routes.addWorkoutPlanScreen:
        if (args is Map<String, dynamic>) {
          return MaterialPageRoute(
            settings: settings,
            builder: (_) => AddWorkoutPlanScreen(
              selectedDate: args['selectedDate'] as DateTime,
            ),
          );
        }
        return _errorRoute();

      case Routes.exerciseDetailScreen:
        if (args is Map<String, dynamic>) {
          return MaterialPageRoute(
            settings: settings,
            builder: (_) =>
                ExerciseDetailScreen(exerciseData: args['exerciseData']),
          );
        }
        return _errorRoute();

      case Routes.workoutDetailScreen:
        if (args is Map<String, dynamic>) {
          return MaterialPageRoute(
            settings: settings,
            builder: (_) =>
                WorkoutDetailScreen(workoutData: args['workoutData']),
          );
        }
        return _errorRoute();

      case Routes.workoutPlanScreen:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const WorkoutPlanScreen(),
        );

      case Routes.workoutStatsScreen:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const WorkoutStatsScreen(),
        );

      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: const Center(child: Text('Route not found')),
      ),
    );
  }
}

/// Helper class for common navigation patterns
class RouteHelper {
  /// Navigate to a screen without arguments
  static Future<T?> navigateTo<T>(BuildContext context, String routeName) {
    return Navigator.pushNamed<T>(context, routeName);
  }

  /// Navigate to a screen with arguments
  static Future<T?> navigateToWithArgs<T>(
    BuildContext context,
    String routeName,
    Map<String, dynamic> arguments,
  ) {
    return Navigator.pushNamed<T>(context, routeName, arguments: arguments);
  }

  /// Replace current screen with new screen
  static Future<T?> navigateAndReplace<T>(
    BuildContext context,
    String routeName, {
    Map<String, dynamic>? arguments,
  }) {
    return Navigator.pushReplacementNamed<T, Object?>(
      context,
      routeName,
      arguments: arguments,
    );
  }

  /// Navigate and clear all previous routes
  static Future<T?> navigateAndClearStack<T>(
    BuildContext context,
    String routeName, {
    Map<String, dynamic>? arguments,
  }) {
    return Navigator.pushNamedAndRemoveUntil<T>(
      context,
      routeName,
      (route) => false,
      arguments: arguments,
    );
  }

  // Specific navigation helpers for commonly used screens

  /// Navigate to workout detail screen
  static Future<void> navigateToWorkoutDetail(
    BuildContext context,
    Map workoutData,
  ) {
    return navigateToWithArgs(context, Routes.workoutDetailScreen, {
      'workoutData': workoutData,
    });
  }

  /// Navigate to exercise detail screen
  static Future<void> navigateToExerciseDetail(
    BuildContext context,
    Map exerciseData,
  ) {
    return navigateToWithArgs(context, Routes.exerciseDetailScreen, {
      'exerciseData': exerciseData,
    });
  }

  /// Navigate to food detail screen
  static Future<void> navigateToFoodDetail(
    BuildContext context,
    Map foodData,
    Map mealData,
  ) {
    return navigateToWithArgs(context, Routes.foodDetailScreen, {
      'foodData': foodData,
      'mealData': mealData,
    });
  }

  /// Navigate to meal detail screen
  static Future<void> navigateToMealDetail(
    BuildContext context,
    Map mealCategory,
  ) {
    return navigateToWithArgs(context, Routes.mealDetailScreen, {
      'mealCategory': mealCategory,
    });
  }

  /// Navigate to add alarm screen
  static Future<void> navigateToAddAlarm(
    BuildContext context,
    DateTime selectedDate,
  ) {
    return navigateToWithArgs(context, Routes.addAlarmScreen, {
      'selectedDate': selectedDate,
    });
  }

  /// Navigate to add workout plan screen
  static Future<void> navigateToAddWorkoutPlan(
    BuildContext context,
    DateTime selectedDate,
  ) {
    return navigateToWithArgs(context, Routes.addWorkoutPlanScreen, {
      'selectedDate': selectedDate,
    });
  }

  /// Navigate to report screen
  static Future<void> navigateToReport(
    BuildContext context,
    DateTime startDate,
    DateTime endDate,
  ) {
    return navigateToWithArgs(context, Routes.reportScreen, {
      'startDate': startDate,
      'endDate': endDate,
    });
  }

  /// Navigate to verify email screen
  static Future<void> navigateToVerifyEmail(
    BuildContext context,
    String email,
  ) {
    return navigateToWithArgs(context, Routes.verifyEmailScreen, {
      'email': email,
    });
  }

  /// Navigate to main bottom navigation (main app entry point)
  static Future<void> navigateToMainApp(BuildContext context) {
    return navigateAndClearStack(context, Routes.mainBottomNavigationScreen);
  }

  /// Navigate to activity selection screen
  static Future<void> navigateToActivitySelection(BuildContext context) {
    return navigateTo(context, Routes.activitySelectionScreen);
  }

  /// Navigate to simple bottom navigation (for testing)
  static Future<void> navigateToSimpleApp(BuildContext context) {
    return navigateAndClearStack(context, Routes.simpleBottomNavigationScreen);
  }
}
