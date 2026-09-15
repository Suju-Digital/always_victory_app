import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_constants.dart';
import '../../constants/app_text_styles.dart';
import '../../controller/auth_controller.dart';
import '../../controller/class_controller.dart';
import '../../controller/progress_controller.dart';

class ProgressReportScreen extends GetView<ProgressController> {
  const ProgressReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    final classController = Get.find<ClassController>();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(
          "Parent Progress Report",
          style: AppTextStyles.appBarTitle.copyWith(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: AppColors.appGradient,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.stars_rounded, color: Color(0xFFF59E0B)),
            onPressed: () {
              Get.snackbar(
                '🏆 Reward Badges',
                'Your child has earned 120 star coins!',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.amber.shade100,
                colorText: Colors.amber.shade900,
              );
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        color: AppColors.primary,
        backgroundColor: Colors.white,
        onRefresh: () async {
          final studentId = int.tryParse(authController.student.value.id ?? '0') ?? 0;
          if (studentId > 0) {
            await controller.getProgress(studentId);
          }
          await ClassController.instance.getAllClassesProgress();
        },
        child: Obx(
          () => SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            padding: const EdgeInsets.all(AppConstants.paddingMD),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              /// 1. STUDENT PROFILE & OVERALL ACCURACY CARD
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: AppColors.appGradient,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.25),
                      blurRadius: 15,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Header: Student Name & Class
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 24,
                          backgroundColor: Colors.white.withValues(alpha: 0.2),
                          child: const Text('👨‍🎓', style: TextStyle(fontSize: 24)),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                authController.student.value.name ?? "Student",
                                style: AppTextStyles.h3.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  "Class ${authController.student.value.className ?? 'Practice'}",
                                  style: AppTextStyles.labelSmall.copyWith(
                                    color: Colors.white,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF59E0B),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.stars_rounded,
                                color: Colors.white,
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                "120",
                                style: AppTextStyles.labelSmall.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Overall Accuracy Gauge Box
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "🎯 Overall Accuracy",
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                "${controller.accuracy.value.toStringAsFixed(0)}%",
                                style: AppTextStyles.h2.copyWith(
                                  color: Colors.white,
                                  fontSize: 24,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: LinearProgressIndicator(
                              value: controller.accuracy.value / 100,
                              minHeight: 8,
                              backgroundColor: Colors.white.withValues(alpha: 0.2),
                              valueColor: AlwaysStoppedAnimation<Color>(
                                controller.accuracy.value >= 75
                                    ? const Color(0xFF10B981)
                                    : controller.accuracy.value >= 50
                                        ? const Color(0xFFF59E0B)
                                        : const Color(0xFFFF5252),
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Total Questions Answered",
                                style: AppTextStyles.caption.copyWith(
                                  color: Colors.white70,
                                ),
                              ),
                              Text(
                                "${controller.correctAnswers.value} / ${controller.totalQuestions.value} Correct",
                                style: AppTextStyles.caption.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              /// 2. KPI PERFORMANCE GRID
              Row(
                children: [
                  Expanded(
                    child: _buildKpiCard(
                      title: "Questions",
                      value: "${controller.totalQuestions.value}",
                      icon: Icons.quiz_rounded,
                      color: const Color(0xFF6366F1),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildKpiCard(
                      title: "Correct",
                      value: "${controller.correctAnswers.value}",
                      icon: Icons.check_circle_rounded,
                      color: const Color(0xFF10B981),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              /// 3. PARENT INSIGHT TIP CARD
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF4E8),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color(0xFFFFB800).withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Text('💡', style: TextStyle(fontSize: 22)),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Parent Insight",
                            style: AppTextStyles.labelLarge.copyWith(
                              color: const Color(0xFFE65100),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            "Daily 15-minute practice improves accuracy by 40%. Keep encouraging your child!",
                            style: AppTextStyles.bodySmall.copyWith(
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              /// 4. DETAILED CLASS PRACTICE HISTORY (PURCHASED CLASSES ONLY)
              Text(
                "Purchased Class Progress 📚",
                style: AppTextStyles.h4,
              ),

              const SizedBox(height: 12),

              Builder(
                builder: (context) {
                  final purchasedClasses = classController.classes
                      .where((cls) => classController.purchaseClass[cls.id] == true)
                      .toList();

                  if (purchasedClasses.isEmpty) {
                    return Container(
                      padding: const EdgeInsets.all(32),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Column(
                        children: [
                          const Text('📚', style: TextStyle(fontSize: 48)),
                          const SizedBox(height: 12),
                          Text(
                            "No Purchased Classes Yet",
                            style: AppTextStyles.h3,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Enroll in a class from Home to start tracking progress!",
                            style: AppTextStyles.bodyMedium,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: purchasedClasses.length,
                    itemBuilder: (context, classIndex) {
                      final cls = purchasedClasses[classIndex];

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey.shade200),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.02),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Theme(
                        data: Theme.of(context).copyWith(
                          dividerColor: Colors.transparent,
                        ),
                        child: ExpansionTile(
                          leading: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Text('📖', style: TextStyle(fontSize: 20)),
                          ),
                          title: Text(
                            cls.className,
                            style: AppTextStyles.bodyLarge.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Obx(() {
                            final progress = controller.getClassProgress(cls.id);
                            final totalQ = controller.getClassTotalQuestions(cls.id);
                            final solvedQ = controller.getClassSolvedQuestions(cls.id);

                            return Row(
                              children: [
                                Text(
                                  '${progress.toStringAsFixed(0)}% Completed',
                                  style: AppTextStyles.labelSmall.copyWith(
                                    color: controller.getProgressColor(progress),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '• $solvedQ/$totalQ Solved',
                                  style: AppTextStyles.bodySmall,
                                ),
                              ],
                            );
                          }),
                          onExpansionChanged: (expanded) async {
                            if (expanded) {
                              try {
                                await controller.loadDays(
                                  cls.id,
                                  forceRefresh: true,
                                );
                              } catch (e) {
                                debugPrint("Load Days Error: $e");
                              }
                            }
                          },
                          children: [
                            Obx(() {
                              final days = controller.classDays[cls.id] ?? [];

                              if (days.isEmpty) {
                                return Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Text(
                                    "No day modules found",
                                    style: AppTextStyles.bodySmall,
                                  ),
                                );
                              }

                              return Column(
                                children: days.map((day) {
                                  return Container(
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF8FAFC),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: ExpansionTile(
                                      leading: const Icon(
                                        Icons.calendar_today_rounded,
                                        size: 18,
                                        color: AppColors.primary,
                                      ),
                                      title: Text(
                                        day.dayName,
                                        style: AppTextStyles.labelLarge.copyWith(
                                          fontSize: 13,
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
                                            debugPrint("Load Attempts Error: $e");
                                          }
                                        }
                                      },
                                      children: [
                                        Obx(() {
                                          final key = "${cls.id}_${day.id}";
                                          final attemptData = controller.attempts[key];

                                          if (attemptData == null) {
                                            return const Padding(
                                              padding: EdgeInsets.all(12),
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                              ),
                                            );
                                          }

                                          return DayAttemptsWidget(
                                            attempts: attemptData.data,
                                            getStars: controller.getStars,
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
                    );
                  },
                );
              },
            ),
            ],
          ),
        ),
      ),
    ),
  );
}

  Widget _buildKpiCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: AppTextStyles.h3.copyWith(
                  color: AppColors.textDark,
                  fontSize: 20,
                ),
              ),
              Text(
                title,
                style: AppTextStyles.caption,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// SMART COMPACT ATTEMPTS WIDGET (Limits list clutter for 100+ attempts)
class DayAttemptsWidget extends StatefulWidget {
  final List<dynamic> attempts;
  final String Function(double) getStars;

  const DayAttemptsWidget({
    super.key,
    required this.attempts,
    required this.getStars,
  });

  @override
  State<DayAttemptsWidget> createState() => _DayAttemptsWidgetState();
}

class _DayAttemptsWidgetState extends State<DayAttemptsWidget> {
  bool _showAll = false;

  @override
  Widget build(BuildContext context) {
    if (widget.attempts.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(12),
        child: Text(
          "No test attempts recorded yet",
          style: AppTextStyles.bodySmall,
        ),
      );
    }

    // Find best score
    double maxPercentage = 0.0;
    for (var a in widget.attempts) {
      if (a.percentage > maxPercentage) {
        maxPercentage = a.percentage.toDouble();
      }
    }

    final displayAttempts =
        _showAll ? widget.attempts : widget.attempts.take(3).toList();

    return Column(
      children: [
        // Summary Header Strip
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 4, 12, 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Total Attempts: ${widget.attempts.length}",
                style: AppTextStyles.labelSmall.copyWith(
                  color: Colors.grey.shade700,
                  fontSize: 11,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF4E8),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  "Best: ${maxPercentage.toStringAsFixed(0)}% ⭐",
                  style: AppTextStyles.labelSmall.copyWith(
                    color: const Color(0xFFE65100),
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
        ),

        // List of Attempts (Max 3 by default)
        for (var attempt in displayAttempts)
          Container(
            margin: const EdgeInsets.fromLTRB(8, 0, 8, 6),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Colors.grey.shade200,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    "${attempt.attemptNo}",
                    style: AppTextStyles.labelSmall.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Attempt ${attempt.attemptNo} - ${widget.getStars(attempt.percentage)}",
                        style: AppTextStyles.labelLarge.copyWith(
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        "${attempt.correctAnswers}/${attempt.totalQuestions} Questions Correct",
                        style: AppTextStyles.bodySmall.copyWith(
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: attempt.percentage >= 75
                        ? const Color(0xFF10B981)
                        : attempt.percentage >= 50
                            ? const Color(0xFFF59E0B)
                            : const Color(0xFFFF5252),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    "${attempt.percentage.toStringAsFixed(0)}%",
                    style: AppTextStyles.labelSmall.copyWith(
                      color: Colors.white,
                      fontSize: 10,
                    ),
                  ),
                ),
              ],
            ),
          ),

        // Show More / Show Less Toggle Button
        if (widget.attempts.length > 3)
          GestureDetector(
            onTap: () {
              setState(() {
                _showAll = !_showAll;
              });
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _showAll
                        ? "Show Less ▴"
                        : "View All ${widget.attempts.length} Attempts ▾",
                    style: AppTextStyles.labelSmall.copyWith(
                      color: AppColors.primary,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
