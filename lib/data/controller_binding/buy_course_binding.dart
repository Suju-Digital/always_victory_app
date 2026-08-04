import 'package:get/get.dart';

import '../../controller/buy_course_controller.dart';

class BuyCourseBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BuyCourseController>(() => BuyCourseController());
  }
}