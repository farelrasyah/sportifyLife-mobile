import 'package:flutter/material.dart';
import '../theme/color_palette.dart';
import '../theme/typography.dart';

class AnimatedLoginButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;
  final Color? primaryColor;
  final Color? secondaryColor;
  final double? height;
  final double? borderRadius;

  const AnimatedLoginButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.icon,
    this.primaryColor,
    this.secondaryColor,
    this.height,
    this.borderRadius,
  }) : super(key: key);

  @override
  State<AnimatedLoginButton> createState() => _AnimatedLoginButtonState();
}

class _AnimatedLoginButtonState extends State<AnimatedLoginButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<Offset> _slideAnimation;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimation();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: const Interval(0.0, 0.8, curve: Curves.easeOutCubic),
          ),
        );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.2, 1.0, curve: Curves.easeOutBack),
      ),
    );
  }

  void _startAnimation() {
    Future.delayed(const Duration(milliseconds: 1000), () {
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
    final primaryColor = widget.primaryColor ?? ColorPalette.kAuthButtonPrimary;
    final secondaryColor =
        widget.secondaryColor ?? ColorPalette.kAuthInputFocused;

    return SlideTransition(
      position: _slideAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          width: double.infinity,
          height: widget.height ?? (isSmallScreen ? 56 : 62),
          margin: EdgeInsets.only(top: isSmallScreen ? 8 : 18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius ?? 22),
            boxShadow: [
              BoxShadow(
                color: primaryColor.withOpacity(0.3),
                blurRadius: 15,
                offset: const Offset(0, 8),
                spreadRadius: 1,
              ),
            ],
            gradient: LinearGradient(
              colors: [
                secondaryColor,
                primaryColor,
                primaryColor.withOpacity(0.8),
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: widget.isLoading ? null : widget.onPressed,
              borderRadius: BorderRadius.circular(widget.borderRadius ?? 22),
              splashColor: Colors.white.withOpacity(0.2),
              highlightColor: Colors.white.withOpacity(0.1),
              child: Center(
                child: widget.isLoading
                    ? const SizedBox(
                        width: 26,
                        height: 26,
                        child: CircularProgressIndicator(
                          strokeWidth: 3,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            widget.text,
                            style: AppTypography.authButtonText.copyWith(
                              fontSize: 18,
                              letterSpacing: 0.5,
                            ),
                          ),
                          if (widget.icon != null) ...[
                            const SizedBox(width: 10),
                            Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                widget.icon,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ],
                        ],
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
