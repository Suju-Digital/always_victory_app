import 'package:always_victory/controller/auth_controller.dart';
import 'package:get/get.dart';
import '../../controller/class_controller.dart';
import '../../controller/days_controller.dart';
import '../../controller/ebook_purchase_controller.dart';
import '../../controller/question_controller.dart';

class AppBindings {
  static void init() {
    Get.put(AuthController(), permanent: true);
    Get.put(ClassController(), permanent: true);
    Get.put(DayController(), permanent: true);
    Get.put(QuestionController(), permanent: true);
    Get.put(BuyEbookController(), permanent: true);
  }
}
