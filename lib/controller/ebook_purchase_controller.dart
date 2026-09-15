import 'package:always_victory/constants/app_strings.dart';
import 'package:always_victory/controller/class_controller.dart';
import 'package:get/get.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../data/api_services/api_service.dart';
import '../data/app_config/app_config.dart';
import '../helpers/utils.dart';
import '../models/ebook_model.dart';

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

  void startPayment() {
    if (selectedBook.value == null) return;

    var options = {
      'key': AppStrings.razorPayApiKey,
      'amount': (selectedBook.value!.price * 100).toInt(),
      'name': AppConfig.appName,
      'description': selectedBook.value!.title,
    };

    try {
      razorpay.open(options);
    } catch (e) {
      Utils.showError(e.toString());
    }
  }

  Future<void> handlePaymentSuccess(
    PaymentSuccessResponse response,
  ) async {
    await ApiServices.buyEbook(
      ebookId: selectedBook.value!.id,
      amount: selectedBook.value!.price,
      transactionId: response.paymentId ?? "",
    );
    await ClassController.instance.loadPurchasedBooks();

    Utils.showSuccess("Book Purchased Successfully 📚🎉");
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
