import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

import '../../../common/colo_extension.dart';
import '../../../cubits/workout/workout_stats_screen_cubit.dart';
import '../../../cubits/workout/workout_stats_screen_state.dart';
import '../../../data/models/workout_model.dart';
import '../../widgets/round_button.dart';
import '../../widgets/custom_modern_appbar.dart';

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
                  // Weekly Stats Summary
                  _buildWeeklyStatsSummary(state),
                  SizedBox(height: screenSize.width * 0.05),
                  if (state.todaySchedules.isNotEmpty)
                    _buildDailyScheduleCard(state),
                  if (state.todaySchedules.isNotEmpty)
                    SizedBox(height: screenSize.width * 0.05),
                  if (state.upcomingSchedules.isNotEmpty) ...[
                    _buildUpcomingWorkoutsSection(state),
                    SizedBox(height: screenSize.width * 0.05),
                  ],
                  // Workout Categories Section (baru)
                  _buildWorkoutCategoriesSection(state),
                  SizedBox(height: screenSize.width * 0.05),
                  // Available Workouts Section (baru dari API)
                  _buildAvailableWorkoutsSection(state),
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
        state.weeklyProgress!.dailyProgress.isNotEmpty) {
      final spots = <FlSpot>[];

      // Map daily progress to chart spots (7 days)
      for (int i = 0; i < 7; i++) {
        double value = 0;
        // Get value for each day if available
        if (i < state.weeklyProgress!.dailyProgress.length) {
          value = state.weeklyProgress!.dailyProgress[i].sessions.toDouble();
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

  Widget _buildScheduleCard(NewWorkoutScheduleModel schedule) {
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
                  schedule.workoutName,
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
                  schedule.formattedDateTime,
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

  /// Build weekly stats summary widget
  Widget _buildWeeklyStatsSummary(WorkoutStatsScreenLoaded state) {
    final weeklyProgress = state.weeklyProgress;

    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: TColor.secondaryG),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            'Sessions',
            weeklyProgress?.totalSessions.toString() ?? '0',
            Icons.fitness_center,
          ),
          _buildStatItem(
            'Calories',
            weeklyProgress?.totalCalories.toString() ?? '0',
            Icons.local_fire_department,
          ),
          _buildStatItem(
            'Duration',
            weeklyProgress?.formattedTotalDuration ?? '0 min',
            Icons.timer,
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: TColor.white, size: 24),
        const SizedBox(height: 5),
        Text(
          value,
          style: TextStyle(
            color: TColor.white,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          label,
          style: TextStyle(color: TColor.white.withOpacity(0.8), fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildWorkoutCategoriesSection(WorkoutStatsScreenLoaded state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Workout Categories",
          style: TextStyle(
            color: TColor.black,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: state.categories.length,
            itemBuilder: (context, index) {
              final category = state.categories[index];
              final isSelected = state.selectedCategory == category;
              return _buildCategoryChip(category, isSelected);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryChip(WorkoutCategory category, bool isSelected) {
    return GestureDetector(
      onTap: () {
        context.read<WorkoutStatsScreenCubit>().filterByCategory(
          isSelected ? null : category,
        );
      },
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          gradient: isSelected ? LinearGradient(colors: TColor.primaryG) : null,
          color: isSelected ? null : TColor.lightGray,
          borderRadius: BorderRadius.circular(15),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: TColor.primaryColor1.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _getCategoryIcon(category),
              color: isSelected ? TColor.white : TColor.gray,
              size: 28,
            ),
            const SizedBox(height: 5),
            Text(
              category.displayName,
              style: TextStyle(
                color: isSelected ? TColor.white : TColor.gray,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getCategoryIcon(WorkoutCategory category) {
    switch (category) {
      case WorkoutCategory.fullBody:
        return Icons.accessibility_new;
      case WorkoutCategory.upperBody:
        return Icons.fitness_center;
      case WorkoutCategory.lowerBody:
        return Icons.directions_run;
      case WorkoutCategory.abs:
        return Icons.filter_vintage;
      case WorkoutCategory.cardio:
        return Icons.favorite;
      case WorkoutCategory.flexibility:
        return Icons.self_improvement;
    }
  }

  /// Build available workouts section from API
  Widget _buildAvailableWorkoutsSection(WorkoutStatsScreenLoaded state) {
    if (state.workouts.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Available Workouts",
              style: TextStyle(
                color: TColor.black,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            // Level filter dropdown
            _buildLevelFilter(state),
          ],
        ),
        const SizedBox(height: 10),
        // Search bar
        _buildSearchBar(state),
        const SizedBox(height: 10),
        // Workout list
        ListView.builder(
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: state.workouts.length + (state.hasMore ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == state.workouts.length) {
              return _buildLoadMoreButton(state);
            }
            return _buildWorkoutCard(state.workouts[index]);
          },
        ),
      ],
    );
  }

  Widget _buildLevelFilter(WorkoutStatsScreenLoaded state) {
    return PopupMenuButton<WorkoutLevel?>(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: TColor.lightGray,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              state.selectedLevel?.displayName ?? 'All Levels',
              style: TextStyle(
                color: TColor.gray,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 4),
            Icon(Icons.arrow_drop_down, color: TColor.gray, size: 20),
          ],
        ),
      ),
      onSelected: (level) {
        context.read<WorkoutStatsScreenCubit>().filterByLevel(level);
      },
      itemBuilder: (context) => [
        const PopupMenuItem<WorkoutLevel?>(
          value: null,
          child: Text('All Levels'),
        ),
        ...WorkoutLevel.values.map(
          (level) => PopupMenuItem<WorkoutLevel?>(
            value: level,
            child: Text(level.displayName),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar(WorkoutStatsScreenLoaded state) {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Search workouts...',
        hintStyle: TextStyle(color: TColor.gray, fontSize: 14),
        prefixIcon: Icon(Icons.search, color: TColor.gray),
        filled: true,
        fillColor: TColor.lightGray,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
      onChanged: (value) {
        context.read<WorkoutStatsScreenCubit>().searchWorkouts(value);
      },
    );
  }

  Widget _buildWorkoutCard(WorkoutModel workout) {
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
            // Navigate to workout detail screen
            _showWorkoutDetailBottomSheet(workout);
          },
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              children: [
                // Icon container
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: _getGradientForLevel(workout.level),
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Icon(
                      _getCategoryIconFromString(workout.category),
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
                        workout.name,
                        style: TextStyle(
                          color: TColor.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          _buildTag(
                            workout.displayLevel,
                            _getColorForLevel(workout.level),
                          ),
                          const SizedBox(width: 8),
                          _buildTag(workout.displayCategory, TColor.gray),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Text(
                        '${workout.exerciseCount} exercises',
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

  Widget _buildTag(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  List<Color> _getGradientForLevel(String level) {
    switch (level.toLowerCase()) {
      case 'beginner':
        return [Colors.green.shade400, Colors.green.shade600];
      case 'intermediate':
        return TColor.primaryG;
      case 'advanced':
        return [Colors.red.shade400, Colors.red.shade600];
      default:
        return TColor.primaryG;
    }
  }

  Color _getColorForLevel(String level) {
    switch (level.toLowerCase()) {
      case 'beginner':
        return Colors.green;
      case 'intermediate':
        return TColor.primaryColor1;
      case 'advanced':
        return Colors.red;
      default:
        return TColor.gray;
    }
  }

  IconData _getCategoryIconFromString(String category) {
    switch (category.toLowerCase()) {
      case 'fullbody':
      case 'full_body':
      case 'full body':
        return Icons.accessibility_new;
      case 'upper':
      case 'upper_body':
      case 'upperbody':
        return Icons.fitness_center;
      case 'lower':
      case 'lower_body':
      case 'lowerbody':
        return Icons.directions_run;
      case 'abs':
        return Icons.filter_vintage;
      case 'cardio':
        return Icons.favorite;
      case 'flexibility':
        return Icons.self_improvement;
      default:
        return Icons.fitness_center;
    }
  }

  Widget _buildLoadMoreButton(WorkoutStatsScreenLoaded state) {
    if (state.isLoadingMore) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: RoundButton(
        title: "Load More",
        type: RoundButtonType.bgGradient,
        onPressed: () {
          context.read<WorkoutStatsScreenCubit>().loadMoreWorkouts();
        },
      ),
    );
  }

  void _showWorkoutDetailBottomSheet(WorkoutModel workout) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.6,
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
            Container(
              width: 50,
              height: 4,
              decoration: BoxDecoration(
                color: TColor.gray.withOpacity(0.3),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(
                      children: [
                        Container(
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: _getGradientForLevel(workout.level),
                            ),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Center(
                            child: Icon(
                              _getCategoryIconFromString(workout.category),
                              color: TColor.white,
                              size: 35,
                            ),
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                workout.name,
                                style: TextStyle(
                                  color: TColor.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Row(
                                children: [
                                  _buildTag(
                                    workout.displayLevel,
                                    _getColorForLevel(workout.level),
                                  ),
                                  const SizedBox(width: 8),
                                  _buildTag(
                                    workout.displayCategory,
                                    TColor.gray,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Description
                    Text(
                      'Description',
                      style: TextStyle(
                        color: TColor.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      workout.description.isEmpty
                          ? 'No description available.'
                          : workout.description,
                      style: TextStyle(color: TColor.gray, fontSize: 14),
                    ),
                    const SizedBox(height: 20),
                    // Stats
                    Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: TColor.lightGray,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildWorkoutStat(
                            '${workout.exerciseCount}',
                            'Exercises',
                            Icons.fitness_center,
                          ),
                          _buildWorkoutStat(
                            workout.displayLevel,
                            'Level',
                            Icons.trending_up,
                          ),
                          _buildWorkoutStat(
                            workout.displayCategory,
                            'Category',
                            Icons.category,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Action buttons
                    Row(
                      children: [
                        Expanded(
                          child: RoundButton(
                            title: "Schedule",
                            type: RoundButtonType.bgGradient,
                            onPressed: () {
                              Navigator.pop(context);
                              _showScheduleDialog(workout);
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: RoundButton(
                            title: "Start Now",
                            type: RoundButtonType.bgGradient,
                            onPressed: () async {
                              Navigator.pop(context);
                              try {
                                await context
                                    .read<WorkoutStatsScreenCubit>()
                                    .startWorkout(workout.id);
                                // Navigate to active workout screen
                                if (mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Started: ${workout.name}'),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                }
                              } catch (e) {
                                if (mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Error: $e'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWorkoutStat(String value, String label, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: TColor.primaryColor1, size: 24),
        const SizedBox(height: 5),
        Text(
          value,
          style: TextStyle(
            color: TColor.black,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(label, style: TextStyle(color: TColor.gray, fontSize: 12)),
      ],
    );
  }

  void _showScheduleDialog(WorkoutModel workout) {
    DateTime selectedDate = DateTime.now().add(const Duration(days: 1));
    TimeOfDay selectedTime = const TimeOfDay(hour: 7, minute: 0);
    bool reminderEnabled = true;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            'Schedule Workout',
            style: TextStyle(color: TColor.black, fontWeight: FontWeight.w700),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                workout.name,
                style: TextStyle(color: TColor.gray, fontSize: 14),
              ),
              const SizedBox(height: 20),
              // Date picker
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(
                  Icons.calendar_today,
                  color: TColor.primaryColor1,
                ),
                title: const Text('Date'),
                subtitle: Text(
                  '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                ),
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: selectedDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (date != null) {
                    setDialogState(() => selectedDate = date);
                  }
                },
              ),
              // Time picker
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(Icons.access_time, color: TColor.primaryColor1),
                title: const Text('Time'),
                subtitle: Text(selectedTime.format(context)),
                onTap: () async {
                  final time = await showTimePicker(
                    context: context,
                    initialTime: selectedTime,
                  );
                  if (time != null) {
                    setDialogState(() => selectedTime = time);
                  }
                },
              ),
              // Reminder toggle
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Enable Reminder'),
                value: reminderEnabled,
                onChanged: (value) {
                  setDialogState(() => reminderEnabled = value);
                },
                activeColor: TColor.primaryColor1,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel', style: TextStyle(color: TColor.gray)),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context);
                try {
                  await context.read<WorkoutStatsScreenCubit>().createSchedule(
                    workoutId: workout.id,
                    scheduledDate: selectedDate,
                    scheduledTime:
                        '${selectedTime.hour.toString().padLeft(2, '0')}:${selectedTime.minute.toString().padLeft(2, '0')}',
                    reminderEnabled: reminderEnabled,
                  );
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Workout scheduled successfully!'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Error: $e'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: TColor.primaryColor1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Schedule',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
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
