import 'package:sportifylife/ui/screens/onboarding/model/onboarding_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:liquid_swipe/liquid_swipe.dart';

import 'package:lottie/lottie.dart';

class AnimatedOnboardingScreen extends StatefulWidget {
  const AnimatedOnboardingScreen({Key? key}) : super(key: key);

  @override
  State<AnimatedOnboardingScreen> createState() =>
      _AnimatedOnboardingScreenState();
}

class _AnimatedOnboardingScreenState extends State<AnimatedOnboardingScreen> {
  late LiquidController _liquidController;
  int currentPage = 0;

  @override
  void initState() {
    _liquidController = LiquidController();
    super.initState();
  }

  final List<List<Color>> buttonGradients = [
    [Color(0xFFFF66B2), Color(0xFFFF0080)],
    [Color(0xFFFDC830), Color(0xFFF37335)],
    [Color(0xFF00c6ff), Color(0xFF0072ff)],
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          LiquidSwipe.builder(
            itemCount: onboardingPages.length,
            itemBuilder: (context, index) {
              final page = onboardingPages[index];

              return Container(
                width: double.infinity,
                color: page.backgroundColor,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      page.assetType == 'gif'
                          ? Image.asset(
                              page.assetPath,
                              height: size.height * 0.4,
                              fit: BoxFit.contain,
                            )
                          : Lottie.asset(
                              page.assetPath,
                              height: size.height * 0.4,
                              fit: BoxFit.contain,
                            ),
                      SizedBox(height: 20),
                      Text(
                        page.title,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: size.width * 0.06,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        page.description,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: size.width * 0.035,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 30),
                      GestureDetector(
                        onTap: () {
                          if (index < onboardingPages.length - 1) {
                            _liquidController.animateToPage(
                              page: index + 1,
                              duration: 700,
                            );
                          } else {
                            // Navigate to main app screen
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            vertical: 14,
                            horizontal: size.width * 0.25,
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors:
                                  buttonGradients[index %
                                      buttonGradients.length],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color:
                                    buttonGradients[index %
                                            buttonGradients.length][1]
                                        .withOpacity(0.5),
                                blurRadius: 10,
                                offset: Offset(0, 5),
                              ),
                            ],
                            borderRadius: BorderRadius.circular(30),
                          ),

                          child: Text(
                            page.buttonText,
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: size.width * 0.045,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
            liquidController: _liquidController,
            waveType: WaveType.liquidReveal,
            fullTransitionValue: 880,
            enableSideReveal: true,
            enableLoop: false,
            slideIconWidget: currentPage == onboardingPages.length - 1
                ? null
                : Icon(Icons.arrow_back_ios, color: Colors.white),
            onPageChangeCallback: (page) {
              setState(() {
                currentPage = page;
              });
            },
          ),
          // SkipButton(onTap: (){}),
          Positioned(
            top: size.height * 0.06,
            right: 25,
            child: GestureDetector(
              onTap: () {
                // Navigate to home or main screen
              },
              child: Text(
                "Skip",
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: size.width * 0.045,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
