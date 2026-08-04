import 'package:always_victory/controller/auth_controller.dart';
import 'package:always_victory/data/api_services/api_service.dart';
import 'package:always_victory/helpers/debug_loger.dart';
import 'package:always_victory/helpers/local_storage.dart';
import 'package:always_victory/helpers/voice_helper.dart';
import 'package:always_victory/models/carousel_model.dart';
import 'package:always_victory/models/class_model.dart';
import 'package:always_victory/models/progress_model.dart';
import 'package:always_victory/models/purchease_class.dart';
import 'package:always_victory/models/review_model.dart';
import 'package:always_victory/models/student_model.dart';
import 'package:get/get.dart';

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

  Future<void> loadOnInit() async {
    print("class ,purchase , ebook loaded");
    try {
      isLoading.value = true;
       await loadClass();
        await  loadPurchaseClass();
        await loadEbooks();
        await loadPurchasedBooks();
    await  Future.wait([
        loadCarousel(),
        getAllClassesProgress(),
        loadEnrollmentCounts(),
        loadReviews(),
      ]);

      isLoading.value = false;

      // Welcome voice greeting for kids
      final name = authController.student.value.name ?? "";
      if (name.isNotEmpty) {
        Future.delayed(const Duration(seconds: 1), () {
          VoiceHelper.speak("नमस्ते $name! Always Victory में आपका स्वागत है। चलिए आज कुछ नया सीखते हैं!");
        });
      }

    } catch (e) {
      isLoading.value = false;
    }
  }

  Future<void> loadClass() async {
    try {
      AppLog.info("Loading classes...");

      final result = await ApiServices.getClasses();

      classes.assignAll(result);

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

      carousal.assignAll(result);

      AppLog.info("Carousel loaded: ${carousal.length}");
    } catch (e, s) {
      AppLog.error("loadCarousel Error: $e");
      AppLog.error(s.toString());
    }
  }

  Future<void> getAllClassesProgress() async {
    try {
      AppLog.info("Loading progress...");

      if (classes.isEmpty) {
        AppLog.info("Classes are empty. Skipping progress API.");
        return;
      }

      final json = await LocalStorage.getStudent();
      if(json == null){
        print("classes null.........❌❌❌❌");

        return;
      }
      final student = StudentModel.fromJson(json);

      if (student.id == null || student.id!.isEmpty) {
        AppLog.response(student.toJson());
        AppLog.error("Student ID is null or empty");
        return;
      }

      final studentId = int.tryParse(student.id!);

      if (studentId == null) {
        AppLog.error("Invalid Student ID: ${student.id}");
        return;
      }

      final results = await Future.wait(
        classes.map(
              (cls) => ApiServices.getProgress(
            studentId: studentId,
            classId: cls.id,
          ),
        ),
      );

      questionProgress.assignAll(
        results.whereType<ProgressModel>(),
      );

      
      questionProgress.forEach((element) => AppLog.response(element.toJson()),);
      
      AppLog.info(
        "Progress loaded: ${questionProgress.length}",
      );
    } catch (e, s) {
      AppLog.error("getAllClassesProgress Error: $e");
      AppLog.error(s.toString());
    }
  }

  Future<void> loadEnrollmentCounts() async {
    try {
      final results = await Future.wait(
        classes.map(
              (cls) => ApiServices.getEnrollmentCount(
            classId: cls.id,
          ),
        ),
      );

      for (final item in results) {
        enrollmentCounts[item.classId] =
            item.totalStudents;
      }
    } catch (e) {
      AppLog.error(e.toString());
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

      purchaseClass.clear();

      final json = await LocalStorage.getStudent();
      if(json  == null){
        print("purchase null.........❌❌❌❌");
        return;
      }
          final student = StudentModel.fromJson(json);
      var purchasedClasses ;
        if(student.id!=null){
         purchasedClasses= await ApiServices.getPurchasedClasses(
            studentId: int.parse(student.id!),
          );
        }else {
          print("Student Id Null..");
        }



      final purchasedIds =
      purchasedClasses.map((e) => e.classId).toSet();

      for (final cls in classes) {
        AppLog.info(
          "Checking Class => ${cls.id} : ${purchasedIds.contains(cls.id)}",
        );

        purchaseClass[cls.id] = purchasedIds.contains(cls.id);
      }

      purchaseClass.refresh();
    } catch (e, s) {
      AppLog.error(e.toString());
      AppLog.error(s.toString());
    }
  }


  Future<void> loadEbooks() async {
    try {
      final result = await ApiServices.getEbooks();
      ebooks.assignAll(result);

    } catch (e) {
      print(e);
    }
  }

  Future<void> loadPurchasedBooks() async {

    purchasedBooks.clear();
    final studentJson =  await LocalStorage.getStudent();
    if(studentJson == null){
      return AppLog.error("Student Getting Null");
    }

    final student = StudentModel.fromJson(studentJson);

    final result =
    await ApiServices.getPurchasedBooks(
      studentId: int.parse(student.id!),
    );

    for(final item in result){
      purchasedBooks[item.ebookId] = true;
    }
    print("Purchased Books => $purchasedBooks");
    purchasedBooks.refresh();
  }

  Future<void> loadReviews() async {
    try {
      final result = await ApiServices.getReviews();
      reviews.assignAll(result);
      print("Review Loading....");
    } catch (e) {
      AppLog.error("loadReviews Error: $e");
    }
  }
}
