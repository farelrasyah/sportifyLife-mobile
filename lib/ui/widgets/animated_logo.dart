import 'package:flutter/material.dart';
import '../theme/color_palette.dart';

class AnimatedLogo extends StatefulWidget {
  final double size;
  final IconData icon;
  final Color? primaryColor;
  final Color? secondaryColor;
  final Color? backgroundColor;

  const AnimatedLogo({
    Key? key,
    this.size = 110,
    this.icon = Icons.fitness_center,
    this.primaryColor,
    this.secondaryColor,
    this.backgroundColor,
  }) : super(key: key);

  @override
  State<AnimatedLogo> createState() => _AnimatedLogoState();
}

class _AnimatedLogoState extends State<AnimatedLogo>
    with TickerProviderStateMixin {
  late final AnimationController _logoAnimationController;
  late final AnimationController _floatingController;

  late final Animation<double> _logoScaleAnimation;
  late final Animation<double> _logoRotateAnimation;
  late final Animation<double> _logoGlowAnimation;
  late final Animation<double> _floatAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimations();
  }

  void _initializeAnimations() {
    _logoAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    _floatingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    )..repeat(reverse: true);

    _logoScaleAnimation =
        TweenSequence<double>([
          TweenSequenceItem(
            tween: Tween<double>(begin: 0.0, end: 1.2),
            weight: 40,
          ),
          TweenSequenceItem(
            tween: Tween<double>(begin: 1.2, end: 1.0),
            weight: 60,
          ),
        ]).animate(
          CurvedAnimation(
            parent: _logoAnimationController,
            curve: const Interval(0.0, 0.6, curve: Curves.easeInOut),
          ),
        );

    _logoRotateAnimation = Tween<double>(begin: 0.0, end: 0.1).animate(
      CurvedAnimation(
        parent: _logoAnimationController,
        curve: const Interval(0.3, 0.6, curve: Curves.elasticOut),
      ),
    );

    _logoGlowAnimation =
        TweenSequence<double>([
          TweenSequenceItem(
            tween: Tween<double>(begin: 0.0, end: 4.0),
            weight: 40,
          ),
          TweenSequenceItem(
            tween: Tween<double>(begin: 4.0, end: 0.0),
            weight: 60,
          ),
        ]).animate(
          CurvedAnimation(
            parent: _logoAnimationController,
            curve: const Interval(0.0, 1.0, curve: Curves.easeInOut),
          ),
        );

    _floatAnimation = Tween<double>(begin: -3.0, end: 7.0).animate(
      CurvedAnimation(parent: _floatingController, curve: Curves.easeInOut),
    );
  }

  void _startAnimations() {
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        _logoAnimationController.forward();
      }
    });
  }

  @override
  void dispose() {
    _logoAnimationController.dispose();
    _floatingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = widget.primaryColor ?? ColorPalette.kAuthButtonPrimary;
    final secondaryColor =
        widget.secondaryColor ?? ColorPalette.kAuthInputFocused;
    final backgroundColor = widget.backgroundColor ?? Colors.white;

    return AnimatedBuilder(
      animation: Listenable.merge([
        _logoAnimationController,
        _floatingController,
      ]),
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _floatAnimation.value),
          child: Transform.scale(
            scale: _logoScaleAnimation.value,
            child: Transform.rotate(
              angle: _logoRotateAnimation.value,
              child: Container(
                width: widget.size,
                height: widget.size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: backgroundColor,
                  boxShadow: [
                    BoxShadow(
                      color: primaryColor.withOpacity(0.3),
                      blurRadius: 15 + _logoGlowAnimation.value,
                      spreadRadius: 3 + _logoGlowAnimation.value / 2,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Center(
                  child: Container(
                    width: widget.size - 14,
                    height: widget.size - 14,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          secondaryColor,
                          primaryColor,
                          primaryColor.withOpacity(0.8),
                        ],
                        center: Alignment.topLeft,
                        radius: 1.0,
                        stops: const [0.2, 0.5, 0.9],
                      ),
                    ),
                    child: Icon(
                      widget.icon,
                      size: widget.size * 0.45,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
