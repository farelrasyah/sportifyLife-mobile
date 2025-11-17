import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubits/authCubit.dart';
import '../../app/routes.dart';
import '../../data/repositories/userDetailsRepository.dart';
import '../../cubits/userDetailsCubit.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    await Future.delayed(
      const Duration(seconds: 2),
    ); // Show splash for 2 seconds

    if (!mounted) return;

    context.read<AuthCubit>().checkAuthStatus();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) async {
        if (state is AuthUnauthenticated) {
          Navigator.of(context).pushReplacementNamed(Routes.loginScreen);
        } else if (state is AuthSuccess) {
          if (state.needsVerification) {
            Navigator.of(context).pushReplacementNamed(
              Routes.verifyEmailScreen,
              arguments: {'email': state.user.email},
            );
          } else {
            // Check if profile is complete
            final userDetailsCubit = UserDetailsCubit(UserDetailsRepository());
            await userDetailsCubit.getUserDetails();

            final detailsState = userDetailsCubit.state;
            if (detailsState is UserDetailsLoaded && !detailsState.isComplete) {
              if (mounted) {
                Navigator.of(
                  context,
                ).pushReplacementNamed(Routes.completeProfileScreen);
              }
            } else {
              if (mounted) {
                Navigator.of(context).pushReplacementNamed(Routes.homeScreen);
              }
            }
          }
        }
      },
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Theme.of(context).primaryColor,
                Theme.of(context).primaryColor.withOpacity(0.8),
              ],
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // App Logo
                Icon(Icons.fitness_center, size: 100, color: Colors.white),
                const SizedBox(height: 24),
                // App Name
                const Text(
                  'SportifyLife',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 48),
                // Loading Indicator
                const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
