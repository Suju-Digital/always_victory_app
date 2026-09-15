import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_constants.dart';
import '../../constants/app_text_styles.dart';
import '../../controller/class_controller.dart';
import '../../controller/days_controller.dart';
import '../../data/app_config/app_config.dart';
import '../../helpers/utils.dart';
import '../../routes/app_routes.dart';

class PurchasedClassesTab extends StatelessWidget {
  PurchasedClassesTab({super.key});

  final ClassController classController = Get.find<ClassController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final purchasedClasses = classController.classes
          .where((e) => classController.purchaseClass[e.id] == true)
          .toList();

      if (purchasedClasses.isEmpty) {
        return RefreshIndicator(
          color: AppColors.primary,
          onRefresh: () async {
            await ClassController.instance.loadClass();
            await ClassController.instance.getAllClassesProgress();
          },
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.2),
              Center(
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
                        Icons.school_outlined,
                        size: 64,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "No Purchased Classes Yet",
                      style: AppTextStyles.h3,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "Explore courses on Home to get started!",
                      style: AppTextStyles.bodyMedium,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }

      return RefreshIndicator(
        color: AppColors.primary,
        onRefresh: () async {
          await ClassController.instance.loadClass();
          await ClassController.instance.getAllClassesProgress();
        },
        child: ListView.builder(
          padding: const EdgeInsets.all(AppConstants.paddingMD),
          physics: const BouncingScrollPhysics(),
          itemCount: purchasedClasses.length,
          itemBuilder: (context, index) {
            final c = purchasedClasses[index];
            final totalStudents = classController.enrollmentCounts[c.id] ?? 0;
            final progressModel = classController.questionProgress
                .firstWhereOrNull((e) => e.classId == c.id);
            final progress = (progressModel?.percentage ?? 0).toDouble();

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
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
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () async {
                  Utils.showLoading(message: "Loading Days...");
                  await DayController.instance.getDays(classId: c.id);
                  Utils.hide();
                  Get.toNamed(AppRoutes.days, arguments: c);
                },
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      // Course Poster Frame
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          "${AppConfig.studentImageBaseUrl}${c.posterImage}",
                          width: 85,
                          height: 85,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            width: 85,
                            height: 85,
                            color: AppColors.primary.withValues(alpha: 0.08),
                            child: const Icon(
                              Icons.school_rounded,
                              color: AppColors.primary,
                              size: 32,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 12),

                      // Content Details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              c.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.bodyLarge.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 4),

                            Text(
                              "Class ${c.className} • $totalStudents Students",
                              style: AppTextStyles.bodySmall,
                            ),

                            const SizedBox(height: 10),

                            // Progress Bar
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: LinearProgressIndicator(
                                value: progress / 100,
                                minHeight: 6,
                                backgroundColor: Colors.grey.shade200,
                                valueColor: const AlwaysStoppedAnimation(
                                  AppColors.primary,
                                ),
                              ),
                            ),

                            const SizedBox(height: 4),

                            Text(
                              "${progress.toStringAsFixed(0)}% Completed",
                              style: AppTextStyles.labelSmall.copyWith(
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 8),

                      const Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 14,
                        color: AppColors.textGrey,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      );
    });
  }
}
