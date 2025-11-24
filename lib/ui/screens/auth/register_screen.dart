import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import '../../../common/colo_extension.dart';
import '../../../common_widget/round_button.dart';
import '../../../common_widget/round_textfield.dart';
import '../../../cubits/auth_cubit.dart';
import 'login_screen.dart';

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
        message = 'Please accept terms and conditions';
      } else {
        message = 'Please fill in all fields';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Colors.red),
      );
    }
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
                const SnackBar(
                  content: Text(
                    'Registration successful! Please verify your email',
                  ),
                  backgroundColor: Colors.green,
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Registration successful!'),
                  backgroundColor: Colors.green,
                ),
              );
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
                          "Hey there,",
                          style: TextStyle(color: TColor.gray, fontSize: 16),
                        ),
                        SizedBox(height: 5),
                        Text(
                          "Create an Account",
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
                        RoundTextField(
                          controller: _firstNameController,
                          hitText: "First Name",
                          icon: "assets/images/user.png",
                        ),
                        SizedBox(height: 15),
                        RoundTextField(
                          controller: _lastNameController,
                          hitText: "Last Name",
                          icon: "assets/images/user.png",
                        ),
                        SizedBox(height: 15),
                        RoundTextField(
                          controller: _emailController,
                          hitText: "Email",
                          icon: "assets/images/email.png",
                          keyboardType: TextInputType.emailAddress,
                        ),
                        SizedBox(height: 15),
                        RoundTextField(
                          controller: _passwordController,
                          hitText: "Password",
                          icon: "assets/images/lock.png",
                          obscureText: true,
                          rigtIcon: TextButton(
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
                                color: TColor.gray,
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
                                "By continuing you accept our Privacy Policy and Term of Use",
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
                              ? "Registering..."
                              : "Register",
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
                                "Or",
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
                                "Already have an account? ",
                                style: TextStyle(
                                  color: TColor.black,
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                "Login",
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
