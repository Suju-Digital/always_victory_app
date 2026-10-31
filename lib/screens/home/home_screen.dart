import 'package:always_victory/controller/days_controller.dart';
import 'package:always_victory/data/app_config/app_config.dart';
import 'package:always_victory/helpers/utils.dart';
import 'package:always_victory/routes/app_routes.dart';
import 'package:always_victory/widgets/class_card.dart';
import 'package:always_victory/widgets/review_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../course_list/buy_ebook_screen.dart';
import '../course_list/course_list.dart';
import '../course_list/ebook_reader.dart';
import '../reviews/reviews_screen.dart';
import 'all_classes_screen.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_constants.dart';
import '../../constants/app_text_styles.dart';
import '../../controller/auth_controller.dart';
import '../../controller/bottom_navigation_controller.dart';
import '../../controller/class_controller.dart';
import '../../controller/progress_controller.dart';
import '../../models/class_model.dart';
import '../../widgets/announcement_dialog.dart';
import '../../widgets/app_cached_image.dart';
import '../../widgets/carousel.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final ClassController classController = Get.find<ClassController>();

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();

    // Trigger promotional/announcement popup once per session after view renders
    WidgetsBinding.instance.addPostFrameCallback((_) {
      AnnouncementDialog.checkAndShow();
    });

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: RefreshIndicator(
        color: AppColors.primary,
        backgroundColor: Colors.white,
        onRefresh: () async {
          if (classController.classes.isEmpty) {
            classController.isLoading.value = true;
          }
          final progressController = Get.isRegistered<ProgressController>()
              ? Get.find<ProgressController>()
              : Get.put(ProgressController());

          await Future.wait([
            ClassController.instance.loadClass(),
            ClassController.instance.loadCarousel(),
            ClassController.instance.loadPurchaseClass(),
            ClassController.instance.loadEnrollmentCounts(),
            ClassController.instance.getAllClassesProgress(),
            ClassController.instance.loadReviews(),
            ClassController.instance.loadEbooks(),
            ClassController.instance.loadPurchasedBooks(),
            progressController.loadStudent(),
          ]);
          classController.isLoading.value = false;
        },
        child: SafeArea(
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              /// 1. ULTRA-PROFESSIONAL EDTECH HEADER
              SliverToBoxAdapter(
                child: Container(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(24),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x0A000000),
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Top Row: Profile, Name, Class Badge & Coins
                      Row(
                        children: [
                          // User Avatar
                          GestureDetector(
                            onTap: () => Get.toNamed(AppRoutes.profile),
                            child: Obx(
                              () => CircleAvatar(
                                radius: 20,
                                backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                                backgroundImage: authController.student.value.photo != null
                                    ? NetworkImage(
                                        "${AppConfig.studentProfileImageBaseUrl}${authController.student.value.photo}")
                                    : null,
                                child: authController.student.value.photo == null
                                    ? const Icon(
                                        Icons.person_rounded,
                                        color: AppColors.primary,
                                        size: 22,
                                      )
                                    : null,
                              ),
                            ),
                          ),

                          const SizedBox(width: 10),

                          // Greeting & Name (Clean horizontal layout)
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Obx(
                                  () => Text(
                                    "Hi ${authController.student.value.name?.split(' ').first.toString().capitalizeFirst ?? 'Student'}! 👋",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: AppTextStyles.h4.copyWith(
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                                Text(
                                  "Let's practice today!",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: Colors.grey.shade600,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(width: 8),

                          // Class Switcher Badge (Constrained width to prevent squeezing name)
                          Obx(
                            () {
                              final className = authController.student.value.className;
                              final displayClass = (className != null && className.isNotEmpty)
                                  ? (className.contains('/') ? className.split('/').first.trim() : className)
                                  : "All Classes";

                              return Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withValues(alpha: 0.08),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: AppColors.primary.withValues(alpha: 0.15),
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.school_rounded,
                                      color: AppColors.primary,
                                      size: 14,
                                    ),
                                    const SizedBox(width: 4),
                                    ConstrainedBox(
                                      constraints: const BoxConstraints(maxWidth: 85),
                                      child: Text(
                                        displayClass,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: AppTextStyles.labelSmall.copyWith(
                                          color: AppColors.primary,
                                          fontSize: 11,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                          const SizedBox(width: 8),
                          // Star Coins Badge
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFF4E8),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: const Color(0xFFFFB800).withValues(alpha: 0.3),
                              ),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.stars_rounded,
                                  color: Color(0xFFF59E0B),
                                  size: 14,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  "120",
                                  style: AppTextStyles.labelSmall.copyWith(
                                    color: const Color(0xFFD97706),
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              /// 2. FEATURED BANNER CAROUSEL
              SliverToBoxAdapter(
                child: Obx(() {
                  if (classController.carousal.isEmpty) return const SizedBox.shrink();
                  
                  return Container(
                    margin: const EdgeInsets.only(top: 14),
                    child: AppCarousel(
                      items: classController.carousal,
                      height: 155,
                      autoPlay: true,
                      itemBuilder: (item, index) {
                        return GestureDetector(
                          onTap: () {
                            AnnouncementDialog.show(carouselItem: item);
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.08),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: AppCachedImage(
                              imageUrl: "${AppConfig.carsouleImageBaseUrl}${item.imageUrl}",
                              fit: BoxFit.fill,
                              width: double.infinity,
                              borderRadius: BorderRadius.circular(16),
                              memCacheWidth: 800,
                              fallbackIcon: Icons.school_rounded,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }),
              ),

              /// 3. COMPACT QUICK NAVIGATION MENU (4 DISTINCT ACTION CARDS)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(14, 16, 14, 12),
                  child: Row(
                    children: [
                      // 1. Daily Practice Card (Coral/Orange)
                      _buildQuickActionCard(
                        icon: Icons.edit_note_rounded,
                        title: 'Daily\nPractice',
                        color: const Color(0xFFFF5722),
                        lightColor: const Color(0xFFFFECEB),
                        onTap: () {
                          if (classController.classes.isNotEmpty) {
                            final first = classController.classes.first;
                            DayController.instance.getDays(classId: first.id);
                            Get.toNamed(AppRoutes.days, arguments: first);
                          } else {
                            Get.to(() => const AllClassesScreen());
                          }
                        },
                      ),

                      // 2. Study E-Books Card (Teal/Emerald)
                      _buildQuickActionCard(
                        icon: Icons.menu_book_rounded,
                        title: 'Study\nE-Books',
                        color: const Color(0xFF00BFA5),
                        lightColor: const Color(0xFFE0F7F4),
                        onTap: () {
                          final bottomNav =
                              Get.isRegistered<BottomNavController>()
                                  ? Get.find<BottomNavController>()
                                  : null;
                          if (bottomNav != null) {
                            bottomNav.changeTab(1);
                          } else {
                            Get.toNamed(AppRoutes.courses);
                          }
                        },
                      ),

                      // 3. Progress Report Card (Blue)
                      _buildQuickActionCard(
                        icon: Icons.bar_chart_rounded,
                        title: 'Progress\nReport',
                        color: const Color(0xFF3B82F6),
                        lightColor: const Color(0xFFEFF6FF),
                        onTap: () => Get.toNamed(AppRoutes.progress),
                      ),

                      // 4. My Learning Card (Purple/Violet)
                      _buildQuickActionCard(
                        icon: Icons.school_rounded,
                        title: 'My\nLearning',
                        color: const Color(0xFF8B5CF6),
                        lightColor: const Color(0xFFF5F3FF),
                        onTap: () => Get.toNamed(AppRoutes.courses),
                      ),
                    ],
                  ),
                ),
              ),

              /// 4. SECTION TITLE
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
                  child: Row(
                    children: [
                      Text(
                        "Select Your Class 🏫",
                        style: GoogleFonts.poppins(
                          color: const Color(0xFF0F172A),
                          fontWeight: FontWeight.w800,
                          fontSize: 18,
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () => Get.to(() => const AllClassesScreen()),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFECEB),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            "See All",
                            style: GoogleFonts.poppins(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w700,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              /// 5. COMPACT CLASS LIST (Limit 4 on Home)
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

                  final int itemCount = classController.classes.length > 4
                      ? 4
                      : classController.classes.length;

                  return SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, i) {
                        if (i >= itemCount) {
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
                            classController.purchaseClass[c.id] ?? false;
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

              /// 5.5. E-BOOKS & STUDY MATERIAL SECTION
              Obx(() {
                final ebooks = classController.ebooks;
                if (ebooks.isEmpty) return const SliverToBoxAdapter(child: SizedBox.shrink());

                return SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
                        child: Row(
                          children: [
                            Text(
                              "Study Material & E-Books 📚",
                              style: GoogleFonts.poppins(
                                color: AppColors.textDark,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const Spacer(),
                            GestureDetector(
                              onTap: () => Get.to(() => const MyPurchasesScreen(initialIndex: 1)),
                              child: Text(
                                "See All",
                                style: GoogleFonts.poppins(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 195,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          physics: const BouncingScrollPhysics(),
                          itemCount: ebooks.length,
                          itemBuilder: (context, index) {
                            final ebook = ebooks[index];
                            final isPurchased =
                                classController.purchasedBooks[ebook.id] ?? false;

                            return Container(
                              width: 140,
                              margin: const EdgeInsets.only(right: 12, bottom: 6),
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: Colors.grey.shade200),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.03),
                                    blurRadius: 8,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(16),
                                onTap: () {
                                  if (isPurchased) {
                                    Get.to(() => EbookReaderScreen(ebook: ebook));
                                  } else {
                                    Get.to(() => BuyEbookScreen(ebook: ebook));
                                  }
                                },
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Book Cover Thumbnail
                                    AppCachedImage(
                                      imageUrl: AppConfig.getEbookThumbnailUrl(
                                        ebook.thumbnail,
                                      ),
                                      height: 95,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                      borderRadius: BorderRadius.circular(10),
                                      memCacheWidth: 280,
                                      memCacheHeight: 190,
                                      fallbackIcon: Icons.menu_book_rounded,
                                    ),
                                    const SizedBox(height: 8),
                                    // Title
                                    Text(
                                      ebook.title,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: AppTextStyles.labelLarge.copyWith(
                                        fontSize: 12,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    // Price & Action Button
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "₹${ebook.price}",
                                          style: AppTextStyles.labelLarge.copyWith(
                                            color: AppColors.primary,
                                            fontSize: 13,
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 3,
                                          ),
                                          decoration: BoxDecoration(
                                            color: isPurchased
                                                ? const Color(0xFF10B981)
                                                : AppColors.primary,
                                            borderRadius: BorderRadius.circular(6),
                                          ),
                                          child: Text(
                                            isPurchased ? "Read 📖" : "Buy 🛒",
                                            style: AppTextStyles.labelSmall.copyWith(
                                              color: Colors.white,
                                              fontSize: 9,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              }),

              /// 6. PARENT & STUDENT REVIEWS
              Obx(() {
                final reviews = classController.reviews;

                return SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
                        child: Row(
                          children: [
                            Text(
                              "Student Reviews ⭐",
                              style: GoogleFonts.poppins(
                                color: AppColors.textDark,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const Spacer(),
                            GestureDetector(
                              onTap: () => Get.to(() => const ReviewsScreen()),
                              child: Text(
                                "See All",
                                style: GoogleFonts.poppins(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (reviews.isEmpty)
                        GestureDetector(
                          onTap: () => Get.to(() => const ReviewsScreen()),
                          child: Container(
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
                              return GestureDetector(
                                onTap: () => Get.to(() => const ReviewsScreen()),
                                child: ReviewCard(review: reviews[index]),
                              );
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
                  onTap: () => Get.to(() => const ReviewsScreen()),
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(16, 16, 16, 20),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.15),
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

  Widget _buildQuickActionCard({
    required IconData icon,
    required String title,
    required Color color,
    required Color lightColor,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 3),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: color,
              width: 1.6,
            ),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.08),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Circular Pastel Icon Container
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: lightColor,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(
                    icon,
                    color: color,
                    size: 22,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              // Two-line Bold Title
              Text(
                title,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF0F172A),
                  height: 1.25,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
