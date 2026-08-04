import 'dart:convert';

import 'package:always_victory/controller/class_controller.dart';
import 'package:always_victory/controller/question_controller.dart';
import 'package:always_victory/data/api_helper/api_helper.dart';
import 'package:always_victory/data/app_config/app_config.dart';
import 'package:always_victory/helpers/debug_loger.dart';
import 'package:always_victory/models/student_model.dart';
import 'package:always_victory/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;

import '../data/api_services/api_service.dart';
import '../helpers/local_storage.dart';
import '../helpers/utils.dart';
import '../models/class_model.dart';

class AuthController extends GetxController {
  static AuthController get instance => Get.find();

  // ================= STUDENT =================

  Rx<StudentModel> student = StudentModel().obs;

  // ================= LOGIN =================

  final loginController = TextEditingController();
  final passwordController = TextEditingController();

  // ================= REGISTER =================

  final nameController = TextEditingController();
  final contactController = TextEditingController();
  final emailController = TextEditingController();
  final registerPasswordController = TextEditingController();

  // ================= COMMON =================

  final isLoading = false.obs;
  final isPasswordHidden = true.obs;
  final isRegisterPasswordHidden = true.obs;

  final Rxn<ClassModel?> selectedClass = Rxn<ClassModel?>(null);

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  void toggleRegisterPasswordVisibility() {
    isRegisterPasswordHidden.value = !isRegisterPasswordHidden.value;
  }

  // ================= LOGIN =================

  Future<void> login() async {
    final email = loginController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      Utils.show(
        isError: true,
        message: "Please enter Email and Password",
      );
      return;
    }

    try {
      Utils.showLoading(message: "Logging in...");

      final response = await ApiHelper.post(
        AppConfig.login,
        body: {
          'login': email,
          'password': password,
        },
      );



      AppLog.response(response);

      if (response['status'] == true) {
        final json = response['data'] as Map<String, dynamic>;

        student.value = StudentModel.fromJson(json);

        AppLog.info("This Student rx value");
        AppLog.response(student.value.toJson());

        await LocalStorage.setLoggedIn(true);
        await LocalStorage.saveStudent(student.value.toJson());
        await ClassController.instance.loadOnInit();

        Utils.show(
          isSuccess: true,
          message: response['message'] ?? 'Login Successful',
        );
        passwordController.text = "";
        loginController.text = "";
        Get.offAllNamed(AppRoutes.bottomNav);
      } else {
        Utils.show(
          isError: true,
          message: response['message'] ?? 'Login Failed',
        );
      }
      Utils.hide();
    } catch (e, s) {
      Utils.hide();
      AppLog.error('Login Error: $e');
      AppLog.error(s.toString());
      Utils.show(
        isError: true,
        message: e.toString(),
      );
    }
  }

  // ================= REGISTER =================

  Future<void> registerStudent() async {


    String name = nameController.text.trim();
    String contact = contactController.text.trim();
    String studentClass = AuthController.instance.selectedClass.value?.className ?? "";
    String email = emailController.text.trim();
    String password = registerPasswordController.text.trim();



    if (name.isEmpty || contact.isEmpty || studentClass.isEmpty) {
      Utils.show(
        isError: true,
        message: "Name, Contact and Class are required",
      );
      return;
    }

    print(email);
    print(password);

    if ((email.isNotEmpty && password.isEmpty) ||
        (email.isEmpty && password.isNotEmpty)) {
      Utils.show(
        isError: true,
        message: "Email and Password must be filled together",
      );
      return;
    }

    try {
      Utils.showLoading();

      final studentModel = StudentModel(
        name: name,
        mobile: contact,
        className: studentClass,
        email: email.isEmpty ? null : email,
        status: "1",
        classId: selectedClass.value?.id.toString() ?? "",
        createdAt: DateTime.now().toIso8601String(),
      );

      final response = await ApiServices.registerStudent(
        student: studentModel,
        password: password,
      );
      AppLog.response(response);
      if (response['status'] == true) {
        final stId = response['student_id'];
        await LocalStorage.setLoggedIn(true);
        studentModel.id = stId.toString();
        student.value = studentModel;
        await LocalStorage.saveStudent(student.toJson());
        await ClassController.instance.loadOnInit();
       await QuestionController.instance.getDemoQuestions(AuthController.instance.selectedClass.value?.id??0);


        Utils.show(
          isSuccess: true,
          message: "Student Registered Successfully",
        );

        clearRegisterFields();

        Get.back();
        Get.offAllNamed(AppRoutes.demoTest);
        QuestionController.instance.startTimer();
      } else {
        Utils.show(
          isError: true,
          message: response['message'],
        );
      }
    } catch (e) {
      Utils.show(
        isError: true,
        message: e.toString(),
      );
    } finally {
      Utils.hide();
    }
  }



  // ================= UPDATE PROFILE =================

  Future<void> updateProfile({
    required String name,
    required String email,
    required String mobile,
    File? imageFile,
  }) async {
    try {
      isLoading.value = true;

      // Get student ID
      final studentId = student.value.id;
      if (studentId == null || studentId.isEmpty) {
        Utils.showError("Student ID not found. Please login again.");
        return;
      }

      // Prepare data for update
      final Map<String, dynamic> data = {
        'student_id': studentId,
        'name': name,
        'email': email,
        'mobile': mobile,
      };

      String? uploadedImagePath;

      // If image is selected, upload it first
      if (imageFile != null) {
        try {
          // Create multipart request for image upload
          final request = http.MultipartRequest(
            'POST',
            Uri.parse('${AppConfig.baseUrl}/upload_student_photo.php'),
          );

          // Add student ID
          request.fields['student_id'] = studentId;

          // Add image file
          final stream = http.ByteStream(imageFile.openRead());
          final length = await imageFile.length();
          final multipartFile = http.MultipartFile(
            'photo',
            stream,
            length,
            filename: path.basename(imageFile.path),
          );
          request.files.add(multipartFile);

          // Send request
          final response = await request.send();
          final responseString = await response.stream.bytesToString();
          final imageResponse = jsonDecode(responseString);

          AppLog.response(imageResponse);

          if (imageResponse['status'] == true) {
            uploadedImagePath = imageResponse['filename'];
            if (uploadedImagePath != null) {
              data['photo'] = uploadedImagePath;
            }
          } else {
            Utils.showError(imageResponse['message'] ?? "Failed to upload image");
            return;
          }
        } catch (e) {
          AppLog.error("Image upload error: $e");
          Utils.showError("Failed to upload image: $e");
          return;
        }
      }

      // Update profile
      final response = await ApiHelper.post(
        'update_student.php',
        body: data,
      );

      AppLog.response(response);

      if (response['status'] == true) {
        // Update local student data
        final responseData = response['data'] as Map<String, dynamic>;

        final updatedStudent = StudentModel(
          id: student.value.id,
          name: responseData['name'] ?? name,
          email: responseData['email'] ?? email,
          mobile: responseData['mobile'] ?? mobile,
          className: responseData['class_name'] ?? student.value.className,
          classId: responseData['class_id'] ?? student.value.classId,
          photo: responseData['photo'] ?? student.value.photo,
          status: responseData['status'] ?? student.value.status,
          createdAt: responseData['created_at'] ?? student.value.createdAt,
        );

        student.value = updatedStudent;
        await LocalStorage.saveStudent(student.value.toJson());

        // Show success only once
        Utils.showSuccess("Profile updated successfully! 🎉");

        // Wait a moment before navigating back
        await Future.delayed(const Duration(milliseconds: 500));
        Get.back(); // Go back to profile screen
      } else {
        Utils.showError(response['message'] ?? "Failed to update profile");
      }
    } catch (e) {
      AppLog.error("Update Profile Error: $e");
      Utils.showError("Error updating profile: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // ================= OTHER FUNCTIONS =================

  void clearRegisterFields() {
    nameController.clear();
    contactController.clear();
    emailController.clear();
    registerPasswordController.clear();
  }

  void openRegisterScreen() {
    Get.toNamed(AppRoutes.register);
  }

  @override
  void onClose() {
    loginController.dispose();
    passwordController.dispose();
    nameController.dispose();
    contactController.dispose();
    emailController.dispose();
    registerPasswordController.dispose();
    super.onClose();
  }
}