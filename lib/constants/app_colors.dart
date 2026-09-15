import 'package:flutter/material.dart';

class AppColors {
  // Brand Primary
  static const Color primary        = Color(0xFFFF5252); // Energetic Red/Coral (Primary Brand)
  static const Color primaryLight   = Color(0xFFFF7A00); // Warm Orange for Gradients
  static const Color primaryDark    = Color(0xFFE53935); // Deep Red for active states

  static const Gradient appGradient = LinearGradient(
    colors: [
      Color(0xFFFF5252), // primary
      Color(0xFFFF7A00), // primaryLight
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Gamified Accent Colors
  static const Color accentIndigo   = Color(0xFF6366F1); // Learning/Quiz
  static const Color accentMint     = Color(0xFF10B981); // Progress/Success
  static const Color accentGold     = Color(0xFFF59E0B); // Stars/Coins/Rewards
  static const Color accentPink     = Color(0xFFEC4899); // Fun/Profile

  // Pastel Backgrounds (for Class Cards / Kids UI)
  static const Color pastelPink     = Color(0xFFFFECEF);
  static const Color pastelIndigo   = Color(0xFFEFEAFF);
  static const Color pastelMint     = Color(0xFFE8F9F3);
  static const Color pastelGold     = Color(0xFFFFF4E8);
  static const Color pastelPurple   = Color(0xFFFDF0F8);

  // Status & Feedback Colors
  static const Color correct        = Color(0xFF22C55E); // Right Answer
  static const Color wrong          = Color(0xFFEF4444); // Wrong Answer
  static const Color unanswered     = Color(0xFFF59E0B); // Warning/Skipped
  static const Color skipped        = Color(0xFF94A3B8); // Neutral

  // Core Backgrounds
  static const Color bgLight        = Color(0xFFF8FAFC); // Main App Background (Off-white/slate)
  static const Color bgCream        = Color(0xFFFFFDF0); // Warm cream for ultra-kid mode
  static const Color bgDark         = Color(0xFF0F172A); // Dark mode bg
  static const Color cardLight      = Color(0xFFFFFFFF); // White cards
  static const Color cardDark       = Color(0xFF1E293B); // Dark cards

  // Text Colors
  static const Color textDark       = Color(0xFF0F172A); // Primary text (Black/Slate)
  static const Color textLight      = Color(0xFFF8FAFC); // White text
  static const Color textGrey       = Color(0xFF64748B); // Secondary text
  static const Color textHint       = Color(0xFFCBD5E1); // Placeholder

  // MCQ Option Colors (A, B, C, D distinct colors)
  static const Color optionA        = Color(0xFF6366F1); // Indigo
  static const Color optionB        = Color(0xFF8B5CF6); // Purple
  static const Color optionC        = Color(0xFFEC4899); // Pink
  static const Color optionD        = Color(0xFFF97316); // Orange

  // Borders & Dividers
  static const Color border         = Color(0xFFE2E8F0);
  static const Color divider        = Color(0xFFCBD5E1);
}
