import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../common/colo_extension.dart';
import '../../widgets/round_button.dart';
import '../../widgets/today_sleep_schedule_row.dart';
import 'sleep_plan_screen.dart';

class SleepActivityScreen extends StatefulWidget {
  const SleepActivityScreen({super.key});

  @override
  State<SleepActivityScreen> createState() => _SleepActivityScreenState();
}

class _SleepActivityScreenState extends State<SleepActivityScreen> {
  final List<Map<String, dynamic>> _sleepScheduleData = [
    {
      "name": "Bedtime",
      "image": "assets/img/bed.png",
      "time": "01/06/2023 09:00 PM",
      "duration": "in 6hours 22minutes",
    },
    {
      "name": "Alarm",
      "image": "assets/img/alaarm.png",
      "time": "02/06/2023 05:10 AM",
      "duration": "in 14hours 30minutes",
    },
  ];

  List<int> _activeTooltipSpots = [4];

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    final chartBarData = _getChartData()[0];

    return Scaffold(
      appBar: _buildAppBar(),
      backgroundColor: TColor.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSleepChart(screenSize, chartBarData),
                  SizedBox(height: screenSize.width * 0.05),
                  _buildLastNightSleepCard(screenSize),
                  SizedBox(height: screenSize.width * 0.05),
                  _buildDailySleepScheduleCard(),
                  SizedBox(height: screenSize.width * 0.05),
                  _buildTodayScheduleSection(screenSize),
                ],
              ),
            ),
            SizedBox(height: screenSize.width * 0.05),
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
            "assets/img/black_btn.png",
            width: 15,
            height: 15,
            fit: BoxFit.contain,
          ),
        ),
      ),
      title: Text(
        "Sleep Tracker",
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

  Widget _buildSleepChart(Size screenSize, LineChartBarData chartBarData) {
    return Container(
      padding: const EdgeInsets.only(left: 15),
      height: screenSize.width * 0.5,
      width: double.maxFinite,
      child: LineChart(
        LineChartData(
          showingTooltipIndicators: _activeTooltipSpots.map((index) {
            return ShowingTooltipIndicators([
              LineBarSpot(
                chartBarData,
                _getChartData().indexOf(chartBarData),
                chartBarData.spots[index],
              ),
            ]);
          }).toList(),
          lineTouchData: _buildLineTouchData(),
          lineBarsData: _getChartData(),
          minY: -0.01,
          maxY: 10.01,
          titlesData: FlTitlesData(
            show: true,
            leftTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(sideTitles: _getBottomTitles()),
            rightTitles: AxisTitles(sideTitles: _getRightTitles()),
          ),
          gridData: _buildGridData(),
          borderData: FlBorderData(
            show: true,
            border: Border.all(color: Colors.transparent),
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
        if (event is FlTapUpEvent) {
          final spotIndex = response.lineBarSpots!.first.spotIndex;
          _activeTooltipSpots.clear();
          setState(() {
            _activeTooltipSpots.add(spotIndex);
          });
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
                        strokeWidth: 1,
                        strokeColor: TColor.primaryColor2,
                      ),
                ),
              );
            }).toList();
          },
      touchTooltipData: LineTouchTooltipData(
        getTooltipColor: (touchedSpot) => TColor.secondaryColor1,
        tooltipBorder: BorderSide(color: Colors.transparent),
        getTooltipItems: (List<LineBarSpot> lineBarsSpot) {
          return lineBarsSpot.map((lineBarSpot) {
            return LineTooltipItem(
              "${lineBarSpot.y.toInt()} hours",
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

  FlGridData _buildGridData() {
    return FlGridData(
      show: true,
      drawHorizontalLine: true,
      horizontalInterval: 2,
      drawVerticalLine: false,
      getDrawingHorizontalLine: (value) {
        return FlLine(color: TColor.gray.withOpacity(0.15), strokeWidth: 2);
      },
    );
  }

  Widget _buildLastNightSleepCard(Size screenSize) {
    return Container(
      width: double.maxFinite,
      height: screenSize.width * 0.4,
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: TColor.primaryG),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Text(
              "Last Night Sleep",
              style: TextStyle(color: TColor.white, fontSize: 14),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Text(
              "8h 20m",
              style: TextStyle(
                color: TColor.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const Spacer(),
          Image.asset("assets/img/SleepGraph.png", width: double.maxFinite),
        ],
      ),
    );
  }

  Widget _buildDailySleepScheduleCard() {
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
            "Daily Sleep Schedule",
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
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SleepPlanScreen(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTodayScheduleSection(Size screenSize) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Today Schedule",
          style: TextStyle(
            color: TColor.black,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: screenSize.width * 0.03),
        ListView.builder(
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: _sleepScheduleData.length,
          itemBuilder: (context, index) {
            var scheduleItem = _sleepScheduleData[index];
            return TodaySleepScheduleRow(sObj: scheduleItem);
          },
        ),
      ],
    );
  }

  List<LineChartBarData> _getChartData() => [_getPrimaryLineData()];

  LineChartBarData _getPrimaryLineData() => LineChartBarData(
    isCurved: true,
    gradient: LinearGradient(
      colors: [TColor.primaryColor2, TColor.primaryColor1],
    ),
    barWidth: 2,
    isStrokeCapRound: true,
    dotData: FlDotData(show: false),
    belowBarData: BarAreaData(
      show: true,
      gradient: LinearGradient(
        colors: [TColor.primaryColor2, TColor.white],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
    ),
    spots: const [
      FlSpot(1, 3),
      FlSpot(2, 5),
      FlSpot(3, 4),
      FlSpot(4, 7),
      FlSpot(5, 4),
      FlSpot(6, 8),
      FlSpot(7, 5),
    ],
  );

  SideTitles _getRightTitles() => SideTitles(
    getTitlesWidget: _buildRightTitleWidgets,
    showTitles: true,
    interval: 2,
    reservedSize: 40,
  );

  Widget _buildRightTitleWidgets(double value, TitleMeta meta) {
    String text;
    switch (value.toInt()) {
      case 0:
        text = '0h';
        break;
      case 2:
        text = '2h';
        break;
      case 4:
        text = '4h';
        break;
      case 6:
        text = '6h';
        break;
      case 8:
        text = '8h';
        break;
      case 10:
        text = '10h';
        break;
      default:
        return Container();
    }

    return Text(
      text,
      style: TextStyle(color: TColor.gray, fontSize: 12),
      textAlign: TextAlign.center,
    );
  }

  SideTitles _getBottomTitles() => SideTitles(
    showTitles: true,
    reservedSize: 32,
    interval: 1,
    getTitlesWidget: _buildBottomTitleWidgets,
  );

  Widget _buildBottomTitleWidgets(double value, TitleMeta meta) {
    var textStyle = TextStyle(color: TColor.gray, fontSize: 12);
    Widget text;
    switch (value.toInt()) {
      case 1:
        text = Text('Sun', style: textStyle);
        break;
      case 2:
        text = Text('Mon', style: textStyle);
        break;
      case 3:
        text = Text('Tue', style: textStyle);
        break;
      case 4:
        text = Text('Wed', style: textStyle);
        break;
      case 5:
        text = Text('Thu', style: textStyle);
        break;
      case 6:
        text = Text('Fri', style: textStyle);
        break;
      case 7:
        text = Text('Sat', style: textStyle);
        break;
      default:
        text = const Text('');
        break;
    }

    return SideTitleWidget(meta: meta, child: text);
  }
}
