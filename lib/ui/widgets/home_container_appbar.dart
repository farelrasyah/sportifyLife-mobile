import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import 'dart:math' as math;

/// Home Container AppBar - Elegant animated header component
///
/// A reusable, highly customizable AppBar widget with animated decorative elements,
/// gradient background, and floating content card. Designed for consistent
/// visual experience across Home, Activity, and Profile screens.
///
/// Features:
/// - Animated glowing effects with subtle movements
/// - Dramatic curved gradient background
/// - Enhanced wave patterns
/// - Frosted glass content card
/// - Customizable profile image, title, and actions
class HomeContainerAppbar extends StatefulWidget {
  /// Profile image URL (can be empty)
  final String profileImage;

  /// Main title text (e.g., user name)
  final String title;

  /// Welcome/greeting text
  final String welcomeText;

  /// Primary color for gradients and decorations
  final Color primaryColor;

  /// Light variant of primary color
  final Color lightColor;

  /// Dark variant of primary color
  final Color darkColor;

  /// Action button icon (default: notifications)
  final IconData actionIcon;

  /// Action button callback
  final VoidCallback? onActionPressed;

  /// Show/hide action button
  final bool showActionButton;

  /// Custom action widget (overrides actionIcon if provided)
  final Widget? customAction;

  /// Height of the AppBar (excluding status bar)
  final double height;

  /// Enable profile image tap to zoom
  final bool enableProfileZoom;

  const HomeContainerAppbar({
    super.key,
    required this.profileImage,
    required this.title,
    this.welcomeText = 'Hi, Welcome Back',
    this.primaryColor = const Color(0xFF7B8FE8),
    this.lightColor = const Color(0xFF8FA3F5),
    this.darkColor = const Color(0xFF6578DC),
    this.actionIcon = Icons.notifications_active_rounded,
    this.onActionPressed,
    this.showActionButton = true,
    this.customAction,
    this.height = 120,
    this.enableProfileZoom = true,
  });

  @override
  State<HomeContainerAppbar> createState() => _HomeContainerAppbarState();
}

class _HomeContainerAppbarState extends State<HomeContainerAppbar>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  late AnimationController _glowAnimationController;
  late AnimationController _pulseAnimationController;
  late AnimationController _rotationAnimationController;
  late Animation<double> _glowAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();

    // Add lifecycle observer
    WidgetsBinding.instance.addObserver(this);

    // Enhanced glow animation - more visible but smooth
    _glowAnimationController = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    );
    _glowAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _glowAnimationController,
        curve: Curves.easeInOutSine, // Smoother curve
      ),
    );

    // Enhanced pulse animation - more visible
    _pulseAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1800),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(begin: 0.92, end: 1.08).animate(
      CurvedAnimation(
        parent: _pulseAnimationController,
        curve: Curves.easeInOutCubic, // More elegant curve
      ),
    );

    // Enhanced rotation - more visible but still graceful
    _rotationAnimationController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    );
    _rotationAnimation = Tween<double>(begin: 0.0, end: 2 * math.pi).animate(
      CurvedAnimation(
        parent: _rotationAnimationController,
        curve: Curves.linear,
      ),
    );

    // Start animations with delays for more natural feel
    _glowAnimationController.repeat(reverse: true);
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) _pulseAnimationController.repeat(reverse: true);
    });
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted) _rotationAnimationController.repeat();
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
        _glowAnimationController.stop();
        _pulseAnimationController.stop();
        _rotationAnimationController.stop();
        break;
      case AppLifecycleState.resumed:
        if (!_glowAnimationController.isAnimating) {
          _glowAnimationController.repeat(reverse: true);
        }
        if (!_pulseAnimationController.isAnimating) {
          _pulseAnimationController.repeat(reverse: true);
        }
        if (!_rotationAnimationController.isAnimating) {
          _rotationAnimationController.repeat();
        }
        break;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _glowAnimationController.dispose();
    _pulseAnimationController.dispose();
    _rotationAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Set system UI overlay style to ensure status bar is properly handled
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    return Container(
      height: widget.height + MediaQuery.of(context).padding.top,
      width: MediaQuery.of(context).size.width,
      child: Stack(
        fit: StackFit.expand,
        clipBehavior: Clip.none,
        children: [
          // Background with dramatically curved bottom
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 0,
            child: CustomPaint(
              painter: DramaticCurvedGradientPainter(
                colors: [
                  widget.darkColor,
                  widget.primaryColor,
                  Color.lerp(widget.primaryColor, widget.lightColor, 0.5)!,
                  widget.lightColor,
                ],
                stops: const [0.0, 0.3, 0.6, 1.0],
              ),
            ),
          ),

          // Decorative design elements with enhanced animations
          Positioned.fill(
            child: AnimatedBuilder(
              animation: Listenable.merge([
                _glowAnimationController,
                _pulseAnimationController,
                _rotationAnimationController,
              ]),
              builder: (context, _) {
                return CustomPaint(
                  painter: AnimatedAppBarDecorationPainter(
                    color: Colors.white.withOpacity(
                      0.12 + (_glowAnimation.value * 0.08),
                    ),
                    glowValue: _glowAnimation.value,
                    pulseValue: _pulseAnimation.value,
                    rotationValue: _rotationAnimation.value,
                  ),
                );
              },
            ),
          ),

          // Refined animated glowing effect
          AnimatedBuilder(
            animation: Listenable.merge([
              _glowAnimationController,
              _pulseAnimationController,
            ]),
            builder: (context, _) {
              return Stack(
                children: [
                  // Primary glow circle
                  Positioned(
                    top:
                        MediaQuery.of(context).padding.top -
                        100 +
                        (math.sin(_glowAnimation.value * 2 * math.pi) * 8),
                    right:
                        -60 +
                        (math.cos(_glowAnimation.value * 2 * math.pi) * 5),
                    child: Transform.scale(
                      scale: 0.90 + (_pulseAnimation.value * 0.15),
                      child: Container(
                        width: 180,
                        height: 180,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              Colors.white.withOpacity(
                                0.22 + (_glowAnimation.value * 0.08),
                              ),
                              Colors.white.withOpacity(
                                0.12 + (_glowAnimation.value * 0.05),
                              ),
                              Colors.white.withOpacity(0.0),
                            ],
                            stops: const [0.0, 0.6, 1.0],
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Secondary glow circle
                  Positioned(
                    top:
                        MediaQuery.of(context).padding.top -
                        70 +
                        (math.sin(_glowAnimation.value * 2 * math.pi + 1.5) *
                            6),
                    left:
                        -30 +
                        (math.cos(_glowAnimation.value * 2 * math.pi + 1.5) *
                            4),
                    child: Transform.scale(
                      scale:
                          0.95 +
                          (math.sin(_pulseAnimation.value * math.pi) * 0.10),
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              Colors.white.withOpacity(
                                0.18 + (_glowAnimation.value * 0.06),
                              ),
                              Colors.white.withOpacity(
                                0.09 + (_glowAnimation.value * 0.04),
                              ),
                              Colors.white.withOpacity(0.0),
                            ],
                            stops: const [0.0, 0.7, 1.0],
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Tertiary glow circle
                  Positioned(
                    top:
                        MediaQuery.of(context).padding.top +
                        25 +
                        (math.sin(_glowAnimation.value * 2 * math.pi + 3) * 5),
                    right:
                        -15 +
                        (math.cos(_glowAnimation.value * 2 * math.pi + 3) * 4),
                    child: Transform.rotate(
                      angle: _rotationAnimation.value * 0.5,
                      child: Transform.scale(
                        scale:
                            0.85 +
                            (math.sin(_pulseAnimation.value * math.pi + 2) *
                                0.12),
                        child: Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              colors: [
                                Colors.white.withOpacity(
                                  0.14 + (_glowAnimation.value * 0.05),
                                ),
                                Colors.white.withOpacity(
                                  0.07 + (_glowAnimation.value * 0.03),
                                ),
                                Colors.white.withOpacity(0.0),
                              ],
                              stops: const [0.0, 0.8, 1.0],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),

          // Enhanced static wave pattern
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: CustomPaint(
              painter: EnhancedWavePatternPainter(
                color1: Colors.white.withOpacity(0.1),
                color2: Colors.white.withOpacity(0.07),
              ),
              child: SizedBox(
                height: 80,
                width: MediaQuery.of(context).size.width,
              ),
            ),
          ),

          // Main content container
          Positioned(
            bottom: 10,
            left: 16,
            right: 16,
            child: Container(
              height: 75,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: widget.primaryColor.withOpacity(0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                    spreadRadius: 0,
                  ),
                  BoxShadow(
                    color: widget.lightColor.withOpacity(0.15),
                    blurRadius: 25,
                    offset: const Offset(0, 10),
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Profile image
                  _buildProfileImage(),
                  const SizedBox(width: 15.0),

                  // Welcome text
                  Expanded(child: _buildWelcomeText()),

                  // Action button
                  if (widget.showActionButton) _buildActionButton(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileImage() {
    final profileWidget = Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [widget.primaryColor, widget.darkColor],
        ),
        boxShadow: [
          BoxShadow(
            color: widget.primaryColor.withOpacity(0.3),
            blurRadius: 8,
            spreadRadius: 1,
          ),
        ],
      ),
      padding: const EdgeInsets.all(2),
      child: CircleAvatar(
        backgroundColor: Colors.white,
        radius: 25,
        backgroundImage: widget.profileImage.isNotEmpty
            ? AssetImage(widget.profileImage)
            : null,
        child: widget.profileImage.isEmpty
            ? Icon(Icons.person, color: widget.primaryColor, size: 30)
            : null,
      ),
    );

    if (!widget.enableProfileZoom) {
      return profileWidget;
    }

    return GestureDetector(
      onTap: () => _showProfileZoom(context),
      child: profileWidget,
    );
  }

  Widget _buildWelcomeText() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.welcomeText,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Colors.grey[600],
            fontFamily: 'Poppins',
          ),
        ),
        Text(
          widget.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            height: 1.1,
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: widget.primaryColor,
            fontFamily: 'Poppins',
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton() {
    if (widget.customAction != null) {
      return widget.customAction!;
    }

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(15),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: widget.onActionPressed,
        child: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [widget.primaryColor, widget.darkColor],
            ),
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: widget.primaryColor.withOpacity(0.25),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Icon(widget.actionIcon, color: Colors.white, size: 24),
        ),
      ),
    );
  }

  void _showProfileZoom(BuildContext context) {
    if (widget.profileImage.isEmpty) return;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.7,
            child: Stack(
              children: [
                InteractiveViewer(
                  minScale: 0.5,
                  maxScale: 4.0,
                  child: Center(
                    child: Image.asset(
                      widget.profileImage,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => Center(
                        child: Icon(
                          Icons.error,
                          color: widget.primaryColor,
                          size: 50,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: Material(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(20),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () => Navigator.of(context).pop(),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Custom painter for dramatically curved gradient background
class DramaticCurvedGradientPainter extends CustomPainter {
  final List<Color> colors;
  final List<double> stops;

  DramaticCurvedGradientPainter({required this.colors, required this.stops});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);

    // Create gradient
    paint.shader = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: colors,
      stops: stops,
    ).createShader(rect);

    // Create dramatic double-curved path
    final path = Path();
    path.lineTo(0, size.height - 60);

    // First dramatic curve
    final firstControlPoint = Offset(size.width * 0.25, size.height + 30);
    final firstEndPoint = Offset(size.width * 0.5, size.height - 40);
    path.quadraticBezierTo(
      firstControlPoint.dx,
      firstControlPoint.dy,
      firstEndPoint.dx,
      firstEndPoint.dy,
    );

    // Second dramatic curve
    final secondControlPoint = Offset(size.width * 0.75, size.height - 110);
    final secondEndPoint = Offset(size.width, size.height - 50);
    path.quadraticBezierTo(
      secondControlPoint.dx,
      secondControlPoint.dy,
      secondEndPoint.dx,
      secondEndPoint.dy,
    );

    // Complete the path
    path.lineTo(size.width, 0);
    path.close();

    canvas.drawPath(path, paint);

    // Add dramatic highlights
    final highlightPaint = Paint()
      ..color = Colors.white.withOpacity(0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    final highlightPath = Path();
    highlightPath.moveTo(0, size.height - 58);
    highlightPath.quadraticBezierTo(
      firstControlPoint.dx,
      firstControlPoint.dy - 4,
      firstEndPoint.dx,
      firstEndPoint.dy - 3,
    );
    highlightPath.quadraticBezierTo(
      secondControlPoint.dx,
      secondControlPoint.dy - 3,
      secondEndPoint.dx,
      secondEndPoint.dy - 3,
    );

    canvas.drawPath(highlightPath, highlightPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Enhanced wave pattern painter
class EnhancedWavePatternPainter extends CustomPainter {
  final Color color1;
  final Color color2;

  EnhancedWavePatternPainter({required this.color1, required this.color2});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()..style = PaintingStyle.fill;

    // First enhanced wave
    final path = Path();
    path.moveTo(0, size.height * 0.3);

    path.cubicTo(
      size.width * 0.15,
      size.height * 0.1,
      size.width * 0.35,
      size.height * 0.6,
      size.width * 0.5,
      size.height * 0.2,
    );

    path.cubicTo(
      size.width * 0.65,
      size.height * -0.2,
      size.width * 0.85,
      size.height * 0.4,
      size.width,
      size.height * 0.3,
    );

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    paint.color = color1;
    canvas.drawPath(path, paint);

    // Second enhanced wave
    final secondPath = Path();
    secondPath.moveTo(0, size.height * 0.5);

    secondPath.cubicTo(
      size.width * 0.2,
      size.height * 0.3,
      size.width * 0.4,
      size.height * 0.8,
      size.width * 0.6,
      size.height * 0.4,
    );

    secondPath.cubicTo(
      size.width * 0.75,
      size.height * 0.1,
      size.width * 0.9,
      size.height * 0.6,
      size.width,
      size.height * 0.35,
    );

    secondPath.lineTo(size.width, size.height);
    secondPath.lineTo(0, size.height);
    secondPath.close();

    paint.color = color2;
    canvas.drawPath(secondPath, paint);

    // Add decorative circles
    final circlePaint = Paint()
      ..color = color1
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(size.width * 0.85, size.height * 0.2),
      25,
      circlePaint,
    );
    canvas.drawCircle(
      Offset(size.width * 0.15, size.height * 0.7),
      20,
      circlePaint,
    );
    canvas.drawCircle(
      Offset(size.width * 0.6, size.height * 0.6),
      15,
      circlePaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Enhanced custom painter for animated decorative elements
class AnimatedAppBarDecorationPainter extends CustomPainter {
  final Color color;
  final double glowValue;
  final double pulseValue;
  final double rotationValue;

  AnimatedAppBarDecorationPainter({
    required this.color,
    required this.glowValue,
    required this.pulseValue,
    required this.rotationValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final glowPaint = Paint()
      ..color = color.withOpacity(color.opacity * (0.3 + glowValue * 0.3))
      ..style = PaintingStyle.fill
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);

    // Refined animated decorative circles
    final circles = [
      {
        'center': Offset(
          size.width * (0.88 + math.sin(glowValue * 2 * math.pi) * 0.01),
          size.height * (0.22 + math.cos(glowValue * 2 * math.pi) * 0.008),
        ),
        'radius': 25 * (0.9 + math.sin(pulseValue * math.pi) * 0.15),
        'hasGlow': true,
      },
      {
        'center': Offset(
          size.width * (0.12 + math.cos(glowValue * 2 * math.pi + 1.5) * 0.008),
          size.height * (0.78 + math.sin(glowValue * 2 * math.pi + 1.5) * 0.01),
        ),
        'radius': 18 * (0.95 + math.sin(pulseValue * math.pi + 0.5) * 0.1),
        'hasGlow': false,
      },
      {
        'center': Offset(
          size.width * (0.52 + math.sin(glowValue * 2 * math.pi + 3) * 0.012),
          size.height * (0.18 + math.cos(glowValue * 2 * math.pi + 3) * 0.006),
        ),
        'radius': 12 * (1.0 + math.sin(pulseValue * math.pi + 1) * 0.2),
        'hasGlow': true,
      },
    ];

    // Draw refined animated circles
    for (var circle in circles) {
      final center = circle['center'] as Offset;
      final radius = circle['radius'] as double;
      final hasGlow = circle['hasGlow'] as bool;

      if (hasGlow) {
        canvas.drawCircle(center, radius * 1.3, glowPaint);
      }
      canvas.drawCircle(center, radius, paint);
    }

    // Refined animated arcs
    final arcPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5 + glowValue * 0.5;

    final arcRect = Rect.fromLTRB(
      size.width * (0.12 + math.sin(glowValue * 2 * math.pi) * 0.02),
      size.height * (0.25 + math.cos(glowValue * 2 * math.pi) * 0.015),
      size.width * (0.58 + math.sin(glowValue * 2 * math.pi + 1) * 0.025),
      size.height * (0.58 + math.cos(glowValue * 2 * math.pi + 1) * 0.02),
    );

    final arcSweep = 1.2 + math.sin(glowValue * 2 * math.pi) * 0.2;
    final arcStart = 0.3 + rotationValue * 0.05;

    canvas.drawArc(arcRect, arcStart, arcSweep, false, arcPaint);
  }

  @override
  bool shouldRepaint(covariant AnimatedAppBarDecorationPainter oldDelegate) {
    return oldDelegate.glowValue != glowValue ||
        oldDelegate.pulseValue != pulseValue ||
        oldDelegate.rotationValue != rotationValue;
  }
}
