import 'package:always_victory/data/app_config/app_config.dart';
import 'package:always_victory/helpers/utils.dart';
import 'package:always_victory/models/day_model.dart';
import 'package:always_victory/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/days_controller.dart';
import '../../controller/question_controller.dart';
import '../../models/class_model.dart';
import '../../widgets/days_list_tile.dart';

class DayScreen extends StatelessWidget {
  final controller = Get.find<DayController>();

  // 🔥 GET CLASS DATA
  final ClassModel classData = Get.arguments;

  DayScreen({super.key});

  bool get isLocked => classData.finalPrice > 0;


  @override
  Widget build(BuildContext context) {
    final QuestionController questionController = Get.find<QuestionController>();

    return Scaffold(
        body: Obx(() {
          if (controller.days.isEmpty) {
            return const Center(child: Text("No Days Found"));
          }

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                /// 🔥 TOP IMAGE WITH OVERLAY
                Stack(
                  children: [
                    Image.network(
                     "${AppConfig.studentImageBaseUrl}${ classData.posterImage}",
                      height: 220,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),

                    /// DARK OVERLAY (🔥 makes text readable)
                    Container(
                      height: 220,
                      color: Colors.black.withOpacity(0.3),
                    ),

                    /// TEXT ON IMAGE
                    Positioned(
                      bottom: 16,
                      left: 16,
                      right: 16,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          /// CLASS NAME
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.9),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              classData.className,
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),

                          const SizedBox(height: 6),

                          /// TITLE
                          Text(
                            classData.title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),

                    /// BACK BUTTON
                    Positioned(
                      top: 40,
                      left: 10,
                      child: CircleAvatar(
                        backgroundColor: Colors.black45,
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back,
                              color: Colors.white),
                          onPressed: () => Get.back(),
                        ),
                      ),
                    ),
                  ],
                ),

                /// 🔥 MAIN CARD (OVERLAP EFFECT)
                Transform.translate(
                  offset: const Offset(0, -20),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [



                        /// DESCRIPTION
                        Text(
                          classData.description,
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 13,
                          ),
                        ),

                        const SizedBox(height: 10),

                        /// PRICE
                        Row(
                          children: [
                            Text(
                              "₹${classData.originalPrice}",
                              style: TextStyle(
                                decoration:
                                TextDecoration.lineThrough,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              "₹${classData.finalPrice}",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        /// 🔥 DAYS HEADER
                        Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Start: ${controller.days.first.createdAt}",
                              style: const TextStyle(fontSize: 13),
                            ),
                            Text(
                              "${controller.totalDays} Days",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 10),

                        /// 🔥 DAY LIST (CARD STYLE)
                        ListView.builder(

                          itemCount: controller.days.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            final day = controller.days[index];
                             return InkWell(
                                 onTap: () async {
                                   Utils.showLoading(message: "Question Loading..");

                                   final ok = await questionController.fetchQuestions(
                                     day.id.toString(),
                                     classData.id.toString(),
                                   );
                                  print("Loading Hide");
                                   Utils.hide();

                                   if (!ok) {
                                     Get.snackbar(
                                       "No Questions",
                                       "Questions are not available.",
                                     );
                                     return;
                                   }

                                   Get.toNamed(AppRoutes.quiz);
                                 },

                                 child: DaysListTile(day: day, index: index,));
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
    );
  }
}

