import 'dart:async';
import 'package:always_victory/controller/auth_controller.dart';
import 'package:always_victory/data/api_services/api_service.dart';
import 'package:always_victory/helpers/debug_loger.dart';
import 'package:always_victory/models/demo_question_model.dart';
import 'package:always_victory/models/demo_result_model.dart';
import 'package:always_victory/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../constants/app_colors.dart';
import '../data/api_helper/api_helper.dart';
import '../models/answer_model.dart';
import '../models/question_model.dart';
import 'class_controller.dart';
import 'days_controller.dart';

class QuestionController extends GetxController {
// static QuestionController get instance=> Get.find();
//
//   var questions = <QuestionModel>[].obs;
//   final RxList<AnswerModel> answersList = <AnswerModel>[].obs;
//
//   var demoQuestion = <DemoQuestionModel>[].obs;
//
// final RxList<DemoResultModel> demAnswersList = <DemoResultModel>[].obs;
//
//
//   var index = 0.obs;
//   var selected = "".obs;
//   var score = 0.obs;
//
//   /// ⏱ Timer
//   var secondsLeft = 30.obs;
//   Timer? _timer;
//
// Future<bool> fetchQuestions(String dayId, String classId) async {
//   index.value = 0;
//   score.value = 0;
//   selected.value = "";
//   answersList.clear();
//
//   final data = await ApiServices.getQuestions(dayId, classId);
//
//   questions.assignAll(data);
//
//
//   if (questions.isEmpty) {
//     return false;
//   }
//
//   startTimer();
//   return true;
// }
//
//   Future<void> submitFinalAnswer(
//       int classId,
//       int dayId,
//       ) async {
//
//     final student = AuthController.instance.student.value;
//
//     if (student.id == null) {
//       Get.snackbar("Error", "Student not found");
//       return;
//     }
//
//     final message = await ApiServices.submitAnswer(
//       studentId: int.parse(student.id!),
//       courseId: classId,
//       dayId: dayId,
//       classId: classId,
//       answersList: answersList,
//     );
//
//     AppLog.response(message);
//   }
//
//   /// ▶️ Start Timer
// void startTimer() {
//   print("Timer Started");
//   print("Questions Length = ${questions.length}");
//
//   _timer?.cancel();
//   secondsLeft.value = 30;
//
//   _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
//     if (secondsLeft.value > 0) {
//       secondsLeft--;
//     } else {
//       next();
//     }
//   });
// }
//
//   void selectAnswer(String val) {
//     selected.value = val;
//   }
//
//   Future<void> next() async {
//     if (index.value >= questions.length) {
//       _timer?.cancel();
//       return;
//     }
//     final question = questions[index.value];
//
//     bool isCorrect = false;
//
//     if (question.questionTypeId == 1) {
//       isCorrect = selected.value == question.correctAnswer;
//     } else {
//       isCorrect = selected.value
//           .trim()
//           .toLowerCase()
//           .contains(
//         (question.correctAnswer ?? "")
//             .trim()
//             .toLowerCase(),
//       );
//     }
//
//     if (isCorrect) {
//       print(score);
//       score++;
//     }
//     print("Selected => ${selected.value}");
//     print("Correct => ${question.correctAnswer}");
//     print("Question Type => ${question.questionTypeId}");
//     print("isCorrect => $isCorrect");
//
//     final student = AuthController.instance.student.value;
//
//     answersList.add(
//       AnswerModel()
//         ..studentId = int.tryParse(student.id ?? "0")
//         ..questionId = question.id
//         ..courseId = question.subjectId // ya actual courseId
//         ..givenAnswer = selected.value
//         ..isCorrect = isCorrect ? 1 : 0
//         ..timeTaken = 30 - secondsLeft.value
//         ..dayId = question.dayId
//         ..classId = question.classId
//         ..studentAnswer = selected.value
//         ..correctAnswer = question.correctAnswer
//         ..status = "submitted"
//         ..answer = "",
//     );
//
//     if (index.value < questions.length - 1) {
//       index++;
//       selected.value = "";
//       startTimer();
//     } else {
//       _timer?.cancel();
//
//     await  submitFinalAnswer(
//         question.classId ?? 0,
//         question.dayId ?? 0,
//       );
//      await  ClassController.instance.getAllClassesProgress();
//       Get.offNamed(
//         AppRoutes.result,
//         arguments: {
//           "score": score.value,
//           "total": questions.length,
//         },
//       );
//     }
//   }
//
//

  static QuestionController get instance => Get.find();

  var questions = <QuestionModel>[].obs;
  var allDayQuestions = <QuestionModel>[].obs;
  final RxList<AnswerModel> answersList = <AnswerModel>[].obs;

  var demoQuestion = <DemoQuestionModel>[].obs;
  final RxList<DemoResultModel> demAnswersList = <DemoResultModel>[].obs;

  var index = 0.obs;
  var selected = "".obs;
  var score = 0.obs;

  // Track quiz session for visual resets
  var quizSessionId = 0.obs;

  // Store answer for each question index
  final RxList<String> answerPerQuestion = <String>[].obs;

  // Track skipped questions
  final RxList<bool> skippedQuestions = <bool>[].obs;

  // Timer
  var secondsLeft = 30.obs;
  Timer? _timer;

  // Flag to check if timer is paused (for image view)
  var isTimerPaused = false.obs;

  Future<bool> fetchQuestions(String dayId, String classId) async {
    index.value = 0;
    score.value = 0;
    selected.value = "";
    answersList.clear();

    final data = await ApiServices.getQuestions(dayId, classId);
    allDayQuestions.assignAll(data);
    questions.assignAll(data);

    // Initialize answer storage and result list
    answerPerQuestion.value = List.filled(questions.length, '');
    skippedQuestions.value = List.filled(questions.length, false);
    
    // Initialize answersList with empty models for each question
    answersList.assignAll(List.generate(questions.length, (index) => AnswerModel()));

    if (questions.isEmpty) {
      return false;
    }

    return true;
  }

  void startQuizForSubject(dynamic subjectFilter) {
    if (subjectFilter == null) {
      // All Questions
      questions.assignAll(allDayQuestions);
    } else if (subjectFilter is String && subjectFilter.isNotEmpty) {
      // Filter by subject name (from PHP query s.subject_name AS subject_id)
      final nameFiltered = allDayQuestions.where((q) {
        final name = q.subjectName?.trim().toLowerCase() ?? '';
        final target = subjectFilter.trim().toLowerCase();
        return name.contains(target) || target.contains(name) || name == target;
      }).toList();

      if (nameFiltered.isNotEmpty) {
        questions.assignAll(nameFiltered);
      } else {
        questions.assignAll(allDayQuestions);
      }
    } else if (subjectFilter is int) {
      final idFiltered =
          allDayQuestions.where((q) => q.subjectId == subjectFilter).toList();

      if (idFiltered.isNotEmpty) {
        questions.assignAll(idFiltered);
      } else {
        questions.assignAll(allDayQuestions);
      }
    } else {
      questions.assignAll(allDayQuestions);
    }

    index.value = 0;
    score.value = 0;
    selected.value = "";
    answerPerQuestion.value = List.filled(questions.length, '');
    skippedQuestions.value = List.filled(questions.length, false);
    answersList.assignAll(
        List.generate(questions.length, (index) => AnswerModel()));

    startTimer();
  }

  Future<void> submitFinalAnswer(int classId, int dayId) async {
    final student = AuthController.instance.student.value;
    if (student.id == null) {
      Get.snackbar("Error", "Student not found");
      return;
    }


    final message = await ApiServices.submitAnswer(
      studentId: int.parse(student.id!),
      courseId: classId,
      dayId: dayId,
      classId: classId,
      answersList: answersList,
    );

    AppLog.response(message);
  }

  void resetQuizState() {
    try {
      debugPrint("Starting Quiz Reset...");
      
      // 1. Reset primitive counters
      index.value = 0;
      score.value = 0;
      selected.value = "";
      isTimerPaused.value = false;
      
      // 2. Increment session to force UI list reset
      quizSessionId.value++; 
      
      // 3. Clear and Refresh question data
      if (questions.isNotEmpty) {
        // Shuffle for variety (Interactive for kids)
        questions.shuffle();
        
        // 4. Force re-initialization of RxLists
        answersList.value = List.generate(questions.length, (index) => AnswerModel());
        answerPerQuestion.value = List.filled(questions.length, '');
        skippedQuestions.value = List.filled(questions.length, false);
        
        // Explicitly refresh to ensure Obx picks it up
        answersList.refresh();
        answerPerQuestion.refresh();
        skippedQuestions.refresh();
        
        debugPrint("Quiz State Reset: Questions shuffled and all tracking lists cleared.");
      } else {
        answersList.clear();
        answerPerQuestion.clear();
        skippedQuestions.clear();
      }

      // Clear Demo specific lists as well
      demAnswersList.clear();
      
      // 5. Ensure timer is stopped so it can be restarted fresh
      stopTimer();
      secondsLeft.value = 30;
      
    } catch (e) {
      debugPrint("Reset State Critical Error: $e");
    }
  }

  void startTimer() {
    // Don't start if timer is paused
    if (isTimerPaused.value) return;

    // Only start if current question is MCQ
    if (questions.isNotEmpty && questions[index.value].questionTypeId == 1) {
      _timer?.cancel();
      secondsLeft.value = 30;
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (secondsLeft.value > 0) {
          secondsLeft--;
        } else {
          // Time's up - auto skip
          skipQuestion();
        }
      });
    } else {
      stopTimer();
    }
  }

  void stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  void pauseTimer() {
    if (_timer != null) {
      isTimerPaused.value = true;
      _timer?.cancel();
      _timer = null;
    }
  }

  void resumeTimer() {
    if (isTimerPaused.value) {
      isTimerPaused.value = false;
      startTimer();
    }
  }

  void selectAnswer(String val) {
    selected.value = val;
    if (index.value < answerPerQuestion.length) {
      answerPerQuestion[index.value] = val;
      skippedQuestions[index.value] = false; // Not skipped if answered
    }
  }

  void skipQuestion() {
    if (index.value >= questions.length) return;

    final question = questions[index.value];
    final student = AuthController.instance.student.value;

    // Mark as skipped in local tracking
    if (skippedQuestions.length > index.value) {
      skippedQuestions[index.value] = true;
    }
    if (answerPerQuestion.length > index.value) {
      answerPerQuestion[index.value] = ''; // No answer
    }

    // Update the answer model in the list so it's recorded as skipped
    if (index.value < answersList.length) {
      answersList[index.value] = AnswerModel()
        ..studentId = int.tryParse(student.id ?? "0")
        ..questionId = question.id
        ..courseId = question.subjectId
        ..givenAnswer = ""
        ..isCorrect = 0
        ..timeTaken = 30 - secondsLeft.value
        ..dayId = question.dayId
        ..classId = question.classId
        ..studentAnswer = ""
        ..correctAnswer = question.correctAnswer
        ..status = "skipped"
        ..answer = "";
    }

    // Move to next
    if (index.value < questions.length - 1) {
      index.value++;
      selected.value = answerPerQuestion.length > index.value
          ? answerPerQuestion[index.value] ?? ''
          : '';
      startTimer();
    } else {
      // Last question - show submit dialog
      _timer?.cancel();
      showSubmitConfirmation();
    }
  }

  void goBack() {
    if (index.value > 0) {
      stopTimer();
      index.value--;
      // Restore selected answer for the new current question
      selected.value = answerPerQuestion[index.value] ?? '';
      // Start timer if MCQ else stop
      if (questions[index.value].questionTypeId == 1) {
        startTimer();
      } else {
        stopTimer();
      }
    }
  }

  Future<void> next() async {
    if (index.value >= questions.length) {
      _timer?.cancel();
      return;
    }

    final question = questions[index.value];

    // Check if answer is provided (if not skipped)
    if (selected.value.isEmpty && !skippedQuestions[index.value]) {
      // Don't proceed - answer required
      return;
    }

    bool isCorrect = false;

    if (question.questionTypeId == 1) {
      isCorrect = selected.value == question.correctAnswer;
    } else {
      isCorrect = selected.value
          .trim()
          .toLowerCase()
          .contains((question.correctAnswer ?? "").trim().toLowerCase());
    }

    final student = AuthController.instance.student.value;
    
    // Update the existing answer model instead of adding
    if (index.value < answersList.length) {
      answersList[index.value] = AnswerModel()
        ..studentId = int.tryParse(student.id ?? "0")
        ..questionId = question.id
        ..courseId = question.subjectId
        ..givenAnswer = selected.value
        ..isCorrect = isCorrect ? 1 : 0
        ..timeTaken = 30 - secondsLeft.value
        ..dayId = question.dayId
        ..classId = question.classId
        ..studentAnswer = selected.value
        ..correctAnswer = question.correctAnswer
        ..status = "submitted"
        ..answer = "";
    }

    // Recalculate score
    score.value = answersList.where((ans) => ans.isCorrect == 1).length;

    if (index.value < questions.length - 1) {
      index.value++;
      selected.value = answerPerQuestion[index.value] ?? '';
      startTimer();
    } else {
      _timer?.cancel();
      showSubmitConfirmation();
    }
  }

  void showSubmitConfirmation() {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.correct.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.task_alt_rounded,
                  color: AppColors.correct,
                  size: 40,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Submit Quiz?",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                "Excellent effort! You have reached the end. Are you sure you want to submit your answers and see your results?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.textGrey,
                  fontSize: 15,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 28),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Get.back(),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        side: BorderSide(color: Colors.grey.shade300),
                      ),
                      child: const Text(
                        "Review",
                        style: TextStyle(color: Colors.black87),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        Get.back();
                        await _submitQuiz();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text("Submit"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

// Make _submitQuiz public or keep as is
  Future<void> _submitQuiz() async {
    if (questions.isEmpty) return;

    final question = questions[0];
    await submitFinalAnswer(
      question.classId ?? 0,
      question.dayId ?? 0,
    );

    if (question.classId != null && question.dayId != null) {
      if (Get.isRegistered<DayController>()) {
        await DayController.instance.markDayCompleted(
          question.classId!,
          question.dayId!,
        );
      }
    }

    await ClassController.instance.getAllClassesProgress();
    Get.offNamed(
      AppRoutes.result,
      arguments: {
        "score": score.value,
        "total": questions.length,
      },
    );
  }
Future<void> nextDemo() async {
  if (index.value >= demoQuestion.length) {
    _timer?.cancel();
    return;
  }

  final question = demoQuestion[index.value];

  bool isCorrect = selected.value
      .trim()
      .toLowerCase()
      .contains(question.correctAnswer.trim().toLowerCase());

  if (isCorrect) {
    score.value++;
  }

  print("Selected => ${selected.value}");
  print("Correct => ${question.correctAnswer}");
  print("isCorrect => $isCorrect");

  if (index.value < demoQuestion.length - 1) {
    index.value++;
    selected.value = "";
    startTimer();
  } else {
    _timer?.cancel();

    final student = AuthController.instance.student.value;

    final result = DemoResultModel(
      id: 0,
      studentId: int.tryParse(student.id ?? "0") ?? 0,
      classId: question.classId,
      totalQuestions: demoQuestion.length,
      correctAnswers: score.value,
      wrongAnswers: demoQuestion.length - score.value,
      score: score.value,
      createdAt: DateTime.now().toIso8601String(),
    );

    demAnswersList.add(result);

    // TODO: Call your demo result API here
    await submitDemoResult(result);

    Get.offNamed(
      AppRoutes.demoResult,
      arguments: {
        "score": score.value,
        "total": demoQuestion.length,
      },
    );
  }
}

 Future<void> getDemoQuestions(int classId) async {
  try {
    demoQuestion.clear();
    final response = await ApiHelper.get(
      "get_demo_question.php?class_id=$classId",
    );

    if (response["status"] == true) {
      List<dynamic> data = response["questions"];

     demoQuestion.value = data
          .map((e) => DemoQuestionModel.fromJson(e))
          .toList();
     print("Demo Question List Length is -> ${demoQuestion.length}");

     demoQuestion.refresh();
    } else {
      throw Exception(response["message"] ?? "No questions found");
    }
  } catch (e) {
    throw Exception(e.toString());
  }
}

static Future<bool> submitDemoResult(DemoResultModel result) async {
  try {
    final response = await ApiHelper.post(
      "demo_question_result.php",
      body: {
        "student_id": result.studentId,
        "class_id": result.classId,
        "total_questions": result.totalQuestions,
        "correct_answers": result.correctAnswers,
        "wrong_answers": result.wrongAnswers,
        "score": result.score,
        "created_at": result.createdAt,
      },
    );

    AppLog.response(response);

    if (response["status"] == true) {
      print("✅ ${response["message"]}");
      return true;
    } else {
      print("❌ ${response["message"]}");
      return false;
    }
  } catch (e) {
    print("Submit Demo Result Error: $e");
    return false;
  }
}

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}