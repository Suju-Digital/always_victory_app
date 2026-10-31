import 'package:get/get.dart';
import '../data/api_helper/api_helper.dart';
import '../data/api_services/api_service.dart';
import '../data/app_config/app_config.dart';
import '../helpers/debug_loger.dart';
import '../helpers/local_storage.dart';
import '../models/about_model.dart';
import '../models/day_model.dart';
import '../models/student_model.dart';

class DayController extends GetxController {
  static DayController get instance => Get.find();

  final days = <DayModel>[].obs;
  final Rxn<AboutModel> aboutData = Rxn<AboutModel>();
  final completedDayIds = <int>{}.obs;
  final RxBool isLoadingProgress = false.obs;
  int? currentClassId;

  @override
  void onInit() {
    super.onInit();
    loadAbout();
  }

  Future<void> getDays({
    required int classId,
  }) async {
    try {
      currentClassId = classId;

      final response = await ApiHelper.get(
        '${AppConfig.getDays}?class_id=$classId',
      );

      final data = (response['data'] as List)
          .map((e) => DayModel.fromJson(e))
          .toList();

      days.assignAll(data);

      // Load completed days from local storage & server for cross-device sync
      await loadDayCompletionStatus(classId);
    } catch (e) {
      AppLog.error("Get Days Error: $e");
    }
  }

  /// Load completed days from cache first, then sync with server attempts
  Future<void> loadDayCompletionStatus(int classId) async {
    try {
      isLoadingProgress.value = true;
      final studentJson = await LocalStorage.getStudent();
      if (studentJson == null) return;
      final student = StudentModel.fromJson(studentJson);
      if (student.id == null || student.id!.isEmpty) return;

      final studentId = student.id!;

      // 1. Fast path: load cached completed days immediately
      final cachedCompleted = await LocalStorage.getCompletedDays(studentId, classId);
      if (cachedCompleted.isNotEmpty) {
        completedDayIds.addAll(cachedCompleted);
        completedDayIds.refresh();
      }

      // 2. Network sync: fetch attempts from server in parallel for all days
      if (days.isNotEmpty) {
        final futures = days.map((day) async {
          try {
            final attempts = await ApiServices.getStudentAttempts(
              studentId: studentId,
              classId: classId.toString(),
              dayId: day.id.toString(),
            );
            if (attempts.status && (attempts.totalAttempts > 0 || attempts.data.isNotEmpty)) {
              return day.id;
            }
          } catch (e) {
            AppLog.error("Error checking day ${day.id} completion: $e");
          }
          return null;
        });

        final results = await Future.wait(futures);
        final serverCompleted = results.whereType<int>().toSet();

        if (serverCompleted.isNotEmpty) {
          completedDayIds.addAll(serverCompleted);
          completedDayIds.refresh();
          await LocalStorage.saveCompletedDays(studentId, classId, completedDayIds);
        }
      }
    } catch (e) {
      AppLog.error("loadDayCompletionStatus Error: $e");
    } finally {
      isLoadingProgress.value = false;
    }
  }

  /// Check if a day is unlocked sequentially:
  /// Day 1 (index 0) is always unlocked.
  /// Day N is unlocked if Day N-1 has been completed.
  bool isDayUnlocked(int index) {
    if (index == 0) return true;
    if (index > 0 && index - 1 < days.length) {
      final prevDay = days[index - 1];
      return completedDayIds.contains(prevDay.id);
    }
    return false;
  }

  /// Check if a day has been completed
  bool isDayCompleted(int dayId) {
    return completedDayIds.contains(dayId);
  }

  /// Mark a day as completed (called when user submits quiz)
  Future<void> markDayCompleted(int classId, int dayId) async {
    completedDayIds.add(dayId);
    completedDayIds.refresh();

    try {
      final studentJson = await LocalStorage.getStudent();
      if (studentJson != null) {
        final student = StudentModel.fromJson(studentJson);
        if (student.id != null && student.id!.isNotEmpty) {
          await LocalStorage.saveCompletedDays(student.id!, classId, completedDayIds);
        }
      }
    } catch (e) {
      AppLog.error("markDayCompleted error: $e");
    }
  }

  int get totalDays => days.length;

  Future<void> loadAbout() async {
    AppLog.info("Load about...");
    aboutData.value = await ApiServices.getAbout();
  }
}
