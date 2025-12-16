import 'package:table_calendar/table_calendar.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:lottie/lottie.dart';
import 'package:simple_animation_progress_bar/simple_animation_progress_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/colo_extension.dart';
import '../../../cubits/sleep_calendar_cubit.dart';
import '../../../cubits/sleep_calendar_state.dart';
import '../../../cubits/sleep_schedule_cubit.dart';
import '../../../cubits/sleep_schedule_state.dart';
import '../../../app/routes.dart';
import '../../widgets/round_button.dart';
import '../../widgets/today_sleep_schedule_row.dart';
import '../../widgets/custom_modern_appbar.dart';

class SleepPlanScreen extends StatefulWidget {
  const SleepPlanScreen({super.key});

  @override
  State<SleepPlanScreen> createState() => _SleepPlanScreenState();
}

class _SleepPlanScreenState extends State<SleepPlanScreen>
    with TickerProviderStateMixin {
  late DateTime _currentSelectedDate;
  late DateTime _focusedDay;
  CalendarFormat _calendarFormat = CalendarFormat.week;
  late AnimationController _fabAnimationController;

  @override
  void initState() {
    super.initState();
    _currentSelectedDate = DateTime.now();
    _focusedDay = DateTime.now();
    _fabAnimationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    // Load initial data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SleepCalendarCubit>().loadInitialCalendarData();
      context.read<SleepScheduleCubit>().loadSleepSchedules();
    });
  }

  @override
  void dispose() {
    _fabAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: CustomModernAppBar(
        title: "Sleep Schedule",
        icon: Icons.bedtime,
        fabAnimationController: _fabAnimationController,
        primaryColor: TColor.primaryColor1,
        lightColor: TColor.primaryColor2,
        onBackPressed: () => Navigator.pop(context),
      ),
      backgroundColor: TColor.white,
      body: BlocBuilder<SleepCalendarCubit, SleepCalendarState>(
        builder: (context, calendarState) {
          if (calendarState is SleepCalendarLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (calendarState is SleepCalendarError) {
            return _buildErrorState(calendarState.message);
          }

          if (calendarState is SleepCalendarLoaded) {
            return _buildLoadedState(screenSize, calendarState);
          }

          return _buildEmptyState();
        },
      ),
      floatingActionButton: _buildAddAlarmFAB(),
    );
  }

  Widget _buildLoadedState(Size screenSize, SleepCalendarLoaded calendarState) {
    return RefreshIndicator(
      onRefresh: () => context.read<SleepCalendarCubit>().refreshCalendarData(),
      color: TColor.primaryColor1,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildIdealHoursCard(screenSize, calendarState.selectedDateData),
            SizedBox(height: screenSize.width * 0.05),
            _buildScheduleTitle(),
            _buildCalendarWidget(calendarState),
            SizedBox(height: screenSize.width * 0.03),
            _buildScheduleList(),
            _buildSleepProgressCard(screenSize, calendarState.selectedDateData),
            SizedBox(height: screenSize.width * 0.05),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(String errorMessage) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: TColor.gray),
            const SizedBox(height: 16),
            Text(
              'Error loading calendar data',
              style: TextStyle(
                color: TColor.black,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              errorMessage,
              style: TextStyle(color: TColor.gray, fontSize: 14),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            RoundButton(
              title: "Try Again",
              onPressed: () =>
                  context.read<SleepCalendarCubit>().loadInitialCalendarData(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.calendar_today_outlined, size: 64, color: TColor.gray),
            const SizedBox(height: 16),
            Text(
              'No Calendar Data',
              style: TextStyle(
                color: TColor.black,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Loading calendar data...',
              style: TextStyle(color: TColor.gray, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIdealHoursCard(Size screenSize, calendarData) {
    final totalSleepDuration = calendarData?.formattedTotalDuration ?? "0h";

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
            _buildIdealHoursContent(totalSleepDuration),
            _buildIdealHoursImage(screenSize),
          ],
        ),
      ),
    );
  }

  Widget _buildIdealHoursContent(String totalSleepDuration) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 15),
        Text(
          "Today's Sleep",
          style: TextStyle(color: TColor.black, fontSize: 14),
        ),
        Text(
          totalSleepDuration,
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
    return Lottie.asset(
      "assets/images/sleep.json",
      width: screenSize.width * 0.35,
      height: screenSize.width * 0.35,
      fit: BoxFit.contain,
      repeat: true,
      animate: true,
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

  Widget _buildCalendarWidget(SleepCalendarLoaded calendarState) {
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
          // Load data for selected date
          context.read<SleepCalendarCubit>().changeSelectedDate(selectedDay);
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
    return BlocBuilder<SleepScheduleCubit, SleepScheduleState>(
      builder: (context, scheduleState) {
        if (scheduleState is SleepScheduleLoading) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (scheduleState is SleepScheduleLoaded) {
          final activeSchedules = scheduleState.schedules
              .where((s) => s.isActive)
              .toList();

          if (activeSchedules.isEmpty) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: TColor.lightGray,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: [
                  Icon(Icons.schedule, size: 48, color: TColor.gray),
                  const SizedBox(height: 8),
                  Text(
                    "No active schedules",
                    style: TextStyle(
                      color: TColor.gray,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Add a sleep schedule to see it here",
                    style: TextStyle(color: TColor.gray, fontSize: 12),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: activeSchedules.length,
            itemBuilder: (context, index) {
              final schedule = activeSchedules[index];
              final now = DateTime.now();
              final today = DateFormat('EEEE').format(now);

              // Check if today is in repeat days
              // final isToday = schedule.repeatDays.contains(today);

              return TodaySleepScheduleRow(
                sObj: {
                  "name": "Bedtime",
                  "image": "assets/images/bedroom.json",
                  "time":
                      "${DateFormat('dd/MM/yyyy').format(now)} ${schedule.formattedBedtime}",
                  "duration": schedule.formattedSleepDuration,
                },
              );
            },
          );
        }

        if (scheduleState is SleepScheduleError) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.1),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              children: [
                Icon(Icons.error_outline, size: 48, color: Colors.red),
                const SizedBox(height: 8),
                Text(
                  "Error loading schedules",
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  scheduleState.message,
                  style: TextStyle(
                    color: Colors.red.withOpacity(0.8),
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildSleepProgressCard(Size screenSize, calendarData) {
    final hasData =
        calendarData?.totalSleepDuration != null &&
        calendarData.totalSleepDuration > 0;
    final progressRatio = hasData
        ? (calendarData.totalSleepDuration / 480).clamp(0.0, 1.0)
        : 0.0; // 480 minutes = 8 hours
    final progressPercentage = (progressRatio * 100).round();

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
          _buildProgressText(hasData, calendarData),
          const SizedBox(height: 15),
          _buildProgressBar(screenSize, progressRatio, progressPercentage),
        ],
      ),
    );
  }

  Widget _buildProgressText(bool hasData, calendarData) {
    if (!hasData) {
      return Text(
        "No sleep data for today\nAdd a sleep record to track progress",
        style: TextStyle(color: TColor.black, fontSize: 12),
      );
    }

    final duration = calendarData?.formattedTotalDuration ?? "0h";
    return Text(
      "You got $duration of sleep\nfor today",
      style: TextStyle(color: TColor.black, fontSize: 12),
    );
  }

  Widget _buildProgressBar(
    Size screenSize,
    double progressRatio,
    int progressPercentage,
  ) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SimpleAnimationProgressBar(
          height: 15,
          width: screenSize.width - 80,
          backgroundColor: Colors.grey.shade100,
          foregroundColor: Colors.purple,
          ratio: progressRatio,
          direction: Axis.horizontal,
          curve: Curves.fastLinearToSlowEaseIn,
          duration: const Duration(seconds: 2),
          borderRadius: BorderRadius.circular(7.5),
          gradientColor: LinearGradient(
            colors: TColor.secondaryG,
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        Text(
          "$progressPercentage%",
          style: TextStyle(color: TColor.black, fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildAddAlarmFAB() {
    return InkWell(
      onTap: () async {
        final result = await Navigator.pushNamed(
          context,
          Routes.addAlarmScreen,
          arguments: {'selectedDate': _currentSelectedDate},
        );

        // Refresh data if alarm was added
        if (result != null) {
          context.read<SleepCalendarCubit>().refreshCalendarData();
          context.read<SleepScheduleCubit>().loadSleepSchedules();
        }
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
