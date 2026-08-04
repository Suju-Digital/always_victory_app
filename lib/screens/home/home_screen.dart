import 'package:always_victory/controller/days_controller.dart';
import 'package:always_victory/data/app_config/app_config.dart';
import 'package:always_victory/helpers/utils.dart';
import 'package:always_victory/routes/app_routes.dart';
import 'package:always_victory/widgets/class_card.dart';
import 'package:always_victory/widgets/review_card.dart';
import 'package:always_victory/widgets/review_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_constants.dart';
import '../../constants/app_text_styles.dart';
import '../../controller/auth_controller.dart';
import '../../controller/class_controller.dart';
import '../../widgets/crousel.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  final ClassController classController = Get.find<ClassController>();

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();

    return Scaffold(
      backgroundColor: const Color(0xfff8faff),
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
              /// 🎨 Premium Kid-Friendly Header Area
              SliverToBoxAdapter(
                child: Container(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
                  decoration: const BoxDecoration(
                    gradient: AppColors.appGradient,
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(40),
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          // Profile Area with Premium Border
                          GestureDetector(
                            onTap: () => Get.toNamed(AppRoutes.profile),
                            child: Container(
                              padding: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.white.withOpacity(0.5), width: 2),
                                shape: BoxShape.circle,
                              ),
                              child: CircleAvatar(
                                radius: 24,
                                backgroundColor: Colors.white.withOpacity(0.2),
                                backgroundImage: authController.student.value.photo != null
                                    ? NetworkImage("${AppConfig.studentProfileImageBaseUrl}${authController.student.value.photo}")
                                    : null,
                                child: authController.student.value.photo == null
                                    ? const Icon(Icons.person, color: Colors.white)
                                    : null,
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          // Greeting with Shadow for Readability
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Obx(() => Text(
                                      "Hi ${authController.student.value.name?.split(' ').first.toString().capitalizeFirst ?? 'Superstar'}! 👋",
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 22,
                                        fontWeight: FontWeight.w900,
                                        letterSpacing: 0.5,
                                        shadows: [
                                          Shadow(color: Colors.black12, offset: Offset(0, 2), blurRadius: 4),
                                        ],
                                      ),
                                    )),
                                Text(
                                  "Ready to win today? 🏆",
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.9),
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Star Counter with Glassmorphism
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.white.withOpacity(0.3)),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.stars_rounded, color: Colors.amber, size: 22),
                                const SizedBox(width: 6),
                                Text(
                                  "120", 
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w900,
                                    fontSize: 15,
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

              /// 🎠 Carousel with Depth Animation
              SliverToBoxAdapter(
                child: Container(
                  margin: const EdgeInsets.only(top: 8),
                  child: AppCarousel(
                    items: classController.carousal,
                    height: 190,
                    autoPlay: true,
                    itemBuilder: (item, index) {
                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(24),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              Image.network(
                                "${AppConfig.carsouleImageBaseUrl}${item.imageUrl}",
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(
                                  color: Colors.grey.shade100,
                                  child: const Icon(Icons.image_not_supported),
                                ),
                              ),
                              // Soft overlay for better visibility
                              DecoratedBox(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.transparent,
                                      Colors.black.withOpacity(0.4),
                                    ],
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 16,
                                left: 16,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(100),
                                    border: Border.all(
                                      color: Colors.white.withOpacity(0.3),
                                      width: 1,
                                    ),
                                  ),
                                  child: const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text('🌟', style: TextStyle(fontSize: 14)),
                                      SizedBox(width: 6),
                                      Text(
                                        'Explore Now',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 11,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

              /// 🚀 Quick Action Cards
              SliverToBoxAdapter(
                child: Container(
                  height: 140, // Sufficient height for cards
                  margin: const EdgeInsets.only(top: 8, bottom: 16),
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    physics: const BouncingScrollPhysics(),
                    children: [
                      _buildQuickActionCard(
                        '🚀',
                        'Resume',
                        'Keep Learning',
                        AppColors.primary,
                        () {
                          // Find last class logic
                        },
                      ),
                      _buildQuickActionCard(
                        '🏆',
                        'Progress',
                        'Track Growth',
                        Colors.blue,
                        () => Get.toNamed(AppRoutes.progress),
                      ),
                      _buildQuickActionCard(
                        '📚',
                        'Library',
                        'My Books',
                        Colors.green,
                        () => Get.toNamed(AppRoutes.courses),
                      ),
                      _buildQuickActionCard(
                        '🎨',
                        'Profile',
                        'My Account',
                        Colors.pink,
                        () => Get.toNamed(AppRoutes.profile),
                      ),
                    ],
                  ),
                ),
              ),

              /// 📚 Course Title
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 16),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text('📚', style: TextStyle(fontSize: 22)),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Your Learning Path",
                              style: AppTextStyles.h2.copyWith(
                                color: AppColors.textDark,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              "Choose a course to continue",
                              style: TextStyle(
                                color: AppColors.textGrey.withOpacity(0.8),
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 16)),

              /// 📋 Course List
              SliverPadding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.paddingMD,
                ),
                sliver: Obx(() {
                  if (classController.isLoading.value) {
                    return SliverToBoxAdapter(
                      child: Container(
                        height: 300,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(
                                height: 80,
                                width: 80,
                                child: CircularProgressIndicator(
                                  strokeWidth: 6,
                                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                                  backgroundColor: AppColors.border,
                                ),
                              ),
                              const SizedBox(height: 20),
                              TweenAnimationBuilder(
                                duration: const Duration(milliseconds: 1000),
                                tween: Tween<double>(begin: 0, end: 1),
                                curve: Curves.easeInOut,
                                builder: (context, value, child) {
                                  return Opacity(
                                    opacity: value.clamp(0.0, 1.0),
                                    child: child,
                                  );
                                },
                                child: const Text(
                                  '📖 Loading Courses...',
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              TweenAnimationBuilder(
                                duration: const Duration(milliseconds: 1200),
                                tween: Tween<double>(begin: 0, end: 1),
                                curve: Curves.easeInOut,
                                builder: (context, value, child) {
                                  return Opacity(
                                    opacity: value.clamp(0.0, 1.0),
                                    child: child,
                                  );
                                },
                                child: Text(
                                  '✨ Getting your courses ready...',
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                  if (classController.classes.isEmpty) {
                    return SliverToBoxAdapter(
                      child: TweenAnimationBuilder(
                        duration: const Duration(milliseconds: 1000),
                        tween: Tween<double>(begin: 0, end: 1),
                        builder: (context, value, child) {
                          return Opacity(
                            opacity: value.clamp(0.0, 1.0),
                            child: Transform.scale(
                              scale: 0.8 + (0.2 * value),
                              child: child,
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(24),
                          margin: const EdgeInsets.symmetric(vertical: 40),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: AppColors.primary.withOpacity(0.2),
                              width: 2,
                              style: BorderStyle.solid,
                            ),
                          ),
                          child: Column(
                            children: [
                              Stack(
                                children: [
                                  Icon(
                                    Icons.school,
                                    color: AppColors.primary.withOpacity(0.2),
                                    size: 120,
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: const Text(
                                      '😊',
                                      style: TextStyle(fontSize: 40),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 15),
                              Text(
                                '🎯 No Data Available Yet',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: AppColors.primary.withOpacity(0.8),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '📝 Please wait for best material uploading...',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                  color: Colors.grey.shade600,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 16),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Text(
                                  '⏳ Coming Soon!',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                            ],
                          ),
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

                        final c = classController.classes[i];
                        final progressModel = i < classController.questionProgress.length
                            ? classController.questionProgress[i]
                            : null;
                        final totalStudents = classController.enrollmentCounts[c.id] ?? 0;
                        final isPurchased = classController.purchaseClass[c.id] ?? true;
                        final isLocked = !isPurchased;

                        return TweenAnimationBuilder(
                          duration: Duration(milliseconds: 300 + (i * 50)),
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
                          child: ClassCard(
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
                                  Get.snackbar(
                                    '🎉 Success!',
                                    'Welcome to your new course!',
                                    snackPosition: SnackPosition.BOTTOM,
                                    backgroundColor: Colors.green.shade100,
                                    icon: const Icon(Icons.celebration, color: Colors.green),
                                  );
                                }
                              } else {
                                Utils.showLoading(message: "📚 Loading Days...");
                                await DayController.instance.getDays(classId: c.id);
                                Utils.hide();
                                Get.toNamed(
                                  AppRoutes.days,
                                  arguments: c,
                                );
                              }
                            },
                          ),
                        );
                      },
                      childCount: classController.classes.length,
                    ),
                  );
                }),
              ),

              /// ❤️ Wall of Love (Parent Reviews)
              Obx(() {
                final reviews = classController.reviews;
                
                return SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(24, 32, 24, 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Wall of Love ❤️",
                                  style: AppTextStyles.h2.copyWith(
                                    color: AppColors.textDark,
                                    fontWeight: FontWeight.w900,
                                    fontSize: 20,
                                  ),
                                ),
                                Text(
                                  "What other parents are saying",
                                  style: TextStyle(
                                    color: AppColors.textGrey.withOpacity(0.7),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      
                      if (reviews.isEmpty)
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 24),
                          padding: const EdgeInsets.all(24),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(color: Colors.grey.shade100),
                          ),
                          child: Column(
                            children: [
                              const Text("✨", style: TextStyle(fontSize: 24)),
                              const SizedBox(height: 8),
                              Text(
                                "No reviews yet. Be the first to share your child's journey!",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: AppColors.textGrey.withOpacity(0.8),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        )
                      else
                        SizedBox(
                          height: 200,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(horizontal: 24),
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

              /// 🎯 Parent Review & Footer
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    // Parent Review Call-to-Action
                    GestureDetector(
                      onTap: () => ReviewDialog.show(context),
                      child: Container(
                        margin: const EdgeInsets.fromLTRB(24, 24, 24, 20),
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(28),
                          border: Border.all(color: AppColors.primary.withOpacity(0.1), width: 1.5),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.star_rounded, color: AppColors.primary, size: 28),
                            ),
                            const SizedBox(width: 16),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Share Your Feedback",
                                    style: TextStyle(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w900,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    "Help us make Always Victory even better for your kids!",
                                    style: TextStyle(
                                      color: AppColors.primary,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(Icons.arrow_forward_ios_rounded, color: AppColors.primary, size: 16),
                          ],
                        ),
                      ),
                    ),

                    Container(
                      margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: AppColors.primary.withOpacity(0.1),
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.03),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildFooterItem('🎯', 'Learn'),
                          _buildFooterItem('🏆', 'Achieve'),
                          _buildFooterItem('🌟', 'Shine'),
                          _buildFooterItem('🚀', 'Grow'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 32)),
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

  Widget _buildQuickActionCard(String emoji, String title, String subtitle, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 125, // Compact width
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withOpacity(0.1), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(emoji, style: const TextStyle(fontSize: 20)),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                color: AppColors.textDark,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 2),
            Expanded( // Use Expanded to handle overflow safely
              child: Text(
                subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: AppColors.textGrey,
                  fontWeight: FontWeight.w500,
                  fontSize: 10,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
