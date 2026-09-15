import 'dart:convert';
import 'dart:io';
import 'package:always_victory/data/api_helper/api_helper.dart';
import 'package:always_victory/data/app_config/app_config.dart';
import 'package:always_victory/helpers/debug_loger.dart';
import 'package:always_victory/models/answer_model.dart';
import 'package:always_victory/models/review_model.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;

import '../../helpers/local_storage.dart';
import '../../models/about_model.dart';
import '../../models/carousel_model.dart';
import '../../models/class_model.dart';
import '../../models/ebook_model.dart';
import '../../models/ebook_purchase_model.dart';
import '../../models/enroll_class_model.dart';
import '../../models/onboard_model.dart';
import '../../models/progress_model.dart';
import '../../models/purchase_class_model.dart';
import '../../models/question_model.dart';
import '../../models/student_attempt_model.dart';
import '../../models/student_model.dart';

class ApiServices {
  ApiServices._();

  static Future<List<OnboardModel>> getOnboards() async {
    final response = await http.get(Uri.parse("${AppConfig.baseUrl}${AppConfig.onBoard}"));

    if (response.statusCode != 200) {
      throw Exception('Failed to load onboarding data');
    }

    final Map<String, dynamic> json = jsonDecode(response.body);
    final List<dynamic> data = json['data'] ?? [];

    return data.map((item) => OnboardModel.fromJson(item)).toList();
  }

  static String getImageUrl(String imagePath) {
    print('${AppConfig.imageBaseUrl}$imagePath');
    return '${AppConfig.imageBaseUrl}$imagePath';
  }

  static Future<Map<String, dynamic>> registerStudent({
    required StudentModel student,
    required String password,
  }) async {
    final response = await ApiHelper.post(
      "registration-api.php",
      body: {
        "name": student.name,
        "email": student.email,
        "mobile": student.mobile,
        "password": password,
        "class_name": student.className,
        "class_id": student.classId,
      },
    );

    return Map<String, dynamic>.from(response);
  }

  static Future<List<ClassModel>> getClasses() async {
    try {
      final response = await ApiHelper.get(
        AppConfig.getClass,
      );

      if (response['status'] == true) {
        final List<dynamic> data = response['data'] ?? [];
        return data.map((item) => ClassModel.fromJson(item)).toList();
      }

      return [];
    } catch (e) {
      throw Exception('Failed to load classes: $e');
    }
  }

  static Future<List<CarouselModel>> getCarousel() async {
    try {
      final response = await ApiHelper.get(
        AppConfig.carousel,
      );

      AppLog.response(response);

      if (response['status'] == true) {
        final List<dynamic> data = response['data'] ?? [];
        return data.map((item) => CarouselModel.fromJson(item)).toList();
      }

      return [];
    } catch (e) {
      throw Exception('Failed to load features: $e');
    }
  }

  static Future<ProgressModel?> getProgress({
    required int studentId,
    required int classId,
  }) async {
    try {
      final response = await ApiHelper.post(
        AppConfig.progress,
        body: {
          'student_id': studentId,
          'class_id': classId,
        },
      );
      AppLog.response(response);
      return ProgressModel.fromJson(response);
    } catch (e) {
      AppLog.error(e.toString());
    }
    return null;
  }

  static Future<EnrollmentModel> getEnrollmentCount({
    required int classId,
  }) async {
    final response = await ApiHelper.post(
      AppConfig.enrollStudent,
      body: {
        'class_id': classId,
      },
    );

    return EnrollmentModel.fromJson(response);
  }

  static Future<List<ClassItem>> getPurchasedClasses({
    required int studentId,
  }) async {
    final response = await ApiHelper.get(
      '${AppConfig.purchaseCLassCourse}?student_id=$studentId',
    );

    if (response['status'] != true) {
      return [];
    }

    final List<dynamic> classes = response['data']?['classes'] ?? [];

    return classes.map((e) => ClassItem.fromJson(e)).toList();
  }

  static Future<List<QuestionModel>> getQuestions(String dayId, String classId) async {
    try {
      // Send with query params since PHP script expects $_GET['day_id']
      final endpointWithQuery = "${AppConfig.getQuestion}?day_id=$dayId&class_id=$classId";
      
      var response = await ApiHelper.get(endpointWithQuery);

      if (response['status'] != true) {
        response = await ApiHelper.post(
          endpointWithQuery,
          body: {
            "day_id": dayId,
            "class_id": classId,
          },
        );
      }

      if (response['status'] == true && response['data'] != null) {
        List data = response['data'];
        return data.map((e) => QuestionModel.fromJson(e)).toList();
      }

      return [];
    } catch (e) {
      print("getQuestions Error => $e");
      return [];
    }
  }

  static Future<bool> submitAnswer({
    required int studentId,
    required int courseId,
    required int dayId,
    required int classId,
    required List<AnswerModel> answersList,
  }) async {
    try {
      final response = await ApiHelper.post(
        AppConfig.submitAnswer,
        body: {
          "student_id": studentId,
          "course_id": courseId,
          "day_id": dayId,
          "class_id": classId,
          "answers": answersList.map((e) => e.toJson()).toList(),
        },
      );

      return response['success'] == true;
    } catch (e) {
      print("API Error => $e");
      return false;
    }
  }

  static Future<List<EbookModel>> getEbooks() async {
    try {
      final response = await ApiHelper.get(
        "get_ebook.php",
      );

      if (response['status'] == true) {
        return (response['data'] as List)
            .map((e) => EbookModel.fromJson(e))
            .toList();
      }

      return [];
    } catch (e) {
      throw Exception("Failed to load ebooks: $e");
    }
  }

  static Future<List<PurchasedBookModel>> getPurchasedBooks({
    required int studentId,
  }) async {
    final response = await ApiHelper.post(
      "get_purchase_ebook.php",
      body: {
        "student_id": studentId,
      },
    );

    if (response['status'] == true) {
      return (response['data'] as List)
          .map((e) => PurchasedBookModel.fromJson(e))
          .toList();
    }

    return [];
  }

  static Future<void> buyEbook({
    required int ebookId,
    required double amount,
    required String transactionId,
  }) async {
    final studentJson = await LocalStorage.getStudent();
    if (studentJson == null) {
      throw Exception("Student not found");
    }
    final student = StudentModel.fromJson(studentJson);

    await ApiHelper.post(
      "ebook_purchase.php",
      body: {
        "student_id": student.id,
        "ebook_id": ebookId,
        "amount": amount,
        "transaction_id": transactionId,
      },
    );
  }

  static Future<StudentAttemptResponse> getStudentAttempts({
    required String studentId,
    required String classId,
    required String dayId,
  }) async {
    final response = await ApiHelper.post(
      "student_attempts.php",
      body: {
        "student_id": studentId,
        "class_id": classId,
        "day_id": dayId,
      },
    );

    return StudentAttemptResponse.fromJson(response);
  }

  static Future<Map<String, dynamic>> uploadFile(
    File file, {
    required String endpoint,
    required String fieldName,
  }) async {
    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('${AppConfig.baseUrl}/$endpoint'),
      );

      final stream = http.ByteStream(file.openRead());
      final length = await file.length();
      final multipartFile = http.MultipartFile(
        fieldName,
        stream,
        length,
        filename: path.basename(file.path),
      );
      request.files.add(multipartFile);

      final response = await request.send();
      final responseString = await response.stream.bytesToString();

      return jsonDecode(responseString);
    } catch (e) {
      throw Exception("Error uploading file: $e");
    }
  }

  static Future<AboutModel> getAbout() async {
    final response = await ApiHelper.get("about_api.php");

    if (response['status'] == true) {
      return AboutModel.fromJson(response['data']);
    } else {
      throw Exception(response['message']);
    }
  }

  static Future<bool> submitReview({
    required int studentId,
    required int rating,
    required String tags,
    required String comment,
  }) async {
    try {
      final response = await ApiHelper.post(
        "submit_review.php",
        body: {
          "student_id": studentId,
          "rating": rating,
          "tags": tags,
          "comment": comment,
        },
      );
      return response['status'] == true;
    } catch (e) {
      AppLog.error("Submit Review Error: $e");
      return false;
    }
  }

  static Future<List<ReviewModel>> getReviews() async {
    try {
      final response = await ApiHelper.get("get_reviews.php");
      if (response['status'] == true) {
        final List data = response['reviews'] ?? [];
        return data.map((e) => ReviewModel.fromJson(e)).toList();
      }
      return [];
    } catch (e) {
      AppLog.error("Get Reviews Error: $e");
      return [];
    }
  }
}
