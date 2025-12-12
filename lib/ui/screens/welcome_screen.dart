import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../../app/routes.dart';
import '../../common/colo_extension.dart';
import '../widgets/round_button.dart';

/// Welcome screen displayed after user completes goal selection
/// Shows a congratulatory message with Lottie animation and navigation to home
class WelcomeView extends StatefulWidget {
  const WelcomeView({super.key});

  @override
  State<WelcomeView> createState() => _WelcomeViewState();
}

class _WelcomeViewState extends State<WelcomeView> {
  static const double _horizontalPadding = 25.0;
  static const double _verticalPadding = 15.0;
  static const double _topSpacingMultiplier = 0.15;
  static const double _lottieWidthMultiplier = 2.0;
  static const double _bottomSpacingMultiplier = 0.05;

  static const String _welcomeTitle = "Welcome, Farasyah";
  static const String _welcomeSubtitle =
      "You are all set now, let's reach your\ngoals together with us";
  static const String _buttonTitle = "Go To Home";
  static const String _lottieAssetPath = "assets/images/people.json";

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: TColor.white,
      body: SafeArea(
        child: Container(
          width: media.width,
          padding: const EdgeInsets.symmetric(
            vertical: _verticalPadding,
            horizontal: _horizontalPadding,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              _buildTopSpacing(media),
              _buildLottieAnimation(media),
              _buildBottomSpacing(media),
              _buildWelcomeTitle(),
              _buildWelcomeSubtitle(),
              const Spacer(),
              _buildGoToHomeButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopSpacing(Size media) {
    return SizedBox(height: media.height * _topSpacingMultiplier);
  }

  Widget _buildLottieAnimation(Size media) {
    return Lottie.asset(
      _lottieAssetPath,
      width: media.width * _lottieWidthMultiplier,
      fit: BoxFit.fitWidth,
    );
  }

  Widget _buildBottomSpacing(Size media) {
    return SizedBox(height: media.height * _bottomSpacingMultiplier);
  }

  Widget _buildWelcomeTitle() {
    return Text(
      _welcomeTitle,
      style: TextStyle(
        color: TColor.black,
        fontSize: 20,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  Widget _buildWelcomeSubtitle() {
    return Text(
      _welcomeSubtitle,
      textAlign: TextAlign.center,
      style: TextStyle(color: TColor.gray, fontSize: 12),
    );
  }

  Widget _buildGoToHomeButton() {
    return RoundButton(title: _buttonTitle, onPressed: _navigateToHome);
  }

  void _navigateToHome() {
    Navigator.pushReplacementNamed(context, Routes.mainBottomNavigationScreen);
  }
}
