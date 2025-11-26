import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../common/colo_extension.dart';
import '../../../common/common.dart';
import '../../widgets/icon_title_next_row.dart';
import '../../widgets/round_button.dart';

class AddAlarmScreen extends StatefulWidget {
  final DateTime selectedDate;

  const AddAlarmScreen({super.key, required this.selectedDate});

  @override
  State<AddAlarmScreen> createState() => _AddAlarmScreenState();
}

class _AddAlarmScreenState extends State<AddAlarmScreen> {
  bool _isVibrateEnabled = false;

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
            const SizedBox(height: 8),
            _buildAlarmSettingRow(
              icon: "assets/img/Bed_Add.png",
              title: "Bedtime",
              value: "09:00 PM",
              onTap: () {},
            ),
            const SizedBox(height: 10),
            _buildAlarmSettingRow(
              icon: "assets/img/HoursTime.png",
              title: "Hours of sleep",
              value: "8hours 30minutes",
              onTap: () {},
            ),
            const SizedBox(height: 10),
            _buildAlarmSettingRow(
              icon: "assets/img/Repeat.png",
              title: "Repeat",
              value: "Mon to Fri",
              onTap: () {},
            ),
            const SizedBox(height: 10),
            _buildVibrateToggleSection(),
            const Spacer(),
            _buildAddButton(),
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
            "assets/img/closed_btn.png",
            width: 15,
            height: 15,
            fit: BoxFit.contain,
          ),
        ),
      ),
      title: Text(
        "Add Alarm",
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
              "assets/img/more_btn.png",
              width: 15,
              height: 15,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAlarmSettingRow({
    required String icon,
    required String title,
    required String value,
    required VoidCallback onTap,
  }) {
    return IconTitleNextRow(
      icon: icon,
      title: title,
      time: value,
      color: TColor.lightGray,
      onPressed: onTap,
    );
  }

  Widget _buildVibrateToggleSection() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: TColor.lightGray,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(width: 15),
          _buildVibrateIcon(),
          const SizedBox(width: 8),
          _buildVibrateLabel(),
          _buildCustomToggleSwitch(),
        ],
      ),
    );
  }

  Widget _buildVibrateIcon() {
    return Container(
      width: 30,
      height: 30,
      alignment: Alignment.center,
      child: Image.asset(
        "assets/img/Vibrate.png",
        width: 18,
        height: 18,
        fit: BoxFit.contain,
      ),
    );
  }

  Widget _buildVibrateLabel() {
    return Expanded(
      child: Text(
        "Vibrate When Alarm Sound",
        style: TextStyle(color: TColor.gray, fontSize: 12),
      ),
    );
  }

  Widget _buildCustomToggleSwitch() {
    return SizedBox(
      height: 30,
      child: Transform.scale(
        scale: 0.7,
        child: CustomAnimatedToggleSwitch<bool>(
          current: _isVibrateEnabled,
          values: [false, true],
          indicatorSize: const Size.square(30.0),
          animationDuration: const Duration(milliseconds: 200),
          animationCurve: Curves.linear,
          onChanged: (value) => setState(() => _isVibrateEnabled = value),
          iconBuilder: (context, local, global) {
            return const SizedBox();
          },
          onTap: (value) => setState(() => _isVibrateEnabled = !_isVibrateEnabled),
          iconsTappable: false,
          wrapperBuilder: (context, global, child) {
            return Stack(
              alignment: Alignment.center,
              children: [
                Positioned(
                  left: 10.0,
                  right: 10.0,
                  height: 30.0,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: TColor.secondaryG),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(50.0),
                      ),
                    ),
                  ),
                ),
                child,
              ],
            );
          },
          foregroundIndicatorBuilder: (context, global) {
            return SizedBox.fromSize(
              size: const Size(10, 10),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: TColor.white,
                  borderRadius: const BorderRadius.all(Radius.circular(50.0)),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black38,
                      spreadRadius: 0.05,
                      blurRadius: 1.1,
                      offset: Offset(0.0, 0.8),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildAddButton() {
    return RoundButton(title: "Add", onPressed: () {});
  }
}
