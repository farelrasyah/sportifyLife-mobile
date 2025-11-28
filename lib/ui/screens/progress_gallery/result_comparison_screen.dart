import 'package:flutter/material.dart';

import '../../../common/colo_extension.dart';
import '../../widgets/icon_title_next_row.dart';
import '../../widgets/round_button.dart';
import 'report_screen.dart';

class ResultComparisonScreen extends StatefulWidget {
  const ResultComparisonScreen({super.key});

  @override
  State<ResultComparisonScreen> createState() => _ResultComparisonScreenState();
}

class _ResultComparisonScreenState extends State<ResultComparisonScreen> {
  String _firstMonthSelection = "May";
  String _secondMonthSelection = "select Month";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      backgroundColor: TColor.white,
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
        "Comparison",
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
