import 'package:dotted_dashed_line/dotted_dashed_line.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:simple_animation_progress_bar/simple_animation_progress_bar.dart';
import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';

import '../../../common/colo_extension.dart';
import '../../widgets/round_button.dart';
import '../../widgets/workout_row.dart';
import 'fitness_tracker_screen.dart';
import 'notification_screen.dart';
import 'workout_complete_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final List<Map<String, dynamic>> _workoutData = [
    {
      "name": "Full Body Workout",
      "image": "assets/images/moveSet_1.png",
      "kcal": "180",
      "time": "20",
      "progress": 0.3,
    },
    {
      "name": "Lower Body Workout",
      "image": "assets/images/moveSet_2.png",
      "kcal": "200",
      "time": "30",
      "progress": 0.4,
    },
    {
      "name": "Ab Workout",
      "image": "assets/images/moveSet_3.png",
      "kcal": "300",
      "time": "40",
      "progress": 0.7,
    },
  ];

  final List<Map<String, String>> _waterIntake = [
    {"title": "6am - 8am", "subtitle": "600ml"},
    {"title": "9am - 11am", "subtitle": "500ml"},
    {"title": "11am - 2pm", "subtitle": "1000ml"},
    {"title": "2pm - 4pm", "subtitle": "700ml"},
    {"title": "4pm - now", "subtitle": "900ml"},
  ];

  String _period = "Weekly";

  List<FlSpot> get _heartRateData => const [
    FlSpot(0, 20),
    FlSpot(1, 25),
    FlSpot(2, 40),
    FlSpot(3, 50),
    FlSpot(4, 35),
    FlSpot(5, 40),
    FlSpot(6, 30),
    FlSpot(7, 20),
    FlSpot(8, 25),
    FlSpot(9, 40),
    FlSpot(10, 50),
    FlSpot(11, 35),
    FlSpot(12, 50),
    FlSpot(13, 60),
    FlSpot(14, 40),
    FlSpot(15, 50),
    FlSpot(16, 20),
    FlSpot(17, 25),
    FlSpot(18, 40),
    FlSpot(19, 50),
    FlSpot(20, 35),
    FlSpot(21, 80),
    FlSpot(22, 30),
    FlSpot(23, 20),
    FlSpot(24, 25),
    FlSpot(25, 40),
    FlSpot(26, 50),
    FlSpot(27, 35),
    FlSpot(28, 50),
    FlSpot(29, 60),
    FlSpot(30, 40),
  ];

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: TColor.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              SizedBox(height: media.width * 0.05),
              _buildBMICard(media),
              SizedBox(height: media.width * 0.05),
              _buildTodayTarget(),
              SizedBox(height: media.width * 0.05),
              _buildActivityStatus(media),
              SizedBox(height: media.width * 0.05),
              _buildMetricsRow(media),
              SizedBox(height: media.width * 0.1),
              _buildWorkoutProgress(media),
              SizedBox(height: media.width * 0.05),
              _buildLatestWorkout(),
              SizedBox(height: media.width * 0.1),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Welcome Back,",
              style: TextStyle(color: TColor.gray, fontSize: 12),
            ),
            Text(
              "Farasyah",
              style: TextStyle(
                color: TColor.black,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        IconButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const NotificationScreen()),
          ),
          icon: Image.asset(
            "assets/images/notification.png",
            width: 25,
            height: 25,
            fit: BoxFit.fitHeight,
          ),
        ),
      ],
    );
  }

  Widget _buildBMICard(Size media) {
    return Container(
      height: media.width * 0.4,
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: TColor.primaryG),
        borderRadius: BorderRadius.circular(media.width * 0.075),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Image.asset(
            "assets/images/decor.png",
            height: media.width * 0.4,
            width: double.maxFinite,
            fit: BoxFit.fitHeight,
          ),
          Padding(
            padding: const EdgeInsets.all(25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "BMI (Body Mass Index)",
                      style: TextStyle(
                        color: TColor.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      "You have a normal weight",
                      style: TextStyle(
                        color: TColor.white.withOpacity(0.7),
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: 120,
                      height: 35,
                      child: RoundButton(
                        title: "View More",
                        type: RoundButtonType.bgSGradient,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
                AspectRatio(
                  aspectRatio: 1,
                  child: PieChart(
                    PieChartData(
                      startDegreeOffset: 250,
                      borderData: FlBorderData(show: false),
                      sectionsSpace: 1,
                      centerSpaceRadius: 0,
                      sections: [
                        PieChartSectionData(
                          color: TColor.secondaryColor1,
                          value: 33,
                          title: '',
                          radius: 55,
                          badgeWidget: const Text(
                            "20,1",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        PieChartSectionData(
                          color: Colors.white,
                          value: 75,
                          title: '',
                          radius: 45,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTodayTarget() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: TColor.primaryColor2.withOpacity(0.3),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
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
          SizedBox(
            width: 70,
            height: 25,
            child: RoundButton(
              title: "Check",
              type: RoundButtonType.bgGradient,
              fontSize: 12,
              fontWeight: FontWeight.w400,
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FitnessTrackerScreen(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityStatus(Size media) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Activity Status",
          style: TextStyle(
            color: TColor.black,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: media.width * 0.02),
        ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: Container(
            height: media.width * 0.4,
            decoration: BoxDecoration(
              color: TColor.primaryColor2.withOpacity(0.3),
              borderRadius: BorderRadius.circular(25),
            ),
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Heart Rate",
                        style: TextStyle(
                          color: TColor.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      ShaderMask(
                        blendMode: BlendMode.srcIn,
                        shaderCallback: (bounds) => LinearGradient(
                          colors: TColor.primaryG,
                        ).createShader(bounds),
                        child: Text(
                          "78 BPM",
                          style: TextStyle(
                            color: TColor.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                LineChart(_heartRateChart()),
              ],
            ),
          ),
        ),
      ],
    );
  }

  LineChartData _heartRateChart() {
    final barData = LineChartBarData(
      spots: _heartRateData,
      isCurved: false,
      barWidth: 3,
      belowBarData: BarAreaData(
        show: true,
        gradient: LinearGradient(
          colors: [
            TColor.primaryColor2.withOpacity(0.4),
            TColor.primaryColor1.withOpacity(0.1),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      dotData: FlDotData(show: false),
      gradient: LinearGradient(colors: TColor.primaryG),
    );

    return LineChartData(
      lineBarsData: [barData],
      minY: 0,
      maxY: 130,
      titlesData: FlTitlesData(show: false),
      gridData: FlGridData(show: false),
      borderData: FlBorderData(show: false),
    );
  }

  Widget _buildMetricsRow(Size media) {
    return Row(
      children: [
        Expanded(child: _buildWaterIntake(media)),
        SizedBox(width: media.width * 0.05),
        Expanded(
          child: Column(
            children: [
              _buildSleepCard(media),
              SizedBox(height: media.width * 0.05),
              _buildCaloriesCard(media),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildWaterIntake(Size media) {
    return Container(
      height: media.width * 0.95,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 2)],
      ),
      child: Row(
        children: [
          SimpleAnimationProgressBar(
            height: media.width * 0.85,
            width: media.width * 0.07,
            backgroundColor: Colors.grey.shade100,
            foregroundColor: Colors.purple,
            ratio: 0.5,
            direction: Axis.vertical,
            curve: Curves.fastLinearToSlowEaseIn,
            duration: const Duration(seconds: 3),
            borderRadius: BorderRadius.circular(15),
            gradientColor: LinearGradient(
              colors: TColor.primaryG,
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Water Intake",
                  style: TextStyle(
                    color: TColor.black,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                ShaderMask(
                  blendMode: BlendMode.srcIn,
                  shaderCallback: (bounds) => LinearGradient(
                    colors: TColor.primaryG,
                  ).createShader(bounds),
                  child: Text(
                    "4 Liters",
                    style: TextStyle(
                      color: TColor.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Real time updates",
                  style: TextStyle(color: TColor.gray, fontSize: 12),
                ),
                ..._waterIntake
                    .map((item) => _buildWaterItem(item, media))
                    .toList(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWaterItem(Map<String, String> item, Size media) {
    final isLast = item == _waterIntake.last;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 4),
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: TColor.secondaryColor1.withOpacity(0.5),
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            if (!isLast)
              DottedDashedLine(
                height: media.width * 0.078,
                width: 0,
                dashColor: TColor.secondaryColor1.withOpacity(0.5),
                axis: Axis.vertical,
              ),
          ],
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item["title"]!,
              style: TextStyle(color: TColor.gray, fontSize: 10),
            ),
            ShaderMask(
              blendMode: BlendMode.srcIn,
              shaderCallback: (bounds) => LinearGradient(
                colors: TColor.secondaryG,
              ).createShader(bounds),
              child: Text(
                item["subtitle"]!,
                style: TextStyle(color: TColor.white, fontSize: 12),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSleepCard(Size media) {
    return Container(
      width: double.maxFinite,
      height: media.width * 0.45,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 2)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Sleep",
            style: TextStyle(
              color: TColor.black,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
          ShaderMask(
            blendMode: BlendMode.srcIn,
            shaderCallback: (bounds) =>
                LinearGradient(colors: TColor.primaryG).createShader(bounds),
            child: Text(
              "8h 20m",
              style: TextStyle(
                color: TColor.white,
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
          ),
          const Spacer(),
          Image.asset(
            "assets/images/sleepTrack.png",
            width: double.maxFinite,
            fit: BoxFit.fitWidth,
          ),
        ],
      ),
    );
  }

  Widget _buildCaloriesCard(Size media) {
    return Container(
      width: double.maxFinite,
      height: media.width * 0.45,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 2)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Calories",
            style: TextStyle(
              color: TColor.black,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
          ShaderMask(
            blendMode: BlendMode.srcIn,
            shaderCallback: (bounds) =>
                LinearGradient(colors: TColor.primaryG).createShader(bounds),
            child: Text(
              "760 kCal",
              style: TextStyle(
                color: TColor.white,
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
          ),
          const Spacer(),
          Center(
            child: SizedBox(
              width: media.width * 0.2,
              height: media.width * 0.2,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: media.width * 0.15,
                    height: media.width * 0.15,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: TColor.primaryG),
                      borderRadius: BorderRadius.circular(media.width * 0.075),
                    ),
                    child: FittedBox(
                      child: Text(
                        "230kCal\nleft",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: TColor.white, fontSize: 11),
                      ),
                    ),
                  ),
                  SimpleCircularProgressBar(
                    progressStrokeWidth: 10,
                    backStrokeWidth: 10,
                    progressColors: TColor.primaryG,
                    backColor: Colors.grey.shade100,
                    valueNotifier: ValueNotifier(50),
                    startAngle: -180,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWorkoutProgress(Size media) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Workout Progress",
              style: TextStyle(
                color: TColor.black,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            Container(
              height: 30,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: TColor.primaryG),
                borderRadius: BorderRadius.circular(15),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _period,
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
                  onChanged: (value) => setState(() => _period = value!),
                  icon: Icon(Icons.expand_more, color: TColor.white),
                  hint: Text(
                    _period,
                    style: TextStyle(color: TColor.white, fontSize: 12),
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: media.width * 0.05),
        _buildProgressChart(media),
      ],
    );
  }

  Widget _buildProgressChart(Size media) {
    return Container(
      padding: const EdgeInsets.only(left: 15),
      height: media.width * 0.5,
      child: LineChart(
        LineChartData(
          lineBarsData: [
            LineChartBarData(
              isCurved: true,
              gradient: LinearGradient(
                colors: [
                  TColor.primaryColor2.withOpacity(0.5),
                  TColor.primaryColor1.withOpacity(0.5),
                ],
              ),
              barWidth: 4,
              isStrokeCapRound: true,
              dotData: FlDotData(show: false),
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
            LineChartBarData(
              isCurved: true,
              gradient: LinearGradient(
                colors: [
                  TColor.secondaryColor2.withOpacity(0.5),
                  TColor.secondaryColor1.withOpacity(0.5),
                ],
              ),
              barWidth: 2,
              isStrokeCapRound: true,
              dotData: FlDotData(show: false),
              spots: const [
                FlSpot(1, 80),
                FlSpot(2, 50),
                FlSpot(3, 90),
                FlSpot(4, 40),
                FlSpot(5, 80),
                FlSpot(6, 35),
                FlSpot(7, 60),
              ],
            ),
          ],
          minY: -0.5,
          maxY: 110,
          titlesData: FlTitlesData(
            show: true,
            leftTitles: AxisTitles(),
            topTitles: AxisTitles(),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 32,
                getTitlesWidget: (value, meta) {
                  const days = [
                    '',
                    'Sun',
                    'Mon',
                    'Tue',
                    'Wed',
                    'Thu',
                    'Fri',
                    'Sat',
                  ];
                  return Text(
                    value.toInt() < days.length ? days[value.toInt()] : '',
                    style: TextStyle(color: TColor.gray, fontSize: 12),
                  );
                },
              ),
            ),
            rightTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 20,
                reservedSize: 40,
                getTitlesWidget: (value, meta) {
                  if (value % 20 == 0 && value <= 100) {
                    return Text(
                      '${value.toInt()}%',
                      style: TextStyle(color: TColor.gray, fontSize: 12),
                    );
                  }
                  return Container();
                },
              ),
            ),
          ),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: 25,
            getDrawingHorizontalLine: (value) =>
                FlLine(color: TColor.gray.withOpacity(0.15), strokeWidth: 2),
          ),
          borderData: FlBorderData(show: false),
        ),
      ),
    );
  }

  Widget _buildLatestWorkout() {
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
          itemCount: _workoutData.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const WorkoutCompleteScreen(),
                ),
              ),
              child: WorkoutRow(workout: _workoutData[index]),
            );
          },
        ),
      ],
    );
  }
}
