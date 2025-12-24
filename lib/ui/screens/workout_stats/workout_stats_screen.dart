import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

import '../../../common/colo_extension.dart';
import '../../../cubits/workout/workout_stats_screen_cubit.dart';
import '../../../cubits/workout/workout_stats_screen_state.dart';
import '../../../data/models/workout_plan_model.dart';
import '../../widgets/round_button.dart';
import '../../widgets/custom_modern_appbar.dart';
import 'exercise_list_by_body_part_screen.dart';

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

    // Load data from backend
    context.read<WorkoutStatsScreenCubit>().loadWorkoutStatsData();
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
        child: BlocBuilder<WorkoutStatsScreenCubit, WorkoutStatsScreenState>(
          builder: (context, state) {
            if (state is WorkoutStatsScreenLoading) {
              return _buildLoadingState();
            }

            if (state is WorkoutStatsScreenError) {
              return _buildErrorState(state.message, screenSize);
            }

            if (state is WorkoutStatsScreenEmpty) {
              return _buildEmptyState(screenSize);
            }

            if (state is WorkoutStatsScreenLoaded) {
              return _buildLoadedState(state, screenSize);
            }

            return _buildLoadingState();
          },
        ),
      ),
    );
  }

  Widget _buildLoadedState(WorkoutStatsScreenLoaded state, Size screenSize) {
    return RefreshIndicator(
      onRefresh: () async {
        await context.read<WorkoutStatsScreenCubit>().refreshData();
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            // Chart section
            Container(
              width: screenSize.width,
              height: screenSize.width * 0.8,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: _buildChart(state),
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
                  if (state.todaySchedules.isNotEmpty)
                    _buildDailyScheduleCard(state),
                  if (state.todaySchedules.isNotEmpty)
                    SizedBox(height: screenSize.width * 0.05),
                  if (state.upcomingSchedules.isNotEmpty) ...[
                    _buildUpcomingWorkoutsSection(state),
                    SizedBox(height: screenSize.width * 0.05),
                  ],
                  _buildWorkoutCategoriesSection(state),
                  SizedBox(height: screenSize.width * 0.1),
                ],
              ),
            ),
          ],
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
              "${lineBarSpot.y.toInt()} workouts",
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

  List<LineChartBarData> _buildLineChartData(WorkoutStatsScreenLoaded state) {
    // Use real data from backend if available
    if (state.weeklyProgress != null &&
        state.weeklyProgress!.currentWeek.workoutDays.isNotEmpty) {
      final weeklyData = state.weeklyProgress!.currentWeek;
      final spots = <FlSpot>[];

      // Map weekly data to chart spots (7 days)
      for (int i = 0; i < 7; i++) {
        double value = 0;
        // Get value for each day if available
        if (i < weeklyData.workoutDays.length) {
          value = weeklyData.workoutDays[i].workouts.toDouble();
        }
        spots.add(FlSpot(i + 1, value * 10)); // Scale for visibility
      }

      return [
        LineChartBarData(
          isCurved: true,
          color: TColor.white,
          barWidth: 4,
          isStrokeCapRound: true,
          dotData: FlDotData(show: false),
          belowBarData: BarAreaData(show: false),
          spots: spots.isEmpty ? _getDefaultSpots() : spots,
        ),
      ];
    }

    // Fallback to default data
    return [_buildPrimaryLineData()];
  }

  List<FlSpot> _getDefaultSpots() {
    return const [
      FlSpot(1, 0),
      FlSpot(2, 0),
      FlSpot(3, 0),
      FlSpot(4, 0),
      FlSpot(5, 0),
      FlSpot(6, 0),
      FlSpot(7, 0),
    ];
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

  Widget _buildChart(WorkoutStatsScreenLoaded state) {
    return LineChart(
      LineChartData(
        lineTouchData: _buildLineTouchData(),
        gridData: _buildGridData(),
        titlesData: _buildTitlesData(),
        borderData: _buildBorderData(),
        lineBarsData: _buildLineChartData(state),
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

  Widget _buildDailyScheduleCard(WorkoutStatsScreenLoaded state) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
      decoration: BoxDecoration(
        color: TColor.primaryColor2.withOpacity(0.3),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Today's Workout",
                  style: TextStyle(
                    color: TColor.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  "${state.todaySchedules.length} workout${state.todaySchedules.length > 1 ? 's' : ''} scheduled",
                  style: TextStyle(color: TColor.gray, fontSize: 12),
                ),
              ],
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
                // Navigate to daily workout schedule screen
                // TODO: Implement navigation
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUpcomingWorkoutsSection(WorkoutStatsScreenLoaded state) {
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
              onPressed: () {
                // Navigate to all schedules
                // TODO: Implement navigation
              },
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
          itemCount: state.upcomingSchedules.length > 2
              ? 2
              : state.upcomingSchedules.length,
          itemBuilder: (context, index) {
            var schedule = state.upcomingSchedules[index];
            return _buildScheduleCard(schedule);
          },
        ),
      ],
    );
  }

  Widget _buildScheduleCard(WorkoutScheduleModel schedule) {
    final scheduledDate = schedule.scheduledDateTime;
    final timeText = scheduledDate != null
        ? "${scheduledDate.day}/${scheduledDate.month}, ${scheduledDate.hour.toString().padLeft(2, '0')}:${scheduledDate.minute.toString().padLeft(2, '0')}"
        : "Not scheduled";

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: TColor.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: TColor.secondaryG),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.fitness_center, color: TColor.white, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  schedule.customWorkoutPlan?.name ?? "Workout",
                  style: TextStyle(
                    color: TColor.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  timeText,
                  style: TextStyle(color: TColor.gray, fontSize: 12),
                ),
              ],
            ),
          ),
          Switch(
            value: schedule.reminderEnabled,
            onChanged: (value) {
              context.read<WorkoutStatsScreenCubit>().toggleReminder(
                schedule.id,
                value,
              );
            },
            activeColor: TColor.primaryColor1,
          ),
        ],
      ),
    );
  }

  Widget _buildWorkoutCategoriesSection(WorkoutStatsScreenLoaded state) {
    if (state.bodyParts.isEmpty) {
      return const SizedBox.shrink();
    }

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
        const SizedBox(height: 10),
        ListView.builder(
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: state.bodyParts.length,
          itemBuilder: (context, index) {
            var bodyPart = state.bodyParts[index];
            return _buildBodyPartCard(bodyPart.value, bodyPart.label);
          },
        ),
      ],
    );
  }

  Widget _buildBodyPartCard(String bodyPartValue, String bodyPartLabel) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: TColor.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(15),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    ExerciseListByBodyPartScreen(bodyPart: bodyPartValue),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              children: [
                // Lottie animation
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: TColor.primaryG),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Icon(
                      _getBodyPartIcon(bodyPartValue),
                      color: TColor.white,
                      size: 30,
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        bodyPartLabel,
                        style: TextStyle(
                          color: TColor.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        "Browse exercises",
                        style: TextStyle(color: TColor.gray, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right, color: TColor.gray.withOpacity(0.5)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconData _getBodyPartIcon(String bodyPart) {
    switch (bodyPart.toUpperCase()) {
      case 'BACK':
        return Icons.airline_seat_recline_normal;
      case 'CHEST':
        return Icons.accessibility_new;
      case 'LEGS':
      case 'LOWER LEGS':
      case 'UPPER LEGS':
        return Icons.directions_walk;
      case 'ARMS':
      case 'UPPER ARMS':
      case 'LOWER ARMS':
        return Icons.fitness_center;
      case 'SHOULDERS':
        return Icons.self_improvement;
      case 'WAIST':
      case 'ABS':
        return Icons.crop_square;
      case 'CARDIO':
        return Icons.favorite;
      default:
        return Icons.fitness_center;
    }
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(TColor.white),
          ),
          const SizedBox(height: 20),
          Text(
            'Loading workout data...',
            style: TextStyle(color: TColor.white, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String message, Size screenSize) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: screenSize.height * 0.15),
          Container(
            padding: const EdgeInsets.all(20),
            margin: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: TColor.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 60, color: TColor.gray),
                const SizedBox(height: 20),
                Text(
                  'Oops! Something went wrong',
                  style: TextStyle(
                    color: TColor.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  message,
                  style: TextStyle(color: TColor.gray, fontSize: 14),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: 150,
                  child: RoundButton(
                    title: "Retry",
                    type: RoundButtonType.bgGradient,
                    onPressed: () {
                      context
                          .read<WorkoutStatsScreenCubit>()
                          .loadWorkoutStatsData();
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(Size screenSize) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: screenSize.height * 0.1),
          Container(
            padding: const EdgeInsets.all(20),
            margin: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: TColor.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 200,
                  height: 200,
                  child: Lottie.asset(
                    'assets/images/exercise.json',
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'No Workout Data Yet',
                  style: TextStyle(
                    color: TColor.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Start your fitness journey by creating your first workout plan!',
                  style: TextStyle(color: TColor.gray, fontSize: 14),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: 200,
                  child: RoundButton(
                    title: "Refresh",
                    type: RoundButtonType.bgGradient,
                    onPressed: () {
                      context
                          .read<WorkoutStatsScreenCubit>()
                          .loadWorkoutStatsData();
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
