import 'package:always_victory/controller/auth_controller.dart';
import 'package:always_victory/data/api_services/api_service.dart';
import 'package:always_victory/helpers/debug_loger.dart';
import 'package:always_victory/helpers/local_storage.dart';
import 'package:always_victory/helpers/voice_helper.dart';
import 'package:always_victory/models/carousel_model.dart';
import 'package:always_victory/models/class_model.dart';
import 'package:always_victory/models/progress_model.dart';
import 'package:always_victory/models/review_model.dart';
import 'package:always_victory/models/student_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/painting.dart';
import 'package:get/get.dart';

import '../data/app_config/app_config.dart';
import '../data/api_helper/api_helper.dart';
import '../models/ebook_model.dart';

class ClassController extends GetxController {
  static ClassController get instance => Get.find();

  final AuthController authController = Get.find<AuthController>();

  final classes = <ClassModel>[].obs;
  final carousal = <CarouselModel>[].obs;
  final questionProgress = <ProgressModel>[].obs;
  final enrollmentCounts = <int, int>{}.obs;
  final purchaseClass = <int, bool>{}.obs;
  final Rx<ClassModel?> selectedClass = Rx<ClassModel?>(null);
  final isLoading = false.obs;

  final ebooks = <EbookModel>[].obs;
  final purchasedBooks = <int, bool>{}.obs;

  final reviews = <ReviewModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadOnInit();
  }

  /// ⚡ 1. Ultra-Fast Local Cache Restore:
  /// Reads cached classes, banners, and ebooks from SharedPreferences instantly (0 ms).
  /// Home screen renders immediately without blocking on network requests!
  Future<bool> loadFromCache() async {
    try {
      final cachedClasses = await LocalStorage.getClasses();
      final cachedCarousel = await LocalStorage.getCarousel();
      final cachedEbooks = await LocalStorage.getEbooks();
      final cachedPurchasedClasses = await LocalStorage.getPurchasedClasses();
      final cachedPurchasedBooks = await LocalStorage.getPurchasedBooks();
      final cachedEnrollments = await LocalStorage.getEnrollmentCounts();
      final cachedReviews = await LocalStorage.getReviews();
      final cachedProgress = await LocalStorage.getProgress();

      bool hasData = false;

      if (cachedClasses.isNotEmpty) {
        classes.assignAll(cachedClasses);
        hasData = true;
      }
      if (cachedCarousel.isNotEmpty) {
        carousal.assignAll(cachedCarousel);
        hasData = true;
      }
      if (cachedEbooks.isNotEmpty) {
        ebooks.assignAll(cachedEbooks);
        hasData = true;
      }
      if (cachedPurchasedClasses.isNotEmpty) {
        purchaseClass.assignAll(cachedPurchasedClasses);
      }
      if (cachedPurchasedBooks.isNotEmpty) {
        purchasedBooks.assignAll(cachedPurchasedBooks);
      }
      if (cachedEnrollments.isNotEmpty) {
        enrollmentCounts.assignAll(cachedEnrollments);
      }
      if (cachedReviews.isNotEmpty) {
        reviews.assignAll(cachedReviews);
      }
      if (cachedProgress.isNotEmpty) {
        questionProgress.assignAll(cachedProgress);
      }

      AppLog.info(
        "Cache restored: classes=${classes.length}, banners=${carousal.length}, ebooks=${ebooks.length}",
      );
      return hasData;
    } catch (e) {
      AppLog.error("loadFromCache Error: $e");
      return false;
    }
  }

  /// 🚀 2. Cache-First Stale-While-Revalidate Engine:
  /// Restores cache first, then silently refreshes data over the network in parallel.
  Future<void> loadOnInit() async {
    try {
      // Step A: Instant cache restore
      final hasCachedData = await loadFromCache();

      // Only show full-screen loader on first install when cache is completely empty
      if (!hasCachedData) {
        isLoading.value = true;
      }

      // Step B: Fetch primary Home items concurrently in parallel
      await Future.wait([
        loadClass(),
        loadCarousel(),
        loadEbooks(),
      ]);

      // Core content is refreshed, dismiss loader
      isLoading.value = false;

      // Personalized Voice Greeting in English (ONLY ONCE per install/first time, non-blocking)
      final name = authController.student.value.name ?? "";
      if (name.isNotEmpty) {
        LocalStorage.hasPlayedVoiceGreeting().then((alreadyPlayed) {
          if (!alreadyPlayed) {
            LocalStorage.setVoiceGreetingPlayed();
            Future.delayed(const Duration(milliseconds: 700), () {
              VoiceHelper.speak(
                "Welcome $name to Always Victory! Let's learn something new today!",
              );
            });
          }
        });
      }

      // Step C: Background refresh for secondary data (non-blocking)
      await Future.wait([
        loadPurchaseClass(),
        loadPurchasedBooks(),
        loadEnrollmentCounts(),
        loadReviews(),
        getAllClassesProgress(),
      ]);
    } catch (e, s) {
      AppLog.error("loadOnInit Network Error: $e");
      AppLog.error(s.toString());
      isLoading.value = false;
    }
  }

  Future<void> loadClass() async {
    try {
      AppLog.info("Loading classes...");
      final result = await ApiServices.getClasses();

      if (result.isNotEmpty) {
        classes.assignAll(result);
        await LocalStorage.saveClasses(classes);
        _precacheImages();
      }
      AppLog.info("Classes loaded: ${classes.length}");
    } catch (e, s) {
      AppLog.error("loadClass Error: $e");
      AppLog.error(s.toString());
    }
  }

  Future<void> loadCarousel() async {
    try {
      AppLog.info("Loading carousel...");
      final result = await ApiServices.getCarousel();

      if (result.isNotEmpty) {
        carousal.assignAll(result);
        await LocalStorage.saveCarousel(carousal);
        _precacheImages();
      }
      AppLog.info("Carousel loaded: ${carousal.length}");
    } catch (e, s) {
      AppLog.error("loadCarousel Error: $e");
      AppLog.error(s.toString());
    }
  }

  void _precacheImages() {
    try {
      for (final item in carousal.take(5)) {
        if (item.imageUrl.isNotEmpty) {
          final url = "${AppConfig.carsouleImageBaseUrl}${item.imageUrl}";
          CachedNetworkImageProvider(url).resolve(ImageConfiguration.empty);
        }
      }
      for (final cls in classes.take(6)) {
        if (cls.posterImage.isNotEmpty) {
          final url = "${AppConfig.studentImageBaseUrl}${cls.posterImage}";
          CachedNetworkImageProvider(url).resolve(ImageConfiguration.empty);
        }
      }
    } catch (_) {}
  }

  Future<void> getAllClassesProgress() async {
    try {
      if (classes.isEmpty) return;

      final json = await LocalStorage.getStudent();
      if (json == null) return;

      final student = StudentModel.fromJson(json);
      if (student.id == null || student.id!.isEmpty) return;

      final studentId = int.tryParse(student.id!);
      if (studentId == null) return;

      final results = await Future.wait(
        classes.map(
          (cls) => ApiServices.getProgress(
            studentId: studentId,
            classId: cls.id,
          ),
        ),
      );

      final validProgress = results.whereType<ProgressModel>().toList();
      questionProgress.assignAll(validProgress);
      await LocalStorage.saveProgress(questionProgress);

      AppLog.info("Progress loaded: ${questionProgress.length}");
    } catch (e, s) {
      AppLog.error("getAllClassesProgress Error: $e");
      AppLog.error(s.toString());
    }
  }

  Future<void> loadEnrollmentCounts() async {
    try {
      if (classes.isEmpty) return;

      final results = await Future.wait(
        classes.map(
          (cls) => ApiServices.getEnrollmentCount(
            classId: cls.id,
          ),
        ),
      );

      for (final item in results) {
        enrollmentCounts[item.classId] = item.totalStudents;
      }
      await LocalStorage.saveEnrollmentCounts(enrollmentCounts);
    } catch (e) {
      AppLog.error("loadEnrollmentCounts Error: $e");
    }
  }

  Future<bool> paymentSuccess({
    required int studentId,
    required int classId,
    required double amount,
    required String paymentId,
  }) async {
    final response = await ApiHelper.post(
      "payment_success.php",
      body: {
        "student_id": studentId,
        "class_id": classId,
        "amount": amount,
        "payment_id": paymentId,
      },
    );

    return response["status"] == true;
  }

  Future<void> loadPurchaseClass() async {
    try {
      final json = await LocalStorage.getStudent();
      if (json == null) {
        purchaseClass.clear();
        await LocalStorage.savePurchasedClasses(purchaseClass);
        return;
      }

      final student = StudentModel.fromJson(json);
      if (student.id == null || student.id!.isEmpty) return;

      final studentId = int.tryParse(student.id!);
      if (studentId == null) return;

      final purchasedClasses = await ApiServices.getPurchasedClasses(
        studentId: studentId,
      );

      final purchasedIds = purchasedClasses.map((e) => e.classId).toSet();
      final newMap = <int, bool>{};
      for (final cls in classes) {
        newMap[cls.id] = purchasedIds.contains(cls.id);
      }
      for (final id in purchasedIds) {
        newMap[id] = true;
      }

      purchaseClass.assignAll(newMap);
      await LocalStorage.savePurchasedClasses(purchaseClass);
    } catch (e, s) {
      AppLog.error("loadPurchaseClass Error: $e");
      AppLog.error(s.toString());
    }
  }

  Future<void> loadEbooks() async {
    try {
      final result = await ApiServices.getEbooks();
      if (result.isNotEmpty) {
        ebooks.assignAll(result);
        await LocalStorage.saveEbooks(ebooks);
      }
    } catch (e) {
      AppLog.error("loadEbooks Error: $e");
    }
  }

  Future<void> loadPurchasedBooks() async {
    try {
      final studentJson = await LocalStorage.getStudent();
      if (studentJson == null) {
        purchasedBooks.clear();
        await LocalStorage.savePurchasedBooks(purchasedBooks);
        return;
      }

      final student = StudentModel.fromJson(studentJson);
      if (student.id == null || student.id!.isEmpty) return;

      final studentId = int.tryParse(student.id!);
      if (studentId == null) return;

      final result = await ApiServices.getPurchasedBooks(
        studentId: studentId,
      );

      final newBookMap = <int, bool>{};
      for (final b in ebooks) {
        newBookMap[b.id] = false;
      }
      for (final item in result) {
        newBookMap[item.ebookId] = true;
      }
      purchasedBooks.assignAll(newBookMap);
      await LocalStorage.savePurchasedBooks(purchasedBooks);
    } catch (e) {
      AppLog.error("loadPurchasedBooks Error: $e");
    }
  }

  Future<void> loadReviews() async {
    try {
      final result = await ApiServices.getReviews();
      if (result.isNotEmpty) {
        reviews.assignAll(result);
        await LocalStorage.saveReviews(reviews);
      }
    } catch (e) {
      AppLog.error("loadReviews Error: $e");
    }
  }
}
