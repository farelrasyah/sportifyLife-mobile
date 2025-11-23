import 'package:flutter/material.dart';

/// SportifyLife Design System - Color Palette
///
/// A comprehensive color system based on a cohesive blue palette
/// that provides semantic meaning and consistent visual hierarchy.
///
/// Color Roles:
/// - Primary: Main brand identity and key actions
/// - Secondary: Supporting elements and secondary actions
/// - Accent: Highlights, notifications, and special emphasis
/// - Background: Surface colors and containers
/// - Semantic: Status colors (success, warning, error, info)
class ColorPalette {
  ColorPalette._();

  // ==================== CORE BRAND COLORS ====================

  /// Deep Twilight - The darkest brand color for maximum impact
  /// Usage: Primary text, headers, strong emphasis
  static const Color kDeepTwilight = Color(0xFF03045E);

  /// French Blue - Deep brand color for authority
  /// Usage: Primary buttons, active states, navigation
  static const Color kFrenchBlue = Color(0xFF023E8A);

  /// Bright Teal Blue - Core brand color
  /// Usage: Main brand elements, primary actions
  static const Color kBrightTealBlue = Color(0xFF0077B6);

  /// Blue Green - Balanced brand color
  /// Usage: Secondary actions, hover states
  static const Color kBlueGreen = Color(0xFF0096C7);

  /// Turquoise Surf - Vibrant accent color
  /// Usage: Highlights, active indicators, CTAs
  static const Color kTurquoiseSurf = Color(0xFF00B4D8);

  /// Sky Aqua - Light accent color
  /// Usage: Subtle highlights, secondary elements
  static const Color kSkyAqua = Color(0xFF48CAE4);

  /// Frosted Blue - Soft background color
  /// Usage: Light backgrounds, cards, containers
  static const Color kFrostedBlue = Color(0xFF90E0EF);

  /// Frosted Blue 2 - Very light background
  /// Usage: Page backgrounds, subtle containers
  static const Color kFrostedBlue2 = Color(0xFFADE8F4);

  /// Light Cyan - Minimal background color
  /// Usage: Page backgrounds, minimal containers
  static const Color kLightCyan = Color(0xFFCAF0F8);

  // ==================== SEMANTIC COLOR SYSTEM ====================

  // PRIMARY COLORS - Main brand identity
  static const Color kPrimary = kBrightTealBlue; // #0077B6
  static const Color kPrimaryDark = kFrenchBlue; // #023E8A
  static const Color kPrimaryLight = kTurquoiseSurf; // #00B4D8
  static const Color kPrimaryContainer = kFrostedBlue2; // #ADE8F4

  // SECONDARY COLORS - Supporting elements
  static const Color kSecondary = kBlueGreen; // #0096C7
  static const Color kSecondaryDark = kBrightTealBlue; // #0077B6
  static const Color kSecondaryLight = kSkyAqua; // #48CAE4
  static const Color kSecondaryContainer = kFrostedBlue; // #90E0EF

  // ACCENT COLORS - Highlights and emphasis
  static const Color kAccent = kTurquoiseSurf; // #00B4D8
  static const Color kAccentDark = kBlueGreen; // #0096C7
  static const Color kAccentLight = kSkyAqua; // #48CAE4
  static const Color kAccentContainer = kLightCyan; // #CAF0F8

  // BACKGROUND COLORS - Surfaces and containers
  static const Color kBackground = Color(0xFFFFFFFF); // Pure white
  static const Color kBackgroundSecondary = kLightCyan; // #CAF0F8
  static const Color kSurface = Color(0xFFFFFFFF); // White surface
  static const Color kSurfaceVariant = kFrostedBlue2; // #ADE8F4
  static const Color kSurfaceContainer = kFrostedBlue; // #90E0EF

  // TEXT COLORS - Typography hierarchy
  static const Color kTextPrimary = kDeepTwilight; // #03045E
  static const Color kTextSecondary = kFrenchBlue; // #023E8A
  static const Color kTextTertiary = kBrightTealBlue; // #0077B6
  static const Color kTextOnPrimary = Color(0xFFFFFFFF); // White on primary
  static const Color kTextOnSecondary = Color(0xFFFFFFFF); // White on secondary
  static const Color kTextOnAccent = Color(0xFFFFFFFF); // White on accent
  static const Color kTextDisabled = Color(0xFF9CA3AF); // Disabled text

  // ==================== SEMANTIC STATUS COLORS ====================

  // SUCCESS - Positive actions and confirmations
  static const Color kSuccess = Color(0xFF10B981); // Emerald green
  static const Color kSuccessLight = Color(0xFF6EE7B7); // Light emerald
  static const Color kSuccessContainer = Color(
    0xFFECFDF5,
  ); // Very light emerald

  // WARNING - Caution and attention needed
  static const Color kWarning = Color(0xFFF59E0B); // Amber
  static const Color kWarningLight = Color(0xFFFBBF24); // Light amber
  static const Color kWarningContainer = Color(0xFFFEF3C7); // Very light amber

  // ERROR - Errors and destructive actions
  static const Color kError = Color(0xFFEF4444); // Red
  static const Color kErrorLight = Color(0xFFF87171); // Light red
  static const Color kErrorContainer = Color(0xFFFEE2E2); // Very light red

  // INFO - Information and neutral status
  static const Color kInfo = kSkyAqua; // #48CAE4
  static const Color kInfoLight = kFrostedBlue; // #90E0EF
  static const Color kInfoContainer = kLightCyan; // #CAF0F8

  // ==================== COMPONENT-SPECIFIC COLORS ====================

  // BUTTONS
  static const Color kButtonPrimary = kPrimary; // #0077B6
  static const Color kButtonSecondary = kSecondary; // #0096C7
  static const Color kButtonAccent = kAccent; // #00B4D8
  static const Color kButtonDisabled = Color(0xFFE5E7EB); // Light gray
  static const Color kButtonTextPrimary = kTextOnPrimary; // White
  static const Color kButtonTextSecondary = kTextPrimary; // Dark blue

  // BORDERS AND DIVIDERS
  static const Color kBorder = Color(0xFFE5E7EB); // Light gray
  static const Color kBorderFocused = kPrimary; // #0077B6
  static const Color kDivider = Color(0xFFF3F4F6); // Very light gray

  // SHADOWS AND OVERLAYS
  static const Color kShadowLight = Color(0x1A000000); // 10% black
  static const Color kShadowMedium = Color(0x33000000); // 20% black
  static const Color kShadowDark = Color(0x4D000000); // 30% black
  static const Color kOverlay = Color(0x80000000); // 50% black

  // ==================== CONTEXT-SPECIFIC COLORS ====================

  // ONBOARDING SCREENS
  static const Color kOnboardingBackground = kBackgroundSecondary; // #CAF0F8
  static const Color kOnboardingTitle = kTextPrimary; // #03045E
  static const Color kOnboardingDescription = kTextSecondary; // #023E8A
  static const Color kOnboardingButton = kButtonPrimary; // #0077B6
  static const Color kOnboardingButtonIcon = kTextOnPrimary; // White
  static const Color kOnboardingDotActive = kAccent; // #00B4D8
  static const Color kOnboardingDotInactive = Color(0xFFD1D5DB); // Light gray

  // AUTHENTICATION SCREENS
  static const Color kAuthBackground = kBackground; // White
  static const Color kAuthTitle = kTextPrimary; // #03045E
  static const Color kAuthSubtitle = kTextSecondary; // #023E8A
  static const Color kAuthInputBorder = kBorder; // Light gray
  static const Color kAuthInputFocused = kBorderFocused; // #0077B6
  static const Color kAuthInputFill = kSurfaceVariant; // #ADE8F4
  static const Color kAuthButtonPrimary = kButtonPrimary; // #0077B6
  static const Color kAuthButtonText = kButtonTextPrimary; // White
  static const Color kAuthLinkText = kAccent; // #00B4D8
  static const Color kAuthDivider = kDivider; // Very light gray
  static const Color kAuthSocialBorder = kBorder; // Light gray
  static const Color kAuthPlaceholder = kTextDisabled; // Gray

  // ==================== GRADIENT DEFINITIONS ====================

  /// Primary brand gradient - Deep to bright
  static const LinearGradient kPrimaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [kFrenchBlue, kBrightTealBlue],
    stops: [0.0, 1.0],
  );

  /// Secondary gradient - Bright to vibrant
  static const LinearGradient kSecondaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [kBrightTealBlue, kTurquoiseSurf],
    stops: [0.0, 1.0],
  );

  /// Accent gradient - Vibrant to light
  static const LinearGradient kAccentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [kTurquoiseSurf, kSkyAqua],
    stops: [0.0, 1.0],
  );

  /// Background gradient - Light to minimal
  static const LinearGradient kBackgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [kFrostedBlue2, kLightCyan],
    stops: [0.0, 1.0],
  );

  /// Button gradient - Dynamic button styling
  static const LinearGradient kButtonGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [kPrimary, kSecondary],
    stops: [0.0, 1.0],
  );

  /// Hero gradient - Full spectrum for hero sections
  static const LinearGradient kHeroGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [kDeepTwilight, kFrenchBlue, kBrightTealBlue, kTurquoiseSurf],
    stops: [0.0, 0.3, 0.7, 1.0],
  );
}
