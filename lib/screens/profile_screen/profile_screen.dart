import 'package:always_victory/constants/app_colors.dart';
import 'package:always_victory/controller/auth_controller.dart';
import 'package:always_victory/controller/days_controller.dart';
import 'package:always_victory/helpers/local_storage.dart';
import 'package:always_victory/helpers/utils.dart';
import 'package:always_victory/routes/app_routes.dart';
import 'package:always_victory/widgets/review_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

import '../../data/app_config/app_config.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AuthController>();
    final dayController = Get.find<DayController>();

    return Scaffold(
      backgroundColor: const Color(0xffF5F7FB),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [

              /// Header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius:
                  BorderRadius.circular(20),
                  gradient: AppColors.appGradient,
                ),
                child: Column(
                  children: [

                    Obx(() {
                      final student = controller.student.value;
                      print("${AppConfig.imageBaseUrl}${student.photo??""}");
                      return CircleAvatar(

                        radius: 50,
                        backgroundColor: Colors.white,
                        backgroundImage:
                        student.photo != null &&
                            student.photo!.isNotEmpty
                            ? NetworkImage("${AppConfig.studentProfileImageBaseUrl}${student.photo??""}")
                            : null,
                        child:
                        student.photo == null ||
                            student.photo!.isEmpty
                            ? const Icon(
                          Icons.person,
                          size: 50,
                          color: AppColors.primary,
                        )
                            : null,
                      );
                    }),

                    const SizedBox(height: 12),

                    Obx(
                      ()=>  Text(
                        controller.student.value.name??"No Name",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight:
                          FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),

                    const SizedBox(height: 5),

                     Obx(
                       ()=> Text(
                        "Class ${controller.student.value.className??""}",
                        style: const TextStyle(
                          color: Colors.white70,
                        ),
                                           ),
                     ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              /// Student Section
              _sectionTitle("Student"),

              _menuTile(
                Icons.person_outline,
                "My Profile",
                    () =>Get.toNamed(AppRoutes.profileInfo),
              ),


              const SizedBox(height: 15),

              /// App Section
              _sectionTitle("Application"),


              _menuTile(
                Icons.business_outlined,
                "About Company",
                    () =>Get.toNamed(AppRoutes.aboutCompany),
              ),

              _menuTile(
                Icons.privacy_tip_outlined,
                "Privacy Policy",
                    () =>Get.toNamed(AppRoutes.privacyPolicy),
              ),

              _menuTile(
                Icons.description_outlined,
                "Terms & Conditions",
                    () =>Get.toNamed(AppRoutes.termsCondition),
              ),

              const SizedBox(height: 15),

              /// Support
              _sectionTitle("Support"),

              _menuTile(
                Icons.call_outlined,
                "Contact Us",
                    ()=>Get.toNamed(AppRoutes.contactUs),
              ),

              _menuTile(
                Icons.star_outline_rounded,
                "Write a Review",
                () => ReviewDialog.show(context),
              ),

              _menuTile(
                Icons.share_outlined,
                "Share App",
                () {
                  Share.share(
                    "Download Always Victory App:\nhttps://play.google.com/store/apps/details?id=com.alwaysvictory.app",
                  );
                },
              ),



              const SizedBox(height: 25),

              /// Logout
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton.icon(
                  onPressed: () {

                    Get.defaultDialog(
                      title: "Logout",
                      middleText:
                      "Are you sure you want to logout?",
                      textConfirm: "Yes",
                      textCancel: "No",
                      onConfirm: () async{
                        Get.back();
                       Utils.showLoading(message: "Loging Out....");
                          await  LocalStorage.clear();
                          Utils.hide();
                        Get.offAllNamed(
                          AppRoutes.login,
                        );
                      },
                    );
                  },
                  icon: const Icon(Icons.logout),
                  label: const Text(
                    "Logout",
                  ),
                  style:
                  ElevatedButton.styleFrom(
                    backgroundColor:
                    Colors.red,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Text(
                dayController.aboutData.value?.appName??"",
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 5),

              Text(
                "Version ${dayController.aboutData.value?.appVersion??""}",
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _sectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding:
        const EdgeInsets.only(bottom: 10),
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  static Widget _menuTile(
      IconData icon,
      String title,
      VoidCallback onTap,
      ) {
    return Card(
      elevation: 0,
      margin:
      const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(
        borderRadius:
        BorderRadius.circular(15),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: AppColors.primary,
        ),
        title: Text(title),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
        ),
        onTap: onTap,
      ),
    );
  }
}