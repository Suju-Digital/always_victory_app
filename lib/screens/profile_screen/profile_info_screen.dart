import 'package:always_victory/constants/app_colors.dart';
import 'package:always_victory/controller/auth_controller.dart';
import 'package:always_victory/data/app_config/app_config.dart';
import 'package:always_victory/helpers/debug_loger.dart';
import 'package:always_victory/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';


class StudentProfileInfoScreen extends StatelessWidget {
  const StudentProfileInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AuthController>();
    AppLog.response(controller.student.toJson());
    return Scaffold(
      backgroundColor: const Color(0xffF5F7FB),

      appBar: AppBar(
      title: const Text("My Profile",style: TextStyle(color: Colors.white),),
      centerTitle: true,
      backgroundColor: AppColors.primary,
      automaticallyImplyLeading: false,
    ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            /// Profile Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                borderRadius:
                BorderRadius.circular(20),
                gradient: AppColors.appGradient,
              ),
              child: Column(
                children:  [

                  Obx(() {
                    final student = controller.student.value;
                    print("student image  :${AppConfig.studentProfileImageBaseUrl}${student.photo??""}");
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
                        color: Colors.blue,
                      )
                          : null,
                    );
                  }),

                  SizedBox(height: 15),

                  Obx(
                    ()=> Text(
                      controller.student.value.name??"",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight:
                        FontWeight.bold,
                      ),
                    ),
                  ),

                  SizedBox(height: 5),

                  Obx(
                    ()=> Text(
                      "Class ${controller.student.value.className}",
                      style: TextStyle(
                        color:
                        Colors.white70,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// Information Card
            Card(
              shape:
              RoundedRectangleBorder(
                borderRadius:
                BorderRadius.circular(
                    20),
              ),
              child: Padding(
                padding:
                const EdgeInsets.all(
                    16),
                child: Obx(
                  ()=> Column(
                    children: [

                      _infoTile(
                        Icons.badge_outlined,
                        "Student ID",
                        controller.student.value.id??"",
                      ),

                      const Divider(),

                      _infoTile(
                        Icons.person,
                        "Full Name",
                        controller.student.value.name??"",
                      ),

                      const Divider(),

                      _infoTile(
                        Icons.school,
                        "Class",
                        controller.student.value.className??"",
                      ),

                      const Divider(),

                      _infoTile(
                        Icons.phone,
                        "Contact",
                        controller.student.value.mobile??"",
                      ),

                      const Divider(),

                      _infoTile(
                        Icons.email,
                        "Email",
                        controller.student.value.email??"",
                      ),

                      const Divider(),

                      _infoTile(
                        Icons.calendar_month,
                        "Admission Date",
                        controller.student.value.createdAt??"",
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// Edit Button
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                onPressed: () => Get.toNamed(AppRoutes.editProfile),
                icon:
                const Icon(Icons.edit),
                label: const Text(
                  "Edit Profile",
                ),
              ),
            ),
            const SizedBox(height: 20),

          ],
        ),
      ),
    );
  }

  static Widget _infoTile(
      IconData icon,
      String title,
      String value,
      ) {
    return ListTile(
      contentPadding:
      EdgeInsets.zero,
      leading: Icon(
        icon,
        color: const Color(
            0xff4A90E2),
      ),
      title: Text(title),
      subtitle: Text(
        value,
        style: const TextStyle(
          fontSize: 16,
          fontWeight:
          FontWeight.w600,
        ),
      ),
    );
  }

  static Widget _statCard(
      String title,
      String value,
      Color color,
      ) {
    return Container(
      padding:
      const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withOpacity(
            0.1),
        borderRadius:
        BorderRadius.circular(
            15),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              color: color,
              fontWeight:
              FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          Text(title),
        ],
      ),
    );
  }
}