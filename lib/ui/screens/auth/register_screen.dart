import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../common/colo_extension.dart';
import '../../widgets/round_button.dart';
import '../../widgets/round_textfield.dart';
import '../../../cubits/auth_cubit.dart';
import '../../../cubits/verify_cubit.dart';
import 'login_screen.dart';
import 'verify_email_screen.dart';
import '../../../app/routes.dart'; // TEMPORARY: For testing without auth

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool isCheck = false;
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // Color Constants
  static const Color _lightGray = Color(0xFFF7F8F8);
  static const Color _gray = Color(0xFFADA4A5);
  static const Color _black = Color(0xFF1D1617);

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleRegister() {
    if (_firstNameController.text.isNotEmpty &&
        _lastNameController.text.isNotEmpty &&
        _emailController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty &&
        isCheck) {
      context.read<AuthCubit>().register(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        confirmPassword: _passwordController.text,
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
      );
    } else {
      String message = '';
      if (!isCheck) {
        message = tr('validation_accept_terms');
      } else {
        message = tr('validation_fill_all_fields');
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Colors.red),
      );
    }
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required String iconPath,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    Widget? rightIcon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: _lightGray,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Container(
            alignment: Alignment.center,
            width: 50,
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Image.asset(
              iconPath,
              width: 20,
              height: 20,
              fit: BoxFit.contain,
              color: _gray,
            ),
          ),
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: keyboardType,
              obscureText: obscureText,
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: TextStyle(color: _gray, fontSize: 12),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
              style: TextStyle(color: _black, fontSize: 14),
            ),
          ),
          if (rightIcon != null) rightIcon,
          const SizedBox(width: 8),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: TColor.white,
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error), backgroundColor: Colors.red),
            );
          } else if (state is AuthSuccess) {
            if (state.needsVerification) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(tr('message_register_success_verify')),
                  backgroundColor: Colors.green,
                ),
              );
              // Navigate to verify email screen
              Future.delayed(const Duration(milliseconds: 500), () {
                if (mounted) {
                  Navigator.pushReplacementNamed(
                    context,
                    Routes.verifyEmailScreen,
                    arguments: {'email': _emailController.text.trim()},
                  );
                }
              });
            } else {
              // Registration successful, navigate to Complete Profile Screen
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(tr('message_register_success')),
                  backgroundColor: Colors.green,
                ),
              );

              // Navigate to Complete Profile Screen for new users
              Future.delayed(const Duration(milliseconds: 500), () {
                if (mounted) {
                  Navigator.of(
                    context,
                  ).pushReplacementNamed(Routes.completeProfileScreen);
                }
              });
            }
          }
        },
        builder: (context, state) {
          return Stack(
            children: [
              SingleChildScrollView(
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 20),
                        // Header Section
                        Text(
                          tr("greeting_hey_there"),
                          style: TextStyle(color: TColor.gray, fontSize: 16),
                        ),
                        SizedBox(height: 5),
                        Text(
                          tr("register_greeting_create_account"),
                          style: TextStyle(
                            color: TColor.black,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 30),

                        // Lottie Animation
                        Container(
                          height: media.width * 0.7,
                          width: media.width * 0.7,
                          child: Lottie.asset(
                            'assets/images/meditating.json',
                            fit: BoxFit.contain,
                            repeat: true,
                            animate: true,
                          ),
                        ),
                        SizedBox(height: 30),

                        // Form Section
                        _buildTextField(
                          controller: _firstNameController,
                          hintText: tr("hint_first_name"),
                          iconPath: "assets/images/user.png",
                        ),
                        SizedBox(height: 15),
                        _buildTextField(
                          controller: _lastNameController,
                          hintText: tr("hint_last_name"),
                          iconPath: "assets/images/user.png",
                        ),
                        SizedBox(height: 15),
                        _buildTextField(
                          controller: _emailController,
                          hintText: tr("hint_email"),
                          iconPath: "assets/images/email.png",
                          keyboardType: TextInputType.emailAddress,
                        ),
                        SizedBox(height: 15),
                        _buildTextField(
                          controller: _passwordController,
                          hintText: tr("hint_password"),
                          iconPath: "assets/images/lock.png",
                          obscureText: true,
                          rightIcon: TextButton(
                            onPressed: () {},
                            child: Container(
                              alignment: Alignment.center,
                              width: 20,
                              height: 20,
                              child: Image.asset(
                                "assets/images/show_password.png",
                                width: 20,
                                height: 20,
                                fit: BoxFit.contain,
                                color: _gray,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 15),

                        // Terms & Conditions
                        Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  isCheck = !isCheck;
                                });
                              },
                              icon: Icon(
                                isCheck
                                    ? Icons.check_box_outlined
                                    : Icons.check_box_outline_blank_outlined,
                                color: TColor.gray,
                                size: 20,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                tr("terms_conditions_text"),
                                style: TextStyle(
                                  color: TColor.gray,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 25),

                        // Button Section
                        RoundButton(
                          title: state is AuthLoading
                              ? tr("button_registering")
                              : tr("register_button"),
                          onPressed: state is AuthLoading
                              ? () {}
                              : _handleRegister,
                        ),
                        SizedBox(height: 20),
                        // Divider
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 1,
                                color: TColor.gray.withOpacity(0.5),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                              ),
                              child: Text(
                                tr("divider_or"),
                                style: TextStyle(
                                  color: TColor.black,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                height: 1,
                                color: TColor.gray.withOpacity(0.5),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        // Social Login
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {},
                              child: Container(
                                width: 50,
                                height: 50,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: TColor.white,
                                  border: Border.all(
                                    width: 1,
                                    color: TColor.gray.withOpacity(0.4),
                                  ),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Image.asset(
                                  "assets/images/google.png",
                                  width: 20,
                                  height: 20,
                                ),
                              ),
                            ),
                            SizedBox(width: 30),
                            GestureDetector(
                              onTap: () {},
                              child: Container(
                                width: 50,
                                height: 50,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: TColor.white,
                                  border: Border.all(
                                    width: 1,
                                    color: TColor.gray.withOpacity(0.4),
                                  ),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Image.asset(
                                  "assets/images/facebook.png",
                                  width: 20,
                                  height: 20,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        // Footer
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BlocProvider(
                                  create: (_) => AuthCubit(),
                                  child: const LoginScreen(),
                                ),
                              ),
                            );
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                tr("footer_already_have_account"),
                                style: TextStyle(
                                  color: TColor.black,
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                tr("footer_login"),
                                style: TextStyle(
                                  color: TColor.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
              if (state is AuthLoading)
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
