import 'package:always_victory/data/api_services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_constants.dart';
import '../../constants/app_text_styles.dart';
import '../../controller/onboarding_controller.dart';

class OnboardingView extends GetView<OnboardingController> {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          /// PageView
          Obx(
          ()=> PageView.builder(
              controller: controller.pageController,
              onPageChanged: controller.onPageChanged,
              itemCount: controller.pages.length,
              itemBuilder: (_, i) {
                final page = controller.pages[i];
                return SafeArea(
                  top: true,
                  minimum: EdgeInsets.only(top: 100,bottom: 150),
                  child: Container(
                    width: double.infinity,
                    margin: EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(11),
                      border: Border.all(color: AppColors.primary,width: 2)
                    ),
                    child: GridTile(
                      header: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight,
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.white,
                              offset: Offset(0,3 ),
                              blurRadius: 5,
                              spreadRadius: 0
                            )
                          ],
                          borderRadius: const BorderRadius.only(topLeft: Radius.circular(9),topRight: Radius.circular(9))
                        ),
                        child: Text(
                          page.title ?? "",
                          textAlign: TextAlign.center,
                          style: AppTextStyles.h1.copyWith(
                            color: Colors.black,
                            fontSize: 21,
                            fontWeight: FontWeight.bold,
                            overflow: TextOverflow.ellipsis,
                            fontStyle: FontStyle.italic,

                          ),
                        ),
                      ),
                      footer: Container(
                        decoration: BoxDecoration(
                            color: AppColors.primaryLight,
                            boxShadow: const [
                              BoxShadow(
                                  color: Colors.white,
                                  offset: Offset(0,-3 ),
                                  blurRadius: 5,
                                  spreadRadius: 0
                              )
                            ],
                            borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(9),bottomRight: Radius.circular(9))
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Text(
                            page.description ?? "",
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.bodyLarge.copyWith(
                              color: Colors.black,
                              fontSize: 15
                            ),
                          ),
                        ),
                      ),

                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 40),
                        child: ClipRRect(
                          borderRadius: BorderRadiusGeometry.circular(9),
                          child: Image.network(
                            ApiServices.getImageUrl(page.image ?? ""),
                            width: double.infinity,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) {
                                return child;
                              }
                              return SizedBox(
                                height: 200,
                                child: const Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          /// Skip Button
          Positioned(
            top: 50,
            right: 20,
            child: Obx(
              () => controller.isLast
                  ? const SizedBox()
                  : TextButton(
                      onPressed: controller.skip,
                      child: Text(
                        "Skip",
                        style: AppTextStyles.labelLarge.copyWith(
                          color: AppColors.textGrey,
                        ),
                      ),
                    ),
            ),
          ),

          /// Bottom Controls
          Positioned(
            bottom: 40,
            left: 20,
            right: 20,
            child: Column(
              children: [
                /// Dots Indicator
                Obx(
                  () => Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(controller.pages.length, (i) {
                      final isActive = i == controller.currentPage.value;

                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: isActive ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: isActive ? AppColors.primary : AppColors.textHint,
                          borderRadius: BorderRadius.circular(
                            AppConstants.radiusRound,
                          ),
                        ),
                      );
                    }),
                  ),
                ),

                const SizedBox(height: 30),

                /// Continue Button
                Obx(
                  () => SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: controller.next,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            AppConstants.radiusMD,
                          ),
                        ),
                      ),
                      child: Text(
                        controller.isLast ? "Get Started 🚀" : "Continue",
                        style: AppTextStyles.button.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ),
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
