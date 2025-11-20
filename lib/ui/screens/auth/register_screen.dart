import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../cubits/auth_cubit.dart';
import '../../../app/routes.dart';
import '../../../utils/storage_helper.dart';
import '../../theme/color_palette.dart';
import '../../theme/typography.dart';
import '../../widgets/auth_input_field.dart';
import '../../widgets/auth_button.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      context.read<AuthCubit>().register(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        confirmPassword: _confirmPasswordController.text,
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
      );
    }
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPalette.kAuthBackground,
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) async {
          if (state is AuthSuccess) {
            // Save verification expiry and navigate
            final expiresAt = DateTime.now().add(const Duration(minutes: 1));
            await StorageHelper().saveVerificationExpiry(expiresAt);

            if (mounted) {
              Navigator.of(context).pushReplacementNamed(
                Routes.verifyEmailScreen,
                arguments: {'email': state.user.email},
              );
            }
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error),
                backgroundColor: Colors.red,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is AuthLoading;

          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 60),

                    // Header Section
                    Text('Hey there,', style: AppTypography.authSubtitle),
                    const SizedBox(height: 4),
                    Text('Create an Account', style: AppTypography.authTitle),
                    const SizedBox(height: 32),

                    // First Name Field
                    AuthInputField(
                      hintText: 'First Name',
                      controller: _firstNameController,
                      textCapitalization: TextCapitalization.words,
                      prefixIcon: const Icon(
                        Icons.person_outlined,
                        color: ColorPalette.kAuthPlaceholder,
                        size: 20,
                      ),
                      validator: _validateName,
                    ),
                    const SizedBox(height: 16),

                    // Last Name Field
                    AuthInputField(
                      hintText: 'Last Name',
                      controller: _lastNameController,
                      textCapitalization: TextCapitalization.words,
                      prefixIcon: const Icon(
                        Icons.person_outlined,
                        color: ColorPalette.kAuthPlaceholder,
                        size: 20,
                      ),
                      validator: _validateName,
                    ),
                    const SizedBox(height: 16),

                    // Email Field
                    AuthInputField(
                      hintText: 'Email',
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      prefixIcon: const Icon(
                        Icons.email_outlined,
                        color: ColorPalette.kAuthPlaceholder,
                        size: 20,
                      ),
                      validator: _validateEmail,
                    ),
                    const SizedBox(height: 16),

                    // Password Field
                    AuthInputField(
                      hintText: 'Password',
                      controller: _passwordController,
                      isPassword: true,
                      obscureText: _obscurePassword,
                      prefixIcon: const Icon(
                        Icons.lock_outlined,
                        color: ColorPalette.kAuthPlaceholder,
                        size: 20,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          color: ColorPalette.kAuthPlaceholder,
                          size: 20,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                      validator: _validatePassword,
                    ),
                    const SizedBox(height: 16),

                    // Confirm Password Field
                    AuthInputField(
                      hintText: 'Confirm Password',
                      controller: _confirmPasswordController,
                      isPassword: true,
                      obscureText: _obscureConfirmPassword,
                      prefixIcon: const Icon(
                        Icons.lock_outlined,
                        color: ColorPalette.kAuthPlaceholder,
                        size: 20,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureConfirmPassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          color: ColorPalette.kAuthPlaceholder,
                          size: 20,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureConfirmPassword = !_obscureConfirmPassword;
                          });
                        },
                      ),
                      validator: _validateConfirmPassword,
                    ),
                    const SizedBox(height: 20),

                    // Terms and Privacy Policy
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 20,
                          height: 20,
                          margin: const EdgeInsets.only(top: 2),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: ColorPalette.kAuthInputBorder,
                              width: 1.5,
                            ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Icon(
                            Icons.check,
                            size: 14,
                            color: ColorPalette.kAuthButtonPrimary,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              style: AppTypography.authSmallText,
                              children: [
                                const TextSpan(
                                  text: 'By continuing you accept our ',
                                ),
                                TextSpan(
                                  text: 'Privacy Policy',
                                  style: AppTypography.authSmallText.copyWith(
                                    color: ColorPalette.kAuthLinkText,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                                const TextSpan(text: ' and '),
                                TextSpan(
                                  text: 'Term of Use',
                                  style: AppTypography.authSmallText.copyWith(
                                    color: ColorPalette.kAuthLinkText,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),

                    // Register Button
                    AuthButton(
                      text: 'Register',
                      onPressed: isLoading ? null : _register,
                      isLoading: isLoading,
                    ),
                    const SizedBox(height: 24),

                    // Divider
                    Row(
                      children: [
                        const Expanded(
                          child: Divider(
                            color: ColorPalette.kAuthDivider,
                            thickness: 1,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text('Or', style: AppTypography.authSmallText),
                        ),
                        const Expanded(
                          child: Divider(
                            color: ColorPalette.kAuthDivider,
                            thickness: 1,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Social Login Buttons
                    Row(
                      children: [
                        Expanded(
                          child: SocialLoginButton(
                            text: 'Google',
                            icon: Container(
                              width: 20,
                              height: 20,
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(
                                    'assets/images/google_icon.png',
                                  ),
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                            onPressed: () {
                              // TODO: Implement Google login
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: SocialLoginButton(
                            text: 'Facebook',
                            icon: const Icon(
                              Icons.facebook,
                              color: Color(0xFF1877F2),
                              size: 20,
                            ),
                            onPressed: () {
                              // TODO: Implement Facebook login
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),

                    // Login Link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Already have an account? ',
                          style: AppTypography.authSmallText,
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pushNamed(Routes.loginScreen);
                          },
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 4.0,
                              vertical: 0.0,
                            ),
                          ),
                          child: Text(
                            'Login',
                            style: AppTypography.authLinkText.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
