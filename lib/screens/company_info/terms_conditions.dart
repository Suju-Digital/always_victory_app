import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_constants.dart';
import '../../constants/app_text_styles.dart';
import 'widgets/policy_section.dart';

class TermsConditionScreen extends StatelessWidget {
  const TermsConditionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(
          "Terms & Conditions",
          style: AppTextStyles.appBarTitle.copyWith(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: AppColors.appGradient,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
          onPressed: () => Get.back(),
        ),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(AppConstants.paddingMD),
        children: [
          Center(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF3CD),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.gavel_rounded,
                size: 48,
                color: Color(0xFFD84315),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: Text(
              "Terms of Service",
              style: AppTextStyles.h2,
            ),
          ),
          const SizedBox(height: 4),
          Center(
            child: Text(
              "Last Updated: January 2026",
              style: AppTextStyles.caption,
            ),
          ),
          const SizedBox(height: 24),
          const PolicySection(
            icon: Icons.check_circle_rounded,
            title: "Acceptance",
            content: "By using this application you agree to be bound by these Terms & Conditions. If you disagree with any part, you may not access our services.",
          ),
          const PolicySection(
            icon: Icons.workspace_premium_rounded,
            title: "Subscription",
            content: "Premium MCQs and PDF eBooks are available only with an active subscription. Access remains valid for the duration of the purchased period.",
          ),
          const PolicySection(
            icon: Icons.account_balance_wallet_rounded,
            title: "Payments",
            content: "All payments are processed securely through authorized payment gateways. Subscriptions are non-refundable except as required by law.",
          ),
          const PolicySection(
            icon: Icons.copyright_rounded,
            title: "Copyright",
            content: "All educational content including MCQs, eBooks, and logos belong to Always Victory. Unauthorized redistribution is strictly prohibited.",
          ),
          const PolicySection(
            icon: Icons.block_flipped,
            title: "Account Use",
            content: "Accounts involved in misuse, copyright violation, or sharing login credentials may be suspended without notice.",
          ),
          const PolicySection(
            icon: Icons.update_rounded,
            title: "Changes",
            content: "We reserve the right to update these terms. Continued use of the app after changes implies acceptance of the new Terms.",
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.15),
              ),
            ),
            child: Text(
              "Thank you for being part of Always Victory. 🚀",
              textAlign: TextAlign.center,
              style: AppTextStyles.labelLarge.copyWith(
                color: AppColors.primary,
              ),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
