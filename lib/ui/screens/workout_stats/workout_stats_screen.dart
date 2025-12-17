import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../common/colo_extension.dart';
import '../../widgets/round_button.dart';
import '../../widgets/upcoming_workout_row.dart';
import '../../widgets/what_train_row.dart';
import '../../widgets/custom_modern_appbar.dart';
import 'workout_detail_screen.dart';

class WorkoutStatsScreen extends StatefulWidget {
  const WorkoutStatsScreen({super.key});

  @override
  State<WorkoutStatsScreen> createState() => _WorkoutStatsScreenState();
}

class _WorkoutStatsScreenState extends State<WorkoutStatsScreen>
    with TickerProviderStateMixin {
  late AnimationController _fabAnimationController;

  @override
  void initState() {
    super.initState();
    _fabAnimationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _fabAnimationController.dispose();
    super.dispose();
  }

  final List<Map<String, String>> _recentWorkouts = [
    {
      "image": "assets/images/jumping_jack.json",
      "title": "Fullbody Workout",
      "time": "Today, 03:00pm",
    },
    {
      "image": "assets/images/exercise.json",
      "title": "Upperbody Workout",
      "time": "June 05, 02:00pm",
    },
  ];

  final List<Map<String, String>> _workoutCategories = [
    {
      "image": "assets/images/jumping_jack.json",
      "title": "Fullbody Workout",
      "exercises": "11 Exercises",
      "time": "32mins",
    },
    {
      "image": "assets/images/split_jump.json",
      "title": "Lowebody Workout",
      "exercises": "12 Exercises",
      "time": "40mins",
    },
    {
      "image": "assets/images/meditating.json",
      "title": "AB Workout",
      "exercises": "14 Exercises",
      "time": "20mins",
    },
  ];

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: TColor.white,
      appBar: CustomModernAppBar(
        title: "Workout Stats",
        icon: Icons.bar_chart,
        fabAnimationController: _fabAnimationController,
        onBackPressed: () => Navigator.pop(context),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: TColor.primaryG),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Chart section
              Container(
                width: screenSize.width,
                height: screenSize.width * 0.8,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 20,
                ),
                child: _buildChart(),
              ),
              // Content section
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: TColor.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                  ),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    _buildDragHandle(),
                    SizedBox(height: screenSize.width * 0.05),
                    _buildDailyScheduleCard(),
                    SizedBox(height: screenSize.width * 0.05),
                    _buildUpcomingWorkoutsSection(),
                    SizedBox(height: screenSize.width * 0.05),
                    _buildWorkoutCategoriesSection(),
                    SizedBox(height: screenSize.width * 0.1),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  LineTouchData _buildLineTouchData() {
    return LineTouchData(
      enabled: true,
      handleBuiltInTouches: false,
      touchCallback: (FlTouchEvent event, LineTouchResponse? response) {
        if (response == null || response.lineBarSpots == null) {
          return;
        }
      },
      mouseCursorResolver: (FlTouchEvent event, LineTouchResponse? response) {
        if (response == null || response.lineBarSpots == null) {
          return SystemMouseCursors.basic;
        }
        return SystemMouseCursors.click;
      },
      getTouchedSpotIndicator:
          (LineChartBarData barData, List<int> spotIndexes) {
            return spotIndexes.map((index) {
              return TouchedSpotIndicatorData(
                FlLine(color: Colors.transparent),
                FlDotData(
                  show: true,
                  getDotPainter: (spot, percent, barData, index) =>
                      FlDotCirclePainter(
                        radius: 3,
                        color: Colors.white,
                        strokeWidth: 3,
                        strokeColor: TColor.secondaryColor1,
                      ),
                ),
              );
            }).toList();
          },
      touchTooltipData: LineTouchTooltipData(
        getTooltipColor: (touchedSpot) => TColor.secondaryColor1,
        tooltipBorder: BorderSide.none,
        getTooltipItems: (List<LineBarSpot> lineBarsSpot) {
          return lineBarsSpot.map((lineBarSpot) {
            return LineTooltipItem(
              "${lineBarSpot.x.toInt()} mins ago",
              const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            );
          }).toList();
        },
      ),
    );
  }

  List<LineChartBarData> _buildLineChartData() {
    return [_buildPrimaryLineData(), _buildSecondaryLineData()];
  }

  LineChartBarData _buildPrimaryLineData() {
    return LineChartBarData(
      isCurved: true,
      color: TColor.white,
      barWidth: 4,
      isStrokeCapRound: true,
      dotData: FlDotData(show: false),
      belowBarData: BarAreaData(show: false),
      spots: const [
        FlSpot(1, 35),
        FlSpot(2, 70),
        FlSpot(3, 40),
        FlSpot(4, 80),
        FlSpot(5, 25),
        FlSpot(6, 70),
        FlSpot(7, 35),
      ],
    );
  }

  LineChartBarData _buildSecondaryLineData() {
    return LineChartBarData(
      isCurved: true,
      color: TColor.white.withOpacity(0.5),
      barWidth: 2,
      isStrokeCapRound: true,
      dotData: FlDotData(show: false),
      belowBarData: BarAreaData(show: false),
      spots: const [
        FlSpot(1, 80),
        FlSpot(2, 50),
        FlSpot(3, 90),
        FlSpot(4, 40),
        FlSpot(5, 80),
        FlSpot(6, 35),
        FlSpot(7, 60),
      ],
    );
  }

  FlTitlesData _buildTitlesData() {
    return FlTitlesData(
      show: true,
      leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      bottomTitles: AxisTitles(sideTitles: _buildBottomTitles()),
      rightTitles: AxisTitles(sideTitles: _buildRightTitles()),
    );
  }

  SideTitles _buildRightTitles() {
    return SideTitles(
      getTitlesWidget: _buildRightTitleWidgets,
      showTitles: true,
      interval: 20,
      reservedSize: 40,
    );
  }

  Widget _buildRightTitleWidgets(double value, TitleMeta meta) {
    String text;
    switch (value.toInt()) {
      case 0:
        text = '0%';
        break;
      case 20:
        text = '20%';
        break;
      case 40:
        text = '40%';
        break;
      case 60:
        text = '60%';
        break;
      case 80:
        text = '80%';
        break;
      case 100:
        text = '100%';
        break;
      default:
        return Container();
    }

    return Text(
      text,
      style: TextStyle(color: TColor.white, fontSize: 12),
      textAlign: TextAlign.center,
    );
  }

  SideTitles _buildBottomTitles() {
    return SideTitles(
      showTitles: true,
      reservedSize: 32,
      interval: 1,
      getTitlesWidget: _buildBottomTitleWidgets,
    );
  }

  Widget _buildBottomTitleWidgets(double value, TitleMeta meta) {
    var style = TextStyle(color: TColor.white, fontSize: 12);
    Widget text;
    switch (value.toInt()) {
      case 1:
        text = Text('Sun', style: style);
        break;
      case 2:
        text = Text('Mon', style: style);
        break;
      case 3:
        text = Text('Tue', style: style);
        break;
      case 4:
        text = Text('Wed', style: style);
        break;
      case 5:
        text = Text('Thu', style: style);
        break;
      case 6:
        text = Text('Fri', style: style);
        break;
      case 7:
        text = Text('Sat', style: style);
        break;
      default:
        text = const Text('');
        break;
    }

    return SideTitleWidget(meta: meta, child: text);
  }

  FlGridData _buildGridData() {
    return FlGridData(
      show: true,
      drawHorizontalLine: true,
      horizontalInterval: 25,
      drawVerticalLine: false,
      getDrawingHorizontalLine: (value) {
        return FlLine(color: TColor.white.withOpacity(0.15), strokeWidth: 2);
      },
    );
  }

  FlBorderData _buildBorderData() {
    return FlBorderData(
      show: true,
      border: Border.all(color: Colors.transparent),
    );
  }

  Widget _buildChart() {
    return LineChart(
      LineChartData(
        lineTouchData: _buildLineTouchData(),
        gridData: _buildGridData(),
        titlesData: _buildTitlesData(),
        borderData: _buildBorderData(),
        lineBarsData: _buildLineChartData(),
        minX: 0,
        maxX: 8,
        minY: 0,
        maxY: 105,
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

  Widget _buildDailyScheduleCard() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
      decoration: BoxDecoration(
        color: TColor.primaryColor2.withOpacity(0.3),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Daily Workout Schedule",
            style: TextStyle(
              color: TColor.black,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(
            width: 70,
            height: 25,
            child: RoundButton(
              title: "Check",
              type: RoundButtonType.bgGradient,
              fontSize: 12,
              fontWeight: FontWeight.w400,
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUpcomingWorkoutsSection() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Upcoming Workout",
              style: TextStyle(
                color: TColor.black,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            TextButton(
              onPressed: () {},
              child: Text(
                "See More",
                style: TextStyle(
                  color: TColor.gray,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        ListView.builder(
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: _recentWorkouts.length,
          itemBuilder: (context, index) {
            var workoutData = _recentWorkouts[index];
            return UpcomingWorkoutRow(wObj: workoutData);
          },
        ),
      ],
    );
  }

  Widget _buildWorkoutCategoriesSection() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "What Do You Want to Train",
              style: TextStyle(
                color: TColor.black,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        ListView.builder(
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: _workoutCategories.length,
          itemBuilder: (context, index) {
            var workoutData = _workoutCategories[index];
            return InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        WorkoutDetailScreen(workoutData: workoutData),
                  ),
                );
              },
              child: WhatTrainRow(wObj: workoutData),
            );
          },
        ),
      ],
    );
  }
}
