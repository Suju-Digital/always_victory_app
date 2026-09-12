import 'package:always_victory/data/controller_binding/buy_course_binding.dart';
import 'package:always_victory/screens/auth/login_screen.dart';
import 'package:always_victory/screens/auth/register_screen.dart';
import 'package:always_victory/screens/bottom_nav/bottom_navigation_screen.dart';
import 'package:always_victory/screens/course_list/course_list.dart';
import 'package:always_victory/screens/days_list/days_screen.dart';
import 'package:always_victory/screens/demo_test/demo_question_screen.dart';
import 'package:always_victory/screens/demo_test/demo_success_screen.dart';
import 'package:always_victory/screens/profile_screen/edit_profile.dart';
import 'package:always_victory/screens/profile_screen/profile_info_screen.dart';
import 'package:always_victory/screens/progress_screen/progress_report_screen.dart';
import 'package:always_victory/screens/purchase/buy_class_screen.dart';
import 'package:always_victory/screens/quiz/quiz_screen.dart';
import 'package:always_victory/screens/result/result_screen.dart';
import 'package:always_victory/screens/splash/splash_screen.dart';
import 'package:get/get.dart';

import '../data/controller_binding/bottom_navigation_binding.dart';
import '../data/controller_binding/home_binding.dart';
import '../data/controller_binding/onboarding_binding.dart';
import '../data/controller_binding/profile_binding.dart';
import '../data/controller_binding/progress_report_binding.dart';
import '../screens/company_info/about_company.dart';
import '../screens/company_info/contact_us.dart';
import '../screens/company_info/privacy-policy.dart';
import '../screens/company_info/terms_conditions.dart';
import '../screens/home/home_screen.dart';
import '../screens/onBoard/onboarding_view.dart';
import '../screens/profile_screen/profile_screen.dart';
import 'app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashScreen(),
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => HomeScreen(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: AppRoutes.onboarding,
      page: () => const OnboardingView(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: AppRoutes.demoTest,
      page: () => DemoQuestionScreen(),
    ),
    GetPage(
      name: AppRoutes.demoResult,
      page: () => DemoResultScreen(),
    ),
    GetPage(
      name: AppRoutes.days,
      page: () => DayScreen(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: AppRoutes.quiz,
      page: () => QuizScreen(),
    ),
    GetPage(
      name: AppRoutes.result,
      page: () => ResultScreen(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => StudentLoginScreen(),
    ),
    GetPage(
      name: AppRoutes.register,
      page: () => RegisterScreen(),
    ),
    GetPage(
      name: AppRoutes.courses,
      page: () => const MyPurchasesScreen(),
    ),
    GetPage(
      name: AppRoutes.profile,
      page: () => const ProfileScreen(),
    ),
    GetPage(
      name: AppRoutes.bottomNav,
      page: () => const BottomNavigationScreen(),
      binding: BottomNavBinding(),
    ),
    GetPage(
      name: AppRoutes.progress,
      page: () => ProgressReportScreen(),
      binding: ProgressBinding(),
    ),
    GetPage(
      name: AppRoutes.profileInfo,
      page: () => StudentProfileInfoScreen(),
    ),
    GetPage(
      name: AppRoutes.aboutCompany,
      page: () => AboutCompanyScreen(),
    ),
    GetPage(
      name: AppRoutes.privacyPolicy,
      page: () => const PrivacyPolicyScreen(),
    ),
    GetPage(
      name: AppRoutes.termsCondition,
      page: () => const TermsConditionScreen(),
    ),
    GetPage(
      name: AppRoutes.contactUs,
      page: () => ContactUsScreen(),
    ),
    GetPage(
      name: AppRoutes.editProfile,
      page: () => const EditProfileScreen(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: AppRoutes.purchase,
      page: () => const BuyClassScreen(),
      binding: BuyCourseBinding(),
    ),
  ];
}
