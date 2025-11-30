import 'package:flutter/material.dart';

/// NavigatorObserver untuk logging setiap perpindahan halaman
class RouteLogger extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    _logRoute('PUSH', route, previousRoute);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    _logRoute('POP', route, previousRoute);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    if (newRoute != null) {
      _logRoute('REPLACE', newRoute, oldRoute);
    }
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didRemove(route, previousRoute);
    _logRoute('REMOVE', route, previousRoute);
  }

  // ANSI color codes
  static const String _yellow = '\x1B[33m';
  static const String _reset = '\x1B[0m';

  void _logRoute(
    String action,
    Route<dynamic> route,
    Route<dynamic>? previousRoute,
  ) {
    final routeName = _getRouteName(route);

    // Skip logging jika route name tidak valid
    if (routeName.contains('MaterialPageRoute') ||
        routeName.contains('_PageRoute')) {
      return;
    }

    print('$_yellow[NAVIGATION] $action TO ROUTE: $routeName$_reset');
  }

  String _getRouteName(Route<dynamic> route) {
    if (route.settings.name != null && route.settings.name!.isNotEmpty) {
      return route.settings.name!;
    }
    return route.runtimeType.toString();
  }
}
