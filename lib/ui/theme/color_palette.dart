import 'package:flutter/material.dart';

/// SportifyLife Application Color Scheme
/// Professional color management system for consistent branding
class ColorPalette {
  ColorPalette._();

  // Brand Colors
  static const Color kBrandBlue = Color(0xFF92A3FD);
  static const Color kBrandSkyBlue = Color(0xFF9DCEFF);
  static const Color kAccentViolet = Color(0xFFC58BF2);
  static const Color kAccentRose = Color(0xFFEEA4CE);

  // Neutral Colors
  static const Color kCharcoal = Color(0xFF1D1617);
  static const Color kStoneGray = Color(0xFF786F72);
  static const Color kMediumGray = Color(0xFFAAA4A6);
  static const Color kCloudWhite = Color(0xFFF7F8F8);
  static const Color kPureWhite = Colors.white;

  // Semantic Colors
  static const Color kPrimary = kBrandBlue;
  static const Color kPrimaryVariant = kBrandSkyBlue;
  static const Color kSecondary = kAccentViolet;
  static const Color kSecondaryVariant = kAccentRose;
  static const Color kBackground = kPureWhite;
  static const Color kSurface = kCloudWhite;

  // Text Colors
  static const Color kTextPrimary = kCharcoal;
  static const Color kTextSecondary = kStoneGray;
  static const Color kTextTertiary = kMediumGray;
  static const Color kTextOnPrimary = kPureWhite;
  static const Color kTextOnSecondary = kPureWhite;

  // Component Colors
  static const Color kButton = kBrandBlue;
  static const Color kButtonText = kPureWhite;
  static const Color kBorder = kMediumGray;
  static const Color kBorderFocus = kBrandBlue;
  static const Color kDivider = kCloudWhite;
  static const Color kShadow = Color(0x1A000000);
  static const Color kOverlay = Color(0x80000000);
  static const Color kDisabled = kMediumGray;

  // Status Colors
  static const Color kError = Color(0xFFEF4444);
  static const Color kSuccess = Color(0xFF10B981);
  static const Color kWarning = Color(0xFFF59E0B);

  // Gradients
  static const LinearGradient brandGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [kBrandSkyBlue, kBrandBlue],
    stops: [0.0, 1.0],
  );

  static const LinearGradient accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [kAccentRose, kAccentViolet],
    stops: [0.0, 1.0],
  );

  static const LinearGradient softBackgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [kPureWhite, kCloudWhite],
    stops: [0.0, 1.0],
  );

  static const LinearGradient heroGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [kBrandSkyBlue, kBrandBlue, kAccentViolet, kAccentRose],
    stops: [0.0, 0.35, 0.65, 1.0],
  );

  // Gradient Arrays
  static List<Color> get brandGradientColors => [kBrandSkyBlue, kBrandBlue];
  static List<Color> get accentGradientColors => [kAccentRose, kAccentViolet];

  // Legacy Support (Backward Compatibility)
  @Deprecated('Use kBrandBlue instead')
  static Color get primaryColor1 => kBrandBlue;

  @Deprecated('Use kBrandSkyBlue instead')
  static Color get primaryColor2 => kBrandSkyBlue;

  @Deprecated('Use kAccentViolet instead')
  static Color get secondaryColor1 => kAccentViolet;

  @Deprecated('Use kAccentRose instead')
  static Color get secondaryColor2 => kAccentRose;

  @Deprecated('Use brandGradientColors instead')
  static List<Color> get primaryG => brandGradientColors;

  @Deprecated('Use accentGradientColors instead')
  static List<Color> get secondaryG => accentGradientColors;

  @Deprecated('Use kCharcoal instead')
  static Color get black => kCharcoal;

  @Deprecated('Use kStoneGray instead')
  static Color get gray => kStoneGray;

  @Deprecated('Use kPureWhite instead')
  static Color get white => kPureWhite;

  @Deprecated('Use kCloudWhite instead')
  static Color get lightGray => kCloudWhite;
}
