import 'package:table_calendar/table_calendar.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:simple_animation_progress_bar/simple_animation_progress_bar.dart';

import '../../../common/colo_extension.dart';
import '../../widgets/round_button.dart';
import '../../widgets/today_sleep_schedule_row.dart';
import 'add_alarm_screen.dart';

class SleepPlanScreen extends StatefulWidget {
  const SleepPlanScreen({super.key});

  @override
  State<SleepPlanScreen> createState() => _SleepPlanScreenState();
}

class _SleepPlanScreenState extends State<SleepPlanScreen> {
  late DateTime _currentSelectedDate;
  late DateTime _focusedDay;
  CalendarFormat _calendarFormat = CalendarFormat.week;

  final List<Map<String, dynamic>> _dailySleepSchedule = [
    {
      "name": "Bedtime",
      "image": "assets/images/bed.png",
      "time": "01/06/2023 09:00 PM",
      "duration": "in 6hours 22minutes",
    },
    {
      "name": "Alarm",
      "image": "assets/images/alaarm.png",
      "time": "02/06/2023 05:10 AM",
      "duration": "in 14hours 30minutes",
    },
  ];

  @override
  void initState() {
    super.initState();
    _currentSelectedDate = DateTime.now();
    _focusedDay = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: _buildAppBar(),
      backgroundColor: TColor.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildIdealHoursCard(screenSize),
                SizedBox(height: screenSize.width * 0.05),
                _buildScheduleTitle(),
                _buildCalendarWidget(),
                SizedBox(height: screenSize.width * 0.03),
                _buildScheduleList(),
                _buildSleepProgressCard(screenSize),
              ],
            ),
            SizedBox(height: screenSize.width * 0.05),
          ],
        ),
      ),
      floatingActionButton: _buildAddAlarmFAB(),
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
            "assets/images/black_btn.png",
            width: 15,
            height: 15,
            fit: BoxFit.contain,
          ),
        ),
      ),
      title: Text(
        "Sleep Schedule",
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

  Widget _buildIdealHoursCard(Size screenSize) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Container(
        width: double.maxFinite,
        padding: const EdgeInsets.all(20),
        height: screenSize.width * 0.4,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              TColor.primaryColor2.withOpacity(0.4),
              TColor.primaryColor1.withOpacity(0.4),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildIdealHoursContent(),
            _buildIdealHoursImage(screenSize),
          ],
        ),
      ),
    );
  }

  Widget _buildIdealHoursContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 15),
        Text(
          "Ideal Hours for Sleep",
          style: TextStyle(color: TColor.black, fontSize: 14),
        ),
        Text(
          "8hours 30minutes",
          style: TextStyle(
            color: TColor.primaryColor2,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const Spacer(),
        SizedBox(
          width: 110,
          height: 35,
          child: RoundButton(
            title: "Learn More",
            fontSize: 12,
            onPressed: () {},
          ),
        ),
      ],
    );
  }

  Widget _buildIdealHoursImage(Size screenSize) {
    return Image.asset(
      "assets/images/sleep_schedule.png",
      width: screenSize.width * 0.35,
    );
  }

  Widget _buildScheduleTitle() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Text(
        "Your Schedule",
        style: TextStyle(
          color: TColor.black,
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildCalendarWidget() {
    return Container(
      decoration: BoxDecoration(
        color: TColor.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TableCalendar(
        firstDay: DateTime.now().subtract(const Duration(days: 365)),
        lastDay: DateTime.now().add(const Duration(days: 365)),
        focusedDay: _focusedDay,
        calendarFormat: _calendarFormat,
        selectedDayPredicate: (day) {
          return isSameDay(_currentSelectedDate, day);
        },
        onDaySelected: (selectedDay, focused) {
          setState(() {
            _currentSelectedDate = selectedDay;
            _focusedDay = focused;
          });
        },
        onFormatChanged: (format) {
          if (_calendarFormat != format) {
            setState(() {
              _calendarFormat = format;
            });
          }
        },
        onPageChanged: (focused) {
          _focusedDay = focused;
        },
        calendarStyle: CalendarStyle(
          todayDecoration: BoxDecoration(
            color: TColor.primaryColor2.withOpacity(0.3),
            shape: BoxShape.circle,
          ),
          selectedDecoration: BoxDecoration(
            gradient: LinearGradient(
              colors: TColor.primaryG,
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            shape: BoxShape.circle,
          ),
          selectedTextStyle: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          todayTextStyle: TextStyle(
            color: TColor.primaryColor1,
            fontWeight: FontWeight.bold,
          ),
          defaultTextStyle: const TextStyle(color: Colors.black),
          weekendTextStyle: TextStyle(color: TColor.primaryColor2),
        ),
        headerStyle: HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
          titleTextStyle: TextStyle(
            color: TColor.black,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
          leftChevronIcon: Icon(
            Icons.chevron_left,
            color: TColor.primaryColor1,
          ),
          rightChevronIcon: Icon(
            Icons.chevron_right,
            color: TColor.primaryColor1,
          ),
        ),
        daysOfWeekStyle: DaysOfWeekStyle(
          weekdayStyle: TextStyle(color: TColor.gray, fontSize: 12),
          weekendStyle: TextStyle(color: TColor.primaryColor2, fontSize: 12),
        ),
      ),
    );
  }

  Widget _buildScheduleList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: _dailySleepSchedule.length,
      itemBuilder: (context, index) {
        var scheduleItem = _dailySleepSchedule[index];
        return TodaySleepScheduleRow(sObj: scheduleItem);
      },
    );
  }

  Widget _buildSleepProgressCard(Size screenSize) {
    return Container(
      width: double.maxFinite,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            TColor.secondaryColor2.withOpacity(0.4),
            TColor.secondaryColor1.withOpacity(0.4),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildProgressText(),
          const SizedBox(height: 15),
          _buildProgressBar(screenSize),
        ],
      ),
    );
  }

  Widget _buildProgressText() {
    return Text(
      "You will get 8hours 10minutes\nfor tonight",
      style: TextStyle(color: TColor.black, fontSize: 12),
    );
  }

  Widget _buildProgressBar(Size screenSize) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SimpleAnimationProgressBar(
          height: 15,
          width: screenSize.width - 80,
          backgroundColor: Colors.grey.shade100,
          foregroundColor: Colors.purple,
          ratio: 0.96,
          direction: Axis.horizontal,
          curve: Curves.fastLinearToSlowEaseIn,
          duration: const Duration(seconds: 3),
          borderRadius: BorderRadius.circular(7.5),
          gradientColor: LinearGradient(
            colors: TColor.secondaryG,
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        Text("96%", style: TextStyle(color: TColor.black, fontSize: 12)),
      ],
    );
  }

  Widget _buildAddAlarmFAB() {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                AddAlarmScreen(selectedDate: _currentSelectedDate),
          ),
        );
      },
      child: Container(
        width: 55,
        height: 55,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: TColor.secondaryG),
          borderRadius: BorderRadius.circular(27.5),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 5,
              offset: Offset(0, 2),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Icon(Icons.add, size: 20, color: TColor.white),
      ),
    );
  }
}
