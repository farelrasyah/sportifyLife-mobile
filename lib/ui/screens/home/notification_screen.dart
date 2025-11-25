import 'package:flutter/material.dart';

import '../../../common/colo_extension.dart';
import '../../../common_widget/notification_row.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final List<Map<String, String>> _notifications = [
    {
      "image": "assets/images/moveSet_1.png",
      "title": "Hey, it's time for lunch",
      "time": "About 1 minutes ago",
    },
    {
      "image": "assets/images/moveSet_2.png",
      "title": "Don't miss your lowerbody workout",
      "time": "About 3 hours ago",
    },
    {
      "image": "assets/images/moveSet_3.png",
      "title": "Hey, let's add some meals for your b",
      "time": "About 3 hours ago",
    },
    {
      "image": "assets/images/moveSet_1.png",
      "title": "Congratulations, You have finished A..",
      "time": "29 May",
    },
    {
      "image": "assets/images/moveSet_2.png",
      "title": "Hey, it's time for lunch",
      "time": "8 April",
    },
    {
      "image": "assets/images/moveSet_3.png",
      "title": "Ups, You have missed your Lowerbo...",
      "time": "8 April",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      backgroundColor: TColor.white,
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
        itemCount: _notifications.length,
        itemBuilder: (context, index) {
          return NotificationRow(notification: _notifications[index]);
        },
        separatorBuilder: (context, index) {
          return Divider(color: TColor.gray.withOpacity(0.5), height: 1);
        },
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: TColor.white,
      centerTitle: true,
      elevation: 0,
      leading: _buildBackButton(),
      title: Text(
        "Notification",
        style: TextStyle(
          color: TColor.black,
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
      ),
      actions: [_buildMoreButton()],
    );
  }

  Widget _buildBackButton() {
    return InkWell(
      onTap: () => Navigator.pop(context),
      child: Container(
        margin: const EdgeInsets.all(8),
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
    );
  }

  Widget _buildMoreButton() {
    return InkWell(
      onTap: () {},
      child: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: TColor.lightGray,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Image.asset(
          "assets/images/elips_btn.png",
          width: 12,
          height: 12,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
