import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:easy_localization/easy_localization.dart';
import 'app/routes.dart';
import 'ui/theme/app_theme.dart';
import 'utils/route_logger.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

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
