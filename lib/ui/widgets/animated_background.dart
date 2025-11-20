import 'dart:ui';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/color_palette.dart';

class AnimatedBackground extends StatefulWidget {
  final Widget child;

  const AnimatedBackground({Key? key, required this.child}) : super(key: key);

  @override
  State<AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground>
    with TickerProviderStateMixin {
  late final AnimationController _backgroundAnimationController;
  late final AnimationController _floatingElementsController;

  late final Animation<double> _backgroundFadeAnimation;
  late final Animation<double> _blurAnimation;
  late final Animation<double> _float1;
  late final Animation<double> _float2;
  late final Animation<double> _float3;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimations();
  }

  void _initializeAnimations() {
    _backgroundAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    _floatingElementsController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    )..repeat(reverse: true);

    _backgroundFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _backgroundAnimationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _blurAnimation = Tween<double>(begin: 0.0, end: 3.0).animate(
      CurvedAnimation(
        parent: _backgroundAnimationController,
        curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
      ),
    );

    _float1 = Tween<double>(begin: -5.0, end: 5.0).animate(
      CurvedAnimation(
        parent: _floatingElementsController,
        curve: Curves.easeInOut,
      ),
    );

    _float2 = Tween<double>(begin: -3.0, end: 7.0).animate(
      CurvedAnimation(
        parent: _floatingElementsController,
        curve: Curves.easeInOut,
      ),
    );

    _float3 = Tween<double>(begin: 2.0, end: -6.0).animate(
      CurvedAnimation(
        parent: _floatingElementsController,
        curve: Curves.easeInOut,
      ),
    );
  }

  void _startAnimations() {
    _backgroundAnimationController.forward();
    _floatingElementsController.forward();
  }

  @override
  void dispose() {
    _backgroundAnimationController.dispose();
    _floatingElementsController.dispose();
    super.dispose();
  }

  Widget _buildFloatingElement({
    required double top,
    required double left,
    required double size,
    required Color color,
    required Animation<double> animation,
    double? angle,
  }) {
    return Positioned(
      top: top,
      left: left,
      child: AnimatedBuilder(
        animation: _floatingElementsController,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, animation.value),
            child: Transform.rotate(
              angle: angle ?? 0,
              child: FadeTransition(
                opacity: _backgroundFadeAnimation,
                child: Container(
                  width: size,
                  height: size,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(size / 2),
                    boxShadow: [
                      BoxShadow(
                        color: color.withOpacity(0.3),
                        blurRadius: 10,
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildGradientDecorativeElement({
    required double top,
    required double left,
    required double size,
    required List<Color> colors,
    required Animation<double> animation,
    required double angle,
  }) {
    return Positioned(
      top: top,
      left: left,
      child: AnimatedBuilder(
        animation: _floatingElementsController,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, animation.value),
            child: Transform.rotate(
              angle: angle,
              child: FadeTransition(
                opacity: _backgroundFadeAnimation,
                child: Container(
                  width: size,
                  height: size,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: colors,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(size / 3),
                    boxShadow: [
                      BoxShadow(
                        color: colors.first.withOpacity(0.3),
                        blurRadius: 15,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Stack(
      children: [
        // Background gradient
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                ColorPalette.kAuthBackground,
                ColorPalette.kAuthInputFill,
                ColorPalette.kAuthBackground,
              ],
              stops: [0.0, 0.6, 1.0],
            ),
          ),
        ),

        // Decorative floating elements using app colors
        _buildFloatingElement(
          top: -40,
          left: -30,
          size: screenWidth * 0.4,
          color: ColorPalette.kAuthButtonPrimary.withOpacity(0.15),
          animation: _float1,
        ),

        _buildGradientDecorativeElement(
          top: screenHeight * 0.12,
          left: screenWidth * 0.7,
          size: screenWidth * 0.3,
          colors: [
            ColorPalette.kAuthButtonPrimary.withOpacity(0.4),
            ColorPalette.kAuthInputFocused.withOpacity(0.1),
          ],
          animation: _float2,
          angle: -math.pi / 6,
        ),

        _buildFloatingElement(
          top: screenHeight * 0.55,
          left: -screenWidth * 0.15,
          size: screenWidth * 0.3,
          color: ColorPalette.kAuthLinkText.withOpacity(0.1),
          animation: _float3,
          angle: math.pi / 4,
        ),

        _buildGradientDecorativeElement(
          top: screenHeight * 0.75,
          left: screenWidth * 0.6,
          size: screenWidth * 0.4,
          colors: [
            ColorPalette.kAuthButtonPrimary.withOpacity(0.1),
            ColorPalette.kAuthInputFocused.withOpacity(0.05),
          ],
          animation: _float1,
          angle: math.pi / 8,
        ),

        // Small floating dots
        for (int i = 0; i < 8; i++)
          _buildFloatingElement(
            top: screenHeight * (0.2 + i * 0.1) % screenHeight,
            left: screenWidth * (0.1 + i * 0.12) % screenWidth,
            size: 8 + (i % 4) * 3,
            color: i % 3 == 0
                ? ColorPalette.kAuthButtonPrimary.withOpacity(0.2)
                : i % 3 == 1
                ? ColorPalette.kAuthLinkText.withOpacity(0.3)
                : ColorPalette.kAuthInputFocused.withOpacity(0.3),
            animation: i % 3 == 0
                ? _float1
                : i % 3 == 1
                ? _float2
                : _float3,
          ),

        // Blur effect
        AnimatedBuilder(
          animation: _backgroundAnimationController,
          builder: (context, child) {
            return BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: _blurAnimation.value,
                sigmaY: _blurAnimation.value,
              ),
              child: Container(color: Colors.transparent),
            );
          },
        ),

        // Child content
        widget.child,
      ],
    );
  }
}
