import 'package:get/get.dart';

import '../../controller/bottom_anvigation_controller.dart';
import '../../controller/progress_controller.dart';

class BottomNavBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => BottomNavController(),);
    Get.lazyPut<ProgressController>(
          () => ProgressController(),
    );

  }
}