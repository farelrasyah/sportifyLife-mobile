import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart' hide CarouselController;
import 'package:lottie/lottie.dart';
 import '../../../app/routes.dart';

class GoalScreen extends StatefulWidget {
  const GoalScreen({super.key});

  @override
  State<GoalScreen> createState() => _GoalScreenState();
}

class _GoalScreenState extends State<GoalScreen> {
  // Color Constants - Updated to match TColor.primaryG gradient
  static const Color _white = Colors.white;
  static const Color _black = Color(0xFF1D1617);
  static const Color _gray = Color(0xFF7B6F72);

  // Primary gradient colors to match TColor.primaryG
  static const List<Color> _primaryGradient = [
    Color(0xFF92A3FD), // Light blue
    Color(0xFF9DCEFF), // Lighter blue
  ];

  // Selected goal index
  int _selectedGoalIndex = 0;

  List goalArr = [
    {
      "lottie": "assets/images/punches.json",
      "title": "Improve Shape",
      "subtitle":
          "I have a low amount of body fat\nand need / want to build more\nmuscle",
    },
    {
      "lottie": "assets/images/split_jump.json",
      "title": "Lean & Tone",
      "subtitle":
          "I'm skinny fat. look thin but have\nno shape. I want to add lean\nmuscle in the right way",
    },
    {
      "lottie": "assets/images/exercise.json",
      "title": "Lose a Fat",
      "subtitle":
          "I have over 20 lbs to lose. I want to\ndrop all this fat and gain muscle\nmass",
    },
  ];

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: _white,
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: CarouselSlider(
                items: goalArr
                    .asMap()
                    .entries
                    .map(
                      (entry) => GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedGoalIndex = entry.key;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: _primaryGradient,
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(25),
                            border: _selectedGoalIndex == entry.key
                                ? Border.all(
                                    color: _white,
                                    width: 2,
                                  ) // Selected indicator: white border
                                : null, // Unselected: no border
                            boxShadow: _selectedGoalIndex == entry.key
                                ? [
                                    BoxShadow(
                                      color: _primaryGradient[0].withOpacity(
                                        0.3,
                                      ),
                                      blurRadius: 8,
                                      spreadRadius: 1,
                                    ),
                                  ] // Selected: subtle shadow
                                : null, // Unselected: no shadow
                          ),
                          padding: EdgeInsets.symmetric(
                            vertical: media.width * 0.03,
                            horizontal: 15,
                          ),
                          alignment: Alignment.center,
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  height: media.width * 0.6,
                                  width: media.width * 0.6,
                                  child: Lottie.asset(
                                    entry.value["lottie"].toString(),
                                    fit: BoxFit.contain,
                                    repeat: true,
                                  ),
                                ),
                                SizedBox(height: media.width * 0.02),

                                // Text Content - Properly sized and centered
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Text(
                                          entry.value["title"].toString(),
                                          style: TextStyle(
                                            color: _white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w800,
                                          ),
                                          textAlign: TextAlign.center,
                                          maxLines: 1,
                                        ),
                                      ),
                                      Container(
                                        width: media.width * 0.12,
                                        height: 2,
                                        margin: const EdgeInsets.symmetric(
                                          vertical: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          color: _white,
                                          borderRadius: BorderRadius.circular(
                                            1,
                                          ),
                                        ),
                                      ),
                                      FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Text(
                                          entry.value["subtitle"].toString(),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: _white.withOpacity(0.9),
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                            height: 1.3,
                                          ),
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList(),
                options: CarouselOptions(
                  autoPlay: false,
                  enlargeCenterPage: true,
                  viewportFraction: 0.7,
                  aspectRatio: 0.74,
                  initialPage: 0,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _selectedGoalIndex = index;
                    });
                  },
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              width: media.width,
              child: Column(
                children: [
                  SizedBox(height: media.width * 0.05),
                  Text(
                    "What is your goal ?",
                    style: TextStyle(
                      color: _black,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    "It will help us to choose a best\nprogram for you",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: _gray, fontSize: 12),
                  ),
                  const Spacer(),
                  SizedBox(height: media.width * 0.05),
                  _buildRoundButton(
                    title: "Confirm",
                    onPressed: () {
                      // Get selected goal data
                      final selectedGoal = goalArr[_selectedGoalIndex];
                      print("Selected Goal: ${selectedGoal["title"]}");

                      // TODO: Save selected goal to user preferences or state management
                      // For now, navigate to welcome screen
                      Navigator.pushReplacementNamed(
                        context,
                        Routes.welcomeScreen,
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoundButton({
    required String title,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 20),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: _primaryGradient[0],
          foregroundColor: _white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          elevation: 8,
          shadowColor: _primaryGradient[0].withOpacity(0.3),
        ),
        child: Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
