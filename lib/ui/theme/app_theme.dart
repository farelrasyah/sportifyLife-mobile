import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'color_palette.dart';
import 'typography.dart';
import 'spacing.dart';

/// Main theme configuration for SportifyLife app
class AppTheme {
  AppTheme._();

  /// Light theme configuration
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,

      // Color scheme
      colorScheme: const ColorScheme.light(
        primary: ColorPalette.kPrimary,
        primaryContainer: ColorPalette.kPrimaryLight,
        secondary: ColorPalette.kAccent,
        surface: ColorPalette.kSurface,
        background: ColorPalette.kBackground,
        onPrimary: ColorPalette.kTextOnPrimary,
        onSecondary: ColorPalette.kTextOnPrimary,
        onSurface: ColorPalette.kTextPrimary,
        onBackground: ColorPalette.kTextPrimary,
      ),

      // Typography
      textTheme: AppTypography.textTheme,

      // App bar theme
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
        titleTextStyle: AppTypography.titleLarge,
        iconTheme: const IconThemeData(color: ColorPalette.kTextPrimary),
      ),

      // Elevated button theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: ColorPalette.kButtonPrimary,
          foregroundColor: ColorPalette.kButtonTextPrimary,
          elevation: 8,
          shadowColor: ColorPalette.kShadowMedium,
          shape: RoundedRectangleBorder(borderRadius: Spacing.radiusButton),
          padding: Spacing.buttonPadding,
          minimumSize: const Size(double.infinity, Spacing.buttonHeight),
          textStyle: AppTypography.buttonPrimary,
        ),
      ),

      // Text button theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: ColorPalette.kPrimary,
          textStyle: AppTypography.buttonSecondary,
          padding: Spacing.buttonPadding,
        ),
      ),

      // Outlined button theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: ColorPalette.kPrimary,
          side: const BorderSide(color: ColorPalette.kPrimary, width: 1.5),
          shape: RoundedRectangleBorder(borderRadius: Spacing.radiusButton),
          padding: Spacing.buttonPadding,
          minimumSize: const Size(double.infinity, Spacing.buttonHeight),
          textStyle: AppTypography.buttonPrimary,
        ),
      ),

      // Card theme - using default for now to avoid compatibility issues
      // Input decoration theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: ColorPalette.kSurface,
        border: OutlineInputBorder(
          borderRadius: Spacing.radiusMD,
          borderSide: const BorderSide(
            color: ColorPalette.kTextSecondary,
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: Spacing.radiusMD,
          borderSide: const BorderSide(
            color: ColorPalette.kTextSecondary,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: Spacing.radiusMD,
          borderSide: const BorderSide(color: ColorPalette.kPrimary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: Spacing.radiusMD,
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
        contentPadding: Spacing.buttonPadding,
        hintStyle: AppTypography.bodyMedium,
        labelStyle: AppTypography.labelMedium,
      ),

      // Scaffold theme
      scaffoldBackgroundColor: ColorPalette.kBackground,

      // Visual density
      visualDensity: VisualDensity.adaptivePlatformDensity,
    );
  }

  /// System UI overlay style for light theme
  static const SystemUiOverlayStyle lightSystemUiOverlayStyle =
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: ColorPalette.kBackground,
        systemNavigationBarIconBrightness: Brightness.dark,
      );

  /// System UI overlay style for gradient backgrounds
  static const SystemUiOverlayStyle gradientSystemUiOverlayStyle =
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarColor: ColorPalette.kPrimaryDark,
        systemNavigationBarIconBrightness: Brightness.light,
      );
}
