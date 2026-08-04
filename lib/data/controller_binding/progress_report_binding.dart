import 'package:get/get.dart';

import '../../controller/progress_controller.dart';
class ProgressBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
          () => ProgressController(),
    );
  }
}