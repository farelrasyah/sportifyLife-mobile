import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:simple_animation_progress_bar/simple_animation_progress_bar.dart';
import '../../../common/colo_extension.dart';
import '../../../common/common.dart';
import '../../widgets/round_button.dart';

class ReportScreen extends StatefulWidget {
  final DateTime startDate;
  final DateTime endDate;
  const ReportScreen({
    super.key,
    required this.startDate,
    required this.endDate,
  });

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  int _selectedTabIndex = 0;

  final List<Map<String, String>> _comparisonImages = [
    {
      "category": tr("front_facing"),
      "beforeImage": "assets/images/pp_1.png",
      "afterImage": "assets/images/pp_2.png",
    },
    {
      "category": tr("back_facing"),
      "beforeImage": "assets/images/pp_3.png",
      "afterImage": "assets/images/pp_4.png",
    },
    {
      "category": tr("left_facing"),
      "beforeImage": "assets/images/pp_5.png",
      "afterImage": "assets/images/pp_6.png",
    },
    {
      "category": tr("right_facing"),
      "beforeImage": "assets/images/pp_7.png",
      "afterImage": "assets/images/pp_8.png",
    },
  ];

  final List<Map<String, String>> _progressStatistics = [
    {
      "metric": "Lose Weight",
      "progressPercent": "33",
      "beforePercent": "33%",
      "afterPercent": "67%",
    },
    {
      "metric": "Height Increase",
      "progressPercent": "88",
      "beforePercent": "88%",
      "afterPercent": "12%",
    },
    {
      "metric": "Muscle Mass Increase",
      "progressPercent": "57",
      "beforePercent": "57%",
      "afterPercent": "43%",
    },
    {
      "metric": "Abs",
      "progressPercent": "89",
      "beforePercent": "89%",
      "afterPercent": "11%",
    },
  ];

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: _buildAppBar(),
      backgroundColor: TColor.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Column(
            children: [
              _buildTabSelector(screenSize),
              const SizedBox(height: 20),
              if (_selectedTabIndex == 0) _buildPhotoComparisonTab(),
              if (_selectedTabIndex == 1) _buildStatisticsTab(screenSize),
            ],
          ),
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
            "assets/images/black_btn.png",
            width: 15,
            height: 15,
            fit: BoxFit.contain,
          ),
        ),
      ),
      title: Text(
        "Result",
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
              "assets/images/share.png",
              width: 15,
              height: 15,
              fit: BoxFit.contain,
            ),
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

  Widget _buildTabSelector(Size screenSize) {
    return Container(
      height: 55,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: TColor.lightGray,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedContainer(
            alignment: _selectedTabIndex == 0
                ? Alignment.centerLeft
                : Alignment.centerRight,
            duration: const Duration(milliseconds: 300),
            child: Container(
              width: (screenSize.width * 0.5) - 40,
              height: 40,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: TColor.primaryG),
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
          SizedBox(
            height: 40,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _selectedTabIndex = 0;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Text(
                        "Photo",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: _selectedTabIndex == 0
                              ? TColor.white
                              : TColor.gray,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _selectedTabIndex = 1;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Text(
                        "Statistic",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: _selectedTabIndex == 1
                              ? TColor.white
                              : TColor.gray,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
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

  Widget _buildPhotoComparisonTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildProgressHeader(),
        const SizedBox(height: 15),
        _buildProgressBar(),
        const SizedBox(height: 15),
        _buildDateHeaders(),
        _buildImageComparisons(),
        _buildBackToHomeButton(),
        const SizedBox(height: 15),
      ],
    );
  }

  Widget _buildProgressHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Average Progress",
          style: TextStyle(
            color: TColor.black,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        const Text(
          "Good",
          style: TextStyle(
            color: Color(0xFF6DD570),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildProgressBar() {
    var screenSize = MediaQuery.of(context).size;
    return Stack(
      alignment: Alignment.center,
      children: [
        SimpleAnimationProgressBar(
          height: 20,
          width: screenSize.width - 40,
          backgroundColor: Colors.grey.shade100,
          foregroundColor: Colors.purple,
          ratio: 0.62,
          direction: Axis.horizontal,
          curve: Curves.fastLinearToSlowEaseIn,
          duration: const Duration(seconds: 3),
          borderRadius: BorderRadius.circular(10),
          gradientColor: LinearGradient(
            colors: TColor.primaryG,
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        Text("62%", style: TextStyle(color: TColor.white, fontSize: 12)),
      ],
    );
  }

  Widget _buildDateHeaders() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          dateToString(widget.startDate, formatStr: "MMMM"),
          style: TextStyle(
            color: TColor.gray,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          dateToString(widget.endDate, formatStr: "MMMM"),
          style: TextStyle(
            color: TColor.gray,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget _buildImageComparisons() {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: _comparisonImages.length,
      itemBuilder: (context, index) {
        var imageData = _comparisonImages[index];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 8),
            Text(
              imageData["category"]!,
              style: TextStyle(
                color: TColor.gray,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Container(
                      decoration: BoxDecoration(
                        color: TColor.lightGray,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.asset(
                          imageData["beforeImage"]!,
                          width: double.maxFinite,
                          height: double.maxFinite,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Container(
                      decoration: BoxDecoration(
                        color: TColor.lightGray,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.asset(
                          imageData["afterImage"]!,
                          width: double.maxFinite,
                          height: double.maxFinite,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildBackToHomeButton() {
    return RoundButton(
      title: "Back to Home",
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }

  Widget _buildStatisticsTab(Size screenSize) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLineChart(screenSize),
        const SizedBox(height: 15),
        _buildDateHeaders(),
        _buildStatisticsList(screenSize),
        _buildBackToHomeButton(),
        const SizedBox(height: 15),
      ],
    );
  }

  Widget _buildLineChart(Size screenSize) {
    return Container(
      padding: const EdgeInsets.only(left: 10),
      height: screenSize.width * 0.5,
      width: double.maxFinite,
      child: LineChart(
        LineChartData(
          lineTouchData: _buildLineTouchData(),
          lineBarsData: _getLineChartData(),
          minY: -0.5,
          maxY: 110,
          titlesData: FlTitlesData(
            show: true,
            leftTitles: const AxisTitles(),
            topTitles: const AxisTitles(),
            bottomTitles: AxisTitles(sideTitles: _buildBottomTitles()),
            rightTitles: AxisTitles(sideTitles: _buildRightTitles()),
          ),
          gridData: FlGridData(
            show: true,
            drawHorizontalLine: true,
            horizontalInterval: 25,
            drawVerticalLine: false,
            getDrawingHorizontalLine: (value) {
              return FlLine(color: TColor.lightGray, strokeWidth: 2);
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

  Widget _buildStatisticsList(Size screenSize) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: _progressStatistics.length,
      itemBuilder: (context, index) {
        var statData = _progressStatistics[index];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 15),
            Text(
              statData["metric"]!,
              style: TextStyle(
                color: TColor.gray,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 25,
                  child: Text(
                    statData["beforePercent"]!,
                    textAlign: TextAlign.right,
                    style: TextStyle(color: TColor.gray, fontSize: 12),
                  ),
                ),
                SimpleAnimationProgressBar(
                  height: 10,
                  width: screenSize.width - 120,
                  backgroundColor: TColor.primaryColor1,
                  foregroundColor: const Color(0xffFFB2B1),
                  ratio:
                      (double.tryParse(statData["progressPercent"]!) ?? 0.0) /
                      100.0,
                  direction: Axis.horizontal,
                  curve: Curves.fastLinearToSlowEaseIn,
                  duration: const Duration(seconds: 3),
                  borderRadius: BorderRadius.circular(5),
                ),
                SizedBox(
                  width: 25,
                  child: Text(
                    statData["afterPercent"]!,
                    textAlign: TextAlign.left,
                    style: TextStyle(color: TColor.gray, fontSize: 12),
                  ),
                ),
              ],
            ),
          ],
        );
      },
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
                const FlLine(color: Colors.transparent),
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
        getTooltipColor: (LineBarSpot spot) => TColor.secondaryColor1,
        tooltipBorder: BorderSide.none,
        tooltipPadding: const EdgeInsets.all(8),
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

  List<LineChartBarData> _getLineChartData() {
    return [_buildPrimaryLineData(), _buildSecondaryLineData()];
  }

  LineChartBarData _buildPrimaryLineData() {
    return LineChartBarData(
      isCurved: true,
      gradient: LinearGradient(colors: TColor.primaryG),
      barWidth: 3,
      isStrokeCapRound: true,
      dotData: const FlDotData(show: false),
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
      gradient: LinearGradient(
        colors: [
          TColor.secondaryColor2.withOpacity(0.5),
          TColor.secondaryColor1.withOpacity(0.5),
        ],
      ),
      barWidth: 2,
      isStrokeCapRound: true,
      dotData: const FlDotData(show: false),
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
    var style = TextStyle(color: TColor.gray, fontSize: 12);
    Widget text;
    switch (value.toInt()) {
      case 1:
        text = Text('Jan', style: style);
        break;
      case 2:
        text = Text('Feb', style: style);
        break;
      case 3:
        text = Text('Mar', style: style);
        break;
      case 4:
        text = Text('Apr', style: style);
        break;
      case 5:
        text = Text('May', style: style);
        break;
      case 6:
        text = Text('Jun', style: style);
        break;
      case 7:
        text = Text('Jul', style: style);
        break;
      default:
        text = const Text('');
        break;
    }

    return SideTitleWidget(meta: meta, child: text);
  }
}
