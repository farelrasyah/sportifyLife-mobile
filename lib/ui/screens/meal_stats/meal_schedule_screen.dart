import 'package:table_calendar/table_calendar.dart';
import 'package:flutter/material.dart';
import '../../../common/colo_extension.dart';
import '../../widgets/meal_food_schedule_row.dart';
import '../../widgets/nutritions_row.dart';

class MealScheduleScreen extends StatefulWidget {
  const MealScheduleScreen({super.key});

  @override
  State<MealScheduleScreen> createState() => _MealScheduleScreenState();
}

class _MealScheduleScreenState extends State<MealScheduleScreen> {
  late DateTime selectedDate;
  late DateTime focusedDay;
  CalendarFormat calendarFormat = CalendarFormat.week;

  final List<Map<String, String>> morningMeals = [
    {
      "name": "Honey Pancake",
      "time": "07:00am",
      "image": "assets/img/honey_pan.png",
    },
    {"name": "Coffee", "time": "07:30am", "image": "assets/img/coffee.png"},
  ];

  final List<Map<String, String>> afternoonMeals = [
    {
      "name": "Chicken Steak",
      "time": "01:00pm",
      "image": "assets/img/chicken.png",
    },
    {
      "name": "Milk",
      "time": "01:20pm",
      "image": "assets/img/glass-of-milk 1.png",
    },
  ];

  final List<Map<String, String>> snackMeals = [
    {"name": "Orange", "time": "04:30pm", "image": "assets/img/orange.png"},
    {
      "name": "Apple Pie",
      "time": "04:40pm",
      "image": "assets/img/apple_pie.png",
    },
  ];

  final List<Map<String, String>> eveningMeals = [
    {"name": "Salad", "time": "07:10pm", "image": "assets/img/salad.png"},
    {"name": "Oatmeal", "time": "08:10pm", "image": "assets/img/oatmeal.png"},
  ];

  final List<Map<String, String>> dailyNutrition = [
    {
      "title": "Calories",
      "image": "assets/img/burn.png",
      "unit_name": "kCal",
      "value": "350",
      "max_value": "500",
    },
    {
      "title": "Proteins",
      "image": "assets/img/proteins.png",
      "unit_name": "g",
      "value": "300",
      "max_value": "1000",
    },
    {
      "title": "Fats",
      "image": "assets/img/egg.png",
      "unit_name": "g",
      "value": "140",
      "max_value": "1000",
    },
    {
      "title": "Carbo",
      "image": "assets/img/carbo.png",
      "unit_name": "g",
      "value": "140",
      "max_value": "1000",
    },
  ];

  @override
  void initState() {
    super.initState();
    selectedDate = DateTime.now();
    focusedDay = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: _buildAppBar(),
      backgroundColor: TColor.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCalendarSection(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildMealSection("BreakFast", morningMeals, "230 calories"),
                  _buildMealSection("Lunch", afternoonMeals, "500 calories"),
                  _buildMealSection("Snacks", snackMeals, "140 calories"),
                  _buildMealSection("Dinner", eveningMeals, "120 calories"),
                  SizedBox(height: screenSize.width * 0.05),
                  _buildNutritionSummarySection(),
                  SizedBox(height: screenSize.width * 0.05),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: TColor.white,
      centerTitle: true,
      elevation: 0,
      leading: _buildAppBarButton(
        "assets/img/black_btn.png",
        () => Navigator.pop(context),
      ),
      title: Text(
        "Meal  Schedule",
        style: TextStyle(
          color: TColor.black,
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
      ),
      actions: [_buildAppBarButton("assets/img/more_btn.png", () {})],
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

  Widget _buildCalendarSection() {
    return Container(
      decoration: BoxDecoration(
        color: TColor.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TableCalendar(
        firstDay: DateTime.now().subtract(const Duration(days: 365)),
        lastDay: DateTime.now().add(const Duration(days: 365)),
        focusedDay: focusedDay,
        calendarFormat: calendarFormat,
        selectedDayPredicate: (day) {
          return isSameDay(selectedDate, day);
        },
        onDaySelected: (selectedDay, focused) {
          setState(() {
            selectedDate = selectedDay;
            focusedDay = focused;
          });
        },
        onFormatChanged: (format) {
          if (calendarFormat != format) {
            setState(() {
              calendarFormat = format;
            });
          }
        },
        onPageChanged: (focused) {
          focusedDay = focused;
        },
        calendarStyle: CalendarStyle(
          todayDecoration: BoxDecoration(
            color: TColor.primaryColor2.withOpacity(0.3),
            shape: BoxShape.circle,
          ),
          selectedDecoration: BoxDecoration(
            gradient: LinearGradient(
              colors: TColor.primaryG,
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            shape: BoxShape.circle,
          ),
          selectedTextStyle: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          todayTextStyle: TextStyle(
            color: TColor.primaryColor1,
            fontWeight: FontWeight.bold,
          ),
          defaultTextStyle: const TextStyle(color: Colors.black),
          weekendTextStyle: TextStyle(color: TColor.primaryColor2),
        ),
        headerStyle: HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
          titleTextStyle: TextStyle(
            color: TColor.black,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
          leftChevronIcon: Icon(
            Icons.chevron_left,
            color: TColor.primaryColor1,
          ),
          rightChevronIcon: Icon(
            Icons.chevron_right,
            color: TColor.primaryColor1,
          ),
        ),
        daysOfWeekStyle: DaysOfWeekStyle(
          weekdayStyle: TextStyle(color: TColor.gray, fontSize: 12),
          weekendStyle: TextStyle(color: TColor.primaryColor2, fontSize: 12),
        ),
      ),
    );
  }

  Widget _buildMealSection(
    String mealType,
    List<Map<String, String>> meals,
    String calories,
  ) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                mealType,
                style: TextStyle(
                  color: TColor.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  "${meals.length} Items | $calories",
                  style: TextStyle(color: TColor.gray, fontSize: 12),
                ),
              ),
            ],
          ),
        ),
        ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: meals.length,
          itemBuilder: (context, index) {
            final mealData = meals[index];
            return MealFoodScheduleRow(mObj: mealData, index: index);
          },
        ),
      ],
    );
  }

  Widget _buildNutritionSummarySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Text(
            "Today Meal Nutritions",
            style: TextStyle(
              color: TColor.black,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: dailyNutrition.length,
          itemBuilder: (context, index) {
            final nutritionData = dailyNutrition[index];
            return NutritionRow(nObj: nutritionData);
          },
        ),
      ],
    );
  }
}
