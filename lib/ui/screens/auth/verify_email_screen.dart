import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../common/colo_extension.dart';
import '../../../common_widget/round_button.dart';
import '../../../cubits/verify_cubit.dart';
import '../../../cubits/auth_cubit.dart';
import '../../../app/routes.dart';
import '../../../utils/storage_helper.dart';
import '../../../data/models/user_model.dart';

class VerifyEmailScreen extends StatefulWidget {
  final String email;

  const VerifyEmailScreen({Key? key, required this.email}) : super(key: key);

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _scaleController;
  late AnimationController _pulseController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _initializeVerification();
  }

  void _initializeAnimations() {
    // Fade animation
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeOut));

    // Scale animation
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeOutBack),
    );

    // Pulse animation for timer
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _fadeController.forward();
    _scaleController.forward();
  }

  Future<void> _initializeVerification() async {
    final expiry = await StorageHelper().getVerificationExpiry();
    final expiryTime = expiry ?? DateTime.now().add(const Duration(minutes: 1));

    if (expiry == null) {
      await StorageHelper().saveVerificationExpiry(expiryTime);
    }

    if (mounted) {
      context.read<VerifyCubit>().startVerificationFlow(
        widget.email,
        expiryTime,
      );
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  Future<void> _openEmailApp() async {
    final Uri emailUri = Uri(scheme: 'mailto');
    try {
      if (await canLaunchUrl(emailUri)) {
        await launchUrl(emailUri);
      } else {
        _showSnackBar('Could not open email app', isError: true);
      }
    } catch (e) {
      _showSnackBar('Error opening email app', isError: true);
    }
  }

  Future<void> _resendVerification() async {
    context.read<VerifyCubit>().resendVerification(widget.email);
    final newExpiry = DateTime.now().add(const Duration(minutes: 1));
    await StorageHelper().saveVerificationExpiry(newExpiry);
    _showSnackBar('Verification email sent!', isError: false);
  }

  void _checkStatus() {
    context.read<VerifyCubit>().checkVerificationStatus();
  }

  void _showSnackBar(String message, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        duration: Duration(seconds: isError ? 4 : 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _handleVerificationSuccess(UserModel user) async {
    _showSnackBar('Email verified! Logging you in...', isError: false);
    context.read<AuthCubit>().updateUserAfterVerification(user);
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      Navigator.of(context).pushReplacementNamed(Routes.completeProfileScreen);
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _scaleController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: TColor.white,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: TColor.white.withOpacity(0.9),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: TColor.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(Icons.arrow_back, color: TColor.black, size: 20),
          ),
          onPressed: () {
            Navigator.of(context).pushReplacementNamed(Routes.loginScreen);
          },
        ),
      ),
      body: BlocConsumer<VerifyCubit, VerifyState>(
        listener: (context, state) {
          if (state is VerifySuccess) {
            _handleVerificationSuccess(state.user);
          } else if (state is VerifyError) {
            _showSnackBar(state.error, isError: true);
          }
        },
        builder: (context, state) {
          return Stack(
            children: [
              // Gradient Background
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      TColor.primary.withOpacity(0.05),
                      TColor.secondary.withOpacity(0.05),
                      TColor.white,
                    ],
                    stops: const [0.0, 0.3, 0.7],
                  ),
                ),
              ),

              // Main Content
              SingleChildScrollView(
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        SizedBox(height: 20),

                        // Animated Header
                        FadeTransition(
                          opacity: _fadeAnimation,
                          child: Column(
                            children: [
                              Text(
                                "Verify Your Email",
                                style: TextStyle(
                                  color: TColor.black,
                                  fontSize: 28,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: -0.5,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                "We've sent a verification link to",
                                style: TextStyle(
                                  color: TColor.gray,
                                  fontSize: 14,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      TColor.primary.withOpacity(0.1),
                                      TColor.secondary.withOpacity(0.1),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  widget.email,
                                  style: TextStyle(
                                    color: TColor.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 30),

                        // Animated Lottie
                        ScaleTransition(
                          scale: _scaleAnimation,
                          child: Container(
                            height: media.width * 0.6,
                            width: media.width * 0.6,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: [
                                  TColor.primary.withOpacity(0.1),
                                  TColor.secondary.withOpacity(0.1),
                                ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: TColor.primary.withOpacity(0.2),
                                  blurRadius: 30,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: Lottie.asset(
                              'assets/images/verification.json',
                              fit: BoxFit.contain,
                              repeat: true,
                              animate: true,
                            ),
                          ),
                        ),

                        SizedBox(height: 30),

                        // Status Card with Animation
                        _buildStatusCard(state),

                        SizedBox(height: 30),

                        // Premium Instructions Card
                        _buildInstructionsCard(),

                        SizedBox(height: 30),

                        // Action Buttons with Stagger Animation
                        _buildActionButtons(state),

                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildStatusCard(VerifyState state) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 600),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: TColor.white,
          borderRadius: BorderRadius.circular(20),
          gradient: state is VerifyExpired
              ? LinearGradient(
                  colors: [
                    Colors.orange.withOpacity(0.1),
                    Colors.orange.withOpacity(0.05),
                  ],
                )
              : LinearGradient(
                  colors: [
                    TColor.primary.withOpacity(0.1),
                    TColor.secondary.withOpacity(0.05),
                  ],
                ),
          boxShadow: [
            BoxShadow(
              color: TColor.black.withOpacity(0.08),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: _buildStatusContent(state),
      ),
    );
  }

  Widget _buildStatusContent(VerifyState state) {
    if (state is VerifyPending) {
      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.access_time, color: TColor.primary, size: 24),
              SizedBox(width: 12),
              Text(
                "Expires in",
                style: TextStyle(
                  color: TColor.gray,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          ScaleTransition(
            scale: _pulseAnimation,
            child: Text(
              _formatDuration(state.remainingTime),
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.w800,
                foreground: Paint()
                  ..shader = LinearGradient(
                    colors: [TColor.primary, TColor.secondary],
                  ).createShader(const Rect.fromLTWH(0, 0, 200, 70)),
              ),
            ),
          ),
          if (state.isChecking) ...[
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation(TColor.primary),
                  ),
                ),
                SizedBox(width: 12),
                Text(
                  "Checking status...",
                  style: TextStyle(
                    fontSize: 14,
                    color: TColor.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ],
      );
    } else if (state is VerifyExpired) {
      return Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.access_time, color: Colors.orange, size: 40),
          ),
          SizedBox(height: 16),
          Text(
            "Link Expired",
            style: TextStyle(
              fontSize: 20,
              color: Colors.orange,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: 8),
          Text(
            "Please request a new verification email",
            style: TextStyle(fontSize: 13, color: TColor.gray),
            textAlign: TextAlign.center,
          ),
        ],
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildInstructionsCard() {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 700),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: TColor.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: TColor.gray.withOpacity(0.2), width: 1),
          boxShadow: [
            BoxShadow(
              color: TColor.black.withOpacity(0.05),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInstructionItem(
              Icons.email_outlined,
              "Check your email inbox",
              0,
            ),
            SizedBox(height: 12),
            _buildInstructionItem(
              Icons.touch_app_outlined,
              "Click the verification link",
              1,
            ),
            SizedBox(height: 12),
            _buildInstructionItem(
              Icons.check_circle_outline,
              "We'll log you in automatically",
              2,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInstructionItem(IconData icon, String text, int index) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 600 + (index * 100)),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(-20 * (1 - value), 0),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [TColor.primary, TColor.secondary],
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 18, color: TColor.white),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 13,
                color: TColor.gray,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(VerifyState state) {
    return Column(
      children: [
        // Check Status Button
        if (state is VerifyPending)
          TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 800),
            tween: Tween(begin: 0.0, end: 1.0),
            curve: Curves.easeOutCubic,
            builder: (context, value, child) {
              return Transform.translate(
                offset: Offset(0, 30 * (1 - value)),
                child: Opacity(opacity: value, child: child),
              );
            },
            child: Column(
              children: [
                RoundButton(title: "Check Status", onPressed: _checkStatus),
                SizedBox(height: 15),
              ],
            ),
          ),

        // Open Email Button
        TweenAnimationBuilder<double>(
          duration: const Duration(milliseconds: 900),
          tween: Tween(begin: 0.0, end: 1.0),
          curve: Curves.easeOutCubic,
          builder: (context, value, child) {
            return Transform.translate(
              offset: Offset(0, 30 * (1 - value)),
              child: Opacity(opacity: value, child: child),
            );
          },
          child: _buildOutlineButton(
            "Open Email App",
            Icons.email_outlined,
            _openEmailApp,
            TColor.primary,
          ),
        ),
        SizedBox(height: 15),

        // Resend Button
        TweenAnimationBuilder<double>(
          duration: const Duration(milliseconds: 1000),
          tween: Tween(begin: 0.0, end: 1.0),
          curve: Curves.easeOutCubic,
          builder: (context, value, child) {
            return Transform.translate(
              offset: Offset(0, 30 * (1 - value)),
              child: Opacity(opacity: value, child: child),
            );
          },
          child: _buildOutlineButton(
            state is VerifyExpired ? "Send New Email" : "Resend Verification",
            Icons.send_outlined,
            _resendVerification,
            state is VerifyExpired ? Colors.orange : TColor.secondary,
          ),
        ),
        SizedBox(height: 20),

        // Back to Login
        TextButton(
          onPressed: () {
            Navigator.of(context).pushReplacementNamed(Routes.loginScreen);
          },
          child: Text(
            "Back to Login",
            style: TextStyle(
              color: TColor.gray,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOutlineButton(
    String title,
    IconData icon,
    VoidCallback onPressed,
    Color color,
  ) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: color.withOpacity(0.4), width: 2),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: MaterialButton(
        onPressed: onPressed,
        height: 56,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        minWidth: double.maxFinite,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 20),
            SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                color: color,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
