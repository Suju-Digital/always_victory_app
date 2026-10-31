import 'package:always_victory/data/app_config/app_config.dart';
import 'package:always_victory/helpers/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_constants.dart';
import '../../constants/app_text_styles.dart';
import '../../controller/days_controller.dart';
import '../../controller/question_controller.dart';
import '../../models/class_model.dart';
import '../../widgets/app_cached_image.dart';
import '../../widgets/days_list_tile.dart';
import 'day_subjects_screen.dart';

class DayScreen extends StatelessWidget {
  final controller = Get.find<DayController>();

  // Class Data passed from Home/All Classes
  final ClassModel classData = Get.arguments;

  DayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final QuestionController questionController = Get.find<QuestionController>();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(
          classData.className,
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
      body: Obx(() {
        if (controller.days.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.08),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.calendar_today_outlined,
                    size: 50,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  "No Days Available Yet",
                  style: AppTextStyles.h3,
                ),
                const SizedBox(height: 6),
                Text(
                  "Check back soon for new practice tests!",
                  style: AppTextStyles.bodyMedium,
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            await controller.getDays(classId: classData.id);
          },
          color: AppColors.primary,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            padding: const EdgeInsets.all(AppConstants.paddingMD),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// 1. COURSE BANNER CARD
                Container(
                  width: double.infinity,
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Poster Header
                      AppCachedImage(
                        imageUrl: "${AppConfig.studentImageBaseUrl}${classData.posterImage}",
                        height: 160,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                        memCacheWidth: 800,
                        memCacheHeight: 320,
                        fallbackIcon: Icons.school_rounded,
                      ),

                      // Details
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    classData.className,
                                    style: AppTextStyles.labelSmall.copyWith(
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  "${controller.totalDays} Practice Modules 📚",
                                  style: AppTextStyles.labelSmall.copyWith(
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 8),

                            Text(
                              classData.title,
                              style: AppTextStyles.h3,
                            ),

                            if (classData.description.isNotEmpty) ...[
                              const SizedBox(height: 4),
                              Text(
                                classData.description,
                                style: AppTextStyles.bodyMedium,
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                /// 2. SECTION HEADER
                Row(
                  children: [
                    Text(
                      "Daily Practice Modules 🗓️",
                      style: AppTextStyles.h4,
                    ),
                    const Spacer(),
                    if (controller.completedDayIds.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8F5E9),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: const Color(0xFF81C784).withValues(alpha: 0.5),
                          ),
                        ),
                        child: Text(
                          "${controller.completedDayIds.length}/${controller.totalDays} Done ✓",
                          style: AppTextStyles.labelSmall.copyWith(
                            color: const Color(0xFF2E7D32),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),

                const SizedBox(height: 12),

                /// 3. DAYS LIST (Sequentially Unlocked)
                ListView.builder(
                  itemCount: controller.days.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final day = controller.days[index];
                    final isUnlocked = controller.isDayUnlocked(index);
                    final isCompleted = controller.isDayCompleted(day.id);

                    return InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () async {
                        if (!isUnlocked) {
                          final prevDay = index > 0 ? controller.days[index - 1] : null;
                          final prevTitle = (prevDay != null && prevDay.dayName.isNotEmpty)
                              ? prevDay.dayName
                              : "Day $index";
                          Utils.showWarning(
                            "Pehle $prevTitle complete karein tabhi yeh day unlock hoga! 🔒",
                          );
                          return;
                        }

                        Utils.showLoading(message: "Loading Questions...");

                        final ok = await questionController.fetchQuestions(
                          day.id.toString(),
                          classData.id.toString(),
                        );

                        Utils.hide();

                        if (!ok) {
                          Get.snackbar(
                            "No Questions",
                            "Questions are currently not available for this day.",
                            backgroundColor: Colors.amber.shade100,
                            snackPosition: SnackPosition.BOTTOM,
                          );
                          return;
                        }

                        Get.to(() => DaySubjectsScreen(
                              day: day,
                              classData: classData,
                            ));
                      },
                      child: DaysListTile(
                        day: day,
                        index: index,
                        isUnlocked: isUnlocked,
                        isCompleted: isCompleted,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
