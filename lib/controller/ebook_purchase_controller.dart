import 'package:always_victory/constants/app_strings.dart';
import 'package:always_victory/controller/class_controller.dart';
import 'package:get/get.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../data/api_services/api_service.dart';
import '../data/app_config/app_config.dart';
import '../helpers/local_storage.dart';
import '../helpers/utils.dart';
import '../models/ebook_model.dart';
import '../models/student_model.dart';

class BuyEbookController extends GetxController {
  static BuyEbookController get instance => Get.find();

  final selectedBook = Rxn<EbookModel>();

  late Razorpay razorpay;

  @override
  void onInit() {
    super.onInit();

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

  void startPayment() async {
    if (selectedBook.value == null) return;

    final studentJson = await LocalStorage.getStudent();
    if (studentJson == null) {
      Utils.showError("Please login to continue");
      return;
    }
    
    final student = StudentModel.fromJson(studentJson);

    Utils.showLoading(message: "Initializing Payment...");
    
    try {
      final res = await ApiServices.createOrder(
        studentId: int.parse(student.id!),
        classId: selectedBook.value!.id, // We reuse classId for itemId here in this snippet
        amount: selectedBook.value!.price,
      );
      
      Utils.hide();

      if (res['status'] == true && res['order_id'] != null) {
        var options = {
          'key': AppStrings.razorPayApiKey,
          'amount': (selectedBook.value!.price * 100).toInt(),
          'name': AppConfig.appName,
          'description': selectedBook.value!.title,
          'order_id': res['order_id'],
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

  Future<void> handlePaymentSuccess(
    PaymentSuccessResponse response,
  ) async {
    Utils.showLoading(message: "Verifying Payment...");
    
    final success = await ApiServices.verifyPaymentServerSide(
      orderId: response.orderId ?? '',
      paymentId: response.paymentId ?? '',
      signature: response.signature ?? '',
    );

    Utils.hide();

    if (success) {
      // Refresh purchased books
      await ClassController.instance.loadPurchasedBooks();
      Utils.showSuccess("Book Purchased Successfully 📚🎉");
    } else {
      Utils.showError("Payment verification failed on server 😅");
    }
  }

  void handlePaymentError(PaymentFailureResponse response) {
    Utils.showError(response.message ?? 'Payment Failed 😅');
  }

  void handleExternalWallet(ExternalWalletResponse response) {
    Utils.showInfo(response.walletName ?? 'Wallet');
  }

  @override
  void onClose() {
    razorpay.clear();
    super.onClose();
  }
}
