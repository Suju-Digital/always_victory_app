import 'package:always_victory/controller/question_controller.dart';
import 'package:get/get.dart';


class QuestionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<QuestionController>(() => QuestionController(),fenix: true);
  }
}