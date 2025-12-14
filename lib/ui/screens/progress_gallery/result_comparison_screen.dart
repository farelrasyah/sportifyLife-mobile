import 'package:flutter/material.dart';

import '../../../common/colo_extension.dart';
import '../../widgets/icon_title_next_row.dart';
import '../../widgets/round_button.dart';
import '../../widgets/custom_modern_appbar.dart';
import 'report_screen.dart';

class ResultComparisonScreen extends StatefulWidget {
  const ResultComparisonScreen({super.key});

  @override
  State<ResultComparisonScreen> createState() => _ResultComparisonScreenState();
}

class _ResultComparisonScreenState extends State<ResultComparisonScreen>
    with TickerProviderStateMixin {
  late AnimationController _fabAnimationController;
  String _firstMonthSelection = "May";
  String _secondMonthSelection = "select Month";

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColor.white,
      appBar: CustomModernAppBar(
        title: "Comparison",
        icon: Icons.compare,
        fabAnimationController: _fabAnimationController,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: Column(
          children: [
            _buildMonthSelector(
              title: "Select Month 1",
              selectedMonth: _firstMonthSelection,
              onPressed: () => _showMonthPicker(true),
            ),
            const SizedBox(height: 15),
            _buildMonthSelector(
              title: "Select Month 2",
              selectedMonth: _secondMonthSelection,
              onPressed: () => _showMonthPicker(false),
            ),
            const Spacer(),
            _buildCompareButton(),
            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }

  Widget _buildMonthSelector({
    required String title,
    required String selectedMonth,
    required VoidCallback onPressed,
  }) {
    return IconTitleNextRow(
      icon: "assets/images/date.png",
      title: title,
      time: selectedMonth,
      onPressed: onPressed,
      color: TColor.lightGray,
    );
  }

  Widget _buildCompareButton() {
    return RoundButton(
      title: "Compare",
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ReportScreen(
              startDate: DateTime(2023, 5, 1),
              endDate: DateTime(2023, 6, 1),
            ),
          ),
        );
      },
    );
  }

  void _showMonthPicker(bool isFirstMonth) {
    // TODO: Implement month picker dialog
    // This would typically show a date picker or custom month selector
    // For now, we'll just update the state with a placeholder
    setState(() {
      if (isFirstMonth) {
        _firstMonthSelection = "June";
      } else {
        _secondMonthSelection = "July";
      }
    });
  }
}
