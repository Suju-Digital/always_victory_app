import 'package:always_victory/controller/class_controller.dart';
import 'package:always_victory/data/app_config/app_config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../../models/class_model.dart';
import '../constants/app_strings.dart';
import '../data/api_services/api_service.dart';
import '../helpers/local_storage.dart';
import '../models/student_model.dart';

class BuyCourseController extends GetxController {
  static BuyCourseController get instance => Get.find();
  final selectedClass = Rxn<ClassModel>();
  late var enrollStudents = 0.obs;

  late Razorpay razorpay;

  @override
  void onInit() {
    super.onInit();
    print("Razorpay initlize");
    print("Arguments Type => ${Get.arguments.runtimeType}");
    print("Arguments => ${Get.arguments}");
    final args = Get.arguments as Map<String, dynamic>;
    selectedClass.value = args["ClassModel"];
     enrollStudents.value = args["EnrollStudent"] as int;


    razorpay = Razorpay();

    razorpay.on(
      Razorpay.EVENT_PAYMENT_SUCCESS,
      handlePaymentSuccess,
    );

    razorpay.on(
      Razorpay.EVENT_PAYMENT_ERROR,
      handlePaymentError,
    );

    razorpay.on(
      Razorpay.EVENT_EXTERNAL_WALLET,
      handleExternalWallet,
    );
  }

  void setClass(ClassModel classModel) {
    selectedClass.value = classModel;
  }

  void startPayment() {
    if (selectedClass.value == null) return;

    var options = {
      'key': AppStrings.razorPayApiKey,
      'amount': (selectedClass.value!.finalPrice * 100).toInt(),
      'name': AppConfig.appName,
      'description': selectedClass.value!.title,

    };

    try {
      razorpay.open(options);
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void handlePaymentSuccess(
      PaymentSuccessResponse response,
      ) async {

    final student = await LocalStorage.getStudent();

    if(student==null) return;

    final model = StudentModel.fromJson(student);

    final success = await ClassController.instance.paymentSuccess(

      studentId: int.parse(model.id!),

      classId: selectedClass.value!.id,

      amount: selectedClass.value!.finalPrice,

      paymentId: response.paymentId!,

    );

    if(success){
      final classController = Get.find<ClassController>();

      classController.purchaseClass[selectedClass.value!.id] = true;
      classController.purchaseClass.refresh();
      Get.snackbar(
        "Success",
        "Course Purchased Successfully",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      Navigator.of(Get.context!).pop(true);

    }else{

      Get.snackbar(
        "Error",
        "Enrollment Failed",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );

    }

  }

  void handlePaymentError(
      PaymentFailureResponse response,
      ) {
    Get.snackbar(
      'Failed',
      response.message ?? 'Payment Failed',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void handleExternalWallet(
      ExternalWalletResponse response,
      ) {
    Get.snackbar(
      'Wallet',
      response.walletName ?? '',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  @override
  void onClose() {
    razorpay.clear();
    super.onClose();
  }
}