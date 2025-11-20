import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/color_palette.dart';

class GlassmorphismContainer extends StatefulWidget {
  final Widget child;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final double borderRadius;
  final double opacity;
  final double blurSigma;

  const GlassmorphismContainer({
    Key? key,
    required this.child,
    this.margin,
    this.padding,
    this.borderRadius = 28.0,
    this.opacity = 0.75,
    this.blurSigma = 10.0,
  }) : super(key: key);

  @override
  State<GlassmorphismContainer> createState() => _GlassmorphismContainerState();
}

class _GlassmorphismContainerState extends State<GlassmorphismContainer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _slideAnimation;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimations();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _slideAnimation = Tween<double>(begin: 0.3, end: 0.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.2, 0.7, curve: Curves.easeOut),
      ),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.2, 0.7, curve: Curves.easeOut),
      ),
    );
  }

  void _startAnimations() {
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        _animationController.forward();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;

    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: Offset(0, _slideAnimation.value),
          end: Offset.zero,
        ).animate(_animationController),
        child: Container(
          margin:
              widget.margin ??
              EdgeInsets.symmetric(
                horizontal: isSmallScreen ? 16.0 : 24.0,
                vertical: isSmallScreen ? 10.0 : 20.0,
              ),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(widget.opacity),
            borderRadius: BorderRadius.circular(widget.borderRadius),
            border: Border.all(
              color: Colors.white.withOpacity(0.5),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: ColorPalette.kAuthButtonPrimary.withOpacity(0.1),
                blurRadius: 20,
                spreadRadius: 2,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: widget.blurSigma,
                sigmaY: widget.blurSigma,
              ),
              child: Padding(
                padding:
                    widget.padding ??
                    EdgeInsets.all(isSmallScreen ? 20.0 : 28.0),
                child: widget.child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
