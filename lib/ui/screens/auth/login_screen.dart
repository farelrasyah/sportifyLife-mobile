import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../cubits/auth_cubit.dart';
import '../../../app/routes.dart';
import '../../../data/repositories/user_details_repository.dart';
import '../../../cubits/user_details_cubit.dart';
import '../../theme/color_palette.dart';
import '../../theme/typography.dart';

import '../../widgets/elegant_text_field.dart';

import '../../widgets/remember_me_checkbox.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _rememberMe = false;
  bool _isEmailFocused = false;
  bool _isPasswordFocused = false;

  // Focus nodes
  late final FocusNode _emailFocusNode = FocusNode();
  late final FocusNode _passwordFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _setupFocusListeners();
  }

  void _setupFocusListeners() {
    _emailFocusNode.addListener(() {
      setState(() {
        _isEmailFocused = _emailFocusNode.hasFocus;
      });
    });

    _passwordFocusNode.addListener(() {
      setState(() {
        _isPasswordFocused = _passwordFocusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      context.read<AuthCubit>().login(
        email: _emailController.text.trim(),
        password: _passwordController.text,
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

  Widget _buildForgotPasswordButton() {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () {
          // TODO: Implement forgot password
        },
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(
          'Lupa Kata Sandi?',
          style: AppTypography.authLinkText.copyWith(
            decoration: TextDecoration.underline,
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildLoginFormContent() {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        // Welcome Text
        Center(
          child: Text(
            'Selamat Datang',
            style: AppTypography.authTitle.copyWith(
              fontSize: isSmallScreen ? 24 : 28,
              letterSpacing: 0.5,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(height: 8),
        Center(
          child: Text(
            'SportifyLife',
            style: AppTypography.authSubtitle.copyWith(
              fontSize: isSmallScreen ? 17 : 19,
              fontWeight: FontWeight.w700,
              color: ColorPalette.kAuthButtonPrimary,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Center(
          child: Text(
            'Masuk ke akun Anda untuk melanjutkan',
            style: AppTypography.authSmallText.copyWith(
              fontSize: isSmallScreen ? 14 : 16,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(height: isSmallScreen ? 20 : 32),

        // Email Field
        ElegantTextField(
          controller: _emailController,
          hintText: 'Masukkan email Anda',
          labelText: 'Email',
          obscureText: false,
          icon: Icons.alternate_email_rounded,
          focusNode: _emailFocusNode,
          keyboardType: TextInputType.emailAddress,
          validator: _validateEmail,
        ),

        // Password Field
        ElegantTextField(
          controller: _passwordController,
          hintText: '••••••••',
          labelText: 'Password',
          obscureText: _obscurePassword,
          icon: Icons.lock_outline_rounded,
          focusNode: _passwordFocusNode,
          suffixWidget: IconButton(
            icon: Icon(
              _obscurePassword
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
              color: _isPasswordFocused
                  ? ColorPalette.kAuthButtonPrimary
                  : ColorPalette.kAuthPlaceholder,
              size: 22,
            ),
            onPressed: () {
              setState(() {
                _obscurePassword = !_obscurePassword;
              });
            },
          ),
          validator: _validatePassword,
        ),

        // Forgot Password & Remember Me
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: RememberMeCheckbox(
                value: _rememberMe,
                onChanged: (value) {
                  setState(() {
                    _rememberMe = value;
                  });
                },
              ),
            ),
            _buildForgotPasswordButton(),
          ],
        ),

        const SizedBox(height: 18),

        // Login Button
        // BlocConsumer<AuthCubit, AuthState>(
        //   listener: (context, state) async {
        //     if (state is AuthSuccess) {
        //       if (state.needsVerification) {
        //         Navigator.of(context).pushReplacementNamed(
        //           Routes.verifyEmailScreen,
        //           arguments: {'email': state.user.email},
        //         );
        //       } else {
        //         // Check if profile is complete
        //         final userDetailsCubit = UserDetailsCubit(
        //           UserDetailsRepository(),
        //         );
        //         await userDetailsCubit.getUserDetails();

        //         final detailsState = userDetailsCubit.state;
        //         if (detailsState is UserDetailsLoaded &&
        //             !detailsState.isComplete) {
        //           if (mounted) {
        //             Navigator.of(
        //               context,
        //             ).pushReplacementNamed(Routes.completeProfileScreen);
        //           }
        //         } else {
        //           if (mounted) {
        //             Navigator.of(
        //               context,
        //             ).pushReplacementNamed(Routes.homeScreen);
        //           }
        //         }
        //       }
        //     } else if (state is AuthError) {
        //       ScaffoldMessenger.of(context).showSnackBar(
        //         SnackBar(
        //           content: Text(state.error),
        //           backgroundColor: Colors.red,
        //           behavior: SnackBarBehavior.floating,
        //           shape: RoundedRectangleBorder(
        //             borderRadius: BorderRadius.circular(12.0),
        //           ),
        //         ),
        //       );
        //     }
        //   },
        //   // builder: (context, state) {
        //   //   final isLoading = state is AuthLoading;
        //   //   return AnimatedLoginButton(
        //   //     text: 'Masuk',
        //   //     onPressed: isLoading
        //   //         ? null
        //   //         : () {
        //   //             if (_emailController.text.trim().isEmpty) {
        //   //               ScaffoldMessenger.of(context).showSnackBar(
        //   //                 const SnackBar(content: Text('Email harus diisi')),
        //   //               );
        //   //               return;
        //   //             }
        //   //             if (_passwordController.text.trim().isEmpty) {
        //   //               ScaffoldMessenger.of(context).showSnackBar(
        //   //                 const SnackBar(content: Text('Password harus diisi')),
        //   //               );
        //   //               return;
        //   //             }
        //   //             _login();
        //   //           },
        //   //     isLoading: isLoading,
        //   //     icon: Icons.arrow_forward_rounded,
        //   //   );
        //   // },
        // ),

        const SizedBox(height: 24),

        // Register Link
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Belum punya akun? ', style: AppTypography.authSmallText),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(Routes.registerScreen);
                },
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4.0,
                    vertical: 0.0,
                  ),
                ),
                child: Text(
                  'Daftar Sekarang',
                  style: AppTypography.authLinkText.copyWith(
                    fontWeight: FontWeight.w600,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      // child: Scaffold(
      //   body: AnimatedBackground(
      //     child: SafeArea(
      //       child: SingleChildScrollView(
      //         physics: const BouncingScrollPhysics(),
      //         keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      //         child: Container(
      //           constraints: BoxConstraints(
      //             minHeight:
      //                 MediaQuery.of(context).size.height -
      //                 MediaQuery.of(context).padding.top -
      //                 MediaQuery.of(context).padding.bottom,
      //           ),
      //           child: Column(
      //             children: [
      //               SizedBox(
      //                 height: MediaQuery.of(context).size.width < 360 ? 10 : 20,
      //               ),
      //               Form(
      //                 key: _formKey,
      //                 child: GlassmorphismContainer(
      //                   child: _buildLoginFormContent(),
      //                 ),
      //               ),
      //               SizedBox(
      //                 height: MediaQuery.of(context).size.width < 360 ? 16 : 24,
      //               ),
      //             ],
      //           ),
      //         ),
      //       ),
      //     ),
      //   ),
      // ),
    );
  }
}
