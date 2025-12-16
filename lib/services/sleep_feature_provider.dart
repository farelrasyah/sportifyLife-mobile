import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/repositories/sleep_repository.dart';
import '../cubits/sleep_schedule_cubit.dart';
import '../cubits/sleep_activity_cubit.dart';
import '../cubits/sleep_calendar_cubit.dart';
import '../ui/screens/sleep_stats/sleep_activity_screen.dart';
import '../ui/screens/sleep_stats/sleep_plan_screen.dart';
import '../ui/screens/sleep_stats/add_alarm_screen.dart';

/// Sleep Feature Provider
///
/// Provides all necessary cubits for Sleep functionality.
/// Wrap your Sleep screens with this provider to inject dependencies.
class SleepFeatureProvider extends StatelessWidget {
  final Widget child;

  const SleepFeatureProvider({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // Sleep Repository - Single instance
        RepositoryProvider<SleepRepository>(
          create: (context) => SleepRepository(),
        ),

        // Sleep Schedule Cubit
        BlocProvider<SleepScheduleCubit>(
          create: (context) => SleepScheduleCubit(
            sleepRepository: context.read<SleepRepository>(),
          ),
        ),

        // Sleep Activity Cubit
        BlocProvider<SleepActivityCubit>(
          create: (context) => SleepActivityCubit(
            sleepRepository: context.read<SleepRepository>(),
          ),
        ),

        // Sleep Calendar Cubit
        BlocProvider<SleepCalendarCubit>(
          create: (context) => SleepCalendarCubit(
            sleepRepository: context.read<SleepRepository>(),
          ),
        ),
      ],
      child: child,
    );
  }
}

/// Sleep Navigation Helper
///
/// Utility class for navigating to Sleep screens with proper providers.
class SleepNavigation {
  /// Navigate to Sleep Activity Screen with providers
  static Future<void> pushSleepActivity(BuildContext context) async {
    if (context.mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              SleepFeatureProvider(child: SleepActivityScreen()),
        ),
      );
    }
  }

  /// Navigate to Sleep Plan Screen with providers
  static Future<void> pushSleepPlan(BuildContext context) async {
    if (context.mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SleepFeatureProvider(child: SleepPlanScreen()),
        ),
      );
    }
  }

  /// Navigate to Add Alarm Screen with providers
  static Future<dynamic> pushAddAlarm(
    BuildContext context,
    DateTime selectedDate,
  ) async {
    if (context.mounted) {
      return Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SleepFeatureProvider(
            child: AddAlarmScreen(selectedDate: selectedDate),
          ),
        ),
      );
    }
  }
}
