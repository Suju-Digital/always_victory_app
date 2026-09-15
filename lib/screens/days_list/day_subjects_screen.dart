import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_constants.dart';
import '../../constants/app_text_styles.dart';
import '../../controller/question_controller.dart';
import '../../models/class_model.dart';
import '../../models/day_model.dart';
import '../../routes/app_routes.dart';

class DaySubjectsScreen extends StatelessWidget {
  final DayModel day;
  final ClassModel classData;

  const DaySubjectsScreen({
    super.key,
    required this.day,
    required this.classData,
  });

  @override
  Widget build(BuildContext context) {
    final QuestionController questionController = Get.find<QuestionController>();

    final List<Map<String, dynamic>> fallbackSubjects = [
      {
        'id': 1,
        'title': 'Mathematics & Logic',
        'subtitle': 'Numbers, Formulae & Problem Solving',
        'emoji': '🔢',
        'color': const Color(0xFF6366F1), // Indigo
      },
      {
        'id': 2,
        'title': 'Science & EVS',
        'subtitle': 'Concepts, Nature & Experiments',
        'emoji': '🔬',
        'color': const Color(0xFF10B981), // Mint
      },
      {
        'id': 3,
        'title': 'English Grammar',
        'subtitle': 'Vocabulary, Reading & Grammar',
        'emoji': '🔤',
        'color': const Color(0xFFEC4899), // Pink
      },
      {
        'id': 4,
        'title': 'General Knowledge',
        'subtitle': 'World, History & Current Affairs',
        'emoji': '🌍',
        'color': const Color(0xFFF59E0B), // Gold
      },
      {
        'id': 5,
        'title': 'Hindi & Sahitya',
        'subtitle': 'Vyakaran & Reading Practice',
        'emoji': '📖',
        'color': const Color(0xFF8B5CF6), // Purple
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(
          day.dayName.isNotEmpty ? day.dayName : "Select Subject",
          style: AppTextStyles.appBarTitle.copyWith(color: Colors.white),
        ),
        backgroundColor: AppColors.primary,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: AppColors.appGradient,
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(AppConstants.paddingMD),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 1. TOP HEADER BANNER
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
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
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Text('📚', style: TextStyle(fontSize: 28)),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          day.title.isNotEmpty ? day.title : "Daily MCQ Test",
                          style: AppTextStyles.h3,
                        ),
                        const SizedBox(height: 2),
                        Obx(
                          () => Text(
                            "${classData.className} • ${questionController.allDayQuestions.length} Questions Available",
                            style: AppTextStyles.bodySmall,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// 2. SECTION TITLE
            Text(
              "Choose Subject To Solve 📝",
              style: AppTextStyles.h4,
            ),

            const SizedBox(height: 12),

            /// 3. SUBJECT CARDS LIST (DYNAMIC BASED ON PHP API DATA)
            Obx(() {
              final allQuestions = questionController.allDayQuestions;
              final totalAll = allQuestions.length;

              // Extract unique subject names from API
              final Set<String> apiSubjectNames = {};
              for (var q in allQuestions) {
                if (q.subjectName != null && q.subjectName!.trim().isNotEmpty) {
                  apiSubjectNames.add(q.subjectName!.trim());
                }
              }

              final List<Map<String, dynamic>> displaySubjects = [
                {
                  'filter': null,
                  'title': 'All Subjects (Mix Test)',
                  'subtitle': 'Practice all questions together',
                  'emoji': '🎯',
                  'color': AppColors.primary,
                  'count': totalAll,
                },
              ];

              if (apiSubjectNames.isNotEmpty) {
                final colors = [
                  const Color(0xFF6366F1), // Indigo
                  const Color(0xFF10B981), // Mint
                  const Color(0xFFEC4899), // Pink
                  const Color(0xFFF59E0B), // Gold
                  const Color(0xFF8B5CF6), // Purple
                  const Color(0xFF3B82F6), // Blue
                ];
                final emojis = ['🔢', '🔬', '🔤', '🌍', '📖', '🧪', '📐'];

                int i = 0;
                for (var name in apiSubjectNames) {
                  final Color c = colors[i % colors.length];
                  final String em = emojis[i % emojis.length];
                  final int count = allQuestions
                      .where((q) => q.subjectName?.trim() == name)
                      .length;

                  displaySubjects.add({
                    'filter': name,
                    'title': name,
                    'subtitle': '$count Practice Questions Available',
                    'emoji': em,
                    'color': c,
                    'count': count,
                  });
                  i++;
                }
              } else {
                for (var s in fallbackSubjects) {
                  final int? id = s['id'] as int?;
                  int count =
                      allQuestions.where((q) => q.subjectId == id).length;
                  if (count == 0 && totalAll > 0) {
                    const int totalSubjects = 5;
                    final int chunkSize = (totalAll / totalSubjects).ceil();
                    final int startIndex =
                        ((id! - 1) * chunkSize).clamp(0, totalAll);
                    final int endIndex =
                        (startIndex + chunkSize).clamp(0, totalAll);
                    count = (endIndex - startIndex).clamp(0, totalAll);
                  }

                  displaySubjects.add({
                    'filter': id,
                    'title': s['title'] as String,
                    'subtitle': s['subtitle'] as String,
                    'emoji': s['emoji'] as String,
                    'color': s['color'] as Color,
                    'count': count,
                  });
                }
              }

              return ListView.builder(
                itemCount: displaySubjects.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final item = displaySubjects[index];
                  final dynamic filter = item['filter'];
                  final Color color = item['color'] as Color;
                  final int qCount = item['count'] as int;

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.shade200),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.03),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () {
                        questionController.startQuizForSubject(filter);
                        Get.toNamed(AppRoutes.quiz);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(14),
                        child: Row(
                          children: [
                            // Subject Emoji Icon Box
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: color.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Center(
                                child: Text(
                                  item['emoji'] as String,
                                  style: const TextStyle(fontSize: 22),
                                ),
                              ),
                            ),

                            const SizedBox(width: 14),

                            // Subject Details
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item['title'] as String,
                                    style: AppTextStyles.bodyLarge.copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    item['subtitle'] as String,
                                    style: AppTextStyles.bodySmall,
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(width: 8),

                            // Questions Counter & Arrow
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 3,
                                  ),
                                  decoration: BoxDecoration(
                                    color: color.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    "$qCount Qs",
                                    style: AppTextStyles.labelSmall.copyWith(
                                      color: color,
                                      fontSize: 10,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  size: 14,
                                  color: Colors.grey.shade400,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }),
          ],
        ),
      ),
    );
  }
}
