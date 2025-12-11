import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart' hide CarouselController;
import '../../app/routes.dart';

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

  List goalArr = [
    {
      "image": "assets/images/goal_1.png",
      "title": "Improve Shape",
      "subtitle":
          "I have a low amount of body fat\nand need / want to build more\nmuscle",
    },
    {
      "image": "assets/images/goal_2.png",
      "title": "Lean & Tone",
      "subtitle":
          "I'm skinny fat. look thin but have\nno shape. I want to add lean\nmuscle in the right way",
    },
    {
      "image": "assets/images/goal_3.png",
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
                    .map(
                      (gObj) => Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: _primaryGradient,
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        padding: EdgeInsets.symmetric(
                          vertical: media.width * 0.1,
                          horizontal: 25,
                        ),
                        alignment: Alignment.center,
                        child: FittedBox(
                          child: Column(
                            children: [
                              Image.asset(
                                gObj["image"].toString(),
                                width: media.width * 0.5,
                                fit: BoxFit.fitWidth,
                              ),
                              SizedBox(height: media.width * 0.1),
                              Text(
                                gObj["title"].toString(),
                                style: TextStyle(
                                  color: _white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Container(
                                width: media.width * 0.1,
                                height: 1,
                                color: _white,
                              ),
                              SizedBox(height: media.width * 0.02),
                              Text(
                                gObj["subtitle"].toString(),
                                textAlign: TextAlign.center,
                                style: TextStyle(color: _white, fontSize: 12),
                              ),
                            ],
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
                      Navigator.pushReplacementNamed(
                        context,
                        Routes.homeScreen,
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
