import 'dart:math';

import 'package:always_victory/controller/question_controller.dart';
import 'package:always_victory/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/app_colors.dart';
import '../../widgets/score_card.dart';

class DemoResultScreen extends StatelessWidget {
  const DemoResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final data = Get.arguments as Map<String, dynamic>;

    final int score = data["score"];
    final int total = data["total"];
    final double percent = (score / total) * 100;

    ResultLevel resultLevel;
    String message;
    Color color;
    IconData icon;
    String emoji;

    if (percent >= 80) {
      resultLevel = ResultLevel.excellent;
      message = "Excellent!";
      color = AppColors.correct;
      icon = Icons.emoji_events;
      emoji = "🎉";
    } else if (percent >= 60) {
      resultLevel = ResultLevel.good;
      message = "Good Job!";
      color = AppColors.unanswered;
      icon = Icons.thumb_up;
      emoji = "👍";
    } else if (percent >= 40) {
      resultLevel = ResultLevel.average;
      message = "Keep Going!";
      color = AppColors.accent;
      icon = Icons.school;
      emoji = "📚";
    } else {
      resultLevel = ResultLevel.needsImprovement;
      message = "Keep Practicing!";
      color = AppColors.wrong;
      icon = Icons.fitness_center;
      emoji = "💪";
    }

    return Scaffold(
      backgroundColor: const Color(0xfff5f7fb),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildTrophyAnimation(color, icon, resultLevel),
                  const SizedBox(height: 20),
                  _buildMessageWithAnimation(message, color, emoji),
                  const SizedBox(height: 10),
                  _buildScoreText(score, total),
                  const SizedBox(height: 30),
                  _buildStatCards(score, total, percent, color),
                  const SizedBox(height: 40),
                  _buildHomeButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTrophyAnimation(Color color, IconData icon, ResultLevel level) {
    return TweenAnimationBuilder(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 800),
      curve: Curves.elasticOut,
      builder: (context, value, child) {
        final clampedValue = value.clamp(0.0, 1.0);

        return Transform.scale(
          scale: clampedValue,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: color,
                    width: 4,
                  ),
                ),
                child: Container(
                  width: 160,
                  height: 160,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: color.withOpacity(0.1),
                    boxShadow: [
                      BoxShadow(
                        color: color.withOpacity(0.3),
                        blurRadius: 30,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                ),
              ),
              Icon(
                icon,
                size: 100,
                color: color,
              ),
              ...List.generate(8, (index) {
                final angle = (index / 8) * 2 * pi;
                final distance = 60 + (clampedValue * 20);
                return Positioned(
                  left: 70 + cos(angle) * distance,
                  top: 70 + sin(angle) * distance,
                  child: Opacity(
                    opacity: clampedValue,
                    child: Icon(
                      _getRandomConfettiIcon(index),
                      size: 20 + (index % 2) * 10,
                      color: _getConfettiColor(index),
                    ),
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMessageWithAnimation(String message, Color color, String emoji) {
    return Column(
      children: [
        Text(
          emoji,
          style: const TextStyle(fontSize: 40),
        ),
        const SizedBox(height: 8),
        Text(
          message,
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildScoreText(int score, int total) {
    return TweenAnimationBuilder(
      tween: IntTween(begin: 0, end: score),
      duration: const Duration(milliseconds: 1000),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Text(
          "Your Score: $value / $total",
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        );
      },
    );
  }

  Widget _buildStatCards(int score, int total, double percent, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildAnimatedStatCard(
          label: "Score",
          value: "$score",
          color: AppColors.accent,
          icon: Icons.star,
          delay: 0,
        ),
        _buildAnimatedStatCard(
          label: "Total",
          value: "$total",
          color: AppColors.primary,
          icon: Icons.list,
          delay: 200,
        ),
        _buildAnimatedStatCard(
          label: "Result",
          value: "${percent.toStringAsFixed(0)}%",
          color: color,
          icon: Icons.percent,
          delay: 400,
        ),
      ],
    );
  }

  Widget _buildAnimatedStatCard({
    required String label,
    required String value,
    required Color color,
    required IconData icon,
    required int delay,
  }) {
    return TweenAnimationBuilder(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
      child: ScoreStatCard(
        label: label,
        value: value,
        color: color,
        icon: icon,
      ),
      builder: (context, value, child) {
        final clampedValue = value.clamp(0.0, 1.0);
        return Transform.translate(
          offset: Offset(0, 50 * (1 - clampedValue)),
          child: Opacity(
            opacity: clampedValue,
            child: child,
          ),
        );
      },
    );
  }

  Widget _buildHomeButton() {
    return TextButton(
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
      ),
      onPressed: () {
        _goHome();
      },
      child: const Text(
        "Go Home",
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  void _goHome() {
    QuestionController.instance.resetQuizState();
    Get.offAllNamed(AppRoutes.bottomNav);
  }

  IconData _getRandomConfettiIcon(int index) {
    final icons = [
      Icons.star,
      Icons.star_half,
      Icons.circle,
      Icons.square,
      Icons.favorite,
      Icons.emoji_emotions,
      Icons.celebration,
    ];
    return icons[index % icons.length];
  }

  Color _getConfettiColor(int index) {
    final colors = [
      Colors.red,
      Colors.orange,
      Colors.yellow,
      Colors.green,
      Colors.blue,
      Colors.purple,
      Colors.pink,
      Colors.teal,
    ];
    return colors[index % colors.length];
  }
}

enum ResultLevel {
  excellent,
  good,
  average,
  needsImprovement,
}
