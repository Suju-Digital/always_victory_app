import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTextStyles {
  // Headings (Using GoogleFonts.outfit for punchy, bold titles)
  static TextStyle get h1 => GoogleFonts.outfit(fontSize: 26, fontWeight: FontWeight.w800, letterSpacing: -0.5, color: AppColors.textDark);
  static TextStyle get h2 => GoogleFonts.outfit(fontSize: 22, fontWeight: FontWeight.w800, letterSpacing: -0.3, color: AppColors.textDark);
  static TextStyle get h3 => GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.textDark);
  static TextStyle get h4 => GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textDark);

  // Body text (Using GoogleFonts.poppins for clean, highly readable content)
  static TextStyle get bodyLarge  => GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w600, height: 1.5, color: AppColors.textDark);
  static TextStyle get bodyMedium => GoogleFonts.poppins(fontSize: 13.5, fontWeight: FontWeight.w400, height: 1.6, color: const Color(0xFF334155));
  static TextStyle get bodySmall  => GoogleFonts.poppins(fontSize: 11.5, fontWeight: FontWeight.w400, height: 1.4, color: AppColors.textGrey);

  // Labels & Badges
  static TextStyle get labelLarge  => GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.bold, letterSpacing: 0.5);
  static TextStyle get labelMedium => GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 0.4);
  static TextStyle get labelSmall  => GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 0.5);

  // Specific UI Elements
  static TextStyle get button       => GoogleFonts.outfit(fontSize: 15, fontWeight: FontWeight.w800, letterSpacing: 0.8, color: Colors.white);
  static TextStyle get appBarTitle  => GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.w800, letterSpacing: -0.3, color: AppColors.textDark);
  static TextStyle get caption      => GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textGrey);

  // Gamified & Quiz Elements
  static TextStyle get questionText => GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w700, height: 1.4, color: AppColors.textDark);
  static TextStyle get optionText   => GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, height: 1.4);
  static TextStyle get optionLabel  => GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w800, letterSpacing: 0.5);
  static TextStyle get timerText    => GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.w900, letterSpacing: 1.0, color: AppColors.primary);
  static TextStyle get scoreText    => GoogleFonts.outfit(fontSize: 42, fontWeight: FontWeight.w900, letterSpacing: -2.0, color: AppColors.primary);
}
