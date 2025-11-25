import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../common/colo_extension.dart';
import '../../widgets/latest_activity_row.dart';
import '../../widgets/today_target_cell.dart';

class FitnessTrackerScreen extends StatefulWidget {
  const FitnessTrackerScreen({super.key});

  @override
  State<FitnessTrackerScreen> createState() => _FitnessTrackerScreenState();
}

class _FitnessTrackerScreenState extends State<FitnessTrackerScreen> {
  int _touchedBarIndex = -1;
  String _selectedPeriod = "Weekly";

  final List<Map<String, String>> _latestActivities = [
    {
      "image": "assets/images/pfp_1.png",
      "title": "Drinking 300ml Water",
      "time": "About 1 minutes ago",
    },
    {
      "image": "assets/images/pfp_2.png",
      "title": "Eat Snack (Fitbar)",
      "time": "About 3 hours ago",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      backgroundColor: TColor.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25),
        child: Column(
          children: [
            _buildTodayTargetCard(),
            const SizedBox(height: 40),
            _buildActivityProgressSection(),
            const SizedBox(height: 20),
            _buildBarChart(),
            const SizedBox(height: 20),
            _buildLatestWorkoutSection(),
            const SizedBox(height: 40),
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
      leading: _buildBackButton(),
      title: Text(
        "Activity Tracker",
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
          width: 15,
          height: 15,
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  Widget _buildTodayTargetCard() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            TColor.primaryColor2.withOpacity(0.3),
            TColor.primaryColor1.withOpacity(0.3),
          ],
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Today Target",
                style: TextStyle(
                  color: TColor.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              _buildAddButton(),
            ],
          ),
          const SizedBox(height: 15),
          const Row(
            children: [
              Expanded(
                child: TodayTargetCell(
                  icon: "assets/images/water.png",
                  value: "8L",
                  title: "Water Intake",
                ),
              ),
              SizedBox(width: 15),
              Expanded(
                child: TodayTargetCell(
                  icon: "assets/images/foot.png",
                  value: "2400",
                  title: "Foot Steps",
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAddButton() {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: TColor.primaryG),
        borderRadius: BorderRadius.circular(10),
      ),
      child: MaterialButton(
        onPressed: () {},
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: const Icon(Icons.add, color: Colors.white, size: 15),
      ),
    );
  }

  Widget _buildActivityProgressSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Activity Progress",
          style: TextStyle(
            color: TColor.black,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        _buildPeriodDropdown(),
      ],
    );
  }

  Widget _buildPeriodDropdown() {
    return Container(
      height: 30,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: TColor.primaryG),
        borderRadius: BorderRadius.circular(15),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedPeriod,
          items: ["Weekly", "Monthly"]
              .map(
                (name) => DropdownMenuItem(
                  value: name,
                  child: Text(
                    name,
                    style: TextStyle(color: TColor.gray, fontSize: 14),
                  ),
                ),
              )
              .toList(),
          onChanged: (value) {
            if (value != null) {
              setState(() => _selectedPeriod = value);
            }
          },
          icon: Icon(Icons.expand_more, color: TColor.white),
          hint: Text(
            _selectedPeriod,
            style: TextStyle(color: TColor.white, fontSize: 12),
          ),
        ),
      ),
    );
  }

  Widget _buildBarChart() {
    return Container(
      height: MediaQuery.of(context).size.width * 0.5,
      padding: const EdgeInsets.symmetric(vertical: 15),
      decoration: BoxDecoration(
        color: TColor.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 3)],
      ),
      child: BarChart(
        BarChartData(
          barTouchData: _buildBarTouchData(),
          titlesData: _buildTitlesData(),
          borderData: FlBorderData(show: false),
          barGroups: _buildBarGroups(),
          gridData: FlGridData(show: false),
        ),
      ),
    );
  }

  BarTouchData _buildBarTouchData() {
    return BarTouchData(
      touchTooltipData: BarTouchTooltipData(
        getTooltipColor: (group) => Colors.grey,
        tooltipHorizontalAlignment: FLHorizontalAlignment.right,
        tooltipMargin: 10,
        getTooltipItem: (group, groupIndex, rod, rodIndex) {
          const weekDays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
          return BarTooltipItem(
            '${weekDays[group.x]}\n',
            const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
            children: [
              TextSpan(
                text: (rod.toY - 1).toString(),
                style: TextStyle(
                  color: TColor.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          );
        },
      ),
      touchCallback: (FlTouchEvent event, barTouchResponse) {
        setState(() {
          if (!event.isInterestedForInteractions ||
              barTouchResponse == null ||
              barTouchResponse.spot == null) {
            _touchedBarIndex = -1;
            return;
          }
          _touchedBarIndex = barTouchResponse.spot!.touchedBarGroupIndex;
        });
      },
    );
  }

  FlTitlesData _buildTitlesData() {
    return FlTitlesData(
      show: true,
      rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
      topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          getTitlesWidget: (value, meta) {
            const days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
            return Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                days[value.toInt()],
                style: TextStyle(
                  color: TColor.gray,
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                ),
              ),
            );
          },
          reservedSize: 38,
        ),
      ),
      leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
    );
  }

  List<BarChartGroupData> _buildBarGroups() {
    final data = [5.0, 10.5, 5.0, 7.5, 15.0, 5.5, 8.5];
    final colors = [
      TColor.primaryG,
      TColor.secondaryG,
      TColor.primaryG,
      TColor.secondaryG,
      TColor.primaryG,
      TColor.secondaryG,
      TColor.primaryG,
    ];

    return List.generate(7, (index) {
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: _touchedBarIndex == index ? data[index] + 1 : data[index],
            gradient: LinearGradient(
              colors: colors[index],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            width: 22,
            borderSide: _touchedBarIndex == index
                ? const BorderSide(color: Colors.green)
                : const BorderSide(color: Colors.white, width: 0),
            backDrawRodData: BackgroundBarChartRodData(
              show: true,
              toY: 20,
              color: TColor.lightGray,
            ),
          ),
        ],
      );
    });
  }

  Widget _buildLatestWorkoutSection() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Latest Workout",
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
          itemCount: _latestActivities.length,
          itemBuilder: (context, index) {
            return LatestActivityRow(activity: _latestActivities[index]);
          },
        ),
      ],
    );
  }
}
