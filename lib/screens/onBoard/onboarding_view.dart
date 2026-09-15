import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_constants.dart';
import '../../constants/app_text_styles.dart';
import '../../controller/onboarding_controller.dart';

class OnboardingView extends GetView<OnboardingController> {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    final List<Map<String, dynamic>> slides = [
      {
        'tag': '🎯 DAILY MCQ PRACTICE',
        'subTag': 'Nursery to 12th Class',
        'title': 'Daily Interactive\nMCQ Quizzes',
        'subtitle':
            'Practice daily subject-wise MCQs for Nursery to 12th Class with instant answer feedback and timers.',
        'gradient': [const Color(0xFFFF5252), const Color(0xFFFF7A00)],
        'bgGradient': [const Color(0xFFFFF2EE), const Color(0xFFFFFFFF)],
        'icon': Icons.quiz_rounded,
        'emoji': '🎯',
      },
      {
        'tag': '📚 ALL SUBJECTS COVERED',
        'subTag': 'CBSE & State Boards',
        'title': 'Structured Day-Wise\nLearning Series',
        'subtitle':
            'Select your grade and unlock organized day-by-day test series built for complete exam preparation.',
        'gradient': [const Color(0xFF4F46E5), const Color(0xFF7C3AED)],
        'bgGradient': [const Color(0xFFF3F0FF), const Color(0xFFFFFFFF)],
        'icon': Icons.school_rounded,
        'emoji': '📖',
      },
      {
        'tag': 'WIN STAR REWARDS 🏆',
        'subTag': 'Instant Leaderboard',
        'title': 'Track Progress &\nEarn Star Badges',
        'subtitle':
            'Monitor daily accuracy rate, earn stars, and climb the student leaderboard in every single test!',
        'gradient': [const Color(0xFF059669), const Color(0xFF10B981)],
        'bgGradient': [const Color(0xFFECFDF5), const Color(0xFFFFFFFF)],
        'icon': Icons.emoji_events_rounded,
        'emoji': '⭐',
      },
    ];

    return Scaffold(
      body: Obx(() {
        final currentIndex = controller.currentPage.value;
        final currentSlide = slides[currentIndex % slides.length];
        final List<Color> bgGradient =
            currentSlide['bgGradient'] as List<Color>;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          width: size.width,
          height: size.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: bgGradient,
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                /// 1. TOP HEADER (Brand Pill + Skip Button)
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Brand Badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          gradient: AppColors.appGradient,
                          borderRadius: BorderRadius.circular(100),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.25),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text('🏆', style: TextStyle(fontSize: 12)),
                            const SizedBox(width: 6),
                            Text(
                              'ALWAYS VICTORY',
                              style: AppTextStyles.labelSmall.copyWith(
                                color: Colors.white,
                                letterSpacing: 0.8,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Skip Button
                      controller.isLast
                          ? const SizedBox.shrink()
                          : GestureDetector(
                              onTap: controller.skip,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(100),
                                  border: Border.all(
                                    color: Colors.grey.shade200,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.03),
                                      blurRadius: 6,
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'Skip',
                                      style: AppTextStyles.labelSmall.copyWith(
                                        color: AppColors.textDark,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    const Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      size: 10,
                                      color: AppColors.textDark,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                    ],
                  ),
                ),

                /// 2. FULL SCREEN PAGEVIEW SLIDER
                Expanded(
                  child: PageView.builder(
                    controller: controller.pageController,
                    onPageChanged: controller.onPageChanged,
                    itemCount: slides.length,
                    itemBuilder: (context, index) {
                      final slide = slides[index];
                      final List<Color> gradientColors =
                          slide['gradient'] as List<Color>;
                      final IconData icon = slide['icon'] as IconData;
                      final String tag = slide['tag'] as String;
                      final String subTag = slide['subTag'] as String;

                      return Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          /// HERO EMBLEM CARD
                          Container(
                            height: size.height * 0.35,
                            width: size.width * 0.85,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(28),
                              boxShadow: [
                                BoxShadow(
                                  color: gradientColors.first.withValues(alpha: 0.18),
                                  blurRadius: 25,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                              border: Border.all(
                                color: gradientColors.first.withValues(alpha: 0.12),
                                width: 2,
                              ),
                            ),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                // Glowing Radial Backdrop Circle
                                Container(
                                  width: size.width * 0.5,
                                  height: size.width * 0.5,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: RadialGradient(
                                      colors: [
                                        gradientColors.first.withValues(alpha: 0.15),
                                        gradientColors.last.withValues(alpha: 0.02),
                                      ],
                                    ),
                                  ),
                                ),

                                // Center Emblem Circle
                                Container(
                                  padding: const EdgeInsets.all(28),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: gradientColors,
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: gradientColors.first
                                            .withValues(alpha: 0.35),
                                        blurRadius: 20,
                                        offset: const Offset(0, 8),
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    icon,
                                    size: size.width * 0.18,
                                    color: Colors.white,
                                  ),
                                ),

                                // Floating Top Tag Badge
                                Positioned(
                                  top: 16,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 14,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(100),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withValues(alpha: 0.06),
                                          blurRadius: 8,
                                          offset: const Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: Text(
                                      tag,
                                      style: AppTextStyles.labelSmall.copyWith(
                                        color: gradientColors.first,
                                      ),
                                    ),
                                  ),
                                ),

                                // Floating Bottom SubTag Badge
                                Positioned(
                                  bottom: 16,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 14,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: gradientColors.first,
                                      borderRadius: BorderRadius.circular(100),
                                      boxShadow: [
                                        BoxShadow(
                                          color: gradientColors.first
                                              .withValues(alpha: 0.3),
                                          blurRadius: 8,
                                          offset: const Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(
                                          Icons.stars_rounded,
                                          color: Colors.white,
                                          size: 14,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          subTag,
                                          style: AppTextStyles.labelSmall.copyWith(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          /// 📝 TITLE & SUBTITLE SECTION
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              children: [
                                Text(
                                  slide['title'] as String,
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTextStyles.h2.copyWith(
                                    color: AppColors.textDark,
                                    height: 1.2,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  slide['subtitle'] as String,
                                  textAlign: TextAlign.center,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    color: Colors.grey.shade700,
                                    height: 1.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),

                /// 3. BOTTOM FOOTER CONTROLS
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                  child: Column(
                    children: [
                      /// Indicator Dots
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          slides.length,
                          (i) {
                            final isActive = i == currentIndex;

                            return AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              width: isActive ? 32 : 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: isActive
                                    ? AppColors.primary
                                    : Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: isActive
                                    ? [
                                        BoxShadow(
                                          color: AppColors.primary
                                              .withValues(alpha: 0.35),
                                          blurRadius: 6,
                                          offset: const Offset(0, 2),
                                        ),
                                      ]
                                    : null,
                              ),
                            );
                          },
                        ),
                      ),

                      const SizedBox(height: 20),

                      /// Main Action Button
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: controller.next,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            elevation: 4,
                            shadowColor: AppColors.primary.withValues(alpha: 0.4),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                controller.isLast ? "GET STARTED" : "CONTINUE",
                                style: AppTextStyles.button,
                              ),
                              const SizedBox(width: 8),
                              Icon(
                                controller.isLast
                                    ? Icons.rocket_launch_rounded
                                    : Icons.arrow_forward_rounded,
                                size: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
