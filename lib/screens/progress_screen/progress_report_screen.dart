import 'package:always_victory/constants/app_colors.dart';
import 'package:always_victory/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/class_controller.dart';
import '../../controller/progress_controller.dart';

class ProgressReportScreen extends GetView<ProgressController> {
  const ProgressReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    final classController = Get.find<ClassController>();

    return Scaffold(
      backgroundColor: const Color(0xffF5F7FB),
      appBar: AppBar(
        title: Row(
          children: [
            const Text('📊', style: TextStyle(fontSize: 24)),
            const SizedBox(width: 8),
            const Text(
              "My Progress",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 20,
              ),
            ),
          ],
        ),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 4,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: AppColors.appGradient,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.emoji_events, color: Colors.amber),
            onPressed: () {
              Get.snackbar(
                '🏆 Achievements',
                'Keep learning to unlock more badges!',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.amber.shade100,
                duration: const Duration(seconds: 2),
              );
            },
          ),
        ],
      ),
      body: Obx(
            () => SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              /// Welcome Header Card with Animation
              TweenAnimationBuilder(
                duration: const Duration(milliseconds: 600),
                tween: Tween<double>(begin: 0, end: 1),
                curve: Curves.easeOutBack,
                builder: (context, value, child) {
                  return Transform.scale(
                    scale: 0.9 + (0.1 * value),
                    child: Opacity(
                      opacity: value.clamp(0.0, 1.0),
                      child: child,
                    ),
                  );
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    gradient:AppColors.appGradient,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: const Text(
                              '👋',
                              style: TextStyle(fontSize: 28),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  authController.student.value.name ?? "No Name",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.amber.withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Text(
                                        '📚',
                                        style: TextStyle(fontSize: 14),
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        "Class ${authController.student.value.className}",
                                        style: const TextStyle(
                                          color: Colors.white70,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.amber.withOpacity(0.3),
                              shape: BoxShape.circle,
                            ),
                            child: const Text(
                              '⭐',
                              style: TextStyle(fontSize: 24),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 16,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Column(
                                children: [
                                  Obx(() => Text(
                                    "${controller.accuracy.value.toStringAsFixed(0)}%",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )),
                                  const Text(
                                    "🎯 Overall Accuracy",
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 13,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Obx(() => LinearProgressIndicator(
                                    value: controller.accuracy.value / 100,
                                    backgroundColor: Colors.white.withOpacity(0.2),
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      controller.accuracy.value >= 75
                                          ? Colors.green
                                          : controller.accuracy.value >= 50
                                          ? Colors.orange
                                          : Colors.red,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  )),
                                  const SizedBox(height: 4),
                                  Obx(() => Text(
                                    "${controller.correctAnswers.value}/${controller.totalQuestions.value} Questions",
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 12,
                                    ),
                                  )),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              /// Stats with Emojis
              TweenAnimationBuilder(
                duration: const Duration(milliseconds: 800),
                tween: Tween<double>(begin: 0, end: 1),
                curve: Curves.easeOut,
                builder: (context, value, child) {
                  return Opacity(
                    opacity: value.clamp(0.0, 1.0),
                    child: Transform.translate(
                      offset: Offset(0, 20 * (1 - value)),
                      child: child,
                    ),
                  );
                },
                child: Row(
                  children: [
                    Expanded(
                      child: _statCard(
                        "📝 Questions",
                        controller.totalQuestions.value.toString(),
                        Icons.quiz,
                        AppColors.accent,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _statCard(
                        "✅ Correct",
                        controller.correctAnswers.value.toString(),
                        Icons.check_circle,
                        AppColors.correct,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              /// Motivation Card
              TweenAnimationBuilder(
                duration: const Duration(milliseconds: 1000),
                tween: Tween<double>(begin: 0, end: 1),
                curve: Curves.easeOut,
                builder: (context, value, child) {
                  return Opacity(
                    opacity: value.clamp(0.0, 1.0),
                    child: child,
                  );
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primary.withOpacity(0.1),
                        AppColors.primary.withOpacity(0.2),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.primary.withOpacity(0.3),
                      width: 2,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.amber.shade200,
                          shape: BoxShape.circle,
                        ),
                        child: const Text(
                          '🏆',
                          style: TextStyle(fontSize: 28),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "🌟 Keep Going!",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.deepOrange,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              "Tap a class below to see your detailed progress!",
                              style: TextStyle(
                                color: Colors.grey.shade700,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Text(
                        '🚀',
                        style: TextStyle(fontSize: 30),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              /// Classes Progress List
              Obx(() {
                if (classController.classes.isEmpty) {
                  return Container(
                    padding: const EdgeInsets.all(40),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          '📚',
                          style: TextStyle(fontSize: 60),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "No Classes Yet",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Start learning to track your progress! 🌟",
                          style: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: classController.classes.length,
                  itemBuilder: (context, classIndex) {
                    final cls = classController.classes[classIndex];

                    return TweenAnimationBuilder(
                      duration: Duration(milliseconds: 300 + (classIndex * 50)),
                      tween: Tween<double>(begin: 0, end: 1),
                      curve: Curves.easeOutBack,
                      builder: (context, value, child) {
                        return Opacity(
                          opacity: value.clamp(0.0, 1.0),
                          child: Transform.translate(
                            offset: Offset(50 * (1 - value), 0),
                            child: child,
                          ),
                        );
                      },
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        margin: const EdgeInsets.only(bottom: 12),
                        child: Theme(
                          data: Theme.of(context).copyWith(
                            dividerColor: Colors.transparent,
                          ),
                          child: ExpansionTile(
                            leading: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Text(
                                '📖',
                                style: TextStyle(fontSize: 24),
                              ),
                            ),
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  cls.className,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                Obx(() {
                                  final progress = controller.getClassProgress(cls.id);
                                  final totalQ = controller.getClassTotalQuestions(cls.id);
                                  final solvedQ = controller.getClassSolvedQuestions(cls.id);

                                  return Row(
                                    children: [
                                      Text(
                                        '📊 ${progress.toStringAsFixed(0)}%',
                                        style: TextStyle(
                                          color: controller.getProgressColor(progress),
                                          fontWeight: FontWeight.w600,
                                          fontSize: 13,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        '📝 $solvedQ/$totalQ',
                                        style: TextStyle(
                                          color: Colors.grey.shade600,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  );
                                }),
                              ],
                            ),

                            onExpansionChanged: (expanded) async {
                              if (expanded) {
                                try {
                                  await controller.loadDays(
                                    cls.id,
                                    forceRefresh: true,
                                  );
                                } catch (e) {
                                  Get.snackbar(
                                    'Error',
                                    'Failed to load days. Please try again.',
                                    snackPosition: SnackPosition.BOTTOM,
                                    backgroundColor: Colors.red.shade100,
                                  );
                                }
                              }
                            },
                            children: [
                              Obx(() {
                                final days = controller.classDays[cls.id] ?? [];

                                if (days.isEmpty) {
                                  return Container(
                                    padding: const EdgeInsets.all(20),
                                    child: Column(
                                      children: [
                                        const Text(
                                          '📅',
                                          style: TextStyle(fontSize: 40),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          "No days available yet",
                                          style: TextStyle(
                                            color: Colors.grey.shade600,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          "Check back later! 📚",
                                          style: TextStyle(
                                            color: Colors.grey.shade500,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }

                                return Column(
                                  children: days.map((day) {
                                    return Card(
                                      margin: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      child: ExpansionTile(
                                        leading: Container(
                                          padding: const EdgeInsets.all(6),
                                          decoration: BoxDecoration(
                                            color: AppColors.accent.withOpacity(0.1),
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Text(
                                            '📅',
                                            style: TextStyle(fontSize: 20),
                                          ),
                                        ),
                                        title: Text(
                                          day.dayName,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),

                                        onExpansionChanged: (expanded) async {
                                          if (expanded) {
                                            try {
                                              await controller.loadAttempts(
                                                studentId: int.parse(
                                                  authController.student.value.id ?? '0',
                                                ),
                                                classId: cls.id,
                                                dayId: day.id,
                                              );
                                            } catch (e) {
                                              Get.snackbar(
                                                'Error',
                                                'Failed to load attempts.',
                                                snackPosition: SnackPosition.BOTTOM,
                                                backgroundColor: Colors.red.shade100,
                                              );
                                            }
                                          }
                                        },
                                        children: [
                                          Obx(() {
                                            final key = "${cls.id}_${day.id}";
                                            final attemptData = controller.attempts[key];

                                            if (attemptData == null) {
                                              return Container(
                                                padding: const EdgeInsets.all(20),
                                                child: const Center(
                                                  child: CircularProgressIndicator(
                                                    valueColor: AlwaysStoppedAnimation<Color>(
                                                      Colors.deepPurple,
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }

                                            if (attemptData.data.isEmpty) {
                                              return Container(
                                                padding: const EdgeInsets.all(20),
                                                child: Column(
                                                  children: [
                                                    const Text(
                                                      '🎯',
                                                      style: TextStyle(fontSize: 40),
                                                    ),
                                                    const SizedBox(height: 8),
                                                    Text(
                                                      "No attempts yet",
                                                      style: TextStyle(
                                                        color: Colors.grey.shade600,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 4),
                                                    Text(
                                                      "Keep practicing! 💪",
                                                      style: TextStyle(
                                                        color: Colors.grey.shade500,
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            }

                                            return ListView.builder(
                                              shrinkWrap: true,
                                              physics: const NeverScrollableScrollPhysics(),
                                              itemCount: attemptData.data.length,
                                              itemBuilder: (context, attemptIndex) {
                                                final attempt = attemptData.data[attemptIndex];

                                                return Container(
                                                  margin: const EdgeInsets.symmetric(
                                                    horizontal: 8,
                                                    vertical: 4,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    gradient: LinearGradient(
                                                      colors: [
                                                        AppColors.primary.withOpacity(0.05),
                                                        AppColors.primary.withOpacity(0.1),
                                                      ],
                                                      begin: Alignment.topLeft,
                                                      end: Alignment.bottomRight,
                                                    ),
                                                    borderRadius: BorderRadius.circular(12),
                                                    border: Border.all(
                                                      color: AppColors.primary.withOpacity(0.2),
                                                      width: 1,
                                                    ),
                                                  ),
                                                  child: ListTile(
                                                    leading: Container(
                                                      width: 40,
                                                      height: 40,
                                                      decoration: const BoxDecoration(
                                                        gradient: AppColors.appGradient,
                                                        shape: BoxShape.circle,
                                                      ),
                                                      child: Center(
                                                        child: Text(
                                                          "${attempt.attemptNo}",
                                                          style: const TextStyle(
                                                            color: Colors.white,
                                                            fontWeight: FontWeight.bold,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    title: Text(
                                                      "🎯 Attempt ${attempt.attemptNo}",
                                                      style: const TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 15,
                                                      ),
                                                    ),
                                                    subtitle: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        const SizedBox(height: 4),
                                                        Text(
                                                          controller.getStars(attempt.percentage),
                                                          style: const TextStyle(fontSize: 16),
                                                        ),
                                                        const SizedBox(height: 6),
                                                        ClipRRect(
                                                          borderRadius: BorderRadius.circular(10),
                                                          child: LinearProgressIndicator(
                                                            value: attempt.percentage / 100,
                                                            minHeight: 8,
                                                            backgroundColor: Colors.grey.shade200,
                                                            valueColor: AlwaysStoppedAnimation<Color>(
                                                              attempt.percentage >= 75
                                                                  ? Colors.green
                                                                  : attempt.percentage >= 50
                                                                  ? Colors.orange
                                                                  : Colors.red,
                                                            ),
                                                          ),
                                                        ),
                                                        const SizedBox(height: 4),
                                                        Row(
                                                          children: [
                                                            const Text(
                                                              '✅ ',
                                                              style: TextStyle(fontSize: 12),
                                                            ),
                                                            Text(
                                                              "${attempt.correctAnswers}/${attempt.totalQuestions} Correct",
                                                              style: TextStyle(
                                                                color: Colors.grey.shade600,
                                                                fontSize: 12,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                    trailing: Container(
                                                      padding: const EdgeInsets.symmetric(
                                                        horizontal: 12,
                                                        vertical: 8,
                                                      ),
                                                      decoration: BoxDecoration(
                                                        gradient: LinearGradient(
                                                          colors: attempt.percentage >= 75
                                                              ? [Colors.green.shade400, Colors.green.shade700]
                                                              : attempt.percentage >= 50
                                                              ? [Colors.orange.shade400, Colors.orange.shade700]
                                                              : [Colors.red.shade400, Colors.red.shade700],
                                                        ),
                                                        borderRadius: BorderRadius.circular(20),
                                                      ),
                                                      child: Text(
                                                        "${attempt.percentage.toStringAsFixed(0)}%",
                                                        style: const TextStyle(
                                                          color: Colors.white,
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                            );
                                          }),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                );
                              }),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              }),

              const SizedBox(height: 20),

              /// Fun Footer
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primary.withOpacity(0.05),
                      AppColors.primary.withOpacity(0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildFooterItem('🌟', 'Learn'),
                    _buildFooterItem('📝', 'Practice'),
                    _buildFooterItem('🏆', 'Achieve'),
                    _buildFooterItem('🎯', 'Master'),
                  ],
                ),
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFooterItem(String emoji, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TweenAnimationBuilder(
          duration: const Duration(seconds: 2),
          tween: Tween<double>(begin: 1, end: 1.2),
          curve: Curves.elasticInOut,
          builder: (context, value, child) {
            return Transform.scale(
              scale: value,
              child: child,
            );
          },
          child: Text(
            emoji,
            style: const TextStyle(fontSize: 28),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _statCard(
      String title,
      String value,
      IconData icon,
      Color color,
      ) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 30,
              color: color,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
}