import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constants/app_colors.dart';
import '../../controller/onboarding_controller.dart';

class OnboardingView extends GetView<OnboardingController> {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    // Full-screen vibrant slide configurations
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
                          horizontal: 14,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          gradient: AppColors.appGradient,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withOpacity(0.3),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text('🏆', style: TextStyle(fontSize: 14)),
                            const SizedBox(width: 6),
                            Text(
                              'ALWAYS VICTORY',
                              style: GoogleFonts.outfit(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 1.0,
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
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: Colors.grey.shade200,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.03),
                                      blurRadius: 6,
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'Skip',
                                      style: GoogleFonts.poppins(
                                        color: AppColors.textDark,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 13,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    const Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      size: 11,
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
                          /// HERO EMBLEM CARD (Fills full middle height)
                          Container(
                            height: size.height * 0.38,
                            width: size.width * 0.85,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(36),
                              boxShadow: [
                                BoxShadow(
                                  color: gradientColors.first.withOpacity(0.18),
                                  blurRadius: 30,
                                  offset: const Offset(0, 12),
                                ),
                              ],
                              border: Border.all(
                                color: gradientColors.first.withOpacity(0.12),
                                width: 2,
                              ),
                            ),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                // Glowing Radial Backdrop Circle
                                Container(
                                  width: size.width * 0.55,
                                  height: size.width * 0.55,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: RadialGradient(
                                      colors: [
                                        gradientColors.first.withOpacity(0.15),
                                        gradientColors.last.withOpacity(0.02),
                                      ],
                                    ),
                                  ),
                                ),

                                // Center Emblem Circle
                                Container(
                                  padding: const EdgeInsets.all(32),
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
                                            .withOpacity(0.4),
                                        blurRadius: 25,
                                        offset: const Offset(0, 10),
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    icon,
                                    size: size.width * 0.2,
                                    color: Colors.white,
                                  ),
                                ),

                                // Floating Top Tag Badge
                                Positioned(
                                  top: 18,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.06),
                                          blurRadius: 10,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: Text(
                                      tag,
                                      style: GoogleFonts.poppins(
                                        color: gradientColors.first,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w900,
                                        letterSpacing: 0.6,
                                      ),
                                    ),
                                  ),
                                ),

                                // Floating Bottom SubTag Badge
                                Positioned(
                                  bottom: 18,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: gradientColors.first,
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: [
                                        BoxShadow(
                                          color: gradientColors.first
                                              .withOpacity(0.35),
                                          blurRadius: 10,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(
                                          Icons.stars_rounded,
                                          color: Colors.white,
                                          size: 16,
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          subTag,
                                          style: GoogleFonts.poppins(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
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
                                  style: GoogleFonts.outfit(
                                    fontSize: 28,
                                    fontWeight: FontWeight.w900,
                                    color: AppColors.textDark,
                                    height: 1.2,
                                    letterSpacing: -0.5,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  slide['subtitle'] as String,
                                  textAlign: TextAlign.center,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    color: Colors.grey.shade600,
                                    height: 1.5,
                                    fontWeight: FontWeight.w500,
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
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 28),
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
                              width: isActive ? 36 : 9,
                              height: 9,
                              decoration: BoxDecoration(
                                color: isActive
                                    ? AppColors.primary
                                    : Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: isActive
                                    ? [
                                        BoxShadow(
                                          color: AppColors.primary
                                              .withOpacity(0.4),
                                          blurRadius: 8,
                                          offset: const Offset(0, 2),
                                        ),
                                      ]
                                    : null,
                              ),
                            );
                          },
                        ),
                      ),

                      const SizedBox(height: 24),

                      /// Main Action Button
                      SizedBox(
                        width: double.infinity,
                        height: 60,
                        child: ElevatedButton(
                          onPressed: controller.next,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            elevation: 8,
                            shadowColor: AppColors.primary.withOpacity(0.45),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                controller.isLast ? "GET STARTED" : "CONTINUE",
                                style: GoogleFonts.outfit(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 1.0,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Icon(
                                controller.isLast
                                    ? Icons.rocket_launch_rounded
                                    : Icons.arrow_forward_rounded,
                                size: 22,
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
