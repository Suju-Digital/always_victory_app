import 'package:get/get.dart';
import '../data/api_helper/api_helper.dart';
import '../data/api_services/api_service.dart';
import '../data/app_config/app_config.dart';
import '../models/about_model.dart';
import '../models/day_model.dart';

class DayController extends GetxController {
  static DayController get instance => Get.find();

  final days = <DayModel>[].obs;
  final Rxn<AboutModel> aboutData = Rxn<AboutModel>();

  @override
  void onInit(){
    super.onInit();
    loadAbout();
  }

  Future<void> getDays({
    required int classId,
  }) async {
    try {


      final response = await ApiHelper.get(
        '${AppConfig.getDays}?class_id=$classId',
      );

      final data = (response['data'] as List)
          .map((e) => DayModel.fromJson(e))
          .toList();

      days.assignAll(data);
    } catch (e) {
      print("Get Days Error: $e");
    }
  }

  int get totalDays => days.length;


  Future<void> loadAbout()async{
    print("Load.. about");
    aboutData.value =  await ApiServices.getAbout();

  }
}