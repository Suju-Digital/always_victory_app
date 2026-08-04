import 'package:always_victory/helpers/debug_loger.dart';
import 'package:always_victory/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:palette_generator_master/palette_generator_master.dart';
import '../data/api_services/api_service.dart';
import '../helpers/local_storage.dart';
import '../models/onboard_model.dart';
import 'package:get/get.dart';

class OnboardingController extends GetxController {

  static OnboardingController get instance => Get.find();

  final PageController pageController = PageController();

  RxList<OnboardModel> pages = <OnboardModel>[].obs;



  var currentPage = 0.obs;

  @override
  void onInit() {
    super.onInit();
    getOnBoardData();
    loadColors();
  }

  bool get isLast => currentPage.value == pages.length - 1;

  void getOnBoardData() async{
    print("on Board data Loading........");
    List<OnboardModel> onboards = await ApiServices.getOnboards();
    onboards.forEach((element) {
      AppLog.response(element.toJson());
    },);

    pages.value = onboards;
  }

  void onPageChanged(int index) {
    currentPage.value = index;
  }

  void next() {
    if (isLast) {
      finishOnboarding();
    } else {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void skip() {
    pageController.animateToPage(
      pages.length - 1,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }





  Future<Color> getDominantColor(String imageUrl) async {
    final PaletteGeneratorMaster paletteGenerator =
    await PaletteGeneratorMaster.fromImageProvider(
      NetworkImage(ApiServices.getImageUrl(imageUrl)),
    );

    return paletteGenerator.dominantColor?.color ?? Colors.blue;
  }


  final RxMap<int, Color> pageColors = <int, Color>{}.obs;


  Future<void> loadColors() async {
    print("on Board Color Loading........");

    for (int i = 0; i < pages.length; i++) {
      pageColors[i] = await getDominantColor(pages[i].image ?? "");
    }
  }

  Future<void> finishOnboarding() async {
    await LocalStorage.setOnboardingDone(true);
    Get.offAllNamed(AppRoutes.login);
  }




  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}