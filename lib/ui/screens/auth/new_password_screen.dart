import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../common/colo_extension.dart';
import '../../widgets/round_button.dart';
import '../../widgets/round_textfield.dart';
import '../../../cubits/password_reset_cubit.dart';
import '../../../app/routes.dart';

class NewPasswordScreen extends StatefulWidget {
  final String email;
  final String otp;

  const NewPasswordScreen({super.key, required this.email, required this.otp});

  @override
  State<NewPasswordScreen> createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;
  bool _showPasswordRequirements = false;

  // Color Constants
  static const Color _lightGray = Color(0xFFF7F8F8);
  static const Color _gray = Color(0xFFADA4A5);
  static const Color _black = Color(0xFF1D1617);

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleResetPassword() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<PasswordResetCubit>().resetPassword(
        email: widget.email,
        otp: widget.otp,
        newPassword: _newPasswordController.text,
        confirmNewPassword: _confirmPasswordController.text,
      );
    }
  }

  String? _validatePassword(String? value) {
    if (value?.isEmpty ?? true) {
      return 'Please enter your new password';
    }

    if (value!.length < 8) {
      return 'Password must be at least 8 characters';
    }

    // Check password requirements according to backend
    final passwordRegex = RegExp(
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,128}$',
    );
    if (!passwordRegex.hasMatch(value)) {
      return 'Password does not meet requirements';
    }

    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value?.isEmpty ?? true) {
      return 'Please confirm your new password';
    }

    if (value != _newPasswordController.text) {
      return 'Passwords do not match';
    }

    return null;
  }

  Widget _buildPasswordRequirement(String text, bool isValid) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Icon(
            isValid ? Icons.check_circle : Icons.radio_button_unchecked,
            size: 16,
            color: isValid ? Colors.green : _gray,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 12,
                color: isValid ? Colors.green : _gray,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordRequirements() {
    final password = _newPasswordController.text;
    final hasMinLength = password.length >= 8;
    final hasLowercase = password.contains(RegExp(r'[a-z]'));
    final hasUppercase = password.contains(RegExp(r'[A-Z]'));
    final hasDigit = password.contains(RegExp(r'\d'));
    final hasSpecialChar = password.contains(RegExp(r'[@$!%*?&]'));

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: TColor.lightGray.withOpacity(0.3),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: TColor.lightGray.withOpacity(0.5), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Password Requirements:",
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: _black,
            ),
          ),
          const SizedBox(height: 8),
          _buildPasswordRequirement("At least 8 characters", hasMinLength),
          _buildPasswordRequirement("One lowercase letter (a-z)", hasLowercase),
          _buildPasswordRequirement("One uppercase letter (A-Z)", hasUppercase),
          _buildPasswordRequirement("One number (0-9)", hasDigit),
          _buildPasswordRequirement(
            "One special character (@\$!%*?&)",
            hasSpecialChar,
          ),
        ],
      ),
    );
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
          "New Password",
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
          } else if (state is PasswordResetSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
                duration: const Duration(seconds: 3),
              ),
            );

            // Navigate back to login screen after successful reset
            Future.delayed(const Duration(milliseconds: 1500), () {
              if (mounted) {
                Navigator.of(
                  context,
                ).pushNamedAndRemoveUntil(Routes.loginScreen, (route) => false);
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
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 20),

                          // Header Section
                          Text(
                            "Create New Password",
                            style: TextStyle(
                              color: _black,
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "Your new password must be different from previous used passwords.",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: _gray, fontSize: 14),
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

                          // New Password Input
                          Container(
                            decoration: BoxDecoration(
                              color: _lightGray,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: TextFormField(
                              controller: _newPasswordController,
                              obscureText: _obscureNewPassword,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 15,
                                  horizontal: 15,
                                ),
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                hintText: "New Password",
                                prefixIcon: Container(
                                  alignment: Alignment.center,
                                  width: 20,
                                  height: 20,
                                  child: Image.asset(
                                    "assets/icon/lock.png",
                                    width: 20,
                                    height: 20,
                                    fit: BoxFit.contain,
                                    color: _gray,
                                  ),
                                ),
                                suffixIcon: TextButton(
                                  onPressed: () {
                                    setState(() {
                                      _obscureNewPassword =
                                          !_obscureNewPassword;
                                    });
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    width: 20,
                                    height: 20,
                                    child: Icon(
                                      _obscureNewPassword
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                      color: _gray,
                                      size: 18,
                                    ),
                                  ),
                                ),
                              ),
                              validator: _validatePassword,
                              onChanged: (value) {
                                setState(() {
                                  _showPasswordRequirements = value.isNotEmpty;
                                });
                              },
                            ),
                          ),

                          // Password Requirements
                          if (_showPasswordRequirements)
                            _buildPasswordRequirements(),

                          const SizedBox(height: 20),

                          // Confirm Password Input
                          Container(
                            decoration: BoxDecoration(
                              color: _lightGray,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: TextFormField(
                              controller: _confirmPasswordController,
                              obscureText: _obscureConfirmPassword,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 15,
                                  horizontal: 15,
                                ),
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                hintText: "Confirm New Password",
                                prefixIcon: Container(
                                  alignment: Alignment.center,
                                  width: 20,
                                  height: 20,
                                  child: Image.asset(
                                    "assets/icon/lock.png",
                                    width: 20,
                                    height: 20,
                                    fit: BoxFit.contain,
                                    color: _gray,
                                  ),
                                ),
                                suffixIcon: TextButton(
                                  onPressed: () {
                                    setState(() {
                                      _obscureConfirmPassword =
                                          !_obscureConfirmPassword;
                                    });
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    width: 20,
                                    height: 20,
                                    child: Icon(
                                      _obscureConfirmPassword
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                      color: _gray,
                                      size: 18,
                                    ),
                                  ),
                                ),
                              ),
                              validator: _validateConfirmPassword,
                            ),
                          ),
                          const SizedBox(height: 40),

                          // Reset Password Button
                          RoundButton(
                            title: isLoading
                                ? "Updating Password..."
                                : "Update Password",
                            onPressed: isLoading ? () {} : _handleResetPassword,
                          ),
                          const SizedBox(height: 30),

                          // Security Info
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: TColor.lightGray.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.security,
                                  color: TColor.primaryColor1,
                                  size: 24,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "Your password is encrypted and stored securely. Make sure to use a strong and unique password.",
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
