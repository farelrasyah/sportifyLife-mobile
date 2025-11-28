import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../common/colo_extension.dart';
import '../../widgets/find_eat_cell.dart';
import '../../widgets/round_button.dart';
import '../../widgets/today_meal_row.dart';
import 'meal_detail_screen.dart';
import 'meal_schedule_screen.dart';

class MealOrganizerScreen extends StatefulWidget {
  const MealOrganizerScreen({super.key});

  @override
  State<MealOrganizerScreen> createState() => _MealOrganizerScreenState();
}

class _MealOrganizerScreenState extends State<MealOrganizerScreen> {
  final List<Map<String, String>> dailyMeals = [
    {
      "name": "Salmon Nigiri",
      "image": "assets/images/m_1.png",
      "time": "28/05/2023 07:00 AM",
    },
    {
      "name": "Lowfat Milk",
      "image": "assets/images/m_2.png",
      "time": "28/05/2023 08:00 AM",
    },
  ];

  final List<Map<String, String>> mealOptions = [
    {
      "name": "Breakfast",
      "image": "assets/images/m_3.png",
      "number": "120+ Foods",
    },
    {"name": "Lunch", "image": "assets/images/m_4.png", "number": "130+ Foods"},
  ];

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

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
                  _buildNutritionChartSection(screenSize),
                  SizedBox(height: screenSize.width * 0.05),
                  _buildSchedulePromptSection(),
                  SizedBox(height: screenSize.width * 0.05),
                  _buildTodayMealsSection(screenSize),
                  SizedBox(height: screenSize.width * 0.05),
                ],
              ),
            ),
            _buildMealDiscoverySection(screenSize),
            SizedBox(height: screenSize.width * 0.05),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: TColor.white,
      centerTitle: true,
      elevation: 0,
      leading: _buildAppBarButton(
        "assets/images/black_btn.png",
        () => Navigator.pop(context),
      ),
      title: Text(
        "Meal Planner",
        style: TextStyle(
          color: TColor.black,
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
      ),
      actions: [_buildAppBarButton("assets/images/more_btn.png", () {})],
    );
  }

  Widget _buildAppBarButton(String iconPath, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
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
          iconPath,
          width: 15,
          height: 15,
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  Widget _buildNutritionChartSection(Size screenSize) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Meal Nutritions",
              style: TextStyle(
                color: TColor.black,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            _buildTimeRangeDropdown(),
          ],
        ),
        SizedBox(height: screenSize.width * 0.05),
        _buildNutritionChart(screenSize),
      ],
    );
  }

  Widget _buildTimeRangeDropdown() {
    return Container(
      height: 30,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: TColor.primaryG),
        borderRadius: BorderRadius.circular(15),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton(
          items: ["Weekly", "Monthly"]
              .map(
                (period) => DropdownMenuItem(
                  value: period,
                  child: Text(
                    period,
                    style: TextStyle(color: TColor.gray, fontSize: 14),
                  ),
                ),
              )
              .toList(),
          onChanged: (value) {},
          icon: Icon(Icons.expand_more, color: TColor.white),
          hint: Text(
            "Weekly",
            textAlign: TextAlign.center,
            style: TextStyle(color: TColor.white, fontSize: 12),
          ),
        ),
      ),
    );
  }

  Widget _buildNutritionChart(Size screenSize) {
    return Container(
      padding: const EdgeInsets.only(left: 15),
      height: screenSize.width * 0.5,
      width: double.maxFinite,
      child: LineChart(
        LineChartData(
          lineTouchData: LineTouchData(
            enabled: true,
            handleBuiltInTouches: false,
            touchCallback: (FlTouchEvent event, LineTouchResponse? response) {},
            mouseCursorResolver:
                (FlTouchEvent event, LineTouchResponse? response) {
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
              tooltipBorder: BorderSide(
                color: TColor.secondaryColor1,
                width: 1,
              ),
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
          ),
          lineBarsData: _buildChartData(),
          minY: -0.5,
          maxY: 110,
          titlesData: FlTitlesData(
            show: true,
            leftTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(sideTitles: _buildBottomTitles()),
            rightTitles: AxisTitles(sideTitles: _buildRightTitles()),
          ),
          gridData: FlGridData(
            show: true,
            drawHorizontalLine: true,
            horizontalInterval: 25,
            drawVerticalLine: false,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: TColor.gray.withOpacity(0.15),
                strokeWidth: 2,
              );
            },
          ),
          borderData: FlBorderData(
            show: true,
            border: Border.all(color: Colors.transparent),
          ),
        ),
      ),
    );
  }

  List<LineChartBarData> _buildChartData() {
    return [
      LineChartBarData(
        isCurved: true,
        gradient: LinearGradient(
          colors: [TColor.primaryColor2, TColor.primaryColor1],
        ),
        barWidth: 2,
        isStrokeCapRound: true,
        dotData: FlDotData(
          show: true,
          getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
            radius: 3,
            color: Colors.white,
            strokeWidth: 1,
            strokeColor: TColor.primaryColor2,
          ),
        ),
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
      ),
    ];
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
      style: TextStyle(color: TColor.gray, fontSize: 12),
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
    final style = TextStyle(color: TColor.gray, fontSize: 12);
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

  Widget _buildSchedulePromptSection() {
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
            "Daily Meal Schedule",
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
                    builder: (context) => const MealScheduleScreen(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTodayMealsSection(Size screenSize) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Today Meals",
              style: TextStyle(
                color: TColor.black,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            _buildMealTypeDropdown(),
          ],
        ),
        SizedBox(height: screenSize.width * 0.05),
        ListView.builder(
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: dailyMeals.length,
          itemBuilder: (context, index) {
            final mealData = dailyMeals[index];
            return TodayMealRow(mObj: mealData);
          },
        ),
      ],
    );
  }

  Widget _buildMealTypeDropdown() {
    return Container(
      height: 30,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: TColor.primaryG),
        borderRadius: BorderRadius.circular(15),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton(
          items: ["Breakfast", "Lunch", "Dinner", "Snack", "Dessert"]
              .map(
                (mealType) => DropdownMenuItem(
                  value: mealType,
                  child: Text(
                    mealType,
                    style: TextStyle(color: TColor.gray, fontSize: 14),
                  ),
                ),
              )
              .toList(),
          onChanged: (value) {},
          icon: Icon(Icons.expand_more, color: TColor.white),
          hint: Text(
            "Breakfast",
            textAlign: TextAlign.center,
            style: TextStyle(color: TColor.white, fontSize: 12),
          ),
        ),
      ),
    );
  }

  Widget _buildMealDiscoverySection(Size screenSize) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Text(
            "Find Something to Eat",
            style: TextStyle(
              color: TColor.black,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        SizedBox(
          height: screenSize.width * 0.55,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            scrollDirection: Axis.horizontal,
            itemCount: mealOptions.length,
            itemBuilder: (context, index) {
              final mealOption = mealOptions[index];
              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          MealDetailScreen(mealCategory: mealOption),
                    ),
                  );
                },
                child: FindEatCell(fObj: mealOption, index: index),
              );
            },
          ),
        ),
      ],
    );
  }
}
