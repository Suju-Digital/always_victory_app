import 'dart:ui';

import 'package:always_victory/data/api_services/api_service.dart';
import 'package:always_victory/helpers/debug_loger.dart';
import 'package:always_victory/helpers/local_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../data/api_helper/api_helper.dart';
import '../models/day_model.dart';
import '../models/progress_model_over_all.dart';
import '../models/student_attempt_model.dart';
import '../models/student_model.dart';
import 'days_controller.dart';

/// Class Progress Data Model
class ClassProgressData {
  final int totalQuestions;
  final int solvedQuestions;
  final double percentage;

  ClassProgressData({
    required this.totalQuestions,
    required this.solvedQuestions,
    required this.percentage,
  });
}

class ProgressController extends GetxController {
  RxBool isLoading = false.obs;

  Rx<StudentProgressModel?> progress = Rx<StudentProgressModel?>(null);

  final RxMap<int, List<DayModel>> classDays = <int, List<DayModel>>{}.obs;
  final dayController = Get.find<DayController>();

  final RxMap<String, StudentAttemptResponse> attempts =
      <String, StudentAttemptResponse>{}.obs;

  RxString studentName = "".obs;
  RxInt classId = 0.obs;

  // These are the main stats that will be displayed
  RxInt totalQuestions = 0.obs;
  RxInt correctAnswers = 0.obs;
  RxDouble accuracy = 0.0.obs;

  // Store progress per class
  final RxMap<int, ClassProgressData> classProgress = <int, ClassProgressData>{}.obs;

  RxList<int> weeklyProgress = <int>[].obs;

  StudentAttemptResponse? studentAttemptResponse;

  @override
  void onInit() {
    super.onInit();
    loadStudent();
  }

  Future<void> loadStudent() async {
    try {
      final userJson = await LocalStorage.getStudent();

      if (userJson == null) return;

      final student = StudentModel.fromJson(userJson);

      studentName.value = student.name ?? "";
      classId.value = int.tryParse(student.classId ?? "0") ?? 0;

      if (student.id != null) {
        await getProgress(int.parse(student.id!));
      }
    } catch (e) {
      AppLog.error("Error loading student: $e");
    }
  }

  /// Get overall progress for the student
  Future<void> getProgress(int studentId) async {
    try {
      isLoading.value = true;
      AppLog.info("Fetching progress for student: $studentId");

      final response = await ApiHelper.get(
        "get_progress.php?student_id=$studentId",
      );

      AppLog.info("Progress response: $response");

      final model = StudentProgressModel.fromJson(response);

      progress.value = model;

      // Update the observable values
      totalQuestions.value = model.totalQuestions ?? 0;
      correctAnswers.value = model.correctAnswers ?? 0;

      // Calculate accuracy
      if (totalQuestions.value > 0) {
        accuracy.value = (correctAnswers.value / totalQuestions.value) * 100;
      } else {
        accuracy.value = 0.0;
      }

      AppLog.info("Progress loaded: Total=${totalQuestions.value}, Correct=${correctAnswers.value}, Accuracy=${accuracy.value}");

    } catch (e) {
      AppLog.error("Error fetching progress: $e");
      Get.snackbar(
        "Error",
        "Failed to load progress. Please try again.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Get progress for a specific class
  double getClassProgress(int classId) {
    final progressData = classProgress[classId];
    if (progressData == null) return 0.0;
    return progressData.percentage;
  }

  /// Get total questions for a class
  int getClassTotalQuestions(int classId) {
    final progressData = classProgress[classId];
    if (progressData == null) return 0;
    return progressData.totalQuestions;
  }

  /// Get solved questions for a class
  int getClassSolvedQuestions(int classId) {
    final progressData = classProgress[classId];
    if (progressData == null) return 0;
    return progressData.solvedQuestions;
  }

  /// Load days for a specific class
  Future<void> loadDays(
      int classId, {
        bool forceRefresh = false,
      }) async {
    try {
      print("📚 loadDays called for classId: $classId");

      if (!forceRefresh && classDays.containsKey(classId)) {
        final cachedDays = classDays[classId];
        if (cachedDays != null && cachedDays.isNotEmpty) {
          print("✅ Using cached days for class $classId (${cachedDays.length} days)");
          return;
        }
      }

      isLoading.value = true;
      print("🔄 Fetching days from API for class $classId...");

      await dayController.getDays(classId: classId);

      classDays[classId] = List.from(dayController.days);

      print("✅ Loaded ${dayController.days.length} days for class $classId");
      classDays.refresh();

    } catch (e) {
      print("❌ Error loading days: $e");
      Get.snackbar(
        "Error",
        "Failed to load days. Please try again.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Load attempts for a specific day
  Future<void> loadAttempts({
    required int studentId,
    required int classId,
    required int dayId,
  }) async {
    try {
      final key = "${classId}_$dayId";

      if (attempts.containsKey(key)) {
        print("✅ Using cached attempts for $key");
        return;
      }

      print("🔄 Fetching attempts for student: $studentId, class: $classId, day: $dayId");

      final result = await ApiServices.getStudentAttempts(
        studentId: studentId.toString(),
        classId: classId.toString(),
        dayId: dayId.toString(),
      );

      attempts[key] = result;
      attempts.refresh();

      print("✅ Loaded ${result.data.length} attempts for $key");

    } catch (e) {
      print("❌ Error loading attempts: $e");
      Get.snackbar(
        "Error",
        "Failed to load attempts. Please try again.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
      );
    }
  }

  /// Get progress for a specific day
  double getDayProgress(int classId, int dayId) {
    try {
      final key = "${classId}_$dayId";
      final attemptData = attempts[key];

      if (attemptData == null || attemptData.data.isEmpty) {
        return 0.0;
      }

      // Get the latest attempt percentage
      final latestAttempt = attemptData.data.last;
      return latestAttempt.percentage;

    } catch (e) {
      print("❌ Error getting day progress: $e");
      return 0.0;
    }
  }

  /// Get average progress for a class
  double getAverageProgress(int classId) {
    try {
      final days = classDays[classId] ?? [];

      if (days.isEmpty) {
        return 0.0;
      }

      double total = 0.0;
      int count = 0;

      for (var day in days) {
        final progress = getDayProgress(classId, day.id);
        if (progress > 0) {
          total += progress;
          count++;
        }
      }

      return count > 0 ? total / count : 0.0;

    } catch (e) {
      print("❌ Error getting average progress: $e");
      return 0.0;
    }
  }

  /// Get star rating based on percentage
  String getStars(double percentage) {
    if (percentage >= 90) return "⭐⭐⭐⭐⭐";
    if (percentage >= 75) return "⭐⭐⭐⭐☆";
    if (percentage >= 60) return "⭐⭐⭐☆☆";
    if (percentage >= 40) return "⭐⭐☆☆☆";
    return "⭐☆☆☆☆";
  }

  /// Get star count (0-5)
  int getStarCount(double percentage) {
    if (percentage >= 90) return 5;
    if (percentage >= 75) return 4;
    if (percentage >= 60) return 3;
    if (percentage >= 40) return 2;
    return 1;
  }

  /// Get progress color based on percentage
  Color getProgressColor(double percentage) {
    if (percentage >= 75) return Colors.green;
    if (percentage >= 50) return Colors.orange;
    return Colors.red;
  }

  /// Get progress emoji based on percentage
  String getProgressEmoji(double percentage) {
    if (percentage >= 90) return '🌟';
    if (percentage >= 75) return '🎯';
    if (percentage >= 60) return '📈';
    if (percentage >= 40) return '📚';
    return '💪';
  }

  /// Get progress message based on percentage
  String getProgressMessage(double percentage) {
    if (percentage >= 90) return "🌟 Outstanding!";
    if (percentage >= 75) return "⭐ Great Job!";
    if (percentage >= 60) return "📈 Good Work!";
    if (percentage >= 40) return "📚 Keep Going!";
    return "💪 Keep Practicing!";
  }

  /// Refresh all progress data
  Future<void> refreshAllData(int studentId) async {
    try {
      isLoading.value = true;

      // Clear cache
      classDays.clear();
      attempts.clear();
      classProgress.clear();

      // Fetch fresh data
      await getProgress(studentId);

      Get.snackbar(
        "✅ Refreshed",
        "Progress data has been updated!",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.shade100,
        duration: const Duration(seconds: 2),
      );

    } catch (e) {
      AppLog.error("Error refreshing data: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// Clear all cached data
  void clearCache() {
    classDays.clear();
    attempts.clear();
    classProgress.clear();
    print('🗑️ Cache cleared');
  }

  /// Clear cache for a specific class
  void clearClassCache(int classId) {
    classDays.remove(classId);
    attempts.removeWhere((key, value) => key.startsWith("${classId}_"));
    classProgress.remove(classId);
    print('🗑️ Cache cleared for class $classId');
  }

  /// Get total attempts count
  int getTotalAttempts() {
    int total = 0;
    attempts.forEach((key, value) {
      total += value.data.length;
    });
    return total;
  }

  /// Get best attempt percentage
  double getBestAttempt() {
    double best = 0.0;
    attempts.forEach((key, value) {
      for (var attempt in value.data) {
        if (attempt.percentage > best) {
          best = attempt.percentage;
        }
      }
    });
    return best;
  }

  /// Get average of all attempts
  double getAverageAttempt() {
    double total = 0.0;
    int count = 0;
    attempts.forEach((key, value) {
      for (var attempt in value.data) {
        total += attempt.percentage;
        count++;
      }
    });
    return count > 0 ? total / count : 0.0;
  }

  /// Get class wise progress summary
  Map<int, ClassProgressData> getClassProgressSummary() {
    return Map.from(classProgress);
  }
}