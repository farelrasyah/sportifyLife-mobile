import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/color_palette.dart';
import '../theme/spacing.dart';
import '../theme/app_theme.dart';
import '../widgets/logo_widget.dart';
import '../widgets/primary_button.dart';

/// Welcome screen with pixel-perfect design matching the provided image
/// Features gradient background, animated logo, and call-to-action button
class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with TickerProviderStateMixin {
  late AnimationController _backgroundController;
  late AnimationController _buttonController;
  late Animation<double> _backgroundAnimation;
  late Animation<double> _buttonAnimation;
  late Animation<Offset> _buttonSlideAnimation;

  @override
  void initState() {
    super.initState();

    // Set system UI overlay style for gradient background
    SystemChrome.setSystemUIOverlayStyle(AppTheme.gradientSystemUiOverlayStyle);

    // Background animation controller
    _backgroundController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    // Button animation controller
    _buttonController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    // Background fade animation
    _backgroundAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _backgroundController, curve: Curves.easeOut),
    );

    // Button fade animation
    _buttonAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _buttonController, curve: Curves.easeOut),
    );

    // Button slide animation
    _buttonSlideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _buttonController,
            curve: Curves.easeOutCubic,
          ),
        );

    // Start animations with delay
    _startAnimations();
  }

  void _startAnimations() async {
    await _backgroundController.forward();
    await Future.delayed(const Duration(milliseconds: 800));
    await _buttonController.forward();
  }

  @override
  void dispose() {
    _backgroundController.dispose();
    _buttonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _backgroundController,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              gradient: ColorPalette.kPrimaryGradient.scale(
                _backgroundAnimation.value,
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: Spacing.screenAll,
                child: Column(
                  children: [
                    // Top spacer to center content vertically
                    const Spacer(flex: 2),

                    // Logo and tagline
                    const LogoWidget(animate: true),

                    // Bottom spacer
                    const Spacer(flex: 3),

                    // Get Started button with animation
                    AnimatedBuilder(
                      animation: _buttonController,
                      builder: (context, child) {
                        return FadeTransition(
                          opacity: _buttonAnimation,
                          child: SlideTransition(
                            position: _buttonSlideAnimation,
                            child: PrimaryButton(
                              text: 'Get Started',
                              onPressed: _onGetStartedPressed,
                            ),
                          ),
                        );
                      },
                    ),

                    // Bottom padding
                    Spacing.verticalXXL,
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _onGetStartedPressed() {
    // Add haptic feedback
    HapticFeedback.lightImpact();

    // Navigate to next screen (placeholder for now)
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Welcome to SportifyLife!'),
        duration: Duration(seconds: 2),
      ),
    );

    // TODO: Navigate to login/register screen
    // Navigator.pushNamed(context, '/auth');
  }
}

/// Extension to scale gradient opacity
extension GradientExtension on LinearGradient {
  LinearGradient scale(double opacity) {
    return LinearGradient(
      begin: begin,
      end: end,
      colors: colors.map((color) => color.withOpacity(opacity)).toList(),
      stops: stops,
    );
  }
}
