import 'package:always_victory/constants/app_colors.dart';
import 'package:always_victory/screens/company_info/widgets/policy_section.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TermsConditionScreen extends StatelessWidget {
  const TermsConditionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF8FAFC),
      appBar: AppBar(
        title: const Text(
          "Terms & Conditions",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: AppColors.appGradient,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
          onPressed: () => Get.back(),
        ),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(20),
        children: [
          Center(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.gavel_rounded,
                size: 60,
                color: Colors.orange,
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Center(
            child: Text(
              "Terms of Service",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                color: AppColors.textDark,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Center(
            child: Text(
              "Last Updated: January 2026",
              style: TextStyle(
                color: AppColors.textGrey.withOpacity(0.6),
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
          const SizedBox(height: 32),
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
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.05),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Center(
              child: Text(
                "Thank you for being part of Always Victory. 🚀",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}