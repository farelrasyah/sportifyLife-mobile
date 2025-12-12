import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../common/colo_extension.dart';
import '../../widgets/round_button.dart';
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
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

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

  Future<void> _resendVerification() async {
    context.read<VerifyCubit>().resendVerification(widget.email);
    final newExpiry = DateTime.now().add(const Duration(minutes: 1));
    await StorageHelper().saveVerificationExpiry(newExpiry);
    _showSnackBar(tr('verify_email_sent_success'), isError: false);
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
    _showSnackBar(tr('verify_email_verified_success'), isError: false);
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
        leading: null,
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
              Container(decoration: BoxDecoration(color: TColor.white)),

              // Main Content
              SingleChildScrollView(
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        // Animated Header
                        FadeTransition(
                          opacity: _fadeAnimation,
                          child: Column(
                            children: [
                              Text(
                                tr("verify_email_title"),
                                style: TextStyle(
                                  color: TColor.black,
                                  fontSize: 28,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: -0.5,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                tr("verify_email_sent_to"),
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
                                  color: TColor.lightGray,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  widget.email,
                                  style: TextStyle(
                                    color: TColor.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
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
                              color: TColor.lightGray,
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
    if (state is VerifyPending && state.remainingTime > Duration.zero) {
      return Column(
        children: [
          Text(
            tr("verify_expires_in_label"),
            style: TextStyle(
              color: TColor.gray,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16),
          Text(
            _formatDuration(state.remainingTime),
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.w700,
              color: TColor.black,
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
                  tr("verify_checking_status"),
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
    } else {
      // Expired or time is up
      return Column(
        children: [
          SizedBox(height: 16),
          Text(
            tr("verify_link_expired"),
            style: TextStyle(
              fontSize: 20,
              color: TColor.black,
              fontWeight: FontWeight.w800,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8),
          Text(
            tr("verify_request_new"),
            style: TextStyle(fontSize: 13, color: TColor.gray),
            textAlign: TextAlign.center,
          ),
        ],
      );
    }
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
            _buildInstructionItem(tr("verify_instruction_check_inbox"), 0),
            SizedBox(height: 12),
            _buildInstructionItem(tr("verify_instruction_click_link"), 1),
            SizedBox(height: 12),
            _buildInstructionItem(tr("verify_instruction_auto_login"), 2),
          ],
        ),
      ),
    );
  }

  Widget _buildInstructionItem(String text, int index) {
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
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: TColor.gray,
              shape: BoxShape.circle,
            ),
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
        if (state is VerifyPending && state.remainingTime > Duration.zero)
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
                RoundButton(
                  title: tr("verify_button_check_status"),
                  onPressed: _checkStatus,
                ),
                SizedBox(height: 15),
              ],
            ),
          ),

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
            (state is VerifyExpired ||
                    (state is VerifyPending &&
                        state.remainingTime <= Duration.zero))
                ? tr("verify_button_send_new")
                : tr("verify_button_resend"),
            _resendVerification,
            TColor.secondary,
          ),
        ),
        SizedBox(height: 20),

        // Back to Login
        TextButton(
          onPressed: () {
            Navigator.of(context).pushReplacementNamed(Routes.loginScreen);
          },
          child: Text(
            tr("verify_back_to_login"),
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
