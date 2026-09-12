import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/app_colors.dart';
import '../../controller/bottom_navigation_controller.dart';

class BottomNavigationScreen extends GetView<BottomNavController> {
  const BottomNavigationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        body: IndexedStack(
          index: controller.currentIndex.value,
          children: controller.pages,
        ),
        bottomNavigationBar: CurvedNavigationBar(
          index: controller.currentIndex.value,
          backgroundColor: Colors.transparent,
          color: AppColors.primary,
          buttonBackgroundColor: AppColors.primaryLight,
          height: 60,
          items: const [
            Icon(
              Icons.home_rounded,
              color: Colors.white,
            ),
            Icon(
              Icons.menu_book_rounded,
              color: Colors.white,
            ),
            Icon(
              Icons.bar_chart_rounded,
              color: Colors.white,
            ),
            Icon(
              Icons.person_rounded,
              color: Colors.white,
            ),
          ],
          onTap: controller.changeTab,
        ),
      ),
    );
  }
}
