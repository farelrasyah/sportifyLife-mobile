import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:readmore/readmore.dart';
import 'package:lottie/lottie.dart';

import '../../../common/colo_extension.dart';
import '../../widgets/round_button.dart';
import '../../widgets/step_detail_row.dart';

class ExerciseDetailScreen extends StatefulWidget {
  final Map exerciseData;
  const ExerciseDetailScreen({super.key, required this.exerciseData});

  @override
  State<ExerciseDetailScreen> createState() => _ExerciseDetailScreenState();
}

class _ExerciseDetailScreenState extends State<ExerciseDetailScreen> {
  final List<Map<String, String>> _exerciseSteps = [
    {
      "no": "01",
      "title": "Spread Your Arms",
      "detail":
          "To make the gestures feel more relaxed, stretch your arms as you start this movement. No bending of hands.",
    },
    {
      "no": "02",
      "title": "Rest at The Toe",
      "detail":
          "The basis of this movement is jumping. Now, what needs to be considered is that you have to use the tips of your feet",
    },
    {
      "no": "03",
      "title": "Adjust Foot Movement",
      "detail":
          "Jumping Jack is not just an ordinary jump. But, you also have to pay close attention to leg movements.",
    },
    {
      "no": "04",
      "title": "Clapping Both Hands",
      "detail":
          "This cannot be taken lightly. You see, without realizing it, the clapping of your hands helps you to keep your rhythm while doing the Jumping Jack",
    },
  ];

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: _buildAppBar(),
      backgroundColor: TColor.white,
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildVideoSection(screenSize),
              const SizedBox(height: 15),
              _buildExerciseInfo(),
              const SizedBox(height: 15),
              _buildDescriptionSection(),
              const SizedBox(height: 15),
              _buildStepsSection(),
              _buildCustomRepetitionsSection(),
              _buildSaveButton(),
              const SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: TColor.white,
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
            "assets/images/closed_btn.png",
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

  Widget _buildVideoSection(Size screenSize) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: screenSize.width,
          height: screenSize.width * 0.43,
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: TColor.primaryG),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Image.asset(
            "assets/images/video_temp.png",
            width: screenSize.width,
            height: screenSize.width * 0.43,
            fit: BoxFit.contain,
          ),
        ),
        Container(
          width: screenSize.width,
          height: screenSize.width * 0.43,
          decoration: BoxDecoration(
            color: TColor.black.withOpacity(0.2),
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: Image.asset("assets/images/Play.png", width: 30, height: 30),
        ),
      ],
    );
  }

  Widget _buildExerciseInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.exerciseData["title"].toString(),
          style: TextStyle(
            color: TColor.black,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          "Easy | 390 Calories Burn",
          style: TextStyle(color: TColor.gray, fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildDescriptionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Descriptions",
          style: TextStyle(
            color: TColor.black,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        ReadMoreText(
          'A jumping jack, also known as a star jump and called a side-straddle hop in the US military, is a physical jumping exercise performed by jumping to a position with the legs spread wide A jumping jack, also known as a star jump and called a side-straddle hop in the US military, is a physical jumping exercise performed by jumping to a position with the legs spread wide',
          trimLines: 4,
          colorClickableText: TColor.black,
          trimMode: TrimMode.Line,
          trimCollapsedText: ' Read More ...',
          trimExpandedText: ' Read Less',
          style: TextStyle(color: TColor.gray, fontSize: 12),
          moreStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
        ),
      ],
    );
  }

  Widget _buildStepsSection() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "How To Do It",
              style: TextStyle(
                color: TColor.black,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            TextButton(
              onPressed: () {},
              child: Text(
                "${_exerciseSteps.length} Sets",
                style: TextStyle(color: TColor.gray, fontSize: 12),
              ),
            ),
          ],
        ),
        ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: _exerciseSteps.length,
          itemBuilder: (context, index) {
            var stepData = _exerciseSteps[index];
            return StepDetailRow(
              sObj: stepData,
              isLast: _exerciseSteps.last == stepData,
            );
          },
        ),
      ],
    );
  }

  Widget _buildCustomRepetitionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Custom Repetitions",
          style: TextStyle(
            color: TColor.black,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(
          height: 150,
          child: CupertinoPicker.builder(
            itemExtent: 40,
            selectionOverlay: Container(
              width: double.maxFinite,
              height: 40,
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: TColor.gray.withOpacity(0.2),
                    width: 1,
                  ),
                  bottom: BorderSide(
                    color: TColor.gray.withOpacity(0.2),
                    width: 1,
                  ),
                ),
              ),
            ),
            onSelectedItemChanged: (index) {},
            childCount: 60,
            itemBuilder: (context, index) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.asset(
                    "assets/images/fire.json",
                    width: 15,
                    height: 15,
                    fit: BoxFit.contain,
                  ),
                  Text(
                    " ${(index + 1) * 15} Calories Burn",
                    style: TextStyle(color: TColor.gray, fontSize: 10),
                  ),
                  Text(
                    " ${index + 1} ",
                    style: TextStyle(
                      color: TColor.gray,
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    " times",
                    style: TextStyle(color: TColor.gray, fontSize: 16),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSaveButton() {
    return RoundButton(title: "Save", elevation: 0, onPressed: () {});
  }
}
