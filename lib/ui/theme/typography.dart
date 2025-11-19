import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'color_palette.dart';

/// Typography theme for SportifyLife app
/// Defines all text styles used throughout the application
class AppTypography {
  AppTypography._();

  // Base font family - using Inter for modern, clean look

  // Display styles (for large text like app name)
  static TextStyle get displayLarge => GoogleFonts.inter(
    fontSize: 48.0,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
    height: 1.1,
    color: ColorPalette.kTextPrimary,
  );

  static TextStyle get displayMedium => GoogleFonts.inter(
    fontSize: 36.0,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.25,
    height: 1.2,
    color: ColorPalette.kTextPrimary,
  );

  // Headline styles (for main titles)
  static TextStyle get headlineLarge => GoogleFonts.inter(
    fontSize: 32.0,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.25,
    height: 1.25,
    color: ColorPalette.kTextPrimary,
  );

  static TextStyle get headlineMedium => GoogleFonts.inter(
    fontSize: 28.0,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.0,
    height: 1.3,
    color: ColorPalette.kTextPrimary,
  );

  // Title styles (for section titles)
  static TextStyle get titleLarge => GoogleFonts.inter(
    fontSize: 22.0,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.0,
    height: 1.27,
    color: ColorPalette.kTextPrimary,
  );

  static TextStyle get titleMedium => GoogleFonts.inter(
    fontSize: 16.0,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.15,
    height: 1.5,
    color: ColorPalette.kTextPrimary,
  );

  // Body styles (for regular text)
  static TextStyle get bodyLarge => GoogleFonts.inter(
    fontSize: 16.0,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.5,
    height: 1.5,
    color: ColorPalette.kTextSecondary,
  );

  static TextStyle get bodyMedium => GoogleFonts.inter(
    fontSize: 14.0,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.25,
    height: 1.43,
    color: ColorPalette.kTextSecondary,
  );

  // Label styles (for buttons and small text)
  static TextStyle get labelLarge => GoogleFonts.inter(
    fontSize: 14.0,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
    height: 1.43,
    color: ColorPalette.kTextPrimary,
  );

  static TextStyle get labelMedium => GoogleFonts.inter(
    fontSize: 12.0,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
    height: 1.33,
    color: ColorPalette.kTextPrimary,
  );

  // Custom styles for specific use cases

  /// Style for "Sportify" part of the logo
  static TextStyle get logoSportify => GoogleFonts.inter(
    fontSize: 48.0,
    fontWeight: FontWeight.w700,
    letterSpacing: -1.0,
    height: 1.0,
    color: ColorPalette.kTextPrimary,
  );

  /// Style for "Life" part of the logo
  static TextStyle get logoLife => GoogleFonts.inter(
    fontSize: 48.0,
    fontWeight: FontWeight.w300,
    letterSpacing: -1.0,
    height: 1.0,
    color: ColorPalette.kTextOnPrimary,
  );

  /// Style for the tagline "Everybody Can Train"
  static TextStyle get tagline => GoogleFonts.inter(
    fontSize: 18.0,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.5,
    height: 1.5,
    color: ColorPalette.kTextSecondary,
  );

  /// Style for primary button text
  static TextStyle get buttonPrimary => GoogleFonts.inter(
    fontSize: 16.0,
    fontWeight: FontWeight.bold,
    letterSpacing: 0.5,
    height: 1.25,
    color: ColorPalette.kTextButton,
  );

  /// Style for secondary button text
  static TextStyle get buttonSecondary => GoogleFonts.inter(
    fontSize: 16.0,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
    height: 1.25,
    color: ColorPalette.kTextPrimary,
  );

  // Onboarding text styles

  /// Style for onboarding title
  static TextStyle get onboardingTitle => GoogleFonts.inter(
    fontSize: 24.0,
    fontWeight: FontWeight.bold,
    letterSpacing: 0.2,
    height: 1.4,
    color: ColorPalette.kOnboardingTitle,
  );

  /// Style for onboarding description
  static TextStyle get onboardingDescription => GoogleFonts.inter(
    fontSize: 14.0,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.3,
    height: 1.6,
    color: ColorPalette.kOnboardingDescription,
  );

  // Text theme for Material Design integration
  static TextTheme get textTheme => TextTheme(
    displayLarge: displayLarge,
    displayMedium: displayMedium,
    headlineLarge: headlineLarge,
    headlineMedium: headlineMedium,
    titleLarge: titleLarge,
    titleMedium: titleMedium,
    bodyLarge: bodyLarge,
    bodyMedium: bodyMedium,
    labelLarge: labelLarge,
    labelMedium: labelMedium,
  );
}
