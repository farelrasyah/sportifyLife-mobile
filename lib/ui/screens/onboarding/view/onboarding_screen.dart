import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:lottie/lottie.dart';
import 'package:rive/rive.dart' as rive;
import 'package:sportifylife/ui/screens/onboarding/model/onboarding_model.dart';
import 'package:sportifylife/app/routes.dart';

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
    // Slide 1: Soft deep blue gradient (kontras dengan light blue background #E1F5FE)
    [Color(0xFF42A5F5), Color(0xFF1976D2)],
    // Slide 2: Soft medium blue gradient (kontras dengan medium blue background #B3E5FC)
    [Color(0xFF1E88E5), Color(0xFF1565C0)],
    // Slide 3: Soft darker blue gradient (kontras dengan deeper blue background #81D4FA)
    [Color(0xFF1976D2), Color(0xFF0D47A1)],
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
                      _buildAnimationWidget(page, size),
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
                            // Navigate to register screen
                            Navigator.of(
                              context,
                            ).pushReplacementNamed(Routes.registerScreen);
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
                // Navigate to register screen
                Navigator.of(
                  context,
                ).pushReplacementNamed(Routes.registerScreen);
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

  /// Build animation widget based on asset type
  Widget _buildAnimationWidget(OnboardingPageData page, Size size) {
    switch (page.assetType) {
      case 'rive':
        return SizedBox(
          height: size.height * 0.4,
          child: rive.RiveAnimation.asset(page.assetPath, fit: BoxFit.contain),
        );
      case 'lottie':
        return Lottie.asset(
          page.assetPath,
          height: size.height * 0.4,
          fit: BoxFit.contain,
        );
      case 'gif':
      default:
        return Image.asset(
          page.assetPath,
          height: size.height * 0.4,
          fit: BoxFit.contain,
        );
    }
  }
}
