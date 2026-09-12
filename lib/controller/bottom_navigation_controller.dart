import 'package:always_victory/controller/class_controller.dart';
import 'package:always_victory/screens/course_list/course_list.dart';
import 'package:get/get.dart';

import '../screens/home/home_screen.dart';
import '../screens/profile_screen/profile_screen.dart';
import '../screens/progress_screen/progress_report_screen.dart';

class BottomNavController extends GetxController {
  final currentIndex = 0.obs;

  final pages = [
    HomeScreen(),
    MyPurchasesScreen(),
    ProgressReportScreen(),
    ProfileScreen(),
  ];

  Future<void> changeTab(int index) async {
    currentIndex.value = index;
  }
}
