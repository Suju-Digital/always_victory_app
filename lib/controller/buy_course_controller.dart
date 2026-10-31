import 'package:always_victory/controller/class_controller.dart';
import 'package:always_victory/data/app_config/app_config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../data/api_services/api_service.dart';
import '../../models/class_model.dart';
import '../constants/app_strings.dart';
import '../helpers/local_storage.dart';
import '../helpers/utils.dart';
import '../models/student_model.dart';

class BuyCourseController extends GetxController {
  static BuyCourseController get instance => Get.find();
  final selectedClass = Rxn<ClassModel>();
  late var enrollStudents = 0.obs;

  late Razorpay razorpay;

  @override
  void onInit() {
    super.onInit();
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

  void startPayment() async {
    if (selectedClass.value == null) return;

    final studentJson = await LocalStorage.getStudent();
    if (studentJson == null) {
      Utils.showError("Please login to continue");
      return;
    }
    
    final student = StudentModel.fromJson(studentJson);

    Utils.showLoading(message: "Initializing Payment...");
    
    try {
      // 1. Create order on server
      final res = await ApiServices.createOrder(
        studentId: int.parse(student.id!),
        classId: selectedClass.value!.id,
        amount: selectedClass.value!.finalPrice,
      );
      
      Utils.hide();

      if (res['status'] == true && res['order_id'] != null) {
        var options = {
          'key': AppStrings.razorPayApiKey,
          'amount': (selectedClass.value!.finalPrice * 100).toInt(),
          'name': AppConfig.appName,
          'description': selectedClass.value!.title,
          'order_id': res['order_id'], // CRITICAL: Server generated Order ID
          'prefill': {
            'contact': student.mobile ?? '',
            'email': student.email ?? '',
          }
        };
        razorpay.open(options);
      } else {
        Utils.showError(res['message'] ?? 'Could not initialize payment');
      }
    } catch (e) {
      Utils.hide();
      Utils.showError(e.toString());
    }
  }

  void handlePaymentSuccess(
    PaymentSuccessResponse response,
  ) async {
    Utils.showLoading(message: "Verifying Payment...");
    
    // 2. Verify on server
    final success = await ApiServices.verifyPaymentServerSide(
      orderId: response.orderId ?? '',
      paymentId: response.paymentId ?? '',
      signature: response.signature ?? '',
    );

    Utils.hide();

    if (success) {
      final classController = Get.find<ClassController>();
      classController.purchaseClass[selectedClass.value!.id] = true;
      classController.purchaseClass.refresh();
      Utils.showSuccess("Course Purchased Successfully 🎉");
      Navigator.of(Get.context!).pop(true);
    } else {
      Utils.showError("Payment verification failed on server 😅");
    }
  }

  void handlePaymentError(
    PaymentFailureResponse response,
  ) {
    Utils.showError(response.message ?? 'Payment Failed 😅');
  }

  void handleExternalWallet(
    ExternalWalletResponse response,
  ) {
    Utils.showInfo(response.walletName ?? 'Wallet');
  }

  @override
  void onClose() {
    razorpay.clear();
    super.onClose();
  }
}
