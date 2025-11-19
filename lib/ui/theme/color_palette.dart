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
  static const Color kTextSecondary = Color(0xFF6B7280); // Gray text (tagline)
  static const Color kTextOnPrimary = Color(0xFFFFFFFF); // White text (Life)
  static const Color kTextButton = Color(0xFF92A3FD); // Button text color

  // Background colors
  static const Color kBackground = Color(0xFFFFFFFF); // White background
  static const Color kSurface = Color(0xFFFFFFFF); // Surface color
  static const Color kButtonBackground = Color(0xFFFFFFFF); // Button background

  // Shadow colors
  static const Color kShadowLight = Color(0x1A000000); // Light shadow
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
