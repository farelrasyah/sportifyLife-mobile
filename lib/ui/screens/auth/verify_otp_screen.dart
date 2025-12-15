import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../common/colo_extension.dart';
import '../../widgets/round_button.dart';
import '../../../cubits/password_reset_cubit.dart';
import '../../../app/routes.dart';
import 'dart:async';

class VerifyOtpScreen extends StatefulWidget {
  final String email;

  const VerifyOtpScreen({super.key, required this.email});

  @override
  State<VerifyOtpScreen> createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends State<VerifyOtpScreen> {
  final List<TextEditingController> _otpControllers = List.generate(
    6,
    (index) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());

  Timer? _resendTimer;
  int _resendCountdown = 0;
  bool _canResend = true;

  // Color Constants
  static const Color _lightGray = Color(0xFFF7F8F8);
  static const Color _gray = Color(0xFFADA4A5);
  static const Color _black = Color(0xFF1D1617);

  @override
  void initState() {
    super.initState();
    _startResendTimer();
  }

  @override
  void dispose() {
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    _resendTimer?.cancel();
    super.dispose();
  }

  void _startResendTimer() {
    setState(() {
      _canResend = false;
      _resendCountdown = 60; // 60 seconds countdown
    });

    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_resendCountdown > 0) {
          _resendCountdown--;
        } else {
          _canResend = true;
          timer.cancel();
        }
      });
    });
  }

  void _handleOtpSubmit() {
    final otp = _otpControllers.map((controller) => controller.text).join();

    if (otp.length == 6) {
      context.read<PasswordResetCubit>().verifyOtp(widget.email, otp);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter all 6 digits'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  void _handleResendOtp() {
    if (_canResend) {
      context.read<PasswordResetCubit>().resendOtp();
      _startResendTimer();
    }
  }

  void _onOtpChanged(String value, int index) {
    if (value.isNotEmpty) {
      // Move to next field
      if (index < 5) {
        _focusNodes[index + 1].requestFocus();
      } else {
        // All fields filled, submit automatically
        _handleOtpSubmit();
      }
    } else {
      // Move to previous field if current is empty
      if (index > 0) {
        _focusNodes[index - 1].requestFocus();
      }
    }
  }

  void _clearOtpFields() {
    for (var controller in _otpControllers) {
      controller.clear();
    }
    _focusNodes[0].requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: TColor.white,
      appBar: AppBar(
        backgroundColor: TColor.white,
        centerTitle: true,
        elevation: 0,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            margin: const EdgeInsets.all(8),
            height: 40,
            width: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: _lightGray,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.arrow_back_ios, size: 15, color: _black),
          ),
        ),
        title: Text(
          "Verify Code",
          style: TextStyle(
            color: _black,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: BlocConsumer<PasswordResetCubit, PasswordResetState>(
        listener: (context, state) {
          if (state is PasswordResetError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 4),
              ),
            );
            _clearOtpFields();
          } else if (state is PasswordResetOtpSent) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("New code sent to your email"),
                backgroundColor: Colors.green,
                duration: const Duration(seconds: 3),
              ),
            );
            _clearOtpFields();
          } else if (state is PasswordResetOtpVerified) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
                duration: const Duration(seconds: 3),
              ),
            );

            // Navigate to new password screen
            Future.delayed(const Duration(milliseconds: 500), () {
              if (mounted) {
                Navigator.pushNamed(
                  context,
                  Routes.newPasswordScreen,
                  arguments: {'email': state.email, 'otp': state.otp},
                );
              }
            });
          }
        },
        builder: (context, state) {
          final isLoading = state is PasswordResetLoading;

          return Stack(
            children: [
              SingleChildScrollView(
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 20),

                        // Header Section
                        Text(
                          "Check Your Email",
                          style: TextStyle(
                            color: _black,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "We've sent a 6-digit verification code to:",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: _gray, fontSize: 14),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          widget.email,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: _black,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 30),

                        // Lottie Animation
                        Container(
                          height: media.width * 0.5,
                          width: media.width * 0.5,
                          child: Lottie.asset(
                            'assets/images/verification.json',
                            fit: BoxFit.contain,
                          ),
                        ),
                        const SizedBox(height: 30),

                        // OTP Input Fields
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: List.generate(6, (index) {
                            return Container(
                              width: 45,
                              height: 55,
                              decoration: BoxDecoration(
                                color: _lightGray,
                                borderRadius: BorderRadius.circular(15),
                                border: _focusNodes[index].hasFocus
                                    ? Border.all(
                                        color: TColor.primaryColor1,
                                        width: 2,
                                      )
                                    : null,
                              ),
                              child: TextFormField(
                                controller: _otpControllers[index],
                                focusNode: _focusNodes[index],
                                textAlign: TextAlign.center,
                                keyboardType: TextInputType.number,
                                maxLength: 1,
                                style: TextStyle(
                                  color: _black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  counterText: '',
                                ),
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                onChanged: (value) =>
                                    _onOtpChanged(value, index),
                                onTap: () {
                                  // Clear field when tapped for better UX
                                  _otpControllers[index].clear();
                                },
                              ),
                            );
                          }),
                        ),
                        const SizedBox(height: 30),

                        // Verify Button
                        RoundButton(
                          title: isLoading ? "Verifying..." : "Verify Code",
                          onPressed: isLoading ? () {} : _handleOtpSubmit,
                        ),
                        const SizedBox(height: 20),

                        // Resend Section
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Didn't receive the code? ",
                              style: TextStyle(color: _gray, fontSize: 14),
                            ),
                            if (_canResend)
                              GestureDetector(
                                onTap: _handleResendOtp,
                                child: Text(
                                  "Resend",
                                  style: TextStyle(
                                    color: TColor.primaryColor1,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              )
                            else
                              Text(
                                "Resend in ${_resendCountdown}s",
                                style: TextStyle(color: _gray, fontSize: 14),
                              ),
                          ],
                        ),
                        const SizedBox(height: 30),

                        // Info Text
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: TColor.lightGray.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Column(
                            children: [
                              Icon(
                                Icons.timer_outlined,
                                color: TColor.primaryColor1,
                                size: 24,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "The verification code will expire in 10 minutes. Please enter it as soon as you receive it.",
                                textAlign: TextAlign.center,
                                style: TextStyle(color: _gray, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),

              // Loading Overlay
              if (isLoading)
                Container(
                  color: Colors.black.withOpacity(0.3),
                  child: const Center(child: CircularProgressIndicator()),
                ),
            ],
          );
        },
      ),
    );
  }
}
