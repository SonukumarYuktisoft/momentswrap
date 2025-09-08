import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:momentswrap/routes/app_routes.dart';

class OnboardingController extends GetxController {
  static OnboardingController get instance => Get.find();
  // variable
  PageController pageController = PageController();
  RxInt currentPage = 0.obs;

  //Update Current page index when page changes
  void onPageChanged(int index) {
    currentPage.value = index;
  }

  // jump to specific page // Dot navigation indicator
  void jumpToPage(index) {
    currentPage.value = index;
    pageController.jumpToPage(index);
  }

  // next
  void nextPage() {
    if (currentPage.value == 2) {
      Get.offAllNamed(AppRoutes.loginScreen);
    } else {
      int nextPage = currentPage.value + 1;
      pageController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  //skip onboarding
  void skipOnboarding() {
    currentPage.value = 2;
    pageController.jumpToPage(2);
  }
}
