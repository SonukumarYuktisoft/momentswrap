import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:Xkart/view/onboarding_screens/controller/onbroding_controller.dart';
import 'package:Xkart/util/common/coustom_curve.dart';
import 'package:Xkart/util/constants/app_images_string.dart';
import 'package:Xkart/util/constants/app_sizes.dart';
import 'package:Xkart/util/constants/app_text_strings.dart';
import 'package:Xkart/util/device/device_helper.dart';
import 'package:Xkart/util/helpers/helper_functions.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreens extends StatelessWidget {
  const OnboardingScreens({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OnboardingController());
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // PageView for onboarding screens
          PageView(
            controller: controller.pageController,
            onPageChanged: controller.onPageChanged,
            children: [
              OnBoardingPage(
                image: AppImagesString.loginImage,
                title: AppTextStrings.onboardingTitle1,
                subtitle: AppTextStrings.onboardingSubtitle1,
              ),

              OnBoardingPage(
                image: AppImagesString.loginImage,
                title: AppTextStrings.onboardingTitle2,
                subtitle: AppTextStrings.onboardingSubtitle2,
              ),
              OnBoardingPage(
                image: AppImagesString.loginImage,
                title: AppTextStrings.onboardingTitle3,
                subtitle: AppTextStrings.onboardingSubtitle3,
              ),
            ],
          ),

          // Skip button
          OnBoardingSkip(),

          // Dot navigator indicator
          OnBoardingIndicator(),

          // Circular Button
          Positioned(
            bottom: DeviceHelper.getBottomNavigationBarHeight() + 25,
            right: AppSizes.defaultSpacing,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                shape: CircleBorder(),
              ),
              onPressed: () {
                controller.nextPage();
              },
              child: Icon(Icons.arrow_forward_ios, size: AppSizes.iconSizeMd),
            ),
          ),
        ],
      ),
    );
  }
}

class OnBoardingIndicator extends StatelessWidget {
  final controller = OnboardingController.instance;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: DeviceHelper.getBottomNavigationBarHeight() + 25,
      left: AppSizes.defaultSpacing,

      child: SmoothPageIndicator(
        controller: controller.pageController,
        count: 3,
        onDotClicked: controller.jumpToPage,
        effect: WormEffect(
          dotHeight: 10,
          dotWidth: 10,
          activeDotColor: Colors.white,
          dotColor: Colors.grey,
        ),
      ),
    );
  }
}

class OnBoardingSkip extends StatelessWidget {
  OnBoardingSkip({super.key});
  final controller = OnboardingController.instance;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: AppSizes.defaultSpacing,
      right: AppSizes.defaultSpacing,
      child: TextButton(
        // style: TextButton.styleFrom(
        //   padding: const EdgeInsets.symmetric(
        //     horizontal: AppSizes.spaceBtwItems * 2,
        //     vertical: AppSizes.spaceBtwItems,
        //   ),
        //   shape: RoundedRectangleBorder(
        //     borderRadius: BorderRadius.circular(30),
        //   ),
        // ),
        onPressed: () => controller.skipOnboarding(),
        child: Text('Skip', style: Theme.of(context).textTheme.labelMedium),
      ),
    );
  }
}

class OnBoardingPage extends StatelessWidget {
  final String image;
  final String title;
  final String subtitle;

  const OnBoardingPage({
    super.key,
    required this.image,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE60023),

      body: Column(
        children: [
          ClipPath(
            clipper: CustomCurve(),
            child: Container(
              color: Colors.white,
              width: double.infinity,
              height: HelperFunctions.screenHeight() * 0.4,
              child: Image.asset(
                image,
                width: HelperFunctions.screenWidth() * 0.8,
                height: HelperFunctions.screenHeight() * 0.6,
              ),
            ),
          ),

          const SizedBox(height: AppSizes.spaceBtwItems),

          Text(
            title,
            // style: Theme.of(context).textTheme.headlineMedium,
            style: TextStyle(
              fontSize: 25,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),

            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSizes.spaceBtwItems),

          Text(
            subtitle,
            // style: Theme.of(context).textTheme.bodyMedium,
            style: TextStyle(
              fontSize: 17,
              color: Colors.white,
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
