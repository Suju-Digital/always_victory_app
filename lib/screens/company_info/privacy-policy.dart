import 'package:always_victory/constants/app_colors.dart';
import 'package:always_victory/screens/company_info/widgets/policy_section.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF8FAFC),
      appBar: AppBar(
        title: const Text(
          "Privacy Policy",
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
                color: Colors.blue.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.privacy_tip_rounded,
                size: 60,
                color: Colors.blue,
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Center(
            child: Text(
              "Your Privacy Matters",
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
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.05),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Center(
              child: Text(
                "Thank you for trusting Always Victory. ❤️",
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