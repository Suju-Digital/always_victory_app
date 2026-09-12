import 'package:always_victory/controller/days_controller.dart';
import 'package:always_victory/data/app_config/app_config.dart';
import 'package:always_victory/helpers/utils.dart';
import 'package:always_victory/routes/app_routes.dart';
import 'package:always_victory/widgets/class_card.dart';
import 'package:always_victory/widgets/review_card.dart';
import 'package:always_victory/widgets/review_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_constants.dart';
import '../../controller/auth_controller.dart';
import '../../controller/class_controller.dart';
import '../../models/class_model.dart';
import '../../widgets/carousel.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final ClassController classController = Get.find<ClassController>();

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: RefreshIndicator(
        color: AppColors.primary,
        backgroundColor: Colors.white,
        onRefresh: () async {
          classController.isLoading.value = true;
          await Future.wait([
            ClassController.instance.loadClass(),
            ClassController.instance.loadCarousel(),
            ClassController.instance.loadPurchaseClass(),
            ClassController.instance.loadEnrollmentCounts(),
            ClassController.instance.getAllClassesProgress(),
            ClassController.instance.loadReviews(),
          ]);
          classController.isLoading.value = false;
        },
        child: SafeArea(
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              /// 1. CLEAN COMPACT HEADER BAR
              SliverToBoxAdapter(
                child: Container(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                  decoration: const BoxDecoration(
                    gradient: AppColors.appGradient,
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(24),
                    ),
                  ),
                  child: Row(
                    children: [
                      // Avatar
                      GestureDetector(
                        onTap: () => Get.toNamed(AppRoutes.profile),
                        child: Obx(
                          () => CircleAvatar(
                            radius: 20,
                            backgroundColor: Colors.white.withOpacity(0.2),
                            backgroundImage: authController
                                        .student.value.photo !=
                                    null
                                ? NetworkImage(
                                    "${AppConfig.studentProfileImageBaseUrl}${authController.student.value.photo}")
                                : null,
                            child: authController.student.value.photo == null
                                ? const Icon(
                                    Icons.person_rounded,
                                    color: Colors.white,
                                    size: 22,
                                  )
                                : null,
                          ),
                        ),
                      ),

                      const SizedBox(width: 10),

                      // Name & Subtitle
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Obx(
                              () => Text(
                                "Hi ${authController.student.value.name?.split(' ').first.toString().capitalizeFirst ?? 'Student'}! 👋",
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Text(
                              "Ready for daily MCQ practice?",
                              style: GoogleFonts.poppins(
                                color: Colors.white.withOpacity(0.9),
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Star Badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.stars_rounded,
                              color: Colors.amber,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              "120",
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              /// 2. CLEAN BANNER CAROUSEL
              SliverToBoxAdapter(
                child: Container(
                  margin: const EdgeInsets.only(top: 12),
                  child: AppCarousel(
                    items: classController.carousal,
                    height: 145,
                    autoPlay: true,
                    itemBuilder: (item, index) {
                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 2),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.06),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.network(
                            "${AppConfig.carsouleImageBaseUrl}${item.imageUrl}",
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              color: Colors.grey.shade100,
                              child: const Icon(
                                Icons.school_rounded,
                                color: AppColors.primary,
                                size: 36,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

              /// 3. COMPACT QUICK NAVIGATION MENU
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildQuickNavItem(
                        icon: Icons.play_circle_fill_rounded,
                        label: 'Practice',
                        color: AppColors.primary,
                        onTap: () {
                          if (classController.classes.isNotEmpty) {
                            final first = classController.classes.first;
                            DayController.instance.getDays(classId: first.id);
                            Get.toNamed(AppRoutes.days, arguments: first);
                          }
                        },
                      ),
                      _buildQuickNavItem(
                        icon: Icons.bar_chart_rounded,
                        label: 'Progress',
                        color: const Color(0xFF3B82F6),
                        onTap: () => Get.toNamed(AppRoutes.progress),
                      ),
                      _buildQuickNavItem(
                        icon: Icons.menu_book_rounded,
                        label: 'My Classes',
                        color: const Color(0xFF10B981),
                        onTap: () => Get.toNamed(AppRoutes.courses),
                      ),
                      _buildQuickNavItem(
                        icon: Icons.person_rounded,
                        label: 'Profile',
                        color: const Color(0xFFEC4899),
                        onTap: () => Get.toNamed(AppRoutes.profile),
                      ),
                    ],
                  ),
                ),
              ),

              /// 4. SECTION TITLE
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
                  child: Row(
                    children: [
                      Text(
                        "Select Your Class",
                        style: GoogleFonts.poppins(
                          color: AppColors.textDark,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        "Nursery to 12th",
                        style: GoogleFonts.poppins(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              /// 5. COMPACT CLASS LIST
              SliverPadding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.paddingMD,
                ),
                sliver: Obx(() {
                  if (classController.isLoading.value) {
                    return SliverToBoxAdapter(
                      child: SizedBox(
                        height: 180,
                        child: Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primary,
                            strokeWidth: 3,
                          ),
                        ),
                      ),
                    );
                  }

                  if (classController.classes.isEmpty) {
                    return SliverToBoxAdapter(
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        margin: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: Column(
                          children: [
                            const Icon(
                              Icons.school_outlined,
                              size: 40,
                              color: AppColors.primary,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'No Classes Available Yet',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: AppColors.textDark,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  return SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, i) {
                        if (i >= classController.classes.length) {
                          return const SizedBox.shrink();
                        }

                        final ClassModel c = classController.classes[i];
                        final progressModel =
                            i < classController.questionProgress.length
                                ? classController.questionProgress[i]
                                : null;
                        final totalStudents =
                            classController.enrollmentCounts[c.id] ?? 0;
                        final isPurchased =
                            classController.purchaseClass[c.id] ?? true;
                        final isLocked = !isPurchased;

                        return ClassCard(
                          progress: progressModel?.percentage ?? 0,
                          isHighlighted: (progressModel?.percentage ?? 0) > 0,
                          data: c,
                          totalEnroll: totalStudents,
                          isLocked: isLocked,
                          onTap: () async {
                            if (isLocked) {
                              final result = await Get.toNamed(
                                AppRoutes.purchase,
                                arguments: {
                                  "ClassModel": c,
                                  "EnrollStudent": totalStudents,
                                },
                              );
                              if (result == true) {
                                await classController.loadClass();
                                classController.loadPurchaseClass();
                                classController.update();
                              }
                            } else {
                              Utils.showLoading(message: "Loading Days...");
                              await DayController.instance
                                  .getDays(classId: c.id);
                              Utils.hide();
                              Get.toNamed(AppRoutes.days, arguments: c);
                            }
                          },
                        );
                      },
                      childCount: classController.classes.length,
                    ),
                  );
                }),
              ),

              /// 6. PARENT & STUDENT REVIEWS
              Obx(() {
                final reviews = classController.reviews;

                return SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
                        child: Text(
                          "Student Reviews ⭐",
                          style: GoogleFonts.poppins(
                            color: AppColors.textDark,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      if (reviews.isEmpty)
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 16),
                          padding: const EdgeInsets.all(16),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          child: Text(
                            "Share your learning experience with us!",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              color: Colors.grey.shade600,
                              fontSize: 12,
                            ),
                          ),
                        )
                      else
                        SizedBox(
                          height: 180,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            physics: const BouncingScrollPhysics(),
                            itemCount: reviews.length,
                            itemBuilder: (context, index) {
                              return ReviewCard(review: reviews[index]);
                            },
                          ),
                        ),
                    ],
                  ),
                );
              }),

              /// 7. FEEDBACK BANNER
              SliverToBoxAdapter(
                child: GestureDetector(
                  onTap: () => ReviewDialog.show(context),
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(16, 16, 16, 20),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppColors.primary.withOpacity(0.15),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.star_rounded,
                          color: AppColors.primary,
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Share Your Feedback",
                                style: GoogleFonts.poppins(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                "Help us improve MCQ Master",
                                style: GoogleFonts.poppins(
                                  color: AppColors.primary,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: AppColors.primary,
                          size: 14,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 24)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickNavItem({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: color,
              size: 22,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.textDark,
            ),
          ),
        ],
      ),
    );
  }
}
