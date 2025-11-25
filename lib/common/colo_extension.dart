import 'package:flutter/material.dart';

class TColor {
  // Primary Colors
  static Color get primary => const Color(0xff92A3FD);
  static Color get primaryLight => const Color(0xff9DCEFF);
  static Color get primaryColor1 => const Color(0xff92A3FD);
  static Color get primaryColor2 => const Color(0xff9DCEFF);

  // Secondary Colors
  static Color get secondary => const Color(0xffC58BF2);
  static Color get secondaryLight => const Color(0xffEEA4CE);
  static Color get secondaryColor1 => const Color(0xffC58BF2);
  static Color get secondaryColor2 => const Color(0xffEEA4CE);

  // Basic Colors
  static Color get black => const Color(0xff1D1617);
  static Color get gray => const Color(0xff786F72);
  static Color get white => Colors.white;
  static Color get lightGray => const Color(0xffF7F8F8);
  static Color get midGray => const Color(0xffAAA4A6);

  // Gradient Lists
  static List<Color> get primaryG => [primaryColor2, primaryColor1];
  static List<Color> get secondaryG => [secondaryColor2, secondaryColor1];
}
