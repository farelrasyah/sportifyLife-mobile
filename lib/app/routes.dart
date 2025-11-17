import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Screens
import '../ui/screens/splashScreen.dart';
import '../ui/screens/loginScreen.dart';
import '../ui/screens/registerScreen.dart';
import '../ui/screens/verifyEmailScreen.dart';
import '../ui/screens/completeProfileScreen.dart';
import '../ui/screens/homeScreen.dart';

// Cubits
import '../cubits/authCubit.dart';
import '../cubits/verifyCubit.dart';
import '../cubits/userDetailsCubit.dart';

// Repositories
import '../data/repositories/authRepository.dart';
import '../data/repositories/userDetailsRepository.dart';

/// Route names
class Routes {
  static const String splashScreen = '/';
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
      case Routes.splashScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => AuthCubit(AuthRepository()),
            child: const SplashScreen(),
          ),
        );

      case Routes.loginScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => AuthCubit(AuthRepository()),
            child: const LoginScreen(),
          ),
        );

      case Routes.registerScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => AuthCubit(AuthRepository()),
            child: const RegisterScreen(),
          ),
        );

      case Routes.verifyEmailScreen:
        if (args is Map<String, dynamic>) {
          return MaterialPageRoute(
            builder: (_) => BlocProvider(
              create: (_) => VerifyCubit(AuthRepository()),
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
