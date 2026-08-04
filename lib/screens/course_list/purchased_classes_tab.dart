import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/app_colors.dart';
import '../../controller/class_controller.dart';
import '../../controller/days_controller.dart';
import '../../helpers/utils.dart';
import '../../routes/app_routes.dart';
import '../../data/app_config/app_config.dart';

class PurchasedClassesTab extends StatefulWidget {
  PurchasedClassesTab({super.key});

  @override
  State<PurchasedClassesTab> createState() => _PurchasedClassesTabState();
}

class _PurchasedClassesTabState extends State<PurchasedClassesTab> {
  final ClassController classController = Get.find<ClassController>();

 @override
  void initState() {
    super.initState();
    // inIt();
  }

  void inIt()async{
    await ClassController.instance.loadClass();
    await ClassController.instance.getAllClassesProgress();
  }


  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final purchasedClasses = classController.classes
          .where(
            (e) => classController.purchaseClass[e.id] == true,
      )
          .toList();


      if (purchasedClasses.isEmpty) {
        return RefreshIndicator(
          onRefresh: () async {
            await ClassController.instance.loadClass();
            await ClassController.instance.getAllClassesProgress();
          },
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.7,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.school_outlined,
                        size: 90,
                        color: Colors.grey.shade400,
                      ),
                      const SizedBox(height: 15),
                      const Text(
                        "No Purchased Classes",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        "Pull down to refresh",
                        style: TextStyle(
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }

      return RefreshIndicator(
        onRefresh:  ()async {
          await ClassController.instance.loadClass();
          await ClassController.instance.getAllClassesProgress();
        } ,
        child: ListView.builder(
          padding: const EdgeInsets.all(15),
          itemCount: purchasedClasses.length,
          itemBuilder: (context, index) {
            final c = purchasedClasses[index];

            final totalStudents =
                classController.enrollmentCounts[c.id] ?? 0;





            final progressModel = classController.questionProgress.firstWhereOrNull(
                  (e) => e.classId == c.id,
            );

            final progress =
            (progressModel?.percentage ?? 0).toDouble();

            return Card(
              margin:
              const EdgeInsets.only(bottom: 15),
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius:
                BorderRadius.circular(16),
              ),
              child: InkWell(
                borderRadius:
                BorderRadius.circular(16),
                onTap: () async {
                  Utils.showLoading(
                    message: "Loading Days...",
                  );

                  await DayController.instance.getDays(
                    classId: c.id,
                  );

                  Utils.hide();
                  Get.toNamed(
                    AppRoutes.days,
                    arguments: c,
                  );
                },
                child: Padding(
                  padding:
                  const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius:
                        BorderRadius.circular(
                          12,
                        ),
                        child: Image.network(
                          "${AppConfig.studentImageBaseUrl}${c.posterImage}",
                          width: 90,
                          height: 90,
                          fit: BoxFit.cover,
                          errorBuilder:
                              (_, __, ___) =>
                              Container(
                                width: 90,
                                height: 90,
                                color: Colors.grey
                                    .shade200,
                                child: const Icon(
                                  Icons.image,
                                ),
                              ),
                        ),
                      ),

                      const SizedBox(width: 15),

                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment
                              .start,
                          children: [
                            Text(
                              c.title,
                              maxLines: 2,
                              overflow:
                              TextOverflow
                                  .ellipsis,
                              style:
                              const TextStyle(
                                fontWeight:
                                FontWeight
                                    .bold,
                                fontSize: 16,
                              ),
                            ),

                            const SizedBox(
                              height: 6,
                            ),

                            Text(
                              "Class ${c.className}",
                              style: TextStyle(
                                color: Colors
                                    .grey
                                    .shade600,
                              ),
                            ),

                            const SizedBox(
                              height: 4,
                            ),

                            Text(
                              "$totalStudents Students",
                              style: TextStyle(
                                color: Colors
                                    .grey
                                    .shade500,
                                fontSize: 12,
                              ),
                            ),

                            const SizedBox(
                              height: 10,
                            ),

                            ClipRRect(
                              borderRadius:
                              BorderRadius
                                  .circular(
                                20,
                              ),
                              child:
                              LinearProgressIndicator(
                                value:
                                progress /
                                    100,
                                minHeight: 7,
                                backgroundColor: AppColors.border,
                                valueColor: const AlwaysStoppedAnimation(AppColors.primary),
                              ),
                            ),

                            const SizedBox(
                              height: 5,
                            ),

                            Text(
                              "${progress.toStringAsFixed(0)}% Completed",
                              style:
                              const TextStyle(
                                fontSize: 12,
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const Icon(
                        Icons.arrow_forward_ios,
                        size: 18,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      );
    });
  }
}