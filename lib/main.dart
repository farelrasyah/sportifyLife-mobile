import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:easy_localization/easy_localization.dart';
import 'app/routes.dart';
import 'ui/theme/app_theme.dart';
import 'utils/route_logger.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  // Suppress mouse tracker debug assertions (known Flutter desktop bug)
  FlutterError.onError = (FlutterErrorDetails details) {
    // Filter out mouse tracker assertions
    if (details.exception.toString().contains('mouse_tracker.dart') ||
        details.exception.toString().contains('_debugDuringDeviceUpdate')) {
      return; // Ignore these errors
    }
    // Log other errors normally
    FlutterError.presentError(details);
  };

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('id')],
      path: 'assets/languages',
      fallbackLocale: const Locale('en'),
      child: const SportifyLifeApp(),
    ),
  );
}

class SportifyLifeApp extends StatelessWidget {
  const SportifyLifeApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SportifyLife',
      debugShowCheckedModeBanner: false,

      // Suppress rendering overflow errors in debug mode
      builder: (context, widget) {
        ErrorWidget.builder = (FlutterErrorDetails errorDetails) {
          return Container(
            color: Colors.white,
            child: Center(
              child: Text(
                kDebugMode ? errorDetails.toString() : 'Error occurred',
                style: const TextStyle(color: Colors.red),
              ),
            ),
          );
        };
        return widget!;
      },

      // Theme Configuration
      theme: AppTheme.lightTheme,

      // Localization
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,

      // Routing
      initialRoute: Routes.splashScreen,
      onGenerateRoute: RouteGenerator.generateRoute,

      // Navigation Observer untuk logging
      navigatorObservers: [RouteLogger()],
    );
  }
}
