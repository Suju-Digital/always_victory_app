import 'package:always_victory/constants/app_colors.dart';
import 'package:always_victory/constants/app_constants.dart';
import 'package:always_victory/constants/app_text_styles.dart';
import 'package:always_victory/controller/auth_controller.dart';
import 'package:always_victory/controller/days_controller.dart';
import 'package:always_victory/helpers/local_storage.dart';
import 'package:always_victory/helpers/utils.dart';
import 'package:always_victory/routes/app_routes.dart';
import 'package:always_victory/widgets/review_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

import '../../data/app_config/app_config.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AuthController>();
    final dayController = Get.find<DayController>();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(
          "My Profile & Settings",
          style: AppTextStyles.appBarTitle.copyWith(color: Colors.white),
        ),
        backgroundColor: AppColors.primary,
        elevation: 0,
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: AppColors.appGradient,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(AppConstants.paddingMD),
          child: Column(
            children: [
              /// 1. USER PROFILE CARD
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
                        controller.student.value.name ?? "Student",
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

              /// 2. STUDENT SECTION
              _sectionTitle("Student Details"),

              _menuTile(
                Icons.person_outline_rounded,
                "My Profile Info",
                () => Get.toNamed(AppRoutes.profileInfo),
              ),

              const SizedBox(height: 16),

              /// 3. APP SECTION
              _sectionTitle("Application"),

              _menuTile(
                Icons.business_outlined,
                "About Company",
                () => Get.toNamed(AppRoutes.aboutCompany),
              ),

              _menuTile(
                Icons.privacy_tip_outlined,
                "Privacy Policy",
                () => Get.toNamed(AppRoutes.privacyPolicy),
              ),

              _menuTile(
                Icons.description_outlined,
                "Terms & Conditions",
                () => Get.toNamed(AppRoutes.termsCondition),
              ),

              const SizedBox(height: 16),

              /// 4. SUPPORT & SHARING
              _sectionTitle("Support & Share"),

              _menuTile(
                Icons.call_outlined,
                "Contact Us",
                () => Get.toNamed(AppRoutes.contactUs),
              ),

              _menuTile(
                Icons.rate_review_outlined,
                "Write a Review",
                () => ReviewDialog.show(context),
              ),

              _menuTile(
                Icons.share_outlined,
                "Share App With Friends 🚀",
                () {
                  SharePlus.instance.share(
                    ShareParams(
                      text: "🚀 Download Always Victory App for Nursery to 12th MCQ Practice & Study Guides:\n${AppConfig.playStoreUrl}",
                    ),
                  );
                },
              ),

              const SizedBox(height: 24),

              /// 5. LOGOUT BUTTON
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    final confirm = await Utils.showConfirmDialog(
                      title: "Logout Account",
                      message: "Are you sure you want to log out?",
                      confirmText: "Logout",
                      cancelText: "Cancel",
                      confirmColor: Colors.red,
                    );

                    if (confirm == true) {
                      Utils.showLoading(message: "Logging Out...");
                      await LocalStorage.clear();
                      Utils.hide();
                      Get.offAllNamed(AppRoutes.login);
                    }
                  },
                  icon: const Icon(Icons.logout_rounded, size: 20),
                  label: Text(
                    "LOGOUT",
                    style: AppTextStyles.button.copyWith(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade600,
                    foregroundColor: Colors.white,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Version Info
              Obx(
                () => Text(
                  dayController.aboutData.value?.appName ?? AppConfig.appName,
                  style: AppTextStyles.labelLarge.copyWith(
                    color: AppColors.textDark,
                  ),
                ),
              ),
              const SizedBox(height: 2),
              Obx(
                () => Text(
                  "Version ${dayController.aboutData.value?.appVersion ?? AppConfig.appVersion}",
                  style: AppTextStyles.bodySmall,
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _sectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8, left: 4),
        child: Text(
          title,
          style: AppTextStyles.h4.copyWith(
            fontSize: 15,
            color: AppColors.textDark,
          ),
        ),
      ),
    );
  }

  static Widget _menuTile(
    IconData icon,
    String title,
    VoidCallback onTap,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: AppColors.primary,
          size: 22,
        ),
        title: Text(
          title,
          style: AppTextStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.textDark,
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios_rounded,
          size: 14,
          color: AppColors.textGrey,
        ),
        onTap: onTap,
      ),
    );
  }
}
