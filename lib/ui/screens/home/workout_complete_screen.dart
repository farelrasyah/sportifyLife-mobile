import 'package:flutter/material.dart';

import '../../../common/colo_extension.dart';
import '../../widgets/round_button.dart';

class WorkoutCompleteScreen extends StatelessWidget {
  const WorkoutCompleteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return Scaffold(
      backgroundColor: TColor.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              _buildCongratulationsImage(mediaQuery),
              const SizedBox(height: 20),
              _buildTitle(),
              const SizedBox(height: 20),
              _buildSubtitle(),
              const Spacer(),
              _buildBackButton(context),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCongratulationsImage(MediaQueryData mediaQuery) {
    return Image.asset(
      "assets/images/finished_workout.png",
      height: mediaQuery.size.width * 0.8,
      fit: BoxFit.fitHeight,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          height: mediaQuery.size.width * 0.8,
          decoration: BoxDecoration(
            color: TColor.lightGray,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Icon(
            Icons.check_circle_outline,
            size: 100,
            color: TColor.primary,
          ),
        );
      },
    );
  }

  Widget _buildTitle() {
    return Text(
      "Congratulations, You Have Finished Your Workout",
      textAlign: TextAlign.center,
      style: TextStyle(
        color: TColor.black,
        fontSize: 20,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  Widget _buildSubtitle() {
    return Text(
      "Exercises is king and nutrition is queen. Combine the two and you will have a kingdom",
      textAlign: TextAlign.center,
      style: TextStyle(color: TColor.gray, fontSize: 12),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return RoundButton(
      title: "Back To Home",
      onPressed: () => Navigator.pop(context),
    );
  }
}
