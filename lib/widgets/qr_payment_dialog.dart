import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../constants/app_strings.dart';
import '../controller/class_controller.dart';
import '../data/api_services/api_service.dart';
import '../data/app_config/app_config.dart';
import '../helpers/debug_loger.dart';
import '../helpers/utils.dart';
import '../models/class_model.dart';
import '../models/ebook_model.dart';
import '../models/student_model.dart';

class QRPaymentDialog extends StatefulWidget {
  final int productId;
  final String title;
  final double amount;
  final StudentModel student;
  final String type; // 'course' or 'ebook'

  // Constructor for Class / Course
  QRPaymentDialog({
    super.key,
    ClassModel? course,
    int? productId,
    String? title,
    double? amount,
    required this.student,
    this.type = 'course',
  })  : productId = productId ?? course?.id ?? 0,
        title = title ?? course?.title ?? 'Course',
        amount = amount ?? course?.finalPrice ?? 0.0;

  // Constructor for E-Book
  QRPaymentDialog.forEbook({
    super.key,
    required EbookModel ebook,
    required this.student,
  })  : productId = ebook.id,
        title = ebook.title,
        amount = ebook.price,
        type = 'ebook';

  @override
  State<QRPaymentDialog> createState() => _QRPaymentDialogState();
}

class _QRPaymentDialogState extends State<QRPaymentDialog> {
  bool isLoading = true;
  String? qrId;
  String? qrImageUrl;
  String error = '';

  Timer? _pollingTimer;
  bool paymentSuccess = false;
  int pollingAttempts = 0;
  final int maxPollingAttempts = 80; // ~4 minutes

  late Razorpay _razorpay;

  @override
  void initState() {
    super.initState();
    _initRazorpay();
    _generateQR();
  }

  void _initRazorpay() {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handleRazorpaySuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handleRazorpayError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  Future<void> _generateQR() async {
    try {
      setState(() {
        isLoading = true;
        error = '';
      });

      final studentId = int.tryParse(widget.student.id ?? '') ?? 0;

      final res = await ApiServices.createQrPayment(
        studentId: studentId,
        classId: widget.productId,
        amount: widget.amount,
        type: widget.type,
      );

      final isSuccess = res['status'] == true || res['success'] == true;

      if (isSuccess && res['image_url'] != null) {
        if (!mounted) return;
        setState(() {
          qrId = res['qr_id']?.toString();
          qrImageUrl = res['image_url']?.toString();
          isLoading = false;
        });
        _startPolling();
      } else {
        if (!mounted) return;
        setState(() {
          error = res['message']?.toString() ?? 'Unable to generate Razorpay QR code';
          isLoading = false;
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  void _startPolling() {
    _pollingTimer?.cancel();
    _pollingTimer = Timer.periodic(const Duration(seconds: 3), (timer) async {
      pollingAttempts++;
      if (pollingAttempts > maxPollingAttempts) {
        timer.cancel();
        if (mounted) {
          setState(() {
            error = 'Payment timeout. If paid, your item will unlock shortly.';
          });
        }
        return;
      }

      final studentId = int.tryParse(widget.student.id ?? '') ?? 0;

      final isSuccess = await ApiServices.checkPaymentStatus(
        qrId: qrId,
        studentId: studentId,
        classId: widget.productId,
        type: widget.type,
      );

      if (isSuccess) {
        timer.cancel();
        _pollingTimer = null;
        _markItemUnlockedLocally();

        if (mounted) {
          setState(() {
            paymentSuccess = true;
          });
          Future.delayed(const Duration(milliseconds: 400), () {
            if (mounted) Navigator.of(context).pop(true);
          });
        }
      }
    });
  }

  void _openRazorpayCheckout() {
    // 🛑 Cancel QR background polling while user is actively paying via Razorpay/UPI gateway
    _pollingTimer?.cancel();
    _pollingTimer = null;

    final studentMobile = (widget.student.mobile ?? '').trim();
    final studentEmail = (widget.student.email ?? '').trim();
    final amountPaise = (widget.amount * 100).toInt();

    AppLog.info("Launching Razorpay with key: ${AppStrings.razorPayApiKey}, amount: $amountPaise");

    final Map<String, dynamic> options = {
      'key': AppStrings.razorPayApiKey,
      'amount': amountPaise,
      'name': AppConfig.appName,
      'currency': 'INR',
      'description': "Payment for ${widget.title}",
      'theme': {
        'color': '#FF5722',
      },
      'prefill': {
        'contact': studentMobile.isNotEmpty ? studentMobile : '',
        'email': studentEmail.isNotEmpty ? studentEmail : '',
      },
      'notes': {
        'student_id': widget.student.id ?? '0',
        'product_id': widget.productId.toString(),
        'type': widget.type,
      }
    };

    AppLog.info("Full Razorpay Options: $options");

    try {
      _razorpay.open(options);
    } catch (e, s) {
      AppLog.error("Razorpay open error: $e");
      AppLog.error(s.toString());
      Get.defaultDialog(
        title: "Razorpay Crash",
        middleText: "Exception during _razorpay.open: $e",
        textConfirm: "OK",
        onConfirm: () => Get.back(),
      );
      Utils.showError("Could not launch payment gateway: $e");
    }
  }

  void _handleRazorpaySuccess(PaymentSuccessResponse response) async {
    _pollingTimer?.cancel();
    _pollingTimer = null;

    // ⚡ 1. INSTANT OPTIMISTIC UNLOCK: Immediately unlock UI in memory and local storage
    _markItemUnlockedLocally();

    if (mounted) {
      setState(() {
        paymentSuccess = true;
      });
    }

    final studentId = int.tryParse(widget.student.id ?? '') ?? 0;
    final paymentId = response.paymentId ?? '';

    // ⚡ 2. Close dialog after 400ms so user doesn't wait
    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) Navigator.of(context).pop(true);
    });

    // ⚡ 3. Fire-and-forget sync to backend in background (won't block UI)
    try {
      if (widget.type == 'ebook') {
        ApiServices.recordEbookPaymentSuccess(
          studentId: studentId,
          ebookId: widget.productId,
          amount: widget.amount,
          paymentId: paymentId,
        );
      } else {
        ClassController.instance.paymentSuccess(
          studentId: studentId,
          classId: widget.productId,
          amount: widget.amount,
          paymentId: paymentId,
        );
      }
    } catch (_) {}
  }

  void _handleRazorpayError(PaymentFailureResponse response) {
    AppLog.error("🔴 RAZORPAY FAILURE CODE: ${response.code}");
    AppLog.error("🔴 RAZORPAY FAILURE MESSAGE: ${response.message}");

    // Resume QR polling if user cancels or fails payment
    if (!paymentSuccess && mounted) {
      _startPolling();
    }

    Utils.showError(response.message ?? "Payment Canceled");
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Utils.showInfo(response.walletName ?? 'Wallet');
  }

  void _markItemUnlockedLocally() {
    final classController = Get.find<ClassController>();
    if (widget.type == 'ebook') {
      classController.purchasedBooks[widget.productId] = true;
      classController.purchasedBooks.refresh();
      classController.loadPurchasedBooks();
    } else {
      classController.purchaseClass[widget.productId] = true;
      classController.purchaseClass.refresh();
      classController.loadPurchaseClass();
    }
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    _razorpay.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final formattedAmount = widget.amount.toInt() == widget.amount
        ? widget.amount.toInt().toString()
        : widget.amount.toStringAsFixed(1);

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 390),
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 1. Header (Pay ₹amount & Razorpay Dynamic UPI QR)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Pay ₹$formattedAmount",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w800,
                          fontSize: 24,
                          color: const Color(0xFF0F172A),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        "Razorpay Dynamic UPI QR",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500,
                          fontSize: 13,
                          color: const Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    icon: const Icon(
                      Icons.close_rounded,
                      color: Color(0xFF94A3B8),
                      size: 26,
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // 2. Blue Bordered QR Container
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: const Color(0xFF6366F1), // Royal Indigo / Blue Border
                    width: 2.2,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (isLoading)
                      const SizedBox(
                        height: 250,
                        child: Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFF6366F1),
                            strokeWidth: 3,
                          ),
                        ),
                      )
                    else if (paymentSuccess)
                      SizedBox(
                        height: 250,
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.check_circle_rounded,
                                color: Color(0xFF10B981),
                                size: 72,
                              ),
                              const SizedBox(height: 14),
                              Text(
                                "Payment Successful! 🎉",
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF10B981),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                "Unlocking your content now...",
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  color: const Color(0xFF64748B),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    else if (error.isNotEmpty)
                      SizedBox(
                        height: 250,
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.error_outline_rounded,
                                  color: Colors.redAccent,
                                  size: 48,
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  error,
                                  style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.redAccent,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 14),
                                ElevatedButton.icon(
                                  onPressed: _generateQR,
                                  icon: const Icon(Icons.refresh_rounded, size: 16),
                                  label: const Text("Retry"),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF6366F1),
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    else if (qrImageUrl != null)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          qrImageUrl!,
                          height: 255,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          loadingBuilder: (_, child, progress) {
                            if (progress == null) return child;
                            return const SizedBox(
                              height: 255,
                              child: Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Color(0xFF6366F1),
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                    const SizedBox(height: 12),

                    // UPI App Badges Row (GPay, PhonePe, Paytm, BHIM)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildUpiPill("GPay", const Color(0xFF2563EB)),
                        const SizedBox(width: 5),
                        _buildUpiPill("PhonePe", const Color(0xFF7C3AED)),
                        const SizedBox(width: 5),
                        _buildUpiPill("Paytm", const Color(0xFF0284C7)),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              // 3. QR ID Badge
              if (qrId != null && qrId!.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    "QR ID:  $qrId",
                    style: GoogleFonts.sourceCodePro(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF475569),
                    ),
                  ),
                ),

              const SizedBox(height: 14),

              // 4. Waiting for payment status pill
              if (!paymentSuccess && error.isEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEEF2FF),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.2,
                          valueColor: AlwaysStoppedAnimation(Color(0xFF4F46E5)),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        "Waiting for payment...",
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF4F46E5),
                        ),
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: 18),

              // 5. Red CTA Button ("🚀 Pay via Razorpay / UPI 🚀")
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: _openRazorpayCheckout,
                  borderRadius: BorderRadius.circular(16),
                  child: Ink(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFFFF5252),
                          Color(0xFFFF5722),
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFFF5722).withValues(alpha: 0.38),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("🚀", style: TextStyle(fontSize: 15)),
                        const SizedBox(width: 8),
                        Text(
                          "Pay via Razorpay / UPI",
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            letterSpacing: 0.6,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text("🚀", style: TextStyle(fontSize: 15)),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // 6. Outlined Cancel Button
              OutlinedButton(
                onPressed: () => Navigator.of(context).pop(false),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                  side: BorderSide(color: Colors.grey.shade300, width: 1.3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Text(
                  "Cancel",
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF0F172A),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUpiPill(String name, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: color.withValues(alpha: 0.35),
          width: 1.2,
        ),
      ),
      child: Text(
        name,
        style: GoogleFonts.poppins(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }
}
