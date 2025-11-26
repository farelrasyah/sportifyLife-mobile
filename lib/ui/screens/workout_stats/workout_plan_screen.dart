import 'package:table_calendar/table_calendar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../common/colo_extension.dart';
import '../../../common/common.dart';
import '../../widgets/round_button.dart';
import 'add_workout_plan_screen.dart';

class WorkoutPlanScreen extends StatefulWidget {
  const WorkoutPlanScreen({super.key});

  @override
  State<WorkoutPlanScreen> createState() => _WorkoutPlanScreenState();
}

class _WorkoutPlanScreenState extends State<WorkoutPlanScreen> {
  late DateTime _selectedDate;
  late DateTime _focusedDay;
  CalendarFormat _calendarFormat = CalendarFormat.week;

  final List<Map<String, String>> _workoutEvents = [
    {"name": "Ab Workout", "start_time": "25/05/2023 07:30 AM"},
    {"name": "Upperbody Workout", "start_time": "25/05/2023 09:00 AM"},
    {"name": "Lowerbody Workout", "start_time": "25/05/2023 03:00 PM"},
    {"name": "Ab Workout", "start_time": "26/05/2023 07:30 AM"},
    {"name": "Upperbody Workout", "start_time": "26/05/2023 09:00 AM"},
    {"name": "Lowerbody Workout", "start_time": "26/05/2023 03:00 PM"},
    {"name": "Ab Workout", "start_time": "27/05/2023 07:30 AM"},
    {"name": "Upperbody Workout", "start_time": "27/05/2023 09:00 AM"},
    {"name": "Lowerbody Workout", "start_time": "27/05/2023 03:00 PM"},
  ];

  List<Map<String, dynamic>> _selectedDayEvents = [];

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _focusedDay = DateTime.now();
    _updateSelectedDayEvents();
  }

  void _updateSelectedDayEvents() {
    var selectedDateStart = dateToStartDate(_selectedDate);
    _selectedDayEvents = _workoutEvents
        .map((eventObj) {
          return {
            "name": eventObj["name"],
            "start_time": eventObj["start_time"],
            "date": stringToDate(
              eventObj["start_time"].toString(),
              formatStr: "dd/MM/yyyy hh:mm aa",
            ),
          };
        })
        .where((eventObj) {
          return dateToStartDate(eventObj["date"] as DateTime) ==
              selectedDateStart;
        })
        .toList();

    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: _buildAppBar(),
      backgroundColor: TColor.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [_buildCalendarSection(), _buildScheduleTimeline(screenSize)],
      ),
      floatingActionButton: _buildAddScheduleFAB(),
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
            "assets/img/black_btn.png",
            width: 15,
            height: 15,
            fit: BoxFit.contain,
          ),
        ),
      ),
      title: Text(
        "Workout Schedule",
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

  Widget _buildCalendarSection() {
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
          return isSameDay(_selectedDate, day);
        },
        onDaySelected: (selectedDay, focused) {
          setState(() {
            _selectedDate = selectedDay;
            _focusedDay = focused;
            _updateSelectedDayEvents();
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

  Widget _buildScheduleTimeline(Size screenSize) {
    return Expanded(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SizedBox(
          width: screenSize.width * 1.5,
          child: ListView.separated(
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return _buildTimelineRow(index, screenSize);
            },
            separatorBuilder: (context, index) {
              return Divider(color: TColor.gray.withOpacity(0.2), height: 1);
            },
            itemCount: 24,
          ),
        ),
      ),
    );
  }

  Widget _buildTimelineRow(int hourIndex, Size screenSize) {
    var availableWidth = (screenSize.width * 1.2) - (80 + 40);
    var eventsAtThisHour = _selectedDayEvents.where((eventObj) {
      return (eventObj["date"] as DateTime).hour == hourIndex;
    }).toList();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              getTime(hourIndex * 60),
              style: TextStyle(color: TColor.black, fontSize: 12),
            ),
          ),
          if (eventsAtThisHour.isNotEmpty)
            Expanded(
              child: Stack(
                alignment: Alignment.centerLeft,
                children: eventsAtThisHour.map((eventObj) {
                  var minutes = (eventObj["date"] as DateTime).minute;
                  var position = (minutes / 60) * 2 - 1;

                  return Align(
                    alignment: Alignment(position, 0),
                    child: _buildEventCard(eventObj, availableWidth),
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildEventCard(Map<String, dynamic> eventObj, double availableWidth) {
    return InkWell(
      onTap: () {
        _showEventDialog(eventObj);
      },
      child: Container(
        height: 35,
        width: availableWidth * 0.5,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: TColor.secondaryG),
          borderRadius: BorderRadius.circular(17.5),
        ),
        child: Text(
          "${eventObj["name"].toString()}, ${getStringDateToOtherFormate(eventObj["start_time"].toString(), outFormatStr: "h:mm aa")}",
          maxLines: 1,
          style: TextStyle(color: TColor.white, fontSize: 12),
        ),
      ),
    );
  }

  void _showEventDialog(Map<String, dynamic> eventObj) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          contentPadding: EdgeInsets.zero,
          content: Container(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            decoration: BoxDecoration(
              color: TColor.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDialogHeader(),
                const SizedBox(height: 15),
                _buildDialogContent(eventObj),
                const SizedBox(height: 15),
                _buildMarkDoneButton(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDialogHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InkWell(
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
        Text(
          "Workout Schedule",
          style: TextStyle(
            color: TColor.black,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
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

  Widget _buildDialogContent(Map<String, dynamic> eventObj) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          eventObj["name"].toString(),
          style: TextStyle(
            color: TColor.black,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Image.asset("assets/img/time_workout.png", height: 20, width: 20),
            const SizedBox(width: 8),
            Text(
              "${getDayTitle(eventObj["start_time"].toString())}|${getStringDateToOtherFormate(eventObj["start_time"].toString(), outFormatStr: "h:mm aa")}",
              style: TextStyle(color: TColor.gray, fontSize: 12),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMarkDoneButton() {
    return RoundButton(title: "Mark Done", onPressed: () {});
  }

  Widget _buildAddScheduleFAB() {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                AddWorkoutPlanScreen(selectedDate: _selectedDate),
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
