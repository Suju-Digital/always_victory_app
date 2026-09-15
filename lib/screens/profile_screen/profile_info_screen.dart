import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_constants.dart';
import '../../constants/app_text_styles.dart';
import '../../controller/auth_controller.dart';
import '../../data/app_config/app_config.dart';
import '../../routes/app_routes.dart';

class StudentProfileInfoScreen extends StatelessWidget {
  const StudentProfileInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AuthController>();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(
          "My Profile Info",
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
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(AppConstants.paddingMD),
        child: Column(
          children: [
            /// 1. Profile Avatar Header Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: AppColors.appGradient,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.25),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Obx(() {
                    final student = controller.student.value;
                    return CircleAvatar(
                      radius: 42,
                      backgroundColor: Colors.white,
                      backgroundImage: student.photo != null &&
                              student.photo!.isNotEmpty
                          ? NetworkImage(
                              "${AppConfig.studentProfileImageBaseUrl}${student.photo}")
                          : null,
                      child: student.photo == null || student.photo!.isEmpty
                          ? const Icon(
                              Icons.person_rounded,
                              size: 48,
                              color: AppColors.primary,
                            )
                          : null,
                    );
                  }),
                  const SizedBox(height: 12),
                  Obx(
                    () => Text(
                      controller.student.value.name ?? "Student Name",
                      style: AppTextStyles.h3.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Obx(
                    () => Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        "Class ${controller.student.value.className ?? ''}",
                        style: AppTextStyles.labelSmall.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// 2. Student Details Info Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.grey.shade200),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.02),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Obx(
                () => Column(
                  children: [
                    _infoTile(
                      Icons.badge_outlined,
                      "Student ID",
                      controller.student.value.id ?? "N/A",
                    ),
                    const Divider(height: 16),
                    _infoTile(
                      Icons.person_outline_rounded,
                      "Full Name",
                      controller.student.value.name ?? "N/A",
                    ),
                    const Divider(height: 16),
                    _infoTile(
                      Icons.school_outlined,
                      "Class / Grade",
                      "Class ${controller.student.value.className ?? 'N/A'}",
                    ),
                    const Divider(height: 16),
                    _infoTile(
                      Icons.phone_outlined,
                      "Contact Mobile",
                      controller.student.value.mobile ?? "N/A",
                    ),
                    const Divider(height: 16),
                    _infoTile(
                      Icons.email_outlined,
                      "Email Address",
                      controller.student.value.email ?? "N/A",
                    ),
                    const Divider(height: 16),
                    _infoTile(
                      Icons.calendar_month_outlined,
                      "Registration Date",
                      controller.student.value.createdAt ?? "N/A",
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            /// 3. Edit Profile Action Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: () => Get.toNamed(AppRoutes.editProfile),
                icon: const Icon(Icons.edit_rounded, size: 20),
                label: Text(
                  "Edit Profile",
                  style: AppTextStyles.button,
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  static Widget _infoTile(
    IconData icon,
    String title,
    String value,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: AppColors.primary,
              size: 20,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.caption,
                ),
                Text(
                  value,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
