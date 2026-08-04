import 'package:always_victory/controller/question_controller.dart';
import 'package:always_victory/helpers/voice_helper.dart';
import 'package:always_victory/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math' as math;

import '../../constants/app_colors.dart';
import '../../widgets/score_card.dart';

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
    
    // Initialize Voice and Speak
    _initializeAndSpeak();
  }

  Future<void> _initializeAndSpeak() async {
    try {
      await VoiceHelper.init();
      // Wait for animations to start
      await Future.delayed(const Duration(milliseconds: 1200));
      
      String msg = "";
      if (percent >= 80) {
        msg = "वाह! आप एक सुपरस्टार हैं! आपको $score में से $total मिले। आपके लिए पाँच सितारे!";
      } else if (percent >= 50) {
        msg = "बहुत अच्छा प्रयास! आपको $score सही उत्तर मिले। आगे बढ़ते रहें, और अगली बार आप और भी ज्यादा सितारे पाएँगे!";
      } else {
        msg = "अच्छा प्रयास! आपको $score सही उत्तर मिले। आइए फिर से अभ्यास करें और मास्टर बनें!";
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
    String message;
    Color color;
    IconData icon;

    if (percent >= 80) {
      message = "Excellent! 🏆";
      color = AppColors.correct;
      icon = Icons.emoji_events_rounded;
    } else if (percent >= 50) {
      message = "Great Work! 👍";
      color = AppColors.unanswered;
      icon = Icons.stars_rounded;
    } else {
      message = "Good Effort! 💪";
      color = AppColors.wrong;
      icon = Icons.auto_awesome_rounded;
    }

    return Scaffold(
      backgroundColor: const Color(0xfff5f7fb),
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              color.withOpacity(0.05),
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                const SizedBox(height: 30),

                // 🎉 Celebration Header
                Text(
                  "Quiz Completed!",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade600,
                    letterSpacing: 1.2,
                  ),
                ),

                const SizedBox(height: 20),

                /// 🎉 Animated Trophy/Icon
                TweenAnimationBuilder(
                  tween: Tween(begin: 0.0, end: 1.0),
                  duration: const Duration(milliseconds: 1000),
                  curve: Curves.elasticOut,
                  builder: (context, value, child) {
                    return Transform.scale(
                      scale: value,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Glow Background
                          Container(
                            width: 160,
                            height: 160,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: color.withOpacity(0.1),
                              boxShadow: [
                                BoxShadow(
                                  color: color.withOpacity(0.2),
                                  blurRadius: 40,
                                  spreadRadius: 10,
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            icon,
                            size: 80,
                            color: color,
                          ),
                        ],
                      ),
                    );
                  },
                ),

                const SizedBox(height: 20),

                /// 🧠 Big Result Message
                TweenAnimationBuilder(
                  tween: Tween(begin: 0.0, end: 1.0),
                  duration: const Duration(milliseconds: 800),
                  builder: (context, value, child) {
                    return Opacity(
                      opacity: value,
                      child: Transform.translate(
                        offset: Offset(0, 20 * (1 - value)),
                        child: child,
                      ),
                    );
                  },
                  child: Text(
                    message,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Stars System
                _buildStarRating(percent),

                const SizedBox(height: 24),

                /// 📦 Stats Area
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _statItem("Score", "$score/$total", AppColors.accent,
                            Icons.workspace_premium),
                        _divider(),
                        _statItem("Accuracy", "${percent.toStringAsFixed(0)}%",
                            color, Icons.track_changes),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                /// 🔄 Actions
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            elevation: 8,
                            shadowColor: AppColors.primary.withOpacity(0.4),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                          ),
                          onPressed: () {
                          // Clean reset and Play Again
                          try {
                            final controller = QuestionController.instance;
                            controller.resetQuizState();
                            controller.startTimer();
                            Get.offNamed(AppRoutes.quiz);
                          } catch (e) {
                            Get.snackbar(
                              "Error",
                              "Could not restart quiz. Returning home.",
                              backgroundColor: Colors.red.shade100,
                              snackPosition: SnackPosition.BOTTOM,
                            );
                            Future.delayed(const Duration(seconds: 1), () {
                              Get.offAllNamed(AppRoutes.bottomNav);
                            });
                          }
                        },
                          icon: const Icon(Icons.refresh_rounded),
                          label: const Text(
                            "Play Again",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextButton(
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.grey.shade700,
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 24),
                        ),
                        onPressed: () {
                        QuestionController.instance.resetQuizState();
                        Get.offAllNamed(AppRoutes.bottomNav);
                      },
                        child: const Text(
                          "Go Home",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStarRating(double percentage) {
    int starCount = 0;
    if (percentage >= 95) starCount = 5;
    else if (percentage >= 80) starCount = 4;
    else if (percentage >= 60) starCount = 3;
    else if (percentage >= 40) starCount = 2;
    else starCount = 1;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        return TweenAnimationBuilder(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: Duration(milliseconds: 400 + (index * 200)),
          curve: Curves.easeOutBack,
          builder: (context, value, child) {
            return Transform.scale(
              scale: value,
              child: Icon(
                index < starCount ? Icons.star_rounded : Icons.star_outline_rounded,
                color: index < starCount ? Colors.amber : Colors.grey.shade300,
                size: 45,
              ),
            );
          },
        );
      }),
    );
  }

  Widget _statItem(String label, String value, Color color, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: color.withOpacity(0.7), size: 24),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _divider() {
    return Container(
      height: 40,
      width: 1,
      color: Colors.grey.shade200,
    );
  }
}
