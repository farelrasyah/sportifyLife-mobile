import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../common/colo_extension.dart';
import '../../../common/common.dart';
import '../../widgets/icon_title_next_row.dart';
import '../../widgets/round_button.dart';

class AddWorkoutPlanScreen extends StatefulWidget {
  final DateTime selectedDate;
  const AddWorkoutPlanScreen({super.key, required this.selectedDate});

  @override
  State<AddWorkoutPlanScreen> createState() => _AddWorkoutPlanScreenState();
}

class _AddWorkoutPlanScreenState extends State<AddWorkoutPlanScreen> {
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: _buildAppBar(),
      backgroundColor: TColor.white,
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDateSection(),
            const SizedBox(height: 20),
            _buildTimeSection(screenSize),
            const SizedBox(height: 20),
            _buildWorkoutDetailsSection(),
            const Spacer(),
            _buildSaveButton(),
            const SizedBox(height: 20),
          ],
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
      title: Text(
        "Add Schedule",
        style: TextStyle(
          color: TColor.black,
          fontSize: 16,
          fontWeight: FontWeight.w700,
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

  Widget _buildDateSection() {
    return Row(
      children: [
        Image.asset("assets/images/date.png", width: 20, height: 20),
        const SizedBox(width: 8),
        Text(
          dateToString(widget.selectedDate, formatStr: "E, dd MMMM yyyy"),
          style: TextStyle(color: TColor.gray, fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildTimeSection(Size screenSize) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Time",
          style: TextStyle(
            color: TColor.black,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(
          height: screenSize.width * 0.35,
          child: CupertinoDatePicker(
            onDateTimeChanged: (newDate) {},
            initialDateTime: DateTime.now(),
            use24hFormat: false,
            minuteInterval: 1,
            mode: CupertinoDatePickerMode.time,
          ),
        ),
      ],
    );
  }

  Widget _buildWorkoutDetailsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Details Workout",
          style: TextStyle(
            color: TColor.black,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        _buildWorkoutOptionRow(
          icon: "assets/images/choose_workout.png",
          title: "Choose Workout",
          value: "Upperbody",
        ),
        const SizedBox(height: 10),
        _buildWorkoutOptionRow(
          icon: "assets/images/difficulity.png",
          title: "Difficulity",
          value: "Beginner",
        ),
        const SizedBox(height: 10),
        _buildWorkoutOptionRow(
          icon: "assets/images/repetitions.png",
          title: "Custom Repetitions",
          value: "",
        ),
        const SizedBox(height: 10),
        _buildWorkoutOptionRow(
          icon: "assets/images/repetitions.png",
          title: "Custom Weights",
          value: "",
        ),
      ],
    );
  }

  Widget _buildWorkoutOptionRow({
    required String icon,
    required String title,
    required String value,
  }) {
    return IconTitleNextRow(
      icon: icon,
      title: title,
      time: value,
      color: TColor.lightGray,
      onPressed: () {},
    );
  }

  Widget _buildSaveButton() {
    return RoundButton(title: "Save", onPressed: () {});
  }
}
