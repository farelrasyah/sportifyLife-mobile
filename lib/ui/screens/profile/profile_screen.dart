import 'package:flutter/material.dart';
import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../common/colo_extension.dart';
import '../../widgets/setting_row.dart';
import '../../widgets/title_subtitle_cell.dart';
import '../../widgets/home_container_appbar.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _notificationEnabled = false;

  final List<Map<String, String>> _userAccountOptions = [
    {
      "icon": "assets/images/p_personal.png",
      "title": tr("personal_data"),
      "id": "1",
    },
    {"icon": "assets/images/p_achi.png", "title": tr("achievement"), "id": "2"},
    {
      "icon": "assets/images/p_activity.png",
      "title": tr("activity_history"),
      "id": "3",
    },
    {
      "icon": "assets/images/p_workout.png",
      "title": tr("workout_progress"),
      "id": "4",
    },
  ];

  final List<Map<String, String>> _additionalOptions = [
    {
      "icon": "assets/images/p_contact.png",
      "title": tr("contact_us"),
      "id": "5",
    },
    {
      "icon": "assets/images/p_privacy.png",
      "title": tr("privacy_policy"),
      "id": "6",
    },
    {"icon": "assets/images/p_setting.png", "title": tr("settings"), "id": "7"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColor.white,
      body: Column(
        children: [
          HomeContainerAppbar(
            profileImage: "assets/images/u2.png",
            title: "Farasyah",
            welcomeText: "Your Profile",
            primaryColor: const Color(0xFF7B8FE8),
            lightColor: const Color(0xFF8FA3F5),
            darkColor: const Color(0xFF6578DC),
            actionIcon: Icons.settings,
            onActionPressed: () {
              // Navigate to settings
            },
            showActionButton: true,
            enableProfileZoom: true,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.only(
                  top: 15,
                  bottom: 140, // Add bottom padding to avoid bottom nav
                  left: 25,
                  right: 25,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildUserStatsRow(),
                    const SizedBox(height: 20),
                    _buildAccountSection(),
                    const SizedBox(height: 20),
                    _buildNotificationSection(),
                    const SizedBox(height: 20),
                    _buildAdditionalOptionsSection(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserStatsRow() {
    return Row(
      children: [
        Expanded(
          child: TitleSubtitleCell(
            title: "180cm",
            subtitle: tr("height_label"),
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: TitleSubtitleCell(title: "65kg", subtitle: tr("weight_label")),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: TitleSubtitleCell(title: "22yo", subtitle: tr("age_label")),
        ),
      ],
    );
  }

  Widget _buildAccountSection() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
      decoration: BoxDecoration(
        color: TColor.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 2)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            tr("account_label"),
            style: TextStyle(
              color: TColor.black,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
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
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
      decoration: BoxDecoration(
        color: TColor.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 2)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            tr("notification_title"),
            style: TextStyle(
              color: TColor.black,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          SizedBox(
            height: 30,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/images/p_notification.png",
                  height: 15,
                  width: 15,
                  fit: BoxFit.contain,
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Text(
                    tr("popup_notification"),
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
      indicatorSize: const Size.square(30.0),
      animationDuration: const Duration(milliseconds: 200),
      animationCurve: Curves.linear,
      onChanged: (value) => setState(() => _notificationEnabled = value),
      iconBuilder: (context, local, global) {
        return const SizedBox();
      },
      onTap: (value) =>
          setState(() => _notificationEnabled = !_notificationEnabled),
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
            tr("other_label"),
            style: TextStyle(
              color: TColor.black,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
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
