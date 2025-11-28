import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../common/colo_extension.dart';
import '../../../app/routes.dart';
import '../../widgets/round_button.dart';

/// Activity selection screen for choosing different app modules
///
/// This screen provides navigation to:
/// - Workout Stats (Workout Tracker)
/// - Meal Stats (Meal Planner)
/// - Sleep Stats (Sleep Tracker)
class ActivitySelectionScreen extends StatelessWidget {
  const ActivitySelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColor.white,
      appBar: _buildAppBar(),
      body: _buildBody(context),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: TColor.white,
      centerTitle: true,
      elevation: 0,
      leading: const SizedBox(),
      title: Text(
        "Choose Activity",
        style: TextStyle(
          color: TColor.black,
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildWelcomeSection(),
            const SizedBox(height: 40),
            _buildActivityButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return Column(
      children: [
        Icon(Icons.fitness_center, size: 80, color: TColor.primaryColor1),
        const SizedBox(height: 20),
        Text(
          "Track Your Progress",
          style: TextStyle(
            color: TColor.black,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "Choose an activity to monitor and improve your fitness journey",
          textAlign: TextAlign.center,
          style: TextStyle(color: TColor.gray, fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildActivityButtons(BuildContext context) {
    return Column(
      children: [
        _buildWorkoutTrackerButton(context),
        const SizedBox(height: 15),
        _buildMealPlannerButton(context),
        const SizedBox(height: 15),
        _buildSleepTrackerButton(context),
      ],
    );
  }

  Widget _buildWorkoutTrackerButton(BuildContext context) {
    return RoundButton(
      title: "Workout Tracker",
      onPressed: () => _navigateToWorkoutStats(context),
    );
  }

  Widget _buildMealPlannerButton(BuildContext context) {
    return RoundButton(
      title: "Meal Planner",
      onPressed: () => _navigateToMealStats(context),
    );
  }

  Widget _buildSleepTrackerButton(BuildContext context) {
    return RoundButton(
      title: "Sleep Tracker",
      onPressed: () => _navigateToSleepStats(context),
    );
  }

  void _navigateToWorkoutStats(BuildContext context) {
    Navigator.pushNamed(context, Routes.workoutStatsScreen);
  }

  void _navigateToMealStats(BuildContext context) {
    Navigator.pushNamed(context, Routes.mealScheduleScreen);
  }

  void _navigateToSleepStats(BuildContext context) {
    Navigator.pushNamed(context, Routes.sleepPlanScreen);
  }
}
