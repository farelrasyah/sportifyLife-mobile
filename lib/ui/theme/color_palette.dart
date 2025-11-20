import 'package:flutter/material.dart';

/// Color palette for SportifyLife app
/// All colors extracted from the welcome screen design
class ColorPalette {
  ColorPalette._();

  // Primary gradient colors (from the background)
  static const Color kGradientStart = Color(0xFF9DCEFF); // Light blue at top
  static const Color kGradientEnd = Color(0xFF92A3FD); // Purple at bottom

  // Primary brand colors
  static const Color kPrimary = Color(0xFF92A3FD); // Main brand purple
  static const Color kPrimaryLight = Color(0xFF9DCEFF); // Light brand blue
  static const Color kAccent = Color(0xFF92A3FD); // Accent purple

  // Text colors
  static const Color kTextPrimary = Color(0xFF1F2937); // Dark text (Sportify)
  static const Color kTextSecondary = Color(0xFF4B5563); // Gray text (tagline)
  static const Color kTextOnPrimary = Color(0xFFFFFFFF); // White text (Life)
  static const Color kTextButton = Color(0xFF92A3FD); // Button text color

  // Background colors
  static const Color kBackground = Color(0xFFFFFFFF); // White background
  static const Color kSurface = Color(0xFFFFFFFF); // Surface color
  static const Color kButtonBackground = Color(0xFFFFFFFF); // Button background

  // Shadow colors
  static const Color kShadowLight = Color(0x1A000000); // Light shadow

  // Onboarding colors
  static const Color kOnboardingBackground = Color(
    0xFF92B4FF,
  ); // Blue background
  static const Color kOnboardingTitle = Color(0xFF1D1617); // Dark title
  static const Color kOnboardingDescription = Color(
    0xFF7B6F72,
  ); // Gray description
  static const Color kOnboardingButton = Color(0xFF92A3FD); // Blue button
  static const Color kOnboardingButtonIcon = Color(0xFFFFFFFF); // White icon
  static const Color kOnboardingDotActive = Color(0xFF92A3FD); // Active dot
  static const Color kOnboardingDotInactive = Color(0xFFD0D0D0); // Inactive dot

  // Auth screen colors - Modern & Elegant
  static const Color kAuthBackground = Color(0xFFFFFFFF); // Pure white
  static const Color kAuthTitle = Color(0xFF1A1A1A); // Deep black
  static const Color kAuthSubtitle = Color(0xFF6B7280); // Soft gray
  static const Color kAuthInputBorder = Color(0xFFE5E7EB); // Light gray border
  static const Color kAuthInputFocused = Color(0xFF92A3FD); // Blue focused
  static const Color kAuthInputFill = Color(0xFFF9FAFB); // Very light gray fill
  static const Color kAuthButtonPrimary = Color(0xFF92A3FD); // Primary blue
  static const Color kAuthButtonText = Color(0xFFFFFFFF); // White text
  static const Color kAuthLinkText = Color(0xFF92A3FD); // Blue link
  static const Color kAuthDivider = Color(0xFFE5E7EB); // Divider gray
  static const Color kAuthSocialBorder = Color(
    0xFFE5E7EB,
  ); // Social button border
  static const Color kAuthPlaceholder = Color(0xFF9CA3AF); // Placeholder text
  static const Color kShadowMedium = Color(0x33000000); // Medium shadow

  // Gradient definitions
  static const LinearGradient kPrimaryGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [kGradientStart, kGradientEnd],
    stops: [0.0, 1.0],
  );

  static const LinearGradient kButtonGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [kBackground, kBackground],
  );
}
