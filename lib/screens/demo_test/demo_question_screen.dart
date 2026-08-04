import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../constants/app_colors.dart';
import '../../controller/question_controller.dart';
import '../../routes/app_routes.dart';
import '../../widgets/quiz_progress_bar.dart';
import '../../widgets/timer_widget.dart';

class DemoQuestionScreen extends StatelessWidget {
  DemoQuestionScreen({super.key});

  final QuestionController controller = Get.find<QuestionController>();
  final TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5f7fb),
      appBar: AppBar(
        title: const Text(" Demo Quiz Time 🎯"),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              QuestionController.instance.resetQuizState();
              QuestionController.instance.startTimer();
              Get.offNamed(AppRoutes.demoTest);
            },
            icon: const Icon(Icons.refresh, color: AppColors.primary),
          ),
        ],
      ),
      body: WillPopScope(
        onWillPop: () async {
          QuestionController.instance.stopTimer();
          Navigator.of(context).pop();
          return false;
        },
        child: Obx(() {
          if (controller.demoQuestion.isEmpty) {

            return const Center(child: Text("No Demo Question Found"));
          }

          final question = controller.demoQuestion[controller.index.value];

          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 400),
            child: Padding(
              key: ValueKey(controller.index.value),
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  /// 🔥 Progress + Timer
                  Row(
                    children: [
                      Expanded(
                        child: QuizProgressBar(
                          current: controller.index.value + 1,
                          total: controller.demoQuestion.length,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Obx(
                            () => TimerWidget(
                          secondsLeft: controller.secondsLeft.value,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  /// 🧠 Question Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: Text(
                      question.question ?? "",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// 🔽 Answers
                  Expanded(child: _buildAnswerUI(question)),


                  /// 👉 Next Button
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {

                          if (controller.selected.value.isEmpty) {
                            Get.snackbar("Oops 😅", "Select an answer");
                            return;
                          }

                        controller.nextDemo();
                        textController.clear();
                      },
                      child: Text(
                        controller.index.value ==
                            controller.demoQuestion.length - 1
                            ? "Submit"
                            : "Next ➡️",
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  /// 🔥 Answer UI
  Widget _buildAnswerUI(dynamic question) {

      return ListView(
        children: [
          _optionTile(question.option1, AppColors.optionA),
          _optionTile(question.option2, AppColors.optionB),
          _optionTile(question.option3, AppColors.optionC),
          _optionTile(question.option4, AppColors.optionD),
        ],
      );
  }

  /// ✍️ Input Field
  Widget _inputField(String hint, int lines) {
    return TextField(
      controller: textController,
      maxLines: lines,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  /// 🎯 Animated Option Tile
  Widget _optionTile(String? text, Color color) {
    final controller = Get.find<QuestionController>();

    return Obx(() {
      final isSelected = controller.selected.value == text;

      return GestureDetector(
        onTap: () => controller.selectAnswer(text ?? ""),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isSelected ? color.withOpacity(0.15) : Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isSelected ? color : Colors.grey.shade300,
              width: 2,
            ),
            boxShadow: [
              if (isSelected)
                BoxShadow(color: color.withOpacity(0.3), blurRadius: 8),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(text ?? "", style: const TextStyle(fontSize: 16)),
              ),
              AnimatedScale(
                scale: isSelected ? 1.2 : 0,
                duration: const Duration(milliseconds: 200),
                child: Icon(Icons.check_circle, color: color),
              ),
            ],
          ),
        ),
      );
    });
  }
}
