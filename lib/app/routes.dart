import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Screens
import '../ui/screens/splash_screen.dart';
import '../ui/screens/onboarding_screen.dart';
import '../ui/screens/auth/login_screen.dart';
import '../ui/screens/auth/register_screen.dart';
import '../ui/screens/auth/verify_email_screen.dart';
import '../ui/screens/complete_profile_screen.dart';
import '../ui/screens/home_screen.dart';

// Cubits
import '../cubits/auth_cubit.dart';
import '../cubits/verify_cubit.dart';
import '../cubits/user_details_cubit.dart';

// Repositories
import '../data/repositories/user_details_repository.dart';

/// Route names
class Routes {
  static const String welcomeScreen = '/';
  static const String splashScreen = '/splash';
  static const String onboardingScreen = '/onboarding';
  static const String loginScreen = '/login';
  static const String registerScreen = '/register';
  static const String verifyEmailScreen = '/verifyEmail';
  static const String completeProfileScreen = '/completeProfile';
  static const String homeScreen = '/home';
}

/// Generate routes with proper BLoC providers
class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Extract arguments
    final args = settings.arguments;

    switch (settings.name) {
      case Routes.welcomeScreen:
        return MaterialPageRoute(builder: (_) => const OnboardingScreen());

      case Routes.splashScreen:
        return MaterialPageRoute(builder: (_) => const SplashScreen());

      case Routes.onboardingScreen:
        return MaterialPageRoute(builder: (_) => const OnboardingScreen());

      case Routes.loginScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => AuthCubit(),
            child: const LoginScreen(),
          ),
        );

      case Routes.registerScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => AuthCubit(),
            child: const RegisterScreen(),
          ),
        );

      case Routes.verifyEmailScreen:
        if (args is Map<String, dynamic>) {
          return MaterialPageRoute(
            builder: (_) => BlocProvider(
              create: (_) => VerifyCubit(),
              child: VerifyEmailScreen(email: args['email'] as String),
            ),
          );
        }
        return _errorRoute();

      case Routes.completeProfileScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => UserDetailsCubit(UserDetailsRepository()),
            child: const CompleteProfileScreen(),
          ),
        );

      case Routes.homeScreen:
        return MaterialPageRoute(builder: (_) => const HomeScreen());

      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: const Center(child: Text('Route not found')),
      ),
    );
  }
}
