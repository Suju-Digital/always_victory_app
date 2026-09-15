import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_constants.dart';
import '../../constants/app_text_styles.dart';
import 'widgets/policy_section.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(
          "Privacy Policy",
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
                color: AppColors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.privacy_tip_rounded,
                size: 48,
                color: AppColors.primary,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: Text(
              "Your Privacy Matters",
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
            icon: Icons.person_search_rounded,
            title: "Information We Collect",
            content: "We may collect your name, email address, mobile number, profile information, subscription details and learning progress to provide a personalized experience.",
          ),
          const PolicySection(
            icon: Icons.shield_rounded,
            title: "Data Security",
            content: "We use industry-standard security practices to protect your personal information. Your data is encrypted and stored securely.",
          ),
          const PolicySection(
            icon: Icons.auto_awesome_rounded,
            title: "Educational Services",
            content: "Your information is used to provide MCQ practice, PDF eBooks, subscription management and track your learning achievements.",
          ),
          const PolicySection(
            icon: Icons.share_location_rounded,
            title: "Sharing Information",
            content: "We never sell your personal information. Data is only shared with trusted payment providers or when required by law.",
          ),
          const PolicySection(
            icon: Icons.no_accounts_rounded,
            title: "Your Rights",
            content: "You have full control over your data. You may request correction, deletion or access to your information at any time.",
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
              "Thank you for trusting Always Victory. ❤️",
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
