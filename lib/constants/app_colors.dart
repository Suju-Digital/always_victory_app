import 'package:flutter/material.dart';

class AppColors {
  // Primary
  static const Color primary        = Colors.deepOrange;
  static const Color primaryLight   = Colors.deepOrangeAccent;
  static const Color primaryDark    = Colors.deepOrangeAccent;

  static const Gradient appGradient = RadialGradient(
    colors: [
      Colors.deepOrangeAccent,
      Colors.deepOrange,
      Colors.red,
    ],
    center: Alignment.topCenter,
    radius: 1.2,
  );
  // Accent
  static const Color accent         = Color(0xFF06B6D4);
  static const Color accentLight    = Color(0xFF67E8F9);

  // Status
  static const Color correct        = Color(0xFF22C55E);
  static const Color wrong          = Color(0xFFEF4444);
  static const Color unanswered     = Color(0xFFF59E0B);
  static const Color skipped        = Color(0xFF94A3B8);

  // Background
  static const Color bgLight        = Color(0xFFF8FAFC);
  static const Color bgDark         = Color(0xFF0F172A);
  static const Color cardLight      = Color(0xFFFFFFFF);
  static const Color cardDark       = Color(0xFF1E293B);

  // Text
  static const Color textDark       = Color(0xFF0F172A);
  static const Color textLight      = Color(0xFFF8FAFC);
  static const Color textGrey       = Color(0xFF64748B);
  static const Color textHint       = Color(0xFFCBD5E1);

  // Option colors (A, B, C, D)
  static const Color optionA        = Color(0xFF6366F1);
  static const Color optionB        = Color(0xFF8B5CF6);
  static const Color optionC        = Color(0xFFEC4899);
  static const Color optionD        = Color(0xFFF97316);

  // Border / Divider
  static const Color border         = Color(0xFFE2E8F0);
  static const Color divider        = Color(0xFFCBD5E1);
}
