import 'package:always_victory/controller/question_controller.dart';
import 'package:always_victory/helpers/voice_helper.dart';
import 'package:always_victory/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_constants.dart';
import '../../constants/app_text_styles.dart';

class ResultScreen extends StatefulWidget {
  const ResultScreen({super.key});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  late final int score;
  late final int total;
  late final double percent;

  @override
  void initState() {
    super.initState();
    try {
      final data = Get.arguments as Map<String, dynamic>?;
      score = data?["score"] ?? 0;
      total = data?["total"] ?? 0;
      percent = total > 0 ? (score / total) * 100 : 0.0;
    } catch (e) {
      score = 0;
      total = 0;
      percent = 0.0;
      debugPrint("ResultScreen Args Error: $e");
    }

    _initializeAndSpeak();
  }

  Future<void> _initializeAndSpeak() async {
    try {
      await VoiceHelper.init();
      await Future.delayed(const Duration(milliseconds: 800));

      String msg = "";
      if (percent >= 80) {
        msg = "Wow! You are a superstar! You scored $score out of $total. Five stars for you!";
      } else if (percent >= 50) {
        msg = "Great effort! You got $score correct answers. Keep going!";
      } else {
        msg = "Good try! Let's practice again and master this!";
      }
      await VoiceHelper.speak(msg);
    } catch (e) {
      debugPrint("Speech error: $e");
    }
  }

  @override
  void dispose() {
    VoiceHelper.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String titleMsg;
    String subtitleMsg;
    Color accentColor;
    IconData heroIcon;

    if (percent >= 80) {
      titleMsg = "Superstar Performance! 🏆";
      subtitleMsg = "Outstanding accuracy! Keep shining!";
      accentColor = const Color(0xFF10B981); // Mint Green
      heroIcon = Icons.emoji_events_rounded;
    } else if (percent >= 50) {
      titleMsg = "Great Effort! 👍";
      subtitleMsg = "Good job! A little more practice and you'll reach 100%!";
      accentColor = const Color(0xFFF59E0B); // Amber
      heroIcon = Icons.stars_rounded;
    } else {
      titleMsg = "Keep Practicing! 💪";
      subtitleMsg = "Practice makes perfect! Try again to score higher!";
      accentColor = const Color(0xFFFF5252); // Red
      heroIcon = Icons.auto_awesome_rounded;
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(AppConstants.paddingMD),
          child: Column(
            children: [
              const SizedBox(height: 10),

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
                    Text('🎉', style: const TextStyle(fontSize: 14)),
                    const SizedBox(width: 6),
                    Text(
                      "QUIZ COMPLETED",
                      style: AppTextStyles.labelSmall.copyWith(
                        color: accentColor,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

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

              /// 3. CELEBRATORY HEADLINE
              Text(
                titleMsg,
                textAlign: TextAlign.center,
                style: AppTextStyles.h2.copyWith(
                  color: AppColors.textDark,
                ),
              ),

              const SizedBox(height: 6),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  subtitleMsg,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodyMedium,
                ),
              ),

              const SizedBox(height: 16),

              /// 4. FIVE STAR RATING SYSTEM
              _buildStarRating(percent),

              const SizedBox(height: 28),

              /// 5. PERFORMANCE STAT CARDS
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
                    _buildStatTile(
                      label: "Score",
                      value: "$score / $total",
                      icon: Icons.workspace_premium_rounded,
                      color: const Color(0xFF6366F1), // Indigo
                    ),
                    _buildVerticalDivider(),
                    _buildStatTile(
                      label: "Accuracy",
                      value: "${percent.toStringAsFixed(0)}%",
                      icon: Icons.track_changes_rounded,
                      color: accentColor,
                    ),
                    _buildVerticalDivider(),
                    _buildStatTile(
                      label: "Reward",
                      value: "+12 Stars",
                      icon: Icons.stars_rounded,
                      color: const Color(0xFFF59E0B), // Gold
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 36),

              /// 6. ACTION BUTTONS
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
                    try {
                      final controller = QuestionController.instance;
                      controller.resetQuizState();
                      controller.startTimer();
                      Get.offNamed(AppRoutes.quiz);
                    } catch (e) {
                      Get.offAllNamed(AppRoutes.bottomNav);
                    }
                  },
                  icon: const Icon(Icons.refresh_rounded, size: 20),
                  label: Text(
                    "Play Again",
                    style: AppTextStyles.button,
                  ),
                ),
              ),

              const SizedBox(height: 12),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.textDark,
                    side: BorderSide(color: Colors.grey.shade300, width: 1.5),
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
                    style: AppTextStyles.button.copyWith(
                      color: AppColors.textDark,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStarRating(double percentage) {
    int starCount = 1;
    if (percentage >= 95) {
      starCount = 5;
    } else if (percentage >= 80) {
      starCount = 4;
    } else if (percentage >= 60) {
      starCount = 3;
    } else if (percentage >= 40) {
      starCount = 2;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        final isFilled = index < starCount;
        return TweenAnimationBuilder(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: Duration(milliseconds: 300 + (index * 150)),
          curve: Curves.easeOutBack,
          builder: (context, value, child) {
            return Transform.scale(
              scale: value,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3),
                child: Icon(
                  isFilled ? Icons.star_rounded : Icons.star_outline_rounded,
                  color: isFilled ? const Color(0xFFF59E0B) : Colors.grey.shade300,
                  size: 38,
                ),
              ),
            );
          },
        );
      }),
    );
  }

  Widget _buildStatTile({
    required String label,
    required String value,
    required IconData icon,
    required Color color,
  }) {
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

  Widget _buildVerticalDivider() {
    return Container(
      height: 36,
      width: 1,
      color: Colors.grey.shade200,
    );
  }
}
