import 'package:always_victory/controller/question_controller.dart';
import 'package:always_victory/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_constants.dart';
import '../../constants/app_text_styles.dart';

class DemoResultScreen extends StatelessWidget {
  const DemoResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final data = Get.arguments as Map<String, dynamic>;

    final int score = data["score"] ?? 0;
    final int total = data["total"] ?? 0;
    final double percent = total > 0 ? (score / total) * 100 : 0.0;

    String titleMsg;
    String subtitleMsg;
    Color accentColor;
    IconData heroIcon;

    if (percent >= 80) {
      titleMsg = "Excellent Job! 🏆";
      subtitleMsg = "You answered most questions correctly!";
      accentColor = const Color(0xFF10B981);
      heroIcon = Icons.emoji_events_rounded;
    } else if (percent >= 50) {
      titleMsg = "Good Work! 👍";
      subtitleMsg = "Keep practicing to improve your score!";
      accentColor = const Color(0xFFF59E0B);
      heroIcon = Icons.thumb_up_rounded;
    } else {
      titleMsg = "Practice Required! 💪";
      subtitleMsg = "Don't give up! Try again to score better!";
      accentColor = const Color(0xFFFF5252);
      heroIcon = Icons.fitness_center_rounded;
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(AppConstants.paddingMD),
          child: Column(
            children: [
              const SizedBox(height: 20),

              /// 1. TOP BADGE
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(color: accentColor.withValues(alpha: 0.2)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('🎉', style: TextStyle(fontSize: 14)),
                    const SizedBox(width: 6),
                    Text(
                      "TEST COMPLETED",
                      style: AppTextStyles.labelSmall.copyWith(
                        color: accentColor,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              /// 2. GLOWING ANIMATED EMBLEM
              TweenAnimationBuilder(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: const Duration(milliseconds: 900),
                curve: Curves.elasticOut,
                builder: (context, value, child) {
                  return Transform.scale(
                    scale: value,
                    child: Container(
                      width: 140,
                      height: 140,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: accentColor.withValues(alpha: 0.1),
                        boxShadow: [
                          BoxShadow(
                            color: accentColor.withValues(alpha: 0.25),
                            blurRadius: 30,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Icon(
                          heroIcon,
                          size: 70,
                          color: accentColor,
                        ),
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 24),

              /// 3. MESSAGE
              Text(
                titleMsg,
                textAlign: TextAlign.center,
                style: AppTextStyles.h2.copyWith(
                  color: AppColors.textDark,
                ),
              ),

              const SizedBox(height: 6),

              Text(
                subtitleMsg,
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyMedium,
              ),

              const SizedBox(height: 28),

              /// 4. SCORE STAT CARDS
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey.shade200),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatTile("Score", "$score", const Color(0xFF6366F1), Icons.star_rounded),
                    _buildDivider(),
                    _buildStatTile("Total", "$total", AppColors.primary, Icons.quiz_rounded),
                    _buildDivider(),
                    _buildStatTile("Accuracy", "${percent.toStringAsFixed(0)}%", accentColor, Icons.percent_rounded),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              /// 5. HOME BUTTON
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: () {
                    QuestionController.instance.resetQuizState();
                    Get.offAllNamed(AppRoutes.bottomNav);
                  },
                  icon: const Icon(Icons.home_rounded, size: 20),
                  label: Text(
                    "Back to Home",
                    style: AppTextStyles.button,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatTile(String label, String value, Color color, IconData icon) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: AppTextStyles.h4.copyWith(
            color: AppColors.textDark,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: AppTextStyles.caption,
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 36,
      width: 1,
      color: Colors.grey.shade200,
    );
  }
}
