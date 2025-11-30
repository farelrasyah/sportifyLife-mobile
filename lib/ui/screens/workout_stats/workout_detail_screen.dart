import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:lottie/lottie.dart';

import '../../../common/colo_extension.dart';
import '../../widgets/icon_title_next_row.dart';
import '../../widgets/round_button.dart';
import '../../widgets/exercises_set_section.dart';
import 'exercise_detail_screen.dart';
import 'workout_plan_screen.dart';

class WorkoutDetailScreen extends StatefulWidget {
  final Map workoutData;
  const WorkoutDetailScreen({super.key, required this.workoutData});

  @override
  State<WorkoutDetailScreen> createState() => _WorkoutDetailScreenState();
}

class _WorkoutDetailScreenState extends State<WorkoutDetailScreen> {
  final List<Map<String, String>> _recentWorkouts = [
    {
      "image": "assets/images/Workout1.png",
      "title": tr("fullbody_workout"),
      "time": "Today, 03:00pm",
    },
    {
      "image": "assets/images/Workout2.png",
      "title": tr("upperbody_workout"),
      "time": "June 05, 02:00pm",
    },
  ];

  final List<Map<String, String>> _requiredEquipment = [
    {"image": "assets/images/dumbell.json", "title": tr("barbell")},
    {"image": "assets/images/skipping_rope.png", "title": tr("skipping_rope")},
    {"image": "assets/images/bottle.json", "title": tr("bottle_1_liters")},
  ];

  final List<Map<String, dynamic>> _workoutSets = [
    {
      "name": tr("set_1"),
      "set": [
        {
          "image": "assets/images/images_1.png",
          "title": "Warm Up",
          "value": "05:00",
        },
        {
          "image": "assets/images/images_2.png",
          "title": "Jumping Jack",
          "value": "12x",
        },
        {
          "image": "assets/images/images_1.png",
          "title": "Skipping",
          "value": "15x",
        },
        {
          "image": "assets/images/images_2.png",
          "title": "Squats",
          "value": "20x",
        },
        {
          "image": "assets/images/images_1.png",
          "title": "Arm Raises",
          "value": "00:53",
        },
        {
          "image": "assets/images/images_2.png",
          "title": "Rest and Drink",
          "value": "02:00",
        },
      ],
    },
    {
      "name": "Set 2",
      "set": [
        {
          "image": "assets/images/images_1.png",
          "title": "Warm Up",
          "value": "05:00",
        },
        {
          "image": "assets/images/images_2.png",
          "title": "Jumping Jack",
          "value": "12x",
        },
        {
          "image": "assets/images/images_1.png",
          "title": "Skipping",
          "value": "15x",
        },
        {
          "image": "assets/images/images_2.png",
          "title": "Squats",
          "value": "20x",
        },
        {
          "image": "assets/images/images_1.png",
          "title": "Arm Raises",
          "value": "00:53",
        },
        {
          "image": "assets/images/images_2.png",
          "title": "Rest and Drink",
          "value": "02:00",
        },
      ],
    },
  ];

  Widget _buildImage(
    String path, {
    required double width,
    required double height,
    BoxFit? fit,
  }) {
    if (path.endsWith('.json')) {
      return Lottie.asset(
        path,
        width: width,
        height: height,
        fit: fit ?? BoxFit.contain,
      );
    }
    return Image.asset(
      path,
      width: width,
      height: height,
      fit: fit ?? BoxFit.contain,
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: TColor.primaryG),
      ),
      child: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [_buildMainAppBar(), _buildImageAppBar(screenSize)];
        },
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
            color: TColor.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
            ),
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Stack(
              children: [
                _buildScrollableContent(screenSize),
                _buildStartWorkoutButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMainAppBar() {
    return SliverAppBar(
      backgroundColor: Colors.transparent,
      centerTitle: true,
      elevation: 0,
      leading: InkWell(
        onTap: () {
          Navigator.pop(context);
        },
        child: Container(
          margin: const EdgeInsets.all(8),
          height: 40,
          width: 40,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: TColor.lightGray,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Image.asset(
            "assets/images/black_btn.png",
            width: 15,
            height: 15,
            fit: BoxFit.contain,
          ),
        ),
      ),
      actions: [
        InkWell(
          onTap: () {},
          child: Container(
            margin: const EdgeInsets.all(8),
            height: 40,
            width: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: TColor.lightGray,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Image.asset(
              "assets/images/more_btn.png",
              width: 15,
              height: 15,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildImageAppBar(Size screenSize) {
    return SliverAppBar(
      backgroundColor: Colors.transparent,
      centerTitle: true,
      elevation: 0,
      leadingWidth: 0,
      leading: Container(),
      expandedHeight: screenSize.width * 0.5,
      flexibleSpace: Align(
        alignment: Alignment.center,
        child: _buildImage(
          "assets/images/jump.json",
          width: screenSize.width * 0.75,
          height: screenSize.width * 0.8,
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  Widget _buildScrollableContent(Size screenSize) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 10),
          _buildDragHandle(),
          SizedBox(height: screenSize.width * 0.05),
          _buildWorkoutHeader(),
          SizedBox(height: screenSize.width * 0.05),
          _buildScheduleSection(),
          SizedBox(height: screenSize.width * 0.02),
          _buildDifficultySection(),
          SizedBox(height: screenSize.width * 0.05),
          _buildEquipmentSection(screenSize),
          SizedBox(height: screenSize.width * 0.05),
          _buildExercisesSection(),
          SizedBox(height: screenSize.width * 0.1),
        ],
      ),
    );
  }

  Widget _buildDragHandle() {
    return Container(
      width: 50,
      height: 4,
      decoration: BoxDecoration(
        color: TColor.gray.withOpacity(0.3),
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }

  Widget _buildWorkoutHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.workoutData["title"].toString(),
                style: TextStyle(
                  color: TColor.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                "${widget.workoutData["exercises"].toString()} | ${widget.workoutData["time"].toString()} | 320 Calories Burn",
                style: TextStyle(color: TColor.gray, fontSize: 12),
              ),
            ],
          ),
        ),
        TextButton(
          onPressed: () {},
          child: Image.asset(
            "assets/images/fav.png",
            width: 15,
            height: 15,
            fit: BoxFit.contain,
          ),
        ),
      ],
    );
  }

  Widget _buildScheduleSection() {
    return IconTitleNextRow(
      icon: "assets/images/time.png",
      title: "Schedule Workout",
      time: "5/27, 09:00 AM",
      color: TColor.primaryColor2.withOpacity(0.3),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const WorkoutPlanScreen()),
        );
      },
    );
  }

  Widget _buildDifficultySection() {
    return IconTitleNextRow(
      icon: "assets/images/difficulity.png",
      title: "Difficulity",
      time: "Beginner",
      color: TColor.secondaryColor2.withOpacity(0.3),
      onPressed: () {},
    );
  }

  Widget _buildEquipmentSection(Size screenSize) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "You'll Need",
              style: TextStyle(
                color: TColor.black,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            TextButton(
              onPressed: () {},
              child: Text(
                "${_requiredEquipment.length} Items",
                style: TextStyle(color: TColor.gray, fontSize: 12),
              ),
            ),
          ],
        ),
        SizedBox(
          height: screenSize.width * 0.5,
          child: ListView.builder(
            padding: EdgeInsets.zero,
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemCount: _requiredEquipment.length,
            itemBuilder: (context, index) {
              var equipmentItem = _requiredEquipment[index];
              return _buildEquipmentItem(equipmentItem, screenSize);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildEquipmentItem(
    Map<String, String> equipmentItem,
    Size screenSize,
  ) {
    return Container(
      margin: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: screenSize.width * 0.35,
            width: screenSize.width * 0.35,
            decoration: BoxDecoration(
              color: TColor.lightGray,
              borderRadius: BorderRadius.circular(15),
            ),
            alignment: Alignment.center,
            child: _buildImage(
              equipmentItem["image"].toString(),
              width: screenSize.width * 0.2,
              height: screenSize.width * 0.2,
              fit: BoxFit.contain,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              equipmentItem["title"].toString(),
              style: TextStyle(color: TColor.black, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExercisesSection() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Exercises",
              style: TextStyle(
                color: TColor.black,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            TextButton(
              onPressed: () {},
              child: Text(
                "${_workoutSets.length} Sets",
                style: TextStyle(color: TColor.gray, fontSize: 12),
              ),
            ),
          ],
        ),
        ListView.builder(
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: _workoutSets.length,
          itemBuilder: (context, index) {
            var setData = _workoutSets[index];
            return ExercisesSetSection(
              sObj: setData,
              onPressed: (exerciseObj) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ExerciseDetailScreen(exerciseData: exerciseObj),
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildStartWorkoutButton() {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [RoundButton(title: "Start Workout", onPressed: () {})],
      ),
    );
  }
}
