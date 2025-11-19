import 'package:flutter/material.dart';

/// Spacing constants for consistent layout throughout the app
/// Based on 8px grid system for better design consistency
class Spacing {
  Spacing._();

  // Base spacing unit (8px)
  static const double _baseUnit = 8.0;

  // Spacing values
  static const double xs = _baseUnit * 0.5; // 4px
  static const double sm = _baseUnit * 1; // 8px
  static const double md = _baseUnit * 2; // 16px
  static const double lg = _baseUnit * 3; // 24px
  static const double xl = _baseUnit * 4; // 32px
  static const double xxl = _baseUnit * 6; // 48px
  static const double xxxl = _baseUnit * 8; // 64px

  // Specific spacing for welcome screen elements
  static const double logoSpacing = _baseUnit * 2; // 16px between logo parts
  static const double taglineSpacing = _baseUnit * 3; // 24px below logo
  static const double buttonSpacing = _baseUnit * 8; // 64px above button
  static const double screenPadding = _baseUnit * 3; // 24px screen edges
  static const double buttonHeight = _baseUnit * 7; // 56px button height
  static const double buttonRadius = _baseUnit * 3; // 24px button radius

  // EdgeInsets presets for common use cases
  static const EdgeInsets screenHorizontal = EdgeInsets.symmetric(
    horizontal: screenPadding,
  );

  static const EdgeInsets screenVertical = EdgeInsets.symmetric(
    vertical: screenPadding,
  );

  static const EdgeInsets screenAll = EdgeInsets.all(screenPadding);

  static const EdgeInsets buttonPadding = EdgeInsets.symmetric(
    horizontal: xl,
    vertical: md,
  );

  static const EdgeInsets cardPadding = EdgeInsets.all(md);

  static const EdgeInsets listItemPadding = EdgeInsets.symmetric(
    horizontal: md,
    vertical: sm,
  );

  // SizedBox presets for vertical spacing
  static const SizedBox verticalXS = SizedBox(height: xs);
  static const SizedBox verticalSM = SizedBox(height: sm);
  static const SizedBox verticalMD = SizedBox(height: md);
  static const SizedBox verticalLG = SizedBox(height: lg);
  static const SizedBox verticalXL = SizedBox(height: xl);
  static const SizedBox verticalXXL = SizedBox(height: xxl);
  static const SizedBox verticalXXXL = SizedBox(height: xxxl);

  // SizedBox presets for horizontal spacing
  static const SizedBox horizontalXS = SizedBox(width: xs);
  static const SizedBox horizontalSM = SizedBox(width: sm);
  static const SizedBox horizontalMD = SizedBox(width: md);
  static const SizedBox horizontalLG = SizedBox(width: lg);
  static const SizedBox horizontalXL = SizedBox(width: xl);
  static const SizedBox horizontalXXL = SizedBox(width: xxl);
  static const SizedBox horizontalXXXL = SizedBox(width: xxxl);

  // Border radius presets
  static const BorderRadius radiusXS = BorderRadius.all(Radius.circular(xs));
  static const BorderRadius radiusSM = BorderRadius.all(Radius.circular(sm));
  static const BorderRadius radiusMD = BorderRadius.all(Radius.circular(md));
  static const BorderRadius radiusLG = BorderRadius.all(Radius.circular(lg));
  static const BorderRadius radiusXL = BorderRadius.all(Radius.circular(xl));
  static const BorderRadius radiusButton = BorderRadius.all(
    Radius.circular(buttonRadius),
  );
}
