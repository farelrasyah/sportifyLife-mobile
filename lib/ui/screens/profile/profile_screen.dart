import 'package:flutter/material.dart';
import 'package:animated_toggle_switch/animated_toggle_switch.dart';

import '../../../common/colo_extension.dart';
import '../../widgets/round_button.dart';
import '../../widgets/setting_row.dart';
import '../../widgets/title_subtitle_cell.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _notificationEnabled = false;

  final List<Map<String, String>> _userAccountOptions = [
    {"icon": "assets/img/p_personal.png", "title": "Personal Data", "id": "1"},
    {"icon": "assets/img/p_achi.png", "title": "Achievement", "id": "2"},
    {
      "icon": "assets/img/p_activity.png",
      "title": "Activity History",
      "id": "3",
    },
    {
      "icon": "assets/img/p_workout.png",
      "title": "Workout Progress",
      "id": "4",
    },
  ];

  final List<Map<String, String>> _additionalOptions = [
    {"icon": "assets/img/p_contact.png", "title": "Contact Us", "id": "5"},
    {"icon": "assets/img/p_privacy.png", "title": "Privacy Policy", "id": "6"},
    {"icon": "assets/img/p_setting.png", "title": "Setting", "id": "7"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      backgroundColor: TColor.white,
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildUserProfileHeader(),
              const SizedBox(height: 15),
              _buildUserStatsRow(),
              const SizedBox(height: 25),
              _buildAccountSection(),
              const SizedBox(height: 25),
              _buildNotificationSection(),
              const SizedBox(height: 25),
              _buildAdditionalOptionsSection(),
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
      leadingWidth: 0,
      title: Text(
        "Profile",
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

  Widget _buildUserProfileHeader() {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: Image.asset(
            "assets/img/u2.png",
            width: 50,
            height: 50,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Farasyah",
                style: TextStyle(
                  color: TColor.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                "Lose a Fat Program",
                style: TextStyle(color: TColor.gray, fontSize: 12),
              ),
            ],
          ),
        ),
        SizedBox(
          width: 70,
          height: 25,
          child: RoundButton(
            title: "Edit",
            type: RoundButtonType.bgGradient,
            fontSize: 12,
            fontWeight: FontWeight.w400,
            onPressed: () {},
          ),
        ),
      ],
    );
  }

  Widget _buildUserStatsRow() {
    return const Row(
      children: [
        Expanded(
          child: TitleSubtitleCell(title: "180cm", subtitle: "Height"),
        ),
        SizedBox(width: 15),
        Expanded(
          child: TitleSubtitleCell(title: "65kg", subtitle: "Weight"),
        ),
        SizedBox(width: 15),
        Expanded(
          child: TitleSubtitleCell(title: "22yo", subtitle: "Age"),
        ),
      ],
    );
  }

  Widget _buildAccountSection() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      decoration: BoxDecoration(
        color: TColor.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 2)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Account",
            style: TextStyle(
              color: TColor.black,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: _userAccountOptions.length,
            itemBuilder: (context, index) {
              var option = _userAccountOptions[index];
              return SettingRow(
                icon: option["icon"]!,
                title: option["title"]!,
                onPressed: () {},
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationSection() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      decoration: BoxDecoration(
        color: TColor.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 2)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Notification",
            style: TextStyle(
              color: TColor.black,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 30,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/img/p_notification.png",
                  height: 15,
                  width: 15,
                  fit: BoxFit.contain,
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Text(
                    "Pop-up Notification",
                    style: TextStyle(color: TColor.black, fontSize: 12),
                  ),
                ),
                _buildCustomToggleSwitch(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomToggleSwitch() {
    return CustomAnimatedToggleSwitch<bool>(
      current: _notificationEnabled,
      values: const [false, true],
      dif: 0.0,
      indicatorSize: const Size.square(30.0),
      animationDuration: const Duration(milliseconds: 200),
      animationCurve: Curves.linear,
      onChanged: (value) => setState(() => _notificationEnabled = value),
      iconBuilder: (context, local, global) {
        return const SizedBox();
      },
      defaultCursor: SystemMouseCursors.click,
      onTap: () => setState(() => _notificationEnabled = !_notificationEnabled),
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
                  borderRadius: const BorderRadius.all(Radius.circular(50.0)),
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
    );
  }

  Widget _buildAdditionalOptionsSection() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      decoration: BoxDecoration(
        color: TColor.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 2)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Other",
            style: TextStyle(
              color: TColor.black,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            itemCount: _additionalOptions.length,
            itemBuilder: (context, index) {
              var option = _additionalOptions[index];
              return SettingRow(
                icon: option["icon"]!,
                title: option["title"]!,
                onPressed: () {},
              );
            },
          ),
        ],
      ),
    );
  }
}
