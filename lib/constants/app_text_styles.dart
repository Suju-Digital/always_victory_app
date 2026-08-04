import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  // Headings
  static const TextStyle h1 = TextStyle(fontSize: 32, fontWeight: FontWeight.w800, letterSpacing: -0.5);
  static const TextStyle h2 = TextStyle(fontSize: 26, fontWeight: FontWeight.w700, letterSpacing: -0.3);
  static const TextStyle h3 = TextStyle(fontSize: 22, fontWeight: FontWeight.w700);
  static const TextStyle h4 = TextStyle(fontSize: 18, fontWeight: FontWeight.w600);

  // Body
  static const TextStyle bodyLarge  = TextStyle(fontSize: 16, fontWeight: FontWeight.w400, height: 1.6);
  static const TextStyle bodyMedium = TextStyle(fontSize: 14, fontWeight: FontWeight.w400, height: 1.5);
  static const TextStyle bodySmall  = TextStyle(fontSize: 12, fontWeight: FontWeight.w400, height: 1.4);

  // Labels
  static const TextStyle labelLarge  = TextStyle(fontSize: 14, fontWeight: FontWeight.w600, letterSpacing: 0.5);
  static const TextStyle labelMedium = TextStyle(fontSize: 12, fontWeight: FontWeight.w600, letterSpacing: 0.4);
  static const TextStyle labelSmall  = TextStyle(fontSize: 10, fontWeight: FontWeight.w600, letterSpacing: 0.5);

  // Quiz Specific
  static const TextStyle questionText = TextStyle(fontSize: 17, fontWeight: FontWeight.w600, height: 1.6);
  static const TextStyle optionText   = TextStyle(fontSize: 15, fontWeight: FontWeight.w500, height: 1.4);
  static const TextStyle optionLabel  = TextStyle(fontSize: 15, fontWeight: FontWeight.w800, letterSpacing: 0.5);
  static const TextStyle timerText    = TextStyle(
    fontSize: 20, fontWeight: FontWeight.w800, letterSpacing: 1.0,
    color: AppColors.primary,
  );
  static const TextStyle scoreText    = TextStyle(fontSize: 56, fontWeight: FontWeight.w900, letterSpacing: -2.0);
  static const TextStyle caption      = TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: AppColors.textGrey);
  static const TextStyle button       = TextStyle(fontSize: 16, fontWeight: FontWeight.w700, letterSpacing: 0.5);
  static const TextStyle appBarTitle  = TextStyle(fontSize: 20, fontWeight: FontWeight.w800, letterSpacing: -0.3);
}
