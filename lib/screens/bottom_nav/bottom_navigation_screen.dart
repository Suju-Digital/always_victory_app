import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../constants/app_colors.dart';
import '../../controller/bottom_navigation_controller.dart';

class BottomNavigationScreen extends GetView<BottomNavController> {
  const BottomNavigationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        systemNavigationBarColor: AppColors.primary,
        systemNavigationBarIconBrightness: Brightness.light,
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Obx(
        () => Scaffold(
          backgroundColor: AppColors.bgLight,
          body: IndexedStack(
            index: controller.currentIndex.value,
            children: controller.pages,
          ),
          bottomNavigationBar: Container(
            color: AppColors.primary,
            child: SafeArea(
              top: false,
              bottom: true,
              child: CurvedNavigationBar(
                index: controller.currentIndex.value,
                backgroundColor: AppColors.bgLight,
                color: AppColors.primary,
                buttonBackgroundColor: AppColors.primary,
                height: 65,
                animationDuration: const Duration(milliseconds: 350),
                animationCurve: Curves.easeInOut,
                items: const [
                  Icon(
                    Icons.home_rounded,
                    color: Colors.white,
                    size: 26,
                  ),
                  Icon(
                    Icons.menu_book_rounded,
                    color: Colors.white,
                    size: 26,
                  ),
                  Icon(
                    Icons.bar_chart_rounded,
                    color: Colors.white,
                    size: 26,
                  ),
                  Icon(
                    Icons.person_rounded,
                    color: Colors.white,
                    size: 26,
                  ),
                ],
                onTap: controller.changeTab,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
